# dyncap
Dynamic capture point spawner

This script will spawn at a given location a building or object that a player or ai can capture for their side.  An objective icon will spawn on the map with the color of the currently owning side.  Capture can only be done by on foot infantry.  There are other implementations where vehicles can capture as well but this decreases the challenge rating of capturing a point.  This was a creative decision of mine, I might make it parameterizable if wanted or you can fork my work and do it yourself.

Usage:

- Copy the dyncap folder to any place in your mission folder
- Update config.sqf to the path you placed dyncap
- Copy or extend your Description.ext with the one in this distribution
- Put the following in init.sqf: [] execVM "dyncap\config.sqf";
- Use following line to spawn an objective:

<p>
<b>Syntax:</b><br>
    &emsp;_capturableObject = [position, radius, objectType, captureTime, side] call DYNCAP_fnc_createCaptureLocation;
    <p>or<p>
    &emsp;_capturableObject = [position, radius, objectType, captureTime, side, markerType] call DYNCAP_fnc_createCaptureLocation;
    <p>or<p>
    &emsp;_capturableObject = [position, radius, objectType, captureTime, side, markertype, _eventScripts] call DYNCAP_fnc_createCaptureLocation;
<p>
<b>Parameters:</b><br>
    &emsp;position: Array - format Position2D<br>
    &emsp;radius: Number. radius of capture zone<br>
    &emsp;objectType: String<br>
    &emsp;captureTime: Number. time in seconds<br>
    &emsp;side: Side. side the object originaly belongs to<p>
    &emsp;markerType: String. type of ICON to show on the map<p>
    &emsp;eventscripts: Array.  _eventScripts format:<br>
        [<br>
            [Capture scripts],             --- Scripts to run while capturing<br>
            [Captured succes scripts],     --- Scripts to run when capture is a success<br>
            [Capture cancelled scripts]    --- Scripts to run when a capture for any reason cancels<br>
        ]<p>
<b>Return Value:</b><br>
    &emsp;Object: the spawned object to capture<p>
<b>Example:</b><br>

_eventScripts = [<br>
    ["core\server\ai\rushToCaptureLocation.sqf"],<br>
    [],<br>
    ["core\server\ai\spreadOut.sqf"]<br>
];<br><br>
_capture_capturableObject = [_location, "Flag_Green_F", 5, 300, east, nil, _eventScripts] call DYNCAP_fnc_createCaptureLocation;
<p>
<b>Object variables that can be referenced:</b><br>
<br>
"isBeingCaptured": Boolean - is the object currently being captured<br>
"owner": Side - who currently owns the object<br>
"marker": String - name of the marker<p>
<b>Sever side helpers</b><br>
[objective] call pDynRemoveObjective; - removes a spawned objective