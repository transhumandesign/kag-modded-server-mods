/* 
map.getTile(index).flags = 0;

Tile FLAGS
Tile::TileFlags
    SPARE_0
    SOLID
    BACKGROUND
    LADDER
    LIGHT_PASSES
    WATER_PASSES
    FLAMMABLE
    PLATFORM
    LIGHT_SOURCE
    MIRROR
    FLIP
    ROTATE
    COLLISION
    SPARE_2
    SPARE_3
    SPARE_4
*/
namespace CMap
{
	enum CustomTiles
	{ 
		tile_blank_light_stopper = 257,
		
		// 256 row line
		tile_sandbag_1 = 258,
		tile_sandbag_2 = 259,
		tile_sandbag_3 = 260,
		
		tile_veg_left = 261,
		tile_veg_mid_1 = 262,
		tile_veg_mid_2 = 263,
		tile_veg_right = 264,
		
		tile_fence_top = 265,
		tile_fence = 266,
		tile_fence_dmg = 267,
		
		tile_plank_1 = 268,
		tile_plank_2 = 269,
		tile_plank_3 = 270,
		tile_plank_4 = 271,
		
		// 272 line
		tile_lamppost_base = 272,
		tile_lamppost_2 = 273,
		tile_lamppost_3 = 274,
		tile_lamppost_4 = 275,
		tile_lamppost_5 = 276,
		tile_lamppost_top = 277,
		
		tile_wood_block_1_left = 278,
		tile_wood_block_1_mid = 279,
		tile_wood_block_1_right = 280,
		tile_wood_block_1_mid_tee = 281,
		tile_wood_block_2_left = 282,
		tile_wood_block_2_mid = 283,
		tile_wood_column_thin= 284,
		
		tile_brick_back_left = 285,
		tile_brick_back_mid = 286,
		tile_brick_back_right = 287,

		//288 line
		tile_basic_black = 288, // basic BLACK block both solid and frontground
		
		tile_street_1 = 289,
		tile_street_2 = 290,
		
		tile_asphalt_1 = 291,
		tile_asphalt_2 = 292,
		tile_asphalt_3 = 293,
		tile_asphalt_4 = 294,
		
		tile_clay_dirt_1 = 295,
		tile_clay_dirt_2 = 296,
		tile_clay_dirt_3 = 297,

		tile_x_back_1 = 298,
		tile_x_back_2 = 299,
		tile_x_back_3 = 300,
		tile_x_back_4 = 301,
		tile_x_back_junction_1 = 302,
		tile_x_back_junction_2 = 303,

		//304 line
		
		tile_stone_floor = 304,
		tile_stone_floor_corner_out = 305,
		tile_stone_floor_vert = 306,
		tile_stone_floor_corner_in = 307,
		
		tile_bedrock_corner = 308,

		tile_wood_deco_1 = 309,
		tile_wood_deco_2 = 310,
		tile_wood_deco_Tee = 311,
		tile_wood_deco_mid = 312,
		tile_wood_deco_top = 313,

		tile_x_silhouette_1 = 314,
		tile_x_silhouette_2 = 315,
		tile_x_silhouette_3 = 316,
		tile_x_silhouette_4 = 317,
		tile_x_silhouette_junction_1 = 318,
		tile_x_silhouette_junction_2 = 319,
		

		//320 line all Concrete Backwall 
		tile_concrete_back_1 = 320,
		tile_concrete_back_2 = 321,
		tile_concrete_back_3 = 322,
		tile_concrete_back_4 = 323,
		tile_concrete_back_5 = 324,
		tile_concrete_back_6 = 325,
		tile_concrete_back_7 = 326,
		tile_concrete_back_8 = 327,
		tile_concrete_back_9 = 328,
		tile_concrete_back_10 = 329,
		tile_concrete_back_11 = 330,
		tile_concrete_back_12 = 331,
		tile_concrete_back_13 = 332,
		tile_concrete_back_14 = 333,
		tile_concrete_back_15 = 334,
		tile_concrete_back_16 = 335,

		//336 line
		tile_concrete_mid_1 = 336,
		tile_concrete_mid_2 = 337,
		tile_concrete_mid_3 = 338,
		tile_concrete_mid_4 = 339,
		
		tile_metal_column_1 = 340,
		tile_metal_column_2 = 341,
		
		tile_industrial_deco_ceiling_1 = 342,
		tile_industrial_deco_ceiling_2 = 343,

		tile_stone_triangle = 344, // this is the special that casts blank background on triangles at the BasePNGLoader
		
		tile_snow_front_1 = 345,
		tile_snow_front_2 = 346,
		tile_snow_front_3 = 347,
		
		tile_handrail_back_top_left = 348,
		tile_handrail_back_top_mid = 349,
		tile_handrail_back_top_tee = 350,
		tile_handrail_back_top_right = 351,

		//352 line
		tile_wooden_fence_back_1 = 352,
		tile_wooden_fence_back_2 = 353,
		tile_wooden_fence_back_top_1 = 354,
		tile_wooden_fence_back_top_2= 355,
		tile_wooden_fence_back_low_1 = 356,
		tile_wooden_fence_back_low_2 = 357,

		tile_metal_back_base = 358,
		tile_metal_back_1 = 359,
		tile_metal_back_2 = 360,
		tile_metal_back_3 = 361,
		tile_metal_back_4 = 362,

		tile_metal_back_angle = 363,

		tile_handrail_back_low_left = 364,
		tile_handrail_back_low_mid = 365,
		tile_handrail_back_low_tee = 366,
		tile_handrail_back_low_right = 367,

		//368 line

		tile_ladder_custom = 368,
		tile_ladder_custom_veg = 369,
		tile_crate_up_left = 376,
		tile_crate_up_right = 377,
		tile_crate_down_left = 378,
		tile_crate_down_right = 379,

		tile_handrail_front_top_left = 380,
		tile_handrail_front_top_mid = 381,
		tile_handrail_front_top_tee = 382,
		tile_handrail_front_top_right = 383,

		//384 line

		tile_crate2_up_left = 392,
		tile_crate2_up_right = 393,
		tile_crate2_down_left = 394,
		tile_crate2_down_right = 395,

