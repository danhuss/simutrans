FROM debian:testing-slim
LABEL 	maintainer="Daniel Huss - https://github.com/danhuss" \
	description="A docker image for running a Simutrans server."

##create the user
RUN mkdir /home/app && \ 
	groupadd -r app && \ 
	useradd -d /home/app -r -g app app && \ 
	chown app:app -R /home/app && \
##Get everything needed to compile
	apt-get -y update && \
    apt-get -y install \ 
		autoconf \ 
		build-essential \ 
		curl \ 
		git \ 
		libbz2-dev \ 
		libz-dev \ 
		unzip && \
#    apt-get -y build-dep simutrans && \
    apt-get -y remove libsdl1.2-dev && \
    rm -rf /var/lib/apt/lists/* && \ 
	git clone https://github.com/danhuss/simutrans-server-docker.git

# COPY . /simutrans-server-docker

##Compile the code
RUN cd /simutrans-server-docker && \ 
	./get_lang_files.sh && \ 
	autoconf && \ 
	./configure --prefix=/usr --enable-server && \ 
	make && \ 
	mv simutrans / && \ 
	mv sim /simutrans && \ 
	chown app:app -R /simutrans
	
##Let's install a default pak and some default settings ./get_pak.sh
	
##Cleanup
RUN rm -rf /simutrans-server-docker && \ 
	rm -rf /simutrans/config/simuconf.tab /simutrans/music/ /simutrans/script/ && \ 
	strip /simutrans/sim && \ 
	apt-get -y remove autoconf build-essential git libbz2-dev libz-dev && \ 
	apt -y autoremove 

WORKDIR /simutrans
USER app

VOLUME ["/simutrans/pak", "/simutrans/config/simuconf.tab", "/simutrans/save/"]

CMD ["./sim", "-server", "-singleuser", "-lang", "en", "-objects", "pak/", "-nosound", "-nomidi", "-noaddons"]