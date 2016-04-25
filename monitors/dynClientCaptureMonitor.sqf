diag_log format ["Calling dynClientCaptureMonitor.sqf"];

if (isDedicated) exitWith {};

params ["_captureObject", "_radius", "_captureTime"];

_capturePosition = getPos _captureObject;

waitUntil {!isNull player};

while { alive _captureObject } do {

	_activators = _capturePosition nearEntities [["CaManBase"], _radius * 2];

	if(count _activators > 0) then {
		{
			if(_x == player) then {
				disableSerialization;

				_isBeingCaptured = _captureObject getVariable "isBeingCaptured";
				_barActive = false;
				_progressBar = nil;

				if(_isBeingCaptured && !_barActive) then {
					// show progressbar
					diag_log format ["Showing capture bar [%1 - %2]", _isBeingCaptured, _barActive];
					("CapProgressBarLayer" call BIS_fnc_rscLayer) cutRsc ["CapProgressBar", "PLAIN", 0.001, false];
					_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);
					_barActive = true;
				};

				diag_log format ["Start bar update loop with [%1 - %2]", _isBeingCaptured, (player distance _captureObject <= (_radius * 2))];
				while {_isBeingCaptured && (player distance _captureObject <= (_radius * 2))} do {
					_timeHeld = _captureObject getVariable "timeHeld";
					// update progressbar
					_progressBar progressSetPosition (_timeHeld / _captureTime);
					_isBeingCaptured = _captureObject getVariable "isBeingCaptured";
					sleep 1;
				};

				// the bar was active remove it
				if(_barActive) then {
					diag_log format ["Resetting capture bar [%1]", _barActive];
					[] call DynCap_fnc_dynCapResetProgressBar;
				};
			};
		} forEach _activators;
	};
	sleep 1;
};