#airgeddon [![License](https://img.shields.io/badge/License-GPL%20v3%2B-blue.svg?style=flat-square)](LICENSE.md)
This is a multi-use bash script for Linux systems to audit wireless networks.<br/>
![We'll conquer the earth!!][banner]

#Features
- Interface mode switcher (Monitor-Managed) keeping selection even on interface name changing.
- DoS over wireless networks using different methods.
- Assisted Handshake file capturing.
- Cleaning and optimizing Handshake captured files.
- Offline password decrypting on WPA/WPA2 captured files (dictionary, bruteforce and rule based).
- Evil Twin attacks (Rogue AP):
  - Only Rogue/Fake AP version to sniff using external sniffer (Hostapd + DHCP + DoS).
  - Simple integrated sniffing (Hostapd + DHCP + DoS + ettercap).
  - Integrated sniffing, sslstrip (Hostapd + DHCP + DoS + Ettercap + Sslstrip).
  - Integrated sniffing, sslstrip2 and BeEF browser exploitation framework (Hostapd + DHCP + DoS + Bettercap + BeEF).
  - Captive portal with "DNS blackhole" to capture wifi passwords (Hostapd + DHCP + DoS + Dnsspoff + Lighttpd).
- WPS features:
  - WPS scanning (wash). Self parameterization to avoid "bad fcs" problem.
  - Custom PIN association (bully and reaver).
  - Pixie Dust attacks (bully and reaver).
  - Bruteforce PIN attacks (bully and reaver).
  - Parameterizable timeouts.
  - Known WPS PINs attack (bully and reaver), based on online PIN database with auto-update.
  - Integration of the most common PIN generation algorithms.
- Compatibility with many Linux distros (see requirements section).
- Easy targeting and selection in every section.
- Drag and drop files on console window for entering file paths.
- Dynamic screen resolution detection and windows auto-sizing for optimal viewing.
- Controlled Exit. Cleaning tasks and temp files. Option to keep monitor mode if desired.
- Multilanguage support and autodetect OS language feature (see supported languages section).
- Help hints in every zone/menu for easy use.
- Auto-update. Script checks for newer version if possible.

#Requirements
Bash version 4.2 or later needed.

Compatibility with any Linux which have installed the tools what script needs. The script checks for them at the beginning.

Tested on these compatible Linux distros:<br/>
*-Kali 2.0, 2016.1, 2016.2 and arm versions (Raspberry Pi)*<br/>
*-Wifislax 4.11.1, 4.12 and 64-1.0*<br/>
*-Backbox 4.5.1 and 4.6*<br/>
*-Parrot 2.2.1 to 3.4.1 and arm versions (Raspberry Pi)*<br/>
*-BlackArch 2016.01.10 to 2017.01.28*<br/>
*-Cyborg Hawk 1.1*<br/>
*-Debian 7 (Wheezy) and 8 (Jessie)*<br/>
*-Ubuntu/Xubuntu 15.10, 16.04 and 16.04.1*<br/>
*-OpenSUSE Leap 42.1 and 42.2*<br/>
*-CentOS 6 and 7*<br/>
*-Gentoo 20160514 and 20160704*<br/>
*-Fedora 24*<br/>
*-Red Hat 7 (Maipo)*<br/>
*-Arch 4.6.2-1 to 4.8.13-1*<br/>
*-Raspbian 7 (Wheezy) and 8 (Jessie) (Raspberry Pi)*<br/>
*-OpenMandriva LX3*<br/>

airgeddon is already included in some Linux distros and repositories:
 - <a href="http://www.wifislax.com">Wifislax</a> 4.12, 64-1.0 or higher.
 - <a href="https://blackarch.org">BlackArch</a> 2017.01.28 or later.
 - <a href="https://archstrike.org/wiki">ArchStrike</a> repository.

We will enumerate the categories and tools. The command can be included in different packages depending of the distro.

**Essential tools**: <- *the script doesn't work if you don't have installed all of them*

| Command | Possible package name | // | Command | Possible package name |
| --- | --- | --- | --- | --- |
| ifconfig | net-tools | // | iwconfig | wireless-tools |
| iw | iw | // | awk | awk / gawk |
| airmon-ng | aircrack-ng | // | airodump-ng | aircrack-ng |
| aircrack-ng | aircrack-ng | // | xterm | xterm |

**Optional tools**: <- *not necessary to work, only needed for some features*

| Command | Possible package name | // | Command | Possible package name |
| --- | --- | --- | --- | --- |
| wpaclean |  aircrack-ng | // | ettercap |  ettercap / ettercap-text-only / ettercap-graphical |
| crunch |  crunch | // | etterlog |  ettercap / ettercap-text-only / ettercap-graphical |
| aireplay-ng |  aircrack-ng | // | sslstrip |  sslstrip |
| mdk3 |  mdk3 | // | dhcpd |  isc-dhcp-server / dhcp-server / dhcp |
| hashcat |  hashcat | // | dnsspoof |  dsniff |
| hostapd |  hostapd | // | wash |  reaver |
| lighttpd | lighttpd | // | reaver |  reaver |
| iptables |  iptables | // | bully |  bully |
| bettercap |  bettercap | // | pixiewps |  pixiewps |
| beef | beef-xss / beef-project | // | unbuffer | expect / expect-dev |

**Important tips about BeEF**
 - The beef software you must install is BeEF (Browser Exploitation Framework). Be careful, don't confuse with beef (Flexible Brainfuck interpreter). This package has on some distros the same name, same executable file name and can lead into confusion. Anyway, airgeddon is able to detect this and show you a warning if needed. Here is a link to the right BeEF installation's page: [BeEF Installation](https://github.com/beefproject/beef/wiki/Installation).
 - If you use a distro which already comes with BeEF installed like Kali, BlackArch or Wifislax, you will have no problems. If you install BeEF manually, airgeddon is able to manage the integration asking you for the path where it's installed, even modifying its own code in order to make updates-proof persistent changes.

**Update tools**: <- *not necessary to work, only used for auto-update*

| Command | Possible package name |
| --- | --- |
| curl | curl |

**Internal tools**: <- *these are internally checked. Not necessary to work, good to have*

| Command | Possible package name |
| --- | --- |
| xdpyinfo | x11-utils / xdpyinfo / xorg-xdpyinfo |
| ethtool | ethtool |
| lspci | pciutils |
| rfkill | rfkill |
Is highly recommended to have the internal tools installed. They improve functionality and performance. For example, xdpyinfo allow the script to detect the desktop resolution in order to print windows in a better way (size and position).

Of course, the script also uses many standard basic commands that are understood to come with any Linux distro, so they are not checked (cp, rm, grep, pgrep, egrep, md5sum, uname, echo, hash, cat, sed, etc.).

#Known incompatibilities
Impossible compatibility for Mac OSX at the moment. Some reasons:<br/>
*-Bash version* <- it can be avoided upgrading to 4 or later, this is not the real problem :smile:<br/>
*-Aircrack suite* <- this suite for OSX doesn't support airodump and aireplay<br/>
*-Wireless tools* <- iwconfig doesn't exists for OSX, and airport command can't be used. It generates very different outputs

Incompatible with OpenBSD and FreeBSD. They are Unix systems but they have some differences with Linux:<br/>
*-Bash* <- They have no bash. It can be installed, this is not the real problem again :sweat_smile:<br/>
*-Wireless tools* <- iwconfig doesn't exists for these systems, they use ifconfig instead and it generates very different outputs

#Disclaimer & License
This script must be used only for educational purposes and pentesting.<br/>
Use it only on your own networks or with the network's owner appropriate permission during a penstest.<br/>
airgeddon staff is not responsible of its use in any case.<br/>
This script is under GPLv3 (or later) [License](LICENSE.md).

#Use
Must be launched only using bash (not sh). Example `bash /path/to/airgeddon.sh`<br/>
If you launch the script using sh and a *"Syntax error"* appears, launch it with **bash instead of sh**. Even with no initial error, maybe you'll have it later. Use bash always!

#Supported Languages
![English][english] English<br/>
![Spanish][spanish] Spanish<br/>
![French][french] French<br/>
![Catalan][catalan] Catalan<br/>
![Portuguese][portuguese] Portuguese<br/>
![Russian][russian] Russian<br/>
![Greek][greek] Greek

#Project Collaboration
You can join the project:

 - Translations to other languages are welcome.
 - More distros support compatibility.
 - New features.
 - More WPS pins for the database.
 - Testing and feedback is needed too.

*For collaborating translators:*<br/>
You can take the strings to translate from the code. All the stuff to translate is in "language_strings" function. Ask by mail if you have any doubt. You'll be informed about you how to proceed, you can be added as a collaborator on the project.

*For collaborating developers:*<br/>
Debug mode was implemented for faster development skipping intro and initial checks. Use it setting var *"debug_mode"* to 1 or to 2 for extra-verbosity<br/>
Please, respect the tab indentation, code style and the UTF-8 files format only using at the end of the lines LF (not CRLF).<br/>
Direct push on master is not allowed, and pull requests require revision and approvement.<br/>
airgeddon code is 100% clean of warnings. Use [Shellcheck](https://github.com/koalaman/shellcheck) to search for errors and warnings on code. <- Thanks xtonousou for the tip :wink:

*For beta testers:*<br/>
You can download the master version or the beta testing version from the development branch called `dev`. Sometimes there are other temporary branches for specific features that can be tested too. 

*For WPS PIN database collaborators:*<br/>
The pins must be strictly ordered by key in the array. Keys are the first 6 bssid digits. After updating the "known_pins.db" file, you must update too "pindb_checksum.txt" with the calculated checksum of the database file. This checksum is calculated using md5sum tool.

#Changelog
See [Changelog](CHANGELOG.md) file to review changes.

#Credits & Special Thanks
Thank you to:

**Kcdtv** for French translations, beta testing, suggestions about new features and support received since the beginning.<br/>
**USUARIONUEVO** for helping me to improve the script, suggestions about new features and for the support received.<br/>
**El padrino** and **cLn** for Catalan translations.<br/>
**Luan** for Portuguese translations.<br/>
**MiAl** for Russian translations.<br/>
**xtonousou** for Greek translations, beta testing, suggestions, the help received fixing code warnings and other stuff.

Thanks to the "Spanish pentesting crew", the <a href="http://www.wifislax.com/">Wifislax</a> staff, the <a href="https://blackarch.org">BlackArch</a> community, the <a href="http://foro.seguridadwireless.net">Seguridadwireless.net</a>, <a href="https://www.wifi-libre.com">Wifi-libre.com</a> and <a href="http://lampiweb.com/foro/">Lampiweb.com</a> forum people that helped me.<br/>
Thanks to the <a href="https://hackware.ru">Hackware.ru</a> admins. Thanks to all the people who helped me building the online PIN database for WPS. Thank you to Dominique Bongard for bringing to us Pixie Dust attacks. Thanks to Zhao Chunsheng and Stefan Viehböck for their wonderful algorithms.<br/>
I want to thank you too, to all developers who made and designed the third-party tools airgeddon uses.

Thank you too to other authors who inspired me with their scripts:<br/>
*vk496 -> Linset*<br/>
*MI1 -> Airstorm*<br/>
*MatToufoutu -> Ap-fucker*<br/>
*Coeman76 -> Handshaker*<br/>
*Goyfilms -> Goyscript*<br/>
*Kcdtv -> WPSPin*

#Donate
If you enjoyed the script, feel free to give a donation. Invite me to a coffee through Paypal or send me a fraction of a bitcoin:<br/>
Paypal: *v1s1t0r.1s.h3r3&#64;gmail.com*<br/>
Bitcoin: *1AKnTXbomtwUzrm81FRzi5acSSXxGteGTH*

[![paypal][paypal]](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7ELM486P7XKKG)
&nbsp;
[![bitcoin][bitcoin]](https://blockchain.info/address/1AKnTXbomtwUzrm81FRzi5acSSXxGteGTH)

[banner]: /imgs/airgeddon_banner.png "We'll conquer the earth!!"
[paypal]: /imgs/paypal_donate.png "Show me the money!"
[bitcoin]: /imgs/bitcoin_donate.png "Show me the money!"
[english]: /imgs/us.png "English"
[spanish]: /imgs/es.png "Spanish"
[french]: /imgs/fr.png "French"
[catalan]: /imgs/cat.png "Catalan"
[portuguese]: /imgs/pt.png "Portuguese"
[russian]: /imgs/ru.png "Russian"
[greek]: /imgs/gr.png "Greek"
