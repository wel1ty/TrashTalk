--[[
Addon created by Steven Ventura (aka noob)
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

TrashTalkSavedWhispers

]]

boysToAddToTrashTalkStack = {};

function SendTrashTalkMessage(a,b,c,d ) 
--SendTrashTalkMessage(TrashTalkOptions["KickedText"],"WHISPER",nil,destName);
SendChatMessage(a,b,c,d);

boysToAddToTrashTalkStack[d] = d;
print("adding " .. boysToAddToTrashTalkStack[d] .. " to boystack");

end--end function SendTrashTalkMessage
function authorIsTrashTalkVictim(author) 

--search through saved whispers
for a,b in pairs(TrashTalkSavedWhispers) do
if (a == author) then return true end
end--end for
--now include all "temporary whispers"
--its called a stack but i never bother removing from the stack lol
for c,d in pairs(boysToAddToTrashTalkStack) do
if (c == author) then return true end
end--end for
return false

end--end function authorIsTrashTalkVictim
function TrashTalkIncoming(ChatFrameSelf, event, message, author, ...)
if (authorIsTrashTalkVictim(author)) then
biggestxd = 0--cos idk how to get biggest value in array or array size xd
for num,mess in ipairs(TrashTalkSavedWhispers[author]) do
biggestxd = num
end


TrashTalkSavedWhispers[author][biggestxd] = message;--lol
print("saved message from " .. author);

end

end--end function TrashTalkIncoming
local screenWidth;
local screenHeight;

local tHitMarker = 0;hitMarkerEnabled = false;hitMarkerImage = nil;
local clicked1=false;clicked2=false;clicked3=false;clicked4=false;clickeed5=false;--for 'oh baby a triple'
local tOhBabyATriple = 0;
local tIntervention = 0; interventionEnabled = false; interventionImage = nil; interventionImageObj = nil;
local tSnoopDogg = 0; snoopDoggImage = nil; snoopDoggImageObj = nil; snoopDoggEnabled = false;

local buttonHeight = 22;
local buttonWidth = 108;
local snoopWidth = buttonWidth;
local snoopHeight = buttonHeight*3;
local DDSelection = 1 -- A user-configurable setting

local currentPreset;
local defaultPreset1 = "bad";
local defaultPreset2 = "Hi!! :o) ! <33 My name is Roxy, I'm a krazy loud girl who's pretty terrible at games but pretty good at art and smoking weed, come L o L @ me ;~) I'm trying to survive as a student and artist so ALL donations help me a lot! THANK U <3!";
local defaultPreset3 = "What the fuck did you just fucking say about me you little shit? I’ll have you know I gradually reach to the top guild on my server and in this game, been involved in numerous world first raids, and I have over 200 confirmed world first boss kills. I have played every class in the game and I’m the top dps, tank and healer in the guild.";
local function fixPresets()

if (not (TrashTalkPresets) or not (TrashTalkPresets[1])) then
TrashTalkPresets = {[1]= defaultPreset1,
					[2]= defaultPreset2,
					[3]= defaultPreset3};
print("|cff666666(default trashtalkpresets was loaded)");
end
currentPreset = TrashTalkPresets[DDSelection];


end--end function fixPresets

local function OnEvent(self, event, ...)
	local dispatch = self[event]

	if dispatch then
		dispatch(self, ...)
	end
end

local TrashTalk = CreateFrame("Frame");
TrashTalk:SetScript("OnEvent", OnEvent);
TrashTalk:RegisterEvent("ZONE_CHANGED_NEW_AREA");
TrashTalk:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local backgroundFrame = CreateFrame('Frame','backgroundFrame',UIParent);
local TrashTalk_eventFrame = CreateFrame("Frame")
TrashTalk_eventFrame:RegisterEvent("VARIABLES_LOADED");



TrashTalk_eventFrame:SetScript("OnEvent",function(self,event,...) self[event](self,event,...);end)
TrashTalk_eventFrame:SetScript("OnUpdate", function(self, elapsed) TrashTalk_OnUpdate(self, elapsed) end)
function TrashTalk_eventFrame:VARIABLES_LOADED()
fixPresets();--init variables if they arent yet
------------------------------------------------------------------
-- Create the dropdown, and configure its appearance
CreateFrame("FRAME", "TTDD", UIParent, "UIDropDownMenuTemplate")
TTDD:SetPoint("TOPLEFT",backgroundFrame,"BOTTOMLEFT",-24,0);
UIDropDownMenu_SetWidth(TTDD, buttonWidth)
UIDropDownMenu_SetText(TTDD, TrashTalkPresets[DDSelection])

