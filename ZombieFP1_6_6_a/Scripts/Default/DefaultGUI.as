
void LoadDefaultGUI()
{
    if (v_driver > 0)
    {
        // load default skin
        GUI::LoadSkin( "GUI/guiSkin.cfg" );
        // add color tokens
        AddColorToken( "$RED$", SColor(255, 105, 25, 5) );
        AddColorToken( "$GREEN$", SColor(255, 5, 105, 25) );
		AddColorToken( "$GREY$", SColor(255, 195, 195, 195) );
        // add default icon tokens
        AddIconToken( "$NONE$", "GUI/InteractionIcons.png", Vec2f(32,32), 9 );
        AddIconToken( "$TIME$", "GUI/InteractionIcons.png", Vec2f(32,32), 0 );
        AddIconToken( "$COIN$", "GUI/MaterialIcons.png", Vec2f(16,16), 5 );
        AddIconToken( "$GOLD$", "GUI/MaterialIcons.png", Vec2f(16,16), 2 );
        AddIconToken( "$TEAMS$", "GUI/MenuItems.png", Vec2f(32,32), 1 );
        AddIconToken( "$SPECTATOR$", "GUI/MenuItems.png", Vec2f(32,32), 19 );
        AddIconToken( "$FLAG$", CFileMatcher("flag.png").getFirst(), Vec2f(32,16), 0 );
        AddIconToken( "$DISABLED$", "GUI/InteractionIcons.png", Vec2f(32,32), 9, 1 );
		AddIconToken( "$CANCEL$", "GUI/MenuItems.png", Vec2f(32,32), 29 );		
		AddIconToken( "$RESEARCH$", "GUI/InteractionIcons.png", Vec2f(32,32), 27 );
		AddIconToken( "$ALERT$", "GUI/InteractionIcons.png", Vec2f(32,32), 10 ); 
		AddIconToken( "$down_arrow$", "GUI/ArrowDown.png", Vec2f(8,8), 0 );
		AddIconToken( "$ATTACK_LEFT$", "GUI/InteractionIcons.png", Vec2f(32,32), 18, 1 );
		AddIconToken( "$ATTACK_RIGHT$", "GUI/InteractionIcons.png", Vec2f(32,32), 17, 1 );
		AddIconToken( "$ATTACK_THIS$", "GUI/InteractionIcons.png", Vec2f(32,32), 19, 1 );
		AddIconToken( "$DEFEND_LEFT$", "GUI/InteractionIcons.png", Vec2f(32,32), 18, 2 );
		AddIconToken( "$DEFEND_RIGHT$", "GUI/InteractionIcons.png", Vec2f(32,32), 17, 2 );
		AddIconToken( "$DEFEND_THIS$", "GUI/InteractionIcons.png", Vec2f(32,32), 19, 2 );
		AddIconToken( "$CLASSCHANGE$", "GUI/InteractionIcons.png", Vec2f(32,32), 12, 2 );
		AddIconToken( "$BUILD$", "GUI/InteractionIcons.png", Vec2f(32,32), 15 );
		AddIconToken( "$STONE$", "Sprites/World.png", Vec2f(8,8), 48 );
		AddIconToken( "$!!!$", "/Emoticons.png", Vec2f(22,22), 48 );
		
		//Mod Icons
		AddIconToken( "$vehicleshop$", "../Entities/Industry/VehicleShop/VehicleShopIcon.png", Vec2f(40,24), 0 );
		AddIconToken( "$defenseshop$", "../Entities/Industry/DefenseShop/DefenseShop.png", Vec2f(40,24), 0 );
		AddIconToken( "$priestshop$", "../PriestShop.png", Vec2f(40,24), 0 );
		AddIconToken( "$undeadtunnel$", "../UndeadTunnel.png", Vec2f(40,24), 0 );
		AddIconToken( "$undeadtradershop$", "../UndeadTraderShop.png", Vec2f(40,24), 0 );
		AddIconToken( "$horror$", "../UndeadTraderIcons.png", Vec2f(16,16), 0 );
		AddIconToken( "$abomination$", "../UndeadTraderIcons.png", Vec2f(16,16), 1 );
		AddIconToken( "$undeadbarracks$", "../UndeadBarracks.png", Vec2f(40,24), 0 );
		AddIconToken( "$undeadbuilding$", "../UndeadBuilding.png", Vec2f(40,24), 0 );
		AddIconToken( "$ZP$", "..Industry/ZombiePortal/ZPIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$tradershop$", "../Entities/Industry/TraderShop/tradershopIcon.png", Vec2f(40,24), 0 );
		AddIconToken( "$minibuilding$", "../Entities/Industry/Building/MiniBuilding.png", Vec2f(16,16), 0 );
		AddIconToken( "$minibuildershop$", "../Entities/Industry/BuilderShop/MiniBuilderShop.png", Vec2f(16,16), 0 );
		AddIconToken( "$minipriestshop$", "../MiniPriestShop.png", Vec2f(16,16), 0 );
		AddIconToken( "$woodenspikes$", "../WoodenSpikes.png", Vec2f(8,8), 0 );
		AddIconToken( "$miniknightshop$", "../Entities/Industry/KnightShop/MiniKnightShop.png", Vec2f(16,16), 0 );
		AddIconToken( "$miniarchershop$", "../Entities/Industry/ArcherShop/MiniArcherShop.png", Vec2f(16,16), 0 );
		AddIconToken( "$minidorm$", "../Entities/Industry/Dorm/MiniDorm.png", Vec2f(16,16), 0 );
		AddIconToken( "$minidefenseshop$", "../Entities/Industry/DefenseShop/MiniDefenseShop.png", Vec2f(16,16), 0 );
		AddIconToken( "$minitradershop$", "../Entities/Industry/TraderShop/MiniTraderShop.png", Vec2f(16,16), 0 );
		AddIconToken( "$minitunnel$", "../Entities/Industry/Tunnel/MiniTunnel.png", Vec2f(16,16), 0 );
		AddIconToken( "$minifarm$", "../Entities/Industry/Storage/MiniFarm.png", Vec2f(16,16), 0 );
		AddIconToken( "$minivehicleshop$", "../Entities/Industry/VehicleShop/MiniVehicleShop.png", Vec2f(16,16), 0 );
		AddIconToken( "$team_bridge$", "../Entities/Structures/TeamBridge/TeamBridge.png", Vec2f(8,8), 0 );
		AddIconToken( "$chainsaw$", "../EntitiesEntities/Items/Chainsaw/ChainsawIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$drill$", "../EntitiesEntities/Items/Drill/DrillIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$golddrill$", "../EntitiesEntities/Items/Drill/GoldDrillIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$bomb_satchel$", "../EntitiesEntities/Items/BombSatchel/BombSatchel.png", Vec2f(16,16), 0 );
		AddIconToken( "$divinghelmet$", "../EntitiesEntities/Items/DivingHelmet/DivingHelmetIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$bluelantern$", "../EntitiesEntities/Items/BlueLantern/BlueLantern.png", Vec2f(8,8), 0 );
		AddIconToken( "$megasaw$", "../EntitiesEntities/Items/MegaSaw/MS Icon.png", Vec2f(16,16), 0 );
		AddIconToken( "$saw$", "../EntitiesEntities/Items/Saw/SawIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$trampoline$", "../EntitiesEntities/Items/Trampoline/TrampolineIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$ballista$", "../Entities/Vehicles/Ballista/BallistaIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$dinghy$", "../Entities/Vehicles/Boats/DinghyIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$longboat$", "../Entities/Vehicles/Boats/LongboatIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$warboat$", "../Entities/Vehicles/Boats/WarboatIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$raft$", "../Entities/Vehicles/Boats/RaftIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$catapult$", "../Entities/Vehicles/Catapult/CatapultIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$glider$", "../Entities/Vehicles/Glider/GliderIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$balloon$", "../Entities/Vehicles/Balloon/BalloonIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$zeppelin$", "../Entities/Vehicles/Zeppelin/ZeppelinIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$tank$", "../Entities/Vehicles/Tank/TankIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$torch$", "../Torch.png", Vec2f(8, 8), 0);
		AddIconToken( "$caravel$", "../Entities/Vehicles/Caravel/CaravelIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mounted_bow$", "../Entities/Items/MountedBow/MB Icon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mounted_crossbow$", "../Entities/Items/MountedCrossbow/MCbIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mounted_bazooka$", "../Entities/Items/MountedBazooka/MBz Icon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mounted_cannon$", "../Entities/Items/MountedCannon/MCnIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mat_crossbolts$", "../Entities/Materials/CrossboltIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mat_rarrows$", "../Entities/Materials/rArrowIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mat_rockets$", "../Entities/Materials/rocketicon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mat_cannonballs$", "../Entities/Materials/cannonballicon.png", Vec2f(16,16), 0 );
		AddIconToken( "$mat_orbs$", "../Entities/Materials/Orbs_mat.png", Vec2f(16,16), 12 );
		AddIconToken( "$mat_fireorbs$", "../Entities/Materials/Orbs_mat.png", Vec2f(16,16), 13 );
		AddIconToken( "$mat_bomborbs$", "../Entities/Materials/Orbs_mat.png", Vec2f(16,16), 14 );
		AddIconToken( "$mat_waterorbs$", "../Entities/Materials/Orbs_mat.png", Vec2f(16,16), 15 );
		AddIconToken( "$fire_trap_block$", "../Entities/Structures/Fire Trap/FireTrapBlockIcon.png", Vec2f(8,8), 0 );
		AddIconToken( "$triangle$", "../Entities/Structures/Triangle/Triangle.png", Vec2f(8,8), 0 );
		AddIconToken( "$carnage$", "../Entities/Items/Scrolls/ScrollCarnage.png", Vec2f(16,16), 0 );
		AddIconToken( "$midas$", "../Entities/Items/Scrolls/ScrollOfMidas.png", Vec2f(16,16), 0 );
		AddIconToken( "$sreinforce$", "../Entities/Items/Scrolls/ScrollReinforce.png", Vec2f(16,16), 0 );
		AddIconToken( "$whitebook$", "../Entities/Items/Scrolls/WhiteBook.png", Vec2f(16,16), 0 );
		AddIconToken( "$whitepage$", "../Entities/Items/Scrolls/WhitePageIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$sslayer$", "../Entities/Items/Scrolls/ScrollSlayer.png", Vec2f(16,16), 0 );
		AddIconToken( "$snecromancer$", "../Entities/Items/Scrolls/ScrollNecromancer.png", Vec2f(16,16), 0 );
		AddIconToken( "$sgargoyle$", "../Entities/Items/Scrolls/ScrollGargoyle.png", Vec2f(16,16), 0 );
		AddIconToken( "$sbunny$", "../Entities/Items/Scrolls/ScrollBunny.png", Vec2f(16,16), 0 );		
		AddIconToken( "$drought$", "../Entities/Items/Scrolls/ScrollDrought.png", Vec2f(16,16), 0 );
		AddIconToken( "$sreturn$", "../Entities/Items/Scrolls/ScrollReturn.png", Vec2f(16,16), 0 );
		AddIconToken( "$szombie$", "../Entities/Items/Scrolls/ScrollZombie.png", Vec2f(16,16), 0 );
		AddIconToken( "$sskeleton$", "../Entities/Items/Scrolls/ScrollSkeleton.png", Vec2f(16,16), 0 );
		AddIconToken( "$smeteor$", "../Entities/Items/Scrolls/ScrollMeteor.png", Vec2f(16,16), 0 );
		AddIconToken( "$schicken$", "../Entities/Items/Scrolls/ScrollChicken.png", Vec2f(16,16), 0 );
		AddIconToken( "$sburd$", "../Entities/Items/Scrolls/ScrollBurd.png", Vec2f(16,16), 0 );
		AddIconToken( "$spyro$", "../Entities/Items/Scrolls/ScrollPyro.png", Vec2f(16,16), 0 );
		AddIconToken( "$scrossbow$", "../Entities/Items/Scrolls/ScrollCrossbow.png", Vec2f(16,16), 0 );
		AddIconToken( "$sassassin$", "../Entities/Items/Scrolls/ScrollAssassin.png", Vec2f(16,16), 0 );
		AddIconToken( "$necro$", "../Entities/Items/Scrolls/ScrollNecro.png", Vec2f(16,16), 0 );
		AddIconToken( "$booster$", "../Entities/Structures/Components/Load/Booster/Booster.png", Vec2f(8,8), 0 );
		AddIconToken( "$flamer$", "../Entities/Structures/Components/Load/Flamer/Flamer.png", Vec2f(8,8), 0 );
		AddIconToken( "$conveyor$", "../Entities/Structures/Components/Load/Conveyor/Conveyor.png", Vec2f(8,8), 0 );
		AddIconToken( "$conveyortriangle$", "../Entities/Structures/Components/Load/ConveyorTriangle/ConveyorTriangle.png", Vec2f(8,8), 0 );
		AddIconToken( "$nmigrant$", "../SummonIcons.png", Vec2f(16,16), 0 );
		AddIconToken( "$narsonist$", "../SummonIcons.png", Vec2f(16,16), 1 );
		AddIconToken( "$nwarrior$", "../SummonIcons.png", Vec2f(16,16), 2 );
		AddIconToken( "$ngarg$", "../SummonIcons.png", Vec2f(16,16), 3 );
		AddIconToken( "$mage$", "../Entities/NPC/Mage/MageIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$archerbot$", "../Entities/NPC/Archerbot/ArcherBotIcon.png", Vec2f(16,16), 0 );
		AddIconToken( "$piglet$", "../Entities/Natural/Animals/Piglet/Piglet.png", Vec2f(16,16), 0 );
		AddIconToken( "$birb$", "../Entities/Natural/Animals/Birb/Birb.png", Vec2f(16,16), 0 );
		AddIconToken( "$bunny$", "../Entities/Natural/Animals/Bunny/Bunny.png", Vec2f(16,16), 0 );
		AddIconToken( "$chicken$", "../Entities/Natural/Animals/Chicken/Chicken.png", Vec2f(16,16), 0 );
		AddIconToken( "$bison$", "../Entities/Common/Sprites/MiniIcons.png", Vec2f(16,16), 21 );
		AddIconToken( "$shark$", "../Entities/Common/Sprites/MiniIcons.png", Vec2f(16,16), 22 );
		AddIconToken( "$seedicon$", "../Entities/Natural/Trees/SeedIcon.png", Vec2f(16,16), 0 );
				
		
		// classes

		AddIconToken( "$ARCHER$", "ClassIcons.png", Vec2f(16,16), 2 );
		AddIconToken( "$KNIGHT$", "ClassIcons.png", Vec2f(16,16), 1 );
		AddIconToken( "$BUILDER$", "ClassIcons.png", Vec2f(16,16), 0 );

		// blocks

		AddIconToken( "$stone_block$", "Sprites/World.png", Vec2f(8,8), CMap::tile_castle );
		AddIconToken( "$moss_block$", "Sprites/World.png", Vec2f(8,8), CMap::tile_castle_moss );
		AddIconToken( "$back_stone_block$", "Sprites/World.png", Vec2f(8,8), CMap::tile_castle_back );
		AddIconToken( "$wood_block$", "Sprites/World.png", Vec2f(8,8), CMap::tile_wood );
		AddIconToken( "$back_wood_block$", "Sprites/World.png", Vec2f(8,8), CMap::tile_wood_back );
		AddIconToken( "$dirt_block$", "Sprites/World.png", Vec2f(8,8), CMap::tile_ground );

		// techs

		AddIconToken( "$tech_stone$", "GUI/TechnologyIcons.png", Vec2f(16,16), 16 );

		// keys
		const Vec2f keyIconSize(16,16);
		AddIconToken( "$KEY_W$", "GUI/Keys.png", keyIconSize, 6 );
		AddIconToken( "$KEY_A$", "GUI/Keys.png", keyIconSize, 0 );
		AddIconToken( "$KEY_S$", "GUI/Keys.png", keyIconSize, 1 );
		AddIconToken( "$KEY_D$", "GUI/Keys.png", keyIconSize, 2 );
		AddIconToken( "$KEY_E$", "GUI/Keys.png", keyIconSize, 3 );
		AddIconToken( "$KEY_F$", "GUI/Keys.png", keyIconSize, 4 );
		AddIconToken( "$KEY_C$", "GUI/Keys.png", keyIconSize, 5 );
		AddIconToken( "$LMB$", "GUI/Keys.png", keyIconSize, 8 );
		AddIconToken( "$RMB$", "GUI/Keys.png", keyIconSize, 9 );
		AddIconToken( "$KEY_SPACE$", "GUI/Keys.png", Vec2f(24,16), 8 );
		AddIconToken( "$KEY_HOLD$", "GUI/Keys.png", Vec2f(24,16), 9 );
		AddIconToken( "$KEY_TAP$", "GUI/Keys.png", Vec2f(24,16), 10 );
		AddIconToken( "$KEY_F1$", "GUI/Keys.png", Vec2f(24,16), 12 );
		AddIconToken( "$KEY_ESC$", "GUI/Keys.png", Vec2f(24,16), 13 );
    }
}
