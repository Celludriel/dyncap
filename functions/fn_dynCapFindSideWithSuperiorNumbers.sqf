params ["_activators", "_currentOwner"];

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

_sideWithSuperiorNumbers