-- Create and bind the initialization function to the dropdown menu
UIDropDownMenu_Initialize(TTDD, function(self, level, menuList)
 local info = UIDropDownMenu_CreateInfo()
  --display
  local length = getn(TrashTalkPresets);
  for i=1,length do
   info.text = TrashTalkPresets[i]; 
   info.checked = (DDSelection == i);
   info.menuList = i;
   info.func = TTDD.SetValue;
   info.arg1 = i;--arg1 is used here as the SetValue argument.
   UIDropDownMenu_AddButton(info)
  end--end for
end)


-- Implement the function
function TTDD:SetValue(newValue)
 DDSelection = newValue
 UIDropDownMenu_SetText(TTDD, TrashTalkPresets[DDSelection])
end

--TTDD:Show();
------------------------------------------------------------------end dropdown stuff
end--end variablesLoaded

local arena1frame = CreateFrame("Button", "arena1frame", backgroundFrame, "UIPanelButtonTemplate");
local arena2frame = CreateFrame("Button", "arena2frame", backgroundFrame, "UIPanelButtonTemplate");
local arena3frame = CreateFrame("Button", "arena3frame", backgroundFrame, "UIPanelButtonTemplate");
local arena4frame = CreateFrame("Button", "arena4frame", backgroundFrame, "UIPanelButtonTemplate");
local arena5frame = CreateFrame("Button", "arena5frame", backgroundFrame, "UIPanelButtonTemplate");

local playerIsInArena = false; local playersFaction = 'nil'; local enemyFaction = 'nil';
local enemy1 = {}; enemy2 = {}; enemy3 = {}; enemy4 = {}; enemy5 = {};--struct tables
--sets all enemy values back to default values.
function initializeEnemies()
--set arena frame size enough for 2 enemies
backgroundFrame:SetSize(buttonWidth,buttonHeight*2);

enemy1['name'] = 'nobody yet';
enemy1['realm'] = '';
enemy1['class'] = '';
enemy1['exists'] = false;

enemy2['name'] = 'nobody yet';
enemy2['realm'] = '';
enemy2['class'] = '';
enemy2['exists'] = false;

enemy3['name'] = 'nobody yet';
enemy3['realm'] = '';
enemy3['class'] = '';
enemy3['exists'] = false;
arena3frame:Hide();

enemy4['name'] = 'nobody yet';
enemy4['realm'] = '';
enemy4['class'] = '';
enemy4['exists'] = false;
arena4frame:Hide();

enemy5['name'] = 'nobody yet';
enemy5['realm'] = '';
enemy5['class'] = '';
enemy5['exists'] = false;
arena5frame:Hide();


end--end function initializeEnemies;

-- from PiL2 20.4
function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function CreateOptions()
if (not TrashTalkOptions or TrashTalkOptions["Kicked"] == nil) then
print("instantiating trashtalkoptions"); 
TrashTalkOptions = {["Hitmarker"] = true, ["SendUponSight"] = true,
					["SendUponSightText"] = "lmao i just beat you on my alt ur so bad",
					["Juked"] = true, ["JukedText"] = "nice kick friend",
					["Kicked"] = true, ["KickedText"] = "LOL GET KICKED NERD HAHAHA LEARN TO JUKE"};
					
end--end init trashtalkoptions
TrashTalkPanel = CreateFrame("Frame","TrashTalkPanel", UIParent);
TrashTalkPanel.name = "TrashTalk /tt";

local option_hitmarker = CreateFrame("CheckButton","option_hitmarker",TrashTalkPanel,"OptionsCheckButtonTemplate");
_G[option_hitmarker:GetName() .. "Text"]:SetText("Hitmarkers");
option_hitmarker:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Toggle hitmarker sound and images upon clicking on the buttons");
end);
option_hitmarker:SetPoint("TOPLEFT",20,-20);
option_hitmarker.setFunc = function(value) 
TrashTalkOptions["Hitmarker"] = value == "1"
end
option_sendUponSight = CreateFrame("CheckButton","option_sendUponSight",TrashTalkPanel,"OptionsCheckButtonTemplate");
option_juked = CreateFrame("CheckButton","option_juked",option_sendUponSight,"OptionsCheckButtonTemplate");
option_kicked = CreateFrame("CheckButton","option_kicked",option_juked,"OptionsCheckButtonTemplate");
_G[option_sendUponSight:GetName() .. "Text"]:SetText("Message players upon sight");
_G[option_juked:GetName() .. "Text"]:SetText("Message players upon getting juked");
_G[option_kicked:GetName() .. "Text"]:SetText("Message players when someone kicks them");
option_sendUponSight:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText("Automatically send the message below to players when you first encounter them");
end);
option_juked:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText("Automatically send the message below to players when they cast an interrupt but it didn't interrupt anyone (aka got juked)");
end);
option_kicked:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText("Automatically send the message below to players when they get interrupted");
end);
option_sendUponSight:SetPoint("TOPLEFT",20,-60);
option_juked:SetPoint("TOPLEFT",0,-60);
option_kicked:SetPoint("TOPLEFT",0,-60);
option_sendUponSight.setFunc = function(value)
TrashTalkOptions["SendUponSight"] = value == "1";
end
option_juked.setFunc = function(value)
TrashTalkOptions["Juked"] = value == "1";
end
option_kicked.setFunc = function(value)
TrashTalkOptions["Kicked"] = value == "1";
end

