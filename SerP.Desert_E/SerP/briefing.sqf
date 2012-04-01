#include "const.sqf"
private ["_unitside"];
_unitside = side player;
_JIP = if (time>10) then {true}else{false};
_cred = player createDiaryRecord ["diary", [localize "credits_title",format ["%1 <br/>SerP v%2",localize "credits",getNumber(missionConfigFile >> "SerP_version")]]];
//��������� ������� ������� � �������
_grpText = "";
{
	_show = false;
	_units = units _x;
	_markerName = "SerP_startposMarker"+str _x;
	_tmpText = "<br/>" + (if (_JIP) then {str _x}else{"<marker name = '"+_markerName+"'>"+str _x+"</marker>"});
	{
		if ((alive _x)&&((isPlayer _x)||isServer)&&(side _x == _unitside)) then {
			_tmpText = _tmpText + "<br/>--  " + (name _x);
			{
				_weapon = (configFile >> "cfgWeapons" >> _x);
				if ((getNumber(_weapon >> "type") in [1,4,5])&&!isNil{(getArray(_weapon >> "magazines") select  0)}) then {
					_tmpText = _tmpText + "  -  " + getText(_weapon >> "displayName");
				};
			} forEach weapons(_x);
			_show = true;
		};
	} forEach _units;
	if _show then {
		if (markerPos(_markerName) select 0 == 0) then {
			createMarkerLocal [_markerName, getPos leader _x];
		};
		if (!_JIP) then {
			_markerName setMarkerTypeLocal "Start";
			_markerName setMarkerTextLocal str(_x);
			_markerName setMarkerColorLocal "ColorGreen";
			_grpText = _grpText + _tmpText + "<br/>";
		};
	};
} forEach allGroups;

_vehText = "<br/><br/>";
_side = side player;
_index = switch _side do {
	case east: {0};
	case west: {1};
	case resistance: {2};
	case civilian: {3};
};
if (!isNil{SerP_markerCount}) then {
	_count = SerP_markerCount select _index;
	for "_i" from 0 to _count do {
		_name = "SerP_marker"+str(_side) + str(_i);
		_name setMarkerAlphaLocal 1;
		_vehText = _vehText + "<marker name = '"+_name+"'>"+markerText _name+"</marker><br/>";
	};
}else{
	_i = 0;
	_flag = true;
	while {_flag} do {
		_name = "SerP_marker"+str(_side) + str(_i);
		_pos = getMarkerPos _name;
		if (_pos select 0 == 0 && _pos select 1 == 0) then {
			_flag = false;
		}else{
			_name setMarkerAlphaLocal 1;
			_vehText = _vehText + "<marker name = '"+_name+"'>"+markerText _name+"</marker><br/>";
			_i = _i + 1;
		};
	};
};


_groups = player createDiaryRecord ["diary", [localize "groups_title",_grpText]];

//����������, ���� �� ����
if (localize "convent" != "") then {_cond = player createDiaryRecord ["diary", [localize "convent_title",localize "convent"]];};
//������ �� �������� ������

_hour = date select 3;
_time = switch true do {
	case (_hour>=21||_hour<4): {localize "STR_timeOfDay_Option7"};
	case (_hour<5): {localize "STR_timeOfDay_Option0"};
	case (_hour<8): {localize "STR_timeOfDay_Option1"};
	case (_hour<10): {localize "STR_timeOfDay_Option2"};
	case (_hour<14): {localize "STR_timeOfDay_Option3"};
	case (_hour<16): {localize "STR_timeOfDay_Option4"};
	case (_hour<18): {localize "STR_timeOfDay_Option5"};
	case (_hour<21): {localize "STR_timeOfDay_Option6"};
	default {localize "STR_timeOfDay_Option8"};
};

_weather = switch true do {
	case (overcast>0.9): {localize "STR_weather_Option4"};
	case (overcast<0.1): {localize "STR_weather_Option0"};
	case (overcast>0.1): {localize "STR_weather_Option1"};
	case (fog>0.9): {localize "STR_weather_Option3"};
	case (fog>0.5): {localize "STR_weather_Option2"};
	default {localize "STR_weather_Option5"};
};


_weather = player createDiaryRecord ["diary", [localize "STR_weather",
format [localize "STR_timeOfDay" + " - %1<br/>" + localize "STR_weather" + " - %2",_time,_weather]
]];
//������, ���������� � �������� ������
switch true do {
	case (_unitside == east): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		}} forEach [
			[localize "machinery_title",(localize "machinery_rf")+_vehText],
			[localize "enemy_title",localize "enemy_rf"],
			[localize "execution_title",localize "execution_rf"],
			[localize "task_title",localize "task_rf"],
			[localize "situation_title",localize "situation_rf"]
		];
	};
	case (_unitside == west): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		};} forEach [
			[localize "machinery_title",(localize "machinery_bf")+_vehText],
			[localize "enemy_title",localize "enemy_bf"],
			[localize "execution_title",localize "execution_bf"],
			[localize "task_title",localize "task_bf"],
			[localize "situation_title",localize "situation_bf"]
		];
	};
	case (_unitside == resistance): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		};} forEach [
			[localize "machinery_title",(localize "machinery_guer")+_vehText],
			[localize "enemy_title",localize "enemy_guer"],
			[localize "execution_title",localize "execution_guer"],
			[localize "task_title",localize "task_guer"],
			[localize "situation_title",localize "situation_guer"]
		];
	};
	default {//������
		_mis = player createDiaryRecord ["diary", [localize "situation_title", localize "situation_tv"]];
	};
};

if !_JIP then {[] spawn {
	_waitTime = time + 90;
	waitUntil{sleep 1;
		!isNil{warbegins}||(time>_waitTime)
	};
	if isNil{warbegins} exitWith {};
	if (warbegins==1) exitWith {};
	sleep 10;
	{if (side(_x)==side(player)) then {
		_markerName = "SerP_startposMarker"+str _x;
		_markerName setMarkerTypeLocal "Start";
		_markerName setMarkerTextLocal str(_x);
		_markerName setMarkerColorLocal "ColorGreen";
	}} forEach allGroups;
	waitUntil{sleep 1;warbegins == 1};
	{deleteMarkerLocal ("SerP_startposMarker"+str(_x))} forEach allGroups;
}};