FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
	libfuse2 \
	libgtk2.0 \
	psmisc \
	sudo \
	wget \
	libnotify4

WORKDIR /tmp
RUN wget https://downloads.jungledisk.com/jungledisk/junglediskdesktop_320-0_amd64.deb \
	&& dpkg -i junglediskdesktop_320-0_amd64.deb \
	&& apt-get -f install -y \
	&& rm junglediskdesktop_320-0_amd64.deb \
	&& apt-get clean

RUN export uid=1000 gid=1000 && \
	mkdir -p /home/user && \
	echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
	echo "user:x:${uid}:" >> /etc/group && \
	echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
	chmod 0440 /etc/sudoers.d/user && \
	mkdir /home/user/.jungledisk && \
	chown ${uid}:${gid} -R /home/user

USER user
ENV HOME /home/user
CMD jungledisk
