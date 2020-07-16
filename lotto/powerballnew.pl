#!/usr/bin/env perl
#==============
# Random number generator for Powerball lottery.
# toast
# Will Generate 5 random numbers between 1 and 59 and then 1 number 
# between 1 and 35 for the powerball.
# Written and tested under Slackware 13.37
#==============================

use strict;
use warnings;

my $min = 1;

# This will generate 20 numbers remove any duplicates, then display 5 numbers.
my $range = 59; # Defines the range of numbers

# Generates the numbers
my @numbers = map {int(rand($range)) + $min } (1..20);

# Checks the array and removes any duplicates
my $i;
my %seen;
my @picks;
foreach $i (@numbers) {
push(@picks, $i) unless ($seen{$i}++);

}

# Generate the number for the Powerball
my $power_range = 35;

my $powerball = int(rand($power_range)) + $min;

# Print out the generated numbers.
print "Your numbers are:\n";

print join(" ", sort(@picks[0 .. 4])), " Powerball: $powerball\n";

exit(0);
