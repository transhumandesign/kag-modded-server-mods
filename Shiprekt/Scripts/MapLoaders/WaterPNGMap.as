// loads a.PNG map
// PNG loader base class - extend this to add your own PNG loading functionality!

bool LoadMap( CMap@ map, const string& in fileName )
{
	PNGLoader loader();
	return loader.loadMap(map , fileName);
}

// --------------------------------------

#include "CustomMap.as";
#include "LoadMapUtils.as";

class PNGLoader
{
	PNGLoader()	{
	}

	CFileImage@ image;
	CMap@ map;

	bool loadMap( CMap@ _map, const string& in filename)
	{
		@map = _map;

		if (!getNet().isServer())
		{
			CMap::SetupMap( map, 0, 0 );
			return true;
		}

		@image = CFileImage( filename );		
		if (image.isLoaded())
		{
			CMap::SetupMap( map, image.getWidth(), image.getHeight() );

			while (image.nextPixel())
			{
				SColor pixel = image.readPixel();
				int offset = image.getPixelOffset();
				CMap::handlePixel( map,pixel, offset );
				getNet().server_KeepConnectionsAlive();
			}

			return true;
		}
		return false;
	}
 
}