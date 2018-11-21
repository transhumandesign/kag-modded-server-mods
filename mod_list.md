# Mod list

This is the list of mods as they are currently hosted on the official modded server, in python source code form.

This list is subject to change and must be kept in sync manually.

However, if you add a mod, it is recommended to add an entry for it here, for easier integration with the official modded server.

```
mod_configs = [
	# (each config is of the format:)
	# {
	#	'name': '(appended to the server name)'
	#	'autoconfig' : {
	#	 	'sv_gamemode': '(mod rules gamemode)',
	#		'more_autoconfig_vars': 'anything can be overridden',
	#	}
	#	'motd': 'dict to use as the motd cfg'
	# 	'mods': {
	# 		'modname': 'empty string or api resource'
	# 	}
	# }

	{
		'name': 'The Waste Kind',
		'autoconfig' : {
		 	'sv_gamemode': 'CTF',
		 	'sv_maxplayers': 10,
		 	'sv_info': ('Single-class high-detail tactical CTF - '
		 				'detailed maps, dashing, grenades and drama!  '
		 			 	'Mods by 8x, Jaytlebee, Chrispin + More')
		},
		'mods': {
			'TheWasteKind': '',
			'Explosives': '',
		}
	},
	{
		'name': 'Attack and Defence',
		'autoconfig' : {
		 	'sv_gamemode': 'AD',
		 	'sv_maxplayers': 14,
		 	'sv_info': ('Build an impenetrable fortress, '
		 			 	'then defend against a fearsome siege! '
		 			 	'Custom Heads Mod Included!  '
		 			 	'Mods by Verra, Skinney, and makmoud98')
		},
		'mods': {
			'AD': '',
			'PlayerHeads': 'PlayerHeads:PlayerHeads'
		}
	},
	{
		'name': 'Custom Heads CTF',
		'autoconfig' : {
		 	'sv_gamemode': 'CTF',
		 	'sv_maxplayers': 14,
		 	'sv_info': ('Vanilla CTF with custom heads!  '
		 			 	'Mod by Skinney and makmoud98')
		},
		'mods': {
			'PlayerHeads': 'PlayerHeads:PlayerHeads'
		}
	},
	{
		'name': 'Shiprekt',
		'autoconfig' : {
		 	'sv_gamemode': 'TDM',
		 	'sv_maxplayers': 12,
		 	'sv_info': ('Construct a ship from random parts and destroy the enemy core to win!  '
		 			 	'Mod by THD')
		},
		'mods': {
			'Shiprekt': '',
		}
	},
	{
		'name': 'Laser Wars',
		'autoconfig' : {
		 	'sv_gamemode': 'FW',
		 	'sv_maxplayers': 10,
		 	'sv_info': ('Tactical Sci-Fi CTF - multiple classes, jetpacks, and weapons!  '
		 			 	'Mod by Aphelion')
		},
		'mods': {
			'LaserWars': ''
		}
	},
]
```