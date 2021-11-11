#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/veteran-mode/scripts"
#include "gamemode_vm_tester.as"

void main(dictionary@ inputData) {
    XmlElement inputSettings(inputData);
    _log("[vm tester main] input settings:  " + inputSettings.toString());

    GameModeVMTester metagame(inputSettings);

    metagame.init();
    metagame.run();
    metagame.uninit();

    _log("ending execution");
}
