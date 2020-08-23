// Resident Evil/BioHazard Code: Veronica Auto Splitter
// By Kapdap 2020/07/16
// Last updated 2020/08/07
// https://github.com/kapdap/re-cvx-autosplitter

state("rpcs3") {}
state("pcsx2") {}

startup
{
    // Split tracker
    vars.splits = new Dictionary<string, bool>();

    // Inventory split tracker
    vars.tracker = new Dictionary<byte, bool>();
    vars.indexer = new Dictionary<byte, string>();

    // Adds a split
    vars.AddSplit = (Action<string, bool, string, string>)((id, default_value, description, parent) => {
        vars.splits.Add(id, false);
        settings.Add(id, default_value, description, parent);
    });

    // Adds an inventory split
    vars.AddTracker = (Action<byte, string, bool, string, string>)((code, id, default_value, description, parent) => {
        vars.tracker.Add(code, false);
        vars.indexer.Add(code, id);  // Map item code to split name
        settings.Add(id, default_value, description, parent);
    });

    // Resets split tracker
    vars.ResetSplits = (Action) (() => {
        List<string> keys = new List<string>(vars.splits.Keys);
        foreach(string key in keys)
        {
            vars.splits[key] = false;
        }
    });

    // Resets inventory split tracker
    vars.ResetTracker = (Action) (() => {
        List<byte> keys = new List<byte>(vars.tracker.Keys);
        foreach(byte key in keys)
        {
            vars.tracker[key] = false;
        }
    });

    // Swaps 2 byte values
    vars.SwapBytes = (Func<ushort, ushort>)((value) => {
        int b1 = (value >> 0) & 0xff;
        int b2 = (value >> 8) & 0xff;

        return (ushort) (b1 << 8 | b2 << 0);
    });

    // Swaps 4 byte values
    vars.SwapBytesInt = (Func<uint, uint>)((value) => {
        return ((value & 0x000000ff) << 24) +
            ((value & 0x0000ff00) << 8) +
            ((value & 0x00ff0000) >> 8) +
            ((value & 0xff000000) >> 24);
    });

    settings.Add("events", true, "Events");
    vars.AddSplit("tyrantPlane", false, "Tyrant Plane Fight", "events");
    settings.SetToolTip("tyrantPlane", "Splits when Claire opens the door to the cargo hold");
    vars.AddSplit("antarcticaBase", false, "Antartic Transport Terminal", "events");
    settings.SetToolTip("antarcticaBase", "Splits during the cutscene when the plane crashes into the Antartic Transport Terminal");
    vars.AddSplit("nosferatuFight", false, "Nosferatu Fight", "events");
    settings.SetToolTip("nosferatuFight", "Splits during the cutscene when Claire and Steve arrive at the helipad");
    vars.AddSplit("startChris", false, "Start as Chris", "events");
    settings.SetToolTip("startChris", "Splits during cutscene when Chris arrives at Rockfort Island");
    vars.AddSplit("endGame", true, "End Game", "events");
    settings.SetToolTip("endGame", "Splits when the game rank screen displays");

    settings.Add("weapongroup", true, "Weapons");
    vars.AddSplit("combatKnife", false, "Combat Knife", "weapongroup");
    vars.AddTracker(0x09, "handgun", false, "Handgun", "weapongroup");
    vars.AddSplit("subMachineGun", false, "Sub Machine Gun", "weapongroup");
    vars.AddTracker(0x21, "goldLugers", false, "Gold Lugers", "weapongroup");
    vars.AddTracker(0x06, "grenadeLauncher", false, "Grenade Launcher", "weapongroup");
    vars.AddTracker(0x07, "bowGun", false, "Bow Gun", "weapongroup");
    vars.AddTracker(0x04, "shotgun", false, "Shotgun", "weapongroup");
    vars.AddTracker(0x0B, "linearLauncher", false, "Linear Launcher", "weapongroup");

    settings.Add("keygroup", true, "Keys (Rockfort)");
    vars.AddTracker(0x54, "padlockKey", false, "Padlock Key", "keygroup");
    vars.AddTracker(0x44, "goldKey", false, "Gold Key", "keygroup");
    vars.AddTracker(0x43, "silverKey", false, "Silver Key", "keygroup");
    vars.AddTracker(0x4B, "airportKey", false, "Airport Key", "keygroup");
    vars.AddTracker(0x61, "chemStorageKey", false, "Chem. Storage Key", "keygroup");
    vars.AddTracker(0x60, "turnTableKey", false, "Turn Table Key", "keygroup");

    settings.Add("keyantarcticagroup", true, "Keys (Antarctica)");
    vars.AddTracker(0x5A, "miningRoomKey", false, "Mining Room Key", "keyantarcticagroup");
    vars.AddTracker(0x59, "machineRoomKey", false, "Machine Room Key", "keyantarcticagroup");
    vars.AddTracker(0x36, "craneKey", false, "Crane Key", "keyantarcticagroup");
    vars.AddTracker(0x5C, "sterileRoomKey", false, "Sterile Room Key", "keyantarcticagroup");

    settings.Add("toolsgroup", true, "Tools");
    vars.AddTracker(0x52, "extinguisher", false, "Extinguisher", "toolsgroup");
    vars.AddTracker(0x35, "steeringWheel", false, "Steering Wheel", "toolsgroup");
    vars.AddTracker(0x4D, "skeletonPicture", false, "Skeleton Picture", "toolsgroup");
    vars.AddTracker(0x33, "glassEye", false, "Glass Eye", "toolsgroup");
    vars.AddTracker(0x67, "rustedSword", false, "Rusted Sword", "toolsgroup");
    vars.AddTracker(0x34, "pianoRoll", false, "Piano Roll", "toolsgroup");
    vars.AddTracker(0x41, "controlLever", false, "Control Lever", "toolsgroup");
    vars.AddTracker(0x5B, "barCodeSticker", false, "Bar Code Sticker", "toolsgroup");
    vars.AddTracker(0x27, "gasMask", false, "Gas Mask", "toolsgroup");
    vars.AddTracker(0x5E, "batteryPack", false, "Battery Pack", "toolsgroup");
    vars.AddTracker(0x5D, "doorKnob", false, "Door Knob", "toolsgroup");
    vars.AddTracker(0x64, "tankObject", false, "Tank Object", "toolsgroup");
    vars.AddTracker(0x51, "halberd", false, "Halberd", "toolsgroup");
    vars.AddTracker(0x75, "paperWeight", false, "Paper Weight", "toolsgroup");

    settings.Add("cardgroup", true, "Cards");
    vars.AddTracker(0x3E, "biohazardCard", false, "Biohazard Card", "cardgroup");
    vars.AddTracker(0x4C, "emblemCard", false, "Emblem Card", "cardgroup");
    vars.AddTracker(0x69, "securityCard", false, "Security Card", "cardgroup");

    settings.Add("emblemgroup", true, "Emblems");
    vars.AddTracker(0x3B, "hawkEmblem", false, "Hawk Emblem", "emblemgroup");
    vars.AddTracker(0x56, "spAlloyEmblem", false, "Sp. Alloy Emblem", "emblemgroup");
    vars.AddTracker(0x53, "briefcase", false, "Briefcase", "emblemgroup");
    vars.AddTracker(0x55, "tg01", false, "TG-01", "emblemgroup");

    settings.Add("proofgroup", true, "Proofs");
    vars.AddTracker(0x46, "navyProof", false, "Navy Proof", "proofgroup");
    vars.AddTracker(0x45, "armyProof", false, "Army Proof", "proofgroup");
    vars.AddSplit("airForceProof", false, "Air Force Proof", "proofgroup");
    vars.AddSplit("airForceProofChris", false, "Air Force Proof (Chris)", "proofgroup");

    settings.Add("jewelgroup", true, "Family Jewels");
    vars.AddTracker(0x2B, "alexandersPierce", false, "Alexander's Pierce", "jewelgroup");
    vars.AddTracker(0x6B, "alexiasChoker", false, "Alexia's Choker", "jewelgroup");
    vars.AddTracker(0x2D, "alfredsRing", false, "Alfred's Ring", "jewelgroup");
    vars.AddTracker(0x2C, "alexandersJewel", false, "Alexander's Jewel", "jewelgroup");
    vars.AddTracker(0x6C, "alexiasJewel", false, "Alexia's Jewel", "jewelgroup");
    vars.AddTracker(0x2E, "alfredsJewel", false, "Alfred's Jewel", "jewelgroup");

    settings.Add("tigergroup", true, "Tiger Jewels");
    vars.AddTracker(0x70, "blueJewel", false, "Blue Jewel", "tigergroup");
    vars.AddTracker(0x6F, "redJewel", false, "Red Jewel", "tigergroup");

    settings.Add("dragonflygroup", true, "Dragonflies");
    vars.AddTracker(0x77, "silverDragonfly", false, "Silver Dragonfly", "dragonflygroup");
    vars.AddTracker(0x76, "silverDragonflyObject", false, "Silver Dragonfly (No Wings)", "dragonflygroup");
    vars.AddTracker(0x42, "goldDragonfly", false, "Gold Dragonfly", "dragonflygroup");
    vars.AddTracker(0x4F, "goldDragonflyObject", false, "Gold Dragonfly (No Wings)", "dragonflygroup");
    vars.AddTracker(0x78, "wingObject", false, "Wing Object (First Pickup)", "dragonflygroup");

    settings.Add("antgroup", true, "Ants");
    vars.AddTracker(0x3C, "queenAntObject", false, "Queen Ant Object", "antgroup");
    vars.AddTracker(0x3D, "kingAntObject", false, "King Ant Object", "antgroup");

    settings.Add("valvegroup", true, "Valves");
    vars.AddTracker(0x57, "valveHandle", false, "Valve Handle", "valvegroup");
    vars.AddSplit("octaValveHandle", false, "Octa Valve Handle", "valvegroup");
    vars.AddSplit("octaValveHandleChris", false, "Octa Valve Handle (Chris)", "valvegroup");
    vars.AddTracker(0x72, "sqValveHandle", false, "Sq. Valve Handle", "valvegroup");
    vars.AddTracker(0x71, "squaresocket", false, "Square Socket", "valvegroup");

    settings.Add("clementgroup", true, "Clement");
    vars.AddTracker(0x63, "clementSigma", false, "Clement Sigma", "clementgroup");
    vars.AddTracker(0x62, "clementAlpha", false, "Clement Alpha", "clementgroup");
    vars.AddTracker(0x90, "clementMixture", false, "Clement Mixture", "clementgroup");

    settings.Add("plategroup", true, "Eagle Plates");
    vars.AddSplit("eaglePlateDiorama", false, "Eagle Plate (Diorama Room)", "plategroup");
    vars.AddSplit("eaglePlateUmbrella", false, "Eagle Plate (Umbrella Meeting Room)", "plategroup");
    vars.AddSplit("eaglePlateWaterPool", false, "Eagle Plate (Water Pool)", "plategroup");

    settings.Add("musicboxgroup", true, "Music Box Plates");
    vars.AddSplit("musicBoxPlate", false, "Music Box Plate", "musicboxgroup");
    vars.AddSplit("musicBoxPlateChris", false, "Music Box Plate (Chris)", "musicboxgroup");

    settings.Add("containers", true, "Containers");
    vars.AddTracker(0x74, "earthenwareVase", false, "Earthenware Vase", "containers");
    settings.SetToolTip("earthenwareVase", "Contains the Queen Ant Object");
    vars.AddTracker(0x7E, "plantPot", false, "Plant Pot", "containers");
    settings.SetToolTip("plantPot", "Contains the Machine Room Key");
    vars.AddTracker(0x79, "crystal", false, "Crystal", "containers");
    settings.SetToolTip("crystal", "Contains the Security Card for Claire");
    vars.AddTracker(0x6A, "securityFile", false, "Security File", "containers");
    settings.SetToolTip("securityFile", "Contains the Security Card for Chris");

    // Items that are not normally used in a speedrun
    settings.Add("othergroup", false, "Other");
    vars.AddTracker(0x40, "detonator", false, "Detonator", "othergroup");
    vars.AddTracker(0x95, "emptyExtinguisher", false, "Empty Extinguisher", "othergroup");
    vars.AddTracker(0x68, "hemostatic", false, "Hemostatic", "othergroup");
    vars.AddTracker(0x49, "idCard", false, "ID Card", "othergroup");
    vars.AddTracker(0x48, "keyWithTag", false, "Key With Tag", "othergroup");
    settings.SetToolTip("keyWithTag", "Changes to Storage Key when examined.");
    vars.AddTracker(0x32, "lockpick", false, "Lockpick", "othergroup");
    vars.AddTracker(0x88, "lugerReplica", false, "Luger Replica", "othergroup");
    vars.AddTracker(0x73, "serum", false, "Serum", "othergroup");

    // Weapons that are not normally used in a speedrun
    settings.Add("otherweapongroup", false, "Other (Weapons)");
    vars.AddTracker(0x02, "assaultRifle", false, "Assault Rifle", "otherweapongroup");
    vars.AddTracker(0x0A, "customHandgun", false, "Custom Handgun", "otherweapongroup");
    vars.AddTracker(0x83, "enhancedHandgun", false, "Enhanced Handgun", "otherweapongroup");
    vars.AddTracker(0x8E, "m1p", false, "M-100P", "otherweapongroup");
    vars.AddTracker(0x20, "magnum", false, "Magnum", "otherweapongroup");
    vars.AddTracker(0x03, "sniperRifle", false, "Sniper Rifle", "otherweapongroup");
    vars.AddSplit("subMachineGunChris", false, "Sub Machine Gun (Chris)", "otherweapongroup");

    // Application information
    settings.Add("infogroup", false, "Info");
    settings.Add("infogroup1", false, "Resident Evil: Code: Veronica Auto Splitter by Kapdap", "infogroup");
    settings.Add("infogroup2", false, "Website: https://github.com/kapdap/re-cvx-autosplitter", "infogroup");
    settings.Add("infogroup3", false, "Last Update: 2020-08-07T15:15:00+1200", "infogroup");
}

