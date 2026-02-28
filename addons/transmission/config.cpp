class CfgPatches
{
    class transmission
    {
        name = "Incoming Transmission";
        units[] = { "ITR_ModuleTransmission", "ITR_ModuleTransmission_Zeus" };
        requiredVersion = 1.0;
        requiredAddons[] = { "A3_Modules_F" };
        author = "Mugen"; // :3
    };
};

class CfgFunctions
{
    class ITR
    {
        class Core
        {
            file = "\x\incomingtransmission\addons\transmission\functions";
            // 3DEN/system functions
            class transmission {};
            class transmissionModule {};
            // Zeus functions
            class transmissionModuleZeus {};
            class zeusDialogOpen {};
            class zeusDialogCommit {};
        };
    };
};

class CfgFactionClasses
{
    class ITR_Module
    {
        displayName = "ITR Modules";
        priority = 2;
        side = 7;
    };
};

class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
        class ArgumentsBaseUnits
        {
            class Units;
        };
        class ModuleDescription;
    };

    class ITR_ModuleTransmission: Module_F // 3DEN module
    {
        scope = 2; // Visible in Editor
        scopeCurator = 1; // Hidden in Zeus
        displayName = "Incoming Transmission";
        category = "ITR_Module";

        function = "ITR_fnc_transmissionModule";
        functionPriority = 1;
        isGlobal = 0; // Runs on server via remoteExec
        isTriggerActivated = 1; // Can be activated by trigger
        isDisposable = 1;
        curatorCanAttach = 1;

            class Arguments
            {
                class portrait
                {
                    displayName = "Portrait image path";
                    description = "(Optional) Path from mission root";
                    typeName = "STRING";
                    defaultValue = "";
                };

                class speaker
                {
                    displayName = "Speaker name";
                    description = "(Optional) Name displayed in the transmission";
                    typeName = "STRING";
                    defaultValue = "";
                };

                class text
                {
                    displayName = "Transmission text";
                    description = "Transmission body text";
                    typeName = "STRING";
                    defaultValue = "";
                };

                class sound
                {
                    displayName = "Sound class name";
                    description = "(Optional) CfgSounds class name";
                    typeName = "STRING";
                    defaultValue = "";
                };

                class duration
                {
                    displayName = "Duration (seconds)";
                    description = "How long the transmission remains on screen";
                    typeName = "NUMBER";
                    defaultValue = 6;
                };

                class style
                {
                    displayName = "Style";
                    description = "Visual style for the transmission: default, command, warning, enemy, system";
                    typeName = "NUMBER";
                    defaultValue = "";

                    class Values
                    {
                        class Default
                        {
                            name = "Default";
                            value = 0;
                            default = 1;
                        };
                        class Command
                        {
                            name = "Command";
                            value = 1;
                        };
                        class Warning
                        {
                            name = "Warning/Alert";
                            value = 2;
                        };
                        class Enemy
                        {
                            name = "Enemy/Hostile";
                            value = 3;
                        };
                        class System
                        {
                            name = "System";
                            value = 4;
                        };
                    };
                };

                class speakerSize
                {
                    displayName = "Speaker font size";
                    description = "Relative size for the speaker name (e.g. 0.8–1.5)";
                    typeName = "NUMBER";
                    defaultValue = 1.1;
                };

                class textSize
                {
                    displayName = "Text font size";
                    description = "Relative size for the body text (e.g. 0.8–1.3)";
                    typeName = "NUMBER";
                    defaultValue = 1.0;
                };

                class delay
                {
                    displayName = "Delay";
                    description = "Time to wait after activation before this transmission shows";
                    typeName = "NUMBER";
                    defaultValue = 0;
                };
            };

        class ModuleDescription: ModuleDescription
        {
            description = "Shows an Incoming Transmission type dialogue, with options for portrait/sound";
        };
    };

    class ITR_ModuleTransmission_Zeus: ITR_ModuleTransmission // Zeus module
    {
        scope = 1; // Hidden in Eden
        scopeCurator = 2; // Visible in Zeus
        displayName = "Incoming Transmission";
        category = "ITR_Module";
        isTriggerActivated = 0;
        function = "ITR_fnc_transmissionModuleZeus";
    };
};

class RscText;
class RscEdit;
class RscCombo;
class RscButtonMenuOK;
class RscButtonMenuCancel;
class IGUIBack;

class ITR_RscTransmissionDialog // Zeus module window
{
    idd = 90000;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad   = "uiNamespace setVariable ['ITR_RscTransmissionDialog', _this select 0];";
    onUnload = "uiNamespace setVariable ['ITR_RscTransmissionDialog', displayNull];";

    class controlsBackground
    {
        // Main background
        class Background: IGUIBack
        {
            idc = -1;
            x = safeZoneX + safeZoneW * 0.20;
            y = safeZoneY + safeZoneH * 0.18;
            w = safeZoneW * 0.60;
            h = safeZoneH * 0.64;
            colorBackground[] = {0,0,0,0.85};
        };

