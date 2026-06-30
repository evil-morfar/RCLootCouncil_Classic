--- SessionAudit.lua
-- Displays a per-item audit of all loot session responses, grouped by date.
-- Data is written by the MLUpdates TrackAndLogLoot wrapper and stored in RCLootCouncilSessionDB.
--- @type RCLootCouncil
local addon = select(2, ...)
---@class RCSessionAudit : AceModule
local SessionAudit = addon:NewModule("RCSessionAudit")
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")
local L  = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
---@type RCLootCouncil_Classic
local Classic = addon:GetModule("RCClassic")
local AceSerializer = LibStub("AceSerializer-3.0")

local ROW_HEIGHT    = 20
local DATE_ROWS     = 18   -- tall enough to span both item + response lists
local ITEM_ROWS     = 8
local RESPONSE_ROWS = 8

-- Module-local state
local sessionDB, selectedDate, selectedEntry

-- Column widths for item list
local ITEM_COLS = {
	{name = "",                             width = ROW_HEIGHT},  -- item icon
	{name = L["Item"],                      width = 190, defaultsort = 1},
	{name = LC["session_audit_boss"],       width = 110, defaultsort = 1},
	{name = LC["session_audit_winner"],     width = 90,  defaultsort = 1},
	{name = LC["session_audit_responses"],  width = 80,  defaultsort = 2},
}

-- Column widths for response list
local RESPONSE_COLS = {
	{name = "",          width = ROW_HEIGHT},  -- class icon
	{name = "",          width = ROW_HEIGHT},  -- awarded indicator
	{name = _G.NAME,     width = 110, sort = 1, defaultsort = 1},
	{name = L["Reason"], width = 130, defaultsort = 1},
	{name = L["Notes"],  width = 40},
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

	-- Frame: width driven by column totals, height to fit both tables + control strip
	local f = addon.UI:NewNamed("RCFrame", UIParent, "RCSessionAuditFrame",
		LC["Session Audit"], 300, 500)
	addon.UI:RegisterForEscapeClose(f, function()
		if self:IsEnabled() then self:Disable() end
	end)

	-- Close button in the control strip below the title bar
	local closeBtn = addon:CreateButton(_G.CLOSE, f.content)
	closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -28)
	closeBtn:SetScript("OnClick", function() self:Disable() end)

	-- Export: serializes the full session db so it can be shared/pasted to another council member
	local exportBtn = addon:CreateButton(L["Export"], f.content)
	exportBtn:SetPoint("RIGHT", closeBtn, "LEFT", -10, 0)
	exportBtn:SetScript("OnClick", function() self:ExportData() end)

	-- Import: accepts a string produced by Export and merges it in, deduplicated by entry id
	local importBtn = addon:CreateButton("Import", f.content)
	importBtn:SetPoint("RIGHT", exportBtn, "LEFT", -10, 0)
	importBtn:SetScript("OnClick", function() self:ImportData() end)

	-- Date sidebar: starts well below the control strip (button ~22px tall + 20px gap = y-70)
	f.dateList = LibStub("ScrollingTable"):CreateST(
		{{name = L["Date"], width = 90, sort = 2, defaultsort = 2}},
		DATE_ROWS, ROW_HEIGHT, HIGHLIGHT, f.content
	)
	f.dateList.frame:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -70)
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
	f.responseList.frame:SetPoint("TOPLEFT", f.itemList.frame, "BOTTOMLEFT", 0, -20)

	-- Resize frame to fit date sidebar + item list + margins
	f:SetWidth(f.dateList.frame:GetWidth() + f.itemList.frame:GetWidth() + 30)

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
		local winner = addon.Ambiguate(selectedEntry.winner or "")
		for name, resp in pairs(selectedEntry.responses) do
			local hasNote = resp.note and resp.note ~= ""
			local isWinner = addon.Ambiguate(name) == winner
			tinsert(rows, {
				cols = {
					{DoCellUpdate = addon.SetCellClassIcon, args = {resp.class}, value = resp.class or ""},
					{DoCellUpdate = SessionAudit.SetCellWinner, args = {isWinner = isWinner}, value = isWinner and 1 or 0},
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
		-- Sort: winner first (col 2 is the awarded indicator), then by votes descending (col 8)
		table.sort(rows, function(a, b)
			local aw, bw = a.cols[2].value, b.cols[2].value
			if aw ~= bw then return aw > bw end
			return (a.cols[8].value or 0) > (b.cols[8].value or 0)
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

function SessionAudit.SetCellWinner(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...) --luacheck: no unused
	local isWinner = data[realrow].cols[column].args.isWinner
	local f = frame.winnerIcon or CreateFrame("Frame", nil, frame)
	f:SetSize(ROW_HEIGHT - 4, ROW_HEIGHT - 4)
	f:SetPoint("CENTER", frame, "CENTER")
	frame.winnerIcon = f
	if not f.tex then
		f.tex = f:CreateTexture(nil, "OVERLAY")
		f.tex:SetAllPoints(f)
		f.tex:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
	end
	f.tex:SetShown(isWinner)
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

------------------------------------------------------------
-- Export / Import
------------------------------------------------------------

function SessionAudit:ExportData()
	if not (sessionDB and next(sessionDB)) then
		addon:Print(LC["session_audit_no_data"])
		return
	end
	local export = AceSerializer:Serialize(sessionDB)
	local exportFrame = addon.UI:New("RCExportFrame")
	exportFrame:Show()
	exportFrame.edit:SetCallback("OnTextChanged", function(editbox) editbox:SetText(export) end)
	exportFrame.edit:SetText(export)
	exportFrame.edit:SetFocus()
	exportFrame.edit:HighlightText()
end

function SessionAudit:ImportData()
	local importFrame = addon.UI:New("RCImportFrame")
	importFrame.label:SetText(LC["Session Audit"])
	importFrame.edit:SetCallback("OnEnterPressed", function(editbox)
		local ok, data = AceSerializer:Deserialize(editbox.data)
		if not ok or type(data) ~= "table" then
			addon:Print(L["import_malformed"])
			importFrame:Hide()
			return
		end
		local merged = Classic:MergeSessionData(data)
		addon:Print(format("%d %s", merged, LC["Session Audit"]))
		sessionDB = addon.sessionDB and addon.sessionDB.factionrealm
		self:BuildDateList()
		importFrame:Hide()
	end)
	importFrame:Show()
	importFrame.edit:SetFocus()
end
