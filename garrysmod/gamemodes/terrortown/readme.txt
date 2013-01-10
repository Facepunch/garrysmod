Trouble in Terrorist Town
Garry's Mod 10 (Fretta) gamemode
By Bad King Urgrain
http://ttt.badking.net/


*** Description:
Disaster strikes in the Terrorist team! These plucky bomb-planting fighters 
have traitors in their midst who are looking to kill them all! But who are 
the traitors... and who will come out of this alive?


*** Fretta notes:
TTT is Fretta-compatible, which in this case means players get the chance to
vote in order to switch to a different Fretta gamemode.

If you run a server with only TTT on it, you can disable the voting by putting:
  fretta_voting 0
In your server.cfg file. This will pretty much make TTT act like a non-Fretta
gamemode. Note that it will also automatically switch maps according to the
mapcycle.txt, so you should make sure you have one.

You may want to use the Fretta voting system just for selecting the next
map. This is possible using the cvar:
  ttt_fretta_mapvoting 1
Whenever a vote starts, it will skip the gamemode part and just let players vote
on the map to play.

The convar fretta_votesneeded sets the fraction of the players who need to have
voted to change map/gamemode before a vote starts. Votes also start when the
time or round limit is reached, which is when a non-fretta_voting server would
automatically switch maps.

A Fretta server does not have a mapcycle.txt for specific gamemodes, so TTT will
not automatically switch the map as long as that is enabled. You can manually
enable it even when Fretta is on using ttt_always_use_mapcycle.


*** Installation:
If you're looking at a version of TTT included in gmod, you're already done!

If you're dealing with a .zip version, extract .zip contents into:
  X:\Steam\steamapps\your@account\garrysmod\garrysmod\

Or for a dedicated server:
  X:\srcds\orangebox\garrysmod\

So that you get a \garrysmod\gamemodes\terrortown\ directory.

Installing is never necessary if you only want to play on servers.


*** Dedicated server (srcds) preparation:
The gamemode _requires_ CS:S content to be installed. The Garry's Mod wiki
has some information on this (and other srcds setup procedures) here:
  http://wiki.garrysmod.com/?title=Dedicated_Server_Setup#Extra_content
  
If you want TTT to automatically switch maps every few rounds, place a
mapcycle.txt in the \garrysmod\ directory. It should contain a list of map
names, exactly like the mapcycle.txt in Source games like CS:S or HL2DM. If you
don't know what maps to use, just put in a list of the CS:S maps, all of them
work. Once you have a mapcycle file, either disable fretta_voting or enable
ttt_always_use_mapcycle in your server.cfg to enable map cycling. See
ttt_round_limit and such in the convar section below for more configuration.

A common problem is strange issues with floating grenades, floating weapons, and
instant reloading. These are all caused by the server not having CS:S content
installed. If the issues persist despite making sure the CS:S content is there,
try moving the "cstrike" directory into the "orangebox" one, so you get
\servername\orangebox\cstrike\.

You'll also want to turn off sv_alltalk if it's on. It will override TTT's
voice handling, and let dead people talk to living players during a round (bad).
So put sv_alltalk 0 in your server.cfg.

Note that you should enable GMod's ScriptEnforcer functionality. Without it,
cheating will be very easy. All you should need to do is set sv_scriptenforcer
to 1.

For sv_downloadurl/FastDL, the gamemode files will also have to be on the
download server. This includes an up-to-date version of the Lua cache in
\garrysmod\cache\. You may also have to move the stuff in:
  \garrysmod\gamemodes\terrortown\contents\
.. into the main \garrysmod\ directory of the download server. In practice,
players probably don't need to download those files though, because their
gmod will include them.


*** Modding the gamemode:
You should feel free to modify the gamemode in any way you want.

An easy way of customizing TTT is creating your own weapons. You can add your
own scripted weapons without touching the TTT code, so you won't have to
deal too much with code changes from TTT updates.

To get started with custom weapons, check the GMod wiki about SWEPs, and then
take a look at some of the standard TTT weapons that you can find in:
  \gamemodes\terrortown\entities\weapons\

The script for weapon_tttbase has a bunch of documentation you might find
useful. There is a guide available at http://ttt.badking.net/

There are a number of hooks you can use as well. Again, the site is the place to
find further information.

*** Convars and concommands:
The list of all convars used to be here in the readme, but has been moved to
the site, where it is easier to find:
  http://ttt.badking.net/config-and-commands/

Or the alternative url:
  http://sites.google.com/site/troubleinterroristtown/config-and-commands/


*** Credits:
Bad King Urgrain made this in 2009/2010.

Weapon/ammo/player spawn placement scripts included in TTT (such as those for
the CS:S maps) were contributed by the following people:
  Ajunk
  Broadsword
  eeny
  JossiRossi
  that guy
  worbat

