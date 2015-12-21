#!/bin/bash

declare -r TRUE=1
declare -r DEBUG=0

declare -r PATIENT_DATA="PatientsRecord.csv"
declare -r DEPARTMENT_DATA="DepartmentCodes.csv"
declare workingFile=/dev/null

function debugger () {
	if [[ $@ =~ "ARGS" && $DEBUG == $TRUE ]]
		then
			echo -e "${@:2}"
	fi
}

function main () {
	removeFiles
	rebuildFile $PATIENT_DATA
	rebuildFile $DEPARTMENT_DATA
}

function removeFiles () {
	if [[ -e $PATIENT_DATA ]]
		then
			rm $PATIENT_DATA
	fi
	if [[ -e $DEPARTMENT_DATA ]]
		then
			rm $DEPARTMENT_DATA
	fi
}

function rebuildFile () {
	if [[ $1 == $PATIENT_DATA ]]
		then
			setWorkingFile $PATIENT_DATA
			touch "$workingFile"
			echoToFile "Johnson,Bill,450,10000,555-11-2222"
			echoToFile "Sims,Tonya,380,25000,222-33-4444"
			echoToFile "Davis,Julie,680,2000,888-11-9999"
			echoToFile "Smith,John,450,2000,876-33-2211"
			echoToFile "Dalco,Tom,510,500,111-03-0023"
			echoToFile "Johnson,Bill,680,20000,555-11-2222"
			echoToFile "Sims,Tonya,380,25000,222-33-4444"
			echoToFile "Hernandez,James,680,2000,444-66-9999"
	elif [[ $1 == $DEPARTMENT_DATA ]]
		then
			setWorkingFile $DEPARTMENT_DATA
			touch "$workingFile"
			echoToFile "380,Oncology"
			echoToFile "450,ER"
			echoToFile "510,Orthopedics"
			echoToFile "680,Dialasys"
	fi
}

function echoToFile () {
	debugger ARGS $@
	echo -e "$@" >> $workingFile
}

function setWorkingFile () {
	debugger ARGS $@
	if [[ -n "$1" ]]
		then
			workingFile=$1
	else
		workingFile="/dev/null"
	fi
}

main