		tile_handrail_front_low_left = 396,
		tile_handrail_front_low_mid = 397,
		tile_handrail_front_low_tee = 398,
		tile_handrail_front_low_right = 399,

		//400 line ceiling and deco - all BLACK

		tile_black_front_1 = 400,
		tile_black_front_2 = 401,
		tile_black_front_3 = 402,
		tile_black_front_4 = 403,
		tile_black_front_5 = 404,

		tile_black_ceiling_inner_1 = 405,
		tile_black_ceiling_inner_2 = 406,
		tile_black_ceiling_inner_3 = 407,

		tile_black_front_deco_1 = 408,
		tile_black_front_deco_2 = 409,
		tile_black_front_deco_3 = 410,
		tile_black_front_deco_4 = 411,

		tile_wooden_box_1 = 412,
		tile_wooden_box_2 = 413,
		tile_wooden_box_3 = 414,

		tile_snow_vert = 415,

		//416 line Red team background
		tile_red_back_plain = 416,
		tile_red_back_1 = 417,
		tile_red_back_2 = 418,
		tile_red_back_3 = 419,
		tile_red_back_4 = 420,
		tile_red_back_5 = 421,
		tile_red_back_6 = 422,

		tile_container1_top_left = 423, //bone colour
		tile_container1_top_mid = 424,
		tile_container1_top_right = 425,
		tile_container1_mid_left = 426,
		tile_container1_mid_mid = 427,
		tile_container1_mid_right = 428,
		tile_container1_low_left = 429,
		tile_container1_low_mid = 430,
		tile_container1_low_right = 431,


		//432 line Blue team background and container
		tile_blue_back_plain = 432,
		tile_blue_back_1 = 433,
		tile_blue_back_2 = 434,
		tile_blue_back_3 = 435,
		tile_blue_back_4 = 436,
		tile_blue_back_5 = 437,
		tile_blue_back_6 = 438,

		tile_container2_top_left = 439, // light-greenish
		tile_container2_top_mid = 440,
		tile_container2_top_right = 441,
		tile_container2_mid_left = 442,
		tile_container2_mid_mid = 443,
		tile_container2_mid_right = 444,
		tile_container2_low_left = 445,
		tile_container2_low_mid = 446,
		tile_container2_low_right = 447,

		//448 line
		tile_beam_h_left,
		tile_beam_h_mid,
		tile_beam_h_mid_shadowed,
		tile_beam_h_right,
		tile_beam_v_mid,
		tile_beam_v_top,


		tile_container3_top_left = 455, // light-blueish
		tile_container3_top_mid = 456,
		tile_container3_top_right = 457,
		tile_container3_mid_left = 458,
		tile_container3_mid_mid = 459,
		tile_container3_mid_right = 460,
		tile_container3_low_left = 461,
		tile_container3_low_mid = 462,
		tile_container3_low_right = 463,

		//464 line
		tile_beam_h_left_swap,
		tile_beam_v_top_swap,
		tile_beam_h_right_swap,
		tile_beam_v_down_swap,

		tile_container4_top_left = 471, // mossy
		tile_container4_top_mid = 472,
		tile_container4_top_right = 473,
		tile_container4_mid_left = 474,
		tile_container4_mid_mid = 475,
		tile_container4_mid_right = 476,
		tile_container4_low_left = 477,
		tile_container4_low_mid = 478,
		tile_container4_low_right = 479,

		//480
		tile_concrete = 480,
		tile_concrete1,
		tile_concrete2,
		tile_concrete3,
		tile_concrete4,
		tile_concrete5,
		tile_concrete6,
		tile_concrete7,
		tile_concrete8,
		tile_concrete9,
		tile_concrete10,
		tile_concrete11,
		tile_concrete12,
		tile_concrete13,
		tile_concrete14,
		tile_concrete15

		/*
		//480
		tile_concrete = 480,
		tile_concrete1 = 481,
		tile_concrete2 = 482,
		tile_concrete3 = 483,
		tile_concrete4 = 484,
		tile_concrete5 = 485,
		tile_concrete6 = 486,
		tile_concrete7 = 487,
		tile_concrete8 = 488,
		tile_concrete9 = 489,
		tile_concrete10 = 490,
		tile_concrete11 = 491,
		tile_concrete12 = 492,
		tile_concrete13 = 493,
		tile_concrete14 = 494,
		tile_concrete15 = 495
		*/


	};
};


/*bool isTileConcrete(const TileType &in type)
{
	return
	type >= tile_concrete &&
	type <= tile_concrete15;
}*/

const SColor color_blank_light_stopper(255, 255, 216, 0);
const SColor color_stone_triangle(255, 255, 216, 100);
const SColor color_basic_black (255, 63, 19, 19);
const SColor color_basic_black_front (255, 61, 40, 40);

//solid ground
const SColor color_sandbag_1(255, 127, 100, 0);
const SColor color_sandbag_2(255, 127, 100, 30);
const SColor color_sandbag_3(255, 127, 100, 60);


const SColor color_street_1(255, 85, 75, 50);
const SColor color_street_2(255, 85, 75, 75);

const SColor color_asphalt_1(255, 70, 100, 50);
const SColor color_asphalt_2(255, 70, 100, 80);
const SColor color_asphalt_3(255, 70, 100, 110);
const SColor color_asphalt_4(255, 70, 100, 140);

const SColor color_clay_dirt_1(255, 60, 50, 40);
const SColor color_clay_dirt_2(255, 60, 50, 70);
const SColor color_clay_dirt_3(255, 60, 50, 100);

const SColor color_veg_left(255, 20, 100, 0);
const SColor color_veg_mid_1(255, 20, 100, 20);
const SColor color_veg_mid_2(255, 20, 100, 40);
const SColor color_veg_right(255, 20, 100, 60);

const SColor color_stone_floor(255,43,50,0);
const SColor color_stone_floor_corner_out_right(255,43,50,20);
const SColor color_stone_floor_corner_out_left(255,43,50,25);
const SColor color_stone_floor_vert_right(255,43,50,40);
const SColor color_stone_floor_vert_left(255,43,50,45);
const SColor color_stone_floor_corner_in_right(255,43,50,60);
const SColor color_stone_floor_corner_in_left(255,43,50,65);

