--- Testing Queued Comms.

local _, addon = ...
local Object = addon:NewModule("QC", "AceTimer-3.0", "AceConsole-3.0")
local CommsTimer = nil

local MAX_CPS = 10 -- "Comms per second"
local TIMER_DELAY = 1
local current_cps = 0
local debug = false
local Queue


function Object:OnInitialize (args)
   self:Enable()
end
function Object:OnEnable (args)
    Queue = addon.Queue:New()
    addon:ModuleChatCmd(Object, "ChatCommand", nil, "Queued comms debug", "comms")
end

-- Trap original :SendCommand
local orig_SendCommand = addon.SendCommand
-------------------------------------------------------
-- Register some chat commands for debugging
-------------------------------------------------------

function Object:ChatCommand (cmd)
   if cmd == "reset" then
      addon.SendCommand = orig_SendCommand
      self:Print("Comms reset")

   elseif cmd == "start" then
      addon.SendCommand = Object.SendCommand
      self:Print("Comms overwritten")

   elseif cmd == "log" or cmd == "debug" then
      debug = not debug
      self:Print("Debug = "..tostring(debug))

   else
      self:Print("Missing command...\nAvailable:\nreset\nstart")
   end
end

-------------------------------------------------------
-- Comms handling
-------------------------------------------------------
function Object:TimerPulse ()
   -- Reduce CPS
   current_cps = math.max(addon.round(current_cps - MAX_CPS * TIMER_DELAY, 1), 0)
   local size = Queue:Size()
   if size == 0 and current_cps <= 0.1 then
      self:Log("Queue and CPS is 0")
      -- Cancel the timer
      self:CancelTimer(CommsTimer)
      CommsTimer = nil
      return
   end
   self:Log("New CPS:", current_cps)
   while Queue:Size() > 0 do
      local Comm = Queue:Pop()
      -- Can we fit this comm within the current cps?
      if Comm[1] + current_cps <= MAX_CPS then -- yes
         current_cps = current_cps + Comm[1]
         orig_SendCommand(addon, Comm[2], Comm[3], unpack(Comm[4]))
      else -- no
         Queue:UndoPop(Comm)
         break
      end
   end
   self:Log(format("Sent %d messages - new CPS is %d - Queue:Size(): %d", size - Queue:Size(), current_cps, Queue:Size()))
end

-- `self` will point to `addon`
function Object:SendCommand (target, command, ...)
   local toSend = self:Serialize(command, {...})
   local messages = math.ceil(#toSend / 255)
   if messages > MAX_CPS then
      -- A single message exceeds our max CPS.
      -- Will happen in retail, but shouldn't happend in classic with normal comms.
      -- It needs to get sent, so just lower it's size
      Object:Log(format("|cffff0000<WARNING>|r Message size %d being sent.", messages))
      messages = MAX_CPS
   end
   if messages + current_cps > MAX_CPS then
      -- Queue
      Queue:Push({messages,target, command, {...}})
      Object:Log(format("Throttled %s! Current CPS: %d, delayed: %d messages.", command,current_cps, messages))
      -- Check timer
      if not CommsTimer then
         Object:InitTimer()
      end
      return
   else
      current_cps = current_cps + messages
      return orig_SendCommand(addon, target, command, ...)
   end
end

addon.SendCommand = Object.SendCommand

function Object:InitTimer()
   CommsTimer = self:ScheduleRepeatingTimer("TimerPulse", TIMER_DELAY)
end

function Object:Log (...)
   if debug then
      self:Print(...)
   end
   addon:DebugLog(...)
end
