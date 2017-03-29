#airgeddon Dockerfile

#Base image
FROM kalilinux/kali-linux-docker:latest

#Credits
LABEL \
	name="airgeddon" \
	author="v1s1t0r <v1s1t0r.1s.h3r3@gmail.com>" \
	maintainer="OscarAkaElvis <oscar.alfonso.diaz@gmail.com>" \
	description="This is a multi-use bash script for Linux systems to audit wireless networks."

#Update system
RUN \
	apt-get update

#Install airgeddon essential tools
RUN \
	apt-get -y install \
	gawk \
	net-tools \
	wireless-tools \
	iw \
	aircrack-ng \
	xterm

#Install airgeddon internal tools
RUN \
	apt-get -y install \
	ethtool \
	pciutils \
	rfkill \
	x11-utils

#Install update tools
RUN \
	apt-get -y install \
	curl \
	git

#Install airgeddon optional tools
RUN \
	apt-get -y install \
	crunch \
	hashcat \
	mdk3 \
	hostapd \
	lighttpd \
	iptables \
	ettercap-text-only \
	sslstrip \
	isc-dhcp-server \
	dsniff \
	reaver \
	bully \
	pixiewps \
	expect

#Install needed ruby gems
RUN \
	apt-get -y install \
	beef-xss \
	bettercap

#Cleaning packages
RUN \
	apt-get autoremove && \
	apt-get clean && \
	apt-get autoclean

#Env vars
ENV AIRGEDDON_URL="https://github.com/v1s1t0r1sh3r3/airgeddon.git"
ENV DISPLAY=":0"

#Set workdir
WORKDIR /opt/

#Download airgeddon
RUN \
	git clone ${AIRGEDDON_URL} && \
	chmod +x airgeddon/*.sh

#Cleaning files
RUN rm -rf /opt/airgeddon/imgs && \
	rm -rf /opt/airgeddon/.github && \
	rm -rf /opt/airgeddon/CONTRIBUTING.md && \
	rm -rf /opt/airgeddon/pindb_checksum.txt && \
	rm -rf /tmp/*

#Entrypoint
CMD ["bash", "-c", "/opt/airgeddon/airgeddon.sh"]