const SColor color_bedrock_corner(255,43,50,80);

//silhouette background
const SColor color_fence_top(255, 20, 55, 55);
const SColor color_fence(255, 20, 55, 75);
const SColor color_fence_dmg(255, 20, 55, 95);
const SColor color_front_fence(255, 20, 55, 115);


const SColor color_x_silhouette_1(255, 155, 75, 50);
const SColor color_x_silhouette_2(255, 155, 75, 75);
const SColor color_x_silhouette_3(255, 155, 75, 100);
const SColor color_x_silhouette_4(255, 155, 75, 125);
const SColor color_x_silhouette_junction_1(255, 155, 75, 200);
const SColor color_x_silhouette_junction_2(255, 155, 75, 225);


//decoration background
const SColor color_plank_1(255, 158, 140, 100);
const SColor color_plank_2(255, 158, 140, 125);
const SColor color_plank_3(255, 158, 140, 150);
const SColor color_plank_4(255, 158, 140, 175);

const SColor color_x_back_1(255, 55, 75, 50);
const SColor color_x_back_2(255, 55, 75, 75);
const SColor color_x_back_3(255, 55, 75, 100);
const SColor color_x_back_4(255, 55, 75, 125);
const SColor color_x_back_junction_1(255, 55, 75, 200);
const SColor color_x_back_junction_2(255, 55, 75, 225);

const SColor color_wooden_fence_back_1(255, 124, 50, 0);
const SColor color_wooden_fence_back_2(255, 124, 50, 50);
const SColor color_wooden_fence_back_top_1(255, 124, 50, 100);
const SColor color_wooden_fence_back_top_2(255, 124, 50, 150);
const SColor color_wooden_fence_back_low_1(255, 124, 50, 200);
const SColor color_wooden_fence_back_low_2(255, 124, 50, 250);

const SColor color_wood_deco_1(255, 170, 60, 50);
const SColor color_wood_deco_2(255, 170, 60, 75);
const SColor color_wood_deco_tee(255, 170, 60, 100);
const SColor color_wood_deco_mid(255, 170, 60, 125);
const SColor color_wood_deco_top(255, 170, 60, 150);

const SColor color_handrail_back_top_left(255, 125, 25, 0);
const SColor color_handrail_back_top_mid(255, 125, 25, 25);
const SColor color_handrail_back_top_tee(255, 125, 25, 50);
const SColor color_handrail_back_top_right(255, 125, 25, 75);
const SColor color_handrail_back_low_left(255, 125, 140, 100);
const SColor color_handrail_back_low_mid(255, 125, 140, 150);
const SColor color_handrail_back_low_tee(255, 125, 140, 200);
const SColor color_handrail_back_low_right(255, 125, 140, 250);

//decoration background vertical-horizontal

//just ladders to offer standing in the air and perhaps remove vanilla ladder blob
const SColor color_ladder_custom(255, 50, 155, 104);
const SColor color_ladder_custom_veg(255, 50, 155, 184);

//decoration FRONT layer

const SColor color_snow_front_1(255, 152, 200, 150);
const SColor color_snow_front_2(255, 152, 200, 200);
const SColor color_snow_front_3(255, 152, 200, 250); // to end at the right
const SColor color_snow_front_4(255, 152, 200, 245); // 3 Mirrored to begin from the left

const SColor color_handrail_front_top_left(255, 125, 80, 0);
const SColor color_handrail_front_top_mid(255, 125, 80, 50);
const SColor color_handrail_front_top_tee(255, 125, 80, 100);
const SColor color_handrail_front_top_right(255, 125, 80, 150);
const SColor color_handrail_front_low_left(255, 124,121, 100);
const SColor color_handrail_front_low_mid(255, 124,121, 150);
const SColor color_handrail_front_low_tee(255, 124,121, 200);
const SColor color_handrail_front_low_right(255, 124,121, 250);

//decoration lamp post
const SColor color_lamppost_base(255, 66, 55, 100);
const SColor color_lamppost_2(255, 66, 55, 110);
const SColor color_lamppost_3(255, 66, 55, 120);
const SColor color_lamppost_4(255, 66, 55, 130);
const SColor color_lamppost_5(255, 66, 55, 140);
const SColor color_lamppost_top(255, 66, 55, 150);

//solid roof tops, footbridges, platforms etc 
const SColor color_wood_block_1_left(255, 200, 33, 0);
const SColor color_wood_block_1_mid(255, 200, 33, 10);
const SColor color_wood_block_1_mid_tee(255, 200, 33, 20);
const SColor color_wood_block_1_right(255, 200, 33, 30);
const SColor color_wood_block_2_left(255, 200, 33, 40);
const SColor color_wood_block_2_mid(255, 200, 33, 50);
const SColor color_wood_column_thin(255, 100, 33, 50);

//back castle
const SColor color_brick_back_left(255, 85, 100, 85);
const SColor color_brick_back_mid(255, 85, 100, 110);
const SColor color_brick_back_right(255, 85, 100, 135);

const SColor color_concrete_back_1(255, 60, 120, 15);
const SColor color_concrete_back_2(255, 60, 120, 35);
const SColor color_concrete_back_3(255, 60, 120, 55);
const SColor color_concrete_back_4(255, 60, 120, 75);
const SColor color_concrete_back_5(255, 60, 120, 95);
const SColor color_concrete_back_6(255, 60, 120, 115);
const SColor color_concrete_back_7(255, 60, 120, 135);
const SColor color_concrete_back_8(255, 60, 120, 155);
const SColor color_concrete_back_9(255, 60, 120, 175);
const SColor color_concrete_back_10(255, 60, 120, 195);
const SColor color_concrete_back_11(255, 60, 120, 215);
const SColor color_concrete_back_12(255, 60, 120, 235);
const SColor color_concrete_back_13(255, 60, 60, 100);
const SColor color_concrete_back_14(255, 60, 60, 150);
const SColor color_concrete_back_15(255, 60, 60, 200);
const SColor color_concrete_back_16(255, 60, 60, 250);

