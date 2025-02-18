#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-2.0
# 
# Author: Ingo Reitz <9l@9lo.re>
# Contributing:	famfo (famfo#0227)
# Testing:		G4rrus#3755 
# 
# Version 1v18-7
_SCRIPTVER="1v18-7"

#####################################################################################
## Adjust below or use the external config file
#####################################################################################

## MAKE SURE YOU CHOOSE THE SAME PROTON VERSION AS FOR ARMA IN STEAM!!!
# Set this to the Proton Version you are using with Arma!
# Available versions: "8.0", "7.0", "6.3", "5.13", "5.0", "4.11", "4.2", "3.16", "3.7", "Proton Experimental", "Experimental"
# Defaults to: 8.0
PROTON_OFFICIAL_VERSION=""

## Path to Arma's compatdata (wineprefix)
# Leave empty if Arma is installed in Steams default library
COMPAT_DATA_PATH=""

# If you have proton in a different steam library, then put the path to its steamapps folder here
# Leave empty if Proton is installed in Steams default library
STEAM_LIBRARY_PATH=""

# If you are using a custom proton build, then put its folder name (from inside compatibilitytools.d) here
# Leave empty if proton 
PROTON_CUSTOM_VERSION=""

## Esync/Fsync
# IMPORTANT: Make sure that Esync and Fsync settings MATCH for both Arma and TeamSpeak(here)
# If you havent explicitly turned it off for Arma, leave it on here!
ESYNC=true
FSYNC=true

###########################################################################
##        DO NOT EDIT BELOW!
###########################################################################

# Exit if run with different shell
if  [ -n "$_" ]; then
	echo "FATAL: Do not run the script with sh or any other shell!"
	echo "Shell: $_"
	exit
fi

# Check if $XDG_CONFIG_HOME exists, then read external config if it exists
if [[ -n "$XDG_CONFIG_HOME" ]]; then
	USERCONFIG="$XDG_CONFIG_HOME/arma3helper"
else
	USERCONFIG="$HOME/.config/arma3helper"
fi
if [[ -e "$USERCONFIG/config" ]]; then
	echo "Config file $USERCONFIG/config found. Using its values."
	# shellcheck source=/dev/null
	source "$USERCONFIG/config"
fi

## FUNCTIONS
# Installed check ($1 = path; $2 = name in error msg)
_checkinstall() {
	if [[ ! $(command -v "$1") ]]; then
		echo -e "\e[31mError\e[0m: $1 is not installed!"
		exit 1
	fi
}
# Installed check by path ($1 = path; $2 = name in error msg)
_checkpath() {
	if [[ ! -x "$1" ]]; then
		echo -e "\e[31mError\e[0m: $2 is not installed!"
		exit 1
	fi
}
# Confirmation prompt
_confirmation() {
	read -p "$1 (y/n) " -n 1 -r
	echo 
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
    	exit 1
	fi
}
# Get the command to modify the protonprefix
_get_wrappercmd() {
	no_winetricks=$(_checkinstall "winetricks")
	no_protontricks=$(_checkinstall "protontricks")
	wrappercmd=""

	if [[ $no_winetricks && $no_protontricks ]]; then
		echo -e "$no_winetricks\n$no_protontricks"
		exit 1
	fi
	if [[ $no_winetricks ]]; then
		echo "protontricks 107410"
	else
		echo "winetricks"
	fi
}

## ENVIROMENTAL VARAIBLES
if [[ -z "$COMPAT_DATA_PATH" ]]; then
	COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata/107410"
fi
export STEAM_COMPAT_DATA_PATH="$COMPAT_DATA_PATH"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
export SteamAppId="107410"
export SteamGameId="107410"
if [[ $ESYNC == false ]]; then
	export PROTON_NO_ESYNC="1"
fi
if [[ $FSYNC == false ]]; then
	export PROTON_NO_FSYNC="1"
fi
TSPATH="$COMPAT_DATA_PATH/pfx/drive_c/Program Files/TeamSpeak 3 Client/ts3client_win64.exe"

# Handle Proton Experimental or empty Version string
if [[ $PROTON_OFFICIAL_VERSION == "Proton Experimental" || $PROTON_OFFICIAL_VERSION == "Experimental" ]]; then
	PROTON_OFFICIAL_VERSION="- Experimental"
	IS_EXPERIMENTAL=true
elif [[ -z $PROTON_OFFICIAL_VERSION ]]; then
	PROTON_OFFICIAL_VERSION="8.0"
fi

# Executable paths
if [[ -n "$PROTON_CUSTOM_VERSION" ]]; then
	PROTONEXEC="$HOME/.steam/steam/compatibilitytools.d/$PROTON_CUSTOM_VERSION/proton"
else
	if [[ -n "$STEAM_LIBRARY_PATH" ]]; then
		PROTONEXEC="$STEAM_LIBRARY_PATH/common/Proton $PROTON_OFFICIAL_VERSION/proton"
	else
		PROTONEXEC="$HOME/.steam/steam/steamapps/common/Proton $PROTON_OFFICIAL_VERSION/proton"
	fi
