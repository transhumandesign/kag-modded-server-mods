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
		'name': 'Official Modding Server: Attack and Defence!',
		'autoconfig' : {
		 	'sv_gamemode': 'AD',
		 	'sv_maxplayers': 20,
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
		'name': 'Official Modding Server: Shiprekt',
		'autoconfig' : {
		 	'sv_gamemode': 'TDM',
		 	'sv_maxplayers': 18,
		 	'sv_info': ('Construct a ship from random parts and destroy the enemy core to win!  '
		 			 	'Mod by THD')
		},
		'mods': {
			'Shiprekt': ''
		}
	},
	{
		'name': 'Official Modding Server: Archer Parkour!',
		'autoconfig' : {
		 	'sv_gamemode': 'Parkour+',
		 	'sv_maxplayers': 20,
		 	'sv_info': ('Reach the end as fast as you can!, '
		 			 	'Mod by Monkey_Feats! ')
		},
		'mods': {
			'Parkour+': '',
			'PlayerHeads': 'PlayerHeads:PlayerHeads'
		}
	},
	{
		'name': 'Official Modding Server: Grobbers 3D!',
		'autoconfig' : {
		 	'sv_gamemode': 'tdm',
		 	'sv_maxplayers': 30,
		 	'sv_info': ('First 3D mod in KAG, '
		 			 	'Mod by GoldenGuy, Sprites by Jenny! ')
		},
		'mods': {
			'Grobber3D_demo': ''
		}
	},
]
```