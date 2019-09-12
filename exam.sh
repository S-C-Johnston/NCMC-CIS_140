#!/bin/bash
##Assignment: Midterm Exam
##Author: Stewart Johnston <johnstons1@student.ncmich.edu>
##Version: 1.0
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
	populateProfileAdditions
	echoProfileAdditions
	appendProfile
	grepToken
	deleteDeleteMeFile
}

function checkHomeDir () {
	local -i recursionCounter=$1
	echo ${recursionCounter}
	: ${recursionCounter:=0}
	echo ${recursionCounter}
	local homeDir
	read -p "What is your home directory: " homeDir
	if [[ "$homeDir" == $(basename "$HOME") ]]
		then
			echo -e "Correct!\n"
	elif [[  "$homeDir" != $(basename "$HOME") && $recursionCounter -lt $MAX_RECURSION ]]
		then
			echo ${recursionCounter}
			(( recursionCounter++ ))
			echo ${recursionCounter}
			checkHomeDir ${recursionCounter}
		else
			echo -e "Too many bad tries, exiting.";	exit
	fi
}

function describeListBuiltin () {
	echo "Will be opening a link to the ls man page. Navigate with arrow keys, follow links with enter, exit with q."
	sleep 5
	links http://linux.die.net/man/1/ls 
}

function sayRelAbsPathnames () {
cat <<-EOF
	Description of relative and absolute pathnames:
	
	Relative and absolute pathnames are different.
	An absolute pathname is found from the root directoy (/),
	a relative pathname is found relative to the current working directory.
	
	Absolute pathnames start with '/', to indicate the root directory.
	Assuming the item exists, the path will always be legal.
	An example of an absolute pathname is '/home/' or '/usr/bin'

	Relative pathnames start with some item in the current working directory.
	This includes hidden items, like '.', which is a reference to the directory itself, and '..', which is a reference to the parent directory.
	Some examples of relative pathnames are:
	'foo' (a file, foo), 
	'bar/' (a directory, bar),
	'./here' (explicitly calling a file, here),
	'../' (the parent directory or its contents)
	 or '../up/' (a sister directory located in the parent directory)
EOF
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
