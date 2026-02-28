class CfgPatches
{
    class ITR_IntelCard
    {
        name = "ITR Intel Card";
        units[] = { "ITR_ModuleIntelSource" };
        requiredVersion = 1.0;
        requiredAddons[] = { "A3_Modules_F", "A3_UI_F" };
        author = "Mugen"; // This mod has been pain, but a good pain
    };
};

class CfgRemoteExec
{
    class Functions
    {
        mode = 1;
        jip = 1;

        // Client-local UI/actions
        class ITR_INT_fnc_showIntelCard
        {
            allowedTargets = 1;
            jip = 0;
        };
        class ITR_INT_fnc_addDiaryRecord
        {
            allowedTargets = 1;
            jip = 0;
        };
        class ITR_INT_fnc_removeIntelAction
        {
            allowedTargets = 1;
            jip = 0;
        };
        class ITR_INT_fnc_serverConsumeIntel
        {
            allowedTargets = 2; // server only
            jip = 0;
        };

        class ITR_INT_fnc_addIntelAction
        {
            allowedTargets = 1;
            jip = 1;
        };
    };
};

class CfgFunctions
{
    class ITR_INT
    {
        class IntelCard
        {
            file = "\x\incomingtransmissionintel\addons\transmissionintel\functions";

            // Client init
            class clientInit { postInit = 1; };

            // Runtime functions
            class showIntelCard {};
            class intelSourceModule {};
            class addIntelAction {};
            class removeIntelAction {};
            class addDiaryRecord {};
            class serverConsumeIntel {};
        };
    };
};

class RscText;
class RscStructuredText;
class IGUIBack;
class RscTitles
{
    class ITR_IntelCard
    {
        idd = -1;
        duration = 999999;
        fadein = 0;
        fadeout = 0;
        movingEnable = 0;
        onLoad  = "uiNamespace setVariable ['ITR_IntelCard_Display', _this select 0]";
        onUnload = "uiNamespace setVariable ['ITR_IntelCard_Display', displayNull]";

        class controls
        {
            class Intel_BG: IGUIBack
            {
                idc = 9100;
                x = safeZoneX + safeZoneW * 0.02;
                y = safeZoneY + safeZoneH * 0.70;
                w = safeZoneW * 0.26;
                h = safeZoneH * 0.18;
                colorBackground[] = {0, 0, 0, 0.75};
            };
            class Intel_Accent: RscText
            {
                idc = 9101;
                x = safeZoneX + safeZoneW * 0.02;
                y = safeZoneY + safeZoneH * 0.70;
                w = safeZoneW * 0.005;
                h = safeZoneH * 0.18;
                colorBackground[] = {0.96, 0.62, 0.0, 1};
            };
            class Intel_Title: RscText
            {
                idc = 9102;
                text = "NEW INTEL ACQUIRED";
                x = safeZoneX + safeZoneW * 0.027;
                y = safeZoneY + safeZoneH * 0.705;
                w = safeZoneW * 0.24;
                h = safeZoneH * 0.03;
                sizeEx = 0.035;
                font = "PuristaMedium";
                colorText[] = {1,1,1,1};
                shadow = 2;
            };
            class Intel_Tag: RscText
            {
                idc = 9103;
                text = "PRIMARY";
                x = safeZoneX + safeZoneW * 0.027;
                y = safeZoneY + safeZoneH * 0.735;
                w = safeZoneW * 0.10;
                h = safeZoneH * 0.025;
                sizeEx = 0.028;
                font = "PuristaLight";
                colorText[] = {1,1,1,0.9};
                shadow = 0;
            };
            class Intel_Text: RscStructuredText
            {
                idc = 9105;
                x = safeZoneX + safeZoneW * 0.027;
                y = safeZoneY + safeZoneH * 0.765;
                w = safeZoneW * 0.24;
                h = safeZoneH * 0.10;
                size = 0.028;
                shadow = 1;
                text = "Recovered enemy op-plan fragment.";
            };
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

    class ITR_ModuleIntelSource: Module_F
    {
        scope = 2;
        scopeCurator = 1;
        displayName = "Intel Object";
        category = "ITR_Module";
        function = "ITR_INT_fnc_intelSourceModule";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 1;
        curatorCanAttach = 1;

        class Arguments
        {
            class CardTitle
            {
                displayName = "Card Title";
                description = "Title shown on the on-screen intel card (e.g. 'Document Found')";
                typeName = "STRING";
                defaultValue = "";
            };
            class CardSummary
            {
                displayName = "Card Summary Text";
                description = "Short summary shown on the card (Optional)";
                typeName = "STRING";
                defaultValue = "";
            };
            class IntelPriority
            {
                displayName = "Priority";
                description = "Primary, secondary or optional intel (affects tag text only)";
                typeName = "NUMBER";
                defaultValue = 0;
                class values
                {
                    class Primary { name = "Primary"; value = 0; default = 1; };
                    class Secondary { name = "Secondary"; value = 1; };
                    class Optional { name = "Optional"; value = 2; };
                };
            };
            class ColorType
            {
                displayName = "Accent Colour";
                description = "Colour of the accent bar and title text";
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
            class Duration
            {
                displayName = "Card Duration (sec)";
                description = "How long the intel card stays on screen";
                typeName = "NUMBER";
                defaultValue = 10;
            };
            class ActionLabel
            {
                displayName = "Action Label";
                description = "Text for the interaction (e.g. 'Collect Intel', 'Check Bodies', 'Search Laptop').";
                typeName = "STRING";
                defaultValue = "";
            };
            class RemoveObject
            {
                displayName = "Remove Intel Object After Use";
                description = "If true, deletes the intel object after the card is shown once";
                typeName = "BOOL";
                defaultValue = 1;
            };
            class ShowGlobal
            {
                displayName = "Show Card To Everyone";
                description = "If true, all players see the card and get the diary entry. If false, only the user does";
                typeName = "BOOL";
                defaultValue = 1;
            };
            class SoundClass
            {
                displayName = "Sound (CfgSounds class)";
                description = "Optional CfgSounds class to play when intel is reviewed (leave blank for vanilla sound)";
                typeName = "STRING";
                defaultValue = "";
            };
            class DiarySubject
            {
                displayName = "Diary Entry Subject";
                description = "Tab/category name for this intel in the diary (e.g. Intel, Recovered Documents)";
                typeName = "STRING";
                defaultValue = "";
            };
            class DiaryTitle
            {
                displayName = "Diary Entry Title";
                description = "Title used for the diary entry. If left blank, uses the card title";
                typeName = "STRING";
                defaultValue = "";
            };
            class DiaryText
            {
                displayName = "Diary Entry Text";
                description = "Full long-form intel text for the diary entry";
                typeName = "STRING";
                defaultValue = "";
            };
        };

        class ModuleDescription: ModuleDescription
        {
            description = "SYNC THIS MODULE TO AN OBJECT. Player will get an intel interaction, resulting in an Intel Card pop-up and optional diary record entry.";
        };
    };
};
