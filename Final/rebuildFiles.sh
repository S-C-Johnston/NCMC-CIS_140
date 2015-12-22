#!/bin/bash -x

declare -r PATIENT_DATA=PatientsRecord.csv
declare -r PATIENT_BACKUP=PatientsRecord.csv.bak
declare -r DEPARTMENT_CODES=DepartmentCodes.csv
declare -r DEPARTMENT_BACKUP=DepartmentCodes.csv.bak

if [[ -e $PATIENT_DATA ]]
	then
		chmod 755 $PATIENT_DATA 
		rm $PATIENT_DATA
fi 

if [[ -e $DEPARTMENT_CODES ]]
	then
		chmod 755 $DEPARTMENT_CODES
		rm $DEPARTMENT_CODES
fi 

cp $PATIENT_BACKUP $PATIENT_DATA
chmod 755 $PATIENT_DATA 
cp $DEPARTMENT_BACKUP $DEPARTMENT_CODES
chmod 755 $DEPARTMENT_CODES 
