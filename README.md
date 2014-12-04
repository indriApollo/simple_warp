simple_warp
===========

(https://forum.minetest.net/viewtopic.php?f=9&t=10681)

A warp mod for Minetest

**List of commands :**
- ```/setwarp <name>``` (set a private warp at your current position)
- ```/delwarp <name>``` (delete a private warp)
- ```/setwarpall <name>``` (set a public warp at your current position)
- ```/delwarpall <name>``` (delete a public warp)
- ```/warps <index>``` (outputs the list of private warps, set page index to go to the next page)
- ```/warpsall <index>``` (outputs the list of public warps, set page index to go to the next page)
- ```/warp <location>``` (move to warp position)

**Privs :**
- ```usewarp``` (can warp to worldwide/private locations)
- ```warpown``` (can set/del private locations)
- ```warpall``` (can set/del public locations)

**Note :**
The public locations have primary name claim, that means if you use /setwarp test and 'test' is already used publicly, the mod will throw an error. But if you had already set 'test' as private, /setwarpall test will ignore your location and you'll end up with conflicting names (in that case /warp test will always move you to the public location). An easy solution is to prefix the public locations.

**Depends :** none

**Licence :** lgpl 2.1

**Download :** https://github.com/indriApollo/simple_warp/archive/master.zip

**Installation :** Unzip the file and rename it to "simple_warp". Then move it to the mod directory.
