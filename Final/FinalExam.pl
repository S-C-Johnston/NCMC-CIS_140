#!/usr/bin/perl

##Author: Stewart Johnston (Johnstons1@student.ncmich.edu)
##Assignment: Final Exam
##Purpose: Demonstrate mastery of perl as covered in class
##Version: 0.3

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
DBG_VARS => "Variables",
};

use constant {
MENU_ONE => 1,
MENU_EXIT => 0,
};

my @patientData;
my @departmentCodes;

my $continueInt;
use constant USE_PROMPT => TRUE;

#utils for my own shorthand.

sub debugger {
	my @localParms = @_;
	if (DEBUG eq TRUE && $localParms[0] =~ DBG_ARGS || $localParms[0] =~ DBG_VARS) {
		my @callerArgs = @localParms;
		print "$callerArgs[0]:\n";
		shift(@callerArgs);
		if (scalar @callerArgs > 0) {
			foreach my $item (@callerArgs) {
				print "$item\n";
			}
		}
		print "\n";
	}
	if (DEBUG eq TRUE && $localParms[0] =~ DBG_ARRAY) {
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
			print "\n";
		}
	}
}

sub ascBySSN {
	$a->[IDX_SS_NUM] cmp $b->[IDX_SS_NUM];
}

#actual meat of the program.

sub main {
	populateDataArrays(); 
	sortArrayByMthd(\@patientData,\&ascBySSN);
	do {
		menu();
		setContinueInt(USE_PROMPT);
	} while ($continueInt eq TRUE);
}

sub menu {
	print "Search for patient records by Social Security Number (1), or exit (0)\n";
	print "? ";
	my $menuSelection = getNumInput(MENU_EXIT,MENU_ONE); 
	if ($menuSelection eq MENU_ONE) {
		print "Please enter Social Security Number for query: ";
		my $querySSN = getSocialSecNum(); 
		if ($querySSN eq 0) {
			return 0;
		}
	}
	elsif ($menuSelection eq MENU_EXIT) {
		die "Exiting program.";
	}
}

sub getSocialSecNum {
	my $dirtyInput;
	my $cleanInput;
	my $inputValid = 0;
	do {
		chomp ($dirtyInput = <STDIN>);
		debugger(DBG_VARS,"$dirtyInput");
		if ($dirtyInput =~ /^[\d]{2,3}-?[\d]{0,2}-?[\d]{0,4}$/) {
			$cleanInput = $dirtyInput;
		} 
		debugger(DBG_VARS,"$cleanInput","$dirtyInput");
		if (defined $cleanInput && $cleanInput eq $dirtyInput) {
			print "Input accepted.\n";
			$inputValid = TRUE;
		}
		else {
			print "Input rejected. Input either not a social security number or not properly formatted.\n";
			print "Social Security Number format is nnn-nn-nnnn, where \"n\" is a digit.\n";
			print "Partial Social Security Numbers also work, and one may omit the \"-\".\n";
			$inputValid = 0;
			setContinueInt(USE_PROMPT);
		}
	} until ($inputValid eq TRUE || $continueInt eq 0);
	return $cleanInput; 
}

sub setContinueInt {
	my $usePrompt = $_[0];
	#my $prompt = $_[1];
	$continueInt = -1;
	if ($usePrompt eq USE_PROMPT) {
	#	if (!defined $prompt) {
			print "Do you want to continue? (" . TRUE . ":Yes 0:No): ";
			$continueInt = getNumInput(0,TRUE);
	#	}
	#	elsif (defined $prompt) {
	#		print "$prompt";
	#	}
	}
	return $continueInt;
}

sub getNumInput {
	my $rangeMin = $_[0];
	my $rangeMax = $_[1];
	my $dirtyInput;
	my $cleanInput;
	my $inputValid = 0;
	do {
		chomp ($dirtyInput = <STDIN>);
		debugger(DBG_VARS,"$dirtyInput");
		$cleanInput = validateNum($dirtyInput,$rangeMin,$rangeMax);
		debugger(DBG_VARS,"$cleanInput,$dirtyInput");
		if (defined $cleanInput && $cleanInput eq $dirtyInput) {
			print "Input accepted.\n";
			$inputValid = TRUE;
		}
		else {
			print "Input rejected. Input either not a number or out of range. Range is $rangeMin - $rangeMax\n";
			$inputValid = 0;
			$cleanInput = setContinueInt(USE_PROMPT);
		}
	} until ($inputValid eq TRUE || $continueInt eq 0);
	return $cleanInput;
}
	
sub validateNum {
	debugger(DBG_ARGS,@_);
	my $dirtyInput = $_[0];
	my $rangeMin = $_[1]; #these are inclusive
	my $rangeMax = $_[2];
	my $cleanInput;
	if ($dirtyInput =~ /[\d]+/ && $dirtyInput !~ /[^\d]+/ && $rangeMin <= $dirtyInput && $dirtyInput <= $rangeMax) {
		$cleanInput = $dirtyInput;
	}
	else {
		$cleanInput = rand();
	}
	return $cleanInput;
}

sub populateDataArrays {
	retrieveRecords(PATIENT_DATA,\@patientData);
	#debugger(DBG_MDARRAY,scalar @patientData,scalar @{$patientData[0]},@patientData);
	retrieveRecords(DEPARTMENT_DATA,\@departmentCodes);
	#debugger(DBG_MDARRAY,scalar @departmentCodes,scalar @{$departmentCodes[0]},@departmentCodes);
}

sub sortArrayByMthd {
	my $arrayHandle=$_[0];
	my $sortMethod=$_[1];
	#debugger(DBG_MDARRAY,scalar @{$arrayHandle},scalar @{$arrayHandle->[0]},@{$arrayHandle});
	@{$arrayHandle} = sort { &$sortMethod() } @{$arrayHandle};
	#debugger(DBG_MDARRAY,scalar @{$arrayHandle},scalar @{$arrayHandle->[0]},@{$arrayHandle});
}

sub retrieveRecords {
	#debugger(DBG_ARGS,@_);
	my $IN_FILE=$_[0];
	my $arrayHandle=$_[1];
	open (my $IN, '<', $IN_FILE);
	my $counter = 0;
	my @readerArray = ();
	while (<$IN>) {
		@readerArray = split(/,/);
		for (my $i = 0; $i < scalar(@readerArray); $i++) {
			chomp($arrayHandle->[$counter][$i] = "$readerArray[$i]");
			#debugger(DBG_ARGS,"ROW: $counter","COLUMN: $i","$arrayHandle->[$counter][$i]","$readerArray[$i]");
		}
		$counter++;
	}
	close $IN;
}

main();
