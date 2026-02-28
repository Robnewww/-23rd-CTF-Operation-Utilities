class CfgPatches
{
    class transmissionPing
    {
        name = "Objective Ping";
        units[] = { "ITR_ModuleObjectivePing", "ITR_ModuleObjectivePing_Zeus" };
        requiredVersion = 1.0;
        requiredAddons[] = { "A3_Modules_F", "A3_Modules_F_Curator", "A3_UI_F" };
        author = "Mugen"; // if you're reading this, Hi! Whatcha have for lunch today? :3
    };
};

class CfgFactionClasses
{
// Just inherit from ITR_Core :3
};

class CfgFunctions
{
    class ITR_OP
    {
        class ObjectivePing
        {
            file = "\x\incomingtransmissionping\addons\transmissionping\functions";

            // 3DEN/system functions
            class overlayPingShow {};
            class worldPingShow {};
            class objectivePingModule {};
            // Zeus functions
            class objectivePingModuleZeus {};
            class zeusPingDialogOpen {};
            class zeusPingDialogSetup {};
            class zeusPingDialogCommit {};
        };
    };
};

class RscText;
class RscStructuredText;
class RscEdit;
class RscCombo;
class RscButtonMenuOK;
class RscButtonMenuCancel;
class RscCheckbox;
class IGUIBack;
class RscTitles
{
    class ITR_OverlayPing // Banner for the ping
    {
        idd = -1;
        duration = 999999;
        fadein = 0;
        fadeout = 0;
        movingEnable = 0;
        onLoad  = "uiNamespace setVariable ['ITR_OverlayPing_Display', _this select 0]";
        onUnload = "uiNamespace setVariable ['ITR_OverlayPing_Display', displayNull]";

        class controls
        {
            // Main background
            class ITR_OP_Background: RscText
            {
                idc = 9000;
                x = safeZoneX + safeZoneW * 0.2;
                y = safeZoneY + safeZoneH * 0.1;
                w = safeZoneW * 0.6;
                h = safeZoneH * 0.08;
                colorBackground[] = {0, 0, 0, 0.6};
            };
            // Accent on left
            class ITR_OP_Accent: RscText
            {
                idc = 9001;
                x = safeZoneX + safeZoneW * 0.2;
                y = safeZoneY + safeZoneH * 0.1;
                w = safeZoneW * 0.005;
                h = safeZoneH * 0.08;
                colorBackground[] = {0.8, 0.4, 0.1, 1};
            };
            // Banner title
            class ITR_OP_Title: RscText
            {
                idc = 9002;
                style = 2; // centered
                x = safeZoneX + safeZoneW * 0.205;
                y = safeZoneY + safeZoneH * 0.102;
                w = safeZoneW * 0.59;
                h = safeZoneH * 0.03;
                sizeEx = 0.04;
                colorText[] = {1, 1, 1, 1};
                shadow = 2;
                text = "";
            };
            // Banner text
            class ITR_OP_Subtitle: RscStructuredText
            {
                idc = 9003;
                x = safeZoneX + safeZoneW * 0.205;
                y = safeZoneY + safeZoneH * 0.135;
                w = safeZoneW * 0.59;
                h = safeZoneH * 0.035;
                size = 0.03;
                colorText[] = {1, 1, 1, 0.9};
                shadow = 1;
                text = "";
            };
        };
    };
};

class ITR_OP_RscObjectivePingDialog // Zeus module window
{
    idd = 91000;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad   = "uiNamespace setVariable ['ITR_OP_RscObjectivePingDialog', _this select 0]; [_this select 0] call ITR_OP_fnc_zeusPingDialogSetup;";
    onUnload = "uiNamespace setVariable ['ITR_OP_RscObjectivePingDialog', displayNull];";

