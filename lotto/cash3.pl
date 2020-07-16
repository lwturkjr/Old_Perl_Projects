#!/usr/bin/env perl
#=========================#
# Random Number Generation# 
# for FL Lotto Ca$h3      #
#=========================#

# This will Generate 3 numbers with duplicates
# That is how Ca$h3 works it's kinda neat

my $range=9;

# Generate the numbers
my @numbers = map {int(rand($range))} (1..3);


# Print out generated numbers
print "Your numbers are:\n";

print join(" ", sort(@numbers[0 .. 2]));
print "\n";

exit(0);
