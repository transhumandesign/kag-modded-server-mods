/* ItemsCommon.as
 * author: Aphelion
 */

#include "ItemTypes.as";
#include "ExoSuits.as";

const string items_property = "items";

shared class Item
{
	string blob;
	string name;
	string shortName;
	string description;
	u16 price;
	u8 type;
	u32 suits;

	CBitStream reqs;

	Item() {}

	Item( string _blob, string _name, string _shortName, string _description, u16 _price, u8 _type, u32 _suits )
	{
		blob = _blob;
		name = _name;
		shortName = _shortName;
		description = _description;
		price = _price;
		type = _type;
		suits = _suits;
	}

	string getIcon( u8 team = 0, bool grayscale = false )
	{
		string prefix = "$";
		string suffix = "$";

		if(!grayscale)
		{
			prefix = team == 0 ? "$blue_" :
			                     "$red_";
		}
		else
		{
		    suffix = "_grayscale$";
		}
		return prefix + blob + suffix;
	}

	bool isFree()
	{
		return price <= 0 || getRules().get_bool("testing");
	}

	bool availableTo( u32 suit )
	{
		return suits == ExoSuits::All || (suits & suit) != 0;
	}
}

void AddItems( CRules@ this, Item[][]@ items )
{
	Item[] suits;
	items.push_back(suits);

	{
		Item i("logistics", "Logistics - Exo-Suit", "", "A support Exo-Suit able to heal allies, equipped with an omni-tool for resource gathering and construction\n\nShield: 35\nHealth: 40\nAbility: Triage", 0, ItemType::EXO_SUIT, ExoSuits::All);
		items[0].push_back(i);
	}
	{
		Item i("assault", "Assault - Exo-Suit", "", "An advanced combat Exo-Suit with integrated flight capabilities, designed to adapt to any situation on the battlefield\n\nShield: 25\nHealth: 60\nAbility: Hoverpack", 0, ItemType::EXO_SUIT, ExoSuits::All);
		items[0].push_back(i);
	}
	{
		Item i("sentinel", "Sentinel - Exo-Suit", "", "A heavily armoured Exo-Suit capable of wielding heavy weapons with augmented strength\n\nShield: 15\nHealth: 100\nAbility: Shield", 0, ItemType::EXO_SUIT, ExoSuits::All);
		items[0].push_back(i);
	}
	{
		Item i("infiltrator", "Infiltrator - Exo-Suit", "", "A highly flexible Exo-Suit, with advanced shielding and a cloaking device\n\nShield: 40\nHealth: 25\nAbility: Cloaking", 0, ItemType::EXO_SUIT, ExoSuits::All);
		items[0].push_back(i);
	}
	
	Item[] primaries;
	items.push_back(primaries);
	
	{
		Item i("gauss_rifle", "G-4 'Equinox' Gauss Rifle", "'Equinox' Gauss Rifle", "RPM: 450\nDPS: 60\nDMG: 8\nMAG: 25\nRNG: 40", 0, ItemType::WEAPON_PRIMARY, ExoSuits::Assault | ExoSuits::Logistics);
		items[1].push_back(i);
	}
	{
		Item i("gauss_carbine", "GB-39 'Polaris' Gauss Carbine", "'Polaris' Gauss Carbine", "RPM: 600\nDPS: 60\nDMG: 6\nMAG: 30\nRNG: 40", 0, ItemType::WEAPON_PRIMARY, ExoSuits::Assault | ExoSuits::Logistics);
		items[1].push_back(i);
	}
	{
		Item i("pulse_rifle", "RS-90 'Flare' Pulse Rifle", "'Flare' Pulse Rifle", "RPM: 450\nDPS: 54\nDMG: 9\nMAG: 21\nRNG: 45", 1000, ItemType::WEAPON_PRIMARY, ExoSuits::Assault | ExoSuits::Logistics);
		items[1].push_back(i);
	}
	{
		Item i("battle_rifle", "GD-22 'Phantom' Battle Rifle", "'Phantom' Battle Rifle", "RPM: 225\nDPS: 45\nDMG: 12\nMAG: 14\nRNG: 55", 1350, ItemType::WEAPON_PRIMARY, ExoSuits::Assault | ExoSuits::Logistics);
		items[1].push_back(i);
	}
	{
		Item i("arc_laser", "ELM-7 'Construct' Arc Laser", "'Construct' Arc Laser", "RPM: 257\nDPS: 51\nDMG: 12\nMAG: 25", 1350, ItemType::WEAPON_PRIMARY, ExoSuits::Assault | ExoSuits::Logistics);
		items[1].push_back(i);
	}

	{
		Item i("sniper_rifle", "N-17 'Genesis' Sniper Rifle", "'Genesis' Sniper Rifle", "RPM: 40\nDPS: 33\nDMG: 50\nMAG: 1\nRNG: 100", 0, ItemType::WEAPON_PRIMARY, ExoSuits::Infiltrator);
		items[1].push_back(i);
	}
	{
		Item i("submachine_gun_2", "N7-A 'Mag-Sec' Submachine Gun", "'Mag-Sec' SMG", "RPM: 600\nDPS: 70\nDMG: 7\nMAG: 30\nRNG: 30", 0, ItemType::WEAPON_PRIMARY, ExoSuits::Infiltrator);
		items[1].push_back(i);
	}
	{
		Item i("scout_rifle", "CRD-9 'Ghost' Scout Rifle", "'Ghost' Scout Rifle", "RPM: 450\nDPS: 52\nDMG: 7\nMAG: 25\nRNG: 50", 1000, ItemType::WEAPON_PRIMARY, ExoSuits::Infiltrator);
		items[1].push_back(i);
	}
	{
		Item i("scrambler_rifle", "CRW-04 'Templar' Scrambler Rifle", "Scrambler Rifle", "RPM: 600\nDPS: 80\nDMG: 8\nMAG: 15\nRNG: 35", 1350, ItemType::WEAPON_PRIMARY, ExoSuits::Infiltrator);
		items[1].push_back(i);
	}
	{
		Item i("plasma_cannon", "KLA-90 'Allotek' Plasma Cannon", "'Allotek' Plasma Cannon", "Requires ammunition: Plasma Cells\n\nRPM: 30\nDMG: 60/20\nMAG: 1\nRAD: 3.5", 1350, ItemType::WEAPON_PRIMARY, ExoSuits::Infiltrator);
		items[1].push_back(i);
	}

	{
		Item i("lmg", "L-19 'Vortex' Light Machine Gun", "'Vortex' LMG", "RPM: 600\nDPS: 55\nDMG: 5.5\nMAG: 50\nRNG: 45", 0, ItemType::WEAPON_PRIMARY, ExoSuits::Sentinel);
		items[1].push_back(i);
	}
	{
		Item i("missile_launcher", "'Grimlock' BRN-50 Missile Launcher", "Missile Launcher", "Launches light missiles\n\nRequires ammunition: Light Missile", 0, ItemType::WEAPON_PRIMARY, ExoSuits::Sentinel);
		items[1].push_back(i);
	}
	{
		Item i("gatling_laser", "L-30 'Sunbeam' Gatling Laser", "'Sunbeam' Gatling Laser", "RPM: 360-900\nDPS: 36-90\nDMG: 6\nMAG: 75\nRNG: 35", 1000, ItemType::WEAPON_PRIMARY, ExoSuits::Sentinel);
		items[1].push_back(i);
	}
	{
		Item i("scatter_cannon", "'Hydra' Scatter Cannon", "'Hydra' Scatter Cannon", "RPM: 75\nDPS: 18-88\nDMG: 14 x 5\nMAG: 2\nRNG: 25", 1350, ItemType::WEAPON_PRIMARY, ExoSuits::Sentinel);
		items[1].push_back(i);
	}

	{
		Item i("submachine_gun", "SX-46 'Shuriken' Submachine Gun", "'Shuriken' SMG", "RPM: 900\nDPS: 75\nDMG: 5\nMAG: 35\nRNG: 25", 1250, ItemType::WEAPON_PRIMARY, ExoSuits::All);
		items[1].push_back(i);
	}
	{
		Item i("scatter_rifle", "CRG-3 'Nighthawk' Scatter Rifle", "'Nighthawk' Scatter Rifle", "RPM: 225\nDPS: 38-112\nDMG: 10 x 3\nMAG: 4\nRNG: 20", 1250, ItemType::WEAPON_PRIMARY, ExoSuits::All);
		items[1].push_back(i);
	}
	{
		Item i("plasma_launcher", "EXO-5 'Avalanche' Plasma Mortar", "Plasma Mortar", "Requires ammunition: Plasma Cells\n\nRPM: 75\nDPS: 19-38\nDMG: 30/15\nMAG: 8\nRAD: 4", 1250, ItemType::WEAPON_PRIMARY, ExoSuits::All);
		items[1].push_back(i);
	}
	{
		Item i("swarm_launcher", "CBR-112 'Haywire' Swarm Launcher", "Swarm Launcher", "Fires a swarm of missiles that hone in on nearby targets\n\nRequires ammunition: Swarm Missile", 1250, ItemType::WEAPON_PRIMARY, ExoSuits::All);
		items[1].push_back(i);
	}

	Item[] sidearms;
	items.push_back(sidearms);

	{
		Item i("omni_tool", "EK-A2 'Pyrus' Omni-Tool", "'Pyrus' Omni-Tool", "An all-in-one tool for construction and gathering or processing resources\n\nDPS: 75\nDMG: 20", 0, ItemType::WEAPON_SIDEARM, ExoSuits::Logistics);
		items[2].push_back(i);
	}
	{
		Item i("ion_pistol", "T-12 'Cerberus' Ion Pistol", "'Cerberus' Ion Pistol", "RPM: 257\nDPS: 64\nDMG: 15\nMAG: 8\nRNG: 30", 0, ItemType::WEAPON_SIDEARM, ExoSuits::All);
		items[2].push_back(i);
	}
	{
		Item i("scrambler_pistol", "CAR-9 'Carthum' Scrambler Pistol", "Scrambler Pistol", "RPM: 540\nDPS: 81\nDMG: 9\nMAG: 18\nRNG: 20", 500, ItemType::WEAPON_SIDEARM, ExoSuits::All);
		items[2].push_back(i);
	}
	{
		Item i("bolt_pistol", "SR-25 'Raven' Bolt Pistol", "'Raven' Bolt Pistol", "RPM: 150\nDPS: 41\nDMG: 25\nMAG: 4\nRNG: 50", 500, ItemType::WEAPON_SIDEARM, ExoSuits::All);
		items[2].push_back(i);
	}
	{
		Item i("scatter_pistol", "J-52 'Mauler' Scatter Pistol", "'Mauler' Scatter Pistol", "RPM: 120\nDPS: 28-84\nDMG: 14 x 3\nMAG: 4\nRNG: 12", 500, ItemType::WEAPON_SIDEARM, ExoSuits::All);
		items[2].push_back(i);
	}

	Item[] modules;
	items.push_back(modules);

	{
		// nothing here, yet
	}
}

Item[][]@ getItems()
{
	Item[][]@ items;

    getRules().get(items_property, @items);
	return items;
}

Item@ getItem( string name )
{
    Item[][]@ items;

    if (getRules().get(items_property, @items))
    {
        for(uint i = 0; i < items.length; i++)
        {
        	Item@ item = getItem(name, i);
        	if   (item !is null)
        	{
        		return item;
        	}
        }
    }
	return null;
}

Item@ getItem( string name, int index )
{
    Item[][]@ items;

    if (getRules().get(items_property, @items))
    {
        for(uint i = 0; i < items[index].length; i++)
        {
	        if (items[index][i].blob == name)
	        {
	            return items[index][i];
	        }
        }
    }
	return null;
}
