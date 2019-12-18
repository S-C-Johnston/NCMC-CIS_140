## Name: Project 8
## Purpose: Demonstrate an understanding of perl
## Version: 2019.12.16.23
## Author: Stewart Johnston
## Email: johnstons1@student.ncmich.edu

use v5.26.3;
use warnings;
use strict;
use Carp;

my %SYS_LOGIN_DEFS;

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

sub set_sys_login_defs
{
	my $config_hash;
	eval
	{
		$config_hash = read_config_file("/etc/login.defs");
	}
	$SYS_LOGIN_DEFS{UID_MIN} = defined ${$config_hash}{UID_MIN} ?
	${$config_hash}{UID_MIN} : 1000;
	$SYS_LOGIN_DEFS{UID_MAX} = defined ${$config_hash}{UID_MIN} ?
	${$config_hash}{UID_MAX} : 60000;
	$SYS_LOGIN_DEFS{SYS_UID_MIN} = defined
	${$config_hash}{SYS_UID_MIN} ?
	${$config_hash}{SYS_UID_MIN} : 201;
	$SYS_LOGIN_DEFS{SYS_UID_MAX} = defined
	${$config_hash}{SYS_UID_MIN} ?
	${$config_hash}{SYS_UID_MAX} : 999;
	if (defined ${$config_hash}{USERDEL_CMD})
	{
		$SYS_LOGIN_DEFS{USERDEL_CMD} =
		${$config_hash}{USERDEL_CMD};
		#single if here because there is no default.
	}
}
