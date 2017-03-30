#airgeddon Dockerfile

#Base image
FROM kalilinux/kali-linux-docker:latest

#Credits & Data
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

#Install needed Ruby gems
RUN \
	apt-get -y install \
	beef-xss \
	bettercap

#Env vars
ENV AIRGEDDON_URL="https://github.com/v1s1t0r1sh3r3/airgeddon.git"
ENV BULLY_URL="https://github.com/v1s1t0r1sh3r3/bully.git"
ENV HASHCAT2_URL="https://github.com/v1s1t0r1sh3r3/hashcat2.0.git"
ENV DISPLAY=":0"

#Create dir for external files
RUN \
	mkdir /io

#Set workdir
WORKDIR /opt/

#Download airgeddon
RUN \
	git clone ${AIRGEDDON_URL} && \
	chmod +x airgeddon/*.sh

#Prepare packages to upgrade Bully
RUN \
	apt-get -y install libssl1.0-dev \
	build-essential \
	libpcap-dev

#Upgrade Bully
RUN \
	git clone ${BULLY_URL} && \
	cd /opt/bully/src && \
	make && \
	make install && \
	cp /usr/local/bin/bully /usr/bin/ && \
	chmod +x /usr/bin/bully

#Downgrade Hashcat
RUN \
	git clone ${HASHCAT2_URL} && \
	cp /opt/hashcat2.0/hashcat /usr/bin/ && \
	chmod +x /usr/bin/hashcat

#Clean packages
RUN \
	apt-get autoremove && \
	apt-get clean && \
	apt-get autoclean

#Clean files
RUN rm -rf /opt/airgeddon/imgs > /dev/null 2>&1 && \
	rm -rf /opt/airgeddon/.github > /dev/null 2>&1 && \
	rm -rf /opt/airgeddon/CONTRIBUTING.md > /dev/null 2>&1 && \
	rm -rf /opt/airgeddon/pindb_checksum.txt > /dev/null 2>&1 && \
	rm -rf /opt/airgeddon/Dockerfile > /dev/null 2>&1 && \
	rm -rf /opt/bully > /dev/null 2>&1 && \
	rm -rf /opt/hashcat2.0 > /dev/null 2>&1 && \
	rm -rf /tmp/* > /dev/null 2>&1

#Entrypoint
CMD ["bash", "-c", "/opt/airgeddon/airgeddon.sh"]
