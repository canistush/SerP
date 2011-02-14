#include "const.sqf"
private ["_blocker"];
trashArray = [];
planeList = [];
if (isServer) then {
	_bCounter = {
		_briefingTime = (_this select 0);
		warbegins = 0;
		waitUntil{
			sleep 60; 
			SerP_server_message = format ["%1 minutes remaining",round((_briefingTime-time)/60)];
			publicVariable "SerP_server_message";hint SerP_server_message;
			(time >= _briefingTime)||(warbegins==1)
		};
		warbegins = 1;publicVariable "warbegins";
	};
	switch (briefing_mode) do	{
		case 0:	{if true exitWith {[] spawn {
				sleep 1;
				if (isServer) then {
					warbegins = 1; 
					publicVariable "warbegins";
					ace_sys_map_enabled = true; 
					publicVariable "ace_sys_map_enabled";
					sleep 600;
					{//delete AI
						if ((_x isKindOf "Man")and(not(isPlayer _x))) then {_x setPos [0,0,0]; _x setDamage 1} else {	
							if ((_x isKindOf "LandVehicle")or(_x isKindOf "Air")or(_x isKindOf "Ship")) then
							{
								{if (not(isPlayer _x)) then {_x setPos [0,0,0]; _x setDamage 1};} forEach crew _x;
							};
						};
					} forEach playableUnits;
				};
				[] execVM "\x\ace\addons\sys_map\mapview.sqf";
			}};
		};
		case 1:	{
			[420] spawn _bCounter;
		};
		case 2:	{
			[900] spawn _bCounter;
		};
	};


	warbegins = 0;publicVariable "warbegins";
	readyArray = [0,0];publicVariable "readyArray";
	//find zones
	_zones = [];//[_pos,_size]
	{
		_unitPos = getPos vehicle(_x);
		_outOfZone = true;
		{
			_zonePos = _x select 0;
			_size = _x select 1;
			_unitsInZone = _x select 2;
			_dist = (_unitPos distance _zonePos);
			if (_dist < (_defZoneSize + _size)) exitWith {//zone concat
				_unitmod = 1/_unitsInZone;
				_sizemod = (_unitsInZone-1)/_unitsInZone;
				_pos = [(_unitPos select 0)*_unitmod+(_zonePos select 0)*_sizemod,(_unitPos select 1)*_unitmod+(_zonePos select 1)*_sizemod,0];
				_size = (_dist + _defZoneSize) max _size;
				_zones set [_forEachIndex,[_pos,_size,_unitsInZone+1]];
				_outOfZone = false;
			};
		} forEach _zones;
		if (_outOfZone) then {
			_zones set [count _zones,[_unitPos,_defZoneSize,1]]
		};
	} forEach playableUnits;
	waitUntil{
		_exit = true;
		{
			_zonePos1 = _x select 0;
			_size1 = _x select 1;
			_unitsInZone1 = _x select 2;
			_i = _forEachIndex;
			{
				_zonePos2 = _x select 0;
				_size2 = _x select 1;
				_unitsInZone2 = _x select 2;
				_j = _forEachIndex;
				if ((_i!=_j)&&(_zonePos1 distance _zonePos2)<(_size1+_size2)) exitWith {
					_pos = [((_zonePos1 select 0)+(_zonePos2 select 0))/2,((_zonePos1 select 1)+(_zonePos2 select 1))/2,0];
					_size = ((_zonePos1 distance _zonePos2)/2 + _size1 max _size2);
					_zones set [_i,[_pos,_size,_unitsInZone1+_unitsInZone2]];
					_zones set [_j,-1];
					_zones = _zones - [-1];
					_exit = false;
				};
			} forEach _zones;
			if (!_exit) exitWith {};
		} forEach _zones;
		_exit
	};
	startZones = _zones;
	[] spawn {
		#include "const.sqf"
		sleep .01;
		_unitList = (allMissionObjects "Plane")+(allMissionObjects "LandVehicle")+(allMissionObjects "Helicopter")+(allMissionObjects "Ship");
		{
			_corepos = (_x select 0);
			_size = (_x select 1);
			_core = createVehicle ["FlagCarrierChecked", _corepos, [], 0, "CAN_COLLIDE"];
			_core setPos [_corepos select 0,_corepos select 1,-3];
			_corepos = getPosASL _core;
			trashArray set [count trashArray, _core];
			{
				if (((_x distance _core)<_hintzonesize+_size)&&!(_x isKindOf "StaticWeapon")) then {
					_vDir = vectorDir _x;
					_vUp = vectorUp _x;
					_unitpos = getPosASL _x;
					_diff = [((_unitpos select 0) - (_corepos select 0)),((_unitpos select 1) - (_corepos select 1)),((_unitpos select 2) - (_corepos select 2))];
					_x attachTo [_core,[(_diff select 0),(_diff select 1),((_diff select 2) - (((boundingBox _x) select 0) select 2) - 1.5)]];
					_x setVectorDirAndUp [_vDir,_vUp];
					if ((_x isKindOf "Plane")and((_unitpos select 2) > 20)) then {planeList set [count planeList, _x];};
				};
			}forEach _unitList;
			_helper = createVehicle ["Sign_arrow_down_EP1", _corepos, [], 0, "CAN_COLLIDE"];
			_helper attachTo [_core,[0,0,-5]];
			_helper setDir 90;
			trashArray set [count trashArray, _helper];
			_x set [2,_core]; // НАФА? не используется нигде же! Зачем грузить канал?!
			_x set [3,_helper];
		} forEach startZones;
		publicVariable "startZones";
		//Корд, давай уберём за кометны ради снижения нагрузки - передать целых паблик массива с объектами два объекта в пбалик это не хухры-мухры.
		/* Ниже следующее отсвил для потомков.
		_AttUnitList = [];
		{ 
			_center = getposASL _x;
			{
				if !(_x in _AttUnitList) then {
					_dist = (_center distance (getPosASL _x));
					if ((_dist < _defZoneSize + _hintzonesize)&&!(_x isKindOf "StaticWeapon")) then {
						_AttUnitList set [count _AttUnitList, _x];
						_unitpos = getPosASL _x;
						_core = createVehicle ["FlagCarrierChecked", _unitpos, [], 0, "CAN_COLLIDE"];
						_core setPos [_unitpos select 0,_unitpos select 1,-3];
						_corepos = getPosASL _core;
						trashArray set [count trashArray, _core];
						_vDir = vectorDir _x;
						_vUp = vectorUp _x;      
						_diff = [0,0,((_unitpos select 2) - (_corepos select 2))];
						_x attachTo [_core,[0,0,((_diff select 2) - (((boundingBox _x) select 0) select 2) - 1.5)]];
						_x setVectorDirAndUp [_vDir,_vUp];
						if ((_x isKindOf "Plane")and((_unitpos select 2) > 20)) then {planeList set [count planeList, _x];};
					};
				};
			} foreach _unitList;
		} foreach PlayableUnits;
		*/
		//control
		waitUntil{sleep 1;(((readyArray select 0) == 1)&&((readyArray select 1) == 1))||((1 in readyArray)&&!isDedicated)||(warbegins==1)};

		warbegins=1;publicVariable "warbegins";
		warbeginstime=time;publicVariable "warbeginstime";
		{if (!(isPlayer _x)) then {
			_unit = _x;
			_unit setPos [0,0,0];
			deleteVehicle _unit;
		}} forEach playableUnits;
		'logic' createUnit [[0,0,0], createGroup sideLogic,'
			taskHint ["War begins", [1, 0, 0, 1], "taskNew"];
			{
				if (local _x) then {
					switch true do {
						case ((_x isKindOf "Plane")&&(((getPos _x) select 2) > 20)): {
							detach _x;
							_x setVelocity [(sin(getDir _x) * 100),(cos(getDir _x) * 100),20];
						};
						case (((_x isKindOf "LandVehicle")&&(!(_x isKindOf "StaticWeapon")))||(_x isKindOf "Air")or(_x isKindOf "Ship")): {
							detach _x;
							_x setVelocity [0,0,-1];
						};
					};
				};
			} forEach ((allMissionObjects "Plane")+(allMissionObjects "LandVehicle")+(allMissionObjects "Helicopter")+(allMissionObjects "Ship"));
			ace_sys_map_enabled = true;
			[] execVM "\x\ace\addons\sys_map\mapview.sqf";
			player say "ACE_rus_combat119";
			this spawn {
				sleep 4;
				{deleteVehicle _x} forEach trashArray;
				deleteVehicle _this;
			}
		', 0.6, 'corporal']
	};
};

if !(isDedicated) then {
	waitUntil{player==player};
	if !alive(player) exitWith {};
	sleep .1;
	cutText[localize 'STR_missionname','BLACK IN',5];
	forceMap true;
	_blocker2 = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", '
		[0,-1] call ace_sys_weaponselect_fnc_keypressed;
		false
	'];
	[0,-1] call ace_sys_weaponselect_fnc_keypressed;
	waitUntil{sleep .1;!isNil{warbegins}};
	if (warbegins==1) exitWith {
		forceMap false;
		(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown",_blocker2];
	};

	_radio=createTrigger["EmptyDetector",[0,0]];
	_radio setTriggerActivation["INDIA","PRESENT",true];
	_radio setTriggerStatements["this",format ["
		if (side player == %1) then {
			if ((readyArray select 1) == 0) then 
				{readyArray set [1, 1];publicVariable ""readyArray"";}
			else 
				{readyArray set [1, 0];publicVariable ""readyArray"";};
		};
		if (side player == %2) then {
			if ((readyArray select 0) == 0) then 
				{readyArray set [0, 1];publicVariable ""readyArray"";}
			else 
				{readyArray set [0, 0];publicVariable ""readyArray"";}
		;};
		",_sideREDFOR,_sideBLUEFOR],
		""];
	trashArray set [count trashArray, _radio];

	_endTrigger = createTrigger["EmptyDetector",[0,0]];
	_endTrigger setTriggerActivation ["ANY", "PRESENT", true];
	_endTrigger setTriggerStatements[
		"(((readyArray select 0) == 1))",format [
		"taskhint [""BLUEFOR ready "", [0, 0, 1, 1], ""taskNew""];if (side player == %1) then {9 setRadioMsg ""Продолжить брифинг"";};",_sideBLUEFOR],format [
		"taskhint [""BLUEFOR not ready "", [0, 0, 1, 1], ""taskNew""];if (side player == %1) then {9 setRadioMsg ""Закончить брифинг"";};",_sideBLUEFOR]
		];
	trashArray set [count trashArray, _endTrigger];

	_endTrigger = createTrigger["EmptyDetector",[0,0]];
	_endTrigger setTriggerActivation ["ANY", "PRESENT", true];
	_endTrigger setTriggerStatements[
		"(((readyArray select 1) == 1))",format [
		"taskhint [""REDFOR ready "", [1, 0, 0, 1], ""taskNew""];if (side player == %1) then {9 setRadioMsg ""Продолжить брифинг"";};",_sideREDFOR],format [
		"taskhint [""REDFOR not ready "", [1, 0, 0, 1], ""taskNew""];if (side player == %1) then {9 setRadioMsg ""Закончить брифинг"";};",_sideREDFOR]
		];
	trashArray set [count trashArray, _endTrigger];
	9 setRadioMsg "Закончить брифинг";
	_waitTime = time + 60;
	waitUntil{sleep 1;!isNil{startZones}||(time>_waitTime)};// вернул проверку на получене стартзонес, ибо выткать в чёрный экран при потери пакетов особого желания нет.
	if isNil{startZones} then { 
		startZones = [[getPos(vehicle player),_defZoneSize,1,objNull,objNull]]; //вот тут была ошибка не объявленый _size вместо _defZoneSize
	};
	{
		_pos = (_x select 0);
		_size = (_x select 1);
		_helper = (_x select 3);
		_inZone = false;
		if ((getPos (vehicle player) distance _pos)<(_size+_hintzonesize)) exitWith {
			_inZone = true;
			_waitTime = if isServer then {10}else{90};
			if (isNull _helper) then {
				waitUntil {sleep 1;(time>_waitTime)};
			} else {
				waitUntil {sleep 1;(time>_waitTime)||(getDir _helper != 0)};
			};
			sleep 5;
			forceMap false;
			while {(warbegins!=1)} do {
				sleep 2;
				_dist = (vehicle player) distance _pos;
				if (_dist>(_size+_hintzonesize)) exitWith {
					hint "Мне очень жаль";
					player say "r44";
					player say "All_haha";
					//player say "ACE_rus_combat143";
					sleep 3;
					player setDamage 1;
				};
				if (_dist>_size) then {
					hint "Вы покидаете зону брифинга";
					switch round(random 8) do {
						case 0: {player say "r11"};
						case 1: {player say "r15"};
						case 2: {player say "r26"};
						case 3: {player say "r29"};
						case 4: {player say "r25"};
						case 5: {player say "r04"};
						case 6: {player say "r21_4"};
						case 7: {player say "ACE_rus_combat117"};
						case 8: {player say "ACE_rus_combat197"};
					};
				};
			};
		};
	} forEach startZones;
	if (!_inZone) then {
		forceMap false;
	};
	(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown",_blocker2];
};