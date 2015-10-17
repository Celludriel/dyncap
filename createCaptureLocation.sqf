if (!isServer) exitWith {};

_location = getMarkerPos (_this select 0);
_captureRadius = _this select 1;
_buildingType = _this select 2;

_captureBuilding = _buildingType createVehicle _location;
_captureBuilding setVariable ["isBeingCaptured", false, true];
_captureBuilding setVariable ["owner", east, true];

_captureTrigger = createTrigger ["EmptyDetector", _location, true];
_captureTrigger setTriggerArea [_captureRadius, _captureRadius, 0, false];
_captureTrigger setTriggerActivation ["ANY", "PRESENT", true];

_triggerOnAct = format ["[thisTrigger, '%1', %2] execVM 'enterCaptureAlgo.sqf'", _buildingType, _captureRadius];
_triggerOnLeave = format ["[thisTrigger, '%1', %2] execVM 'leaveCaptureAlgo.sqf'", _buildingType, _captureRadius];

_captureTrigger setTriggerStatements ["this", _triggerOnAct, _triggerOnLeave];