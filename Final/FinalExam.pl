#!/usr/bin/perl

##Author: Stewart Johnston (Johnstons1@student.ncmich.edu)
##Assignment: Final Exam
##Purpose: Demonstrate mastery of perl as covered in class
##Version: 0.8

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
IDX_DEPARTMENT => 0,
IDX_OWED_TO_DEPT => 1,
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

use constant USE_PROMPT => TRUE;

my @patientData;
my @departmentCodes;

my $continueInt;

my $recurseCounter = 0;
use constant RECURSE_MAX => 5;

#Utility functions for my own shorthand.

sub debugger {
	my @localParms = @_;
	##debugger( KEYWORD, Arguments/Variables )
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
	##debugger( KEYWORD, Array Length, [mdarray depth], Array )
	##array length and depth as scalars, array as... array. Duh.
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

sub reprintPrompt { ##reprintPrompt( promptToReprint )
	##Non-obvious function. Primarily just shorthand for the logic to
	##reprint a prompt if a validation fails and setContinueInt() is called.
	my $userPrompt = $_[0];
	if (defined $userPrompt && $continueInt eq TRUE) {
		print "$userPrompt";
	}
}

sub getNumInput { ##getNumInput( range floor, range cieling, prompt for user )
	my $rangeMin = $_[0];
	my $rangeMax = $_[1];
	my $userPrompt = $_[2];
	my $dirtyInput;
	my $cleanInput;
	my $inputValid = 0;
	setContinueInt();
	do {
		if (defined $userPrompt) {
			reprintPrompt($userPrompt);
		}
		chomp ($dirtyInput = <STDIN>);
#		debugger(DBG_VARS,"$dirtyInput");
		$cleanInput = validateNum($dirtyInput,$rangeMin,$rangeMax);
#		debugger(DBG_VARS,"$cleanInput,$dirtyInput");
		if (defined $cleanInput && $cleanInput eq $dirtyInput) {
			print "Input accepted.\n";
			$inputValid = TRUE;
		}
		else {
			print "Input rejected. Input either not a number or out of range. Range is $rangeMin - $rangeMax\n";
			$inputValid = 0;
			checkRecurseCounter();
			modRecurseCounter(1);
			$cleanInput = setContinueInt(USE_PROMPT);
		}
	} until ($inputValid eq TRUE || $continueInt eq 0);
	return $cleanInput;
}
	
sub validateNum { ##validateNum( input to validate, range floor, range cieling )
#	debugger(DBG_ARGS,@_);
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

#Global variable handlers.

sub modRecurseCounter { ##modRecurseCounter( [positive or negative value to modify the recursion counter] )
			##No args resets the recursion counter.
	if (@_) {
#		debugger(DBG_ARGS,@_);
	}
	my $modifierInt = $_[0];
	if (defined $modifierInt && $modifierInt =~ /[\d]+/) {
#		debugger(DBG_VARS,"recurseCounter pre-mod",$recurseCounter);
#		debugger(DBG_VARS,"recurseCounter modifier",$modifierInt);
		$recurseCounter += $modifierInt;
#		debugger(DBG_VARS,"recurseCounter post-mod",$recurseCounter);
	}
	else {
#		debugger(DBG_VARS,"recurseCounter pre-reset",$recurseCounter);
		$recurseCounter = 0;
#		debugger(DBG_VARS,"recurseCounter post-reset",$recurseCounter);
	}
}

sub checkRecurseCounter { 
#	debugger(DBG_VARS,"recurseCounter during check",$recurseCounter);
	if ($recurseCounter >= RECURSE_MAX) {
		die "Too many bad tries. Exiting.";
	}
}

sub setContinueInt { ##setContinueInt( [USE_PROMPT] )
	my $promptUser = $_[0];
#	my $prompt = $_[1];
	$continueInt = -1;
	if ($promptUser && $promptUser eq USE_PROMPT) {
#		if (!defined $prompt) {
		do {
			checkRecurseCounter();
			my $userPrompt = "Do you want to continue? (" . TRUE . ":Yes 0:No): ";
			print $userPrompt;
			$continueInt = getNumInput(0,TRUE,$userPrompt);
			if ($continueInt eq TRUE) {
				print "Confirmed, continuing.\n"; 
			}
		} until ($continueInt eq TRUE || $continueInt eq 0);
#		}
#		elsif (defined $prompt) {
#			print "$prompt";
#		}
	}
	return $continueInt;
}

#Sorting schemes.

sub sortArrayByMthd { ##sortArrayByMthd( \@array, &sortMethod, $sortField )
	my $arrayHandle = $_[0];
	my $sortMethod = $_[1];
	my $sortField = $_[2];
#	debugger(DBG_MDARRAY,scalar @{$arrayHandle},scalar @{$arrayHandle->[0]},@{$arrayHandle});
	if (defined $sortField) {
		@{$arrayHandle} = sort { &$sortMethod($sortField) } @{$arrayHandle};
	}
	else {
		@{$arrayHandle} = sort { &$sortMethod() } @{$arrayHandle};
	}
#	debugger(DBG_MDARRAY,scalar @{$arrayHandle},scalar @{$arrayHandle->[0]},@{$arrayHandle});
}

sub ascAlphaByField { ##ascAlphaByField( $field )
	my $field = $_[0];
	$a->[$field] cmp $b->[$field];
}

#Actual meat of the program.

sub main {
	modRecurseCounter();
	setContinueInt();
	populateDataArrays(); 
	sortArrayByMthd(\@patientData,\&ascBySSN,IDX_SS_NUM);
	do {
		menu();
		setContinueInt(USE_PROMPT);
	} while ($continueInt eq TRUE);
	print "\nThank you for using this software. The program will now exit.\n";
	print "Please create a support ticket if you encounter problems.\n";
}

sub populateDataArrays {
	retrieveRecords(PATIENT_DATA,\@patientData);
#	debugger(DBG_MDARRAY,scalar @patientData,scalar @{$patientData[0]},@patientData);
	retrieveRecords(DEPARTMENT_DATA,\@departmentCodes);
#	debugger(DBG_MDARRAY,scalar @departmentCodes,scalar @{$departmentCodes[0]},@departmentCodes);
}

sub retrieveRecords { ##retrieveRecords( filename.csv, \@array )
#	debugger(DBG_ARGS,@_);
	my $IN_FILE=$_[0];
	my $arrayHandle=$_[1];
	open (my $IN, '<', $IN_FILE);
	my $counter = 0;
	my @readerArray = ();
	while (<$IN>) {
		@readerArray = split(/,/);
		for (my $i = 0; $i < scalar(@readerArray); $i++) {
			chomp($arrayHandle->[$counter][$i] = "$readerArray[$i]");
#			debugger(DBG_ARGS,"ROW: $counter","COLUMN: $i","$arrayHandle->[$counter][$i]","$readerArray[$i]");
		}
		$counter++;
	}
	close $IN;
}

sub menu {
	my $menuPromptRoot = "Search for patient records by Social Security Number (" .  MENU_ONE . "), or exit (" . MENU_EXIT . ")\n? ";
	print $menuPromptRoot;
	my $menuSelection = getNumInput(MENU_EXIT,MENU_ONE,$menuPromptRoot); 
	if ($menuSelection eq MENU_ONE) {
		menuSelectionSSN(); 
	} 
	elsif ($menuSelection eq MENU_EXIT) 
	{ 
		die "Exiting program.\n";
	}
}

sub menuSelectionSSN {
	my $menuPromptBranchA = "Please enter Social Security Number for query: ";
	print $menuPromptBranchA;
	my $querySSN = getSocialSecNum($menuPromptBranchA); 
	if ($querySSN eq 0) {
		return 0;
	}
	my $queryReturn = queryPatientDataSSN($querySSN);
#	debugger(DBG_VARS,$queryReturn);
	my @matchingRecords = ();
	unless ($queryReturn eq $querySSN) {
		@matchingRecords = @{$queryReturn};
#		debugger(DBG_MDARRAY,scalar @matchingRecords, scalar @{$matchingRecords[0]},@matchingRecords);
	}
	else {
		print "\nNo matches found.\n";
	}
	#formatMatchingRecords();
	#printFormattedMatchingRecords();
}

sub getSocialSecNum {
	my $userPrompt = $_[0];
	my $dirtyInput;
	my $cleanInput;
	my $inputValid = 0;
	modRecurseCounter();
	setContinueInt();
	do {
		checkRecurseCounter();
		if (defined $userPrompt) {
			reprintPrompt($userPrompt);
		}
		chomp ($dirtyInput = <STDIN>);
#		debugger(DBG_VARS,"$dirtyInput");
		if ($dirtyInput =~ /^[\d]{2,3}-?[\d]{0,2}-?[\d]{0,4}$/) {
			$cleanInput = $dirtyInput;
		} 
#		debugger(DBG_VARS,"$cleanInput","$dirtyInput");
		if (defined $cleanInput && $cleanInput eq $dirtyInput) {
			print "\nInput accepted.\n";
			$inputValid = TRUE;
		}
		else {
			print "\nInput rejected. Input either not a social security number or not properly formatted.\n";
			print "Social Security Number format is nnn-nn-nnnn, where \"n\" is a digit.\n";
			print "Partial Social Security Numbers also work, and one may omit the \"-\".\n";
			$inputValid = 0;
			$cleanInput = setContinueInt(USE_PROMPT);
			modRecurseCounter(1);
		}
	} until ($inputValid eq TRUE || $continueInt eq 0);
	return $cleanInput; 
}

sub queryPatientDataSSN { ##queryPatientDataSSN( $querySSN )
#	debugger(DBG_ARGS,@_);
	my $querySSN = $_[0];
	my @matchingRecords = ();
	foreach my $patientRecord (@patientData) {
#		debugger(DBG_ARRAY,scalar @{$patientRecord},@{$patientRecord});
#		debugger(DBG_VARS,$patientRecord->[IDX_SS_NUM]);
#		debugger(DBG_VARS,($patientRecord->[IDX_SS_NUM] =~ s/-//gr));
#		debugger(DBG_VARS,($querySSN =~ s/-//gr));
		if (($patientRecord->[IDX_SS_NUM] =~ s/-//gr) =~ ($querySSN =~ s/-//gr)) {
			push(@matchingRecords,$patientRecord);
		}
	}
	if ((scalar @matchingRecords) eq 0) {
		return $querySSN;
	}
	if (@matchingRecords) {
#		debugger(DBG_MDARRAY,scalar @matchingRecords, scalar @{$matchingRecords[0]},@matchingRecords);
	}
	return(\@matchingRecords);
}

sub formatMatchingRecords { ##formatPatientRecords( @matchingRecords )
	debugger(DBG_ARGS,@_);
	my @matchingRecords = $_[0];
	foreach my $record (@matchingRecords) {
		my $primeDept = $record->[IDX_PRIME_DEPT];
		$record->[IDX_PRIME_DEPT] = returnDeptCodes($primeDept);
	}
	my @uniqueSSNs = buildUniqueSSNs(@matchingRecords);
	foreach my $SSN (@uniqueSSNs) {
		$sortSSNsByDept($SSN,@matchingRecords);
		
	}
}

sub returnDeptCodes { ##returnDeptCodes( $deptCode )
	my $deptCode = $_[0];
	foreach my $codePair (@departmentCodes) { 
		if ($codePair[0] eq $deptCode) {
			$deptCode = $codePair[1];
			break;
		}
	}
	return $deptCode;
}

sub buildUniqueSSNs { ##buildUniqueSSNs( @modifiedMatchingRecords )
	my @matchingRecords = $_[0];
	my @uniqueSSNs = ();
	foreach my $record (@matchingRecords) {
		my $isUniqueSSN = 0;
		if (@uniqueSSNs) {
			foreach my $SSN (@uniqueSSNs) {
				unless ($record->[IDX_SS_NUM] eq $SSN) {
					$isUniqueSSN = TRUE;
				}
			}
		}
		if ($isUniqueSSN ne TRUE) {
			next;
		}
		else {
			push(@uniqueSSNs,$record->[IDX_SS_NUM]);
		} 
	}
	return(\@uniqueSSNs);
}

sub sortSSNsByDept { ##formatDeptOwedTotals( $SSN, @matchingRecords )
	my $SSN = $_[0];
	my @matchingRecords = $_[1];
	my $sortSliceOffset;
	my $sortSliceLength = 0;
	my $firstMatchedRecord;
	while (my ($i,$record) = each @matchingRecords) {
		if ($record->[IDX_SS_NUM] eq $SSN) { 
			if (! defined $sortSliceOffset && defined $firstMatchedRecord) {
				$sortSliceOffset = $i;
			}
			if (defined $sortSliceOffset) {
				$sortSliceLength += 1;
			}
			if (! defined $firstMatchedRecord) {
				$firstMatchedRecord = $i;
			}
	}
	splice(@matchingRecords, $sortSliceOffset, $sortSliceLength, sortArrayByMthd(@matchingRecords[$sortSliceOffset,$sortSliceLength],&ascAlphaByField,IDX_PRIME_DEPT));
}


sub formatDeptOwedTotals { ##formatDeptOwedTotals( $SSN, @matchingRecords )
	my $SSN = $_[0];
	my @matchingRecords = $_[1];
	my $spliceOffset;
	my $spliceLength = 0;
	my $firstMatchedRecord;
	my $department;
	my $owedTotal = 0;
	while (my ($i,$record) = each @matchingRecords) {
		if ($record->[IDX_SS_NUM] eq $SSN) { 
			if (! defined $spliceOffset && defined $matchedRecord) {
				$spliceOffset = $i;
			}
			if (defined $spliceOffset) {
				$spliceLength += 1;
			}
			if (! defined $department) {
				$department = $record->[IDX_PRIME_DEPT];
			}
			elsif ($department ne $record->[IDX_PRIME_DEPT]) {
				$department = $record->[IDX_PRIME_DEPT];
			}
			if (! defined $firstMatchedRecord) {
				$firstMatchedRecord = $i;
			}
		}
		if (! defined $spliceOffset) {
		}
	}
}

sub printFormattedMatchingRecords { ##printFormattedMatchingRecords( @formattedPatientRecords )
}

main();