        // Border
        class Frame: RscText
        {
            idc = -1;
            style = 128; // ST_FRAME
            x = safeZoneX + safeZoneW * 0.20;
            y = safeZoneY + safeZoneH * 0.18;
            w = safeZoneW * 0.60;
            h = safeZoneH * 0.64;
            colorText[] = {1,1,1,0.4};
            colorBackground[] = {0,0,0,0};
        };

        // Header
        class HeaderBar: RscText
        {
            idc = -1;
            x = safeZoneX + safeZoneW * 0.20;
            y = safeZoneY + safeZoneH * 0.18;
            w = safeZoneW * 0.60;
            h = safeZoneH * 0.035;
            colorBackground[] = {0.08,0.08,0.08,1};
        };

        // Header accent
        class HeaderAccent: RscText
        {
            idc = -1;
            x = safeZoneX + safeZoneW * 0.20;
            y = safeZoneY + safeZoneH * 0.215;
            w = safeZoneW * 0.60;
            h = safeZoneH * 0.004;
            colorBackground[] = {0.96,0.62,0,1};
        };
    };

    class controls
    {
        // Title
        class Title: RscText
        {
            idc = -1;
            text = "INCOMING TRANSMISSION";
            x = safeZoneX + safeZoneW * 0.205;
            y = safeZoneY + safeZoneH * 0.183;
            w = safeZoneW * 0.59;
            h = safeZoneH * 0.03;
            style = 2; // center
            font = "PuristaMedium";
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            moving = 1;
        };
        // Portrait
        class PortraitLabel: RscText
        {
            idc = -1;
            text = "Portrait path:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.23;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };
        class PortraitEdit: RscEdit
        {
            idc = 9001;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.23;
            w = safeZoneW * 0.38;
            h = safeZoneH * 0.028;
        };
        // Speaker name
        class SpeakerLabel: RscText
        {
            idc = -1;
            text = "Speaker:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.265;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };
        class SpeakerEdit: RscEdit
        {
            idc = 9002;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.265;
            w = safeZoneW * 0.38;
            h = safeZoneH * 0.028;
        };
        // Text
        class TextLabel: RscText
        {
            idc = -1;
            text = "Text:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.305;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };
        // Multiline textbox
        class TextEdit: RscEdit
        {
            idc = 9003;
            style = 16;
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.34;
            w = safeZoneW * 0.56;
            h = safeZoneH * 0.24;
        };
        // Sound
        class SoundLabel: RscText
        {
            idc = -1;
            text = "Sound (CfgSounds):";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.59;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class SoundEdit: RscEdit
        {
            idc = 9004;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.59;
            w = safeZoneW * 0.38;
            h = safeZoneH * 0.028;
        };
        // Duration
        class DurationLabel: RscText
        {
            idc = -1;
            text = "Duration (s):";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.63;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class DurationEdit: RscEdit
        {
            idc = 9005;
            text = "6";
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.63;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        // Style
        class StyleLabel: RscText
        {
            idc = -1;
            text = "Style:";
            x = safeZoneX + safeZoneW * 0.52;
            y = safeZoneY + safeZoneH * 0.63;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        class StyleCombo: RscCombo
        {
            idc = 9006;
            x = safeZoneX + safeZoneW * 0.60;
            y = safeZoneY + safeZoneH * 0.63;
            w = safeZoneW * 0.18;
            h = safeZoneH * 0.028;
            onLoad = "_c = _this select 0; _c lbAdd 'Default'; _c lbAdd 'Command'; _c lbAdd 'Warning'; _c lbAdd 'Enemy'; _c lbAdd 'System'; _c lbSetCurSel 0;";
        };
        // Speaker text size
        class SpeakerSizeLabel: RscText
        {
            idc = -1;
            text = "Speaker text size:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.667;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class SpeakerSizeEdit: RscEdit
        {
            idc = 9007;
            text = "1.1";
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.667;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        // Text size
        class TextSizeLabel: RscText
        {
            idc = -1;
            text = "Text size:";
            x = safeZoneX + safeZoneW * 0.52;
            y = safeZoneY + safeZoneH * 0.667;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        class TextSizeEdit: RscEdit
        {
            idc = 9008;
            text = "1.0";
            x = safeZoneX + safeZoneW * 0.60;
            y = safeZoneY + safeZoneH * 0.667;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        // Delay
        class DelayLabel: RscText
        {
            idc = -1;
            text = "Delay before (s):";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.704;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class DelayEdit: RscEdit
        {
            idc = 9009;
            text = "0";
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.704;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        // Transmit/cancel buttons
        class OkButton: RscButtonMenuOK
        {
            idc = 1;
            text = "TRANSMIT";
            x = safeZoneX + safeZoneW * 0.56;
            y = safeZoneY + safeZoneH * 0.78;
            w = safeZoneW * 0.11;
            h = safeZoneH * 0.035;
            onButtonClick = "[] call ITR_fnc_zeusDialogCommit;";
        };

        class CancelButton: RscButtonMenuCancel
        {
            idc = 2;
            text = "CANCEL";
            x = safeZoneX + safeZoneW * 0.69;
            y = safeZoneY + safeZoneH * 0.78;
            w = safeZoneW * 0.11;
            h = safeZoneH * 0.035;
        };
    };
};