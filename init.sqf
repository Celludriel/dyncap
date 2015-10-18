if (!isServer) exitWith {};

_captureBuilding = [(getMarkerPos "spawn_position"),5,"Land_Cargo_Patrol_V1_F", 60] call compileFinal preprocessFileLineNumbers "dyncap\createCaptureLocation.sqf";