const SColor color_concrete_mid_1(255, 60, 200, 100);
const SColor color_concrete_mid_2(255, 60, 200, 150);
const SColor color_concrete_mid_3(255, 60, 200, 200);
const SColor color_concrete_mid_4(255, 60, 200, 250);

const SColor color_metal_column_1 (255, 100, 33, 80);
const SColor color_metal_column_2 (255, 100, 33, 110);

const SColor color_industrial_deco_ceiling_1 (255, 66, 140, 100);
const SColor color_industrial_deco_ceiling_2 (255, 66, 140, 130);

const SColor color_metal_back_base (255, 75, 100, 50); // Base connects with metal column
const SColor color_metal_back_1 (255, 75, 100, 75);  // 
const SColor color_metal_back_2 (255, 75, 100, 100); // 1 mirrored
const SColor color_metal_back_3 (255, 75, 100, 125); // 
const SColor color_metal_back_4 (255, 75, 100, 150); // 2 mirrored
const SColor color_metal_back_5 (255, 75, 100, 175); // 
const SColor color_metal_back_6 (255, 75, 100, 200); // 
const SColor color_metal_back_left (255, 75, 100, 225); // angled left
const SColor color_metal_back_right (255, 75, 100, 250); // angled right

// BLACK ceiling and deco

const SColor color_black_front_1 (255, 25, 24, 0);
const SColor color_black_front_2 (255, 68, 50, 0);
const SColor color_black_front_3 (255, 68, 50, 50);
const SColor color_black_front_4 (255, 68, 50, 100);
const SColor color_black_front_5 (255, 68, 50, 150);

const SColor color_black_ceiling_inner_1 (255, 25, 24, 50);
const SColor color_black_ceiling_inner_2 (255, 25, 24, 100);
const SColor color_black_ceiling_inner_3 (255, 25, 24, 150);

const SColor color_black_front_deco_1 (255, 84, 94, 0);
const SColor color_black_front_deco_2 (255, 84, 94, 50);
const SColor color_black_front_deco_3 (255, 84, 94, 100);
const SColor color_black_front_deco_4 (255, 84, 94, 150);

//Team Background deco
const SColor color_red_back_plain(255, 180, 31, 0);

const SColor color_red_back_1(255, 180, 31, 40);
const SColor color_red_back_2(255, 180, 31, 80);
const SColor color_red_back_3(255, 180, 31, 120);
const SColor color_red_back_4(255, 180, 31, 160);
const SColor color_red_back_5(255, 180, 31, 200);
const SColor color_red_back_6(255, 180, 97, 200);

const SColor color_blue_back_plain(255, 0, 31, 180);

const SColor color_blue_back_1(255, 40, 31, 180);
const SColor color_blue_back_2(255, 80, 31, 180);
const SColor color_blue_back_3(255, 120, 31, 180);
const SColor color_blue_back_4(255, 160, 31, 180);
const SColor color_blue_back_5(255, 200, 31, 180);
const SColor color_blue_back_6(255, 200, 87, 180);

//Solid Deco
const SColor color_tile_crate_up_left(255, 154, 66, 25);
const SColor color_tile_crate_up_right(255, 154, 66, 50);
const SColor color_tile_crate_down_left(255, 154, 66, 75);
const SColor color_tile_crate_down_right(255, 154, 66, 100);

const SColor color_tile_crate2_up_left(255, 154, 100, 25);
const SColor color_tile_crate2_up_right(255, 154, 100, 50);
const SColor color_tile_crate2_down_left(255, 154, 100, 75);
const SColor color_tile_crate2_down_right(255, 154, 100, 100);

const SColor color_tile_wooden_box_1(255, 51, 142, 100);
const SColor color_tile_wooden_box_2(255, 51, 142, 133);
const SColor color_tile_wooden_box_3(255, 51, 142, 166);

const SColor color_tile_snow_vert(255, 150, 200, 101);
const SColor color_tile_snow_vert_mirrored(255, 150, 200, 249);

//containers, 4 colours
//bone
const SColor color_tile_container1_top_left(255, 163, 153, 0);
const SColor color_tile_container1_top_mid(255, 163, 153, 25);
const SColor color_tile_container1_top_right(255, 163, 153, 50);
const SColor color_tile_container1_mid_left(255, 163, 153, 75);
const SColor color_tile_container1_mid_mid(255, 163, 153, 100);
const SColor color_tile_container1_mid_right(255, 163, 153, 125);
const SColor color_tile_container1_low_left(255, 163, 153, 150);
const SColor color_tile_container1_low_mid(255, 163, 153, 175);
const SColor color_tile_container1_low_right(255, 163, 153, 200);

//greenish
const SColor color_tile_container2_top_left				(255, 8, 214, 100);
const SColor color_tile_container2_top_mid				(255, 8, 214, 120);
const SColor color_tile_container2_top_right			(255, 8, 214, 140);
const SColor color_tile_container2_mid_left				(255, 8, 214, 160);
const SColor color_tile_container2_mid_mid				(255, 8, 214, 180);
const SColor color_tile_container2_mid_right			(255, 8, 214, 200);
const SColor color_tile_container2_low_left				(255, 8, 214, 220);
const SColor color_tile_container2_low_mid				(255, 8, 214, 240);
const SColor color_tile_container2_low_right			(255, 8, 214, 250);

//blueish
const SColor color_tile_container3_top_left				(255, 80, 182, 231);
const SColor color_tile_container3_top_mid				(255, 100, 182, 231);
const SColor color_tile_container3_top_right			(255, 120, 182, 231);
const SColor color_tile_container3_mid_left				(255, 140, 182, 231);
const SColor color_tile_container3_mid_mid				(255, 160, 182, 231);
const SColor color_tile_container3_mid_right			(255, 180, 182, 231);
const SColor color_tile_container3_low_left				(255, 200, 182, 231);
const SColor color_tile_container3_low_mid				(255, 220, 182, 231);
const SColor color_tile_container3_low_right			(255, 240, 182, 231);

