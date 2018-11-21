#define CLIENT_ONLY

const string message_time_property = "help_time";

const string title = "- Welcome to Future Wars -\n";
const string credits = "A mod by Aphelion\n(modified by THD for public server)\n\n";

const string[] tips =
{
	"To apply changes to your loadout, you MUST click the BAG icon",
	"Press keys Z and X to swap between your primary and sidearm",
	"You can also press R to cycle between weapons",
	"To build, change your Exo-Suit to Logistics and swap to your sidearm",
	"Some weapons must be unlocked using credits before they can be used",
	"Enter /help to reopen the tooltip box or /stats to view your stats",
	"Have fun!"
};

const Vec2f dimensions(550, 125);
bool show_rules = false;

void Reset( CRules@ this )
{
	const u32 gametime = getGameTime();
	if (gametime < 30) return;

	this.set_u32(message_time_property, getGameTime());
}

void onRestart( CRules@ this )
{
	this.set_u32(message_time_property, 0);
}

void onTick( CRules@ this )
{
	if(!this.exists(message_time_property))
	{
		Reset(this);
	}

    CPlayer@ player = getLocalPlayer();

	if (player !is null)
        show_rules = player.getBlob() is null || (getGameTime() - this.get_u32(message_time_property)) < 900;
	else
	    show_rules = false;
}

void onRender( CRules@ this )
{
	if (show_rules)
	{
	    Vec2f tl = Vec2f(getScreenWidth() / 2 - dimensions.x / 2, (getScreenHeight() - dimensions.y - 85) + (Maths::Sin(getGameTime() / 10.0f) + 1.0f) * 3.0f);
	    Vec2f br = Vec2f(tl.x + dimensions.x, tl.y + dimensions.y);
	    Vec2f text_dim;

		GUI::DrawPane(tl, br, SColor(0x80ffffff));

	    GUI::GetTextDimensions(title, text_dim);
		GUI::DrawText(title, tl + Vec2f(dimensions.x / 2 - text_dim.x / 2, 5), color_white);
	    GUI::GetTextDimensions(credits, text_dim);
		GUI::DrawText(credits, tl + Vec2f(dimensions.x / 2 - text_dim.x / 2, 16), color_white);

		for(uint i = 0; i < tips.length; i++)
		{
			string tip = "- " + tips[i];

			GUI::DrawText(tip, tl + Vec2f(5, 38 + (11 * i)), color_white);
		}
	}
}