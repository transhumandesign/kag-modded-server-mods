/* LoadoutCommon.as
 * author: Aphelion
 */

#include "SoldierCommon.as";

const string cmd_loadout = "cmd loadout";

namespace LoadoutMenu
{
	enum Cmd
	{
		nil = 0,

		SHOW_MENU = 51,
		PURCHASE_ITEM = 52,
		SAVE_LOADOUT = 53,
		PAGE_SELECT = 54,
		
		set_item = 160,
		set_item_reserved = 199,
	};

	enum Page
	{
		PAGE_ZERO = 0,
		PAGE_ONE,
		PAGE_TWO,
		PAGE_THREE,
		PAGE_COUNT
	};
}

bool isItemValid( PlayerProfile@ profile, ExoSuit@ suit, Item@ item )
{
	return HasItem(profile, item) && item.availableTo(suit.flag);
}

bool HasItem( PlayerProfile@ profile, Item@ item )
{
	return item.isFree() || profile.HasItem(item.blob);
}
