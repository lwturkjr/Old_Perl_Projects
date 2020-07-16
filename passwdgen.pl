#!/usr/bin/env perl
#==================================================================
# Written by: Toast                                                
#                                                                  
# Name : passwdgen.pl                                              
#                                                                  
# Random password generator will let the user choose how long the  
# passwd will be if not specified it will default to 10 characters 
# Feel free to modify and redistribute this code                   
#                                                                  
# It will also print the MD5 Hash and SHA1 Hash of the password 
#
# You Need both Digest::MD5 and Digest::SHA1 to use this as is 
# to disable SHA1 comment out line 23, 48 and 49 
#                                                                  
# Written under Slackware GNU/Linux                  
#==================================================================

use strict;
use warnings;

#use Digest::MD5 qw(md5_hex);
#use Digest::SHA1 qw(sha1_hex);

my $passwd_length = $ARGV[0]  || 10; # If passward length is left blank then default to 10 chars.
die "Invalid input\n" if $passwd_length =~ /\D/;
# Kills itself if password length is not a number. 

if ( $passwd_length < 8 or $passwd_length > 50 ) { 
  die "Password to long or to short!\n";  
   # Kills itself if the password is shorter than 8 charecteres or longer than 50.
	# Less than 8 is short and easily cracked longer than 50 is hard to remember. 
	# If you really want to then just comment this section of code out.
} 


# All alphanumeric and punctuation characters
my @chars = map(chr, 33..126);
	
my $passwd; 
$passwd .= $chars[ int(rand @chars) ] for 1 .. $passwd_length; # Generate the password

print "Your new password is: $passwd\n"; # Prints the password

#my $md5_hash = md5_hex($passwd); # Generate the passwords MD5 hash
#print "The MD5 Hash is: $md5_hash\n"; # Prints the passwords MD5 hash

#my $sha1_hash = sha1_hex($passwd); # Generate the passwords SHA1 hash
#print "The SHA1 Hash is: $sha1_hash\n"; # Print the passwords SHA1 hash

exit(0);
