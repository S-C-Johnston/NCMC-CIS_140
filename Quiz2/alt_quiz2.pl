,#!/usr/bin/env perl
#^Retrieved with `which perl` Not necessarily portable.

## Author: Stewart Johnston
## Assignment: Quiz 2 -- Perl Basics
## Purpose: Gather employee information and output total years of
#service of employees in same department
## Version: 2019.12.05.19.01

## Hey listen! This is bare minimum. Only does what the spec-sheet asks,
#nothing more. Wanted to implement better safeties.  Actually, it's kind
#of a crufty mess. I don't like it. I wish I had more time to clean it
#up and work on it.  Will probably rewrite as version 2.0 at some point.
#Spent... longer than I want to admit on this.  3 hrs Saturday "I'll
#totally get this done." Nope.  3 hrs Sunday "I'm almost done, it'll be
#great." Nope.  Monday night, start working on it, thinking I'll get it
#done in time for the deadline.  Cue 8-ish hours straight trying to get
#the pissing thing to work with all the safeties I had written in.  Cue
#4 more hours scrapping those safeties and just straight debugging.
#OMGWTFBBQ So here it is.  #


use 5.14.2;
use warnings;
use strict;

use constant TRUE => 1;
use constant DEBUG => 0;
use constant INT_FAILURE => "FAIL";

my $continueInt;
#my $RECORDS_IO; Unimplemented, not strictly called for in doc, works
#from current session only.

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
	YEARS_MIN => 1,
	#We're counting partial years as whole years, for the sake of
	#simplicity
	YEARS_MAX => 40,
};

sub main {
	do {
		resetContinueInt();
		clearCurrentRecord();
		getCurrentRecord();
		writeCurrentToEmployeesRecord(); 
		fetchDeptTotalYears();
		print "\nRecord modification complete.";
		setContinueInt();
	} while ($continueInt == TRUE);

	print "Process complete, exiting.";
	#sleep 1; #Argh. Ran into the same sleep buffer issue I had last
	#semester.  Sleep prevents the immediately preceeding print
	#statement from issuing until after the sleep has completed. No
	#idea why. Uncomment if you dare.
}

main();

sub resetContinueInt {
	$continueInt = -1;
}

sub debugPrint {
	if (DEBUG == TRUE) {
		my @params = @_;
		foreach my $item (@params) {
			print "$item\t";
		}
		print "\n";
	}
}

sub setContinueInt {
	resetContinueInt();
	do {
		print "\nDo you want to continue (1 or 0): ";
		chomp (my $dirtyInput = <STDIN>);
		debugPrint("dirtyInput",$dirtyInput);

		my $cleanInput = sanitizeNum(0,TRUE,$dirtyInput);
		debugPrint("cleanInput",$cleanInput);

		if (!($cleanInput eq INT_FAILURE) && $cleanInput ==
			$dirtyInput) {
			debugPrint("cleanInput",$cleanInput);
			$continueInt = $cleanInput;
			debugPrint("continue",$continueInt);
		}
		elsif ($cleanInput eq INT_FAILURE) {
			debugPrint("continue",$continueInt);
			print "\nInput rejected. Please try again.";
			#system("clear");
		}

	} until ($continueInt == TRUE || $continueInt == 0)

}

sub clearCurrentRecord {
	@currentRecord=();
}

sub getCurrentRecord {
	$currentRecord[IDX_EMPLOYEE_ID] = getEmployeeIDNum();
	$currentRecord[IDX_EMPLOYEE_DEPT] = getEmployeeDept();
	$currentRecord[IDX_EMPLOYEE_YRS] = getEmployeeYears();
}

sub getEmployeeIDNum {
	resetContinueInt();
	my $cleanInput;
	my $dirtyInput;
	#	my $recordConditionFlag;
	do {
		print "Please enter employee number: ";
		chomp ($dirtyInput = <STDIN>); 
		debugPrint("dirtyIn",$dirtyInput);
		$cleanInput = sanitizeNum(0,IDENT_NUM_MAX,$dirtyInput);
		debugPrint("cleanIn",$cleanInput);

		if (!($cleanInput eq INT_FAILURE) && $cleanInput ==
			$dirtyInput) {
			print "Input accepted.\n";
			resetContinueInt();
		}
		elsif ($cleanInput eq INT_FAILURE) {
			print "Input rejected. Either you entered a", 
			" non-number, or the number was out of range.", 
			" Range is 0-" . IDENT_NUM_MAX;
			setContinueInt();
		}

	} while ($continueInt == TRUE);

	if ($continueInt != TRUE && $cleanInput ne $dirtyInput) {
		debugPrint("dirtyIn",$dirtyInput);
		debugPrint("cleanIn",$cleanInput);
		debugPrint("continue",$continueInt);
		die "Mismatched numbers and no continuation";	
	}

	return $cleanInput;
}

