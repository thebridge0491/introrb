#!/usr/bin/env perl

use 5.010; use warnings; use strict;
use English qw(-no_match_vars); use autodie;

use Data::Dumper;

$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

# <path> = resources/explore/simperl

sub simple01 {
  #"problem 01: print cmd-line arguments 1 per line"
  #<path>/maynard.pl 01 <path>/data01/arg[1 .. N]

  foreach my $dir ( @ARGV ) {
    print "$dir\n";
  }
}

sub simple02 {
  #"problem 02: print all lines read with line number, space, line"
  #<path>/maynard.pl 02 [<path>/data02/arg[1 .. N]]

  my $i = 1;
  while ( <> ) {
    print $i++," $_";
  }
}

sub simple03 {
  #"problem 03: print logins and names (gcos field) of password-format file"
  #<path>/maynard.pl 03 <path>/data03/arg[1 .. N]

  while ( <> ) {
    my @field = split(/:/,$_);
    print "$field[0]\t\t$field[4]\n";
  }
}

sub simple04 {
  #"problem 04: print logins and names (gcos field) of password-format file sorted"
  #<path>/maynard.pl 04 <path>/data03/arg[1 .. N]

  my @pwlines = <>;
  @pwlines = sort @pwlines;
  foreach my $line (@pwlines) {
    my @field = split(/:/,$line);
    print "$field[0]\t\t$field[4]\n";
  }
}

sub simple05 {
  #"problem 05: print all file/directory names in directory from cmd-line"
  #<path>/maynard.pl 05 <path>/data05

  my $dir = $ARGV[0];
  open(DIR,"/bin/ls $dir |") || die "Unable to open directory $ARGV[0]: $!\n";
  while ( <DIR> ) {
    print "$dir/$_";
  }
}

sub simple06 {
  #"problem 06: print all regular file names in directory from cmd-line"
  #<path>/maynard.pl 06 <path>/data05

  my $dir = $ARGV[0];
  open(DIR,"/bin/ls $dir |") || die "Unable to open directory $ARGV[0]: $!\n";
  while ( <DIR> ) {
    chop;
    if ( -f "$dir/$_" ) {
      print "$dir/$_", "\n";
    }
  }
}

sub simple07 {
  #"problem 07: print all directory names in directory from cmd-line"
  #<path>/maynard.pl 07 <path>/data05

  my $dir = $ARGV[0];
  open(DIR,"/bin/ls $dir |") || die "Unable to open directory $ARGV[0]: $!\n";
  while ( <DIR> ) {
    chop;
    if ( -d "$dir/$_" ) {
      print "$dir/$_", "\n";
    }
  }
}

sub simple08 {
  #"problem 08: print mv cmds to chg file extension fm "for" to "f""
  #<path>/maynard.pl 08 for f <path>/data08
  
  my $ext = $ARGV[0];
  my $next = $ARGV[1];
  my $dir = $ARGV[2];
  open(DIR,"/bin/ls $dir |") || die "Unable to open directory $ARGV[2]: $!\n";
  while ( my $old = <DIR> ) {
    chop $old;
    if ( -f "$dir/$old" ) {
      my $new = $old;
      if ( $new =~ s/\.$ext$/\.$next/ ) {
        print "mv $dir/$old $dir/$new\n";
      }
    }
  }
}

sub main {
  #print STDOUT $0; print STDOUT "\n";
  #print STDOUT @ARGV; print STDOUT "\n";
  #
  #foreach my $argX(($0, "\n", @ARGV)) {
  #  printf("%s", $argX);
  #}
  #printf("\n");
  #
  ##printf("%s\n", Dumper \@ARGV);
  #printf("%s\n%s\n\n", $0, join("", @ARGV));
  
  my $prob = $ARGV[0]; shift @ARGV;
  my $args = @ARGV;
  
  #eval("simple$prob($args)");
  my %switcher = (
    '01' => \&simple01,
    '02' => \&simple02,
    '03' => \&simple03,
    '04' => \&simple04,
    '05' => \&simple05,
    '06' => \&simple06,
    '07' => \&simple07,
    '08' => \&simple08
  );
  $switcher{$prob}->($args);
  
  0;
}


#if ('main' eq __PACKAGE__) {
#if ($PROGRAM_NAME eq __FILE__) {
unless (caller) {
  exit main();
}

__END__
