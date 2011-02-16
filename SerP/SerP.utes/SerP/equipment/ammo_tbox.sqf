_cargoCrate_processor = {
	_veh = _this select 0;
	_loadout = toUpper (_this select 1);
	switch _loadout do {
		case "5.56M_big" : {//
			[_veh, "ACE_Tbox_US", [["30Rnd_556x45_Stanag",30], ["ACE_30Rnd_556x45_T_Stanag",6]]] call _addCargoBox;
		};
		case "5.56B" : {//
			[_veh, "ACE_Tbox_US", [["200Rnd_556x45_M249",5],["100Rnd_556x45_M249",5]]] call _addCargoBox;
		};
		case "gren_west" : {//
			[_veh, "ACE_Tbox_US", [["HandGrenade_West",15], ["SmokeShell",10]]] call _addCargoBox;
		};		
		case "60mmHE" : {//
			[_veh, "ACE_Tbox_US", [["ACE_M224HE_CSWDM",10]]] call _addCargoBox;
		};
		case "60mmWP" : {//
			[_veh, "ACE_Tbox_US", [["ACE_M224WP_CSWDM",10]]] call _addCargoBox;
		};
		case "5.45M_big" : {//
			[_veh, "ACE_Tbox_RU", [["30Rnd_545x39_AK",20]]] call _addCargoBox;
		};
	};
};
/*
			_veh addMagazineCargo ["HandGrenade",24];
			_veh addMagazineCargo ["ACE_RDGM",20];
			_veh addMagazineCargo ["30Rnd_545x39_AK",20];
			_veh addMagazineCargo ["10Rnd_762x54_SVD",20];
			_veh addMagazineCargo ["100Rnd_762x54_PK",20];
			_veh addMagazineCargo ["1Rnd_HE_GP25",40];
			_veh addWeaponCargo ["ACE_ANPRC77",4];
			_veh addWeaponCargo ["ACE_BackPack",10];
			_veh addMagazineCargo ["ACE_30Rnd_545x39_T_AK", 20];
			_veh addMagazineCargo ["ACE_Bandage",20];
			_veh addMagazineCargo ["ACE_Morphine",20];
			_veh addMagazineCargo ["ACE_Epinephrine",20];
			if (isServer) then {
				_tbox = "ACE_Tbox_RU" createVehicle [0,0,0];
				_tbox setVariable ["ace_sys_cargo_UnloadPos", [0,7,0], true];
				_tbox addMagazineCargoGlobal ["ACE_PG7VM_PGO7", 10];
				_tbox addMagazineCargoGlobal ["ACE_OG7_PGO7", 10];
				_tbox addMagazineCargoGlobal ["30Rnd_545x39_AK",50];
				_tbox addMagazineCargoGlobal ["HandGrenade_East", 20];
				_tbox addMagazineCargoGlobal ["1Rnd_SMOKE_GP25",20];
				_tbox addMagazineCargoGlobal ["1Rnd_SmokeRed_GP25",5];
				_tbox addMagazineCargoGlobal ["1Rnd_SmokeGreen_GP25",5];
				_tbox addMagazineCargoGlobal ["ACE_1Rnd_CS_GP25",20];
				_tbox addMagazineCargoGlobal ["ACE_SSWhite_GP25",5];
				_tbox addMagazineCargoGlobal ["ACE_SSRed_GP25",5];
				_tbox addMagazineCargoGlobal ["ACE_SSGreen_GP25",5];
				_tbox addMagazineCargoGlobal ["FlareWhite_GP25",5];
				_tbox addMagazineCargoGlobal ["FlareRed_GP25",5];
				_tbox addMagazineCargoGlobal ["FlareGreen_GP25",5];
				_veh setVariable ["ace_sys_cargo_content",(_veh getVariable ["ace_sys_cargo_content",[]]) + [_tbox],true];
			};
			_veh addMagazineCargo ["ACE_Rope_M_60",4];
			_veh addWeaponCargo ["ACE_ParachuteRoundPack",20];
		};*/