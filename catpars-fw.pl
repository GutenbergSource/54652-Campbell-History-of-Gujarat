# catpars.pl -- remove line-breaks in paragraphs.

use strict;

my $infile = $ARGV[0];
open(INPUTFILE, $infile) || die("Could not open input file $infile");

my $mode = "normal";    # normal | concat | fw

while (<INPUTFILE>) {
    my $line = $_;
    if ($mode eq "normal") {
        if ($line =~ /^(<pb\b([^>]*)>)?<p\b([^>]*)><fw\b([^>]*)>/) {
            print $line;
            $mode = "fw";
        } elsif ($line =~ /^(<pb\b([^>]*)>)?(<q\b([^>]*)>)?<p\b([^>]*)>/) {
            print stripNewline($line);
            $mode = "concat";
        } else {
            print $line;
        }
    } elsif ($mode eq "concat") {
        if ($line =~ /^(<pb\b([^>]*)>)?<p\b([^>]*)>/) {
            print "\n\n";
            print stripNewline($line);
        } elsif ($line =~ /^\s$/) {
            $mode = "normal";
            print "\n" . $line;
        } elsif ($line =~ /<fw\b([^>]*)>/) {
            $mode = "fw";
            print $line;
        } else {
            print stripNewline($line);
        }
    } elsif ($mode eq "fw") {
        if ($line =~ /<\/fw\b([^>]*)>/) {
            print stripNewline($line);
            $mode = "concat";
        } else {
            print $line;
        }
    }
}


sub stripNewline($) {
    my $str = shift;
    $str =~ s/\n/ /g;
    return $str;
}
