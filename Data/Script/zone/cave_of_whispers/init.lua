require 'common'
require 'mission_gen'

local cave_of_whispers = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function cave_of_whispers.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_cave_of_whispers")
  

end

function cave_of_whispers.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function cave_of_whispers.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function cave_of_whispers.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_cave_of_whispers result "..tostring(result).." segment "..tostring(segmentID))
  
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
      COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 6, 0)
    else
      PrintInfo("No exit procedure found!")
	  COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
    end
  end
  
end

return cave_of_whispers
