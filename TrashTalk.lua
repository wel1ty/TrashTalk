--[[
Addon created by Steven Ventura aka gangsthurh aka gnome aka noob aka gnome child aka steven steven aka 
All rights reserved
kek
work started on 11/14/15
The purpose of this addon is to enable easy private-messaging to players you are either 
	1) currently fighting in arena
	2) just finished fighting in arena
Because aint nobody got time to look up all the alt codes for the names of the players they fought
--]]
--[[
2/22/2018
save the messages people send me

class TrashTalkMessage	
	(int index)
	string sender
	int time
	string content

class TrashTalkSavedWhispers
	string victim (index)
	list<TrashTalkMessage>


]]
function SendTrashTalkMessage(a, b, c, d)
	--SendTrashTalkMessage(TrashTalkOptions["KickedText"],"WHISPER",nil,destName);
	SendChatMessage(a, b, c, d)
end
function AddTrashTalkVictim(victim)
	if (TrashTalkSavedWhispers[victim] == nil) then
		print("adding victim " .. victim);
		TrashTalkSavedWhispers[victim] = {}
		TrashTalkSavedWhispers[victim]["messages"] = {}
	end
end

function lengthffs(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function AddTrashTalkMessage(victim, sender, content)
	if (authorIsTrashTalkVictim(victim)) then
		print("saving message from " .. sender)
		local messages = TrashTalkSavedWhispers[victim]["messages"]
		local lenx = lengthffs(messages)
		messages[(lenx + 1)] = {}
		messages[(lenx + 1)]["fromHim"] = (sender == victim)
		messages[(lenx + 1)]["time"] = time()
		messages[(lenx + 1)]["content"] = content
	end
end
--end function SendTrashTalkMessage
function authorIsTrashTalkVictim(author)
	--search through saved whispers
	for a, b in pairs(TrashTalkSavedWhispers) do
		if (a == author) then
			return true
		end
	end
	--end for
	return false
end
--end function authorIsTrashTalkVictim
function TrashTalkIncoming(ChatFrameSelf, event, content, author, ...)
	AddTrashTalkMessage(author, author, content)
end
--end function TrashTalkIncoming
local screenWidth
local screenHeight

local tHitMarker = 0
hitMarkerEnabled = false
hitMarkerImage = nil
local clicked1 = false
clicked2 = false
clicked3 = false -- for 'oh baby a triple'
local tOhBabyATriple = 0
local tIntervention = 0
interventionEnabled = false
interventionImage = nil
interventionImageObj = nil
local tSnoopDogg = 0
snoopDoggImage = nil
snoopDoggImageObj = nil
snoopDoggEnabled = false

local buttonHeight = 22
local buttonWidth = 108
local snoopWidth = buttonWidth
local snoopHeight = buttonHeight * 3
local DDSelection = 1 -- A user-configurable setting

local currentPreset
local defaultPreset1 = "bad"
local defaultPreset2 =
	"Hi!! :o) ! <33 My name is Roxy, I'm a krazy loud girl who's pretty terrible at games but pretty good at art and smoking weed, come L o L @ me ;~) I'm trying to survive as a student and artist so ALL donations help me a lot! THANK U <3!"
local defaultPreset3 =
	"What the fuck did you just fucking say about me you little shit? I’ll have you know I gradually reach to the top guild on my server and in this game, been involved in numerous world first raids, and I have over 200 confirmed world first boss kills. I have played every class in the game and I’m the top dps, tank and healer in the guild."
local function fixPresets()
	if (not (TrashTalkPresets) or not (TrashTalkPresets[1])) then
		TrashTalkPresets = {
			[1] = defaultPreset1,
			[2] = defaultPreset2,
			[3] = defaultPreset3
		}
		print("|cff666666(default trashtalkpresets was loaded)")
	end
	currentPreset = TrashTalkPresets[DDSelection]
end
--end function fixPresets

local function OnEvent(self, event, ...)
	local dispatch = self[event]

	if dispatch then
		dispatch(self, ...)
	end
end

function tdump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

local TrashTalk = CreateFrame("Frame")
TrashTalk:SetScript("OnEvent", OnEvent)
TrashTalk:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TrashTalk:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local backgroundFrame = CreateFrame("Frame", "backgroundFrame", UIParent)
local TrashTalk_eventFrame = CreateFrame("Frame")
TrashTalk_eventFrame:RegisterEvent("VARIABLES_LOADED")

TrashTalk_eventFrame:SetScript(
	"OnEvent",
	function(self, event, ...)
		self[event](self, event, ...)
	end
)
TrashTalk_eventFrame:SetScript(
	"OnUpdate",
	function(self, elapsed)
		TrashTalk_OnUpdate(self, elapsed)
	end
)
function TrashTalkOutgoing(a, b, message, name, ...)
	AddTrashTalkMessage(name, UnitName("player"), message);
end
function TrashTalk_eventFrame:VARIABLES_LOADED()
	print("clearing trashtalksavedwhispers");
	TrashTalkSavedWhispers = nil;
	if (TrashTalkSavedWhispers == nil) then
		TrashTalkSavedWhispers = {}
	end

	AddTrashTalkVictim("Wellsfargo-Gorefiend")
	AddTrashTalkVictim(UnitName("player"));
	for i=1,2 do
		AddTrashTalkMessage("Wellsfargo-Gorefiend", "Wellsfargo-Gorefiend", "test message " .. i);
		AddTrashTalkMessage("Wellsfargo-Gorefiend", UnitName("player"), "test message " .. i);
	end
	AddTrashTalkVictim("Rskkarmatko-Tichondrius")
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", TrashTalkIncoming)
	--hooksecurefunc("ChatEdit_ParseText", TrashTalkOutgoing)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", TrashTalkOutgoing)

	fixPresets() --init variables if they arent yet
	------------------------------------------------------------------
	-- Create the dropdown, and configure its appearance
	CreateFrame("FRAME", "TTDD", UIParent, "UIDropDownMenuTemplate")
	TTDD:SetPoint("TOPLEFT", backgroundFrame, "BOTTOMLEFT", -24, 0)
	UIDropDownMenu_SetWidth(TTDD, buttonWidth)
	UIDropDownMenu_SetText(TTDD, TrashTalkPresets[DDSelection])

	-- Create and bind the initialization function to the dropdown menu
	UIDropDownMenu_Initialize(
		TTDD,
		function(self, level, menuList)
			local info = UIDropDownMenu_CreateInfo()
			--display
			local length = getn(TrashTalkPresets)
			for i = 1, length do
				info.text = TrashTalkPresets[i]
				info.checked = (DDSelection == i)
				info.menuList = i
				info.func = TTDD.SetValue
				info.arg1 = i --arg1 is used here as the SetValue argument.
				UIDropDownMenu_AddButton(info)
			end
			--end for
		end
	)

	-- Implement the function
	function TTDD:SetValue(newValue)
		DDSelection = newValue
		UIDropDownMenu_SetText(TTDD, TrashTalkPresets[DDSelection])
	end

	--TTDD:Show();
	------------------------------------------------------------------end dropdown stuff
end
--end variablesLoaded

local ttbuttons = {}
ttbuttons[1] = CreateFrame("Button", nil, backgroundFrame, "UIPanelButtonTemplate")
ttbuttons[2] = CreateFrame("Button", nil, backgroundFrame, "UIPanelButtonTemplate")
ttbuttons[3] = CreateFrame("Button", nil, backgroundFrame, "UIPanelButtonTemplate")

local playerIsInArena = false
local playersFaction = "nil"
local enemyFaction = "nil"
local ttenemies = {}
ttenemies[1] = {}
ttenemies[2] = {}
ttenemies[3] = {}
--sets all enemy values back to default values.
function initializeEnemies()
	--set arena frame size enough for 2 enemies
	backgroundFrame:SetSize(buttonWidth, buttonHeight * 2)

	for i = 1, 3 do
		local selectedEnemy = ttenemies[i]
		selectedEnemy["name"] = "nobody yet"
		selectedEnemy["realm"] = ""
		selectedEnemy["class"] = ""
		selectedEnemy["exists"] = false
	end
	ttbuttons[3]:Hide()
	--default to show 2s, add one if its 3s.
end
--end function initializeEnemies;

-- from PiL2 20.4
function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function TTPopulateTrophies()
	local frame  = CreateFrame("Frame", "GottaMogEmAllOutputFrame", UIParent)
	frame.width  = 500
	frame.height = 250
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetSize(frame.width, frame.height)
	frame:SetPoint("CENTER", UIParent)
	frame:SetBackdrop({
		bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		insets   = { left = 10, right = 10, top = 10, bottom = 10 }
	})
	frame:SetBackdropColor(0, 0, 0, 0.8)
	frame:EnableMouse(true)
	frame:EnableMouseWheel(true)

	-- Make movable 
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
		
	local messageFrame = CreateFrame("ScrollingMessageFrame", nil, frame)
	messageFrame:SetPoint("LEFT", 15, 20)
	messageFrame:SetSize(frame.width, frame.height - 50)
	messageFrame:SetFontObject(GameFontNormal)
	messageFrame:SetTextColor(1, 1, 1, 1)
	messageFrame:SetJustifyH("LEFT")
	messageFrame:SetFading(false)
	messageFrame:SetMaxLines(1000)
	for i,v in pairs(TrashTalkSavedWhispers) do
		--print(i);
		--i is name
		--v is table.
		local messages = v["messages"];
		--[[
			messages[(lenx + 1)]["fromHim"] = (sender == victim)
			messages[(lenx + 1)]["time"] = time()
			messages[(lenx + 1)]["content"] = content
		--]]
		if (messages ~= nil) then
			for i3, v3 in pairs(messages) do
				local author = nil;
				local fromHim  = v3["fromHim"];
				if (fromHim) then
					author = '|cffff0000' .. i;
				else
					author = '|cff0000ff' .. UnitName("player");
				end
				messageFrame:AddMessage('[' .. author .. '|cffffffff]: ' .. v3["content"]);
			end
		end
	end

	local scrollBar = CreateFrame("Slider", nil, frame, "UIPanelScrollBarTemplate")
	scrollBar:SetPoint("RIGHT", frame, "RIGHT", -10, 10)
	scrollBar:SetSize(30, frame.height - 90)
	scrollBar:SetMinMaxValues(0, 99)
	scrollBar:SetValueStep(1)
	scrollBar.scrollStep = 1
	frame.scrollBar = scrollBar

	scrollBar:SetScript("OnValueChanged", function(self, value)
		messageFrame:SetScrollOffset(select(2, scrollBar:GetMinMaxValues()) - value)
	end)
	
	scrollBar:SetValue(select(2, scrollBar:GetMinMaxValues()))
	
	frame:SetScript("OnMouseWheel", function(self, delta)
		--print(messageFrame:GetNumMessages(), messageFrame:GetNumLinesDisplayed())
	
		local cur_val = scrollBar:GetValue()
		local min_val, max_val = scrollBar:GetMinMaxValues()
	
		if delta < 0 and cur_val < max_val then
			cur_val = math.min(max_val, cur_val + 1)
			scrollBar:SetValue(cur_val)
		elseif delta > 0 and cur_val > min_val then
			cur_val = math.max(min_val, cur_val - 1)
			scrollBar:SetValue(cur_val)
		end
	end)
end

local function CreateOptions()
	if (not TrashTalkOptions or TrashTalkOptions["Kicked"] == nil) then
		print("instantiating trashtalkoptions")
		TrashTalkOptions = {
			["Hitmarker"] = true,
			["SendUponSight"] = true,
			["SendUponSightText"] = "lmao i just beat you on my alt ur so bad",
			["Juked"] = true,
			["JukedText"] = "nice kick friend",
			["Kicked"] = true,
			["KickedText"] = "LOL GET KICKED NERD HAHAHA LEARN TO JUKE"
		}
	end
	--end init trashtalkoptions
	TrashTalkPanel = CreateFrame("Frame", "TrashTalkPanel", UIParent)
	TrashTalkPanel.name = "TrashTalk /tt"

	local option_hitmarker =
		CreateFrame("CheckButton", "option_hitmarker", TrashTalkPanel, "ChatConfigCheckButtonTemplate")
	_G[option_hitmarker:GetName() .. "Text"]:SetText("Hitmarkers")
	option_hitmarker:SetScript(
		"OnEnter",
		function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("Toggle hitmarker sound and images upon clicking on the buttons")
		end
	)
	option_hitmarker:SetPoint("TOPLEFT", 20, -20)
	option_hitmarker:SetScript(
		"OnClick",
		function(value)
			TrashTalkOptions["Hitmarker"] = value == "1"
		end
	)
	option_sendUponSight =
		CreateFrame("CheckButton", "option_sendUponSight", TrashTalkPanel, "ChatConfigCheckButtonTemplate")
	option_juked = CreateFrame("CheckButton", "option_juked", option_sendUponSight, "ChatConfigCheckButtonTemplate")
	option_kicked = CreateFrame("CheckButton", "option_kicked", option_juked, "ChatConfigCheckButtonTemplate")
	_G[option_sendUponSight:GetName() .. "Text"]:SetText("Message players upon sight")
	_G[option_juked:GetName() .. "Text"]:SetText("Message players upon getting juked")
	_G[option_kicked:GetName() .. "Text"]:SetText("Message players when someone kicks them")
	option_sendUponSight:SetScript(
		"OnEnter",
		function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("Automatically send the message below to players when you first encounter them")
		end
	)
	option_juked:SetScript(
		"OnEnter",
		function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(
				"Automatically send the message below to players when they cast an interrupt but it didn't interrupt anyone (aka got juked)"
			)
		end
	)
	option_kicked:SetScript(
		"OnEnter",
		function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("Automatically send the message below to players when they get interrupted")
		end
	)
	option_sendUponSight:SetPoint("TOPLEFT", 20, -60)
	option_juked:SetPoint("TOPLEFT", 0, -60)
	option_kicked:SetPoint("TOPLEFT", 0, -60)
	option_sendUponSight:SetScript(
		"OnClick",
		function(value)
			TrashTalkOptions["SendUponSight"] = value == "1"
		end
	)
	option_juked:SetScript(
		"OnClick",
		function(value)
			TrashTalkOptions["Juked"] = value == "1"
		end
	)
	option_kicked:SetScript(
		"OnClick",
		function(value)
			TrashTalkOptions["Kicked"] = value == "1"
		end
	)

	editbox_sendUponSight = CreateFrame("EditBox", "editbox_sendUponSight", option_sendUponSight, "InputBoxTemplate")
	editbox_juked = CreateFrame("EditBox", "editbox_juked", option_juked, "InputBoxTemplate")
	editbox_kicked = CreateFrame("EditBox", "editbox_kicked", option_kicked, "InputBoxTemplate")
	editbox_sendUponSight:SetPoint("TOPLEFT", 0, -30)
	editbox_juked:SetPoint("TOPLEFT", 0, -30)
	editbox_kicked:SetPoint("TOPLEFT", 0, -30)
	
	editbox_sendUponSight:SetSize(400, 20)
	editbox_juked:SetSize(400, 20)
	editbox_kicked:SetSize(400, 20)
	
	editbox_sendUponSight:SetAutoFocus(false)
	editbox_juked:SetAutoFocus(false)
	editbox_kicked:SetAutoFocus(false)
	
	TTPopulateTrophies();
	local function eb1update()
		TrashTalkOptions["SendUponSightText"] = editbox_sendUponSight:GetText()
	end
	--end function eb1enter
	local function eb2update()
		TrashTalkOptions["JukedText"] = editbox_juked:GetText()
	end
	local function eb3update()
		TrashTalkOptions["KickedText"] = editbox_kicked:GetText()
	end
	editbox_sendUponSight:SetScript("OnTextChanged", eb1update)
	editbox_juked:SetScript("OnTextChanged", eb2update)
	editbox_kicked:SetScript("OnTextChanged", eb3update)

	--now load all of my saved options
	option_hitmarker:SetChecked(TrashTalkOptions["Hitmarker"])
	option_sendUponSight:SetChecked(TrashTalkOptions["SendUponSight"])
	option_juked:SetChecked(TrashTalkOptions["Juked"])
	option_kicked:SetChecked(TrashTalkOptions["Kicked"])
	editbox_sendUponSight:SetText(TrashTalkOptions["SendUponSightText"])
	editbox_juked:SetText(TrashTalkOptions["JukedText"])
	editbox_kicked:SetText(TrashTalkOptions["KickedText"])
	editbox_sendUponSight:SetCursorPosition(0)
	editbox_juked:SetCursorPosition(0)
	editbox_kicked:SetCursorPosition(0)
	editbox_sendUponSight:Show()
	editbox_juked:Show()
	editbox_kicked:Show()

	InterfaceOptions_AddCategory(TrashTalkPanel)
	InterfaceAddOnsList_Update()
end
--end CreateOptions

function TrashTalk_initialize()
	print("|cff0000ff>|cffffff00TrashTalk|cffff6600 addon enabled. Type /tt or /trashtalk for options.")
	print("|cff0000ff>|cffff8888warning: you wont get banned as long as you dont whisper moonguard carebears xd")
	initializeEnemies()
	--fixPresets();

	SLASH_TrashTalk1 = "/TrashTalk"
	SLASH_TrashTalk2 = "/TT"
	SlashCmdList["TrashTalk"] = function(c)
		local split = ttSplitString(c)

		local n = getn(split)
		if (n == 0) then
			InterfaceOptionsFrame_OpenToCategory(TrashTalkPanel)
		end
		local command = ""
		local arguments = ""
		command = split[1]
		for i = 2, n do
			arguments = arguments .. split[i] .. " "
		end
		--end for
		arguments = trim(arguments)
		c = string.lower(c) --put commands in all lowercase
		local presetLength = getn(TrashTalkPresets)
		--theres no switch statement in lua (rip)
		if (command) then
			if (command == "add" and arguments and not (arguments == "")) then
				local addedPreset = arguments
				TrashTalkPresets[presetLength + 1] = addedPreset
				DDSelection = presetLength + 1
				UIDropDownMenu_SetText(TTDD, TrashTalkPresets[DDSelection])
				print('|cff00ff00adding |cffffff00"' .. addedPreset .. '"|cff00ff00 to presets list')
			elseif command == "reset" then
				print("reset: |cffff5555removing |cffffff00ALL |cffff5555entries from presets list")
				TrashTalkPresets = {}
				DDSelection = 1
				UIDropDownMenu_SetText(TTDD, defaultPreset1)
				fixPresets()
			elseif command == "hide" then
				TTDD:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", -500, -500) --throw it off screen
				backgroundFrame:Hide()
				print("|cffff0000TrashTalk frame hidden. Type |cffffaa33/tt show|cffff0000 to bring it back.")
			elseif command == "show" then
				backgroundFrame:Show()
				TTDD:SetPoint("TOPLEFT", backgroundFrame, "BOTTOMLEFT", -24, 0)
			else
				printHelp()
			end
		--end switch
		end
		--end 'if command'
		if (not (command)) then
			printHelp()
		end
	end
	--end function slashcommand

	local KickNames = {
		[47528] = GetSpellInfo(47528), --mind freeze
		[96231] = GetSpellInfo(96231), --rebuke
		[6552] = GetSpellInfo(6552), --pummel
		[106839] = GetSpellInfo(106839), -- skull bash
		[119910] = GetSpellInfo(119910), -- spell lock (command demon)
		[19647] = GetSpellInfo(19647), -- spell lock (felhunter)
		[119911] = GetSpellInfo(119911), -- optical blast (command demon)
		[115781] = GetSpellInfo(115781), -- optical blast (observer)
		[132409] = GetSpellInfo(132409), -- Spell lock (grimoire of sacrifice)
		[57994] = GetSpellInfo(57994), -- wind shear
		[147362] = GetSpellInfo(147362), -- counter shot
		[2139] = GetSpellInfo(2139), -- Counterspell
		[1766] = GetSpellInfo(1766), -- kick
		[116705] = GetSpellInfo(116705) --spear hand strike
	}
	local recentSuccessfulKick = 5
	local recentKickAttempt = 5
	local recentKickAttemptPlayer = ""
	function TrashTalk:COMBAT_LOG_EVENT_UNFILTERED(...)
		local aEvent = select(2, ...)
		local aUser = select(5, ...)
		local destName = select(9, ...)
		local spellInfo = select(15, ...)
		local spellId, spellName, spellSchool = select(12, ...)
		wasEnemyArenaCast =
			(aUser == GetUnitName("arena1", true) or aUser == GetUnitName("arena2", true) or aUser == GetUnitName("arena3", true))
		wasFriendlyArenaCast =
			(aUser == GetUnitName("player", true) or aUser == GetUnitName("party1", true) or aUser == GetUnitName("party2", true) or
			aUser == GetUnitName("party3", true) or
			aUser == GetUnitName("party4", true))

		if (aEvent == "SPELL_INTERRUPT" and wasFriendlyArenaCast) then
			if (TrashTalkOptions and TrashTalkOptions["Kicked"] == true) then
				SendTrashTalkMessage(TrashTalkOptions["KickedText"], "WHISPER", nil, destName)
			end
		--end kicked enabled
		end
		--end friendly kick
		if (aEvent == "SPELL_INTERRUPT" and wasEnemyArenaCast) then
			recentSuccessfulKick = 0 --reset its timer for juke detection
		end

		if (wasEnemyArenaCast) then
			for i, v in pairs(KickNames) do --loop through all of the possible interrupt spells
				if (spellId == i) then --if it is a kick
					recentKickAttempt = 0 --reset its timer
					recentKickAttemptPlayer = aUser
				end
				--end spell is a kick
			end
		--end for
		end
		--end if
	end
	--end COMBAT_LOG_EVENT_UNFILTERED

	function handleJukes(elapsed)
		recentKickAttempt = recentKickAttempt + elapsed
		recentSuccessfulKick = recentSuccessfulKick + elapsed
		if (recentSuccessfulKick > 0.50 and recentKickAttempt < 0.50) then
			--this kick missed!
			recentKickAttempt = 5 --so it doesnt run this code twice.
			if (TrashTalkOptions["Juked"] == true) then
				SendTrashTalkMessage(TrashTalkOptions["JukedText"], "WHISPER", nil, recentKickAttemptPlayer)
			end
		--end enabled
		end
		--end kick missed
	end
	--end function handleJukes

	--function taken from http://stackoverflow.com/questions/1426954/split-string-in-lua by user973713 on 11/26/15
	function ttSplitString(inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		local i = 1
		for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
			t[i] = str
			i = i + 1
		end
		return t
	end
	function printHelp()
		print("|cff0000ff>|cffff5555-|cffffff00TrashTalk help listing|cffff5555-   Type these commands")
		print("|cff0000ff>|cffff5555      1) /tt add -- adds a preset")
		print("|cff0000ff>|cffff5555-     example: |cff00ff00/tt add |cffffff00you suck at pvp fat dork")
		print("|cff0000ff>|cffff5555      2) /tt reset -- removes all presets")
		print("|cff0000ff>|cffff5555      3) /tt hide & /tt show ")
		print("|cff8888ffSee Escape>Interface>Addons tab for more options")
	end
	--end printHelp

	backgroundFrame:SetPoint("RIGHT", -50, 0)
	backgroundFrame:SetFrameStrata("MEDIUM")
	backgroundFrame:SetSize(buttonWidth, buttonHeight * 2)
	backgroundFrame:SetMovable(true)
	backgroundFrame:EnableMouse(true)
	backgroundFrame:RegisterForDrag("LeftButton")
	backgroundFrame:SetScript("OnDragStart", backgroundFrame.StartMoving)
	backgroundFrame:SetScript("OnDragStop", backgroundFrame.StopMovingOrSizing)
	local tex = backgroundFrame:CreateTexture("ARTWORK")
	tex:SetAllPoints()
	tex:SetTexture(0.1686274509803922, 0.0588235294117647, 0.003921568627451)
	tex:SetAlpha(0.80)
	titleText = backgroundFrame:CreateFontString("titleText", backgroundFrame, "GameFontNormal")
	titleText:SetTextColor(1, 0.643, 0.169, 1)
	titleText:SetShadowColor(0, 0, 0, 1)
	titleText:SetShadowOffset(2, -1)
	titleText:SetPoint("TOPLEFT", tex, "TOPLEFT", 16, 0)
	titleText:SetText("/tt TrashTalk")
	titleText:Show()
	backgroundFrame:Show()

	for i = 1, 3 do
		local selectedArenaFrame = ttbuttons[i]
		selectedArenaFrame:SetText("")
		selectedArenaFrame:SetPoint("TOPLEFT", tex, "TOPLEFT", 0, -13 - (buttonHeight - 2) * (i - 1))
		selectedArenaFrame:SetWidth(buttonWidth)
		selectedArenaFrame:SetHeight(buttonHeight)
		selectedArenaFrame:SetScript("OnClick", buttonOnePressed)
		selectedArenaFrame:SetBackdropBorderColor(0, 0, 1) --include alpha?
		selectedArenaFrame:SetBackdropColor(0, 0, 1)
	end

	backgroundFrame:Show()

	local frameTemp = CreateFrame("FRAME", "TrashTalkFrame")

	playersFaction = UnitFactionGroup("player")
	if (playersFaction == "Alliance") then
		enemyFaction = "Horde"
	else
		enemyFaction = "Alliance"
	end

	initializeEnemies()
	manageFrames()
end
--end TrashTalk_initialize

function TrashTalk_OnLoad()
end
--end TrashTalk_OnLoad

--the purpose of this function is to redraw the frames with the updated data (given)
function manageFrames(justJoinedArena, justLeftArena)
	if (justJoinedArena) then
		--resize frames and change names and stuff
		initializeEnemies()
	end
	--end justJoinedArena

	if (justLeftArena) then
	end
	--end justLeftArena

	--draw the frames,resize
	for i = 1, 3 do
		ttbuttons[i]:SetText(ttenemies[i]["name"] .. ttenemies[i]["class"])
	end

	if (ttenemies[3]["exists"] == true) then
		ttbuttons[3]:Show()
		backgroundFrame:SetSize(buttonWidth, buttonHeight * 3)
	end
end
--end manageFrames

--the control loop
function handleHitmarkers(elapsed)
	if (hitMarkerEnabled) then
		tHitMarker = tHitMarker + elapsed
		if (tHitMarker > 0.75) then --make the hitmarker disappear after this many seconds
			hitMarkerEnabled = false
			tHitMarker = 0
			hitMarkerImage:Hide()
		end
	end
	--end hitMarkerEnabled
end
--end handleHitmarkers
function handleOhBabyATriple(elapsed)
	numClicked = 0
	if (clicked1) then
		numClicked = numClicked + 1
	end
	if (clicked2) then
		numClicked = numClicked + 1
	end
	if (clicked3) then
		numClicked = numClicked + 1
	end
	if (tOhBabyATriple == 0 and numClicked > 2) then
		interventionEnabled = true
		enableSnoopDogg()
	end
	tOhBabyATriple = tOhBabyATriple + elapsed --used to time effects as well as cancelling initial effect.

	if (tOhBabyATriple > 4.5 and not (numClicked > 2)) then --clicked too slow so no triple :--(
		clicked1 = false
		clicked2 = false
		clicked3 = false
	end

	if (numClicked > 2) then
		if (tOhBabyATriple > 2.0) then
			clicked1 = false
			clicked2 = false
			clicked3 = false
			PlaySoundFile("Interface\\AddOns\\TrashTalk\\sounds\\OH_BABY3.mp3", "Master")
		end
	end
	--end clicked>2
end
--end handleOhBabyATriple

local step = 0
function handleIntervention(elapsed)
	local speed = 0.25

	if (interventionEnabled) then
		tIntervention = tIntervention + elapsed
		if (tIntervention > 0 and tIntervention < speed and step == 0) then
			--initialize
			interventionImage = CreateFrame("Frame", nil, UIParent)
			interventionImage:SetPoint("CENTER", 0, 0)
			interventionImage:SetFrameStrata("HIGH")
			interventionImage:SetSize(800, 800)
			interventionImageObj = interventionImage:CreateTexture()
			interventionImageObj:SetAllPoints()
			interventionImageObj:SetAlpha(1)
			interventionImageObj:SetTexture("Interface/AddOns/TrashTalk/images/int_1.tga")
			interventionImage:Show()

			step = step + 1
		elseif (tIntervention > speed and tIntervention < speed * 2 and step == 1) then
			step = step + 1
			interventionImageObj:SetTexture("Interface/AddOns/TrashTalk/images/int_2.tga")
		elseif (tIntervention > speed * 2 and tIntervention < speed * 3 and step == 2) then
			step = step + 1
			interventionImageObj:SetTexture("Interface/AddOns/TrashTalk/images/int_3.tga")
		elseif (tIntervention > speed * 3 and tIntervention < speed * 4 and step == 3) then
			--peak
			step = step + 1
			interventionImageObj:SetTexture("Interface/AddOns/TrashTalk/images/int_4.tga")
		elseif (tIntervention > speed * 4 and tIntervention < speed * 5 and step == 4) then
			step = step + 1
			interventionImageObj:SetTexture("Interface/AddOns/TrashTalk/images/int_3.tga")
		elseif (tIntervention > speed * 5 and tIntervention < speed * 6 and step == 5) then
			step = step + 1
			interventionImageObj:SetTexture("Interface/AddOns/TrashTalk/images/int_2.tga")
		elseif (tIntervention > speed * 6 and tIntervention < speed * 7 and step == 6) then
			--last part of sequence
			step = step + 1
			interventionImageObj:SetTexture("Interface/AddOns/TrashTalk/images/int_1.tga")
		elseif (tIntervention > speed * 7) then
			interventionEnabled = false
			interventionImage:Hide()
			tIntervention = 0
			step = 0
		end
	--end switch
	end
	--end if interventionEnabled
end
--end handleIntervention
local spinSpeed = 0.25
local spin = 0
local direction = 1
local snoopLoops = 0
function enableSnoopDogg()
	snoopLoops = 0
	snoopDoggEnabled = true
end
function disableSnoopDogg()
	snoopDoggEnabled = false
	snoopDoggImage:Hide()
end
function handleSnoopDogg(elapsed)
	if (snoopDoggEnabled == false) then
		return
	end
	tSnoopDogg = tSnoopDogg + elapsed
	if (tSnoopDogg > spinSpeed) then
		tSnoopDogg = 0
		spin = spin + direction
		if (spin == 8) then
			direction = -1
			spin = 7
		end
		--end 8
		if (spin == -1) then
			snoopLoops = snoopLoops + 1
			direction = 1
			spin = 1
		end
	--end -1
	end
	--end > spin

	if (snoopLoops > 3) then
		disableSnoopDogg()
	end

	if (snoopDoggImage == nil or snoopDoggImageObj == nil) then
		snoopDoggImage = CreateFrame("Frame", nil, UIParent)
		snoopDoggImage:SetPoint("TOPLEFT", backgroundFrame, "TOPLEFT", 0, 0)
		snoopDoggImage:SetFrameStrata("HIGH")
		snoopDoggImage:SetSize(snoopWidth, snoopHeight * 1.5)
		snoopDoggImageObj = snoopDoggImage:CreateTexture()
		snoopDoggImageObj:SetAllPoints()
		snoopDoggImageObj:SetAlpha(1)
	end
	--end if nil

	if (spin == 0) then
		--initialize if nil

		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop1.tga")
		snoopDoggImage:Show()
	elseif (spin == 1) then
		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop2.tga")
	elseif (spin == 2) then
		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop3.tga")
	elseif (spin == 3) then
		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop4.tga")
	elseif (spin == 4) then
		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop5.tga")
	elseif (spin == 5) then
		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop6.tga")
	elseif (spin == 6) then
		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop7.tga")
	elseif (spin == 7) then
		snoopDoggImageObj:SetTexture("Interface/AddOns/TrashTalk/images/snoop8.tga")
	end
	--end switch
end
--end handleSnoopDogg

local firstTime = true
function TrashTalk_OnUpdate(self, elapsed)
	local temp = UIParent:GetEffectiveScale()
	if (firstTime) then --do on-load sensitive stuff
		firstTime = false
		CreateOptions()
	end
	handleSnoopDogg(elapsed)
	handleHitmarkers(elapsed)
	handleOhBabyATriple(elapsed)
	handleIntervention(elapsed)
	handleJukes(elapsed)
	playerIsInArena = IsActiveBattlefieldArena()

	for i = 1, 3 do
		local selectedEnemy = ttenemies[i]
		--detect players on first sight
		if (playerIsInArena and (selectedEnemy["exists"] == false or selectedEnemy["name"] == "Unknown")) then --if i want to write to it
			if (UnitExists("arena" .. i)) then
				selectedEnemy["exists"] = true
				selectedEnemy["name"], selectedEnemy["realm"] = UnitName("arena" .. i)
				local namelol = selectedEnemy["name"];
				local realmlol = selectedEnemy["realm"];
				local appendmelol = selectedEnemy["name"];
				if (realmlol ~= nil) then
					appendmelol = appendmelol .. "-" .. realmlol;
				end
				AddTrashTalkVictim(appendmelol);
				if (UnitFactionGroup("arena" .. i) ~= playersFaction) then
					selectedEnemy["name"] = "" .. enemyFaction .. " :-(" --they are the other faction and cannot be whispered.
					selectedEnemy["realm"] = ""
				elseif (TrashTalkOptions["SendUponSight"] == true and selectedEnemy["name"] ~= "Unknown") then
					if (selectedEnemy["realm"] == nil) then --they are on the same realm as player
						SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, selectedEnemy["name"])
					else
						SendTrashTalkMessage(
							TrashTalkOptions["SendUponSightText"],
							"WHISPER",
							nil,
							selectedEnemy["name"] .. "-" .. selectedEnemy["realm"]
						)
					end
				end
				--end not faction
				selectedEnemy["class"] = UnitClass("arena" .. i)
				manageFrames(false, false)
			end
		--end exists
		end
	end
end
--end TrashTalk_OnUpdate

--localInstanceType is used just for this method. all others should use instanceType
local localInstanceType = "probably_not_arena"
function TrashTalk:ZONE_CHANGED_NEW_AREA()
	local _, instanceType = IsInInstance()
	-- check if we are entering or leaving an arena
	if instanceType == "arena" then
		TrashTalk_JoinedArena()
	elseif instanceType ~= "arena" and localInstanceType == "arena" then
		TrashTalk_LeftArena()
	end
	self.localInstanceType = instanceType
end

function TrashTalk_JoinedArena()
	initializeEnemies()
	manageFrames(true, false)
end
--end TrashTalk_JoinedArena
function TrashTalk_LeftArena()
	manageFrames(false, true)
end
--end TrashTalk_LeftArena

function buttonOnePressed()
	fixPresets()
	clicked1 = true

	if (ttenemies[1]["realm"] == nil) then --they are on the same realm as player
		SendTrashTalkMessage(currentPreset, "WHISPER", nil, ttenemies[1]["name"])
	else
		SendTrashTalkMessage(currentPreset, "WHISPER", nil, ttenemies[1]["name"] .. "-" .. ttenemies[1]["realm"])
	end
	arenaButtonClicked(ttbuttons[1])
end
--end buttonOnePressed

function buttonTwoPressed()
	fixPresets()
	clicked2 = true
	if (ttenemies[2]["realm"] == nil) then --they are on the same realm as player
		SendTrashTalkMessage(currentPreset, "WHISPER", nil, ttenemies[2]["name"])
	else
		SendTrashTalkMessage(currentPreset, "WHISPER", nil, ttenemies[2]["name"] .. "-" .. ttenemies[2]["realm"])
	end
	arenaButtonClicked(ttbuttons[2])
end
--end buttonTwoPressed

function buttonThreePressed()
	fixPresets()
	clicked3 = true
	if (ttenemies[3]["realm"] == nil) then --they are on the same realm as player
		SendTrashTalkMessage(currentPreset, "WHISPER", nil, ttenemies[3]["name"])
	else
		SendTrashTalkMessage(currentPreset, "WHISPER", nil, ttenemies[3]["name"] .. "-" .. ttenemies[3]["realm"])
	end
	arenaButtonClicked(ttbuttons[3])
end
--end buttonThreePressed

--to be called from the three button functions
function arenaButtonClicked(fureemu)
	tOhBabyATriple = 0

	if (TrashTalkOptions["Hitmarker"] == true) then
		PlaySoundFile("Interface\\AddOns\\TrashTalk\\sounds\\Hitmarker_Volume_3.mp3", "Master")
		if (hitMarkerEnabled == true) then
			hitMarkerImage:Hide()
		end --dont make duplicates
		tHitMarker = 0
		hitmarkerX = 4 + math.random(buttonWidth - 8)
		hitMarkerEnabled = true
		--also play the sound
		PlaySoundFile("Interface\\AddOns\\TrashTalk\\sounds\\Hitmarker_Volume_3.mp3", "Master")

		hitMarkerImage = CreateFrame("Frame", nil, UIParent)

		hitMarkerImage:SetPoint("LEFT", fureemu, "LEFT", hitmarkerX, 0)
		hitMarkerImage:SetFrameStrata("HIGH")
		hitMarkerImage:SetSize(32, 32)

		hitMarkerImageObj = hitMarkerImage:CreateTexture()
		hitMarkerImageObj:SetAllPoints()
		hitMarkerImageObj:SetAlpha(1)
		hitMarkerImageObj:SetTexture("Interface/AddOns/TrashTalk/images/Le_Perfect_Hitmarker.tga")
		hitMarkerImage:Show()
	end
	--end TrashTalkOptions["Hitmarker"] true
end
--end function arenaButtonClicked

function backgroundFrame:OnDragStart(self, ...)
	--backgroundFrame:startMoving();
end
function backgroundFrame:OnDragStop(self, ...)
end
function backgroundFrame:OnMouseDown(...)
end
