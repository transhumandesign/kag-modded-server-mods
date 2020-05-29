// copyrighted by GoldenGuy#8983 , DO NOT STEAL >:[

string characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,?!@_*#$%&()+-/:;<=>[]^{} ";
u8[] sizes = {5,5,5,5,5,5,5,5,3,5,5,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,1,4,4,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,1,1,5,1,5,3,3,5,5,5,5,2,2,3,3,2,1,1,2,3,2,2,2,3,3,3,4}; //damn

class NickName
{
	string player_name; // persons name probably
	Vertex[] Vertexes;
	u16[] IDs;
	NickName(){}
	NickName(string _player_name)//, Vertex[] _Vertexes, u16[] _IDs)
	{
		player_name = _player_name+"_NN";
		SColor nickColor = color_white;
		if(_player_name == "GoldenGuy" || _player_name == "Jenny" || _player_name == "Vamist")
			nickColor = SColor(0xFFFF2020);
		int size_x = 0;
		if(!Texture::exists(_player_name+"_NN"))
		{
			if(!Texture::exists("NickNamesFont"))
				Texture::createFromFile("NickNamesFont", "NickNamesFont.png");
				
			ImageData@ nicknames_font_img = Texture::data("NickNamesFont");

			size_x = figureOutTextureLength(_player_name);
			ImageData@ nickname_img = ImageData(size_x, 7);
			
			int nn_last_pos_x = 0;
			
			for(int char = 0; char < _player_name.length(); char++)
			{
				string temp = _player_name.substr(char, -1);
				temp.resize(1);
				//print("temp: "+temp);
				int id = characters.findFirst(temp, 0);
				u8 letter_size = sizes[id];
				int characters_pos_x = 0;
				for(int i = 0; i < id; i++)
				{
					characters_pos_x += sizes[i]+1;
				}
					
				//print("letter: "+temp+"; id = "+id+"; letter_size = "+letter_size);
				
				//print("characters_pos_x: "+characters_pos_x);
				//print(" ");
				
				for(int y = 0; y < 8; y++)
				{
					string bitmap = "";
					for(int x = characters_pos_x; x < characters_pos_x+letter_size+1; x++)
					{
						SColor col = nicknames_font_img.get(x, y);
						if(col.color == 16777215) {nickname_img.put(nn_last_pos_x+(x-characters_pos_x), y, color_black);bitmap +=".";
						}
						else{ bitmap +="0";
						//print("col: "+col.color);
						//if(col.getAlpha() == 0) continue;
						
						nickname_img.put(nn_last_pos_x+(x-characters_pos_x), y, nickColor);}
					}
					//print("  "+bitmap);
				}
				nn_last_pos_x += letter_size+1;
			}
			Texture::createFromData(_player_name+"_NN", nickname_img);
			
			//Texture::createFromFile("Pistol0", "Pistol0.png");
		}
		else
		{
			ImageData@ nickname_img = Texture::data(_player_name+"_NN");
			size_x = nickname_img.width();
		}
		f32 letter_ratio = 1.0f/64.0f;
		f32 letter_heigth = letter_ratio*7;
		f32 text_start = 0-letter_ratio*size_x/2;
		f32 text_end = letter_ratio*size_x/2;
		Vertex[] _Vertexes = {	Vertex(text_start,	letter_heigth+1.2,	0, 0,0,	SColor(120, 255, 255, 255)),
								Vertex(text_end,	letter_heigth+1.2,	0, 1,0,	SColor(120, 255, 255, 255)),
								Vertex(text_end,	1.2,				0, 1,1,	SColor(120, 255, 255, 255)),
								Vertex(text_start,	1.2,				0, 0,1,	SColor(120, 255, 255, 255))};
		u16[] v_ids = {0,1,2,0,2,3};
		//tile_sheet = _tile_sheet;
		Vertexes = _Vertexes;
		IDs = v_ids;
	}
}

int figureOutTextureLength(string player_name)
{
	int nickname_length = 0;
	for(int char = 0; char < player_name.length(); char++)
	{
		string temp = player_name.substr(char, -1);
		temp.resize(1);
		u8 letter_size = sizes[characters.findFirst(temp, 0)];
		
		nickname_length += letter_size+1;
		
		//if(char < player_name.length()-1)
		//	nickname_length++;
	}
	return nickname_length;
}