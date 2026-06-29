--- SessionAudit.lua
-- Displays a per-item audit of all loot session responses, grouped by date.
-- Data is written by the MLUpdates TrackAndLogLoot wrapper and stored in RCLootCouncilSessionDB.
--- @type RCLootCouncil
local addon = select(2, ...)
---@class RCSessionAudit : AceModule
local SessionAudit = addon:NewModule("RCSessionAudit")
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")
local L  = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")

local ROW_HEIGHT    = 20
local DATE_ROWS     = 10
local ITEM_ROWS     = 8
local RESPONSE_ROWS = 8

-- Module-local state
local sessionDB, selectedDate, selectedEntry

-- Column widths for item list
local ITEM_COLS = {
	{name = "",                 width = ROW_HEIGHT},          -- item icon
	{name = L["Item"],          width = 190, defaultsort = 1},
	{name = L["Boss"],          width = 110, defaultsort = 1},
	{name = LC["session_audit_winner"], width = 90, defaultsort = 1},
	{name = LC["session_audit_responses"], width = 35, defaultsort = 2},
}

-- Column widths for response list
local RESPONSE_COLS = {
	{name = "",          width = ROW_HEIGHT},
	{name = _G.NAME,     width = 110, sort = 1, defaultsort = 1},
	{name = L["Reason"], width = 130, defaultsort = 1},
	{name = L["Notes"],  width = ROW_HEIGHT},
	{name = "iLvl",      width = 40,  defaultsort = 2},
	{name = LC["session_audit_roll"], width = 35, defaultsort = 2},
	{name = L["Votes"],  width = 35,  defaultsort = 2},
}

local HIGHLIGHT = {r = 1.0, g = 0.9, b = 0.0, a = 0.5}

------------------------------------------------------------
-- Lifecycle
------------------------------------------------------------

function SessionAudit:OnEnable()
	sessionDB    = addon.sessionDB and addon.sessionDB.factionrealm
	selectedDate  = nil
	selectedEntry = nil
	self.frame   = self:GetFrame()
	self:BuildDateList()
	self:BuildItemList()
	self:BuildResponseList()
	self.frame:Show()
end

function SessionAudit:OnDisable()
	if self.frame then self.frame:Hide() end
end

------------------------------------------------------------
-- Frame construction
------------------------------------------------------------

