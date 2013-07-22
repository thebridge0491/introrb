#!/usr/bin/env perl

use 5.010; use warnings; use strict;
use English qw(-no_match_vars); use autodie;

use Data::Dumper;

$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

# <path> = resources/explore/perl

sub advanced01 {
  #"problem 01: interleave the lines of two files"
  #<path>/maynard.pl 01 <path>/data01/arg[1 .. 2]
  
  my $usage_str = "Usage: $0 <file1> <file2>\n";
  die $usage_str unless 2 == @ARGV;
  
	open(INFILE1,"$ARGV[0]") || die "Unable to open $ARGV[0]: $!\n";
	open(INFILE2,"$ARGV[1]") || die "Unable to open $ARGV[1]: $!\n";

	my $line1 = <INFILE1>;
	my $line2 = <INFILE2>;
	while ( $line1 || $line2 ) {
	  print $line1, $line2;
	  $line1 = <INFILE1>;
	  $line2 = <INFILE2>;
	}
}

sub advanced02 {
  #"problem 02: grep for regexp in list of files fm cmd-line"
  #<path>/maynard.pl 02 'ba+d' <path>/data02/arg[1 .. N]

  my $rexp = shift @ARGV;

  while ( <> ) {
    if ( /$rexp/ ) {
      print "$ARGV:$_";
    }
  }
}

sub advanced03 {
  #"problem 03: concatenate all files whose names given in files fm cmd-line"
  #<path>/maynard.pl 03 <path>/data03/arg[1 .. N]

  while ( my $filename = <> ) {
    open(FILES,$filename) || die "Unable to open $filename: $!\n";
    while ( <FILES> ) {
      print;
    }
    close(FILES);
  }
}

sub advanced04 {
  #"problem 04: locate all core files in directories fm cmd-line"
  #<path>/maynard.pl 04 <path>/data04/{a,b,a/d}

  while ( my $dir = shift @ARGV ) {
    open(CORES,"/usr/bin/find $dir -name core -print |") || die "Unable to execute find: $!\n";
    while ( <CORES> ) {
      print "rm $_";
    }
  }

  # Alternate loop solution
  #
  #while ( my $dir = shift @ARGV ) {
  #  my @cores = `find $dir -name core -print`;
  #  while ( my $file = shift @cores ) {
  #    print "rm $file";
  #  }
  #}
  #
  #
  # Alternate list solution
  #
  # my @cores = `find @ARGV -name core -print`;
  # @cores = grep(s/^/rm /,@cores);
  # print @cores;
}

sub advanced05 {
  #"problem 05: locate all core files in directories fm file fm cmd-line"
  #<path>/maynard.pl 05 <path>/data05/dirs

  while ( <> ) {
    chop;
    open(CORES,"/usr/bin/find $_ -name core -print |") || die "Unable to execute find: $!\n";
    while ( my $file = <CORES> ) {
      print "rm $file";
    }
  }
}

sub advanced06 {
  #"problem 06: grep f/all occur's of regexp fm cmd-line in all text files"
  #<path>/maynard.pl 06 'ba+d' <path>/data06

  my $rexp = shift @ARGV;
  open(FILES,"/bin/ls $ARGV[0] |") || die "Unable to execute ls: $!\n";
  while ( my $file = <FILES> ) {
    $file = $ARGV[0] . "/" . $file;
    chop $file;
    if ( -f $file && -T $file ) {
      open(LINES,"$file") || die "Unable to open $file: $!\n";
      while ( <LINES> ) {
        if ( /$rexp/ ) {
          print "$file:$_";
        }
      }
    }
  }
}

sub advanced07 {
  #"problem 07: print mv cmds to chg basename for a set of files fm cmd-line"
  #<path>/maynard.pl 07 solar <path>/data07/data.*

  use File::Basename;

  my $newbase = shift @ARGV;
  while ( my $pathname = shift @ARGV ) {
    my ($name, $path, $ext) = fileparse($pathname,'\..*');
    my $newname = $name;
    $newname =~ s/^$name/$newbase/;
    if ( $path eq "." ) {
      print "mv $name$ext $newname$ext\n";
    } else {
      print "mv $path$name$ext $path$newname$ext\n";
    }
  }
}

