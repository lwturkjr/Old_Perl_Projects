#!/usr/bin/env perl
#============
# Random number gen
# toast
# A random number gen for rp dice d20 etc.
#==========================

use strict;
use warnings;

my $min = 1; # Set min Range.
my $rangemax = 100; # Set max Range.

# Show usage if left blank.
if ($#ARGV == -1) {usage();}; 

# Tell it what the range will be.
my $range = $ARGV[0]; 

# Tell how many to roll
my $number_of_dice = $ARGV[1];

# If letter is entered as range show error and exit.
die "Enter a number!\n" if $range =~ /\D/;

# If Range is 0 show error and exit.
if ($range == 0) {range();}; 

# If range is greater than max range show error
if ($range > $rangemax) {range();}; 

my $roll = int(rand($range)) + $min;

print "You Rolled a $roll\n";


sub range {
	print "Please enter a number 1 and 100\n";
	exit(0);
}
sub usage {
	print "Dice By: \n";
	print "\t perl dice.pl (number of sides on dice).\n";
	print "\t The number of sides can be between 1 and 100.\n";
	print "\t Syntax is simple for a d20 do perl dice.pl 20.\n";
	print "\t Which will generate a random number between 1 and 20.\n";
	print "\t Have fun.\n";
	exit(0);
}	
