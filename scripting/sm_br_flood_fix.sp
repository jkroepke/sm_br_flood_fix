#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <smlib>

#define PLUGIN_VERSION	"0.0.1"
#define ERR_INVALID_MAP	"Weapon Drop Fix for 'br_flood'"

// Cvar handles
ConVar g_cvarEnabled;

public Plugin myinfo = {
	name = "[CS:GO] br_flood FIX",
	author = "jkroepke",
	description = "Weapon Drop Fix for 'br_flood'",
	version = PLUGIN_VERSION,
	url = "https://github.com/jokroepke/sm_br_flood_fix"
}

public void OnPluginStart() {
	// Plugin version
	CreateConVar("sm_shf_version", PLUGIN_VERSION, "Version of Server Hibernate Fix", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_UNLOGGED|FCVAR_DONTRECORD|FCVAR_REPLICATED|FCVAR_NOTIFY);

	// Enable/disable plugin on the fly
	g_cvarEnabled = CreateConVar("sm_drop_weapons_enabled", "1", "Enables or disables plugin functionality <1 = Enabled/Default, 0 = Disabled>", 0, true, 0.0, true, 1.0);
	if (g_cvarEnabled == INVALID_HANDLE) {
		LogError("Couldn't register 'sm_drop_weapons_enabled'!");
	}

	// Get real player disconnect event
	HookEvent("round_poststart", Event_RoundPostStart, EventHookMode_Post);

	// Load configuration file
	AutoExecConfig(true, "dropweapon");
}


public Action Event_RoundPostStart(Handle event, const char[] name, bool dontBroadcast) {
    if (g_cvarEnabled.IntValue == 0)
		return Plugin_Continue;

    LOOP_CLIENTS(client, CLIENTFILTER_INGAME) {
        Client_RemoveAllWeapons(client);
    }
	return Plugin_Continue;
}