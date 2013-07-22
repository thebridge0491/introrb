#!/usr/bin/env perl

# path = resources/explore/problems_perl

#echo "diff'g regular files between two directories"
#<path>/ddiff.pl -ds12 ../<path>/simperl/Dr_M_version ../<path>/perl/Dr_M_version > <path>/ddifffile.txt

use 5.010; use warnings; use strict;
use English qw(-no_match_vars); use autodie;

die "Usage: ddiff.perl [-ds12] <dirA> <dirB>\n" unless @ARGV >= 2;

if ( $ARGV[$#ARGV] =~ /^-/ || $ARGV[$#ARGV - 1] =~ /^-/ ) {
	die "Usage: ddiff.perl [-ds12] <dirA> <dirB> \
	with switch(s) preceding directories \
	ddiff.perl -ds12 dirA dirB   or \
	ddiff.perl -d -s -1 -2 dirA dirB\n";
}

my (%filesAR, %filesBR);

my $dirB = pop( @ARGV );
my $dirA = pop( @ARGV );
my $switchD = 1 if ((0 == @ARGV) || grep(/d/, @ARGV));
my $switchS = 1 if ((0 == @ARGV) || grep(/s/, @ARGV));
my $switch1 = 1 if ((0 == @ARGV) || grep(/1/, @ARGV));
my $switch2 = 1 if ((0 == @ARGV) || grep(/2/, @ARGV));

my @filesA = `/bin/ls -1 $dirA`;
my @filesB = `/bin/ls -1 $dirB`;
chop( @filesA );
chop( @filesB );

foreach my $file ( @filesA ) {
	if ( -f "$dirA/$file" ) {
		$filesAR{$file} = $file;
		$filesBR{$file} = "";
	}
}

foreach my $file ( @filesB ) {
	if ( -f "$dirB/$file" ) {
		$filesBR{$file} = $file;
		$filesAR{$file} = "" if !$filesAR{$file};
	}
}

foreach my $tester ( sort keys(%filesAR) ) {
	my $testA = "$dirA/$filesAR{$tester}" if $filesAR{$tester};
	my $testB = "$dirB/$filesBR{$tester}" if $filesBR{$tester};
	my $coexist = $filesAR{$tester} && $filesBR{$tester};
	
	print "<<< $tester\n" if $switch1 && !$filesBR{$tester};
	print ">>> $tester\n" if $switch2 && !$filesAR{$tester};
	
	if ($coexist) {
		my $isDiff = `/usr/bin/diff -q $testA $testB`;
		print "< $tester >\n" if $switchD && $isDiff;
		print "> $tester <\n" if $switchS && !$isDiff;
	}
}
