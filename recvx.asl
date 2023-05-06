// Resident Evil/Biohazard: Code: Veronica Auto Splitter
// By Kapdap 2023/05/06
// https://github.com/kapdap/re-cvx-autosplitter

state("rpcs3") {}
state("pcsx2") {}
state("dolphin") {}

startup
{
    // Path to split log
    vars.logPath = "Components/recvx.txt";

    // Split tracker
    vars.splits = new Dictionary<string, bool>();

    // Inventory split tracker
    vars.itemSplits = new Dictionary<byte, bool>();
    vars.itemIndex = new Dictionary<byte, string>();

    // Adds a split
    vars.AddSplit = (Action<string, bool, string, string>)((id, default_value, description, parent) => {
        vars.splits.Add(id, false);
        settings.Add(id, default_value, description, parent);
    });

    // Adds an inventory split
    vars.AddItemSplit = (Action<byte, string, bool, string, string>)((code, id, default_value, description, parent) => {
        vars.itemSplits.Add(code, false);
        vars.itemIndex.Add(code, id);  // Map item code to split name
        settings.Add(id, default_value, description, parent);
    });

    // Resets split tracker
    vars.ResetSplits = (Action) (() => {
        List<string> keys = new List<string>(vars.splits.Keys);
        foreach(string key in keys)
            vars.splits[key] = false;
    });

    // Resets inventory split tracker
    vars.ResetItemSplits = (Action) (() => {
        List<byte> keys = new List<byte>(vars.itemSplits.Keys);
        foreach(byte key in keys)
            vars.itemSplits[key] = false;
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
    vars.AddItemSplit(0x09, "handgun", false, "Handgun", "weapongroup");
    vars.AddSplit("subMachineGun", false, "Sub Machine Gun", "weapongroup");
    vars.AddItemSplit(0x21, "goldLugers", false, "Gold Lugers", "weapongroup");
    vars.AddItemSplit(0x06, "grenadeLauncher", false, "Grenade Launcher", "weapongroup");
    vars.AddItemSplit(0x07, "bowGun", false, "Bow Gun", "weapongroup");
    vars.AddItemSplit(0x04, "shotgun", false, "Shotgun", "weapongroup");
    vars.AddItemSplit(0x0B, "linearLauncher", false, "Linear Launcher", "weapongroup");

    settings.Add("keygroup", true, "Keys (Rockfort)");
    vars.AddItemSplit(0x54, "padlockKey", false, "Padlock Key", "keygroup");
    vars.AddItemSplit(0x44, "goldKey", false, "Gold Key", "keygroup");
    vars.AddItemSplit(0x43, "silverKey", false, "Silver Key", "keygroup");
    vars.AddItemSplit(0x4B, "airportKey", false, "Airport Key", "keygroup");
    vars.AddItemSplit(0x61, "chemStorageKey", false, "Chem. Storage Key", "keygroup");
    vars.AddItemSplit(0x60, "turnTableKey", false, "Turn Table Key", "keygroup");

    settings.Add("keyantarcticagroup", true, "Keys (Antarctica)");
    vars.AddItemSplit(0x5A, "miningRoomKey", false, "Mining Room Key", "keyantarcticagroup");
    vars.AddItemSplit(0x59, "machineRoomKey", false, "Machine Room Key", "keyantarcticagroup");
    vars.AddItemSplit(0x36, "craneKey", false, "Crane Key", "keyantarcticagroup");
    vars.AddItemSplit(0x5C, "sterileRoomKey", false, "Sterile Room Key", "keyantarcticagroup");

    settings.Add("toolsgroup", true, "Tools");
    vars.AddItemSplit(0x52, "extinguisher", false, "Extinguisher", "toolsgroup");
    vars.AddItemSplit(0x35, "steeringWheel", false, "Steering Wheel", "toolsgroup");
    vars.AddItemSplit(0x4D, "skeletonPicture", false, "Skeleton Picture", "toolsgroup");
    vars.AddItemSplit(0x33, "glassEye", false, "Glass Eye", "toolsgroup");
    vars.AddItemSplit(0x67, "rustedSword", false, "Rusted Sword", "toolsgroup");
    vars.AddItemSplit(0x34, "pianoRoll", false, "Piano Roll", "toolsgroup");
    vars.AddItemSplit(0x41, "controlLever", false, "Control Lever", "toolsgroup");
    vars.AddItemSplit(0x5B, "barCodeSticker", false, "Bar Code Sticker", "toolsgroup");
    vars.AddItemSplit(0x27, "gasMask", false, "Gas Mask", "toolsgroup");
    vars.AddItemSplit(0x5E, "batteryPack", false, "Battery Pack", "toolsgroup");
    vars.AddItemSplit(0x5D, "doorKnob", false, "Door Knob", "toolsgroup");
    vars.AddItemSplit(0x64, "tankObject", false, "Tank Object", "toolsgroup");
    vars.AddItemSplit(0x51, "halberd", false, "Halberd", "toolsgroup");
    vars.AddItemSplit(0x75, "paperWeight", false, "Paper Weight", "toolsgroup");

    settings.Add("cardgroup", true, "Cards");
    vars.AddItemSplit(0x3E, "biohazardCard", false, "Biohazard Card", "cardgroup");
    vars.AddItemSplit(0x4C, "emblemCard", false, "Emblem Card", "cardgroup");
    vars.AddItemSplit(0x69, "securityCard", false, "Security Card", "cardgroup");

    settings.Add("emblemgroup", true, "Emblems");
    vars.AddItemSplit(0x3B, "hawkEmblem", false, "Hawk Emblem", "emblemgroup");
    vars.AddItemSplit(0x56, "spAlloyEmblem", false, "Sp. Alloy Emblem", "emblemgroup");
    vars.AddItemSplit(0x53, "briefcase", false, "Briefcase", "emblemgroup");
    vars.AddItemSplit(0x55, "tg01", false, "TG-01", "emblemgroup");

    settings.Add("proofgroup", true, "Proofs");
    vars.AddItemSplit(0x46, "navyProof", false, "Navy Proof", "proofgroup");
    vars.AddItemSplit(0x45, "armyProof", false, "Army Proof", "proofgroup");
    vars.AddSplit("airForceProof", false, "Air Force Proof", "proofgroup");
    vars.AddSplit("airForceProofChris", false, "Air Force Proof (Chris)", "proofgroup");

    settings.Add("jewelgroup", true, "Family Jewels");
    vars.AddItemSplit(0x2B, "alexandersPierce", false, "Alexander's Pierce", "jewelgroup");
    vars.AddItemSplit(0x6B, "alexiasChoker", false, "Alexia's Choker", "jewelgroup");
    vars.AddItemSplit(0x2D, "alfredsRing", false, "Alfred's Ring", "jewelgroup");
    vars.AddItemSplit(0x2C, "alexandersJewel", false, "Alexander's Jewel", "jewelgroup");
    vars.AddItemSplit(0x6C, "alexiasJewel", false, "Alexia's Jewel", "jewelgroup");
    vars.AddItemSplit(0x2E, "alfredsJewel", false, "Alfred's Jewel", "jewelgroup");

    settings.Add("tigergroup", true, "Tiger Jewels");
    vars.AddItemSplit(0x70, "blueJewel", false, "Blue Jewel", "tigergroup");
    vars.AddItemSplit(0x6F, "redJewel", false, "Red Jewel", "tigergroup");

    settings.Add("dragonflygroup", true, "Dragonflies");
    vars.AddItemSplit(0x77, "silverDragonfly", false, "Silver Dragonfly", "dragonflygroup");
    vars.AddItemSplit(0x76, "silverDragonflyObject", false, "Silver Dragonfly (No Wings)", "dragonflygroup");
    vars.AddItemSplit(0x42, "goldDragonfly", false, "Gold Dragonfly", "dragonflygroup");
    vars.AddItemSplit(0x4F, "goldDragonflyObject", false, "Gold Dragonfly (No Wings)", "dragonflygroup");
    vars.AddItemSplit(0x78, "wingObject", false, "Wing Object (First Pickup)", "dragonflygroup");

    settings.Add("antgroup", true, "Ants");
    vars.AddItemSplit(0x3C, "queenAntObject", false, "Queen Ant Object", "antgroup");
    vars.AddItemSplit(0x3D, "kingAntObject", false, "King Ant Object", "antgroup");

    settings.Add("valvegroup", true, "Valves");
    vars.AddItemSplit(0x57, "valveHandle", false, "Valve Handle", "valvegroup");
    vars.AddSplit("octaValveHandle", false, "Octa Valve Handle", "valvegroup");
    vars.AddSplit("octaValveHandleChris", false, "Octa Valve Handle (Chris)", "valvegroup");
    vars.AddItemSplit(0x72, "sqValveHandle", false, "Sq. Valve Handle", "valvegroup");
    vars.AddItemSplit(0x71, "squaresocket", false, "Square Socket", "valvegroup");

    settings.Add("clementgroup", true, "Clement");
    vars.AddItemSplit(0x63, "clementSigma", false, "Clement Sigma", "clementgroup");
    vars.AddItemSplit(0x62, "clementAlpha", false, "Clement Alpha", "clementgroup");
    vars.AddItemSplit(0x90, "clementMixture", false, "Clement Mixture", "clementgroup");

    settings.Add("plategroup", true, "Eagle Plates");
    vars.AddSplit("eaglePlateDiorama", false, "Eagle Plate (Diorama Room)", "plategroup");
    vars.AddSplit("eaglePlateUmbrella", false, "Eagle Plate (Umbrella Meeting Room)", "plategroup");
    vars.AddSplit("eaglePlateWaterPool", false, "Eagle Plate (Water Pool)", "plategroup");

    settings.Add("musicboxgroup", true, "Music Box Plates");
    vars.AddSplit("musicBoxPlate", false, "Music Box Plate", "musicboxgroup");
    vars.AddSplit("musicBoxPlateChris", false, "Music Box Plate (Chris)", "musicboxgroup");

    settings.Add("containers", true, "Containers");
    vars.AddItemSplit(0x74, "earthenwareVase", false, "Earthenware Vase", "containers");
    settings.SetToolTip("earthenwareVase", "Contains the Queen Ant Object");
    vars.AddItemSplit(0x7E, "plantPot", false, "Plant Pot", "containers");
    settings.SetToolTip("plantPot", "Contains the Machine Room Key");
    vars.AddItemSplit(0x79, "crystal", false, "Crystal", "containers");
    settings.SetToolTip("crystal", "Contains the Security Card for Claire");
    vars.AddItemSplit(0x6A, "securityFile", false, "Security File", "containers");
    settings.SetToolTip("securityFile", "Contains the Security Card for Chris");

    // Items that are not normally used in a speedrun
    settings.Add("othergroup", false, "Other");
    vars.AddItemSplit(0x40, "detonator", false, "Detonator", "othergroup");
    vars.AddItemSplit(0x95, "emptyExtinguisher", false, "Empty Extinguisher", "othergroup");
    vars.AddItemSplit(0x68, "hemostatic", false, "Hemostatic", "othergroup");
    vars.AddItemSplit(0x49, "idCard", false, "ID Card", "othergroup");
    vars.AddItemSplit(0x48, "keyWithTag", false, "Key With Tag", "othergroup");
    settings.SetToolTip("keyWithTag", "Changes to Storage Key when examined.");
    vars.AddItemSplit(0x32, "lockpick", false, "Lockpick", "othergroup");
    vars.AddItemSplit(0x88, "lugerReplica", false, "Luger Replica", "othergroup");
    vars.AddItemSplit(0x73, "serum", false, "Serum", "othergroup");

    // Weapons that are not normally used in a speedrun
    settings.Add("otherweapongroup", false, "Other (Weapons)");
    vars.AddItemSplit(0x02, "assaultRifle", false, "Assault Rifle", "otherweapongroup");
    vars.AddItemSplit(0x0A, "customHandgun", false, "Custom Handgun", "otherweapongroup");
    vars.AddItemSplit(0x83, "enhancedHandgun", false, "Enhanced Handgun", "otherweapongroup");
    vars.AddItemSplit(0x8E, "m1p", false, "M-100P", "otherweapongroup");
    vars.AddItemSplit(0x20, "magnum", false, "Magnum", "otherweapongroup");
    vars.AddItemSplit(0x03, "sniperRifle", false, "Sniper Rifle", "otherweapongroup");
    vars.AddSplit("subMachineGunChris", false, "Sub Machine Gun (Chris)", "otherweapongroup");

    // Splitter Options
    settings.Add("optionsGroup", false, "Options");
    settings.Add("logSplits", false, "Log Splits", "optionsGroup");
    settings.SetToolTip("logSplits", "Split log is saved to LiveSplit/" + vars.logPath);
    settings.Add("debugSplits", false, "Debug Splits", "optionsGroup");
    settings.SetToolTip("debugSplits", "Use DbgView application to view split log");

    // Application information
    settings.Add("infogroup", false, "Info");
    settings.Add("infogroup1", false, "Resident Evil: Code: Veronica Auto Splitter by Kapdap", "infogroup");
    settings.Add("infogroup2", false, "Website: https://github.com/kapdap/re-cvx-autosplitter", "infogroup");
    settings.Add("infogroup3", false, "Last Update: 2023-05-06T20:00:00+1200", "infogroup");
}

init
{
    vars.lastSplit = String.Empty; // Name of the most recent split
    vars.gameProcess = String.Empty; // Used to detect when the process has changed
    vars.productCode = String.Empty; // Used to detect when the game release has chang
    vars.isBigEndian = false; // Console uses big endian (e.g. PS3 and GCN)ed

    IntPtr basePointer = IntPtr.Zero; // Emulator virtual memory base pointer

    int timePtr = 0;
    int roomPtr = 0;
    int screenPtr = 0;
    int healthPtr = 0;
    int statusPtr = 0;
    int characterPtr = 0;
    int inventoryPtr = 0;

    // Log splits
    vars.LogSplit = (Action<string>)((text) => {
        vars.lastSplit = text;

        string log = timer.CurrentTime[timer.CurrentTimingMethod] + ": " + text;

        if (settings["logSplits"])
            File.AppendAllText(vars.logPath, log + System.Environment.NewLine);

        if (settings["debugSplits"])
            print("recvx split: " + log);
    });

    // Update split status
    vars.UpdateSplit = (Func<string, bool>)((split) => {
        if (!vars.splits[split])
        {
            vars.LogSplit(split);
            vars.splits[split] = true;
            return settings[split];
        }
        else
            return false;
    });

    // Update item split status
    vars.UpdateItemSplit = (Func<byte, bool>)((id) => {
        if (!vars.itemSplits[id])
        {
            vars.LogSplit(vars.itemIndex[id] + " (" + id.ToString() + ")");
            vars.itemSplits[id] = true;
            return settings[vars.itemIndex[id]];
        }
        else
            return false;
    });

    // Sets memory pointers for the detected game release
    vars.UpdatePointers = (Action) (() => {
        switch ((string)vars.productCode)
        {
            case "GCDJ08": // [GCN] [JP] Biohazard: Code: Veronica Kanzenban
                timePtr = 0x00438B9C;
                roomPtr = 0x00438BB0;
                screenPtr = 0x00438349;
                healthPtr = 0x004378FC;
                statusPtr = 0x00437579;
                characterPtr = 0x00438380;
                inventoryPtr = 0x0043856C;
                break;

            case "GCDE08": // [GCN] [US] Resident Evil: Code: Veronica X
                timePtr = 0x004345BC;
                roomPtr = 0x004345D0;
                screenPtr = 0x00433D69;
                healthPtr = 0x0043331C;
                statusPtr = 0x00432F99;
                characterPtr = 0x00433DA0;
                inventoryPtr = 0x00433F8C;
                break;

            case "GCDP08": // [GCN] [EU] Resident Evil: Code: Veronica X
                timePtr = 0x00438B5C;
                roomPtr = 0x00438B70;
                screenPtr = 0x00438309;
                healthPtr = 0x004378BC;
                statusPtr = 0x00437539;
                characterPtr = 0x00438340;
                inventoryPtr = 0x0043852C;
                break;

            case "SLPM_650.22": // [PS2] [JP] Biohazard: Code: Veronica Kanzenban
                timePtr = 0x004314A0;
                roomPtr = 0x004314B4;
                screenPtr = 0x00430C4C;
                healthPtr = 0x004301FC;
                statusPtr = 0x0042FE6A;
                characterPtr = 0x00430C84;
                inventoryPtr = 0x00430E70;
                break;

            case "SLUS_201.84": // [PS2] [US] Resident Evil: Code: Veronica X
                timePtr = 0x004339A0;
                roomPtr = 0x004339B4;
                screenPtr = 0x0043314C;
                healthPtr = 0x004326FC;
                statusPtr = 0x0043236A;
                characterPtr = 0x00433184;
                inventoryPtr = 0x00433370;
                break;

            case "SLES_503.06": // [PS2] [EU] Resident Evil: Code: Veronica X
                timePtr = 0x0044A1D0;
                roomPtr = 0x0044A1E4;
                screenPtr = 0x0044997C;
                healthPtr = 0x00448F2C;
                statusPtr = 0x00448B9A;
                characterPtr = 0x004499B4;
                inventoryPtr = 0x00449BA0;
                break;

            case "NPUB30467": // [PS3] [US] Resident Evil Code: Veronica X HD
                timePtr = 0x00BB3DB8;
                roomPtr = 0x00BB3DCC;
                screenPtr = 0x00BB3565;
                healthPtr = 0x00BDEA1C;
                statusPtr = 0x00BDE689;
                characterPtr = 0x00BB359C;
                inventoryPtr = 0x00BB3788;
                break;

            case "NPEB00553": // [PS3] [EU] Resident Evil Code: Veronica X
                timePtr = 0x00BC40B8;
                roomPtr = 0x00BC40CC;
                screenPtr = 0x00BC3865;
                healthPtr = 0x00BEED1C;
                statusPtr = 0x00BEE989;
                characterPtr = 0x00BC389C;
                inventoryPtr = 0x00BC3A88;
                break;

            default: // NPJB00135 - [PS3] [JP] Biohazard Code: Veronica Kanzenban
                timePtr = 0x00BB3E38;
                roomPtr = 0x00BB3E4C;
                screenPtr = 0x00BB35E5;
                healthPtr = 0x00BDEA9C;
                statusPtr = 0x00BDE709;
                characterPtr = 0x00BB361C;
                inventoryPtr = 0x00BB3808;
                break;
        }
    });

    // Detects if the process has changed
    vars.UpdateProcess = (Action) (() => {
        // Update process name if application has changed
        if (vars.gameProcess != game.ProcessName)
        {
            vars.gameProcess = game.ProcessName;

            // Set emulator edianess
            switch ((string)vars.gameProcess.ToLower())
            {
                case "dolphin":
                    vars.isBigEndian = true;
                    break;

                case "pcsx2":
                    vars.isBigEndian = false;
                    break;

                default: // rpcs3
                    vars.isBigEndian = true;
                    break;
            }
        }
    });

    // Set emulator base pointer
    vars.UpdatePointer = (Action) (() => {
        switch ((string)vars.gameProcess.ToLower())
        {
            case "dolphin":
                try
                {
                    // https://github.com/Jujstme/Autosplitters/blob/e6adbd04390cabd0a594f0b0ad47a64884a64b03/Template_GameCube.asl#L37
                    basePointer = game.MemoryPages(true).First(p => p.Type == MemPageType.MEM_MAPPED && p.State == MemPageState.MEM_COMMIT && (int)p.RegionSize == 0x2000000).BaseAddress;
                }
                catch (Exception e)
                {
                    basePointer = IntPtr.Zero;
                }
                break;

            case "pcsx2":
                basePointer = new IntPtr(0x20000000);
                break;

            default: // rpcs3
                basePointer = new IntPtr(0x300000000);
                break;
        }
    });

    // Detects if the game release has changed
    vars.UpdateProduct = (Action) (() => {
        string productCode;

        // Read game product code from memory
        switch ((string)vars.gameProcess.ToLower())
        {
            case "dolphin":
                productCode = memory.ReadString(basePointer, 6);
                break;

            case "pcsx2":
                productCode = memory.ReadString(IntPtr.Add(basePointer, 0x00015B90), 11);
                break;

            default: // rpcs3
                productCode = memory.ReadString(IntPtr.Add(basePointer, 0x20010251), 9);
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
        memory.ReadValue<uint>(IntPtr.Add(basePointer, timePtr), out time);
        memory.ReadValue<ushort>(IntPtr.Add(basePointer, roomPtr), out room);
        memory.ReadValue<byte>(IntPtr.Add(basePointer, screenPtr), out screen);
        memory.ReadValue<uint>(IntPtr.Add(basePointer, healthPtr), out health);
        memory.ReadValue<byte>(IntPtr.Add(basePointer, statusPtr), out status);
        memory.ReadValue<byte>(IntPtr.Add(basePointer, characterPtr), out character);

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

        // Pointer to the current characters inventory table
        IntPtr pointer = IntPtr.Add(basePointer, inventoryPtr + (character * 0x40));

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

            // Read quantity if this item is equipped
            if (current.slot == (index + 1))
                current.ammo = BitConverter.ToInt16(bytes, 0);
        }
    });

    // Initialise values
    vars.UpdateProcess();
    vars.UpdatePointer();
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
    vars.UpdatePointer();
    vars.UpdateProduct();
    vars.UpdateValues();

    if (timer.CurrentPhase == TimerPhase.NotRunning)
    {
        vars.ResetSplits();
        vars.ResetItemSplits();
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
            // Items picked up more than once are tracked by the room they are found in
            case 0x08: // Combat Knife
                if (current.room == 0x0000) // Prison B1 Cells
                    // Prevents splitting when changing to Chris if the knife is skipped in the prison cells
                    return vars.UpdateSplit("combatKnife");
                break;

            case 0x22: // Sub Machine Gun
                if (current.room == 0x030A) // Military Training Facility Warehouse
                    return vars.UpdateSplit("subMachineGun");

                if (current.room == 0x0716) // Military Training Facility B3 Cave
                    return vars.UpdateSplit("subMachineGunChris");
                break;

            case 0x47: // Air Force Proof
                if (current.room == 0x0207) // Private Residence 4F Private Study
                    return vars.UpdateSplit("airForceProof");

                if (current.room == 0x0801) // Airport Bridge
                    return vars.UpdateSplit("airForceProofChris");
                break;

            case 0x4E: // Music Box Plate
                if (current.room == 0x0205) // Private Residence 2F Alexias Bedroom
                    return vars.UpdateSplit("musicBoxPlate");

                if (current.room == 0x0918) // Antartic Transport Terminal B4 Alexias Bedroom
                    return vars.UpdateSplit("musicBoxPlateChris");
                break;

            case 0x58: // Octo Valve Handle
                if (current.room == 0x0602) // Antartic Transport Terminal B1 Tool Storeroom
                    return vars.UpdateSplit("octaValveHandle");

                if (current.room == 0x0906) // Antartic Transport Terminal B1 Mining Room
                    return vars.UpdateSplit("octaValveHandleChris");
                break;

            case 0x38: // Eagle Plate
                if (current.room == 0x0304) // Military Training Facility 1F Diorama Room
                    return vars.UpdateSplit("eaglePlateDiorama");

                if (current.room == 0x0106) // Palace 1F Umbrella Meeting Room
                    return vars.UpdateSplit("eaglePlateUmbrella");

                if (current.room == 0x070A) // Military Training Facility B2 Water Pool
                    return vars.UpdateSplit("eaglePlateWaterPool");
                break;

            default: // Split the first time an item is added to the inventory
                if (vars.itemSplits.ContainsKey(item))
                    return vars.UpdateItemSplit(item);
                break;
        }
    }

    if (current.room == 0x0501) // Transport Plane Cargo Hold
        return vars.UpdateSplit("tyrantPlane");

    if (current.room == 0x0600) // Antartic Transport Terminal B1 Silo
        return vars.UpdateSplit("antarcticaBase");

    if (current.room == 0x060A) // Antartic Transport Terminal 1F Helipad
        return vars.UpdateSplit("nosferatuFight");

    if (current.room == 0x0716) // Military Training Facility B3 Cave
        return vars.UpdateSplit("startChris");

    if (current.screen == 0x04) // End Game Rank Screen
        return vars.UpdateSplit("endGame");
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