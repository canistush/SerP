#include "const.sqf"
trashArray = [];
planeList = [];
_bCounter = {
	_briefingTime = (_this select 0);
	warbegins = 0;publicVariable "warbegins";
	waitUntil{
		SerP_taskHint = format ["%1 minutes remaining",round((_briefingTime-time)/60)];
		publicVariable "SerP_taskHint";hint SerP_taskHint;
		sleep 60;
		(time >= _briefingTime)||(warbegins==1)
	};
	warbegins = 1;publicVariable "warbegins";
};
switch (briefing_mode) do	{
	case 0:	{
		[180] spawn _bCounter;
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
_zones = [];//[_pos,_size,_unitsInZone,_side]
{
	_unitPos = getPos vehicle(_x);
	_unit = _x;
	_side = side _x;
	_size = switch true do {
		case (_side==__sideREDFOR): {__defZoneSize*_zoneMultREDFOR};
		case (_side==__sideBLUEFOR): {__defZoneSize*_zoneMultBLUEFOR};
		default {__defZoneSize};
	};
	_teleportTo = [];
	if (waypointDescription(waypoints(group _unit) select 1)=="teleport") then {
		{
			if (waypointDescription(_x)=="teleport") then {
				_teleportTo = _teleportTo + [waypointPosition(_x)];
			};
		} forEach waypoints(group _unit);
		while {(waypointDescription(waypoints(group _unit) select 1)=="teleport")} do {
			deleteWaypoint (waypoints(group _unit) select 1);
		};
	};
	_outOfZone = true;
	{
		_zonePos = _x select 0;
		_zoneSize = _x select 1;
		_unitsInZone = _x select 2;
		_zoneSide = _x select 3;
		_units = _x select 4;
		_zoneTeleportTo = _x select 5;
		_dist = (_unitPos distance _zonePos);
		if ((_dist < (_size + _zoneSize))&&(_side==_zoneSide)) exitWith {//zone concat
			_unitmod = 1/_unitsInZone;
			_sizemod = (_unitsInZone-1)/_unitsInZone;
			_pos = [(_unitPos select 0)*_unitmod+(_zonePos select 0)*_sizemod,(_unitPos select 1)*_unitmod+(_zonePos select 1)*_sizemod,0];
			_zoneSize = (_size+_dist) max _zoneSize;
			_zones set [_forEachIndex,[_pos,_zoneSize,_unitsInZone+1,_zoneSide,_units + [_unit],_zoneTeleportTo+_teleportTo]];
			_outOfZone = false;
		};
	} forEach _zones;
	if (_outOfZone) then {
		_zones set [count _zones,[_unitPos,_size,1,_side,[_x],_teleportTo]]
	};
	_x setVariable ["SerP_isPlayer",(isPlayer _x)];
} forEach playableUnits;
_exit = false;
while {!_exit} do {
	_exit = true;
	{
		_zonePos1 = _x select 0;
		_size1 = _x select 1;
		_unitsInZone1 = _x select 2;
		_zoneSide1 = _x select 3;
		_units1 = _x select 4;
		_zoneTeleportTo1 = _x select 5;
		_i = _forEachIndex;
		{
			_zonePos2 = _x select 0;
			_size2 = _x select 1;
			_unitsInZone2 = _x select 2;
			_zoneSide2 = _x select 3;
			_units2 = _x select 4;
			_zoneTeleportTo2 = _x select 5;
			_j = _forEachIndex;
			if ((_i!=_j)&&(_zonePos1 distance _zonePos2)<(_size1+_size2)&&(_zoneSide1==_zoneSide2)) exitWith {
				_pos = [((_zonePos1 select 0)+(_zonePos2 select 0))/2,((_zonePos1 select 1)+(_zonePos2 select 1))/2,0];
				_size = ((_zonePos1 distance _zonePos2)/2 + _size1 max _size2);
				_zones set [_i,[_pos,_size,_unitsInZone1+_unitsInZone2,_zoneSide1,_units1+_units2,_zoneTeleportTo1+_zoneTeleportTo2]];
				_zones set [_j,-1];
				_zones = _zones - [-1];
				_exit = false;
			};
		} forEach _zones;
		if (!_exit) exitWith {};
	} forEach _zones;
};
_objectList = (allMissionObjects "Plane")+(allMissionObjects "LandVehicle")+(allMissionObjects "Helicopter")+(allMissionObjects "Ship");
//teleportarium
SerP_startSeed = if (__synchronizedRespawn==0) then {
	__synchronizedRespawn
}else{
	round(random(1000+({isPlayer(_x)} count playableUnits)))
};

_teleportList = [];
{
	_zone = _x;
	_zonePos = _x select 0;
	_size = _x select 1;
	_units = _x select 4;
	_zoneTeleportTo = _x select 5;
	if (count(_zoneTeleportTo)>0) then {
		_teleportTo = if (__synchronizedRespawn!=0) then {
			(SerP_startSeed%(count(_zoneTeleportTo)+1))
		}else{
			round(random(1000+({isPlayer(_x)} count playableUnits)))%(count(_zoneTeleportTo)+1)
		};
		if (_teleportTo>0) then {//0 means that units stay still
			_newZonePos = _zoneTeleportTo select(_teleportTo-1);
			_zone set [0,_newZonePos];
			{
				if (vehicle(_x) == _x) then {
					_unitpos = getPosASL _x;
					_diff = [((_unitpos select 0) - (_zonePos select 0)),((_unitpos select 1) - (_zonePos select 1)),0];
					_newPos = [((_newZonePos select 0)+(_diff select 0)),((_newZonePos select 1)+(_diff select 1)),0];
					_teleportList set [count _teleportList,[_x,_newPos]];
				};
			} forEach _units;
			{
				if ((_x distance _zonePos)<_hintzonesize+_size) then {
					_unitpos = getPosASL _x;
					_diff = [((_unitpos select 0) - (_zonePos select 0)),((_unitpos select 1) - (_zonePos select 1)),0];
					_newPos = [((_newZonePos select 0)+(_diff select 0)),((_newZonePos select 1)+(_diff select 1)),0];
					_teleportList set [count _teleportList,[_x,_newPos]];
				};
			} forEach _objectList;
		};
	};
} forEach _zones;
//end teleportarium
[_zones,_hintzonesize,_objectList,_teleportList] spawn {
	_zones = _this select 0;
	_hintzonesize = _this select 1;
	_objectList = _this select 2;
	_teleportList = _this select 3;
	sleep 5;
	{(_x select 0) setPos (_x select 1)} forEach _teleportList; //move objects
	sleep 1;
	_actionList = [];
	startZones = [];
	{
		_corepos = _x select 0;
		_size = _x select 1;
		_core = createVehicle ["FlagCarrierChecked", [_corepos select 0,_corepos select 1, -3], [], 0, "CAN_COLLIDE"];
		_corepos = getPosASL _core;
		trashArray set [count trashArray, _core];
		{
			if (((_x distance _core)<_hintzonesize+_size)&&!(_x isKindOf "StaticWeapon")) then {
				_unitpos = getPosASL _x;
				_diff = [((_unitpos select 0) - (_corepos select 0)),((_unitpos select 1) - (_corepos select 1)),((_unitpos select 2) - (_corepos select 2))];
				_actionList set [count _actionList,[_x,[_core,[(_diff select 0),(_diff select 1),((_diff select 2) - (((boundingBox _x) select 0) select 2) - 1.5)]],[(vectorDir _x),(vectorUp _x)]]];
			};
		}forEach _objectList;
		_helper = createVehicle ["Sign_arrow_down_EP1", _corepos, [], 0, "CAN_COLLIDE"];
		_actionList set [count _actionList,[_helper,[_core,[0,0,-5]],[[1,0,0],[0,0,1]]]];
		trashArray set [count trashArray, _helper];
		startZones set [count startZones,[[_corepos select 0,_corepos select 1,0],_size,_core,_helper]];
	} forEach _zones;
	{
		(_x select 0) attachTo (_x select 1);
		(_x select 0) setVectorDirAndUp (_x select 2);
	} forEach _actionList;
	publicVariable "startZones";publicVariable "warbegins";publicVariable "readyArray";
	//control
	_oneSide = ({isPlayer(_x)&&(side(_x)==__sideBLUEFOR)} count playableUnits == 0)||({isPlayer(_x)&&(side(_x)==__sideREDFOR)} count playableUnits == 0);
	waitUntil{sleep 1;(((readyArray select 0) == 1)&&((readyArray select 1) == 1))||((1 in readyArray)&&_oneSide)||(warbegins==1)};

	warbegins=1;publicVariable "warbegins";
	warbeginstime=time;publicVariable "warbeginstime";
	'logic' createUnit [[0,0,0], createGroup sideLogic,'
		if isServer then {
			{if (!(isPlayer _x)&&!(_x getVariable "SerP_isPlayer")) then {
				_x setPos [30000,0,100];
				deleteVehicle _x;
			}} forEach playableUnits;
		};
		taskHint ["War begins", [1, 0, 0, 1], "taskNew"];
		{deleteVehicle _x} forEach trashArray;
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
		player say "r61";
		this spawn {
			sleep 4;
			deleteVehicle _this;
		}
	', 0.6, 'corporal']
};