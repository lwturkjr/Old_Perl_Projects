#!/usr/bin/env perl

#===================================
# Made by: Toast
# Random Stat generater for d20 games
#===================================

use strict;
use warnings;

#Minimum stat that can be generated
my $min = 6;

#Generates numbers between 0 and 12 + minumum  will allow for no higher than 18
my $range = 13;

#Generate the numbers and add the $min to them will give between 6 and 18
my $number0 = int(rand($range)) + $min;
my $number1 = int(rand($range)) + $min;
my $number2 = int(rand($range)) + $min;
my $number3 = int(rand($range)) + $min;
my $number4 = int(rand($range)) + $min;
my $number5 = int(rand($range)) + $min;
my $number6 = int(rand($range)) + $min;
my $number7 = int(rand($range)) + $min;

#Print the stats with instrucitons
print "Get rid of the lowest two, and your stats are:\n";
print "$number0, $number1, $number2, $number3, $number4, $number5, $number6, $number7\n";

exit(0)