editbox_sendUponSight = CreateFrame("EditBox","editbox_sendUponSight",option_sendUponSight,"InputBoxTemplate");
editbox_juked = CreateFrame("EditBox","editbox_juked",option_juked,"InputBoxTemplate");
editbox_kicked = CreateFrame("EditBox","editbox_kicked",option_kicked,"InputBoxTemplate");
editbox_sendUponSight:SetPoint("TOPLEFT",0,-30);
editbox_juked:SetPoint("TOPLEFT",0,-30);
editbox_kicked:SetPoint("TOPLEFT",0,-30);
editbox_sendUponSight:SetSize(400,20);
editbox_juked:SetSize(400,20);
editbox_kicked:SetSize(400,20);
editbox_sendUponSight:SetAutoFocus(false);
editbox_juked:SetAutoFocus(false);
editbox_kicked:SetAutoFocus(false);
local function eb1update()
TrashTalkOptions["SendUponSightText"] = editbox_sendUponSight:GetText();
end--end function eb1enter
local function eb2update()
TrashTalkOptions["JukedText"] = editbox_juked:GetText();
end
local function eb3update()
TrashTalkOptions["KickedText"] = editbox_kicked:GetText();
end
editbox_sendUponSight:SetScript("OnTextChanged",eb1update);
editbox_juked:SetScript("OnTextChanged",eb2update);
editbox_kicked:SetScript("OnTextChanged",eb3update);

--now load all of my saved options
option_hitmarker:SetChecked(TrashTalkOptions["Hitmarker"]);
option_sendUponSight:SetChecked(TrashTalkOptions["SendUponSight"]);
option_juked:SetChecked(TrashTalkOptions["Juked"]);
option_kicked:SetChecked(TrashTalkOptions["Kicked"]);
editbox_sendUponSight:SetText(TrashTalkOptions["SendUponSightText"]);
editbox_juked:SetText(TrashTalkOptions["JukedText"]);
editbox_kicked:SetText(TrashTalkOptions["KickedText"]);
editbox_sendUponSight:SetCursorPosition(0);
editbox_juked:SetCursorPosition(0);
editbox_kicked:SetCursorPosition(0);
editbox_sendUponSight:Show();
editbox_juked:Show();
editbox_kicked:Show();

InterfaceOptions_AddCategory(TrashTalkPanel);
InterfaceAddOnsList_Update();
end--end CreateOptions



function TrashTalk_initialize()
print("|cff0000ff>|cffffff00TrashTalk|cffff6600 addon enabled. Type /tt or /trashtalk for options.");
print("|cff0000ff>|cffff8888warning: you wont get banned as long as you dont whisper moonguard carebears xd");
initializeEnemies();
--fixPresets();



SLASH_TrashTalk1 = "/TrashTalk";SLASH_TrashTalk2 = "/TT";
SlashCmdList["TrashTalk"] = function(c)

local split = ttSplitString(c);

local n = getn(split);
print("n is " .. n)
if (n == 0) then
InterfaceOptionsFrame_OpenToCategory(TrashTalkPanel);
end
local command = '';
local arguments = '';
command = split[1];
for i = 2, n do
arguments = arguments .. split[i] .. " ";
end--end for
arguments = trim(arguments);
c = string.lower(c);--put commands in all lowercase
local presetLength = getn(TrashTalkPresets)
--theres no switch statement in lua (rip)
if (command) then
if (command == 'add' and arguments and not (arguments == '')) then
local addedPreset = arguments;
TrashTalkPresets[presetLength+1] = addedPreset;
DDSelection = presetLength+1;
UIDropDownMenu_SetText(TTDD, TrashTalkPresets[DDSelection]);
print('|cff00ff00adding |cffffff00"' .. addedPreset .. '"|cff00ff00 to presets list');
elseif command == 'reset' then
print('reset: |cffff5555removing |cffffff00ALL |cffff5555entries from presets list');
TrashTalkPresets = {};
DDSelection = 1;
UIDropDownMenu_SetText(TTDD, defaultPreset1);
fixPresets();
elseif command == 'hide' then
TTDD:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",-500,-500);--throw it off screen
backgroundFrame:Hide();
print("|cffff0000TrashTalk frame hidden. Type |cffffaa33/tt show|cffff0000 to bring it back.");
elseif command == 'show' then 
backgroundFrame:Show();
TTDD:SetPoint("TOPLEFT",backgroundFrame,"BOTTOMLEFT",-24,0);
else
printHelp();
end--end switch
end--end 'if command'
if (not(command)) then 
printHelp();
end



