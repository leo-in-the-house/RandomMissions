require 'common'
require 'mission_gen'

local moonlit_courtyard = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function moonlit_courtyard.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_moonlit_courtyard")
  

end

function moonlit_courtyard.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function moonlit_courtyard.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function moonlit_courtyard.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_moonlit_courtyard result "..tostring(result).." segment "..tostring(segmentID))
  
  --first check for rescue flag; if we're in rescue mode then take a different path
  MISSION_GEN.EndOfDay(result, segmentID)
COMMON.SidequestExitDungeonMissionCheck(result, zone.ID, segmentID)
COMMON.ExitDungeonMissionCheck(result, zone.ID, segmentID)
  if rescue == true then
    COMMON.EndRescue(zone, result, segmentID)
  elseif segmentID == 2 then
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
	  SV.moonlit_end.BattleComplete = true
	else
	  SV.moonlit_end.BattleFailed = true
	end
    GAME:EnterZone('moonlit_courtyard', -1, 0, 0)
  elseif SV.TemporaryFlags.MissionCompleted then
      COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 2, 0)
  elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
  else
    if segmentID == 0 then
      COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 3, 2)
    elseif segmentID == 1 then
      GAME:EnterZone('moonlit_courtyard', -1, 0, 0)
    else
      PrintInfo("No exit procedure found!")
	  COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
    end
  end
  
end

return moonlit_courtyard
