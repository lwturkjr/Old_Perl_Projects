#!/usr/bin/perl -w 
use SOAP::Lite; 

my $query = "perl"; 
my $googleSearch = SOAP::Lite -> service("http://api.google.com/GoogleSearch.wsdl"); 
my $result = $googleSearch -> doGoogleSearch( 
    "",     # password to access google 
    $query,                                 
    0,                                      # Fisrt result 
    10,                                     # Number of results 
    "false",                                # Filter 
    '',                                     # Restriction 
    "false",                                # Secure Search
    '',                                     # lr 
    'latin1',                               # ie 
    'latin1'                                # oe 
); 

print $result->{resultElements}->[0]->{title}; 
print "\n"; 
print $result->{resultElements}->[0]->{URL}; 
print "\n"; 

1;
