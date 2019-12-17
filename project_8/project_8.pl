## Name: Project 8
## Purpose: Demonstrate an understanding of perl
## Version: 2019.12.16.23
## Author: Stewart Johnston
## Email: johnstons1@student.ncmich.edu

use v5.26.3;
use warnings;
use strict;

sub read_config_file
{
	my $file = shift 
		or die "No file argument: $!\n";
	my %configuration_hash;
	open (CONFIG_FILE, '<', $file) 
		or die "Can't open $file to read: $!\n";
	while (<CONFIG_FILE>)
	{
		chomp (my $line = <CONFIG_FILE>);
		$line =~ s/#.*//;
		$line =~ s/^\s+//;
		$line =~ s/\s+$//;
		next unless (length($line) > 0);
		my ($config_key, $config_value) 
		= split (/\s*=?\s*/, $line);
		$configuration_hash{$config_key} = $config_value;
		#https://www.unix.com/shell-programming-and-scripting/161037-read-config-file-use-perl-program.html
	}
	return \%configuration_hash;
}
