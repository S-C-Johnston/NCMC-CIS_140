#!/usr/bin/perl

##Author: Stewart Johnston
##Assignment: Quiz 2 -- Perl Basics
##Purpose: Gather employee information and output total years of service of employees in same department
##Version: .8

use 5.14.2;
#use warnings;
use strict;

use constant TRUE => 1;
use constant ABJECT_FAILURE => -1;

my $continueInt;
#my $RECORDS_IO; Unimplemented, not strictly called for in doc, works from current session only.

my @employeesRecord=();
my @currentRecord;
use constant {
IDX_EMPLOYEE_ID => 0,
IDX_EMPLOYEE_DEPT => 1,
IDX_EMPLOYEE_YRS => 2,
};
use constant FIELDS => 3;

use constant {
IDENT_NUM_MAX => 5000,
DEPARTMENT_MAX => 10,
YEARS_MAX => 40,
};

sub main {
	do {
	clearCurrentRecord();
	my $breakTest=getCurrentRecord();
	if ($breakTest == ABJECT_FAILURE) {BREAK_TEST: {
		last;
	}}
	writeCurrentToEmployeesRecord(); 
	fetchDeptTotalYears();
	print "\nRecord modification complete.";
	setContinueInt();
	} while ($continueInt == TRUE);
	
	print "Process complete, exiting.";
	sleep 1;
}

main();

=comment
sub setContinueInt {
	while ($continueInt ne "y" || $continueInt ne "n" || $continueInt != TRUE || $continueInt != 0) {
		print "\nDo you want to continue (y or n): ";
		chomp ($continueInt = <STDIN>);
		$continueInt = substr($continueInt, 0, 1);
		$continueInt =~ (tr/[:upper:]/[:lower:]/);
		if ($continueInt ne "y" || $continueInt ne "n" || $continueInt != TRUE || $continueInt != 0) {
			print "Input rejected. Please try again.";

#system("clear");
		}
	}

	if ($continueInt eq "y") {
		$continueInt =~ (s/y/TRUE/);
	}
	else {
		$continueInt =~ (s/n/0/);
	}
}
=cut

sub resetContinueInt {
	$continueInt = -1;
}

sub setContinueInt {
	resetContinueInt();
	while (!($continueInt == TRUE || $continueInt == 0)) {
		print "\nDo you want to continue (1 or 0): ";
		chomp (my $dirty = <STDIN>);
		my $clean = sanitizeNum(0,1,$dirty);
		if ($clean == $dirty) {
			$continueInt = $clean
		}
		else {
			print "\nInput rejected. Please try again.";
			sleep 1;
			#system("clear");
		}
	}
}

sub clearCurrentRecord {
	@currentRecord=();
}

sub getCurrentRecord {
	$currentRecord[IDX_EMPLOYEE_ID] = getEmployeeIDNum();
	if ($currentRecord[IDX_EMPLOYEE_ID] == ABJECT_FAILURE) {
		return ABJECT_FAILURE;
	}
	$currentRecord[IDX_EMPLOYEE_DEPT] = getEmployeeDept();
	if ($currentRecord[IDX_EMPLOYEE_DEPT] == ABJECT_FAILURE) {
		return ABJECT_FAILURE;
	}
	$currentRecord[IDX_EMPLOYEE_YRS] = getEmployeeYears();
	if ($currentRecord[IDX_EMPLOYEE_YRS] == ABJECT_FAILURE) {
		return ABJECT_FAILURE;
	}

}

sub getEmployeeIDNum {
	resetContinueInt();
	my $cleanInput;
	my $uncleanInput;
	my $recordConditionFlag;
	do {
		print "Please enter employee number: ";
		chomp ($uncleanInput = <STDIN>); 
		$cleanInput = sanitizeNum(0,IDENT_NUM_MAX,$uncleanInput);

		if ($cleanInput == $uncleanInput) {
			print "Input accepted.\n";

			if ((my $return=checkExistingRecord($cleanInput,IDX_EMPLOYEE_ID,$cleanInput)) == TRUE) {
			print "\nRecord for employee exists.";
			setContinueInt;
			$recordConditionFlag = TRUE;
			}

			if ($recordConditionFlag == TRUE && $continueInt == TRUE) {
				print "\nProceeding to edit exising record.\n";
				resetContinueInt();
			}
			elsif ($recordConditionFlag == TRUE && $continueInt != TRUE) {
				print "\nExit of existing record cancelled. Restart record?";
				setContinueInt();
			}
		}
		elsif ($cleanInput == ABJECT_FAILURE) {
			print "Input rejected. Either you entered a non-number, or the number was out of range. Range is 0-5000.\n";
			setContinueInt();
		}

	} while ($continueInt == TRUE);

	if ($continueInt != TRUE && $cleanInput != $uncleanInput) {
		return ABJECT_FAILURE
	}

	return $cleanInput;
}

