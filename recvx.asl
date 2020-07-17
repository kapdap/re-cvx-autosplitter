//Resident Evil/BIOHAZARD Code Veronica X
//By Kapdap 7/16/2020
//Last updated 7/16/2020

state("rpcs3") {}
state("pcsx2") {}

startup
{
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
	
	settings.Add("keygroup", true, "Keys");
	settings.Add("hawkEmblem", false, "Hawk Emblem", "keygroup");
	
	settings.Add("weapons", true, "Weapons");
	settings.Add("combatKnife", false, "Combat Knife", "weapons");
	settings.Add("handgun", false, "Handgun", "weapons");
	settings.Add("handgunB", false, "Handgun B", "weapons");
	settings.Add("assaultRifle", false, "Assault Rifle", "weapons");
	settings.Add("sniperRifle", false, "Sniper Rifle", "weapons");
	settings.Add("shotgun", false, "Shotgun", "weapons");
	settings.Add("grenadeLauncher", false, "Grenade Launcher", "weapons");
	settings.Add("bowGun", false, "Bow Gun", "weapons");
	settings.Add("customHandgun", false, "Custom Handgun", "weapons");
	settings.Add("linearLauncher", false, "Linear Launcher", "weapons");
	settings.Add("magnum", false, "Magnum", "weapons");
	settings.Add("goldLugers", false, "Gold Lugers", "weapons");
	settings.Add("subMachineGun", false, "Sub Machine Gun", "weapons");
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
			vars.UpdateAddresses(productCode);
		}
		
		vars.productCode = productCode;
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
		
		IntPtr timePtr = new IntPtr(vars.timeAdr);
		IntPtr roomPtr = new IntPtr(vars.roomAdr);
		IntPtr characterPtr = new IntPtr(vars.characterAdr);
		IntPtr inventoryPtr = new IntPtr(vars.inventoryAdr);
		
		memory.ReadValue<uint>(timePtr, out time);
		memory.ReadValue<ushort>(roomPtr, out room);
		memory.ReadValue<byte>(characterPtr, out character);
		
		if (vars.isBigEndian)
		{
			current.time = vars.SwapEndiannessInt(time);
			current.room = vars.SwapEndianness(room);
		}
		else
		{
			current.time = time;
			current.room = room;
		}
		
		current.character = character;
		current.inventory = new byte[11];
		
		//print("=====================");
		//print("current.character = " + Convert.ToString(current.character, 16));
		//print("current.time = " + Convert.ToString(current.time, 16));
		//print("current.room = " + Convert.ToString(current.room, 16));
		
		int offset = vars.isReverseOrder ? 0x2 : 0x1;
		IntPtr ptr = IntPtr.Add(inventoryPtr, current.character * 0x40 + offset);
		for (int i = 0; i < current.inventory.Length; ++i)
		{
			ptr = IntPtr.Add(ptr, 0x4);
			
			byte item = 0;
			memory.ReadValue<byte>(ptr, out item);
			current.inventory[i] = item;
			
			//print("current.item[" + i + "] = " + Convert.ToString(item, 16));
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
		vars.hawkEmblem = 0;
		
		vars.combatKnife = 0;
		vars.handgun = 0;
		vars.handgunB = 0;
		vars.assaultRifle = 0;
		vars.sniperRifle = 0;
		vars.shotgun = 0;
		vars.grenadeLauncher = 0;
		vars.bowGun = 0;
		vars.customHandgun = 0;
		vars.linearLauncher = 0;
		vars.magnum = 0;
		vars.goldLugers = 0;
		vars.subMachineGun = 0;
	}
}

split
{
    byte[] currentInventory = (current.inventory as byte[]);
    byte[] oldInventory = (old.inventory as byte[]);

    for (int i = 0; i < currentInventory.Length; i++)
    {
        if (currentInventory[i] != oldInventory[i])
        {
			switch (currentInventory[i])
            {
				case 0x3B:
					if (vars.hawkEmblem == 0)
					{
						vars.hawkEmblem = 1;
						return settings["hawkEmblem"];
					}
					break;
					
				case 0x08:
					if (vars.combatKnife == 0)
					{
						vars.combatKnife = 1;
						return settings["combatKnife"];
					}
					break;
					
				case 0x09:
					if (vars.handgun == 0)
					{
						vars.handgun = 1;
						return settings["handgun"];
					}
					break;
					
				case 0x05:
					if (vars.handgunB == 0)
					{
						vars.handgunB = 1;
						return settings["handgunB"];
					}
					break;
					
				case 0x02:
					if (vars.assaultRifle == 0)
					{
						vars.assaultRifle = 1;
						return settings["assaultRifle"];
					}
					break;
					
				case 0x03:
					if (vars.sniperRifle == 0)
					{
						vars.sniperRifle = 1;
						return settings["sniperRifle"];
					}
					break;
					
				case 0x04:
					if (vars.shotgun == 0)
					{
						vars.shotgun = 1;
						return settings["shotgun"];
					}
					break;
					
				case 0x06:
					if (vars.grenadeLauncher == 0)
					{
						vars.grenadeLauncher = 1;
						return settings["grenadeLauncher"];
					}
					break;
					
				case 0x07:
					if (vars.bowGun == 0)
					{
						vars.bowGun = 1;
						return settings["bowGun"];
					}
					break;
					
				case 0x0A:
					if (vars.customHandgun == 0)
					{
						vars.customHandgun = 1;
						return settings["customHandgun"];
					}
					break;
					
				case 0x0B:
					if (vars.linearLauncher == 0)
					{
						vars.linearLauncher = 1;
						return settings["linearLauncher"];
					}
					break;
					
				case 0x20:
					if (vars.magnum == 0)
					{
						vars.magnum = 1;
						return settings["magnum"];
					}
					break;
					
				case 0x21:
					if (vars.goldLugers == 0)
					{
						vars.goldLugers = 1;
						return settings["goldLugers"];
					}
					break;
					
				case 0x22:
					if (vars.subMachineGun == 0)
					{
						vars.subMachineGun = 1;
						return settings["subMachineGun"];
					}
					break;
				
                default:
                    break;
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