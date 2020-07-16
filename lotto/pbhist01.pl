#!/usr/bin/env perl
# originally from http://www.perlmonks.org/
#  Powerball Frequency Analyzer
#   by chromatic (Bishop)
# originally based upon old pbhist.txt
# updated to current history 
# also run current "winnums-text.txt" format with no header line
#             with draws since last rule change in 1/15/12
#             toast Updated and tested 11/27/12 
# 
use strict;
use warnings;
use LWP::Simple;

my (@numbers, %normals, %powerb);

my $content;

# This pulls from all the numbers drawm from the beggining of the game.
#unless (defined ($content = get('http://www.powerball.com/powerball/winnums-text.txt'))) {
#    die "Cannot get PB history.\n";
#}

# If you want to make your own file with a certain range of dates you can un-comment this
# make sure the file name is correct and you might need to change it if you're on windows
unless (defined ($content = get('file:./winnums.txt'))) {
   die "Cannot get PB history.\n";
}

@numbers = split /\n/, $content;

my @data;

foreach my $line (@numbers) {
    next if ($line =~ /^!/);
    @data = split(/\s+/, $line);
    shift @data;        # throw away the date
    @data = reverse(@data);
    shift @data if ( @data > 6); #discard power play number.
    my $pb = shift @data;

    $powerb{$pb}++; 

    foreach (@data) {
        $normals{$_}++;
    }
}

my @norm_sort = sort { $normals{$a} <=> $normals{$b} } keys %normals;
my @pb_sort = sort { $powerb{$a} <=> $powerb{$b} } keys %powerb;

print "\nWhite Balls --\n";
#print "@norm_sort\n";
print "Cold Picks:\t";
print join(" ", @norm_sort[0 .. 4]), "\n"; #These had to be changed from the orginal becuase of how I formated the text file
print " Mid Picks:\t";
print join(" ", @norm_sort[25 .. 29]), "\n";
print " Hot Picks:\t";
print join(" ", @norm_sort[54 .. 58]), "\n";

print "\nPowerBalls --\n";
print "@pb_sort\n";
print "Cold Picks:\t";
print join(" ", sort (@pb_sort[0 .. 2])), "\n"; #These had to be changed from the orginal becuase of how i formated the text file
#print " Mid Picks:\t";
#print join(" ", sort (@pb_sort[18 .. 20])), "\n";
#print " Hot Picks:\t";
#print join(" ", sort (@pb_sort[28 .. 30])), "\n";

print "\nDisclaimer:\t
This is not statistically accurate, except in that the drawings are guaranteed.
This is just a quick frequency analysis making no pretenses as to predictive accuracy.\n";
