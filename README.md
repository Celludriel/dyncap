# dyncap
Dynamic capture point spawner

This script will spawn at a given location a building or object that a player or ai can capture for their side.  An objective icon will spawn on the map with the color of the currently owning side.  Capture can only be done by on foot infantry.  There are other implementations where vehicles can capture as well but this decreases the challenge rating of capturing a point.  This was a creative decision of mine, I might make it parameterizable if wanted or you can fork my work and do it yourself.

Usage:

- Copy the dyncap folder to your mission root
- Copy or extend your Description.ext with the one in this distribution
- Use following line to spawn an objective:

Syntax:
    objective = [position, radius, objectType, captureTime] setMarkerColor color
Parameters:
    position: Array - format Position2D
    radius: Number. radius of capture zone
    objectType: String
    captureTime: Number. time in seconds
Return Value:
    Object: the spawned object to capture

_captureBuilding = [(getMarkerPos "spawn_position"),5,"Land_Cargo_Patrol_V1_F", 60] call compileFinal preprocessFileLineNumbers "dyncap\createCaptureLocation.sqf";

Object variables that can be referenced

"isBeingCaptured": Boolean - is the object currently being captured
"owner": Side - who currently owns the object
"marker": String - name of the marker