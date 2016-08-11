# chivarly-juggernaut

First player to get a kill becomes the Juggernaut. an oversized player with extra strength and health.
The Juggernaut scores 2 points for every kill they get.
If a player kills the Juggernaut they become the juggernaut and score 2 points.
No points are obtained by non-juggernauts killing non-juggernauts.

A marker displays the location of the current Juggernaut.

---

Steam workshop: http://steamcommunity.com/sharedfiles/filedetails/?id=740605534

--- 

Start a server with ?modname=Juggernaut on the command line (appended to the map). For example: 

UDK.exe aoctd-frigid_p?modname=Juggernaut... 


You can specify the mod you'd like to use in the maplist as well (in PCServer-UDKGame.ini), allowing you to switch between mods if you want. For example: 

Maplist=aoctd-frigid_p?modname=Juggernaut
Maplist=aoctd-moor_p?modname=someothermod 

Keep in mind that ? options specified in the map list will carry between map changes. 

Add this switch to the server's command line to have it download automatically: 

-sdkfileid=740605534

================= 

If you want to play offline, just use the 'open' console command, again appending ?modname. 

open aoctd-frigid_p?modname=Juggernaut
