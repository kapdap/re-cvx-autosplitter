// Resident Evil/BIOHAZARD Code Veronica X
// By Kapdap 2020/07/16
// Last updated 2020/08/01
// https://github.com/kapdap/re-cvx-autosplitter

state("rpcs3") {}
state("pcsx2") {}

startup
{
    // Inventory split tracking
    vars.indexer = new Dictionary<byte, string>();
    vars.tracker = new Dictionary<byte, bool>();

    // Event split tracking
    vars.events = new Dictionary<string, bool>();

    vars.AddSplit = (Action<byte, string, bool, string, string>)((code, id, default_value, description, parent) => {
        vars.indexer.Add(code, id);
        vars.tracker.Add(code, false);
        settings.Add(id, default_value, description, parent);
    });

    vars.AddEvent = (Action<string, bool, string, string>)((id, default_value, description, parent) => {
        vars.events.Add(id, false);
        settings.Add(id, default_value, description, parent);
    });

    vars.ResetTracker = (Action) (() => {
        List<byte> keys = new List<byte>(vars.tracker.Keys);
        foreach(byte key in keys)
        {
            vars.tracker[key] = false;
        }
    });

    vars.ResetEvents = (Action) (() => {
        List<string> keys = new List<string>(vars.events.Keys);
        foreach(string key in keys)
        {
            vars.events[key] = false;
        }
    });

    vars.SwapBytes = (Func<ushort, ushort>)((value) => {
        int b1 = (value >> 0) & 0xff;
        int b2 = (value >> 8) & 0xff;

        return (ushort) (b1 << 8 | b2 << 0);
    });

    vars.SwapBytesInt = (Func<uint, uint>)((value) => {
        return ((value & 0x000000ff) << 24) +
            ((value & 0x0000ff00) << 8) +
            ((value & 0x00ff0000) >> 8) +
            ((value & 0xff000000) >> 24);
    });

    settings.Add("events", true, "Events");
    vars.AddEvent("tyrantPlane", false, "Tyrant Plane Fight", "events");
    settings.SetToolTip("tyrantPlane", "Splits when Claire enters the cargo hold.");
    vars.AddEvent("antarcticaBase", false, "Antarctica Base", "events");
    vars.AddEvent("nosferatuFight", false, "Nosferatu Fight", "events");
    settings.SetToolTip("nosferatuFight", "Splits when Claire and Steve arrive at the helipad.");
    vars.AddEvent("startChris", false, "Start as Chris", "events");
    vars.AddEvent("endGame", true, "End Game", "events");
    settings.SetToolTip("endGame", "Splits when the game rank screen displays.");

    settings.Add("weapongroup", true, "Weapons");
    vars.AddSplit(0x08, "combatKnife", false, "Combat Knife", "weapongroup");
    vars.AddSplit(0x09, "handgun", false, "Handgun", "weapongroup");
    vars.AddEvent("subMachineGun", false, "Sub Machine Gun", "weapongroup");
    vars.AddSplit(0x21, "goldLugers", false, "Gold Lugers", "weapongroup");
    vars.AddSplit(0x06, "grenadeLauncher", false, "Grenade Launcher", "weapongroup");
    vars.AddSplit(0x07, "bowGun", false, "Bow Gun", "weapongroup");
    vars.AddSplit(0x04, "shotgun", false, "Shotgun", "weapongroup");
    vars.AddSplit(0x0B, "linearLauncher", false, "Linear Launcher", "weapongroup");

    settings.Add("keygroup", true, "Keys (Rockfort)");
    vars.AddSplit(0x54, "padlockKey", false, "Padlock Key", "keygroup");
    vars.AddSplit(0x44, "goldKey", false, "Gold Key", "keygroup");
    vars.AddSplit(0x43, "silverKey", false, "Silver Key", "keygroup");
    vars.AddSplit(0x4B, "airportKey", false, "Airport Key", "keygroup");
    vars.AddSplit(0x61, "chemStorageKey", false, "Chem. Storage Key", "keygroup");
    vars.AddSplit(0x60, "turnTableKey", false, "Turn Table Key", "keygroup");

    settings.Add("keyantarcticagroup", true, "Keys (Antarctica)");
    vars.AddSplit(0x5A, "miningRoomKey", false, "Mining Room Key", "keyantarcticagroup");
    vars.AddSplit(0x59, "machineRoomKey", false, "Machine Room Key", "keyantarcticagroup");
    vars.AddSplit(0x36, "craneKey", false, "Crane Key", "keyantarcticagroup");
    vars.AddSplit(0x5C, "sterileRoomKey", false, "Sterile Room Key", "keyantarcticagroup");

    settings.Add("toolsgroup", true, "Tools");
    vars.AddSplit(0x52, "extinguisher", false, "Extinguisher", "toolsgroup");
    vars.AddSplit(0x35, "steeringWheel", false, "Steering Wheel", "toolsgroup");
    vars.AddSplit(0x4D, "skeletonPicture", false, "Skeleton Picture", "toolsgroup");
    vars.AddSplit(0x33, "glassEye", false, "Glass Eye", "toolsgroup");
    vars.AddSplit(0x67, "rustedSword", false, "Rusted Sword", "toolsgroup");
    vars.AddSplit(0x34, "pianoRoll", false, "Piano Roll", "toolsgroup");
    vars.AddSplit(0x41, "controlLever", false, "Control Lever", "toolsgroup");
    vars.AddSplit(0x5B, "barCodeSticker", false, "Bar Code Sticker", "toolsgroup");
    vars.AddSplit(0x27, "gasMask", false, "Gas Mask", "toolsgroup");
    vars.AddSplit(0x5E, "batteryPack", false, "Battery Pack", "toolsgroup");
    vars.AddSplit(0x5D, "doorKnob", false, "Door Knob", "toolsgroup");
    vars.AddSplit(0x64, "tankObject", false, "Tank Object", "toolsgroup");
    vars.AddSplit(0x51, "halberd", false, "Halberd", "toolsgroup");
    vars.AddSplit(0x75, "paperWeight", false, "Paper Weight", "toolsgroup");

    settings.Add("cardgroup", true, "Cards");
    vars.AddSplit(0x3E, "biohazardCard", false, "Biohazard Card", "cardgroup");
    vars.AddSplit(0x4C, "emblemCard", false, "Emblem Card", "cardgroup");
    vars.AddSplit(0x69, "securityCard", false, "Security Card", "cardgroup");

    settings.Add("emblemgroup", true, "Emblems");
    vars.AddSplit(0x3B, "hawkEmblem", false, "Hawk Emblem", "emblemgroup");
    vars.AddSplit(0x56, "spAlloyEmblem", false, "Sp. Alloy Emblem", "emblemgroup");
    vars.AddSplit(0x53, "briefcase", false, "Briefcase", "emblemgroup");
    vars.AddSplit(0x55, "tg01", false, "TG-01", "emblemgroup");

    settings.Add("proofgroup", true, "Proofs");
    vars.AddSplit(0x46, "navyProof", false, "Navy Proof", "proofgroup");
    vars.AddSplit(0x45, "armyProof", false, "Army Proof", "proofgroup");
    vars.AddEvent("airForceProof", false, "Air Force Proof", "proofgroup");
    vars.AddEvent("airForceProofChris", false, "Air Force Proof (Chris)", "proofgroup");

    settings.Add("jewelgroup", true, "Family Jewels");
    vars.AddSplit(0x2B, "alexandersPierce", false, "Alexander's Pierce", "jewelgroup");
    vars.AddSplit(0x6B, "alexiasChoker", false, "Alexia's Choker", "jewelgroup");
    vars.AddSplit(0x2D, "alfredsRing", false, "Alfred's Ring", "jewelgroup");
    vars.AddSplit(0x2C, "alexandersJewel", false, "Alexander's Jewel", "jewelgroup");
    vars.AddSplit(0x6C, "alexiasJewel", false, "Alexia's Jewel", "jewelgroup");
    vars.AddSplit(0x2E, "alfredsJewel", false, "Alfred's Jewel", "jewelgroup");

    settings.Add("tigergroup", true, "Tiger Jewels");
    vars.AddSplit(0x70, "blueJewel", false, "Blue Jewel", "tigergroup");
    vars.AddSplit(0x6F, "redJewel", false, "Red Jewel", "tigergroup");

    settings.Add("dragonflygroup", true, "Dragonflies");
    vars.AddSplit(0x77, "silverDragonfly", false, "Silver Dragonfly", "dragonflygroup");
    vars.AddSplit(0x76, "silverDragonflyObject", false, "Silver Dragonfly (No Wings)", "dragonflygroup");
    vars.AddSplit(0x42, "goldDragonfly", false, "Gold Dragonfly", "dragonflygroup");
    vars.AddSplit(0x4F, "goldDragonflyObject", false, "Gold Dragonfly (No Wings)", "dragonflygroup");
    vars.AddSplit(0x78, "wingObject", false, "Wing Object (First Pickup)", "dragonflygroup");

    settings.Add("antgroup", true, "Ants");
    vars.AddSplit(0x3C, "queenAntObject", false, "Queen Ant Object", "antgroup");
    vars.AddSplit(0x3D, "kingAntObject", false, "King Ant Object", "antgroup");

    settings.Add("valvegroup", true, "Valves");
    vars.AddSplit(0x57, "valveHandle", false, "Valve Handle", "valvegroup");
    vars.AddEvent("octaValveHandle", false, "Octa Valve Handle", "valvegroup");
    vars.AddEvent("octaValveHandleChris", false, "Octa Valve Handle (Chris)", "valvegroup");
    vars.AddSplit(0x72, "sqValveHandle", false, "Sq. Valve Handle", "valvegroup");
    vars.AddSplit(0x71, "squaresocket", false, "Square Socket", "valvegroup");

    settings.Add("clementgroup", true, "Clement");
    vars.AddSplit(0x63, "clementSigma", false, "Clement Sigma", "clementgroup");
    vars.AddSplit(0x62, "clementAlpha", false, "Clement Alpha", "clementgroup");
    vars.AddSplit(0x90, "clementMixture", false, "Clement Mixture", "clementgroup");

    settings.Add("plategroup", true, "Eagle Plates");
    vars.AddEvent("eaglePlateDiorama", false, "Eagle Plate (Diorama Room)", "plategroup");
    vars.AddEvent("eaglePlateUmbrella", false, "Eagle Plate (Umbrella Meeting Room)", "plategroup");
    vars.AddEvent("eaglePlateWaterPool", false, "Eagle Plate (Water Pool)", "plategroup");

    settings.Add("musicboxgroup", true, "Music Box Plates");
    vars.AddEvent("musicBoxPlate", false, "Music Box Plate", "musicboxgroup");
    vars.AddEvent("musicBoxPlateChris", false, "Music Box Plate (Chris)", "musicboxgroup");

    settings.Add("containers", true, "Containers");
    vars.AddSplit(0x74, "earthenwareVase", false, "Earthenware Vase", "containers"); // Queen Ant Object
    vars.AddSplit(0x7E, "plantPot", false, "Plant Pot", "containers"); // Machine Room Key
    vars.AddSplit(0x79, "crystal", false, "Crystal", "containers"); // Security Card (as Claire)
    vars.AddSplit(0x6A, "securityFile", false, "Security File", "containers"); // Security Card (as Chris)

    settings.Add("othergroup", false, "Other");
    vars.AddSplit(0x40, "detonator", false, "Detonator", "othergroup");
    vars.AddSplit(0x95, "emptyExtinguisher", false, "Empty Extinguisher", "othergroup");
    vars.AddSplit(0x68, "hemostatic", false, "Hemostatic", "othergroup");
    vars.AddSplit(0x49, "idCard", false, "ID Card", "othergroup");
    vars.AddSplit(0x48, "keyWithTag", false, "Key With Tag", "othergroup"); // Storage Key
    vars.AddSplit(0x32, "lockpick", false, "Lockpick", "othergroup");
    vars.AddSplit(0x88, "lugerReplica", false, "Luger Replica", "othergroup");
    vars.AddSplit(0x73, "serum", false, "Serum", "othergroup");

    settings.Add("otherweapongroup", false, "Other (Weapons)");
    vars.AddSplit(0x02, "assaultRifle", false, "Assault Rifle", "otherweapongroup");
    vars.AddSplit(0x0A, "customHandgun", false, "Custom Handgun", "otherweapongroup");
    vars.AddSplit(0x83, "enhancedHandgun", false, "Enhanced Handgun", "otherweapongroup");
    vars.AddSplit(0x8E, "m1p", false, "M-100P", "otherweapongroup");
    vars.AddSplit(0x20, "magnum", false, "Magnum", "otherweapongroup");
    vars.AddSplit(0x03, "sniperRifle", false, "Sniper Rifle", "otherweapongroup");
    vars.AddEvent("subMachineGunChris", false, "Sub Machine Gun (Chris)", "otherweapongroup");

    settings.Add("infogroup", false, "Info");
    settings.Add("infogroup1", false, "Resident Evil: Code: Veronica Auto Splitter by Kapdap", "infogroup");
    settings.Add("infogroup2", false, "Website: https://github.com/kapdap/re-cvx-autosplitter", "infogroup");
    settings.Add("infogroup3", false, "Last Update: 2020-08-01T18:05:00+1200", "infogroup");
}