end--end function slashcommand

local KickNames = 
	{ 
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
[116705] = GetSpellInfo(116705), --spear hand strike
	};
local recentSuccessfulKick = 5;
local recentKickAttempt = 5;
local recentKickAttemptPlayer = "";
function TrashTalk:COMBAT_LOG_EVENT_UNFILTERED(...)
local aEvent = select(2, ...)
local aUser = select(5, ...)
local destName = select(9, ...)
local spellInfo = select(15, ...)
local spellId, spellName, spellSchool = select(12, ...)
wasEnemyArenaCast = (aUser == GetUnitName("arena1",true) 
				or aUser == GetUnitName("arena2",true) 
				or aUser == GetUnitName("arena3",true)
				or aUser == GetUnitName("arena4",true)
				or aUser == GetUnitName("arena5",true));
wasFriendlyArenaCast = (aUser == GetUnitName("player",true)
					 or aUser == GetUnitName("party1",true)
					 or aUser == GetUnitName("party2",true)
					 or aUser == GetUnitName("party3",true)
					 or aUser == GetUnitName("party4",true));

if (aEvent=="SPELL_INTERRUPT" and wasFriendlyArenaCast)
then
if (TrashTalkOptions and TrashTalkOptions["Kicked"] == true)
then
SendTrashTalkMessage(TrashTalkOptions["KickedText"],"WHISPER",nil,destName);
end--end kicked enabled
end--end friendly kick			
if (aEvent=="SPELL_INTERRUPT" and wasEnemyArenaCast)
then
recentSuccessfulKick = 0;--reset its timer for juke detection
end

if (wasEnemyArenaCast) then
for i,v in pairs(KickNames) do--loop through all of the possible interrupt spells
if (spellId == i) --if it is a kick
then
recentKickAttempt = 0;--reset its timer
recentKickAttemptPlayer = aUser;
end--end spell is a kick

end--end for
end--end if

end--end COMBAT_LOG_EVENT_UNFILTERED

function handleJukes(elapsed)
recentKickAttempt = recentKickAttempt + elapsed;
recentSuccessfulKick = recentSuccessfulKick + elapsed;
if (recentSuccessfulKick > 0.50 and recentKickAttempt < 0.50) then
--this kick missed!
recentKickAttempt = 5;--so it doesnt run this code twice.
if (TrashTalkOptions["Juked"] == true) then
SendTrashTalkMessage(TrashTalkOptions["JukedText"],"WHISPER",nil,recentKickAttemptPlayer);
end--end enabled
end--end kick missed


end--end function handleJukes







