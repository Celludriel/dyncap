if (!isServer) exitWith {};

_location = _this select 0;
_captureRadius = _this select 1;
_buildingType = _this select 2;

_markerName = format ["dyncap_marker_%1", round(random 1000)];
while { getMarkerColor _markerName != "" } do {
	_markerName = format ["dyncap_marker_%1", round(random 1000)];
};

_marker = createMarker [_markerName, _location];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_objective";
_marker setMarkerSize [0.50, 0.50];
_marker setMarkerColor "ColorRed";

_captureBuilding = _buildingType createVehicle _location;
_captureBuilding setVariable ["isBeingCaptured", false, true];
_captureBuilding setVariable ["owner", east, true];
_captureBuilding setVariable ["marker", _marker, true];

_captureTrigger = createTrigger ["EmptyDetector", _location, true];
_captureTrigger setTriggerArea [_captureRadius, _captureRadius, 0, false];
_captureTrigger setTriggerActivation ["ANY", "PRESENT", true];

_triggerOnAct = format ["[thisTrigger, '%1', %2] execVM 'dyncap\enterCaptureAlgo.sqf'", _buildingType, _captureRadius];
_triggerOnLeave = format ["[thisTrigger, '%1', %2] execVM 'dyncap\leaveCaptureAlgo.sqf'", _buildingType, _captureRadius];

_captureTrigger setTriggerStatements ["this && ({(_x isKindOf 'CAManBase')} count thislist) > 0", _triggerOnAct, _triggerOnLeave];

_captureBuilding