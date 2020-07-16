#!/usr/bin/env perl
#==============
# Random number generator for Megabucks plus lottery.
# Lloyd Turk
# A random number generator for playing megabucks plus.
# Will Generate 5 random numbers between 1 and 41 and then 1 number 
# between 1 and 6 for the megaball.
# Written under and tested Slackware 13.37
#==============================

use strict;
use warnings;

my $min = 1;

# This will generate 10 numbers remove any duplicates, then display 5 numbers.
my $range = 41;

# Generates the numbers
my $number0 = int(rand($range)) + $min;
my $number1 = int(rand($range)) + $min;
my $number2 = int(rand($range)) + $min;
my $number3 = int(rand($range)) + $min;
my $number4 = int(rand($range)) + $min;
my $number5 = int(rand($range)) + $min;
my $number6 = int(rand($range)) + $min;
my $number7 = int(rand($range)) + $min;
my $number8 = int(rand($range)) + $min;
my $number9 = int(rand($range)) + $min;

# places the numbers in an array
my @picks = (
      $number0, 
      $number1, 
      $number2, 
      $number3, 
      $number4, 
      $number5, 
      $number6, 
      $number7, 
      $number8, 
      $number9
   );

# Checks the array and removes any duplicates
my $i;
my %seen;
my @nodupes;
foreach $i (@picks) {
push(@nodupes, $i) unless ($seen{$i}++);

}

# Defines the numbers to be printed
@picks=@nodupes;
splice @picks, 5, 10;

# Generate the number for the Megaball
my $mega_range = 6;

my $megaball = int(rand($mega_range)) + $min;

# Print out the generated numbers.
print "Your numbers are:\n";
print "@picks Megaball: $megaball\n";

exit(0)