init
{
    vars.productCode = String.Empty;
    vars.gameProcess = String.Empty;
    vars.isBigEndian = false;
    vars.isReverseOrder = false;

    vars.UpdateAddresses = (Action<string>) ((productCode) => {
        switch (productCode)
        {
            case "SLPM_650.22":
                vars.timeAdr = 0x204314A0;
                vars.roomAdr = 0x204314B4;
                vars.rankAdr = 0x20430C4C;
                vars.healthAdr = 0x204301FC;
                vars.characterAdr = 0x20430C84;
                vars.inventoryAdr = 0x20430E70;
                break;

            case "SLUS_201.84":
                vars.timeAdr = 0x204339A0;
                vars.roomAdr = 0x204339B4;
                vars.rankAdr = 0x2043314C;
                vars.healthAdr = 0x204326FC;
                vars.characterAdr = 0x20433184;
                vars.inventoryAdr = 0x20433370;
                break;

            case "SLES_503.06":
                vars.timeAdr = 0x2044A1D0;
                vars.roomAdr = 0x2044A1E4;
                vars.rankAdr = 0x2044997C;
                vars.healthAdr = 0x20448F2C;
                vars.characterAdr = 0x204499B4;
                vars.inventoryAdr = 0x20449BA0;
                break;

            case "NPUB30467":
                vars.timeAdr = 0x300BB3DB8;
                vars.roomAdr = 0x300BB3DCC;
                vars.rankAdr = 0x300BB3565;
                vars.healthAdr = 0x300BDEA1F;
                vars.characterAdr = 0x300BB359C;
                vars.inventoryAdr = 0x300BB3788;
                break;

            case "NPEB00553":
                vars.timeAdr = 0x300BC40B8;
                vars.roomAdr = 0x300BC40CC;
                vars.rankAdr = 0x300BC3865;
                vars.healthAdr = 0x300BEED1F;
                vars.characterAdr = 0x300BC389C;
                vars.inventoryAdr = 0x300BC3A88;
                break;

            default: // NPJB00135
                vars.timeAdr = 0x300BB3E38;
                vars.roomAdr = 0x300BB3E4C;
                vars.rankAdr = 0x300BB35E5;
                vars.healthAdr = 0x300BDEA9F;
                vars.characterAdr = 0x300BB361C;
                vars.inventoryAdr = 0x300BB3808;
                break;
        }
    });

    vars.UpdateProduct = (Action) (() => {
        string productCode;

        switch (game.ProcessName)
        {
            case "pcsx2":
                productCode = memory.ReadString(new IntPtr(0x20015B90), 11);
                break;

            default: // rpcs3
                productCode = memory.ReadString(new IntPtr(0x320010251), 9);
                break;
        }

        if (vars.productCode != productCode)
        {
            vars.productCode = productCode;
            vars.UpdateAddresses(productCode);
        }
    });

    vars.UpdateProcess = (Action) (() => {
        if (vars.gameProcess != game.ProcessName)
        {
            vars.gameProcess = game.ProcessName;
            vars.isBigEndian = (vars.gameProcess == "rpcs3");
            vars.isReverseOrder = (vars.gameProcess == "pcsx2");
        }
    });

    vars.UpdateValues = (Action) (() => {
        uint time = 0;
        ushort room = 0;
        byte rank = 0x00;
        byte health = 0x00;
        byte character = 0x00;

        memory.ReadValue<uint>(new IntPtr(vars.timeAdr), out time);
        memory.ReadValue<ushort>(new IntPtr(vars.roomAdr), out room);
        memory.ReadValue<byte>(new IntPtr(vars.rankAdr), out rank);
        memory.ReadValue<byte>(new IntPtr(vars.healthAdr), out health);
        memory.ReadValue<byte>(new IntPtr(vars.characterAdr), out character);

        current.rank = rank;
        current.inventory = new byte[44];
        current.time = vars.isBigEndian ? (int)vars.SwapBytesInt(time) : (int)time;
        current.room = vars.SwapBytes(room);
        current.health = (int)health;
        current.character = character;

        int index = -1;
        int offset = vars.isReverseOrder ? 0x2 : 0x1;

        for (int x = 0; x < 4; ++x)
        {
            IntPtr ptr = IntPtr.Add(new IntPtr(vars.inventoryAdr), x * 0x40 + offset);
            for (int i = 0; i < 11; ++i)
            {
                ptr = IntPtr.Add(ptr, 0x4);

                byte item = 0;
                memory.ReadValue<byte>(ptr, out item);

                current.inventory[++index] = item;
            }
        }
    });

    vars.UpdateProcess();
    vars.UpdateProduct();
    vars.UpdateValues();
}

