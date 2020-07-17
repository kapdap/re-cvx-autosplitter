// Resident Evil/BIOHAZARD Code Veronica X
// By Kapdap 2020/07/16
// Last updated 2020/07/18
// https://github.com/kapdap/re-cvx-autosplitter

state("rpcs3") {}
state("pcsx2") {}

startup
{
    vars.indexer = new Dictionary<byte, string>();
    vars.tracker = new Dictionary<byte, bool>();

    vars.AddSplit = (Action<byte, string, bool, string, string>)((code, id, default_value, description, parent) => {
        vars.indexer.Add(code, id);
        vars.tracker.Add(code, false);
        settings.Add(id, default_value, description, parent);
    });

    vars.AddGroup = (Action<string, bool, string>)((id, default_value, description) => {
        settings.Add(id, default_value, description);
    });

    vars.AddGroup("keygroup", true, "Hawk Emblem");
    vars.AddSplit(0x3B, "hawkEmblem", false, "Hawk Emblem", "keygroup");
    
    vars.AddGroup("weapons", true, "Weapons");
    vars.AddSplit(0x08, "combatKnife", false, "Combat Knife", "weapons");
    vars.AddSplit(0x09, "handgun", false, "Handgun", "weapons");
    vars.AddSplit(0x05, "handgunB", false, "Handgun B", "weapons");
    vars.AddSplit(0x02, "assaultRifle", false, "Assault Rifle", "weapons");
    vars.AddSplit(0x03, "sniperRifle", false, "Sniper Rifle", "weapons");
    vars.AddSplit(0x04, "shotgun", false, "Shotgun", "weapons");
    vars.AddSplit(0x06, "grenadeLauncher", false, "Grenade Launcher", "weapons");
    vars.AddSplit(0x07, "bowGun", false, "Bow Gun", "weapons");
    vars.AddSplit(0x0A, "customHandgun", false, "Custom Handgun", "weapons");
    vars.AddSplit(0x0B, "linearLauncher", false, "Linear Launcher", "weapons");
    vars.AddSplit(0x20, "magnum", false, "Magnum", "weapons");
    vars.AddSplit(0x21, "goldLugers", false, "Gold Lugers", "weapons");
    vars.AddSplit(0x22, "subMachineGun", false, "Sub Machine Gun", "weapons");

    vars.ResetTracker = (Action) (() => {
        List<byte> keys = new List<byte>(vars.tracker.Keys);
        foreach(byte key in keys)
        {
            vars.tracker[key] = false; 
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
                vars.characterAdr = 0x2044BC64;
                vars.inventoryAdr = 0x20430E70;
                break;
                
            case "SLUS_201.84":
                vars.timeAdr = 0x204339A0;
                vars.roomAdr = 0x204339B5;
                vars.characterAdr = 0x2044E164;
                vars.inventoryAdr = 0x20433370;
                break;
                
            case "SLES_503.06":
                vars.timeAdr = 0x2044A1D0;
                vars.roomAdr = 0x2044A1E5;
                vars.characterAdr = 0x20464994;
                vars.inventoryAdr = 0x20449BA0;
                break;
                
            case "NPUB30467":
                vars.timeAdr = 0x300BB3DB8;
                vars.roomAdr = 0x300BB3DCC;
                vars.characterAdr = 0x300BCE57E;
                vars.inventoryAdr = 0x300BB3788;
                break;
                
            case "NPEB0053":
                vars.timeAdr = 0x300BC40B8;
                vars.roomAdr = 0x300BC40CC;
                vars.characterAdr = 0x300BDE87E;
                vars.inventoryAdr = 0x300BC3A88;
                break;
                
            default: // NPJB00135
                vars.timeAdr = 0x300BB3E38;
                vars.roomAdr = 0x300BB3E4C;
                vars.characterAdr = 0x300BCE5FE;
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
        byte character = 0x00;
        
        memory.ReadValue<uint>(new IntPtr(vars.timeAdr), out time);
        memory.ReadValue<ushort>(new IntPtr(vars.roomAdr), out room);
        memory.ReadValue<byte>(new IntPtr(vars.characterAdr), out character);
        
        current.time = !vars.isBigEndian ? time : vars.SwapEndiannessInt(time);
        current.room = !vars.isBigEndian ? room : vars.SwapEndianness(room);
        current.character = character;
        current.inventory = new byte[11];
        
        int offset = vars.isReverseOrder ? 0x2 : 0x1;
        IntPtr ptr = IntPtr.Add(new IntPtr(vars.inventoryAdr), current.character * 0x40 + offset);
        for (int i = 0; i < current.inventory.Length; ++i)
        {
            ptr = IntPtr.Add(ptr, 0x4);
            
            byte item = 0;
            memory.ReadValue<byte>(ptr, out item);
            current.inventory[i] = item;
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
    }
}

split
{
    for (int i = 0; i < current.inventory.Length; i++)
    {
        byte item = current.inventory[i];

        if (item != old.inventory[i])
        {
            if (vars.tracker.ContainsKey(item) && !vars.tracker[item])
            {
                vars.tracker[item] = true;
                return settings[vars.indexer[item]]; 
            }
        }
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