fi

# Start
if [[ -z $* ]]; then
	# Check if TS is installed
	_checkpath "$TSPATH" "TeamSpeak"
	if ! pgrep -i arma3.exe && ! pgrep -i arma3_x64.exe && ! pgrep -i Arma3BattleEye.exe; then
		echo -e "\e[31mArma should be started first!\e[0m \n"
		exit 1
	fi
	sh -c "'$PROTONEXEC' run '$TSPATH'"
# TS installer
elif [[ $1 == "install" ]]; then 
	echo "Trying to install Teamspeak with provided file"
	echo -e "\e[31mINSTALL TEAMSPEAK FOR ALL USERS AND LEAVE THE PATH DEFAULT!!!\e[0m \n"
	sleep 2
	if [[ -z $2 ]]; then
		echo "Error - no installer exe provided"
		exit 1
	fi
	sh -c "'$PROTONEXEC' run '$2'"
# Debug information
elif [[ $1 = "debug" ]]; then
	echo "DEBUGGING INFORMATION"
	echo
	echo "Script Version: $_SCRIPTVER"
	_UPVER=$(curl -s https://raw.githubusercontent.com/ninelore/armaonlinux/master/version)
	if [[ $_SCRIPTVER != "$_UPVER" ]]; then
		echo -e "\e[31mScript Version $_UPVER is available!\e[0m"
		echo "https://github.com/ninelore/armaonlinux"
	fi
	echo
	echo "Command Line:"
	echo "sh -c \"'$PROTONEXEC' run '$TSPATH'\""
	echo
	if [[ -n "$PROTON_CUSTOM_VERSION" ]]; then
		echo "Proton: custom $PROTON_CUSTOM_VERSION"
	elif [[ $IS_EXPERIMENTAL == true ]]; then
		echo "Proton: official Experimental"
	else
		echo "Proton: official $PROTON_OFFICIAL_VERSION"
	fi
	echo
	echo "Enviromental Variables"
	echo "STEAM_COMPAT_DATA_PATH: $STEAM_COMPAT_DATA_PATH"
	echo "SteamAppId/SteamGameId: $SteamAppId $SteamGameId"
	echo "ESync: $ESYNC"
	echo "FSync: $FSYNC"
# Winetricks wrapper for Arma's compatdata
elif [[ $1 = "winetricks" ]]; then
	echo "Executing winetricks inside Arma's compatdata prefix..."
	wrappercmd=$(_get_wrappercmd)
	echo "Using \"$wrappercmd\""
	export WINEPREFIX="$COMPAT_DATA_PATH/pfx"
	if [[ $2 = "Arma" ]]; then
		echo "Installing recommended features/DLLs for Arma"
		$wrappercmd d3dcompiler_43 d3dx10_43 d3dx11_43 xact_x64
		echo "done"
	else
		echo "Arguments: ${*:2}"
		$wrappercmd "${*:2}"
	fi
elif [[ $1 = "winecfg" ]]; then
	echo "Starting winecfg via winetricks for Arma's compatdata..."
	wrappercmd=$(_get_wrappercmd)
	echo "Running $wrappercmd winecfg"
	export WINEPREFIX="$COMPAT_DATA_PATH/pfx"
	$wrappercmd winecfg
# Updater
elif [[ $1 = "update" ]]; then
	echo -e "\e[31mUpdating the script will reset your changes in the script options!\e[0m"
	echo "However, it will not reset your settings in ~/.arma3helper."
	_confirmation "Are you sure?"
	curl -o "$0" https://raw.githubusercontent.com/ninelore/armaonlinux/master/Arma3Helper.sh
	echo "The Script was updated!"
# create extermal config
elif [[ $1 = "createconfig" ]]; then
	if [[ -e "$USERCONFIG/config" ]]; then
		echo -e "\e[31mA config file already exists!\e[0m"
		_confirmation "Do you want to override it?"
	else
		mkdir -p "$USERCONFIG"
	fi
	curl -o "$USERCONFIG/config" https://raw.githubusercontent.com/ninelore/armaonlinux/master/config
else
	echo "SCRIPT USAGE"
	echo
	echo -e "\e[31mDouble check the script settings before reporting any problems!\e[0m"
	echo
	echo "./Arma3Helper.sh                                      - Start Teamspeak"
	echo
	echo "./Arma3Helper.sh install [installer exe path]         - Install Teamspeak"
	echo
	echo "./Arma3Helper.sh winetricks [winetricks arguments]    - Run a winetricks command inside the Arma prefix"
	echo
	echo "./Arma3Helper.sh winetricks Arma                      - Install recommended Features/DLLs for Arma via winetricks [As per Guide Chapter 5.1]"
	echo
	echo "./Arma3Helper.sh winecfg                              - Run winecfg for the Arma prefix"
	echo
	echo "./Arma3Helper.sh debug                                - Print Debugging Information"
	echo 
	echo "./Arma3Helper.sh update                               - Update the script from github master"
	echo
	echo "./Arma3Helper.sh createconfig                         - Creates an external config file in your ~/.config/ directory"
fi
