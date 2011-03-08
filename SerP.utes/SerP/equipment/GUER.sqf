#define addWeapons {_unit addWeapon _x} forEach 
#define addMagazines(a,b) for "_i" from 1 to b do {_unit addMagazine a}
_unit = _this select 0;
_type = toUpper (_this select 1);
switch _type do {
	case "WL": {// Warlord
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("ACE_33Rnd_9x19_G18",2);
		addMagazines("SmokeShell",2);
		addMagazines("HandGrenade_East",2);
		addWeapons ["AK_47_M","ACE_Glock18","Binocular","NVGoggles","ACE_PRC119_ACU"];
		addWeapons ["ACE_Map","ACE_Map_Tools","ItemGPS"];
	};
	case "SL": {// Squad Lider
		addMagazines("ACE_20Rnd_762x51_B_G3",3);
		addMagazines("SmokeShell",2);
		addMagazines("HandGrenade_East",2);
		addWeapons ["ACE_G3A3","Binocular","NVGoggles","ACE_PRC119_ACU"];
		addWeapons ["ACE_Map","ACE_Map_Tools"];
	};
	case "TL": {// Watch Leader
		addMagazines("SmokeShell",2);
		addMagazines("HandGrenade_East",2);
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("ACE_33Rnd_9x19_G18",2);
		addWeapons ["AK_47_S","ACE_Glock18","Binocular","NVGoggles"];
		addWeapons ["ACE_Map","ACE_Map_Tools"];
	};
	case "MG": {//Machinegunner
		addMagazines("100Rnd_762x54_PK",2);
		addMagazines("HandGrenade_West",3);
		addWeapons ["PK","Binocular","NVGoggles"];
		addWeapons ["ACE_Map","ACE_Earplugs"];
	};
	case "AG": {//Asst. Machinegunner
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("HandGrenade_West",3);
		addWeapons ["AK_47_M", "NVGoggles", "ACE_Combat_Pack"];
		addWeapons ["ACE_Earplugs"];
		_unit setVariable ["ACE_RuckMagContents",[["100Rnd_762x54_PK",2]]];
	};
	case "AR": {// Automatic Rifleman
		addMagazines("75Rnd_545x39_RPK",4);
		addMagazines("HandGrenade_East",3);
		addWeapons ["RPK_74","NVGoggles"];
		addWeapons ["ACE_Earplugs", "ACE_Map"];
	};
	case "AT": {//AT Operator
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("HandGrenade_East",3);
		addMagazines("PG7V",2);
		addWeapons ["AK_47_S", "RPG7V","NVGoggles"];
		addWeapons ["ACE_Earplugs", "ACE_Map"];
	};
	case "AAT": {// Asst. AT Operator
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("HandGrenade_East",3);
		addWeapons ["AK_47_M", "ACE_Combat_Pack", "NVGoggles"];
		addWeapons ["ACE_Map","ACE_Earplugs"];
		_unit setVariable ["ACE_RuckMagContents", [["PG7V",2],["OG7",2]]];
	};
	case "LAT": {// Rifleman AT
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("HandGrenade_East",3);	
		addWeapons ["AK_47_S","NVGoggles", "ACE_RPG22"];
		addWeapons ["ACE_Map"];
	};	
	case "SAB": {// Saboteur
		addMagazines("30Rnd_762x39_AK47",3);
		addWeapons ["AK_47_S", "NVGoggles","ACE_Combat_Pack"];
		addWeapons ["ACE_Map"];
		_unit setVariable ["ACE_RuckMagContents", [["PipeBomb",2]]];
	};
	case "SAP": {// Sapper
		addMagazines("30Rnd_762x39_AK47",3);
		addWeapons ["AK_47_S", "NVGoggles","ACE_Combat_Pack"];
		addWeapons ["ACE_Map"];
		_unit setVariable ["ACE_RuckMagContents", [["BAF_ied_v2",2],["BAF_ied_v4",2]]];
	};
	case "ASAP": {// Asst. Sapper
		addMagazines("30Rnd_762x39_AK47",3);
		addWeapons ["AK_47_S", "NVGoggles","ACE_Combat_Pack"];
		addWeapons ["ACE_Map"];
		_unit setVariable ["ACE_RuckMagContents", [["BAF_ied_v1",2],["BAF_ied_v3",2]]];
	};
	case "RF": {// Rifleman
		addMagazines("ACE_10Rnd_762x39_B_SKS",6);
		addMagazines("HandGrenade_East",4);
		addWeapons ["ACE_SKS"];
	};
	case "RC": {// Recon
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("ACE_33Rnd_9x19_G18",2);
		addMagazines("BAF_ied_v3",1);
		addMagazines("HandGrenade_East",4);
		addWeapons ["AK_47_M", "ACE_Glock18", "NVGoggles"];
		addWeapons ["ACE_Map"];
	};
	case "MR": {// Lee-Endfield
		addMagazines("10x_303",4);
		addMagazines("HandGrenade_East",4);
		addWeapons ["LeeEnfield","NVGoggles", "RPG18"];
		addWeapons ["ACE_Map"];
	};
	case "SN": {// Sniper
		addMagazines("5x_22_LR_17_HMR",6);
		addMagazines("ACE_Pomz_M",2);
		addMagazines("SmokeShell",2);
		addMagazines("8Rnd_9x18_Makarov",2);
		addWeapons ["huntingrifle", "Makarov", "NVGoggles"];
		addWeapons ["ACE_Map"];
	};
	case "MED": {//Medic
		addMagazines("30Rnd_762x39_AK47",3);
		addWeapons ["AK_47_S", "NVGoggles","ACE_Combat_Pack"];
		addWeapons ["ACE_Map"];
		_unit setVariable ["ACE_RuckMagContents",[["ACE_Bandage",10],["ACE_Morphine",10],["ACE_Epinephrine",10],["ACE_Medkit",10]]]
	};
	case "GL": {//Grenadier
		addMagazines("30Rnd_762x39_AK47",4);
		addMagazines("1Rnd_HE_M203",5);
		addWeapons ["AK_47_S", "NVGoggles"];
		addMagazines("HandGrenade_West",4);
		_unit setVariable ["ACE_weapononback","M79_EP1"];
	};
	case "AA": {//Pzrk Operator
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("HandGrenade_East",3);
		addWeapons ["AK_47_S","Strela","NVGoggles"];
		addWeapons ["ACE_Earplugs", "ACE_Map"];
		addMagazines("Strela",1);
	};
//DSHKM		
	case "HMG" : {//DSHKM Gunner
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("ACE_DSHKM_CSWDM",1);
		addWeapons ["AK_47_S", "ACE_DSHKMProxy", "NVGoggles"];		
		addWeapons ["ACE_Map","ACE_Earplugs"];
	};
	case "HMGAG" : {//DSHKM Asst. Gunner
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("ACE_DSHKM_CSWDM",1);
		addMagazines("HandGrenade_West",2);
		addWeapons ["AK_47_S", "ACE_DSHKMTripodProxy", "Binocular", "NVGoggles"];	
		addWeapons ["ACE_Map", "ACE_Earplugs"];
	};
	case "HMGAB" : {
		addMagazines("30Rnd_762x39_AK47",3);
		addMagazines("HandGrenade_East",2);
		addWeapons ["AK_47_S","ACE_BackPack_ACR","NVGoggles"];
		_unit setVariable ["ACE_RuckMagContents", [["ACE_DSHKM_CSWDM",4]]];
	};
//����������
	case "L_PM" : {
		addMagazines("8Rnd_9x18_Makarov",4);
		addMagazines("HandGrenade_East",2);
		addWeapons ["PM"];
	};
	case "L_RV" : {
		addMagazines("6Rnd_45ACP",4);
		addMagazines("HandGrenade_East",2);
		addWeapons ["revolver_EP1"];
	};
	case "L_GLOCK" : {
		addMagazines("ACE_33Rnd_9x19_G18",4);
		addMagazines("HandGrenade_East",2);
		addWeapons ["ACE_Glock18"];
	};
	case "L_UZI" : {
		addMagazines("30Rnd_9x19_UZI",4);
		addMagazines("HandGrenade_East",2);
		addWeapons ["UZI_EP1"];
	};
	case "L_SCORP" : {
		addMagazines("20Rnd_B_765x17_Ball",4);
		addMagazines("HandGrenade_East",2);
		addWeapons ["Sa61_EP1"];
	};
};