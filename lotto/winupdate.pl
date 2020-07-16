#!/usr/bin/env perl

#=================================
# A perl script to compliment
# pbhist2012.pl this will update
# powerball history from the rule
# change of 2012.
# By: toast
#=================================

use warnings;
use strict;
use Tie::File;
use LWP::Simple;

# Download the newest Powerball Numbers
getstore('http://www.powerball.com/powerball/winnums-text.txt', 'winnums.txt') 
   or die 'Unable to get page';

# Remove the first line of the file.
my @array;
tie @array, 'Tie::File', 'winnums.txt' or die $!;
shift @array;
untie @array;
