require 'common'
require 'mission_gen'

local trickster_woods = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function trickster_woods.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_trickster_woods")
  

end

function trickster_woods.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function trickster_woods.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function trickster_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_trickster_woods result "..tostring(result).." segment "..tostring(segmentID))
  
  --first check for rescue flag; if we're in rescue mode then take a different path
  MISSION_GEN.EndOfDay(result, segmentID)
COMMON.ExitDungeonMissionCheck(result, zone.ID, segmentID)
  if rescue == true then
    COMMON.EndRescue(zone, result, segmentID)
  elseif SV.TemporaryFlags.MissionCompleted then
    COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 2, 0)
  elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
  else
    if segmentID == 0 then
      COMMON.UnlockWithFanfare('deserted_fortress', true)
      COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 3, 2)
    elseif segmentID == 1 then
      COMMON.UnlockWithFanfare('moonlit_courtyard', true)
      COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 3, 2)
    else
      PrintInfo("No exit procedure found!")
	  COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
    end
  end
  
end

return trickster_woods