sub advanced08 {
  #"problem 08: print cmds to list users of sendmail (possible spammers)"
  #<path>/maynard.pl 08 <path>/data08

  while ( <> ) {
    if ( /^root\s+(\d+) .+ sendmail: \w+ (\S+).: user open/ ) {
    print "$2   $1\n";
    }
    if ( /^root\s+(\d+) .+ sendmail: server (\S+@)?(\S+)/ ) {
    print "$3   $1\n";
    }
  }
}

sub advanced09 {
  #"problem 09: print user names in each event with quotes in ISP file"
  #<path>/maynard.pl 09 <path>/data09

  my @events = <>;
  my @users = grep(s/^\s+User-Name = //,@events);
  print @users;
}

sub advanced10 {
  #"problem 10: print user names in each event without quotes in ISP file"
  #<path>/maynard.pl 10 <path>/data10

  my @events = <>;
  my @users = grep(s/^\s+User-Name = //,@events);
  @users = grep(s/"//g,@users);
  print @users;
}

sub advanced11 {
  #"problem 11: compute total user minutes in ISP file"
  #<path>/maynard.pl 11 <path>/data11
  
  my $time = 0;
  while ( <> ) {
    if ( /Acct-Session-Time = (\d+)/ ) {
      $time += $1;
    }
  }

  print "Total User Session Time = $time\n";
}

sub advanced12 {
  #"problem 12: print number of connections with designated connect rates"
  #<path>/maynard.pl 12 <path>/data12

  my $conn144 = my $conn192 = my $conn288 = my $conn336 = my $conngt = 0;
  while ( <> ) {
    if ( /Ascend-Data-Rate = (\d+)/ ) {
      if ( $1 <= 14400 ) {
        $conn144++;
      } elsif ( $1 <= 19200 ) {
        $conn192++;
      } elsif ( $1 <= 28800 ) {
        $conn288++;
      } elsif ( $1 <= 33600 ) {
        $conn336++;
      } else {
        $conngt++;
      }
    }
  }

  print "0-14400\t\t$conn144\n";
  print "14401-19200\t$conn192\n";
  print "19201-28800\t$conn288\n";
  print "28801-33600\t$conn336\n";
  print "above 33600\t$conngt\n";
}

sub advanced13 {
  #"problem 13: print total input and output bandwidth usage in packets"
  #<path>/maynard.pl 13 <path>/data13
  
  my $input = my $output = 0;
  while ( <> ) {
    if ( /Acct-Input-Packets = (\d+)/ ) {
      $input += $1;
    }
    if ( /Acct-Output-Packets = (\d+)/ ) {
      $output += $1;
    }
  }

  print "Total Input Bandwidth Usage  = $input packets\n";
  print "Total Output Bandwidth Usage = $output packets\n";
}

sub advanced14 {
  #"problem 14: print ???"
  #<path>/maynard.pl 14 <path>/data14
  
  print "UNDEFINED solution\n";
}

sub advanced15 {
  #"problem 15: ???"
  #<path>/maynard.pl 15 <path>/data15
  
  print "UNDEFINED solution\n";
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
  
  #eval("advanced$prob($args)");
  my %switcher = (
    '01' => \&advanced01,
    '02' => \&advanced02,
    '03' => \&advanced03,
    '04' => \&advanced04,
    '05' => \&advanced05,
    '06' => \&advanced06,
    '07' => \&advanced07,
    '08' => \&advanced08,
    '09' => \&advanced09,
    '10' => \&advanced10,
    '11' => \&advanced11,
    '12' => \&advanced12,
    '13' => \&advanced13,
    '14' => \&advanced14,
    '15' => \&advanced15
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