function SessionAudit:GetFrame()
	if self.frame then return self.frame end

	-- Overall frame: wide enough for date sidebar + item list
	local f = addon.UI:NewNamed("RCFrame", UIParent, "RCSessionAuditFrame",
		LC["Session Audit"], 300, 500)
	addon.UI:RegisterForEscapeClose(f, function()
		if self:IsEnabled() then self:Disable() end
	end)

	-- Close button
	local closeBtn = addon:CreateButton(_G.CLOSE, f.content)
	closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -110)
	closeBtn:SetScript("OnClick", function() self:Disable() end)

	-- Date sidebar
	f.dateList = LibStub("ScrollingTable"):CreateST(
		{{name = L["Date"], width = 90, sort = 2, defaultsort = 2}},
		DATE_ROWS, ROW_HEIGHT, HIGHLIGHT, f.content
	)
	f.dateList.frame:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -30)
	f.dateList:EnableSelection(true)
	f.dateList:RegisterEvents({
		["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, table, button) --luacheck: no unused
			if button == "LeftButton" and row then
				local d = data[realrow][1]
				selectedDate  = (selectedDate ~= d) and d or nil
				selectedEntry = nil
				self:BuildItemList()
				self:BuildResponseList()
			end
			return false
		end
	})

	-- Item list (anchored to the right of the date sidebar)
	f.itemList = LibStub("ScrollingTable"):CreateST(
		ITEM_COLS, ITEM_ROWS, ROW_HEIGHT, HIGHLIGHT, f.content
	)
	f.itemList.frame:SetPoint("TOPLEFT", f.dateList.frame, "TOPRIGHT", 10, 0)
	f.itemList:EnableSelection(true)
	f.itemList:RegisterEvents({
		["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, table, button) --luacheck: no unused
			if button == "LeftButton" and row then
				selectedEntry = data[realrow].entry
				self:BuildResponseList()
			end
			return false
		end
	})

	-- Response table (below item list)
	f.responseList = LibStub("ScrollingTable"):CreateST(
		RESPONSE_COLS, RESPONSE_ROWS, ROW_HEIGHT, HIGHLIGHT, f.content
	)
	f.responseList.frame:SetPoint("TOPLEFT", f.itemList.frame, "BOTTOMLEFT", 0, -10)

	self.frame = f
	return f
end

------------------------------------------------------------
-- Data builders
------------------------------------------------------------

function SessionAudit:BuildDateList()
	if not self.frame then return end
	local rows = {}
	if sessionDB then
		for d in pairs(sessionDB) do
			tinsert(rows, {d})
		end
		table.sort(rows, function(a, b) return a[1] > b[1] end)
	end
	self.frame.dateList:SetData(rows, true)
end

function SessionAudit:BuildItemList()
	if not self.frame then return end
	local rows = {}
	if selectedDate and sessionDB and sessionDB[selectedDate] then
		for _, entry in ipairs(sessionDB[selectedDate]) do
			local count = 0
			for _ in pairs(entry.responses or {}) do count = count + 1 end
			tinsert(rows, {
				entry = entry,
				cols  = {
					{DoCellUpdate = SessionAudit.SetCellItemIcon, args = {entry.item}},
					{value = entry.item or ""},
					{value = entry.boss or ""},
					{value = addon.Ambiguate(entry.winner or "")},
					{value = count},
				},
			})
		end
	end
	if #rows == 0 and not selectedDate then
		-- No date selected yet; leave list empty with no noise.
	end
	self.frame.itemList:SetData(rows)
	self.frame.itemList:SortData()
end

function SessionAudit:BuildResponseList()
	if not self.frame then return end
	local rows = {}
	if selectedEntry and selectedEntry.responses then
		for name, resp in pairs(selectedEntry.responses) do
			local hasNote = resp.note and resp.note ~= ""
			tinsert(rows, {
				cols = {
					{DoCellUpdate = addon.SetCellClassIcon, args = {resp.class}, value = resp.class or ""},
					{value = addon.Ambiguate(name), color = addon:GetClassColor(resp.class)},
					{DoCellUpdate = SessionAudit.SetCellResponse,
					 args = {text = resp.response, color = resp.responseColor},
					 value = resp.response or ""},
					{DoCellUpdate = SessionAudit.SetCellNote,
					 args = {note = resp.note},
					 value = hasNote and 1 or 0},
					{value = resp.ilvl or ""},
					{value = resp.roll or ""},
					{value = resp.votes or 0},
				},
			})
		end
		-- Sort: winner first, then by votes descending
		local winner = selectedEntry.winner
		table.sort(rows, function(a, b)
			local an = a.cols[2].value
			local bn = b.cols[2].value
			if an == addon.Ambiguate(winner or "") then return true end
			if bn == addon.Ambiguate(winner or "") then return false end
			return (a.cols[7].value or 0) > (b.cols[7].value or 0)
		end)
	end
	self.frame.responseList:SetData(rows)
	self.frame.responseList:SortData()
end

------------------------------------------------------------
-- Cell renderers
------------------------------------------------------------

function SessionAudit.SetCellItemIcon(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...) --luacheck: no unused
	local item = data[realrow].cols[column].args[1]
	local f = frame.iconBtn or CreateFrame("Button", nil, frame)
	f:SetSize(ROW_HEIGHT - 2, ROW_HEIGHT - 2)
	f:SetPoint("CENTER", frame, "CENTER")
	frame.iconBtn = f
	if item then
		local texture = select(5, C_Item.GetItemInfoInstant(item))
		f:SetNormalTexture(texture or "Interface/ICONS/INV_Misc_QuestionMark")
		f:SetScript("OnEnter", function() addon:CreateHypertip(item) end)
		f:SetScript("OnLeave", function() addon:HideTooltip() end)
		f:Show()
	else
		f:Hide()
	end
end

function SessionAudit.SetCellResponse(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...) --luacheck: no unused
	local args = data[realrow].cols[column].args
	frame.text:SetText(args.text or "")
	local c = args.color
	if c and type(c) == "table" and c[1] then
		frame.text:SetTextColor(c[1], c[2], c[3], c[4] or 1)
	else
		frame.text:SetTextColor(1, 1, 1, 1)
	end
end

function SessionAudit.SetCellNote(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...) --luacheck: no unused
	local note = data[realrow].cols[column].args.note
	local f = frame.noteBtn or CreateFrame("Button", nil, frame)
	f:SetSize(ROW_HEIGHT, ROW_HEIGHT)
	f:SetPoint("CENTER", frame, "CENTER")
	frame.noteBtn = f
	if note and note ~= "" then
		f:SetNormalTexture("Interface/BUTTONS/UI-GuildButton-PublicNote-Up.png")
		f:SetScript("OnEnter", function() addon:CreateTooltip(_G.LABEL_NOTE, note) end)
		f:SetScript("OnLeave", function() addon:HideTooltip() end)
	else
		f:SetNormalTexture("Interface/BUTTONS/UI-GuildButton-PublicNote-Disabled.png")
		f:SetScript("OnEnter", nil)
		f:SetScript("OnLeave", nil)
	end
	f:Show()
end
