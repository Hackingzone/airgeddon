<!-- Change version for shield on each commit -->
<!-- Visit https://shields.io/ for more info -->
<!-- Shields' color scheme based on banner: colorA=273133 colorB=0093ee -->

# :satellite: airgeddon [![Version-shield]](CHANGELOG.md) [![Bash4.2-shield]](http://tldp.org/LDP/abs/html/bashver4.html#AEN21220) [![License-shield]](LICENSE.md) [![Paypal-shield]](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7ELM486P7XKKG) [![Bitcoin-shield]](https://blockchain.info/address/1AKnTXbomtwUzrm81FRzi5acSSXxGteGTH)

> This is a multi-use bash script for Linux systems to audit wireless networks.

![Banner]

<details>
	<summary><strong>Table of Contents</strong></summary>
	<ul>
		<li><a href="#features">Features</a></li>
		<li><a href="#requirements">Requirements</a></li>
		<ul>
			<li><a href="#essential-tools--the-script-does-not-work-if-you-dont-have-installed-all-of-them">Essential Tools</a></li>
			<li><a href="#optional-tools--not-necessary-to-work-only-needed-for-some-features">Optional Tools</a></li>
			<ul>
				<li><a href="#important-tips-about-beef">BeEF Tips</a></li>
				<li><a href="#important-tips-about-hashcat">Hashcat Tips</a></li>
			</ul>
			<li><a href="#update-tools--not-necessary-to-work-only-used-for-auto-update">Update Tools</a></li>
			<li><a href="#internal-tools--these-are-internally-checked-not-necessary-to-work-good-to-have">Internal Tools</a></li>
		</ul>
		<li><a href="#usage">Usage</a></li>
		<li><a href="#supported-languages">Supported Languages</a></li>
		<li><a href="#known-incompatibilities">Known Incompatibilities</a></li>
		<li><a href="#contributing">Contributing</a></li>
		<li><a href="#changelog">Changelog</a></li>
		<li><a href="#disclaimer--license">Disclaimer & License</a></li>
		<li><a href="#acknowledgments--license">Acknowledgments</a></li>
		<ul>
			<li><a href="#hat-tip-to">Hat Tip To</a></li>
			<li><a href="#inspiration">Inspiration</a></li>
		</ul>
	</ul>
</details>

---

### Features

<!-- Each sub list needs 2 additional followed spaces -->
- Interface mode switcher (Monitor-Managed) keeping selection even on interface name changing
- DoS over wireless networks using different methods
- Assisted Handshake file capturing
- Cleaning and optimizing Handshake captured files
- Offline password decrypting on WPA/WPA2 captured files (dictionary, bruteforce and rule based)
- Evil Twin attacks (Rogue AP)
  - Only Rogue/Fake AP version to sniff using external sniffer (Hostapd + DHCP + DoS)
  - Simple integrated sniffing (Hostapd + DHCP + DoS + Ettercap)
  - Integrated sniffing, sslstrip (Hostapd + DHCP + DoS + Ettercap + Sslstrip)
  - Integrated sniffing, sslstrip2 and BeEF browser exploitation framework (Hostapd + DHCP + DoS + Bettercap + BeEF)
  - Captive portal with "DNS blackhole" to capture wifi passwords (Hostapd + DHCP + DoS + Dnsspoff + Lighttpd)
  - Optional MAC spoofing for all Evil Twin attacks
- WPS features
  - WPS scanning (wash). Self parameterization to avoid *"bad fcs"* problem
  - Custom PIN association (bully and reaver)
  - Pixie Dust attacks (bully and reaver)
  - Bruteforce PIN attacks (bully and reaver)
  - Parameterizable timeouts
  - Known WPS PINs attack (bully and reaver), based on online PIN database with auto-update
  - Integration of the most common PIN generation algorithms
- Compatibility with many Linux distributions (see [Requirements] section)
- Easy targeting and selection in every section
- Drag and drop files on console window for entering file paths
- Dynamic screen resolution detection and windows auto-sizing for optimal viewing
- Controlled Exit. Cleaning tasks and temp files. Option to keep monitor mode if desired
- Multilanguage support and autodetect OS language feature (see [Supported Languages] section)
- Help hints in every zone/menu for easy use
- Auto-update. Script checks for newer version if possible

