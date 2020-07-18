// Resident Evil/BIOHAZARD Code Veronica X
// By Kapdap 2020/07/16
// Last updated 2020/07/18
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

    vars.SwapEndianness = (Func<ushort, ushort>)((value) => {
        int b1 = (value >> 0) & 0xff;
        int b2 = (value >> 8) & 0xff;

        return (ushort) (b1 << 8 | b2 << 0);
    });

    vars.SwapEndiannessInt = (Func<uint, uint>)((value) => {
        return ((value & 0x000000ff) << 24) +
            ((value & 0x0000ff00) << 8) +
            ((value & 0x00ff0000) >> 8) +
            ((value & 0xff000000) >> 24);
    });

    settings.Add("events", true, "Events");
    vars.AddEvent("endGame", true, "End Game", "events");

    settings.Add("weapongroup", true, "Weapons");
    vars.AddSplit(0x02, "assaultRifle", false, "Assault Rifle", "weapongroup");
    vars.AddSplit(0x07, "bowGun", false, "Bow Gun", "weapongroup");
    vars.AddSplit(0x08, "combatKnife", false, "Combat Knife", "weapongroup");
    vars.AddSplit(0x0A, "customHandgun", false, "Custom Handgun", "weapongroup");
    vars.AddSplit(0x83, "enhancedHandgun", false, "Enhanced Handgun", "weapongroup");
    vars.AddSplit(0x06, "grenadeLauncher", false, "Grenade Launcher", "weapongroup");
    vars.AddSplit(0x09, "handgun", false, "Handgun", "weapongroup");
    vars.AddSplit(0x0B, "linearLauncher", false, "Linear Launcher", "weapongroup");
    vars.AddSplit(0x20, "magnum", false, "Magnum", "weapongroup");
    vars.AddSplit(0x04, "shotgun", false, "Shotgun", "weapongroup");
    vars.AddSplit(0x03, "sniperRifle", false, "Sniper Rifle", "weapongroup");

    settings.Add("emblemgroup", true, "Emblems");
    vars.AddSplit(0x3B, "hawkEmblem", false, "Hawk Emblem", "emblemgroup");
    vars.AddSplit(0x56, "spAlloyEmblemA", false, "Sp. Alloy Emblem (Hawk)", "emblemgroup");
    vars.AddSplit(0x65, "spAlloyEmblemB", false, "Sp. Alloy Emblem B", "emblemgroup");
    vars.AddSplit(0x53, "briefcase", false, "Briefcase", "emblemgroup");
    vars.AddSplit(0x55, "tg01", false, "TG-01", "emblemgroup");

    settings.Add("cardgroup", true, "Cards");
    vars.AddSplit(0x86, "card", false, "Card", "cardgroup");
    vars.AddSplit(0x49, "idCard", false, "ID Card", "cardgroup");
    vars.AddSplit(0x3E, "biohazardCard", false, "Biohazard Card", "cardgroup");
    vars.AddSplit(0x4C, "emblemCard", false, "Emblem Card", "cardgroup");
    vars.AddSplit(0x69, "securityCard", false, "Security Card", "cardgroup");

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

    settings.Add("dragonflygroup", true, "Dragonfly");
    vars.AddSplit(0x78, "wingObject", false, "Wing Object", "dragonflygroup"); // There are 4 Wings to pickup
    vars.AddSplit(0x4F, "dragonflyObject", false, "Dragonfly Object", "dragonflygroup");
    vars.AddSplit(0x42, "goldDragonflyA", false, "Gold Dragonfly A", "dragonflygroup");
    vars.AddSplit(0x7A, "goldDragonflyB", false, "Gold Dragonfly B", "dragonflygroup");
    vars.AddSplit(0x7B, "goldDragonflyC", false, "Gold Dragonfly C", "dragonflygroup");
    vars.AddSplit(0x7C, "goldDragonflyD", false, "Gold Dragonfly D", "dragonflygroup");
    vars.AddSplit(0x76, "silverDragonflyA", false, "Silver Dragonfly A", "dragonflygroup");
    vars.AddSplit(0x77, "silverDragonflyB", false, "Silver Dragonfly B", "dragonflygroup");

    settings.Add("antgroup", true, "Ants");
    vars.AddSplit(0x3C, "queenAntObject", false, "Queen Ant Object", "antgroup");
    vars.AddSplit(0x6D, "queenAntReliefA", false, "Queen Ant Relief A", "antgroup");
    vars.AddSplit(0x89, "queenAntReliefB", false, "Queen Ant Relief B", "antgroup");
    vars.AddSplit(0x3D, "kingAntObject", false, "King Ant Object", "antgroup");
    vars.AddSplit(0x6E, "kingAntRelief", false, "King Ant Relief", "antgroup");

    settings.Add("submarinegroup", true, "Submarine");
    vars.AddSplit(0x35, "steeringWheel", false, "Steering Wheel", "submarinegroup");
    vars.AddSplit(0x47, "airForceProof", false, "Air Force Proof", "submarinegroup");
    vars.AddSplit(0x45, "armyProof", false, "Army Proof", "submarinegroup");
    vars.AddSplit(0x46, "navyProof", false, "Navy Proof", "submarinegroup");

    settings.Add("keygroup", true, "Keys");
    vars.AddSplit(0x4B, "airportKey", false, "Airport Key", "keygroup");
    vars.AddSplit(0x61, "chemStorageKey", false, "Chem. Storage Key", "keygroup");
    vars.AddSplit(0x36, "craneKey", false, "Crane Key", "keygroup");
    vars.AddSplit(0x99, "crestKeyG", false, "Crest Key G", "keygroup");
    vars.AddSplit(0x98, "crestKeyS", false, "Crest Key S", "keygroup");
    vars.AddSplit(0x33, "glassEye", false, "Glass Eye", "keygroup");
    vars.AddSplit(0x44, "goldKey", false, "Gold Key", "keygroup");
    vars.AddSplit(0x48, "keyWithTag", false, "Key With Tag", "keygroup");
    vars.AddSplit(0x59, "machineRoomKey", false, "Machine Room Key", "keygroup");
    vars.AddSplit(0x5A, "miningRoomKey", false, "Mining Room Key", "keygroup");
    vars.AddSplit(0x54, "padlockKey", false, "Padlock Key", "keygroup");
    vars.AddSplit(0x43, "silverKey", false, "Silver Key", "keygroup");
    vars.AddSplit(0x5C, "sterileRoomKey", false, "Sterile Room Key", "keygroup");
    vars.AddSplit(0x60, "turnTableKey", false, "Turn Table Key", "keygroup");
    vars.AddSplit(0x5D, "doorKnob", false, "Door Knob", "keygroup");

    settings.Add("valvegroup", true, "Valves");
    vars.AddSplit(0x57, "valveHandle", false, "Valve Handle", "valvegroup");
    vars.AddSplit(0x71, "socket", false, "Socket", "valvegroup");
    vars.AddSplit(0x58, "octaValveHandle", false, "Octa Valve Handle", "valvegroup");
    vars.AddSplit(0x96, "squareSocket", false, "Square Socket", "valvegroup");
    vars.AddSplit(0x72, "sqValveHandle", false, "Sq. Valve Handle", "valvegroup");

    settings.Add("clementgroup", true, "Clement");
    vars.AddSplit(0x62, "clementAlpha", false, "Clement Alpha", "clementgroup");
    vars.AddSplit(0x63, "clementSigma", false, "Clement Sigma", "clementgroup");
    vars.AddSplit(0x90, "clementMixture", false, "Clement Mixture", "clementgroup");

    settings.Add("miscgroup", true, "Misc");
    vars.AddSplit(0x5B, "barCodeSticker", false, "Bar Code Sticker", "miscgroup");
    vars.AddSplit(0x41, "controlLever", false, "Control Lever", "miscgroup");
    vars.AddSplit(0x5E, "batteryPack", false, "Battery Pack", "miscgroup");
    vars.AddSplit(0x52, "extinguisher", false, "Extinguisher", "miscgroup");
    vars.AddSplit(0x27, "gasMask", false, "Gas Mask", "miscgroup");
    vars.AddSplit(0x4D, "skeletonPicture", false, "Skeleton Picture", "miscgroup");
    vars.AddSplit(0x64, "tankObject", false, "Tank Object", "miscgroup");
    vars.AddSplit(0x39, "sidePack", false, "Side Pack", "miscgroup");
    vars.AddSplit(0x38, "eaglePlate", false, "Eagle Plate", "miscgroup");
    vars.AddSplit(0x4E, "musicBoxPlate", false, "Music Box Plate", "miscgroup");
    vars.AddSplit(0x34, "pianoRoll", false, "Piano Roll", "miscgroup");
    vars.AddSplit(0x21, "goldLugers", false, "Gold Lugers", "miscgroup");
    vars.AddSplit(0x88, "lugerReplica", false, "Luger Replica", "miscgroup");
    vars.AddSplit(0x67, "rustedSword", false, "Rusted Sword", "miscgroup");
    vars.AddSplit(0x40, "detonator", false, "Detonator", "miscgroup");
    vars.AddSplit(0x51, "halberd", false, "Halberd", "miscgroup");

    settings.Add("othergroup", true, "Other");
    vars.AddSplit(0x50, "album", false, "Album", "othergroup");
    vars.AddSplit(0x79, "crystal", false, "Crystal", "othergroup");
    vars.AddSplit(0x74, "earthenwareVase", false, "Earthenware Vase", "othergroup");
    vars.AddSplit(0x95, "emptyExtinguisher", false, "Empty Extinguisher", "othergroup");
    vars.AddSplit(0x5F, "hemostaticA", false, "Hemostatic A", "othergroup");
    vars.AddSplit(0x68, "hemostaticB", false, "Hemostatic B", "othergroup");
    vars.AddSplit(0x32, "lockpick", false, "Lockpick", "othergroup");
    vars.AddSplit(0x8E, "m1p", false, "M-1P", "othergroup");
    vars.AddSplit(0x3A, "map", false, "Map", "othergroup");
    vars.AddSplit(0x75, "paperWeight", false, "Paper Weight", "othergroup");
    vars.AddSplit(0x7E, "plantPot", false, "Plant Pot", "othergroup");
    vars.AddSplit(0x8C, "remoteController", false, "Remote Controller", "othergroup");
    vars.AddSplit(0x6A, "securityFile", false, "Security File", "othergroup");
    vars.AddSplit(0x73, "serum", false, "Serum", "othergroup");
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
                vars.roomAdr = 0x204314B5;
                vars.rankAdr = 0x204F5C90;
                vars.inventoryAdr = 0x20430E70;
                break;

            case "SLUS_201.84":
                vars.timeAdr = 0x204339A0;
                vars.roomAdr = 0x204339B5;
                vars.rankAdr = 0x204F8190;
                vars.inventoryAdr = 0x20433370;
                break;

            case "SLES_503.06":
                vars.timeAdr = 0x2044A1D0;
                vars.roomAdr = 0x2044A1E5;
                vars.rankAdr = 0x2050E9C0;
                vars.inventoryAdr = 0x20449BA0;
                break;

            case "NPUB30467":
                vars.timeAdr = 0x300BB3DB8;
                vars.roomAdr = 0x300BB3DCC;
                vars.rankAdr = 0x300000000; // TODO: Get address
                vars.inventoryAdr = 0x300BB3788;
                break;

            case "NPEB00553":
                vars.timeAdr = 0x300BC40B8;
                vars.roomAdr = 0x300BC40CC;
                vars.rankAdr = 0x300000000; // TODO: Get address
                vars.inventoryAdr = 0x300BC3A88;
                break;

            default: // NPJB00135
                vars.timeAdr = 0x300BB3E38;
                vars.roomAdr = 0x300BB3E4C;
                vars.rankAdr = 0x300000000; // TODO: Get address
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

        memory.ReadValue<uint>(new IntPtr(vars.timeAdr), out time);
        memory.ReadValue<ushort>(new IntPtr(vars.roomAdr), out room);
        memory.ReadValue<byte>(new IntPtr(vars.rankAdr), out rank);

        current.time = !vars.isBigEndian ? time : vars.SwapEndiannessInt(time);
        current.room = !vars.isBigEndian ? room : vars.SwapEndianness(room);
        current.rank = rank;
        current.inventory = new byte[44];

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

        if (vars.tracker.ContainsKey(item) && !vars.tracker[item] && item != old.inventory[i])
        {
            vars.tracker[item] = true;
            return settings[vars.indexer[item]];
        }
    }

    if (current.rank != 0x00 && !vars.events["endGame"])
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