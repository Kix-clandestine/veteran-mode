// declare include paths
#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/veteran-mode/scripts"

#include "gamemode_invasion.as"
// HACK: [VM] include trackers here for late addition to a derived GameModeInvasion metagame


// --------------------------------------------
void main(dictionary@ inputData) {
    _setupLog("dev_verbose");
    XmlElement inputSettings(inputData);
    _log("VM debug: inputSettings = ");
    _log(inputSettings.toStringWithFloats());
    UserSettings settings;
    // HACK: [VM] set the username from the local inputData as this main begins at campaign entry script
    string username = "";
    if (!inputData.get("username", username)) {
        _log("username key not in inputData dict");
    }
    settings.m_username = username;
    // 0 (greenbelts), 1 (graycollars), 2 (brownpants)
    settings.m_factionChoice = 0;
    settings.m_playerAiCompensationFactor = 1.0;
    settings.m_enemyAiAccuracyFactor = 0.95;
    settings.m_playerAiReduction = 0.0;
    // HACK: mod for VM tester invasion
    settings.m_teamKillPenaltyEnabled = false;
    settings.m_completionVarianceEnabled = false;
    settings.m_journalEnabled = false;
    settings.m_fellowDisableEnemySpawnpointsSoldierCountOffset = 1;
    // HACK: [VM] some of these VM things require XP and RP, improve reward factor and starting amounts
    // xp factor 2x vanilla invasion 1.89 setting
    settings.m_xpFactor = 0.27 * 2;
    /* settings.m_rpFactor = 1.0; */
    settings.m_initialXp = 100.0;
    settings.m_initialRp = 1000000.0;
    // HACK: [VM] when there aren't enough enemies around, test these weapons on your allies instead XD
    settings.m_friendlyFire = true;
    // HACK: [VM] enable testing tools!
    settings.m_testingToolsEnabled = true;
    // configure veteran settings
    settings.m_fov = true;

    array<string> overlays = { "media/packages/invasion", "media/packages/veteran-mode" };
    settings.m_overlayPaths = overlays;

        settings.m_startServerCommand = """
<command class='start_server'
    server_name="Veteran Mode [TEST]"
    server_port='1234'
    comment='Coop campaign'
    url=''
    register_in_serverlist='0'
    mode='COOP'
    persistency='forever'
    max_players='16'>
    <client_faction id='0' />
</command>
""";

    settings.print();
    GameModeInvasion metagame(settings);
    metagame.init();
    // HACK: [VM] add local player as admin for easy testing, hacks, etc
    if (!metagame.getAdminManager().isAdmin(metagame.getUserSettings().m_username)) {
        metagame.getAdminManager().addAdmin(metagame.getUserSettings().m_username);
    }
    // HACK: [VM] late add VM trackers...

    metagame.run();
    metagame.uninit();

    _log("ending execution");
}
