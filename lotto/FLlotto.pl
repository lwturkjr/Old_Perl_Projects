#!/usr/bin/env perl
#==============
# Random number generator for The Florida lottery.
# toast
# Will Generate 6 random numbers between 1 and 53 
# Written and tested under Slackware 14.0
# Based on Powerball.pl by toast
#==============================

use strict;
use warnings;

my $min = 1;

# This will generate 20 numbers remove any duplicates, then display 5 numbers.
my $range = 53; # Defines the range of numbers

# Generates the numbers
my @numbers = map {int(rand($range)) + $min } (1..20);

# Checks the array and removes any duplicates
my $i;
my %seen;
my @picks;
foreach $i (@numbers) {
push(@picks, $i) unless ($seen{$i}++);

}

# Print out the generated numbers.
print "Your numbers are:\n";

print join(" ", sort(@picks[0 .. 5])), "\n";

exit(0);
