#airgeddon
This is a Multi-use bash script to audit wireless networks.<br>

#Requirements
We say a distro is a 100% compatible Linux distro if it has installed by default all the tools script needs to work.<br>
Tested on these 100% compatible Linux distros:<br>
-Kali. Tested on 2.0 and 2016.1<br>
-Wifislax. Tested on 4.11.1<br>
-Backbox. Tested on 4.5.1<br>
-Parrot. Tested on 2.2.1<br>
-Blackarch 2016.01.10<br>
<br>
Anyway, can be used with any Linux distro if you have installed the tools what script needs. The script checks for them at the beginning:<br>
iwconfig airmon-ng airodump-ng aireplay-ng mdk3 awk wpaclean<br>
<br>
Other (non 100% compatible) distros tested successfully after installing missing tools:<br>
-Debian 8 (Jessie)<br>
-Ubuntu 15.10<br>

#Disclaimer
This script must be used only for educational purposes and Pen testing.<br>
Use it only on your own networks.<br>
We are not responsible of its use.<br>
This script is under GPLv2 (or later) License.<br>

#Use
Under some distros like Kali Linux must be called only using bash (no sh). Example "bash /path/airgeddon.sh"<br>
Under Wifislax and others, it can be called using bash or sh. Example "sh /path/airgeddon.sh"<br>
If you call the script using sh and a "Syntax error" appears, use it with bash instead of sh.<br>

#Supported Languages
English, Spanish, French and Catalan.<br>

#Project Collaboration
You can join the project:<br>
-Translations to other languages are welcome.<br>
-More distros support compatibility.<br>
-New features.<br>
-Testing and feedback is needed too.<br>

#Changelog
See <a href="https://github.com/v1s1t0r1sh3r3/airgeddon/blob/master/changelog.txt">Changelog</a> file to review changes.<br>