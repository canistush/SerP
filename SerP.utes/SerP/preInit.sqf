enableSaving [false, false];
//init global variables
if (isClass(configFile >> "cfgPatches" >> "ace_main")) then {
	ace_sys_wounds_enabled = true;
	ace_sys_repair_default_tyres= true;
	ace_sys_tracking_markers_enabled_override = true;
	ace_sys_tracking_markers_enabled = false;
	ace_sys_spectator_playable_only = true;
	//ace_sys_spectator_NoMarkersUpdates = true;
};

enableEngineArtillery false;

//functions
SerP_isCrew = compile preprocessFileLineNumbers "SerP\isCrew.sqf";
SerP_isPilot = compile preprocessFileLineNumbers "SerP\isPilot.sqf";
[] call compile preprocessFileLineNumbers "SerP\setMissionConditions.sqf";
[] execVM "SerP\endmission.sqf";

if (isServer) then {
	publicVars = ["timeOfDay","weather","briefing_mode","warbegins","readyarray","startZones"];
	onPlayerConnected "{publicVariable _x} forEach publicVars";
	[] execVM "SerP\startmission_server.sqf";
};

if (!isDedicated) then {
	SerP_server_message = "";
	"SerP_server_message" addPublicVariableEventHandler {hint (_this select 1)};
	[] execVM "SerP\startmission_client.sqf";
};