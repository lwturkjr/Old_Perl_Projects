#!/usr/bin/perl

#==============================================================================
# Toast
# Robopenguin - A geneal purpose IRC (Internet Relay Chat) bot.
# Feel free to edit/redistribute this code
#
# This is a general purpose irc bot originally designed for entirtainment
# purposes but will eventually be able to perfom more advanced tasks such as 
# allowing remote access to your home computer via IRC.
#
# The Majority of this code was based off of sera-irc which is an IRC task bot
# created by Brian Hodgins to get the orginal sera-irc source code please see
# http://www.brianhodgins.com/projects/sera-irc
# =============================================================================

use warnings;
use strict;
use POE qw(Component::Client::TCP);

#==============-Settings-=============#

my %Irc = (
   version         => '0.1.1',
   port            => 6667,
   server          => '',
   nickname        => 'Robopenguin',
   username        => 'Robopenguin ',
   chans           => [''],
   debug           => 1, # 0 = none, 1 = verbose, 2 = everything
   privmsg         => \&irc_privmsg,
   hostname        => 0,
   servername      => 0,
   realname        => 'Robopenguin, Like Robocop only cooler.',
   nickname1       => 'Robopenguin1',
   trigger         => '!',
   mode            => '', # Automaticly set
   motd            => '', # Automaticly set
   buffer_enable   => 1,
   max_buffer      => 50,
);
my %access = (
   toast           => 'owner',
   toastytoast     => 'owner',
);

#=====================================#

#=============-Commands-==============#

our %Commands = (
   'rum'        =>\&cmd_rum,
   'get'        =>\&cmd_get,
   'getme'      =>\&cmd_getme,
   'whoami'     =>\&cmd_whoami,
   'commands'   =>\&cmd_commands,
   'whoareyou'  =>\&cmd_whoareyou,
   'flee'       =>\&irc_disconnect,
);
#====================================#

#=============-Misc-=================#

my $act = "\001ACTION";
my $srv_ref;
our @traffic_buffer;

#====================================#

# Create Socket then connect:
POE::Component::Client::TCP ->new (
   RemoteAddress => $Irc{server},
   RemotePort    => $Irc{port},
   Connected     => \&irc_connect,
   Disconnected  => \&irc_disconnect,
   ServerInput   => \&irc_input,
);

# Once successfully connected.
sub irc_connect {
	$srv_ref= $_[HEAP]{server};
	print "Connected to $Irc{server}\n";
	$_[HEAP]{server}->put("NICK $Irc{nickname}\n");
	print("Sent nickname $Irc{nickname}\n");
	$_[HEAP]{server}->put("USER $Irc{username} $Irc{hostname} $Irc{servername} $Irc{realname}\n");
	print("Sent username, hostname, servername, and realname\n");
}

# Incoming traffic comes here.
sub irc_input {
	my ($heap, $msg) = @_[HEAP, ARG0];
   # Debug:
	if(defined($Irc{debug})) {
		print "$msg\n";
	}   
   # Buffer:
	if($Irc{buffer_enable}) {
			if (@traffic_buffer == ($Irc{max_buffer} + 1)) {
				delete $traffic_buffer[0];
			}
			push (@traffic_buffer, $msg);
		}
   # For grabbing host info
	if ($Irc{host} = $msg =~ /^:[a-zA-Z][\.]+\s002\s$Irc{nickname}\s:.*\s([.a-zA-Z0-9]+),/ ) {
		printd("Host greeted us as $1\n");
	}

   # If Nick is already in use
	if ($msg =~ /^:.+\s433/ ) {
	# Respond with Alt. nick
	$heap->{server}->put("NICK $Irc{nickname1}\n");
	$Irc{nickname} = $Irc{nickname};
	printd("$Irc{nickname} is in use, will use $Irc{nickname1} instead.\n");
	}

   # Motd message, append to motd buffer:
	if ($msg =~ /$Irc{host}\s372\s$Irc{nickname}\s:-(.*)/ ) {
		$Irc{motd} .= "$1\n";
	}

   # End of motd, ready to join a channel:
	if ($msg =~ /$Irc{host}\s001\s$Irc{nickname}/ ) {
		
		foreach (@{$Irc{chans}}) {
			$heap->{server}->put("JOIN $_\n");
			print("Joining channels: $_\n");
		}
	}
   # Handle PING:
	if ($msg =~ /^PING\s(.*)/i ) {
		$heap->{server}->put("PONG $1\n");
		print("Ping reply: $1\n");
	}
     
	# PRIVMSG:
		if ( $msg =~ /^:(.+)!(.+)\@(.+)\sPRIVMSG\s(.+)\s:(.*)/i ) {
			my ($nick, $user, $host, $channel, $message) = ($1, $2, $3, $4, $5);
			printd("[$channel] <$nick> $message\n");
        # Is this a command?
		if ((my $command) = $message =~ /^$Irc{trigger}(.*)/ ) {
				my $cmd;
				my $params;
				if (($params) = $command =~ /\s(.*)/ ) {
			# Multipart command:
				$cmd = (split /\s/, $command)[0];
			} else {
				$cmd = $command;
			}
			if (defined($Commands{$cmd})) {
				if ($channel eq $Irc{nickname}) {
				# Is a private nick message, set the channel as their nick.
					$channel = $nick
				}
				if ($params) {
					$params =~ s/^\s+|\s+$//;
				}
				else {
					$params = '';
				}
				$Commands{$cmd}->($_[KERNEL], $_[HEAP], $_[SESSION], $nick, $user, $host, $channel, $params, $cmd);
			}
		}
	}
}

# Debugging messages

sub printd {
	# Just here to prevent repetition.
	my $msg = shift;
	if (defined($Irc{debug})) {
		print $msg;
	}
}

# Functionality

sub privmsg {
	my ($destination, $message) = @_;
	$srv_ref->put("PRIVMSG $destination :$message\n");    
}
  
sub irc_disconnect {
	my $nick = $_[3];
	my $chan = $_[6];
	# Checks to see if person telling it to quit is its owner or not
	if($access{$nick} ne 'owner'){
		# If isn't the owner owner respond
	privmsg($chan, "YOU'RE NOT MY MOMMY!!!!!\n"); # I thought it was funny.
}	
	# If it is owner then disconnect
	if ($access{$nick} eq 'owner'){
		die("Dissconnected from $Irc{server}\n");
	}
}

#==============-Commands-=============#

sub cmd_rum {
	my $nick = $_[3];
	my $chan = $_[6];
		 privmsg($chan, "$act Pours a shot of rum and passes it to $nick\001\n");
	}

sub cmd_get {
	my $what = $_[7];
	my $chan = $_[6];
		privmsg($chan, "$act Gets $what\001\n");
	}
sub cmd_getme {
	my $what = $_[7];
	my $nick = $_[3];
	my $chan = $_[6];
		privmsg($chan, "$act Gets $nick $what\001\n");
	}
	
sub cmd_whoami {
	my ($kernel, $heap, $session, $nick, $user, $host, $chan, $command) = @_;
		privmsg($chan, "You are $nick ($nick\@$host)");
	}

sub cmd_whoareyou {
	my $chan = $_[6];
		privmsg($chan, "I am Robopenguin, Like Robocop only cooler.\n");
	}

sub cmd_commands {
	my $chan = $_[3];
		privmsg($chan, "My Commands are !rum, !get, !getme, !whoareyou, and !commands\n");
	}

#=====================================#

POE::Kernel->run(); # Get everything started.
