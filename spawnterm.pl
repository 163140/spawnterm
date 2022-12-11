#!/usr/bin/env perl
#===============================================================================
#
#         FILE: spawnterm.pl
#
#        USAGE: ./spawnterm.pl
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: EA1A87 (), 163140@autistici.org
# ORGANIZATION:
#      VERSION: 0.0
#      CREATED: 11.12.2022 11:01:29
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.36;

use Proc::ProcessTable;
use List::MoreUtils qw(duplicates);

my $Wanted_Proc_Name = shift;
my $User_Name = $<; # real uid


my $Processes = Proc::ProcessTable->new();

sub filter_by_name ($Process_Table, $Proc_Name) {
	my $Name = $Process_Table -> {fname};
	return $Process_Table -> {pid} if $Name eq $Proc_Name;
	return;
}

sub filter_by_user ($Process_Table, $User_Name) {
	my $Owner = $Process_Table -> {euid};
	return $Process_Table -> {pid} if $Owner eq $User_Name;
	return;
}


my @PIDs_1 = map
		{filter_by_name($_, $Wanted_Proc_Name)}	@{$Processes->table};
my @PIDs_2 = map
		{filter_by_user($_, $User_Name)}				@{$Processes->table};

my @PIDs = duplicates (@PIDs_1, @PIDs_2);

my $Exec_Cmd = "alacritty msg create-window";
if ((scalar @PIDs) < 1) {
	$Exec_Cmd = "alacritty";
}

exec $Exec_Cmd;