--function taken from http://stackoverflow.com/questions/1426954/split-string-in-lua by user973713 on 11/26/15
function ttSplitString(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; local i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
function printHelp()
print("|cff0000ff>|cffff5555-|cffffff00TrashTalk help listing|cffff5555-   Type these commands")
print("|cff0000ff>|cffff5555      1) /tt add -- adds a preset")
print("|cff0000ff>|cffff5555-     example: |cff00ff00/tt add |cffffff00you suck at pvp fat dork")
print("|cff0000ff>|cffff5555      2) /tt reset -- removes all presets");
print("|cff0000ff>|cffff5555      3) /tt hide & /tt show ");
print("|cff8888ffSee Escape>Interface>Addons tab for more options");
end--end printHelp

backgroundFrame:SetPoint('RIGHT',-50,0);
backgroundFrame:SetFrameStrata('MEDIUM');
backgroundFrame:SetSize(buttonWidth,buttonHeight*2);
backgroundFrame:SetMovable(true);
backgroundFrame:EnableMouse(true);
backgroundFrame:RegisterForDrag("LeftButton");
backgroundFrame:SetScript("OnDragStart", backgroundFrame.StartMoving)
backgroundFrame:SetScript("OnDragStop", backgroundFrame.StopMovingOrSizing)
local tex = backgroundFrame:CreateTexture("ARTWORK");
 tex:SetAllPoints();
 tex:SetTexture(0.1686274509803922,0.0588235294117647,0.003921568627451); tex:SetAlpha(0.80);
 titleText = backgroundFrame:CreateFontString("titleText",backgroundFrame,"GameFontNormal");
 titleText:SetTextColor(1,0.643,0.169,1);
 titleText:SetShadowColor(0,0,0,1);
 titleText:SetShadowOffset(2,-1);
 titleText:SetPoint("TOPLEFT",tex,"TOPLEFT",16,0);
titleText:SetText("/tt TrashTalk");
titleText:Show();
backgroundFrame:Show();



arena1frame:SetText("");
arena1frame:SetPoint("TOPLEFT",tex,"TOPLEFT",0,-13);
arena1frame:SetWidth(buttonWidth);
arena1frame:SetHeight(buttonHeight);
arena1frame:SetScript("OnClick", buttonOnePressed);
arena1frame:SetBackdropBorderColor(0,0,1);--include alpha?
arena1frame:SetBackdropColor(0,0,1);

arena2frame:SetText("");
arena2frame:SetPoint("TOPLEFT",tex,"TOPLEFT",0,-13-(buttonHeight-2)*1);--place it at the top of the frame under title
arena2frame:SetWidth(buttonWidth);
arena2frame:SetHeight(buttonHeight);
arena2frame:SetScript("OnClick", buttonTwoPressed);
arena2frame:SetBackdropBorderColor(0,0,1);
arena2frame:SetBackdropColor(0,0,1);

arena3frame:SetText("");
arena4frame:SetText("");
arena5frame:SetText("");
arena3frame:SetPoint("TOPLEFT",tex,"TOPLEFT",0,-13-(buttonHeight-2)*2);
arena4frame:SetPoint("TOPLEFT",tex,"TOPLEFT",0,-13-(buttonHeight-2)*3);
arena5frame:SetPoint("TOPLEFT",tex,"TOPLEFT",0,-13-(buttonHeight-2)*4);
arena3frame:SetWidth(buttonWidth);
arena4frame:SetWidth(buttonWidth);
arena5frame:SetWidth(buttonWidth);
arena3frame:SetHeight(buttonHeight);
arena4frame:SetHeight(buttonHeight);
arena5frame:SetHeight(buttonHeight);
arena3frame:SetScript("OnClick", buttonThreePressed);
arena4frame:SetScript("OnClick", buttonFourPressed);
arena5frame:SetScript("OnClick", buttonFivePressed);
arena3frame:SetBackdropBorderColor(0,0,1);
arena4frame:SetBackdropBorderColor(0,0,1);
arena5frame:SetBackdropBorderColor(0,0,1);
arena3frame:SetBackdropColor(0,0,1);
arena4frame:SetBackdropColor(0,0,1);
arena5frame:SetBackdropColor(0,0,1);
backgroundFrame:Show();



local frameTemp = CreateFrame("FRAME","TrashTalkFrame");

playersFaction = UnitFactionGroup('player');
if (playersFaction == "Alliance")
then
enemyFaction = "Horde";
else
enemyFaction = "Alliance";
end

initializeEnemies();
manageFrames();

end--end TrashTalk_initialize





function TrashTalk_OnLoad()
end--end TrashTalk_OnLoad


--the purpose of this function is to redraw the frames with the updated data (given)
function manageFrames(justJoinedArena,justLeftArena)

if (justJoinedArena)
then
--resize frames and change names and stuff
initializeEnemies();

end--end justJoinedArena

if (justLeftArena)
then



end--end justLeftArena

--draw the frames,resize
arena1frame:SetText(enemy1['name'] .. enemy1['class']);
arena2frame:SetText(enemy2['name'] .. enemy2['class']);
arena3frame:SetText(enemy3['name'] .. enemy3['class']);
arena4frame:SetText(enemy4['name'] .. enemy4['class']);
arena5frame:SetText(enemy5['name'] .. enemy5['class']);

if (enemy3['exists'] == true)
then
arena3frame:Show();
backgroundFrame:SetSize(buttonWidth,buttonHeight*3);
end
if (enemy4['exists'] == true)
then
arena4frame:Show();
backgroundFrame:SetSize(buttonWidth,buttonHeight*4);
end
if (enemy5['exists'] == true)
then
arena5frame:Show();
backgroundFrame:SetSize(buttonWidth,buttonHeight*5);
end


end--end manageFrames




--the control loop
function handleHitmarkers(elapsed)
if (hitMarkerEnabled)
then
tHitMarker = tHitMarker + elapsed;
if (tHitMarker > 0.75)--make the hitmarker disappear after this many seconds
then
hitMarkerEnabled = false;
tHitMarker = 0;
hitMarkerImage:Hide();
end
end--end hitMarkerEnabled
end--end handleHitmarkers
function handleOhBabyATriple(elapsed)
numClicked = 0;
if (clicked1) then numClicked = numClicked + 1; end
if (clicked2) then numClicked = numClicked + 1; end
if (clicked3) then numClicked = numClicked + 1; end
if (clicked4) then numClicked = numClicked + 1; end
if (clicked5) then numClicked = numClicked + 1; end
if (tOhBabyATriple == 0 and numClicked > 2) then 
interventionEnabled = true;
enableSnoopDogg();
end
tOhBabyATriple = tOhBabyATriple + elapsed;--used to time effects as well as cancelling initial effect.

if (tOhBabyATriple > 4.5 and not(numClicked > 2)) then --clicked too slow so no triple :--(
clicked1 = false; clicked2 = false; clicked3 = false; clicked4 = false; clicked5 = false
end

if (numClicked > 2) then 
if (tOhBabyATriple > 2.0) then
clicked1 = false; clicked2 = false; clicked3 = false;
PlaySoundFile('Interface\\AddOns\\TrashTalk\\sounds\\OH_BABY3.mp3', 'Master');
end
end--end clicked>2


end--end handleOhBabyATriple

local step = 0;
function handleIntervention(elapsed)
local speed = 0.25;

if (interventionEnabled)
then
tIntervention = tIntervention + elapsed;
if (tIntervention > 0 and tIntervention < speed and step == 0)
then
--initialize
interventionImage = CreateFrame('Frame',nil, UIParent);
interventionImage:SetPoint('CENTER', 0,0);
interventionImage:SetFrameStrata("HIGH");
interventionImage:SetSize(800,800);
interventionImageObj = interventionImage:CreateTexture();
interventionImageObj:SetAllPoints();
interventionImageObj:SetAlpha(1);
interventionImageObj:SetTexture('Interface/AddOns/TrashTalk/images/int_1.tga');
interventionImage:Show();


step = step + 1;
elseif (tIntervention > speed and tIntervention < speed*2 and step == 1)
then 
step = step + 1;
interventionImageObj:SetTexture('Interface/AddOns/TrashTalk/images/int_2.tga');
elseif (tIntervention > speed*2 and tIntervention < speed*3 and step == 2)
then
step = step + 1;
interventionImageObj:SetTexture('Interface/AddOns/TrashTalk/images/int_3.tga');
elseif (tIntervention > speed*3 and tIntervention < speed*4 and step == 3)
then
--peak
step = step + 1;
interventionImageObj:SetTexture('Interface/AddOns/TrashTalk/images/int_4.tga');
elseif (tIntervention > speed*4 and tIntervention < speed*5 and step == 4)
then
step = step + 1;
interventionImageObj:SetTexture('Interface/AddOns/TrashTalk/images/int_3.tga');
elseif (tIntervention > speed*5 and tIntervention < speed*6 and step == 5)
then
step = step + 1;
interventionImageObj:SetTexture('Interface/AddOns/TrashTalk/images/int_2.tga');
elseif (tIntervention > speed*6 and tIntervention < speed*7 and step == 6)
then
step = step + 1;
interventionImageObj:SetTexture('Interface/AddOns/TrashTalk/images/int_1.tga');
--last part of sequence
elseif (tIntervention > speed*7)
then
interventionEnabled = false;
interventionImage:Hide();
tIntervention = 0;
step = 0;
end--end switch
end--end if interventionEnabled

end--end handleIntervention
local spinSpeed = 0.25;
local spin = 0;
local direction = 1;
local snoopLoops = 0;
function enableSnoopDogg()
snoopLoops = 0;
snoopDoggEnabled = true;
end
function disableSnoopDogg()
snoopDoggEnabled = false;
snoopDoggImage:Hide();
end
function handleSnoopDogg(elapsed)
if (snoopDoggEnabled == false) then return end;
tSnoopDogg = tSnoopDogg + elapsed;
if (tSnoopDogg > spinSpeed) 
then 
tSnoopDogg = 0;
spin = spin + direction; 
if (spin == 8) then
direction = -1;
spin = 7;
end--end 8
if (spin == -1) then
snoopLoops = snoopLoops + 1;
direction = 1;
spin = 1;
end--end -1
end--end > spin

if (snoopLoops > 3) then disableSnoopDogg(); end

if (snoopDoggImage == nil or snoopDoggImageObj == nil)
then
snoopDoggImage = CreateFrame('Frame',nil, UIParent);
snoopDoggImage:SetPoint("TOPLEFT", backgroundFrame, "TOPLEFT", 0,0);
snoopDoggImage:SetFrameStrata("HIGH");
snoopDoggImage:SetSize(snoopWidth,snoopHeight*1.5);
snoopDoggImageObj = snoopDoggImage:CreateTexture();
snoopDoggImageObj:SetAllPoints();
snoopDoggImageObj:SetAlpha(1);
end--end if nil

if (spin == 0)
then
--initialize if nil

snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop1.tga');
snoopDoggImage:Show();
elseif (spin == 1)
then 
snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop2.tga');
elseif (spin == 2)
then
snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop3.tga');
elseif (spin == 3)
then
snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop4.tga');
elseif (spin == 4)
then
snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop5.tga');
elseif (spin == 5)
then
snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop6.tga');
elseif (spin == 6)
then
snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop7.tga');
elseif (spin == 7)
then
snoopDoggImageObj:SetTexture('Interface/AddOns/TrashTalk/images/snoop8.tga');
end--end switch


end--end handleSnoopDogg

local firstTime = true;
function TrashTalk_OnUpdate(self, elapsed)
local temp =  UIParent:GetEffectiveScale();
if (firstTime) then--do on-load sensitive stuff
firstTime = false;
CreateOptions();
end
handleSnoopDogg(elapsed);
handleHitmarkers(elapsed);
handleOhBabyATriple(elapsed);
handleIntervention(elapsed);
handleJukes(elapsed);
playerIsInArena = IsActiveBattlefieldArena();

--detect players on first sight
if (playerIsInArena and (enemy1['exists'] == false or enemy1['name'] == 'Unknown'))--if i want to write to it
then
if (UnitExists("arena1")) then 
enemy1['exists'] = true;
enemy1['name'], enemy1['realm'] = UnitName("arena1");
if (UnitFactionGroup('arena1') ~= playersFaction) then
enemy1['name'] = "" .. enemyFaction .. " :-(";--they are the other faction and cannot be whispered.
enemy1['realm'] = '';
elseif (TrashTalkOptions["SendUponSight"] == true and enemy1['name'] ~= 'Unknown') then
if (enemy1['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy1['name']);
else
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy1['name'] .. '-' .. enemy1['realm']);
end

end--end not faction
enemy1["class"] = UnitClass("arena1");
manageFrames(false,false);
end--end exists
end--end 1

if (playerIsInArena and (enemy2['exists'] == false or enemy2['name'] == 'Unknown'))--if i want to write to it
then
if (UnitExists("arena2")) then 
enemy2['exists'] = true;
enemy2['name'], enemy2['realm'] = UnitName("arena2");
if (UnitFactionGroup('arena2') ~= playersFaction) then
enemy2['name'] = "" .. enemyFaction .. " :-(";--they are the other faction and cannot be whispered.
enemy2['realm'] = '';
elseif (TrashTalkOptions["SendUponSight"] == true and enemy2['name'] ~= 'Unknown') then
if (enemy2['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy2['name']);
else
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy2['name'] .. '-' .. enemy2['realm']);
end
end--end not faction
enemy2["class"] = UnitClass("arena2");
manageFrames(false,false);
end--end exists
end--end 2

if (playerIsInArena and (enemy3['exists'] == false or enemy3['name'] == 'Unknown'))--if i want to write to it
then
if (UnitExists("arena3")) then 
enemy3['exists'] = true;
enemy3['name'], enemy3['realm'] = UnitName("arena3");
if (UnitFactionGroup('arena3') ~= playersFaction) then
enemy3['name'] = "" .. enemyFaction .. " :-(";--they are the other faction and cannot be whispered.
enemy3['realm'] = '';
elseif (TrashTalkOptions["SendUponSight"] == true and enemy3['name'] ~= 'Unknown') then
if (enemy3['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy3['name']);
else
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy3['name'] .. '-' .. enemy3['realm']);
end
end--end not faction
enemy3["class"] = UnitClass("arena3");
manageFrames(false,false);
end--end exists
end--end 3

if (playerIsInArena and (enemy4['exists'] == false or enemy4['name'] == 'Unknown'))--if i want to write to it
then
if (UnitExists("arena4")) then 
enemy4['exists'] = true;
enemy4['name'], enemy4['realm'] = UnitName("arena4");
if (UnitFactionGroup('arena4') ~= playersFaction) then
enemy4['name'] = "" .. enemyFaction .. " :-(";--they are the other faction and cannot be whispered.
enemy4['realm'] = '';
elseif (TrashTalkOptions["SendUponSight"] == true and enemy4['name'] ~= 'Unknown') then
if (enemy4['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy4['name']);
else
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy4['name'] .. '-' .. enemy4['realm']);
end

end--end not faction
enemy4["class"] = UnitClass("arena4");
manageFrames(false,false);
end--end exists
end--end 4
if (playerIsInArena and (enemy5['exists'] == false or enemy5['name'] == 'Unknown'))--if i want to write to it
then
if (UnitExists("arena5")) then 
enemy5['exists'] = true;
enemy5['name'], enemy5['realm'] = UnitName("arena5");
if (UnitFactionGroup('arena5') ~= playersFaction) then
enemy5['name'] = "" .. enemyFaction .. " :-(";--they are the other faction and cannot be whispered.
enemy5['realm'] = '';
elseif (TrashTalkOptions["SendUponSight"] == true and enemy5['name'] ~= 'Unknown') then
if (enemy5['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy5['name']);
else
SendTrashTalkMessage(TrashTalkOptions["SendUponSightText"], "WHISPER", nil, enemy5['name'] .. '-' .. enemy5['realm']);
end

end--end not faction
enemy5["class"] = UnitClass("arena5");
manageFrames(false,false);
end--end exists
end--end 5



end--end TrashTalk_OnUpdate

--localInstanceType is used just for this method. all others should use instanceType
local localInstanceType = "probably_not_arena";
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
initializeEnemies();
manageFrames(true, false);
end--end TrashTalk_JoinedArena
function TrashTalk_LeftArena()
manageFrames(false,true);
end--end TrashTalk_LeftArena


function buttonOnePressed()
fixPresets();
clicked1 = true;

if (enemy1['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy1['name']);
else
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy1['name'] .. '-' .. enemy1['realm']);
end
arenaButtonClicked(arena1frame);
end--end buttonOnePressed

function buttonTwoPressed()
fixPresets();
clicked2 = true;
if (enemy2['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy2['name']);
else
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy2['name'] .. '-' .. enemy2['realm']);
end
arenaButtonClicked(arena2frame);
end--end buttonTwoPressed

function buttonThreePressed()
fixPresets();
clicked3 = true;
if (enemy3['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy3['name']);
else
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy3['name'] .. '-' .. enemy3['realm']);
end
arenaButtonClicked(arena3frame);
end--end buttonThreePressed

function buttonFourPressed()
fixPresets();
clicked4 = true;

if (enemy4['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy4['name']);
else
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy4['name'] .. '-' .. enemy4['realm']);
end
arenaButtonClicked(arena4frame);
end--end buttonFourPressed

function buttonFivePressed()
fixPresets();
clicked5 = true;

if (enemy5['realm'] == nil) then--they are on the same realm as player 
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy5['name']);
else
SendTrashTalkMessage(currentPreset, "WHISPER", nil, enemy5['name'] .. '-' .. enemy5['realm']);
end
arenaButtonClicked(arena5frame);
end--end buttonFivePressed

--to be called from the three button functions
function arenaButtonClicked(fureemu)
tOhBabyATriple = 0;

if (TrashTalkOptions["Hitmarker"] == true) then
PlaySoundFile('Interface\\AddOns\\TrashTalk\\sounds\\Hitmarker_Volume_3.mp3', 'Master');
if (hitMarkerEnabled == true) then 
hitMarkerImage:Hide();
 end; --dont make duplicates
tHitMarker = 0;
hitmarkerX = 4 + math.random(buttonWidth - 8)
hitMarkerEnabled = true;
--also play the sound
PlaySoundFile('Interface\\AddOns\\TrashTalk\\sounds\\Hitmarker_Volume_3.mp3', 'Master');

hitMarkerImage = CreateFrame('Frame',nil, UIParent);

hitMarkerImage:SetPoint('LEFT',fureemu,'LEFT',hitmarkerX,0);
hitMarkerImage:SetFrameStrata("HIGH");
hitMarkerImage:SetSize(32,32);

hitMarkerImageObj = hitMarkerImage:CreateTexture();
hitMarkerImageObj:SetAllPoints();
hitMarkerImageObj:SetAlpha(1);
hitMarkerImageObj:SetTexture('Interface/AddOns/TrashTalk/images/Le_Perfect_Hitmarker.tga');
hitMarkerImage:Show();
end--end TrashTalkOptions["Hitmarker"] true
end--end function arenaButtonClicked



function backgroundFrame:OnDragStart(self,...)
--backgroundFrame:startMoving();
end
function backgroundFrame:OnDragStop(self,...)

end
function backgroundFrame:OnMouseDown(...)
end

