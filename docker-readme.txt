Simutrans Server, Dockerized - http://www.simutrans.com/
I setup a bunch of defaults so it can be setup really quickly. You can 
mix and match some of the launch options to customize as needed.

Forked from https://github.com/aburch/simutrans Thanks to everyone who has contributed.

Defaults: 
 - Graphics Pak = pak64; 
 - simuconf.tab = default from build; 
 - game file = a random 256x256 map I created.

 Launch with all the defaults:
	docker run -d -p 13353:13353 dahuss/simutrans-server-docker
 Launch with a custom pak:
	docker run -d -p 13353:13353 -v <local path>/pak128:/simutrans/pak dahuss/simutrans-server-docker
 Launch with a custom config (place custom simuconf.tab in directory by itself):
	docker run -d -p 13353:13353 -v <path to config directory>:/simutrans/config dahuss/simutrans-server-docker
 Launch with custom game file:
	docker run -d -p 13353:13353 -v <path to save directory>:/simutrans/save dahuss/simutrans-server-docker -load <save game file>
