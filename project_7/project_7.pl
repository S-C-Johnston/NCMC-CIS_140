# Name: Project 7
# Purpose: Demonstrate understanding of perl programming basics and
# algorithms
# Version: 2019.12.12.09.01
# Author: Stewart Johnston
# Email: johnstons1@student.ncmich.edu

use v5.26.0;
use warnings;
use strict;

my $FH_OUT;
my $FILENAME= "test.csv";

my $test_hash = (
	last_name => "Johnston",
	first_name => "Stewart",
	middle_initial => "C",
	DOB => "1996-04-12",
	insurance_carrier => "none",
	ailment => "Delusions of grandeur",
);

sub main()
{
	open ($FH_OUT, '>>', $FILENAME) and \
	say("$FILENAME opened successfully") or \
	die "Cannot open $FILENAME";
};

main();
