("CapProgressBarLayer" call BIS_fnc_rscLayer) cutFadeOut 0;
_progressBar = ((uiNamespace getVariable "CapProgressBar") displayCtrl 22202);
if(!(isNil "_progressBar")) then {
	_progressBar progressSetPosition 0;
};