init
{
    vars.gameProcess = String.Empty; // Used to detect when the process has changed
    vars.productCode = String.Empty; // Used to detect when the game release has changed
    vars.basePointer = IntPtr.Zero; // Emulator virtual memory base pointer
    vars.isBigEndian = false; // Console uses big endian (e.g. PS3)

    // Sets memory pointers for the detected game release
    vars.UpdatePointers = (Action) (() => {
        switch ((string)vars.productCode)
        {
            case "SLPM_650.22": // [PS2] [JP] BioHazard Code: Veronica Kanzenban
                vars.timePtr = 0x004314A0;
                vars.roomPtr = 0x004314B4;
                vars.screenPtr = 0x00430C4C;
                vars.healthPtr = 0x004301FC;
                vars.statusPtr = 0x0042FE6A;
                vars.characterPtr = 0x00430C84;
                vars.inventoryPtr = 0x00430E70;
                break;

            case "SLUS_201.84": // [PS2] [US] Resident Evil Code: Veronica X
                vars.timePtr = 0x004339A0;
                vars.roomPtr = 0x004339B4;
                vars.screenPtr = 0x0043314C;
                vars.healthPtr = 0x004326FC;
                vars.statusPtr = 0x0043236A;
                vars.characterPtr = 0x00433184;
                vars.inventoryPtr = 0x00433370;
                break;

            case "SLES_503.06": // [PS2] [EU] Resident Evil Code: Veronica X
                vars.timePtr = 0x0044A1D0;
                vars.roomPtr = 0x0044A1E4;
                vars.screenPtr = 0x0044997C;
                vars.healthPtr = 0x00448F2C;
                vars.statusPtr = 0x00448B9A;
                vars.characterPtr = 0x004499B4;
                vars.inventoryPtr = 0x00449BA0;
                break;

            case "NPUB30467": // [PS3] [US] Resident Evil Code: Veronica X HD
                vars.timePtr = 0x00BB3DB8;
                vars.roomPtr = 0x00BB3DCC;
                vars.screenPtr = 0x00BB3565;
                vars.healthPtr = 0x00BDEA1C;
                vars.statusPtr = 0x00BDE689;
                vars.characterPtr = 0x00BB359C;
                vars.inventoryPtr = 0x00BB3788;
                break;

            case "NPEB00553": // [PS3] [EU] Resident Evil Code: Veronica X
                vars.timePtr = 0x00BC40B8;
                vars.roomPtr = 0x00BC40CC;
                vars.screenPtr = 0x00BC3865;
                vars.healthPtr = 0x00BEED1C;
                vars.statusPtr = 0x00BEE989;
                vars.characterPtr = 0x00BC389C;
                vars.inventoryPtr = 0x00BC3A88;
                break;

            // Default to PS3 JP release - most commonly speedrun version
            default: // NPJB00135 - [PS3] [JP] BioHazard Code: Veronica Kanzenban
                vars.timePtr = 0x00BB3E38;
                vars.roomPtr = 0x00BB3E4C;
                vars.screenPtr = 0x00BB35E5;
                vars.healthPtr = 0x00BDEA9C;
                vars.statusPtr = 0x00BDE709;
                vars.characterPtr = 0x00BB361C;
                vars.inventoryPtr = 0x00BB3808;
                break;
        }
    });

    // Detects if the process has changed
    vars.UpdateProcess = (Action) (() => {
        // Update process name if application has changed
        if (vars.gameProcess != game.ProcessName)
        {
            vars.gameProcess = game.ProcessName;

            // Set emulator base pointer and edianess values
            switch ((string)vars.gameProcess)
            {
                case "pcsx2":
                    vars.basePointer = 0x20000000;
                    vars.isBigEndian = false;
                    break;

                default: // rpcs3
                    vars.basePointer = 0x300000000;
                    vars.isBigEndian = true;
                    break;
            }
        }
    });

    // Detects if the game release has changed
    vars.UpdateProduct = (Action) (() => {
        string productCode;

        // Read game product code from memory
        switch ((string)vars.gameProcess)
        {
            case "pcsx2":
                productCode = memory.ReadString(new IntPtr(vars.basePointer + 0x00015B90), 11);
                break;

            default: // rpcs3
                productCode = memory.ReadString(new IntPtr(vars.basePointer + 0x20010251), 9);
                break;
        }

        // Update product code if the game release has changed
        if (vars.productCode != productCode)
        {
            vars.productCode = productCode;
            vars.UpdatePointers();
        }
    });

    // Updates game values
    vars.UpdateValues = (Action) (() => {
        uint time = 0; // In Game Timer
        ushort room = 0; // Room the character is in
        byte screen = 0; // Current game screen
        uint health = 0; // Character health
        byte status = 0; // Character status info
        byte character = 0; // Character ID (0 Claire, 1 Chris, 2 Steve, 3 Wesker)

        // Read values from memory
        memory.ReadValue<uint>(new IntPtr(vars.basePointer + vars.timePtr), out time);
        memory.ReadValue<ushort>(new IntPtr(vars.basePointer + vars.roomPtr), out room);
        memory.ReadValue<byte>(new IntPtr(vars.basePointer + vars.screenPtr), out screen);
        memory.ReadValue<uint>(new IntPtr(vars.basePointer + vars.healthPtr), out health);
        memory.ReadValue<byte>(new IntPtr(vars.basePointer + vars.statusPtr), out status);
        memory.ReadValue<byte>(new IntPtr(vars.basePointer + vars.characterPtr), out character);

        current.slot = 0; // Inventory slot number of the equipped item
        current.ammo = 0; // Ammo count for the equipped weapon
        current.time = vars.isBigEndian ? (int)vars.SwapBytesInt(time) : (int)time;
        current.room = vars.SwapBytes(room); // Room bytes always need to be swapped
        current.screen = screen;
        current.health = vars.isBigEndian ? (int)vars.SwapBytesInt(health) : (int)health;
        current.status = "Normal";
        current.character = character;
        current.inventory = new byte[11]; // Current characters inventory

        // Check status for gassed or poison flags
        if ((status & 0x20) != 0)
            current.status = "Gassed";
        else if ((status & 0x08) != 0)
            current.status = "Poison";

        int index = -1; // Inventory array index

        // Calculate starting pointer to the current characters inventory entries
        IntPtr pointer = new IntPtr(vars.basePointer + vars.inventoryPtr + (character * 0x40));

        // Read inventory of the current character
        for (int i = 0; i < 12; ++i)
        {
            uint item = 0; // Inventory entry

            // Read inventory entry from memory
            memory.ReadValue<uint>(pointer, out item);

            // Move pointer to the next entry
            pointer = IntPtr.Add(pointer, 0x4);

            // Convert to little endian if the console uses big endian
            item = vars.isBigEndian ? vars.SwapBytesInt(item) : item;

            // First entry is the slot number of the equipped item
            if (i == 0)
            {
                current.slot = item;
                continue;
            }

            // Remaing entries are inventory items
            byte[] bytes = BitConverter.GetBytes(item);

            // Set inventory index to the item ID
            current.inventory[++index] = bytes[2];

            // Read quantity if this item is equipped for the ammo count
            if (current.slot == (index + 1))
                current.ammo = BitConverter.ToInt16(bytes, 0);
        }
    });

    // Initialise values
    vars.UpdateProcess();
    vars.UpdateProduct();
    vars.UpdateValues();
}

