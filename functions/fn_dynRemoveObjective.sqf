params["_captureObject"];

waitUntil { sleep 0.1; !(_captureObject getVariable "isUsed") };

_marker = _captureObject getVariable "marker";
_trigger = _captureObject getVariable "trigger";

deleteMarker _marker;
deleteVehicle _trigger;
deleteVehicle _captureObject;