sub getEmployeeDept {
	my $cleanInput;
	do {
		print "Please enter employee department number: ";
		chomp (my $uncleanInput = <STDIN>); 
		$cleanInput = sanitizeNum(0,DEPARTMENT_MAX,$uncleanInput);

		if ($cleanInput == $uncleanInput) {
			print "Input accepted.\n";

			if ((my $return=checkExistingRecord($currentRecord[IDX_EMPLOYEE_ID],
			IDX_EMPLOYEE_DEPT,$cleanInput) == ABJECT_FAILURE)) {

			print "\nRecord for employee exists, and has a different value.";
			setContinueInt;
			}

			if ($continueInt == TRUE) {
				print "\nProceeding to edit exising record.\n";
				$continueInt = 0;
			}
			else {
				print "\nExit of existing record cancelled. Restart record?";
				setContinueInt();
				break;
			}

		}
		elsif ($cleanInput == ABJECT_FAILURE) {
			print "Input rejected. Either you entered a non-number, or the number was out of range. Range is 0-10.\n";
			setContinueInt();
		}
	} while ($continueInt == TRUE);

	return $cleanInput;
}

sub getEmployeeYears {
	my $cleanInput;
	do {
		print "Please enter employee's years of service rounded up to whole number values: ";
		chomp (my $uncleanInput = <STDIN>); 
		$cleanInput = sanitizeNum(0,YEARS_MAX,$uncleanInput);

		if ($cleanInput == $uncleanInput) {
			print "Input accepted.\n";

			if (checkExistingRecord($currentRecord[IDX_EMPLOYEE_ID],
			IDX_EMPLOYEE_YRS,$cleanInput) == ABJECT_FAILURE) {

			print "\nRecord for employee exists, and has a different value.";
			setContinueInt;
			}

			if ($continueInt == TRUE) {
				print "\nProceeding to edit exising record.\n";
				$continueInt = 0;
			}
			else {
				print "\nExit of existing record cancelled. Restart record?";
				setContinueInt();
				break;
			}

		}
		elsif ($cleanInput == ABJECT_FAILURE) {
			print "Input rejected. Either you entered a non-number, or the number was out of range. Range is 0-40.\n";
			setContinueInt();
		}
	} while ($continueInt == TRUE);

	return $cleanInput;

}

sub checkExistingRecord {
	my $employeeNum = $_[0];
	my $recordIndex = $_[1];
	my $inputToCheck = $_[2];

	if ($employeesRecord[$employeeNum][$recordIndex] == $inputToCheck){
		return TRUE;
	}
	else {
		return ABJECT_FAILURE;
	}
}

sub sanitizeNum {
	my $rangeMin = $_[0];
	my $rangeMax = $_[1];
	my $input = $_[2];
	if ($input =~ /[^0-9]/ || $input < $rangeMin || $input > $rangeMax) {
		return ABJECT_FAILURE;
	}
	else {
		return $input;
	}
}

sub writeCurrentToEmployeesRecord {
	for (my $i=0; $i < FIELDS; $i++) {
		$employeesRecord[$currentRecord[IDX_EMPLOYEE_ID]][$i] = $currentRecord[$i];
	}
}

sub fetchDeptTotalYears {
	my $deptTotal = 0;

	foreach my $employee (@employeesRecord) {
		if (@$employee[IDX_EMPLOYEE_DEPT] == $currentRecord[IDX_EMPLOYEE_DEPT]) {
			$deptTotal += @$employee[IDX_EMPLOYEE_YRS]; #reference weirdness... perldoc.perl.org/perllol.html
		}
	}

	print "\nThe total years of service across all members of the employee's department is " . $deptTotal . " years.";
} 