    class controlsBackground
    {
        // Main background
        class Background: IGUIBack
        {
            idc = -1;
            x = safeZoneX + safeZoneW * 0.20;
            y = safeZoneY + safeZoneH * 0.18;
            w = safeZoneW * 0.60;
            h = safeZoneH * 0.50;
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
            h = safeZoneH * 0.50;
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
        // Module title
        class DialogTitle: RscText
        {
            idc = -1;
            text = "OBJECTIVE PING";
            x = safeZoneX + safeZoneW * 0.205;
            y = safeZoneY + safeZoneH * 0.183;
            w = safeZoneW * 0.59;
            h = safeZoneH * 0.03;
            style = 2;
            font = "PuristaMedium";
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            moving = 1;
        };
        // Banner title
        class TitleLabel: RscText
        {
            idc = -1;
            text = "Banner title:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.23;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class TitleEdit: RscEdit
        {
            idc = 9101;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.23;
            w = safeZoneW * 0.38;
            h = safeZoneH * 0.028;
        };
        // Banner text
        class TextLabel: RscText
        {
            idc = -1;
            text = "Banner text:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.265;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class TextEdit: RscEdit
        {
            idc = 9102;
            style = 16;
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.30;
            w = safeZoneW * 0.56;
            h = safeZoneH * 0.16;
        };
        // Ping label
        class LabelLabel: RscText
        {
            idc = -1;
            text = "World ping label:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.47;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class LabelEdit: RscEdit
        {
            idc = 9103;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.47;
            w = safeZoneW * 0.38;
            h = safeZoneH * 0.028;
        };
        // Banner duration
        class BannerDurationLabel: RscText
        {
            idc = -1;
            text = "Banner duration (s):";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.51;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class BannerDurationEdit: RscEdit
        {
            idc = 9104;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.51;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        // Ping duration
        class PingDurationLabel: RscText
        {
            idc = -1;
            text = "Ping duration (s):";
            x = safeZoneX + safeZoneW * 0.52;
            y = safeZoneY + safeZoneH * 0.51;
            w = safeZoneW * 0.17;
            h = safeZoneH * 0.028;
        };
        class PingDurationEdit: RscEdit
        {
            idc = 9105;
            x = safeZoneX + safeZoneW * 0.70;
            y = safeZoneY + safeZoneH * 0.51;
            w = safeZoneW * 0.08;
            h = safeZoneH * 0.028;
        };
        // Ping icon
        class IconLabel: RscText
        {
            idc = -1;
            text = "Icon:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.55;
            w = safeZoneW * 0.10;
            h = safeZoneH * 0.028;
        };
        class IconCombo: RscCombo
        {
            idc = 9110;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.55;
            w = safeZoneW * 0.38;
            h = safeZoneH * 0.028;
        };
        // Color
        class ColorLabel: RscText
        {
            idc = -1;
            text = "Color:";
            x = safeZoneX + safeZoneW * 0.22;
            y = safeZoneY + safeZoneH * 0.59;
            w = safeZoneW * 0.10;
            h = safeZoneH * 0.028;
        };
        class ColorCombo: RscCombo
        {
            idc = 9111;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.59;
            w = safeZoneW * 0.38;
            h = safeZoneH * 0.028;
        };
        // Radio sound toggle
        class RadioCheck: RscCheckbox
        {
            idc = 9120;
            x = safeZoneX + safeZoneW * 0.40;
            y = safeZoneY + safeZoneH * 0.63;
            w = safeZoneW * 0.02;
            h = safeZoneH * 0.028;
        };
        class RadioLabel: RscText
        {
            idc = -1;
            text = "Play radio chatter";
            x = safeZoneX + safeZoneW * 0.43;
            y = safeZoneY + safeZoneH * 0.63;
            w = safeZoneW * 0.35;
            h = safeZoneH * 0.028;
        };
        // Send ping/cancel buttons
        class OkButton: RscButtonMenuOK
        {
            idc = 1;
            text = "SEND PING";
            x = safeZoneX + safeZoneW * 0.56;
            y = safeZoneY + safeZoneH * 0.635;
            w = safeZoneW * 0.11;
            h = safeZoneH * 0.035;
            onButtonClick = "[] call ITR_OP_fnc_zeusPingDialogCommit;";
        };
        class CancelButton: RscButtonMenuCancel
        {
            idc = 2;
            text = "CANCEL";
            x = safeZoneX + safeZoneW * 0.69;
            y = safeZoneY + safeZoneH * 0.635;
            w = safeZoneW * 0.11;
            h = safeZoneH * 0.035;
        };
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

    // Eden module
    class ITR_ModuleObjectivePing: Module_F
    {
        scope = 2; // Visible in editor
        scopeCurator = 1; // Hidden in Zeus
        displayName = "Objective Ping";
        category = "ITR_Module";
        function = "ITR_OP_fnc_objectivePingModule";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1; // Can be activated by trigger
        isDisposable = 1;
        curatorCanAttach = 1;

        class Arguments
        {
            class Title
            {
                displayName = "Banner Title";
                description = "Objective banner title";
                typeName = "STRING";
                defaultValue = "";
            };
            class Subtitle
            {
                displayName = "Banner Text";
                description = "Objective banner text";
                typeName = "STRING";
                defaultValue = "";
            };
            class Label
            {
                displayName = "World Ping Label";
                description = "Text label above world ping. If left empty, Banner Title will be used";
                typeName = "STRING";
                defaultValue = "";
            };
            class BannerDuration
            {
                displayName = "Banner Duration (sec)";
                description = "How long the screen banner stays visible";
                typeName = "NUMBER";
                defaultValue = 6;
            };
            class PingDuration
            {
                displayName = "World Ping Duration (sec)";
                description = "How long the 3D world ping stays visible";
                typeName = "NUMBER";
                defaultValue = 10;
            };
            class IconType
            {
                displayName = "World Ping Icon";
                description = "Which 3D icon to show at the objective";
                typeName = "NUMBER";
                defaultValue = 0;

                class values
                {
                    class Icon_Objective { name = "Objective"; value = 0; default = 1; };
                    class Icon_Flag { name = "Flag"; value = 1; };
                    class Icon_Destroy { name = "Destroy"; value = 2; };
                    class Icon_Pickup { name = "Pickup"; value = 3; };
                    class Icon_Unknown { name = "Unknown"; value = 4; };
                    class Icon_Warning { name = "Warning"; value = 5; };
                    class Icon_Support { name = "Support"; value = 6; };
                    class Icon_Join { name = "Join"; value = 7; };
                };
            };
            class ColorType
            {
                displayName = "World Ping Color";
                description = "Color of the world ping icon, label, and banner accent";
                typeName = "NUMBER";
                defaultValue = 0;

                class values
                {
                    class Col_Orange { name = "Orange / Gold"; value = 0; default = 1; };
                    class Col_White { name = "White"; value = 1; };
                    class Col_Green { name = "Green"; value = 2; };
                    class Col_Red { name = "Red"; value = 3; };
                    class Col_Blue { name = "Blue"; value = 4; };
                    class Col_Yellow { name = "Yellow"; value = 5; };
                    class Col_Cyan { name = "Cyan"; value = 6; };
                    class Col_Purple { name = "Purple"; value = 7; };
                };
            };
            class PlayRadio
            {
                displayName = "Play Radio Chatter";
                description = "If checked, plays a radio chatter sound when the ping sends";
                typeName = "BOOL";
                defaultValue = 0;
            };
        };

        class ModuleDescription: ModuleDescription
        {
            description = "Shows a cinematic banner and a 3D world ping at the module position so players know where a new objective/update is";
        };
    };

    // Zeus module
    class ITR_ModuleObjectivePing_Zeus: Module_F
    {
        scope = 1; // hidden in Eden
        scopeCurator = 2; // visible in Zeus only
        displayName = "Objective Ping";
        category = "ITR_Module";
        function = "ITR_OP_fnc_objectivePingModuleZeus";
        functionPriority = 1;
        isGlobal = 1;
        isDisposable = 1;
        curatorCanAttach = 1;

        class ModuleDescription: ModuleDescription
        {
            description = "Shows a cinematic banner and a 3D world ping at the module position so players know where a new objective/update is";
        };
    };
};