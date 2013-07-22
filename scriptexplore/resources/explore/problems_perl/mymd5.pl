#!/usr/bin/env perl

# path = resources/explore/problems_perl

#echo "computing MD5 msg digest for files under dir's in rootfile.txt"
#<path>/mymd5.pl <path>/rootfile.txt <path>/md5file.txt

use 5.010; use warnings; use strict;
use English qw(-no_match_vars); use autodie;

die "Usage: mymd5.perl <rootfile.txt> [md5file.txt]\n" unless @ARGV >= 1;

my $notStdOut;

if (2 == @ARGV) {
	open(MD5FILE, "> $ARGV[1]") or die;
	$notStdOut = 1;
	pop( @ARGV );
}

while ( <ARGV> ) {
	chop( $_ );
	my @files = sort( `/usr/bin/find $_ -print` );
	chop( @files );
	@files = grep( -f, @files );
	
	foreach my $file ( @files ) {
		my $fgrPrt = `/usr/bin/md5sum $file` or warn;
		$fgrPrt =~ s/^([^ \t]+)[ ]+([^ \t\n]+)/$2\t$1/;
		print STDOUT "$fgrPrt" if !$notStdOut;
		print MD5FILE "$fgrPrt" if $notStdOut;
	}
}
