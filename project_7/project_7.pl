# Name: Project 7
# Purpose: Demonstrate understanding of perl programming basics and
# algorithms
# Version: 2019.12.12.09.01
# Author: Stewart Johnston
# Email: johnstons1@student.ncmich.edu

use v5.26.0;
use warnings;
use strict;

use constant {
	TRUE => 1,
	FALSE => 0,
	CURRENT_YEAR => 2019,
};

my $FH_IN;
my $FH_OUT;
my $FILENAME = "test.csv";
my $NO_INS_FILENAME = "no_insurance.csv";

my $largest_PIN = 0;

sub autoincrement_largest_PIN
{
	my $target = shift;
	if ($target && $target >= $largest_PIN)
	{
		$largest_PIN = $target;
	};
	#$largest_PIN++;
	return $largest_PIN++;
};

#my %patient_record= (
#	PIN => 0,
#	last_name => "Johnston",
#	first_name => "Stewart",
#	middle_initial => "C",
#	DOB => "1996-04-12",
#	age => 23,
#	insurance_carrier => "none",
#	ailment => "Delusions of grandeur",
#);

use constant PATIENT_KEYS => qw[
PIN
last_name
first_name
middle_initial
DOB
age
insurance_carrier
ailment];

my @patients;
#push (@patients, \%patient_record);

sub populate_data_from_file
{
	my $FILENAME = shift @_;
	die "Cannot open $FILENAME" unless \
	open ($FH_IN, '<', $FILENAME) and \
	say("$FILENAME opened successfully");
	while ( <$FH_IN> )
	{
		chomp(my $line = $_);
		my @pairs = split (/;/, $line);
		my %hash;
		foreach my $pair (@pairs)
		{
			my ($key, $value) = split (/=>/, $pair);
			$hash{$key} = $value;
			if ("insurance_carrier" eq $key and !$value)
			{
				$value = "none";
			}
				
		};
		push(@patients, \%hash);
		$patients[($. - 1)]{"PIN"} =
		autoincrement_largest_PIN($patients[($.-1)]{"PIN"});
		my ($year, $month, $day) = split (/-/,
			$patients[$.-1]{"DOB"});
		$patients[$.-1]{"age"} = (CURRENT_YEAR - $year);
	};
	close ($FH_IN);
	return TRUE;
};

sub print_patients
{
	print "In print_patients";
	foreach my $key (PATIENT_KEYS)
	{
		print qq($key );
	};
	print qq(\n);
	for (my $i = 0; $i < scalar @patients; $i++)
	{
		foreach my $key (PATIENT_KEYS)
		{
			print (qq($patients[$i]{$key}\; ));
		};
		print qq(\n);
	};
};

sub populate_file_from_data
{
	my $FILENAME = shift @_;
	open ($FH_OUT, '>', $FILENAME);
	for (my $i = 0; $i < scalar @patients; $i++)
	{
		foreach my $key (keys %{$patients[$i]})
		{
			print $FH_OUT (qq($key=>$patients[$i]{$key}\;));
		};
		print $FH_OUT qq(\n);
	}
	close ($FH_OUT);
};

sub prompt_new_patients
{
	my %new_patient;
	my $response;
	print "Please input their first name: ";
	chomp ($new_patient{"last_name"} = <STDIN>);
	print "Please input their last name: ";
	chomp ($new_patient{"first_name"} = <STDIN>);
	print "Please input their middle initial: ";
	chomp ($new_patient{"middle_initial"} = <STDIN>);
	print "Please input their birth year: ";
	chomp ($response = <STDIN>);
	my $year = $response;
	print "Please input their birth month: ";
	chomp ($response = <STDIN>);
	my $month = $response;
	print "Please input their birth day: ";
	chomp ($response = <STDIN>);
	my $day = $response;
	$new_patient{"DOB"} = join ("-", ($year, $month, $day));
	print qq(Please input their insurance carrier, or 'none': );
	chomp ($response = <STDIN>);
	$new_patient{"insurance_carrier"} = $response;
	if ($new_patient{"insurance_carrier"} eq '')
	{
		$new_patient{"insurance_carrier"} = "none";
	};
	print "Please input their ailment: ";
	say chomp ($new_patient{"ailment"} = <STDIN>);
	$new_patient{"PIN"} = autoincrement_largest_PIN();
	$new_patient{"age"} = (CURRENT_YEAR - $year);
	push (@patients, \%new_patient);
};

sub process_no_insurance
{
	open ($FH_OUT, '>', $NO_INS_FILENAME);
	for (my $i = 0; $i < scalar @patients; $i++)
	{
		if (!$patients[$i]{"insurance_carrier"})
		{
			$patients[$i]{"insurance_carrier"} = "none";
		}
		foreach my $key (keys %{$patients[$i]})
		{
			if ($patients[$i]{"insurance_carrier"} eq "none")
			{
				print $FH_OUT
				(qq($key=>$patients[$i]{$key}\;));
			};
		};
		print $FH_OUT qq(\n);
	};
	close($FH_OUT);
};

sub main()
{
	populate_data_from_file($FILENAME);
	print_patients();
	my $continue = TRUE;
	do {
		prompt_new_patients();
		print "Would you like to continue? \n";
		print "0 = no, any other =  yes: ";
		chomp ($continue = <STDIN>);
	} until (!$continue);
	print_patients();
	populate_file_from_data($FILENAME);
	process_no_insurance();
};

main();