---

### Requirements

Bash **4.2** or later.

Compatible with any Linux distribution that has installed the tools needed. The script checks for them at the beginning.

> `airgeddon` is already included in some Linux distributions and repositories
> - [Wifislax] 4.12, 64-1.0 or higher
> - [BlackArch] 2017.01.28 or later
> - [ArchStrike] repository

<!-- Distribution compatibility should be written here -->
<details open>
	<summary><strong>Tested on these compatible Linux distributions</strong></summary>
	<ul>
		<em>
			<li>Kali 2.0, 2016.1, 2016.2 and arm versions (Raspberry Pi)</li>
			<li>Wifislax 4.11.1, 4.12 and 64-1.0</li>
			<li>Backbox 4.5.1 and 4.6</li>
			<li>Parrot 2.2.1 to 3.4.1 and arm versions (Raspberry Pi)</li>
			<li>BlackArch 2016.01.10 to 2017.01.28</li>
			<li>Cyborg Hawk 1.1</li>
			<li>Debian 7 (Wheezy) and 8 (Jessie)</li>
			<li>Ubuntu/Xubuntu 15.10, 16.04 and 16.04.1</li>
			<li>OpenSUSE Leap 42.1 and 42.2</li>
			<li>CentOS 6 and 7</li>
			<li>Gentoo 20160514 and 20160704</li>
			<li>Fedora 24</li>
			<li>Red Hat 7 (Maipo)</li>
			<li>Arch 4.6.2-1 to 4.10.4-1</li>
			<li>Raspbian 7 (Wheezy) and 8 (Jessie) (Raspberry Pi)</li>
			<li>OpenMandriva LX3</li>
		</em>
	</ul>
</details>

<!-- HTML entities here: http://www.amp-what.com/unicode/search/%2F%26%5Cw%2F -->
#### Essential tools &#8592; The script does not work if you don't have installed all of them

 Command     | Possible package name | &#8901; | Command     | Possible package name
:------------|:----------------------|:-------:|:------------|:----------------------
 ifconfig    | net-tools             | &#8901; | iwconfig    | wireless-tools        
 iw          | iw                    | &#8901; | awk         | awk \| gawk           
 airmon-ng   | aircrack-ng           | &#8901; | airodump-ng | aircrack-ng           
 aircrack-ng | aircrack-ng           | &#8901; | xterm       | xterm                 

#### Optional tools &#8592; Not necessary to work, only needed for some features

 Command     | Possible package name    | &#8901; | Command  | Possible package name                                
:------------|:-------------------------|:-------:|:---------|:-----------------------------------------------------
 wpaclean    | aircrack-ng              | &#8901; | ettercap | ettercap \| ettercap-text-only \| ettercap-graphical
 crunch      | crunch                   | &#8901; | etterlog | ettercap \| ettercap-text-only \| ettercap-graphical
 aireplay-ng | aircrack-ng              | &#8901; | sslstrip | sslstrip                                             
 mdk3        | mdk3                     | &#8901; | dhcpd    | isc-dhcp-server \| dhcp-server \| dhcp               
 hashcat     | hashcat                  | &#8901; | dnsspoof | dsniff                                               
 hostapd     | hostapd                  | &#8901; | wash     | reaver                                               
 lighttpd    | lighttpd                 | &#8901; | reaver   | reaver                                               
 iptables    | iptables                 | &#8901; | bully    | bully                                                
 bettercap   | bettercap                | &#8901; | pixiewps | pixiewps                                             
 beef        | beef-xss \| beef-project | &#8901; | unbuffer | expect \| expect-dev                                 

