if (!isServer) exitWith {};

diag_log format ["Calling leaveCaptureAlgo.sqf"];

disableSerialization;

_trigger = _this select 0;
_buildingType = _this select 1;
_radius = _this select 2;

// find the object that needs to be captured
_captureObject = nearestObject [_trigger, _buildingType];

// mark that a script is using the object
_captureObject setVariable ["isUsed", true, true];

_capturePosition = getPos _captureObject;

diag_log format ["captureObject: %1, capturePosition: %2", _captureObject, _capturePosition];

// get the current owner
_currentOwner = _captureObject getVariable "owner";

diag_log format ["currentOwner: %1", _currentOwner];

// if this object is not being captured we can exit nothing has to be done
if (!(_captureObject getVariable "isBeingCaptured")) exitWith {};

// count which side has superior numbers
_activators = _capturePosition nearEntities [ "CaManBase", _radius ];
_sideWithSuperiorNumbers = [_activators,_currentOwner] call dynCapFindSideWithSuperiorNumbers;

diag_log format ["sideWithSuperiorNumbers: %1", _sideWithSuperiorNumbers];

if(_sideWithSuperiorNumbers == _currentOwner) then {
	diag_log format ["Owner back superior after leaving trigger ending capture"];
	_captureObject setVariable ["isBeingCaptured", false, true];
};

_captureObject setVariable ["isUsed", false, true];