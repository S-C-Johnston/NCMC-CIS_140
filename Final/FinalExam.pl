#!/usr/bin/perl

##Author: Stewart Johnston (Johnstons1@student.ncmich.edu)
##Assignment: Final Exam
##Purpose: Demonstrate mastery of perl as covered in class
##Version: 0.1

use 5.14.2;
use warnings;
use strict;

use constant {
TRUE => 1,
};

use constant DEBUG => TRUE;

use constant {
PATIENT_DATA => "PatientsRecord.csv",
DEPARTMENT_DATA => "DepartmentCodes.csv",
};

use constant {
IDX_NAME_L => 0,
IDX_NAME_F => 1,
IDX_PRIME_DEPT => 2,
IDX_OWED_AMOUNT => 3,
IDX_SS_NUM => 4,
};

use constant {
DBG_ARGS => "Arguments",
DBG_ARRAY => "List",
DBG_IDX_ARRAY_LENGTH => 1,
DBG_MDARRAY => "List of Lists",
DBG_IDX_MDARRAY_DEPTH => 2,
};

my @patientData;
my @departmentCodes;

sub debugger {
	my @localParms = @_;
	if (DEBUG == TRUE && $localParms[0] =~ DBG_ARGS) {
		my @callerArgs = @localParms;
		print "$callerArgs[0]:\n";
		shift(@callerArgs);
		foreach my $item (@callerArgs) {
			print "$item\n";
		}
		print "\n";
	}
	if (DEBUG == TRUE && $localParms[0] =~ DBG_ARRAY) {
		my @callerElements = @localParms;
		print "$callerElements[0]:\n";
		my $callerArrayLength = 0;
		my $callerMDArrayDepth = 0;
		if ($callerElements[0] =~ DBG_MDARRAY) {
			$callerArrayLength = $callerElements[DBG_IDX_ARRAY_LENGTH];
			$callerMDArrayDepth = $callerElements[DBG_IDX_MDARRAY_DEPTH];
			splice(@callerElements,0,3);
		}
		else {
			$callerArrayLength = $callerElements[DBG_IDX_ARRAY_LENGTH];
			splice(@callerElements,0,2);
		}
		for (my $i = 0; $i < $callerArrayLength; $i++) {
			print "ROW: $i\n";
			print "$callerElements[$i]\n";	
			for (my $j = 0; $j < $callerMDArrayDepth; $j++) {
				print "COLUMN: $j\n";
				print "$callerElements[$i][$j]\n";
			}
		}
		print "\n";
	}
}

sub main {
	populateDataArrays();
}

sub populateDataArrays {
	retrieveRecords(PATIENT_DATA,\@patientData);
	debugger(DBG_MDARRAY,scalar @patientData,scalar @{$patientData[0]},@patientData);
	retrieveRecords(DEPARTMENT_DATA,\@departmentCodes);
	debugger(DBG_MDARRAY,scalar @departmentCodes,scalar @{$departmentCodes[0]},@departmentCodes);
}

sub retrieveRecords {
	debugger(DBG_ARGS,@_);
	my $IN_FILE=$_[0];
	my $arrayHandle=$_[1];
	open (my $IN, '<', $IN_FILE);
	my $counter = 0;
	my @readerArray = ();
	while (<$IN>) {
		@readerArray = split(/,/);
		for (my $i = 0; $i < scalar(@readerArray); $i++) {
			chomp($arrayHandle->[$counter][$i] = "$readerArray[$i]");
			debugger(DBG_ARGS,"ROW: $counter","COLUMN: $i","$arrayHandle->[$counter][$i]","$readerArray[$i]");
		}
		$counter++;
	}
	close $IN;
}

main();
