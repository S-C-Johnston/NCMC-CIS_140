#!/bin/bash

##Author: Stewart Johnston johnstons1@ncmich.edu
##Assignment: Project 4, task 1
##Purpose: Demonstrate understanding of shell customiztion with bash.
##Version: 1.03.2

#ERR codes:
#1	You had one job. There is literally only one way to use this script. In
#	the words of Jim Carrey, "Stop breaking the law, asshole!"
#2	The username was invalid, because the user did not exist. Contact the
#	sysadmin, or maybe try ls with the home prefix.

declare -r NEW_USER=$1
declare -r DEBUG=0
if [[ $(uname) == "Linux" ]] #Quick-n-dirty OS detection, assuming broadly similar hierarchies across type.
	then 
		declare -r HOME_PREFIX="/home/"
elif [[ $(uname) == "Darwin" ]]
	then 
		declare -r HOME_PREFIX="/users/"
fi
declare -r USR_DIR="/$HOME_PREFIX/$NEW_USER/"
declare -r BASH_PROFILE="/$HOME_PREFIX/$NEW_USER/.bash_profile"

function debugMe () {
	declare -r SWITCH=$1
	if [[ $DEBUG == 1 && $SWITCH == ON ]]
		then set -x
	elif [[ $DEBUG == 1 && $SWITCH == OFF ]]
		then set +x
	fi
}

function main () {
	checkForArg
	initProfile
	populateProfile
}

function checkForArg () {
	if [[ -z "$NEW_USER" ]] #http://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
		then
			echo -n "Usage of script: Task_One.sh "
			tput smul
			echo "username"
			tput sgr0
			echo "The script will not work without this input."
			echo "err 1: There was no username argument, or the username arg was blank"
			sleep 1
			exit 1
	fi
}

function populateProfile () {
	if [[ $DEBUG == 1 ]]; then echoExportToProfile "This is a test." "\n" "So is this."; fi #Ugly one-liner debugger is ugly. Test post, please ignore.
	echoToProfile "tput bold" #What a fricken' confusing directive. I
# thought it was asking us to enable a terminal feature entirely. After screwing
# around with it for... longer than I'd like to admit, I finally assumed that it
# meant to make all text bold. Tput seems to be the most portable way of doing
# this. I learned a lot about tput and terminfo, though, so I've got that going
# for me, which is nice.
	echoToProfile "txtgrn='\e[0;32m' # Green" #https://wiki.archlinux.org/index.php/Color_Bash_Prompt
	echoToProfile "txtrst='\e[0m'    # Text Reset"
	echoExportToProfile 'PS1="$txtgrn\u \W $ $txtrst"'
	echoExportToProfile 'PATH=$PATH:.' #I don't advise this, for security reasons.
# But hey, the assignment asked for it.
# Also. Wasn't really sure what was meant by "ensure all programs etc can use the PATH.
# I am assuming it meant to export the variable, instead of just setting it.
	echoToProfile "alias dir='ls -l'"
	echoToProfile "alias cls='clear'"
	echoToProfile "w"
	echoToProfile "alias rm='rm -i'"
	echoToProfile "set -o noclobber"
}

function initProfile () {
	if ! [[ -d "$USR_DIR" ]]
		then
			echo "Username is not valid; no such user"
			echo "err 2: Invalid username"
			sleep 1
			exit 2
	fi

	if [[ -e \$$BASH_PROFILE ]]
		then
			echo "User's bash profile exists, no change."
	else
		touch $BASH_PROFILE
	fi 
}

function echoExportToProfile () {
	echo -e "export "$@"" >> $BASH_PROFILE
}

function echoToProfile () {
	echo -e "$@" >> $BASH_PROFILE
}

main 
