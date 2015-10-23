diag_log format ["Calling dynClientCaptureMonitor.sqf"];

if (isDedicated) exitWith {};
[] call compileFinal preprocessFileLineNumbers "dyncap\dyncap_fn.sqf";

_captureObject = _this select 0;
_radius = _this select 1;
_captureTime = _this select 2;
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
					("CapProgressBarLayer" call BIS_fnc_rscLayer) cutRsc ["CapProgressBar", "PLAIN", 0.001, false];
					_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);
					_barActive = true;
				};

				while {_isBeingCaptured && (player distance _captureObject <= (_radius * 2))} do {
					_timeHeld = _captureObject getVariable "timeHeld";
					// update progressbar
					_progressBar progressSetPosition (_timeHeld / _captureTime);
					_isBeingCaptured = _captureObject getVariable "isBeingCaptured";
					sleep 1;
				};

				// the bar was active remove it
				if(_barActive) then {
					[] call dynCapResetProgressBar;
				};
			};
		} forEach _activators;
	};
	sleep 1;
};