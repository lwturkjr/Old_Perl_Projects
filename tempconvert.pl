#!/usr/bin/perl
#===================================================#
# Temp converter         			    
# Written by: toast 			    
# This script is to convert a given temperature	       
# to and from either Celsius or Fahrentheit.	    
# Feel free to modify and improve upon this script. 
# As well feel free to redistribute this script.     
# Written under Slackware 12.2 tested and working!  
#===================================================#

use strict;
use warnings;
use Switch;
#=============== Declare Variables =================# 
my $temp;
my $scale;
my $output;
#================= Start Program ===================#
print "Enter F or C for Scale (F for farenheit C for celcius)";
print "Scale to convert to -> "; # Ask which scale to convert to.
	chomp($scale = lc <STDIN>); 
	# Get the scale to convert to from stdin and change the input to lowercase.

if (($scale ne "f") && ($scale ne "c")){usage();}; # If scale != c or f then print usage.
if ($scale eq "f" or $scale eq "c"){gettemp();}; # When scale does = f or c then gettemp.
sub gettemp{

	print "Temp to Convert -> "; # Ask for temp to convert.
		chomp ($temp = <STDIN>); # Get temp to be converted from stdin.
	
	if ($temp eq ""){usage();}; # If nothing is typed will show usage.
	die "Invalid temp" if $temp =~ /\D/; # Kill itself if temp is not numeric.

}

# This is where the actaul conversion happens
switch ($scale) {
	case 'f' {$output = ($temp * 1.8) + 32;} # Convert to F using the formula.
	case 'c' {$output = ($temp - 32) * (5/9);} # Convert to C using the formula.
}

# This explains how the script is to be used.
sub usage {
	print "\nTemp Converter\n";
	print "Usage \n";
	print " perl tempconvert.pl\n";
	print " Scale to convert to -> <scale (F or f for farenheit C or c for celcius)>\n";
	print " Temp to Convert -> <temp to convert>";
	print " So if you enter F in the scale section and 21 in the tempuratre section it will convert 21C to 69.8F\n\n"; 
	exit (0);
}

print "Converted -> $output\n"; # Print the converted temp.
exit(0);
