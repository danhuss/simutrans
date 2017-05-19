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
    apt-get -y build-dep simutrans && \
    apt-get -y remove libsdl1.2-dev && \
##	used instead of COPY for building on docker for windows (carriage return issues)
#	git clone https://github.com/danhuss/simutrans-server-docker.git && \ 
    rm -rf /var/lib/apt/lists/* 

COPY . /simutrans-server-docker

##Compile the code
RUN cd /simutrans-server-docker && \ 
	./get_lang_files.sh && \ 
	autoconf && \ 
	./configure --prefix=/usr --enable-server && \ 
	make && \ 
	mv simutrans / && \ 
	mv sim /simutrans && \ 
	mkdir /simutrans/save && \ 
	chown app:app -R /simutrans

	
##Let's install a default pak and some default settings 
RUN cd / && \ 
	curl -L -o simupak64.zip https://downloads.sourceforge.net/project/simutrans/pak64/120-2/simupak64-120-2.zip && \ 
	unzip simupak64.zip && \
	mv /simutrans-server-docker/serversave.sve /simutrans/save/
	
##Cleanup
RUN rm -rf /simutrans-server-docker && \ 
	rm -rf /simutrans/music/ /simutrans/script/ && \ 
	strip /simutrans/sim && \ 
	apt-get -y remove autoconf build-essential git libbz2-dev libz-dev && \ 
	apt -y autoremove 

WORKDIR /simutrans
USER app

VOLUME ["/simutrans/pak/", "/simutrans/config/", "/simutrans/save/"]
ENTRYPOINT ["./sim", "-server","13353", "-singleuser", "-lang","en", "-objects","pak/", "-nosound", "-nomidi", "-noaddons", "-log","1", "-debug","3"]
CMD ["-load","serversave.sve"]