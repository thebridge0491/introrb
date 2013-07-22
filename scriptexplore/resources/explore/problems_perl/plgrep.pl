#!/usr/bin/env perl

# path = resources/explore/problems_perl

#echo "grep'g for regexp in regular files in file list and under dir's in list"
#<path>/plgrep.pl -l 'ba+d' ../<path>/perl/data06/filea ../<path>/perl/data06/dir1 ../<path>/perl/data06/fileb > <path>/plgrepfile.txt

use 5.010; use warnings; use strict;
use English qw(-no_match_vars); use autodie;

die "Usage: plgrep.perl [-l] <'pregexp'> <file dir list>\n" unless @ARGV >= 2;

my $switchL = shift( @ARGV ) if ("-l" eq $ARGV[0]);
my $exp1 = shift ( @ARGV );

my (@files);

foreach my $path ( @ARGV ) {
	if (-d $path) {
		my @dirFiles = `/usr/bin/find $path -print`;
		chop( @dirFiles );
		
		my @dirRFiles = grep( -f, @dirFiles );
		push( @files, @dirRFiles );
	} elsif ( -f $path ) {
		push( @files, $path );
	}
}

foreach my $file ( @files ) {
	my $notDone = 1;
	open(FILE, (!-T $file ? "/usr/bin/strings $file |" : $file)) or warn;
	
	while ( $notDone && ($_ = <FILE>) ) {
		if ( /$exp1/ ) {
			print "$file" . (!$switchL ? ":$_" : "\n");
			$notDone = 0 if $switchL;
		}
	}
}
