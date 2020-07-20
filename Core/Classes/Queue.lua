--- Queue.lua Simple implementation of a (FIFO) queue around a list.
-- Use by calling the implemented methods: `Push`, `Pop` and `Size`.
local _, addon = ...
local List = {}
local Queue = {}
addon.Queue = Queue

-----------------------------------------------------------
-- Queue
-----------------------------------------------------------
local queue_mt = {
   __index = {
      --- Pushes a new value to the queue.
      Push = function (self, value)
         List.pushright(self.List, value)
      end,
      --- Returns and removes the first added value  to the queue.
      Pop = function (self)
         return List.popleft(self.List)
      end,
      --- Reinserts a value to the front of the queue.
      UndoPop = function (self, value)
         return List.pushleft(self.List, value)
      end,
      --- Returns the number of elements currently in the queue.
      Size = function (self)
         return self.List.size
      end
   }
}

--- Returns a new Queue.
function Queue:New ()
   local list = List:new()
   return setmetatable({List = list}, queue_mt)
end

-----------------------------------------------------------
-- General List object
-----------------------------------------------------------
function List.new ()
   return {first = 0, last = -1, size = 0}
end

function List.pushleft (list, value)
   local first = list.first - 1
   list.first = first
   list.size = list.size + 1
   list[first] = value
end

function List.pushright (list, value)
   local last = list.last + 1
   list.last = last
   list.size = list.size + 1
   list[last] = value
end

function List.popleft (list)
   local first = list.first
   if first > list.last then error("list is empty", 2) end
   local value = list[first]
   list[first] = nil
   list.first = first + 1
   list.size = list.size - 1
   return value
end

function List.popleft (list)
   local last = list.last
   if list.first > last then error("list is empty", 2) end
   local value = list[last]
   list[last] = nil
   list.last = last - 1
   list.size = list.size - 1
   return value
end