//mossy
const SColor color_tile_container4_top_left				(255, 37, 44, 0);
const SColor color_tile_container4_top_mid				(255, 37, 44, 25);
const SColor color_tile_container4_top_right			(255, 37, 44, 50);
const SColor color_tile_container4_mid_left				(255, 37, 44, 75);
const SColor color_tile_container4_mid_mid				(255, 37, 44, 100);
const SColor color_tile_container4_mid_right			(255, 37, 44, 125);
const SColor color_tile_container4_low_left				(255, 37, 44, 150);
const SColor color_tile_container4_low_mid				(255, 37, 44, 175);
const SColor color_tile_container4_low_right			(255, 37, 44, 200);

//industrial beam structures
const SColor color_tile_beam_h_left						(255, 115, 85, 0);
const SColor color_tile_beam_h_mid						(255, 115, 85, 25);
const SColor color_tile_beam_h_mid_shadowed				(255, 115, 85, 50);
const SColor color_tile_beam_h_right					(255, 115, 85, 75);
const SColor color_tile_beam_v_mid						(255, 115, 85, 100);
const SColor color_tile_beam_v_top						(255, 115, 85, 125);
//swap to dark background
const SColor color_tile_beam_h_left_swap				(255, 115, 85, 200);
const SColor color_tile_beam_v_top_swap					(255, 115, 85, 225);
const SColor color_tile_beam_h_right_swap				(255, 115, 85, 250);
const SColor color_tile_beam_v_down_swap				(255, 115, 25, 225);

//this is autotiled concrete, to be used 1 tile thick, thx to Skinney (not working atm)
//const SColor color_tile_concrete						(255, 130, 85, 85);


void HandleCustomTile( CMap@ map, int offset, SColor pixel )


