#!/usr/bin/perl
#======================================================= 
# GPA Calculator for EMCC.                               
# Written by Lloyd Turk.                                 
# Help from Nate Green and Brian Hodgins.                
# Feel free to optimize, change, and redistribute this   
# perl script.                                           
# Your school might have a different grading critira so  
# edit as you need to.                                   
#                                                        
# To calulte GPA multiply the number of credits for each 
# class by the grade for the class add all theproducts   
# up and divide by total number of credits.             
# GPA = [(NC x Grade)+(for each class)]/Total Credits.   
# NC = Number of credits.                                
#                                                        
# Letter Grade Values at EMCC.                           
# A  = 4.00 A- = 3.67 B+ = 3.33 B  = 3.00 B- = 2.67      
# C+ = 2.33 C  = 2.00 C- = 1.67 D  = 1.00 F  = 0.00
# Written under Slackware 13.      
#======================================================= 

use strict;
use warnings;
#============== Declare Variables ==============#
my $number_of_classes;

#===============================================#

print "How many classes are you taking?: "; 
       chomp($number_of_classes = <STDIN>; # Get number of classes from stdin.
       if($number_of_classes eq ""){usage();}; # If nothing is typed show usage.
       die "Invalid input\n" if $number_of_classes =~ /\D/; # Kills itself if $number_of_class is not a number.

# Apparently I never finished this lol
