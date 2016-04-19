if (!isServer) exitWith {};

params ["_location", "_captureRadius", "_buildingType", "_captureTime", "_side", ["_markerType", "mil_objective"]];

private ["_markerName", "_marker"];

// handle marker or position location
if(typeName _location == "ARRAY") then {
	_markerName = format ["dyncap_marker_%1", round(random 1000)];
	while { getMarkerColor _markerName != "" } do {
		_markerName = format ["dyncap_marker_%1", round(random 1000)];
	};
	_marker = createMarker [_markerName, _location];
};

if(typeName _location == "STRING") then {
	_markerName = _location;
	_location = getMarkerPos _location;
};

// setup marker
_markerName setMarkerShape "ICON";
_markerName setMarkerType _markerType;
_markerName setMarkerSize [0.50, 0.50];
if(_side == EAST) then {
	_markerName setMarkerColor "ColorOPFOR";
} else {
	_markerName setMarkerColor "ColorBLUFOR";
};

// create capture object
_captureBuilding = _buildingType createVehicle _location;
waitUntil {alive _captureBuilding};

_captureBuilding allowDamage false;
_captureBuilding setVariable ["isBeingCaptured", false, true];
_captureBuilding setVariable ["owner", _side, true];
_captureBuilding setVariable ["marker", _markerName, true];

// spawn server thread
[_captureBuilding, _captureRadius, _captureTime] execVM (DYNCAP_PATH + "dynServerCaptureMonitor.sqf");

// spawn client threads
// [[[_captureBuilding,_captureRadius,_captureTime],"dyncap\dynClientCaptureMonitor.sqf"],"BIS_fnc_execVM",true,true] call BIS_fnc_MP;
[[_captureBuilding, _captureRadius, _captureTime], (DYNCAP_PATH + "dynClientCaptureMonitor.sqf")] remoteExec ["execVM", -2, true];

_captureBuilding