{
	if (pixel == color_sandbag_1){
		map.SetTile(offset, CMap::tile_sandbag_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );		
	}
	else if (pixel == color_sandbag_2){
		map.SetTile(offset, CMap::tile_sandbag_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_sandbag_3){
		map.SetTile(offset, CMap::tile_sandbag_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_veg_left){
		map.SetTile(offset, CMap::tile_veg_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_veg_mid_1){
		map.SetTile(offset, CMap::tile_veg_mid_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_veg_mid_2){
		map.SetTile(offset, CMap::tile_veg_mid_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_veg_right){
		map.SetTile(offset, CMap::tile_veg_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_fence_top){
		map.SetTile(offset, CMap::tile_fence_top );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_fence){
		map.SetTile(offset, CMap::tile_fence );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_fence_dmg){
		map.SetTile(offset, CMap::tile_fence_dmg );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_front_fence){
		map.SetTile(offset, CMap::tile_fence );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_plank_1){
		map.SetTile(offset, CMap::tile_plank_1 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_plank_2){
		map.SetTile(offset, CMap::tile_plank_2 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_plank_3){
		map.SetTile(offset, CMap::tile_plank_3 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_plank_4){
		map.SetTile(offset, CMap::tile_plank_4 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_lamppost_base){
		map.SetTile(offset, CMap::tile_lamppost_base );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_lamppost_2){
		map.SetTile(offset, CMap::tile_lamppost_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_lamppost_3){
		map.SetTile(offset, CMap::tile_lamppost_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_lamppost_4){
		map.SetTile(offset, CMap::tile_lamppost_4 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_lamppost_5){
		map.SetTile(offset, CMap::tile_lamppost_5 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_lamppost_top){
		map.SetTile(offset, CMap::tile_lamppost_top );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	
	// wood footbridges here
	else if (pixel == color_wood_block_1_left){
		map.SetTile(offset, CMap::tile_wood_block_1_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_wood_block_1_mid){
		map.SetTile(offset, CMap::tile_wood_block_1_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_wood_block_1_right){
		map.SetTile(offset, CMap::tile_wood_block_1_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_wood_block_1_mid_tee){
		map.SetTile(offset, CMap::tile_wood_block_1_mid_tee );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_wood_block_2_left){
		map.SetTile(offset, CMap::tile_wood_block_2_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_wood_block_2_mid){
		map.SetTile(offset, CMap::tile_wood_block_2_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_wood_column_thin){
		map.SetTile(offset, CMap::tile_wood_column_thin );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND  | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_brick_back_left){
		map.SetTile(offset, CMap::tile_brick_back_left );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_brick_back_mid){
		map.SetTile(offset, CMap::tile_brick_back_mid );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_brick_back_right){
		map.SetTile(offset, CMap::tile_brick_back_right );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	
	//X back figure - 6 normal, 6 silhouettes
	else if (pixel == color_x_back_1){
		map.SetTile(offset, CMap::tile_x_back_1 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_back_2){
		map.SetTile(offset, CMap::tile_x_back_2 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_back_3){
		map.SetTile(offset, CMap::tile_x_back_3 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_back_4){
		map.SetTile(offset, CMap::tile_x_back_4 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_back_junction_1){
		map.SetTile(offset, CMap::tile_x_back_junction_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_back_junction_2){
		map.SetTile(offset, CMap::tile_x_back_junction_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	
	// silhouettes
	else if (pixel == color_x_silhouette_1){
		map.SetTile(offset, CMap::tile_x_silhouette_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_silhouette_2){
		map.SetTile(offset, CMap::tile_x_silhouette_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_silhouette_3){
		map.SetTile(offset, CMap::tile_x_silhouette_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_silhouette_4){
		map.SetTile(offset, CMap::tile_x_silhouette_4 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_silhouette_junction_1){
		map.SetTile(offset, CMap::tile_x_silhouette_junction_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_x_silhouette_junction_2){
		map.SetTile(offset, CMap::tile_x_silhouette_junction_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );	
	}
	
	// CONCRETE PLANKS
	else if (pixel == color_concrete_back_1){
		map.SetTile(offset, CMap::tile_concrete_back_1 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_2){
		map.SetTile(offset, CMap::tile_concrete_back_2 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_3){
		map.SetTile(offset, CMap::tile_concrete_back_3 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_4){
		map.SetTile(offset, CMap::tile_concrete_back_4 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_5){
		map.SetTile(offset, CMap::tile_concrete_back_5 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_6){
		map.SetTile(offset, CMap::tile_concrete_back_6 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_7){
		map.SetTile(offset, CMap::tile_concrete_back_7 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_8){
		map.SetTile(offset, CMap::tile_concrete_back_8 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_9){
		map.SetTile(offset, CMap::tile_concrete_back_9 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_10){
		map.SetTile(offset, CMap::tile_concrete_back_10 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_11){
		map.SetTile(offset, CMap::tile_concrete_back_11 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_12){
		map.SetTile(offset, CMap::tile_concrete_back_12 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	
	//UP AND DOWN ONLY concrete planks
	else if (pixel == color_concrete_back_13){
		map.SetTile(offset, CMap::tile_concrete_back_13 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_14){
		map.SetTile(offset, CMap::tile_concrete_back_14 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_15){
		map.SetTile(offset, CMap::tile_concrete_back_15 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_back_16){
		map.SetTile(offset, CMap::tile_concrete_back_16 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	
	// MID PART concrete planks
	else if (pixel == color_concrete_mid_1){
		map.SetTile(offset, CMap::tile_concrete_mid_1 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_mid_2){
		map.SetTile(offset, CMap::tile_concrete_mid_2 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_mid_3){
		map.SetTile(offset, CMap::tile_concrete_mid_3 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	else if (pixel == color_concrete_mid_4){
		map.SetTile(offset, CMap::tile_concrete_mid_4 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );	
	}
	
	//line 288 solid grounds
	else if (pixel == color_street_1){
		map.SetTile(offset, CMap::tile_street_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_street_2){
		map.SetTile(offset, CMap::tile_street_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_asphalt_1){
		map.SetTile(offset, CMap::tile_asphalt_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_asphalt_2){
		map.SetTile(offset, CMap::tile_asphalt_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_asphalt_3){
		map.SetTile(offset, CMap::tile_asphalt_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_asphalt_4){
		map.SetTile(offset, CMap::tile_asphalt_4 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_clay_dirt_1){
		map.SetTile(offset, CMap::tile_clay_dirt_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_clay_dirt_2){
		map.SetTile(offset, CMap::tile_clay_dirt_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_clay_dirt_3){
		map.SetTile(offset, CMap::tile_clay_dirt_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	
	// Transparent Lightshource stopper, you see the sky, but makes a black silhouette effect,
	//it's the yellow colour on the maps
	else if (pixel == color_blank_light_stopper){
		map.SetTile(offset, CMap::tile_blank_light_stopper );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES  );
		map.AddTileFlag( offset, Tile::BACKGROUND );	
	}
	//this looks like castle makes triangles in darkness not to autotile stone backwall but the blank lightsource stopper above
	else if (pixel == color_stone_triangle){
		map.SetTile(offset, CMap::tile_stone_triangle );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES  );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );	
	}
	
	// industrial backgrounds metal columns
	else if (pixel == color_metal_column_1){
		map.SetTile(offset, CMap::tile_metal_column_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_metal_column_2){
		map.SetTile(offset, CMap::tile_metal_column_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	
	// deco - ceiling horizontal structure
	else if (pixel == color_industrial_deco_ceiling_1){
		map.SetTile(offset, CMap::tile_industrial_deco_ceiling_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_industrial_deco_ceiling_2){
		map.SetTile(offset, CMap::tile_industrial_deco_ceiling_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}

	// industrial background subway support metal panels
	else if (pixel == color_metal_back_base){
		map.SetTile(offset, CMap::tile_metal_back_base );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_metal_back_1){
		map.SetTile(offset, CMap::tile_metal_back_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_metal_back_2){
		map.SetTile(offset, CMap::tile_metal_back_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES | Tile::MIRROR );
	}
	else if (pixel == color_metal_back_3){
		map.SetTile(offset, CMap::tile_metal_back_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_metal_back_4){
		map.SetTile(offset, CMap::tile_metal_back_2);
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES | Tile::MIRROR );
	}
	else if (pixel == color_metal_back_5){
		map.SetTile(offset, CMap::tile_metal_back_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_metal_back_6){
		map.SetTile(offset, CMap::tile_metal_back_4 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_metal_back_left){
		map.SetTile(offset, CMap::tile_metal_back_angle );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_metal_back_right){
		map.SetTile(offset, CMap::tile_metal_back_angle );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES | Tile::MIRROR );
	}
	//stone floor 360
	
	//horiztonal
	else if (pixel == color_stone_floor){
		map.SetTile(offset, CMap::tile_stone_floor );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//outside corners
	else if (pixel == color_stone_floor_corner_out_right){
		map.SetTile(offset, CMap::tile_stone_floor_corner_out );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_stone_floor_corner_out_left){
		map.SetTile(offset, CMap::tile_stone_floor_corner_out );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION | Tile::MIRROR );
	}

	//vertical
	else if (pixel == color_stone_floor_vert_right){
		map.SetTile(offset, CMap::tile_stone_floor_vert );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_stone_floor_vert_left){
		map.SetTile(offset, CMap::tile_stone_floor_vert);
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION | Tile::MIRROR );
	}
	
	//inside corners
	else if (pixel == color_stone_floor_corner_in_right){
		map.SetTile(offset, CMap::tile_stone_floor_corner_in);
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES  );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_stone_floor_corner_in_left){
		map.SetTile(offset, CMap::tile_stone_floor_corner_in);
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES  );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION | Tile::MIRROR );
	}
	
	// used as corner for the bedrock	
	else if (pixel == color_bedrock_corner){
		map.SetTile(offset, CMap::tile_bedrock_corner );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	
	//wood deco park playground-like
	else if (pixel == color_wood_deco_1){
		map.SetTile(offset, CMap::tile_wood_deco_1 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wood_deco_2){
		map.SetTile(offset, CMap::tile_wood_deco_2 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wood_deco_tee){
		map.SetTile(offset, CMap::tile_wood_deco_Tee );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wood_deco_mid){
		map.SetTile(offset, CMap::tile_wood_deco_mid );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wood_deco_top){
		map.SetTile(offset, CMap::tile_wood_deco_top );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}

	// wooden fence background
	else if (pixel == color_wooden_fence_back_1){
		map.SetTile(offset, CMap::tile_wooden_fence_back_1 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wooden_fence_back_2){
		map.SetTile(offset, CMap::tile_wooden_fence_back_2 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wooden_fence_back_top_1){
		map.SetTile(offset, CMap::tile_wooden_fence_back_top_1 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wooden_fence_back_top_2){
		map.SetTile(offset, CMap::tile_wooden_fence_back_top_2 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wooden_fence_back_low_1){
		map.SetTile(offset, CMap::tile_wooden_fence_back_low_1 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_wooden_fence_back_low_2){
		map.SetTile(offset, CMap::tile_wooden_fence_back_low_2 );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}

	// handrail background
	else if (pixel == color_handrail_back_top_left){
		map.SetTile(offset, CMap::tile_handrail_back_top_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_back_top_mid){
		map.SetTile(offset, CMap::tile_handrail_back_top_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_back_top_tee){
		map.SetTile(offset, CMap::tile_handrail_back_top_tee );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_back_top_right){
		map.SetTile(offset, CMap::tile_handrail_back_top_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_back_low_left){
		map.SetTile(offset, CMap::tile_handrail_back_low_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_back_low_mid){
		map.SetTile(offset, CMap::tile_handrail_back_low_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_back_low_tee){
		map.SetTile(offset, CMap::tile_handrail_back_low_tee );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_back_low_right){
		map.SetTile(offset, CMap::tile_handrail_back_low_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}

	//snow grass-like
	else if (pixel == color_snow_front_1){
		map.SetTile(offset, CMap::tile_snow_front_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_snow_front_2){
		map.SetTile(offset, CMap::tile_snow_front_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_snow_front_3){
		map.SetTile(offset, CMap::tile_snow_front_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_snow_front_4){
		map.SetTile(offset, CMap::tile_snow_front_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES | Tile::MIRROR );
	}

	// basic black solid ground and non-solid front
	else if (pixel == color_basic_black){
		map.SetTile(offset, CMap::tile_basic_black );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_basic_black_front){
		map.SetTile(offset, CMap::tile_basic_black );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}

	// handrail front ground black
	else if (pixel == color_handrail_front_top_left){
		map.SetTile(offset, CMap::tile_handrail_front_top_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_front_top_mid){
		map.SetTile(offset, CMap::tile_handrail_front_top_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_front_top_tee){
		map.SetTile(offset, CMap::tile_handrail_front_top_tee );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_front_top_right){
		map.SetTile(offset, CMap::tile_handrail_front_top_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_front_low_left){
		map.SetTile(offset, CMap::tile_handrail_front_low_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_front_low_mid){
		map.SetTile(offset, CMap::tile_handrail_front_low_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_front_low_tee){
		map.SetTile(offset, CMap::tile_handrail_front_low_tee );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_handrail_front_low_right){
		map.SetTile(offset, CMap::tile_handrail_front_low_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}

	//black ceiling
	//doesn't collide
	else if (pixel == color_black_front_1){
		map.SetTile(offset, CMap::tile_black_front_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_black_front_2){
		map.SetTile(offset, CMap::tile_black_front_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_black_front_3){
		map.SetTile(offset, CMap::tile_black_front_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_black_front_4){
		map.SetTile(offset, CMap::tile_black_front_4 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_black_front_5){
		map.SetTile(offset, CMap::tile_black_front_5 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}

	//black ceiling inner, is solid decoration underground mainly, it's a solid tile
	else if (pixel == color_black_ceiling_inner_1){
		map.SetTile(offset, CMap::tile_black_ceiling_inner_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_black_ceiling_inner_2){
		map.SetTile(offset, CMap::tile_black_ceiling_inner_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_black_ceiling_inner_3){
		map.SetTile(offset, CMap::tile_black_ceiling_inner_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//black front deco, different name but same as black_front, doesn't collide, isn't light source
	else if (pixel == color_black_front_deco_1){
		map.SetTile(offset, CMap::tile_black_front_deco_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_black_front_deco_2){
		map.SetTile(offset, CMap::tile_black_front_deco_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_black_front_deco_3){
		map.SetTile(offset, CMap::tile_black_front_deco_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}
	else if (pixel == color_black_front_deco_4){
		map.SetTile(offset, CMap::tile_black_front_deco_4 );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::LIGHT_PASSES );
	}

	// Team-coloured background, both red and blue are LIGHT_SOURCE
	//red
	else if (pixel == color_red_back_plain){
		map.SetTile(offset, CMap::tile_red_back_plain );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_red_back_1){
		map.SetTile(offset, CMap::tile_red_back_1 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_red_back_2){
		map.SetTile(offset, CMap::tile_red_back_2 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_red_back_3){
		map.SetTile(offset, CMap::tile_red_back_3 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_red_back_4){
		map.SetTile(offset, CMap::tile_red_back_4 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_red_back_5){
		map.SetTile(offset, CMap::tile_red_back_5 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_red_back_6){
		map.SetTile(offset, CMap::tile_red_back_6 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}

	// blue
	else if (pixel == color_blue_back_plain){
		map.SetTile(offset, CMap::tile_blue_back_plain );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}

	else if (pixel == color_blue_back_1){
		map.SetTile(offset, CMap::tile_blue_back_1 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_blue_back_2){
		map.SetTile(offset, CMap::tile_blue_back_2 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_blue_back_3){
		map.SetTile(offset, CMap::tile_blue_back_3 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_blue_back_4){
		map.SetTile(offset, CMap::tile_blue_back_4 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_blue_back_5){
		map.SetTile(offset, CMap::tile_blue_back_5 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}
	else if (pixel == color_blue_back_6){
		map.SetTile(offset, CMap::tile_blue_back_6 );
		//map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE );
		map.AddTileFlag( offset, Tile::BACKGROUND | Tile::LIGHT_PASSES );
	}

	//Crates 2x2 solid, is LIGHT_SOURCE so as to see the detail
	else if (pixel == color_tile_crate_up_left){
		map.SetTile(offset, CMap::tile_crate_up_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_crate_up_right){
		map.SetTile(offset, CMap::tile_crate_up_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_crate_down_left){
		map.SetTile(offset, CMap::tile_crate_down_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_crate_down_right){
		map.SetTile(offset, CMap::tile_crate_down_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	//2nd type of 2x2 wooden crate
	else if (pixel == color_tile_crate2_up_left){
		map.SetTile(offset, CMap::tile_crate2_up_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_crate2_up_right){
		map.SetTile(offset, CMap::tile_crate2_up_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_crate2_down_left){
		map.SetTile(offset, CMap::tile_crate2_down_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_crate2_down_right){
		map.SetTile(offset, CMap::tile_crate2_down_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//1 tile wooden boxes or small crates
	else if (pixel == color_tile_wooden_box_1){
		map.SetTile(offset, CMap::tile_wooden_box_1 );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_wooden_box_2){
		map.SetTile(offset, CMap::tile_wooden_box_2 );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_wooden_box_3){
		map.SetTile(offset, CMap::tile_wooden_box_3 );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//Snow dirt, only for vertical, same sprite, normal and mirrored for visual diversity
	else if(pixel == color_tile_snow_vert){
		map.SetTile(offset, CMap::tile_snow_vert );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if(pixel == color_tile_snow_vert_mirrored){
		map.SetTile(offset, CMap::tile_snow_vert );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES );
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION | Tile::MIRROR );
	}

	//Containers, 4 colours, 9 tiles each one
	//bone colour
	else if (pixel == color_tile_container1_top_left){
		map.SetTile(offset, CMap::tile_container1_top_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_top_mid){
		map.SetTile(offset, CMap::tile_container1_top_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_top_right){
		map.SetTile(offset, CMap::tile_container1_top_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_mid_left){
		map.SetTile(offset, CMap::tile_container1_mid_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_mid_mid){
		map.SetTile(offset, CMap::tile_container1_mid_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_mid_right){
		map.SetTile(offset, CMap::tile_container1_mid_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_low_left){
		map.SetTile(offset, CMap::tile_container1_low_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_low_mid){
		map.SetTile(offset, CMap::tile_container1_low_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container1_low_right){
		map.SetTile(offset, CMap::tile_container1_low_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//greenish
	else if (pixel == color_tile_container2_top_left){
		map.SetTile(offset, CMap::tile_container2_top_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_top_mid){
		map.SetTile(offset, CMap::tile_container2_top_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_top_right){
		map.SetTile(offset, CMap::tile_container2_top_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_mid_left){
		map.SetTile(offset, CMap::tile_container2_mid_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_mid_mid){
		map.SetTile(offset, CMap::tile_container2_mid_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_mid_right){
		map.SetTile(offset, CMap::tile_container2_mid_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_low_left){
		map.SetTile(offset, CMap::tile_container2_low_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_low_mid){
		map.SetTile(offset, CMap::tile_container2_low_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container2_low_right){
		map.SetTile(offset, CMap::tile_container2_low_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//blueish
	else if (pixel == color_tile_container3_top_left){
		map.SetTile(offset, CMap::tile_container3_top_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_top_mid){
		map.SetTile(offset, CMap::tile_container3_top_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_top_right){
		map.SetTile(offset, CMap::tile_container3_top_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_mid_left){
		map.SetTile(offset, CMap::tile_container3_mid_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_mid_mid){
		map.SetTile(offset, CMap::tile_container3_mid_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_mid_right){
		map.SetTile(offset, CMap::tile_container3_mid_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_low_left){
		map.SetTile(offset, CMap::tile_container3_low_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_low_mid){
		map.SetTile(offset, CMap::tile_container3_low_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container3_low_right){
		map.SetTile(offset, CMap::tile_container3_low_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//mossy
	else if (pixel == color_tile_container4_top_left){
		map.SetTile(offset, CMap::tile_container4_top_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_top_mid){
		map.SetTile(offset, CMap::tile_container4_top_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_top_right){
		map.SetTile(offset, CMap::tile_container4_top_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_mid_left){
		map.SetTile(offset, CMap::tile_container4_mid_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_mid_mid){
		map.SetTile(offset, CMap::tile_container4_mid_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_mid_right){
		map.SetTile(offset, CMap::tile_container4_mid_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_low_left){
		map.SetTile(offset, CMap::tile_container4_low_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_low_mid){
		map.SetTile(offset, CMap::tile_container4_low_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_container4_low_right){
		map.SetTile(offset, CMap::tile_container4_low_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//Industrial beam structures
	// this autotiled would be much faster for map making
	else if (pixel == color_tile_beam_h_left){
		map.SetTile(offset, CMap::tile_beam_h_left );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_h_mid){
		map.SetTile(offset, CMap::tile_beam_h_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_h_mid_shadowed){
		map.SetTile(offset, CMap::tile_beam_h_mid_shadowed );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_h_right){
		map.SetTile(offset, CMap::tile_beam_h_right );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_v_mid){
		map.SetTile(offset, CMap::tile_beam_v_mid );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_v_top){
		map.SetTile(offset, CMap::tile_beam_v_top );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}

	//swap to background ones; end of the beam, but followed by column or any othe background
	else if (pixel == color_tile_beam_h_left_swap){
		map.SetTile(offset, CMap::tile_beam_h_left_swap );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_v_top_swap){
		map.SetTile(offset, CMap::tile_beam_v_top_swap );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_h_right_swap){
		map.SetTile(offset, CMap::tile_beam_h_right_swap );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
	else if (pixel == color_tile_beam_v_down_swap){
		map.SetTile(offset, CMap::tile_beam_v_down_swap );
		map.RemoveTileFlag( offset, Tile::LIGHT_PASSES);
		map.AddTileFlag( offset, Tile::SOLID | Tile::COLLISION );
	}
// wooden ladders both simple and with vegetation
	else if (pixel == color_ladder_custom){
		map.SetTile(offset, CMap::tile_ladder_custom );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE);
		map.AddTileFlag( offset, Tile::LADDER | Tile::BACKGROUND );
	}
	else if (pixel == color_ladder_custom_veg){
		map.SetTile(offset, CMap::tile_ladder_custom_veg );
		map.RemoveTileFlag( offset, Tile::LIGHT_SOURCE);
		map.AddTileFlag( offset, Tile::LADDER | Tile::BACKGROUND );
	}
}
	