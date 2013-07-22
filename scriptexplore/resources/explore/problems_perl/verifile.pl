#!/usr/bin/env perl

# path = resources/explore/problems_perl

#echo "verifying new MD5 msg digest for files under dir's in rootfile.txt"
#echo "against MD5 msg digest list in md5file.txt"
#<path>/verifile.pl <path>/rootfile.txt <path>/md5file.txt > <path>/verifile.txt

use 5.010; use warnings; use strict;
use English qw(-no_match_vars); use autodie;

die "Usage: verifile.perl <rootfile.txt> <md5file.txt>\n" unless @ARGV == 2;

my ($file, $fgrPrt, %curFiles, %priorFiles, $tester);

open(MD5FILE, "$ARGV[1]") or die;
pop( @ARGV );

while ( <ARGV> ) {
	chop( $_ );
	my @files = sort( `/usr/bin/find $_ -print` );
	chop( @files );
	@files = grep( -f, @files );
	
	foreach $file ( @files ) {
		$fgrPrt = `/usr/bin/md5sum $file` or warn;
		chop( $fgrPrt );
		$fgrPrt =~ s/^([^ \t]+)[ ]+([^ \t]+)/$2 $1/;
		$curFiles{$file} = $fgrPrt;
		$priorFiles{$file} = "";
	}
}

while ( <MD5FILE> ) {
	chop( $_ );
	$file = $_;
	$_ =~ s/[\t]+/ /;
	$file =~ s/^([^ \t]+)[ ]*.+/$1/;
	$priorFiles{$file} = $_;
	$curFiles{$file} = "" if !$curFiles{$file};
}

foreach $tester ( sort keys(%curFiles) ) {
	if (!($priorFiles{$tester} && $curFiles{$tester})) {
		print "<old>$priorFiles{$tester}\n\n" if $priorFiles{$tester};
		print "<new>$curFiles{$tester}\n\n" if $curFiles{$tester};
	} elsif ($priorFiles{$tester} ne $curFiles{$tester}) {
		print "<old>$priorFiles{$tester}\n";
		print "<new>$curFiles{$tester}\n\n";
	}
}
