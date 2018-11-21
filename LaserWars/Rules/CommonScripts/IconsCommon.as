/* IconsCommon.as
 * author: Aphelion
 */

const string building_icons_blue_file = "BuildingIcons_Blue.png";
const string building_icons_red_file = "BuildingIcons_Red.png";

const string item_icons_blue_file = "ItemIcons_Blue.png";
const string item_icons_red_file = "ItemIcons_Red.png";

const string class_icons_blue_file = "ClassIcons_Blue.png";
const string class_icons_red_file = "ClassIcons_Red.png";

const string weapon_icons_blue_file = "WeaponIcons_Blue.png";
const string weapon_icons_red_file = "WeaponIcons_Red.png";
const string weapon_icons_grayscale_file = "WeaponIcons_Grayscale.png";

void AddBuildingIcon( string name, u8 frame )
{
	AddIconToken("$blue_" + name + "$", building_icons_blue_file, Vec2f(40, 24), frame);
	AddIconToken("$red_" + name + "$", building_icons_red_file, Vec2f(40, 24), frame);
}

void AddItemIcon( string name, u8 frame )
{
	AddIconToken("$" + name + "$", item_icons_blue_file, Vec2f(16, 16), frame);
	AddIconToken("$blue_" + name + "$", item_icons_blue_file, Vec2f(16, 16), frame);
	AddIconToken("$red_" + name + "$", item_icons_red_file, Vec2f(16, 16), frame);
}

void AddClassIcon( string name, u8 frame)
{
	AddIconToken("$blue_" + name + "$", class_icons_blue_file, Vec2f(32, 32), frame);
	AddIconToken("$red_" + name + "$", class_icons_red_file, Vec2f(32, 32), frame);
}

void AddWeaponIcon( string name, u8 frame )
{
	AddIconToken("$blue_" + name + "$", weapon_icons_blue_file, Vec2f(32, 16), frame);
	AddIconToken("$red_" + name + "$", weapon_icons_red_file, Vec2f(32, 16), frame);
	AddIconToken("$" + name + "_grayscale$", weapon_icons_grayscale_file, Vec2f(32, 16), frame);
}

string getIcon( string name, u8 team = 0 )
{
	string prefix = team != 1 ? "$blue_" :
		                        "$red_";
	string suffix = "$";
		
	return prefix + name + suffix;
}