start
{
    return (current.time == 0 && current.room == 0 && current.inventory[1] == 0x91);
}

update
{
    vars.UpdateProcess();
    vars.UpdateProduct();
    vars.UpdateValues();

    if (timer.CurrentPhase == TimerPhase.NotRunning)
    {
        vars.ResetTracker();
        vars.ResetEvents();
    }
}

split
{
    for (int i = 0; i < current.inventory.Length; i++)
    {
        byte item = current.inventory[i];

        if (item == old.inventory[i]) continue;

        switch (item)
        {
            case 0x22: // Sub Machine Gun
                if (current.room == 0x030A && !vars.events["subMachineGun"])
                {
                    vars.events["subMachineGun"] = true;
                    return settings["subMachineGun"];
                }

                if (current.room == 0x0716 && !vars.events["subMachineGunChris"])
                {
                    vars.events["subMachineGunChris"] = true;
                    return settings["subMachineGunChris"];
                }
                break;

            case 0x47: // Air Force Proof
                if (current.room == 0x0207 && !vars.events["airForceProof"])
                {
                    vars.events["airForceProof"] = true;
                    return settings["airForceProof"];
                }

                if (current.room == 0x0801 && !vars.events["airForceProofChris"])
                {
                    vars.events["airForceProofChris"] = true;
                    return settings["airForceProofChris"];
                }
                break;

            case 0x4E: // Music Box Plate
                if (current.room == 0x0205 && !vars.events["musicBoxPlate"])
                {
                    vars.events["musicBoxPlate"] = true;
                    return settings["musicBoxPlate"];
                }

                if (current.room == 0x0918 && !vars.events["musicBoxPlateChris"])
                {
                    vars.events["musicBoxPlateChris"] = true;
                    return settings["musicBoxPlateChris"];
                }
                break;

            case 0x58: // Octo Valve Handle
                if (current.room == 0x0602 && !vars.events["octaValveHandle"])
                {
                    vars.events["octaValveHandle"] = true;
                    return settings["octaValveHandle"];
                }

                if (current.room == 0x0906 && !vars.events["octaValveHandleChris"])
                {
                    vars.events["octaValveHandleChris"] = true;
                    return settings["octaValveHandleChris"];
                }
                break;

            case 0x38: // Eagle Plate
                if (current.room == 0x0304 && !vars.events["eaglePlateDiorama"])
                {
                    vars.events["eaglePlateDiorama"] = true;
                    return settings["eaglePlateDiorama"];
                }

                if (current.room == 0x0106 && !vars.events["eaglePlateUmbrella"])
                {
                    vars.events["eaglePlateUmbrella"] = true;
                    return settings["eaglePlateUmbrella"];
                }

                if (current.room == 0x070A && !vars.events["eaglePlateWaterPool"])
                {
                    vars.events["eaglePlateWaterPool"] = true;
                    return settings["eaglePlateWaterPool"];
                }
                break;

            default:
                if (vars.tracker.ContainsKey(item) && !vars.tracker[item])
                {
                    vars.tracker[item] = true;
                    return settings[vars.indexer[item]];
                }
                break;
        }
    }

    if (current.room == 0x0501 && !vars.events["tyrantPlane"])
    {
        vars.events["tyrantPlane"] = true;
        return settings["tyrantPlane"];
    }

    if (current.room == 0x0600 && !vars.events["antarcticaBase"])
    {
        vars.events["antarcticaBase"] = true;
        return settings["antarcticaBase"];
    }

    if (current.room == 0x060A && !vars.events["nosferatuFight"])
    {
        vars.events["nosferatuFight"] = true;
        return settings["nosferatuFight"];
    }

    if (current.room == 0x0716 && !vars.events["startChris"])
    {
        vars.events["startChris"] = true;
        return settings["startChris"];
    }

    if (current.rank == 0x04 && !vars.events["endGame"])
    {
        vars.events["endGame"] = true;
        return settings["endGame"];
    }
}

gameTime
{
    return TimeSpan.FromSeconds(current.time / 60.0);
}

isLoading
{
    return true;
}