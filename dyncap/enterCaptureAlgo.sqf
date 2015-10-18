if (!isServer) exitWith {};

diag_log format ["Calling enterCaptureAlgo.sqf"];

disableSerialization;

_trigger = _this select 0;
_buildingType = _this select 1;
_radius = _this select 2;
_captureTime = 60;

// find the object that needs to be captured
_captureObject = nearestObject [_trigger, _buildingType];
_capturePosition = getPos _captureObject;

diag_log format ["captureObject: %1, capturePosition: %2", _captureObject, _capturePosition];

// get the current owner
_currentOwner = _captureObject getVariable "owner";

diag_log format ["currentOwner: %1", _currentOwner];

// if this object is already being captured another thread is handling the capture don't spawn a new one
if (_captureObject getVariable "isBeingCaptured") exitWith {};

diag_log format ["Starting capture logic"];

// start the capture loop logic
_timeHeld = 0;
_lastTimeCheck = time;
_lastSideWithSuperiorNumbers = _currentOwner;
_doCaptureLoop = true;
while {_doCaptureLoop} do {

	// count which side has superior numbers
	_activators = _capturePosition nearEntities [["CaManBase"], _radius * 2];

	diag_log format ["activators: %1", _activators];

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
	diag_log format ["lastSideWithSuperiorNumbers: %1", _lastSideWithSuperiorNumbers];

	if(_sideWithSuperiorNumbers == _lastSideWithSuperiorNumbers && _sideWithSuperiorNumbers != _currentOwner) then {
		_captureObject setVariable ["isBeingCaptured", true, true];

		// show progressbar
		("CapProgressBarLayer" call BIS_fnc_rscLayer) cutRsc ["CapProgressBar", "PLAIN", 0.001, false]; // display PROGRESS BAR
		_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);

		// calculate the time held
		_currentTime = time;
		_timeHeld = _timeHeld + ( _currentTime - _lastTimeCheck );

		diag_log format ["timeHeld: %1", _timeHeld];

		// update progressbar
		_progressBar progressSetPosition (_timeHeld / _captureTime);

		_lastTimeCheck = _currentTime;
		_lastSideWithSuperiorNumbers = _sideWithSuperiorNumbers;

		if(_timeHeld >= _captureTime) then {
			diag_log format ["Object captured"];
			// the capture succeeded set new owner
			_captureObject setVariable ["isBeingCaptured", false, true];
			_captureObject setVariable ["owner", _sideWithSuperiorNumbers, true];

			// switch color marker
			_marker = _captureObject getVariable "marker";
			switch(_sideWithSuperiorNumbers) do{
				case west : {_marker setMarkerColor "ColorBlue";};
				case east : {_marker setMarkerColor "ColorRed";};
				default {_marker setMarkerColor "ColorBlack";};
			};

			// reset and hide progressbar
			("CapProgressBarLayer" call BIS_fnc_rscLayer) cutFadeOut 0;
			_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);
			if(!(isNil "_progressBar")) then {
				_progressBar progressSetPosition 0;
			};
			_doCaptureLoop = false;
		};

		// we do not want to overtax the cpu so we sleep each second, this won't impact user experience but saves on cpu resources
		sleep 1;
	} else {
		if(_sideWithSuperiorNumbers == _currentOwner) then {
			// the owner is back in the majority stop any capturing
			diag_log format ["Owner back superior ending capture"];
			_captureObject setVariable ["isBeingCaptured", false, true];
			_doCaptureLoop = false;

			// reset and hide progressbar
			("CapProgressBarLayer" call BIS_fnc_rscLayer) cutFadeOut 0;
			_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);
			if(!(isNil "_progressBar")) then {
				_progressBar progressSetPosition 0;
			}
		} else {
			// new side is getting the upper hand reset timer for that side
			diag_log format ["Changing capture side"];
			_timeHeld = 0;
			_lastTimeCheck = time;
			_lastSideWithSuperiorNumbers = _sideWithSuperiorNumbers;

			// reset and hide progressbar
			("CapProgressBarLayer" call BIS_fnc_rscLayer) cutFadeOut 0;
			_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);
			if(!(isNil "_progressBar")) then {
				_progressBar progressSetPosition 0;
			};
			// we do not want to overtax the cpu so we sleep each second, this won't impact user experience but saves on cpu resources
			sleep 1;
		};
	};
};