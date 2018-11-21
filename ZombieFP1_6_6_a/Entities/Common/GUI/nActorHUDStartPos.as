//for use with DefaultActorHUD.as based HUDs

Vec2f getActorHUDStartPosition(CBlob@ blob, const u8 bar_width_in_slots)
{
    f32 width = bar_width_in_slots * 32.0f;
    return Vec2f( getScreenWidth()/2.0f + 160 - width, getScreenHeight() - 40 );
}

void DrawInventoryOnHUD( CBlob@ this, Vec2f tl, Vec2f hudPos = Vec2f(0,0) )
{
	SColor col;		 
	CInventory@ inv = this.getInventory();	 
	for (int i = 0; i < inv.getItemsCount(); i++)
	{
		CBlob@ item = inv.getItem(i);
        string itemname = item.getInventoryName();
        string jitem = "GUI/jitem.png";
        Vec2f jdim = Vec2f(16,16);
        Vec2f adjust = Vec2f(0,2);
		const int quantity = item.getQuantity();
		
		//vertical belt
		Vec2f itempos = Vec2f(10,54 + i * 46) + hudPos;
		GUI::DrawIcon("GUI/jslot.png", 0, Vec2f(32,32), Vec2f(2,46 + i * 46)+hudPos);

		if (itemname == "Gold") { GUI::DrawIcon(jitem, 0, jdim, itempos-adjust, 1.0f ); }
		else if (itemname == "Stone") { GUI::DrawIcon(jitem, 1, jdim, itempos-adjust, 1.0f ); }
		else if (itemname == "Wood") { GUI::DrawIcon(jitem, 2, jdim, itempos-adjust, 1.0f ); }
		else if (itemname == "Lantern") { GUI::DrawIcon(jitem, 3, jdim, itempos, 1.0f ); }
		else if (itemname == "Bombs") { GUI::DrawIcon(jitem, 4, jdim, itempos, 1.0f ); }
		else if (itemname == "Water Bombs") { GUI::DrawIcon(jitem, 5, jdim, itempos+adjust, 1.0f ); }
		else if (itemname == "Satchel") { GUI::DrawIcon(jitem, 6, jdim, itempos, 1.0f ); }
		else if (itemname == "Keg") { GUI::DrawIcon(jitem, 7, jdim, itempos, 1.0f ); }
		else if (itemname == "Arrows") { GUI::DrawIcon(jitem, 8, jdim, itempos, 1.0f ); }
		else if (itemname == "Fire Arrows") { GUI::DrawIcon(jitem, 9, jdim, itempos, 1.0f ); }
		else if (itemname == "Bomb Arrow") { GUI::DrawIcon(jitem, 10, jdim, itempos, 1.0f ); }
		else if (itemname == "Water Arrows") { GUI::DrawIcon(jitem, 11, jdim, itempos, 1.0f ); }
		else if (itemname == "Bread") { GUI::DrawIcon(jitem, 12, jdim, itempos, 1.0f ); }
		else if (itemname == "Heart") { GUI::DrawIcon(jitem, 13, jdim, itempos, 1.0f ); }
		else if (itemname == "Steak") { GUI::DrawIcon(jitem, 16, jdim, itempos, 1.0f ); }
		else if (itemname == "Regular Orbs") { GUI::DrawIcon(jitem, 24, jdim, itempos, 1.0f ); }
		else if (itemname == "Fire Orbs") { GUI::DrawIcon(jitem, 25, jdim, itempos, 1.0f ); }
		else if (itemname == "Bomb Orbs") { GUI::DrawIcon(jitem, 26, jdim, itempos, 1.0f ); }
		else if (itemname == "Water Orbs") { GUI::DrawIcon(jitem, 27, jdim, itempos, 1.0f ); }
		else if (itemname == "Blue Lantern") { GUI::DrawIcon(jitem, 28, jdim, itempos, 1.0f ); }
		else { GUI::DrawIcon( item.inventoryIconName, item.inventoryIconFrame, item.inventoryFrameDimension, itempos, 1.0f ); }

		f32 ratio = float(quantity) / float(item.maxQuantity);
		col = ratio > 0.4f ? SColor(255,255,255,255) :
			ratio > 0.2f ? SColor(255,255,255,128) :
			ratio > 0.1f ? SColor(255,255,128,0) : SColor(255,255,0,0);

		if (quantity != 1)
		{
			if (quantity < 10) { GUI::SetFont("menu"); GUI::DrawText(""+quantity, itempos +Vec2f(22,18), col ); }
			else if (quantity < 100) { GUI::SetFont("menu"); GUI::DrawText(""+quantity, itempos +Vec2f(14,18), col ); }
			else { GUI::SetFont("menu"); GUI::DrawText(""+quantity, itempos +Vec2f(6,18), col ); }
		}
	}
}

void DrawCoinsOnHUD( CBlob@ this, const int coins, Vec2f tl, const int slot )
{
	if (coins > 0)
	{
		GUI::DrawIcon("GUI/jitem.png", 14, Vec2f(16,16), Vec2f(42,38));
		GUI::SetFont("menu");
		GUI::DrawText(""+coins, Vec2f(72,44), color_white);
	}
}