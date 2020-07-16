#!/usr/bin/env perl
#=================
# basic Reading of a file
#=================

use warnings;
use strict;

open (FILE, "test.txt") or die $!;

while (<FILE>) {
chomp;
print "$_\n";
}
close (FILE);

exit(0);
