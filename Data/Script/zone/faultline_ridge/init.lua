require 'common'
require 'mission_gen'

local faultline_ridge = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function faultline_ridge.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_faultline_ridge")
  

end

function faultline_ridge.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function faultline_ridge.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function faultline_ridge.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_faultline_ridge result "..tostring(result).." segment "..tostring(segmentID))
  
  --first check for rescue flag; if we're in rescue mode then take a different path
  MISSION_GEN.EndOfDay(result, segmentID)
  COMMON.SidequestExitDungeonMissionCheck(result, zone.ID, segmentID)
  COMMON.ExitDungeonMissionCheck(result, zone.ID, segmentID)
  if rescue == true then
    COMMON.EndRescue(zone, result, segmentID)
  elseif SV.TemporaryFlags.MissionCompleted then
    COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 2, 0)
  elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
  else
    if segmentID == 0 then
      COMMON.UnlockWithFanfare('trickster_woods', true)
      COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 3, 0)
    else
      PrintInfo("No exit procedure found!")
	  COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
    end
  end
  
end

return faultline_ridge
