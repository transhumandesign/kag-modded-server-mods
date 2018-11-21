/* LoadoutMenu.as
 * author: Aphelion
 */

#include "GameMessagesCommon.as";

#include "LoadoutCommon.as";
#include "Stats.as";

const string EXOSUIT = "selected exosuit";
const string PRIMARY = "selected primary";
const string SIDEARM = "selected sidearm";

const string[] PAGE_NAME =
{
	"Exo-Suit",
	"Weapon",
	"Sidearm",
	"Module",
};

const u8 GRID_SIZE = 48;
const u8 GRID_PADDING = 12;

const Vec2f MENU_SIZE(4, 6);

void onInit( CBlob@ this )
{
	for(u8 i = 0; i < LoadoutMenu::PAGE_COUNT; i++)
	{
		AddIconToken("$" + PAGE_NAME[i] + "$", "LoadoutPageIcons.png", Vec2f(48, 24), i);
	}

	AddIconToken("$SAVE_LOADOUT$", "InteractionIcons.png", Vec2f(32, 32), 28);
	AddIconToken("$PURCHASE_ITEM$", "InteractionIcons.png", Vec2f(32, 32), 26);
}

void onSetPlayer( CBlob@ this, CPlayer@ player )
{
	if (player !is null && getNet().isServer())
	{
		// set selected properties
		PlayerProfile@ profile = getProfile(player);

		if (profile !is null)
		{
		    this.set_string(EXOSUIT, profile.loadout_exosuit);
			this.set_string(PRIMARY, profile.loadout_primary);
			this.set_string(SIDEARM, profile.loadout_sidearm);
			this.Sync(EXOSUIT, true);
			this.Sync(PRIMARY, true);
			this.Sync(SIDEARM, true);
		}
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream@ params )
{
	bool isServer = getNet().isServer();

	if(cmd == LoadoutMenu::SHOW_MENU)
	{
		if (this is getLocalPlayerBlob())
		{
			CreateMenu(this);
		}
	}
	else if(cmd == LoadoutMenu::PURCHASE_ITEM)
	{
		string selected_item;

		if(!params.saferead_string(selected_item)) return;

		if (!this.isMyPlayer() && !isServer) return;

		CPlayer@ player = this.getPlayer();
		if      (player !is null)
		{
			Item@ item = getItem(selected_item, this.get_u8("loadout page"));
			if   (item !is null)
			{
				PlayerProfile@ profile = getProfile(this.getPlayer());

				if (HasItem(profile, item))
				{
					sendMessage("You already have that item.");

		            RefreshMenu(this);
					return;
				}

				int price = item.price;

				int credits = player.getCoins();
				if (credits >= price)
				{
				    this.getSprite().PlaySound("/ChaChing.ogg");

					player.server_setCoins(credits - price);

				    profile.AddItem(selected_item);
				}
				else if (this.isMyPlayer())
				{
					sendMessage("You don't have enough credits to purchase that.");

					Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
				}
			}
		}
		
		RefreshMenu(this);
	}
	else if(cmd == LoadoutMenu::SAVE_LOADOUT)
	{
		if (!this.isMyPlayer() && !isServer) return;
		
		CPlayer@ player = this.getPlayer();
		PlayerProfile@ profile = getProfile(player);
		if            (profile is null) return;

		string exosuit = this.get_string(EXOSUIT);
		string primary = this.get_string(PRIMARY);
		string sidearm = this.get_string(SIDEARM);

		Item@ suit = getItem(exosuit);
		Item@ item;
		bool valid = true;

		if(!profile.HasItem(primary))
		{
			@item = getItem(primary);
			valid = item !is null && item.isFree();
		}

		if (valid && !profile.HasItem(sidearm))
		{
			@item = getItem(sidearm);
			valid = item !is null && item.isFree();
		}

		if(!valid)
		{
			RefreshMenu(this);

			sendMessage("You don't own all of the items in your loadout.");

			Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
			return;
		}

		profile.loadout_exosuit = exosuit;
		profile.loadout_primary = primary;
		profile.loadout_sidearm = sidearm;

		this.ClearGridMenus();
        
		CBlob@ new_blob = server_CreateBlob(profile.loadout_exosuit == "logistics" ? "logistics" : "soldier", this.getTeamNum(), this.getPosition());
		if    (new_blob !is null)
		{
			CInventory@ inv = this.getInventory();

			if (inv !is null)
			{
				while (inv.getItemsCount() > 0)
				{
					CBlob@ item = inv.getItem(0);
					this.server_PutOutInventory(item);
				}
				
				//this.MoveInventoryTo(new_blob);
			}

			// plug the soul
			new_blob.server_SetPlayer(this.getPlayer());
			new_blob.setPosition(this.getPosition());

			// no extra immunity after class change
			if (this.exists("spawn immunity time"))
			{
				new_blob.set_u32("spawn immunity time", this.get_u32("spawn immunity time"));
				new_blob.Sync("spawn immunity time", true);
			}

			if (this.exists("knocked"))
			{
				new_blob.set_u8("knocked", this.get_u8("knocked"));
				new_blob.Sync("knocked", true);
			}

			this.Tag("switch class");
			this.server_SetPlayer(null);
			this.server_Die();
		}
	}
	else if(cmd >= LoadoutMenu::PAGE_SELECT && cmd < LoadoutMenu::PAGE_SELECT + LoadoutMenu::PAGE_COUNT)
	{
		if (!this.isMyPlayer() && !isServer) return;

		this.set_u8("loadout page", cmd - LoadoutMenu::PAGE_SELECT);

		RefreshMenu(this);
	}
	else if (cmd >= LoadoutMenu::set_item && cmd < LoadoutMenu::set_item_reserved)
	{
		if (!this.isMyPlayer() && !isServer) return;

		Item[][]@ items = getItems();

		uint i = cmd - LoadoutMenu::set_item;

		const u8 PAGE = this.get_u8("loadout page");

		if (items !is null && i >= 0 && i < items[PAGE].length)
		{
			Item@ item = @items[PAGE][i];
			if   (item is null) return;

			ExoSuit@ suit;

			switch (item.type)
			{
				case ItemType::EXO_SUIT:

				@suit = getSuit(item.blob);

				this.set_string(EXOSUIT, item.blob);
				this.set_string(PRIMARY, suit.default_primary);
				this.set_string(SIDEARM, suit.default_sidearm);
				
				break;

				case ItemType::WEAPON_PRIMARY:

				this.set_string(PRIMARY, item.blob);

				break;

				case ItemType::WEAPON_SIDEARM:

				this.set_string(SIDEARM, item.blob);

				break;
			}

		    RefreshMenu(this);
		}
	}
}

void CreateMenu( CBlob@ this )
{
	Item[][]@ items = getItems();
	if (items is null) return;

	const Vec2f MENU_CE = Vec2f(0, MENU_SIZE.y * -GRID_SIZE - GRID_PADDING) + Vec2f(getScreenWidth() / 2 - (MENU_SIZE.x * GRID_SIZE - GRID_PADDING) / 2, getScreenHeight() / 2 + (MENU_SIZE.y * GRID_SIZE - GRID_PADDING) / 2);

	CGridMenu@ menu = CreateGridMenu(MENU_CE, this, MENU_SIZE, "Gear");
	if (menu !is null)
	{
		menu.deleteAfterClick = false;

		PlayerProfile@ profile = getProfile(this.getPlayer());
		if (profile is null) return;

		ExoSuit@ suit = getSuit(this.get_string(EXOSUIT));

		const u8 PAGE = this.get_u8("loadout page");
		const string SELECTED_ITEM = PAGE == LoadoutMenu::PAGE_ONE ? this.get_string(PRIMARY) :
			                         PAGE == LoadoutMenu::PAGE_TWO ? this.get_string(SIDEARM) :
			                                                         suit.name;

		for(u8 i = 0; i < items[PAGE].length; i++)
		{
			Item@ item = items[PAGE][i];
			if   (item is null || !item.availableTo(suit.flag)) continue;

			bool hasItem = HasItem(profile, item);

			CGridButton@ button = menu.AddButton(item.getIcon(this.getTeamNum(), !hasItem), item.name, LoadoutMenu::set_item + i);
			if (button is null) continue;

			button.SetSelected(SELECTED_ITEM == item.blob ? 1 : 0);
			button.selectOneOnClick = true;

			string hoverText = item.getIcon(this.getTeamNum(), false) + "\n\n\n" + item.name;

			if (hasItem || item.isFree())
			    hoverText += "\n\n" + item.description + "\n";
			else
			    hoverText += "\nUnlock for " + item.price + " $COIN$\n\n" + item.description + "\n";

		    button.hoverText = hoverText;
		}

		const Vec2f SAVE_POS = Vec2f(menu.getLowerRightPosition().x + GRID_PADDING + GRID_SIZE / 2, menu.getLowerRightPosition().y - GRID_SIZE / 2);

		CGridMenu@ save = CreateGridMenu(SAVE_POS, this, Vec2f(1, 1), "Save");
		if (save !is null)
		{
			save.SetCaptionEnabled(false);

			CGridButton@ button = save.AddButton("$SAVE_LOADOUT$", "", LoadoutMenu::SAVE_LOADOUT, Vec2f(1, 1));
			if (button !is null)
			{
				button.SetHoverText("Save Loadout\n");
			}
		}

		const Vec2f BUY_POS = Vec2f(menu.getLowerRightPosition().x + GRID_PADDING + GRID_SIZE * 1.5f, menu.getLowerRightPosition().y - GRID_SIZE / 2);

		CGridMenu@ buy = CreateGridMenu(BUY_POS, this, Vec2f(1, 1), "Buy");
		if (buy !is null)
		{
			buy.SetCaptionEnabled(false);

			CBitStream params;
			params.write_string(SELECTED_ITEM);

			CGridButton@ button = buy.AddButton("$PURCHASE_ITEM$", "", LoadoutMenu::PURCHASE_ITEM, Vec2f(1, 1), params);
			if (button !is null)
			{
				button.SetHoverText("Purchase Item\n");
			}
		}

		const Vec2f INDEX_POS = Vec2f(menu.getLowerRightPosition().x + GRID_PADDING + GRID_SIZE, menu.getUpperLeftPosition().y + GRID_SIZE * LoadoutMenu::PAGE_COUNT / 2);

		CGridMenu@ index = CreateGridMenu(INDEX_POS, this, Vec2f(2, LoadoutMenu::PAGE_COUNT), "Loadout");
		if (index !is null)
		{
			index.deleteAfterClick = false;

			for(u8 i = 0; i < LoadoutMenu::PAGE_COUNT; i++)
			{
				CGridButton@ button = index.AddButton("$" + PAGE_NAME[i] + "$", PAGE_NAME[i], LoadoutMenu::PAGE_SELECT + i, Vec2f(2, 1));
				if (button is null) continue;

				button.selectOneOnClick = true;

				if (i == PAGE)
				{
					button.SetSelected(1);
				}
			}
		}
	}
}

void RefreshMenu( CBlob@ this )
{
	if (this is getLocalPlayerBlob())
	{
		this.ClearGridMenus();
		
		CreateMenu(this);
	}
}
