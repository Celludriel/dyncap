if (!isServer) exitWith {};

diag_log format ["Calling leaveCaptureAlgo.sqf"];

_trigger = _this select 0;
_buildingType = _this select 1;
_radius = _this select 2;

// find the object that needs to be captured
_captureObject = nearestObject [_trigger, _buildingType];
_capturePosition = getPos _captureObject;

diag_log format ["captureObject: %1, capturePosition: %2", _captureObject, _capturePosition];

// get the current owner
_currentOwner = _captureObject getVariable "owner";

diag_log format ["currentOwner: %1", _currentOwner];

// if this object is not being captured we can exit nothing has to be done
if (!(_captureObject getVariable "isBeingCaptured")) exitWith {};

// count which side has superior numbers
_activators = _capturePosition nearEntities [ "CaManBase", _radius ];
_sideCounters = [[west, 0],[east, 0],[independent, 0]];
{
	_activatorSide = side _x;
	_sideCounterIndex = switch(_activatorSide) do{
		case west : {0};
		case east : {1};
		default {2};
	};
	_counter = _sideCounters select _sideCounterIndex;
	_sideCounters set [_sideCounterIndex, [_activatorSide, ((_counter select 1)+1)]];
} forEach _activators;

diag_log format ["sideCounters: %1", _sideCounters];

// find the side with superior numbers
_sideWithSuperiorNumbers = _currentOwner;
_currentMax = 0;
{
	_count = _x select 1;
	if(_count > _currentMax) then {
		_currentMax = _count;
		_sideWithSuperiorNumbers = _x select 0;
	};
} forEach _sideCounters;

diag_log format ["sideWithSuperiorNumbers: %1", _sideWithSuperiorNumbers];

if(_sideWithSuperiorNumbers == _currentOwner) then {
	diag_log format ["Owner back superior after leaving trigger ending capture"];
	_captureBuilding setVariable ["isBeingCaptured", false, true];
	
	// reset progressbar
	("CapProgressBarLayer" call BIS_fnc_rscLayer) cutFadeOut 0;
	_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);
	_progressBar progressSetPosition 0;	
};