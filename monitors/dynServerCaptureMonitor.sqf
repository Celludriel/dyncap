/*
	_eventScripts format:
		[
			[Capture scripts],
			[Captured succes scripts],
			[Capture cancelled scripts]
		]
*/
diag_log format ["Calling dynServerCaptureMonitor.sqf"];

if (!isServer) exitWith {};

params ["_captureObject", "_radius", "_captureTime", ["_eventScripts", [[],[],[]]]];

_captureEvents = _eventScripts select 0;
_capturedEvents = _eventScripts select 1;
_cancelEvents = _eventScripts select 2;

// mark that a script is using the object
_captureObject setVariable ["isUsed", true, true];

// server handles all the capture logic
_capturePosition = getPos _captureObject;
_previousActivatorsCount = 0;

while { alive _captureObject } do {
	_activators = _capturePosition nearEntities [["CaManBase"], _radius * 2];

	// see if there are enemy activators
	_currentOwner = _captureObject getVariable "side";
	_hasEnemyActivators = false;
	{
		if(side _x != _currentOwner) exitWith { _hasEnemyActivators = true };
	} foreach _activators;

	if(_hasEnemyActivators) then {
		_doCaptureLoop = true;

		// start the capture loop logic
		_timeHeld = 0;
		_lastTimeCheck = time;
		_lastSideWithSuperiorNumbers = _currentOwner;
		_previousActivatorsCount = count _activators;

		while {_doCaptureLoop} do {
			// count which side has superior numbers
			_sideWithSuperiorNumbers = [_activators,_currentOwner] call DynCap_fnc_dynCapFindSideWithSuperiorNumbers;
			//diag_log format ["_sideWithSuperiorNumbers [%1]", _sideWithSuperiorNumbers];

			if(_sideWithSuperiorNumbers == _lastSideWithSuperiorNumbers && _sideWithSuperiorNumbers != _currentOwner) then {
				//diag_log format ["Capturing"];

				{
					[_captureObject] execVm _x
				} forEach _captureEvents;

				_captureObject setVariable ["isBeingCaptured", true, true];

				// calculate the time held
				_currentTime = time;
				_timeHeld = _timeHeld + ( _currentTime - _lastTimeCheck );
				_captureObject setVariable ["timeHeld", _timeHeld, true];

				_lastTimeCheck = _currentTime;
				_lastSideWithSuperiorNumbers = _sideWithSuperiorNumbers;

				if(_timeHeld >= _captureTime) then {
					//diag_log format ["Captured"];

					{
						[_captureObject] execVm _x
					} forEach _capturedEvents;

					// the capture succeeded set new owner
					_captureObject setVariable ["isBeingCaptured", false, true];
					_captureObject setVariable ["timeHeld", 0, true];
					_captureObject setVariable ["side", _sideWithSuperiorNumbers, true];

					// switch color marker
					_marker = _captureObject getVariable "marker";
					switch(_sideWithSuperiorNumbers) do {
						case west : {_marker setMarkerColor "ColorBLUFOR";};
						case east : {_marker setMarkerColor "ColorOPFOR";};
						default {_marker setMarkerColor "ColorBlack";};
					};

					_doCaptureLoop = false;
					_captureObject setVariable ["isUsed", false, true];
				};
			} else {
				if(_sideWithSuperiorNumbers == _currentOwner) then {
					//diag_log format ["Stop Capturing"];

					{
						[_captureObject] execVm _x
					} forEach _cancelEvents;

					// the owner is back in the majority stop any capturing
					_captureObject setVariable ["isBeingCaptured", false, true];
					_doCaptureLoop = false;
					_captureObject setVariable ["isUsed", false, true];
					_captureObject setVariable ["timeHeld", 0, true];
				} else {
					//diag_log format ["Reset Capturing"];

					{
						[_captureObject] execVm _x
					} forEach _cancelEvents;

					// new side is getting the upper hand reset timer for that side
					_timeHeld = 0;
					_captureObject setVariable ["timeHeld", 0, true];
					_lastTimeCheck = time;
					_lastSideWithSuperiorNumbers = _sideWithSuperiorNumbers;
				};
			};

			//fetch new situation
			_activators = _capturePosition nearEntities [["CaManBase"], _radius * 2];
			if(count _activators == 0 && _previousActivatorsCount > 0) then {
				//diag_log format ["Resetting everything"];

				{
					[_captureObject] execVm _x
				} forEach _cancelEvents;

				_previousActivatorsCount = 0;
				_doCaptureLoop = false;
				_captureObject setVariable ["isBeingCaptured", false, true];
				_captureObject setVariable ["timeHeld", 0, true];
			};
			sleep 1;
		};
	};
	sleep 1;
};