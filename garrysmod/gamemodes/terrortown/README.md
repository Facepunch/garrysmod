Trouble in Terrorist Town
=========================
Garry's Mod 13 gamemode 
By Bad King Urgrain
http://ttt.badking.net/


Description
===========
Disaster strikes in the Terrorist team! These plucky bomb-planting fighters 
have traitors in their midst who are looking to kill them all! But who are 
the traitors... and who will come out of this alive?

Installation
============
If you're looking at a version of TTT included in gmod, you're already done!

If you're dealing with a .zip version, extract .zip contents into:
  "X:\Steam\steamapps\common\garrysmod\garrysmod\"

Or for a dedicated server:
  "X:\srcds\orangebox\garrysmod\"

So that you get a "\garrysmod\gamemodes\terrortown\" directory.

Installing is never necessary if you only want to play on servers.


Dedicated server (srcds) preparation
====================================
The gamemode _requires_ CS:S content to be installed. The Garry's Mod wiki
has some information on this here:
* https://wiki.facepunch.com/gmod/Mounting_Content_on_a_Dedicated_Server
  
If you want TTT to automatically switch maps every few rounds, place a
mapcycle.txt in the "\garrysmod\" directory. It should contain a list of map
names, exactly like the mapcycle.txt in Source games like CS:S or HL2DM. If you
don't know what maps to use, just put in a list of the CS:S maps, all of them
work. See ttt_round_limit and such in the convar section below for more configuration.

A common problem is strange issues with floating grenades, floating weapons, and
instant reloading. These are all caused by the server not having CS:S content
installed. If the issues persist despite making sure the CS:S content is there,
try moving the "cstrike" directory into the "orangebox" one, so you get "\servername\orangebox\cstrike\".

While TTT tries to do this automatically, you'll also want to turn off "sv_alltalk" if it's on. 
It will override TTT's voice handling, and let dead people talk to living players during a round (bad). 
So put "sv_alltalk 0" in your server.cfg.

Note that you should disable "sv_allowcslua" (disabled by default, but you should add "sv_allowcslua 0" just incase) functionality. With it on,
cheating will be very easy. All you should need to do is set "sv_allowcslua" to 0.

Modding the gamemode
====================
You should feel free to modify the gamemode in any way you want.

An easy way of customizing TTT is creating your own weapons. You can add your
own scripted weapons without touching the TTT code, so you won't have to
deal too much with code changes from TTT updates.

To get started with custom weapons, check the GMod wiki about SWEPs, and then
take a look at some of the standard TTT weapons that you can find in:
* "\gamemodes\terrortown\entities\weapons\"

The script for weapon_tttbase has a bunch of documentation you might find
useful. There is a guide available at http://ttt.badking.net/

There are a number of hooks you can use as well. Again, the site is the place to
find further information.

Convars and concommands
=======================
The list of all convars used to be here in the readme, but has been moved to the site, where it is easier to find
* http://ttt.badking.net/config-and-commands/

Credits
=======
Bad King Urgrain made this in 2009/2010.

Weapon/ammo/player spawn placement scripts included in TTT (such as those for
the CS:S maps) were contributed by the following people:
* Ajunk
* Broadsword
* eeny
* JossiRossi
* that guy
* worbat
