## Name: Project 8
## Purpose: Demonstrate an understanding of perl
## Version: 2019.12.16.23
## Author: Stewart Johnston
## Email: johnstons1@student.ncmich.edu

use v5.26.3;
use warnings;
use strict;
use Carp;

my %UID_LIMITS;

sub read_config_file
{
	my $file = shift 
		or croak ("No file argument: $!\n");
	my %configuration_hash;
	if (-r $file)
	{
		open (CONFIG_FILE, '<', $file) 
			or croak ("Can't open $file to read: $!\n");
	}
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
	close (CONFIG_FILE);
	return \%configuration_hash;
}