sub getEmployeeDept {
	resetContinueInt();
	my $cleanInput;
	my $dirtyInput;
	do {
		print "Please enter employee department number: ";
		chomp ($dirtyInput = <STDIN>); 
		debugPrint("dirtyIn",$dirtyInput);
		$cleanInput = sanitizeNum(0,DEPARTMENT_MAX,$dirtyInput);
		debugPrint("cleanIn",$cleanInput);

		if (!($cleanInput eq INT_FAILURE) && $cleanInput ==
			$dirtyInput) {
			print "Input accepted.\n";
			resetContinueInt();
		}
		elsif ($cleanInput eq INT_FAILURE) {
			print "Input rejected. Either you entered a", 
			" non-number, or the number was out of",
			" range. Range is" . " 0-" . DEPARTMENT_MAX;
			setContinueInt();
		}

	} while ($continueInt == TRUE);

	if ($continueInt != TRUE && $cleanInput ne $dirtyInput) {
		debugPrint("dirtyIn",$dirtyInput);
		debugPrint("cleanIn",$cleanInput);
		debugPrint("continue",$continueInt);
		die "Mismatched numbers and no continuation";	
	}

	return $cleanInput;
}

sub getEmployeeYears {
	resetContinueInt();
	my $cleanInput;
	my $dirtyInput;
	do {
		print "Please enter employee's years of service",
		" rounded up to whole number values: ";
		chomp ($dirtyInput = <STDIN>); 
		debugPrint("dirtyIn",$dirtyInput);
		$cleanInput =
		sanitizeNum(YEARS_MIN,YEARS_MAX,$dirtyInput);
		debugPrint("cleanIn",$cleanInput);

		if (!($cleanInput eq INT_FAILURE) && $cleanInput ==
			$dirtyInput) {
			print "Input accepted.\n";
			resetContinueInt();
		}
		elsif ($cleanInput eq INT_FAILURE) {
			print "Input rejected. Either you entered a", 
			" non-number, or the number was out of range.",
			" Range is " . YEARS_MIN . "-" . YEARS_MAX;
			setContinueInt();
		}
	} while ($continueInt == TRUE);

	if ($continueInt != TRUE && $cleanInput ne $dirtyInput) {
		debugPrint("dirtyIn",$dirtyInput);
		debugPrint("cleanIn",$cleanInput);
		debugPrint("continue",$continueInt);
		die "Mismatched numbers and no continuation";	
	}

	return $cleanInput;

}

sub sanitizeNum {
	my $rangeMin = $_[0];
	my $rangeMax = $_[1];
	my $input = $_[2];
	if ($input =~ /[^0-9]/ || $input < $rangeMin || $input >
		$rangeMax) {
		return INT_FAILURE;
	}
	else {
		return $input;
	}
}

sub writeCurrentToEmployeesRecord {
	for (my $i=0; $i < FIELDS; $i++) {
		$employeesRecord[$currentRecord[IDX_EMPLOYEE_ID]][$i] =
		$currentRecord[$i];
	}
}

sub fetchDeptTotalYears {
	my $deptTotal = 0;

	foreach my $employee (@employeesRecord) {
		if (defined @$employee[IDX_EMPLOYEE_DEPT] &&
			@$employee[IDX_EMPLOYEE_DEPT] ==
			$currentRecord[IDX_EMPLOYEE_DEPT]) { $deptTotal
			+= @$employee[IDX_EMPLOYEE_YRS];
			#reference weirdness...
			#perldoc.perl.org/perllol.html
		}
	}

	print "\nThe total years of service across all members of the", 
	" employee's department is " . $deptTotal . " years.";
} 
