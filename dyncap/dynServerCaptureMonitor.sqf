diag_log format ["Calling dynServerCaptureMonitor.sqf"];

if (!isServer) exitWith {};

_captureObject = _this select 0;
_radius = _this select 1;
_captureTime = _this select 2;

// mark that a script is using the object
_captureObject setVariable ["isUsed", true, true];

// server handles all the capture logic
_capturePosition = getPos _captureObject;

diag_log format ["captureObject: %1, capturePosition: %2", _captureObject, _capturePosition];

while { alive _captureObject } do {
	_activators = _capturePosition nearEntities [["CaManBase"], _radius * 2];
	diag_log format ["activators: %1", _activators];

	if(count _activators > 0) then {
		diag_log format ["Starting capture logic"];
		_doCaptureLoop = true;

		// get the current owner
		_currentOwner = _captureObject getVariable "owner";

		diag_log format ["currentOwner: %1", _currentOwner];
		// start the capture loop logic
		_timeHeld = 0;
		_lastTimeCheck = time;
		_lastSideWithSuperiorNumbers = _currentOwner;

		while {_doCaptureLoop} do {
			// count which side has superior numbers
			_sideWithSuperiorNumbers = [_activators,_currentOwner] call dynCapFindSideWithSuperiorNumbers;

			diag_log format ["sideWithSuperiorNumbers: %1", _sideWithSuperiorNumbers];
			diag_log format ["lastSideWithSuperiorNumbers: %1", _lastSideWithSuperiorNumbers];

			if(_sideWithSuperiorNumbers == _lastSideWithSuperiorNumbers && _sideWithSuperiorNumbers != _currentOwner) then {
				_captureObject setVariable ["isBeingCaptured", true, true];

				// calculate the time held
				_currentTime = time;
				_timeHeld = _timeHeld + ( _currentTime - _lastTimeCheck );
				_captureObject setVariable ["timeHeld", _timeHeld, true];

				_lastTimeCheck = _currentTime;
				_lastSideWithSuperiorNumbers = _sideWithSuperiorNumbers;

				if(_timeHeld >= _captureTime) then {
					diag_log format ["Object captured"];
					// the capture succeeded set new owner
					_captureObject setVariable ["isBeingCaptured", false, true];
					_captureObject setVariable ["timeHeld", 0, true];
					_captureObject setVariable ["owner", _sideWithSuperiorNumbers, true];

					// switch color marker
					_marker = _captureObject getVariable "marker";
					switch(_sideWithSuperiorNumbers) do {
						case west : {_marker setMarkerColor "ColorBlue";};
						case east : {_marker setMarkerColor "ColorRed";};
						default {_marker setMarkerColor "ColorBlack";};
					};

					_doCaptureLoop = false;
					_captureObject setVariable ["isUsed", false, true];
				};
			} else {
				if(_sideWithSuperiorNumbers == _currentOwner) then {
					// the owner is back in the majority stop any capturing
					diag_log format ["Owner back superior ending capture"];
					_captureObject setVariable ["isBeingCaptured", false, true];
					_doCaptureLoop = false;
					_captureObject setVariable ["isUsed", false, true];
					_captureObject setVariable ["timeHeld", 0, true];
				} else {
					// new side is getting the upper hand reset timer for that side
					diag_log format ["Changing capture side"];
					_timeHeld = 0;
					_captureObject setVariable ["timeHeld", 0, true];
					_lastTimeCheck = time;
					_lastSideWithSuperiorNumbers = _sideWithSuperiorNumbers;
				};
			};
			sleep 1;
		};
	};
	sleep 1;
};