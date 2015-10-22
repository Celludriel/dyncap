if (!isServer) exitWith {};

captureBuilding1 = [(getMarkerPos "spawn_position_1"),5,"Land_Cargo_Patrol_V1_F", 60, east] call compileFinal preprocessFileLineNumbers "dyncap\createCaptureLocation.sqf";
captureBuilding2 = [(getMarkerPos "spawn_position_2"),5,"Land_Cargo_Patrol_V1_F", 60, east] call compileFinal preprocessFileLineNumbers "dyncap\createCaptureLocation.sqf";