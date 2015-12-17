#!/bin/bash
##Assignment: Midterm Exam
##Author: Stewart Johnston
##Version:
##Purpose: Demonstrate understanding of shell and vim.

declare -ir YES=1
declare -ir MAX_RECURSION=10
declare -r DELETE_ME_FILE='DeLeTe.me'
declare -ir NUM_ADDITIONS=3
declare -r IFS_ORIG=$IFS

declare -a profileAdditions

function main () {
	checkHomeDir
	describeListBuiltin
	sayRelAbsPathnames
	makeDeleteMeFile
	populateDeleteMeFile
#	populateProfileAdditionsALT
	populateProfileAdditions
	echoProfileAdditions
	appendProfile
	grepToken
	deleteDeleteMeFile
}

function checkHomeDir () {
	declare recursionCounter=0
	declare homeDir
	read -p "What is your home directory: " homeDir
	if [[ "$homeDir" == "$HOME" ]]
		then
			echo -e "Correct!\n"
	elif  [[  "$homeDir" != "$HOME" && $recursionCounter < $MAX_RECURSION ]]
		then
			checkHomeDir
			(( recursionCounter++ ))
		else
			echo -e "Too many bad tries, exiting."			exit
	fi
}

function describeListBuiltin () {
	echo "Will be opening a link to the ls man page. Navigate with arrow keys, follow links with enter, exit with q."
	sleep 5
	links http://linux.die.net/man/1/ls 
}

function sayRelAbsPathnames () {
	echo "Describing relative and absolute pathnames."
	echo "Relative and absolute pathnames are different."
	echo "An absolute pathname is found from the root directoy,
a relative pathname is found relative to the current working directory."
	echo "Absolute pathnames start with '/', while relative pathnames start without a slash."
	echo "Relative pathnames can start with the CWD './', or the directory above it '../'"
	echo "An example of an absolute pathname is '/home/' or '/usr/bin'"
	echo "An example of a relative pathname is './here' or '../up/'" 
}

function makeDeleteMeFile () {
	touch $HOME/$DELETE_ME_FILE
}

function populateDeleteMeFile () {
	declare -a profile
	profile[0]="'umask 117'"
	profile[1]="'alias cls='clear''"
	profile[2]="'set -o noclobber'"
	
	cat /dev/null > $HOME/$DELETE_ME_FILE

	for (( i=0; $i < ${#profile[*]}; i++ ))
	do
		echo ${profile[$i]} >> $HOME/$DELETE_ME_FILE
	done
}

function echoProfileAdditions () {
	for (( i=0; $i < ${#profileAdditions[*]}; i++ ))
	do
		echo ${profileAdditions[$i]}
	done
}

function populateProfileAdditionsALT () {
	#5 <> $HOME/$DELETE_ME_FILE
	IFS='<newline>'
	read -a profileAdditions -d ^D < "$HOME/$DELETE_ME_FILE" #-u 5
	IFS=$IFS_ORIG
}

function populateProfileAdditions () {
	#IFS='<newline>'
	declare -i counter
	while read 
	do
		profileAdditions[$i]=$REPLY
	#	echo ${profileAdditions[$i]}
		(( counter++ ))
	done < "$HOME/$DELETE_ME_FILE"
	#IFS=$IFS_ORIG
}

function appendProfile () {
	for (( i=0; $i < ${#profileAdditions[*]}; i++ ))
	do
		echo ${profileAdditions[$i]} >> $HOME/.bash_profile
	done
}

function grepToken () {
	echo "Printing files with lines matching 'clob'"
	declare -r TOKEN='clob'
	grep -r "$TOKEN" $HOME
}

function deleteDeleteMeFile () {
	rm $HOME/$DELETE_ME_FILE
}

main