##### Important tips about BeEF

 - The right software you must install is **BeEF** (Browser Exploitation Framework). Be careful, do not mistake it with **beef** (Flexible Brainfuck Interpreter). This package has the same name and executable file name on some distributions and can lead into confusion. Anyway, `airgeddon` is able to detect the issue and display a warning if needed. Here is a link to the right [BeEF installation's page].
 - If you are using a distribution which already has BeEF installed like Kali, BlackArch or Wifislax, there will be no problems. If you have manually installed BeEF, `airgeddon` is able to manage the integration asking for the path where it's installed, even modifying its own code in order to make updates-proof persistent changes.

##### Important tips about hashcat

`hashcat` is used to perform various attacks against captured files using the **CPU**.
In order to execute `hashcat`, you need to install an **OpenCL** runtime compatible with your hardware.

#### Update tools &#8592; Not necessary to work, only used for auto-update

 Command | Possible package name
:--------|:----------------------
 curl    | curl                  

#### Internal tools &#8592; These are internally checked. Not necessary to work, good to have

 Command  | Possible package name                  
:---------|:---------------------------------------
 xdpyinfo | x11-utils \| xdpyinfo \| xorg-xdpyinfo
 ethtool  | ethtool                                
 lspci    | pciutils                               
 rfkill   | rfkill                                 

It is highly recommended to have the internal tools installed. They improve functionality and performance. For example, `xdpyinfo` allows the script to detect the display resolution in order to print on windows in a better way (size and position).

Of course, the script also uses many standard basic tools that are supposed to be included in any Linux distribution, so they are not checked (cp, rm, grep, pgrep, egrep, md5sum, uname, echo, hash, cat, sed, etc.).

A command could be included in different packages, depending on the distribution.

---

### Usage

It is essential to run this script as **root**, otherwise `airgeddon` won't work properly.

<details open>
	<summary><strong>Getting Started</strong></summary>
	<ul>
		<li>Clone the repository</li>
		<ul>
			<li><code>git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git</code></li>
		</ul>
		<li>Go to the newly created directory</li>
		<ul>
			<li><code>cd airgeddon</code></li>
		</ul>
		<li>Run it (remove <strong>sudo</strong> if you already have root permissions)</li>
		<ul>
			<li><code>sudo bash airgeddon.sh</code></li>
		</ul>
	</ul>
</details>

`airgeddon` should be launched with **bash** `bash /path/to/airgeddon.sh` and not with `sh` or any other kind of shell. <br/>

If you launch the script using another shell, there will be *Syntax errors* and faulty results.
Even with no initial errors, they will appear later. Always launch with **bash**!

---

### Supported Languages

![English][English] English <br/>
![Spanish][Spanish] Spanish <br/>
![French][French] French <br/>
![Catalan][Catalan] Catalan <br/>
![Portuguese][Portuguese] Portuguese <br/>
![Russian][Russian] Russian <br/>
![Greek][Greek] Greek <br/>

---

### Known Incompatibilities

- Incompatible with Mac OSX at the moment
 - *Bash version* &#8592; it can be avoided by upgrading it using `brew` or whatever, this is not the real problem :smile:
 - *Aircrack suite* &#8592; this suite does not support `airodump` and `aireplay` for OSX
 - *Wireless tools* &#8592; `iwconfig` does not exist in OSX, so `airport` command cannot be used. It generates different outputs
- Incompatible with OpenBSD and FreeBSD. They are Unix systems but they have some differences with Linux
 - *Bash* &#8592; They have no bash. It can be installed, this is not the real problem again :sweat_smile:
 - *Wireless tools* &#8592; `iwconfig` does not exist in these systems, they use `ifconfig` instead and it generates different outputs

---

### Contributing

- Translations into other languages
- More distribution support compatibility
- New features
- More WPS pins for the database
- Testing and feedback

Read the [Contributing File] for more details on the process of project collaborating and on our code of conduct.

---

### Changelog

Read the [Changelog File] to review changes.

---

### Disclaimer & License

<a href="LICENSE.md"><img src="http://gplv3.fsf.org/gplv3-127x51.png" align="left" hspace="10" vspace="6"></a>

This script must be used for educational purposes and penetration testing only. <br/>
Use it on your own networks or with the permission of the network's owner only.<br/>
`airgeddon` staff is not responsible of its use in any case.

---

### Acknowledgments
<!-- Links are missing, should be replaced -->

[Kcdtv] for French translations, beta testing, suggestions about new features and support received since the beginning, <br/>
**USUARIONUEVO** for helping me to improve the script, suggestions about new features and for the support received, <br/>
**El padrino** and [cLn] for Catalan translations, <br/>
[Luan] for Portuguese translations, <br/>
[MiAl] for Russian translations, <br/>
[xtonousou] for Greek translations, beta testing, suggestions, the help received fixing code warnings and other stuff, <br/>
[OscarAkaElvis] for allowing me to own his body when I visit the earth.

#### Hat tip to

- The "Spanish pentesting crew"
- The [Wifislax] staff
- The [BlackArch] community
- The forum people of [Seguridadwireless.net], [Wifi-libre.com] and [Lampiweb.com]
- The [Hackware.ru] admins
- All the people who helped building the online PIN database for WPS
- Dominique Bongard for bringing to us the Pixie Dust attacks
- Zhao Chunsheng and Stefan Viehböck for their wonderful algorithms
- All the developers who made and designed the third-party tools that `airgeddon` uses

#### Inspiration
<!-- Links are missing, should be replaced -->

- [vk496] &#8594; Linset
- MI1 &#8594; Airstorm
- [MatToufoutu] &#8594; Ap-fucker
- Coeman76 &#8594; Handshaker
- Goyfilms &#8594; Goyscript
- [Kcdtv] &#8594; WPSPin

<!-- Anchors -->
[Requirements]: #requirements
[Supported Languages]: #supported-languages
<!-- Links To Images -->
[Banner]: /imgs/banners/airgeddon_banner.png "We will conquer the earth!!"
[English]: /imgs/flags/us.png "English"
[Spanish]: /imgs/flags/es.png "Spanish"
[French]: /imgs/flags/fr.png "French"
[Catalan]: /imgs/flags/cat.png "Catalan"
[Portuguese]: /imgs/flags/pt.png "Portuguese"
[Russian]: /imgs/flags/ru.png "Russian"
[Greek]: /imgs/flags/gr.png "Greek"
<!-- Links To MDs -->
[Changelog File]: CHANGELOG.md
[Contributing File]: CONTRIBUTING.md
[License File]: LICENSE.md
<!-- URLs -->
[Wifislax]: http://www.wifislax.com
[BlackArch]: https://blackarch.org
[ArchStrike]: https://archstrike.org/wiki
[BeEF installation's page]: https://github.com/beefproject/beef/wiki/Installation
[Seguridadwireless.net]: http://foro.seguridadwireless.net
[Wifi-libre.com]: https://www.wifi-libre.com
[Lampiweb.com]: http://lampiweb.com/foro
[Hackware.ru]: https://hackware.ru
<!-- Github URLs -->
[vk496]: https://github.com/vk496
[MatToufoutu]: https://github.com/mattoufoutu
[Kcdtv]: https://github.com/kcdtv
[cLn]: https://github.com/cLn73
[Luan]: https://github.com/Luan7805
[MiAl]: https://github.com/Mi-Al
[xtonousou]: https://github.com/xtonousou
[OscarAkaElvis]: https://github.com/OscarAkaElvis
<!-- Badges URLs -->
[Version-shield]: https://img.shields.io/badge/version-6.11-blue.svg?style=flat-square&colorA=273133&colorB=0093ee "Latest version"
[Bash4.2-shield]: https://img.shields.io/badge/bash-4.2%2B-blue.svg?style=flat-square&colorA=273133&colorB=00db00 "Bash 4.2 or later"
[License-shield]: https://img.shields.io/badge/license-GPL%20v3%2B-blue.svg?style=flat-square&colorA=273133&colorB=bd0000 "GPL v3+"
[Paypal-shield]: https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square&colorA=002f86&colorB=009cde "Show me the money!"
[Bitcoin-shield]: https://img.shields.io/badge/donate-bitcoin-blue.svg?style=flat-square&colorA=273133&colorB=f7931a "Show me the money!"