start
{
    // Start when IGT is 0, in the Prison Cell room and the 1st item slot contains the Lighter
    return (current.time == 0 && current.room == 0 && current.inventory[0] == 0x37);
}

update
{
    vars.UpdateProcess();
    vars.UpdateProduct();
    vars.UpdateValues();

    if (timer.CurrentPhase == TimerPhase.NotRunning)
    {
        vars.ResetTracker();
        vars.ResetSplits();
    }
}

split
{
    // Split when an inventory entry changes
    for (int i = 0; i < current.inventory.Length; i++)
    {
        byte item = current.inventory[i];

        // Continue if the entry has not changed
        if (item == old.inventory[i]) continue;

        switch (item)
        {
            // Items that are picked up more than once are tracked based on the room they are found in
            case 0x08: // Combat Knife
                // Prison B1 Cells
                if (current.room == 0x0000 && !vars.splits["combatKnife"])
                {
                    // Prevents splitting when changing to Chris if the knife is skipped in the prison cells
                    vars.splits["combatKnife"] = true;
                    return settings["combatKnife"];
                }
                break;

            case 0x22: // Sub Machine Gun
                // Military Training Facility Warehouse
                if (current.room == 0x030A && !vars.splits["subMachineGun"])
                {
                    vars.splits["subMachineGun"] = true;
                    return settings["subMachineGun"];
                }

                // Military Training Facility B3 Cave
                if (current.room == 0x0716 && !vars.splits["subMachineGunChris"])
                {
                    vars.splits["subMachineGunChris"] = true;
                    return settings["subMachineGunChris"];
                }
                break;

            case 0x47: // Air Force Proof
                // Private Residence 4F Private Study
                if (current.room == 0x0207 && !vars.splits["airForceProof"])
                {
                    vars.splits["airForceProof"] = true;
                    return settings["airForceProof"];
                }

                // Airport Bridge
                if (current.room == 0x0801 && !vars.splits["airForceProofChris"])
                {
                    vars.splits["airForceProofChris"] = true;
                    return settings["airForceProofChris"];
                }
                break;

            case 0x4E: // Music Box Plate
                // Private Residence 2F Alexias Bedroom
                if (current.room == 0x0205 && !vars.splits["musicBoxPlate"])
                {
                    vars.splits["musicBoxPlate"] = true;
                    return settings["musicBoxPlate"];
                }

                // Antartic Transport Terminal B4 Alexias Bedroom
                if (current.room == 0x0918 && !vars.splits["musicBoxPlateChris"])
                {
                    vars.splits["musicBoxPlateChris"] = true;
                    return settings["musicBoxPlateChris"];
                }
                break;

            case 0x58: // Octo Valve Handle
                // Antartic Transport Terminal B1 Tool Storeroom
                if (current.room == 0x0602 && !vars.splits["octaValveHandle"])
                {
                    vars.splits["octaValveHandle"] = true;
                    return settings["octaValveHandle"];
                }

                // Antartic Transport Terminal B1 Mining Room
                if (current.room == 0x0906 && !vars.splits["octaValveHandleChris"])
                {
                    vars.splits["octaValveHandleChris"] = true;
                    return settings["octaValveHandleChris"];
                }
                break;

            case 0x38: // Eagle Plate
                // Military Training Facility 1F Diorama Room
                if (current.room == 0x0304 && !vars.splits["eaglePlateDiorama"])
                {
                    vars.splits["eaglePlateDiorama"] = true;
                    return settings["eaglePlateDiorama"];
                }

                // Palace 1F Umbrella Meeting Room
                if (current.room == 0x0106 && !vars.splits["eaglePlateUmbrella"])
                {
                    vars.splits["eaglePlateUmbrella"] = true;
                    return settings["eaglePlateUmbrella"];
                }

                // Military Training Facility B2 Water Pool
                if (current.room == 0x070A && !vars.splits["eaglePlateWaterPool"])
                {
                    vars.splits["eaglePlateWaterPool"] = true;
                    return settings["eaglePlateWaterPool"];
                }
                break;

            // Do not need to check room id if an item is picked up only once
            default:
                // Split the first time an item has been added to the inventory
                if (vars.tracker.ContainsKey(item) && !vars.tracker[item])
                {
                    vars.tracker[item] = true;
                    return settings[vars.indexer[item]];
                }
                break;
        }
    }

    // Transport Plane Cargo Hold
    if (current.room == 0x0501 && !vars.splits["tyrantPlane"])
    {
        vars.splits["tyrantPlane"] = true;
        return settings["tyrantPlane"];
    }

    // Antartic Transport Terminal B1 Silo
    if (current.room == 0x0600 && !vars.splits["antarcticaBase"])
    {
        vars.splits["antarcticaBase"] = true;
        return settings["antarcticaBase"];
    }

    // Antartic Transport Terminal 1F Helipad
    if (current.room == 0x060A && !vars.splits["nosferatuFight"])
    {
        vars.splits["nosferatuFight"] = true;
        return settings["nosferatuFight"];
    }

    // Military Training Facility B3 Cave
    if (current.room == 0x0716 && !vars.splits["startChris"])
    {
        vars.splits["startChris"] = true;
        return settings["startChris"];
    }

    // End Game Rank Screen
    if (current.screen == 0x04 && !vars.splits["endGame"])
    {
        vars.splits["endGame"] = true;
        return settings["endGame"];
    }
}

gameTime
{
    // Seconds = IGT / 60
    return TimeSpan.FromSeconds(current.time / 60.0);
}

isLoading
{
    return true;
}