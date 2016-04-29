if (!isServer) exitWith {};

[] execVM "dyncap\config.sqf";

captureBuilding1 = [(getMarkerPos "spawn_position_1"), "Land_Cargo_Patrol_V1_F", 60, 300, east] call DYNCAP_fnc_createCaptureLocation;
captureBuilding2 = [(getMarkerPos "spawn_position_2"), "Land_Cargo_Patrol_V1_F", 60, 300, west] call DYNCAP_fnc_createCaptureLocation;