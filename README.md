# dyncap
Dynamic capture point spawner

This script will spawn at a given location a building or object that a player or ai can capture for their side.  An objective icon will spawn on the map with the color of the currently owning side.  Capture can only be done by on foot infantry.  There are other implementations where vehicles can capture as well but this decreases the challenge rating of capturing a point.  This was a creative decision of mine, I might make it parameterizable if wanted or you can fork my work and do it yourself.

Usage:

- Copy the dyncap folder to your mission root
- Copy or extend your Description.ext with the one in this distribution
- Use following line to spawn an objective:
<p>
<b>Syntax:</b><br>
    &emsp;objective = [position, radius, objectType, captureTime, side] call compileFinal preprocessFileLineNumbers "dyncap\createCaptureLocation.sqf"<p>
<b>Parameters:</b><br>
    &emsp;position: Array - format Position2D<br>
    &emsp;radius: Number. radius of capture zone<br>
    &emsp;objectType: String<br>
    &emsp;captureTime: Number. time in seconds<br>
    &emsp;side: Side. side the object originaly belongs to<p>
<b>Return Value:</b><br>
    &emsp;Object: the spawned object to capture<p>
<b>Example:</b><br>
_captureBuilding = [(getMarkerPos "spawn_position"),5,"Land_Cargo_Patrol_V1_F", 60, east] call compileFinal preprocessFileLineNumbers "dyncap\createCaptureLocation.sqf";
<p>
<b>Object variables that can be referenced:</b><br>
<br>
"isBeingCaptured": Boolean - is the object currently being captured<br>
"owner": Side - who currently owns the object<br>
"marker": String - name of the marker<p>
<b>Sever side helpers</b><br>
[objective] call pDynRemoveObjective; - removes a spawned objective
<p>
<b>Change Log</b><br>
v1.0.0<br>
&emsp;first release<br>
v1.0.1<br>
&emsp;fixed bug with local server not showing the progressbar<br>