#!/usr/bin/perl

#    sera-irc - an Internet Relay Chat taskbot
#    copyright (C) Brian Hodgins, All Rights Reserved.

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use warnings;
use strict;
use POE qw(Component::Client::TCP);
use Data::Dumper;
#use Binary::ProtocolConstructor;
#use Module::Reload;

########### Settings ##################

my %Irc = (
    server	      => 'irc.freenode.net',
    port	      => 6667,
    nickname          => '',
    username          => ' ',
    password          => ' ',
    channels          => [''],
    debug             => 1, # 0 = none, 1 = verbose, 2 = everything
    privmsg           => \&irc_privmsg,
    hostname          => 0,
    servername        => 0,
    realname          => 'Sera, the loveable task bot.',
    nickname_         => 'Sera_',
    trigger           => '!',
    mode              => '', # Automaticly set
    motd              => '', # Automaticly set
    population        => {}, # Automaticly set
    pluginconfig      => 'plugins.conf',
    pluginsystem      => {}, # Automaticly set
    buffer_enabled    => 1,
    buffer_maxsize    => 50, # Maximum size of traffic buffer
    owners            => [],
    access_list       => {},
);

#######################################

############ Commands #################

our %Commands = (
    'whoami'       => \&cmd_whoami,
    #'eval'         => \&cmd_eval, # Dangerous!
    'plugins'      => \&cmd_pluginlist,
    'whoareyou'    => \&cmd_whoareyou,
    'reload'       => \&cmd_reload,
);

#######################################

############ MISC #####################

my $srv_ref;
our @traffic_buffer;

#######################################

##### Plugin pre-configuration ########

if (-e $Irc{pluginconfig}) {
    $Irc{pluginsystem}->{enabled} = 1;
}

if ($Irc{pluginsystem}->{enabled}) {
    open($Irc{pluginsystem}->{handle}, '<', $Irc{pluginconfig}) or die (
        "Can not manage to open $Irc{pluginconfig}: $!\n");
    # Read the configuration:
    my $filehandle = $Irc{pluginsystem}->{handle};
    while (my $line = <$filehandle>) {
        if ((my ($param, $value)) = $line =~ /^(.+):(.*)/ ) {
            if (-e $value) {            
                $Irc{pluginsystem}->{registry}->{$param} = $value;
                require($value);
		printd("Loaded plugin $param ($value)\n");
	    }
	}
    }
    close($Irc{pluginsystem}->{handle});
}

#######################################

# Create the socket and connect:
POE::Component::Client::TCP->new (
    RemoteAddress    => $Irc{server},
    RemotePort       => $Irc{port},
    Connected        => \&irc_connected,
    Disconnected     => \&irc_disconnected,
    ServerInput      => \&irc_incoming,
);


# When connected... this gets called.
sub irc_connected {
    $srv_ref= $_[HEAP]{server};
    print "Connected to $Irc{server}\n";
    $_[HEAP]{server}->put("PASS $Irc{password}\n");
    printd("Sent password (**censored)\n");
    $_[HEAP]{server}->put("NICK $Irc{nickname}\n");
    printd("Sent nickname ($Irc{nickname})\n");
    $_[HEAP]{server}->put("USER $Irc{username} $Irc{hostname} $Irc{servername} $Irc{realname}\n");
    printd("Sent username, hostname, servername, and realname\n");
}
	

# all incoming traffic comes here.
sub irc_incoming {
    my ($heap, $msg) = @_[HEAP, ARG0];
    # For the buffer:
    if($Irc{buffer_enabled}) {
        if (@traffic_buffer == ($Irc{buffer_maxsize} + 1)) {
            delete $traffic_buffer[0];
        }
        push (@traffic_buffer, $msg);
    }
    # Output traffic if debug is 2 or greater:
    if($Irc{debug} >= 2) {print "$msg\n";};
    # We should do nothing if there's no message output:
    unless ($msg) {return;};

    # For grabbing host info:
    if ($Irc{host} = $msg =~ /^:[a-zA-Z|\.]+\s002\s$Irc{nickname}\s:.*\s([.a-zA-Z0-9]+),/ ) {
        printd("Host greeted us as $1\n");
    }

    # If nickname already in use:
    if ( $msg =~ /^:.+\s433/ ) {
        # Respond with the backup:
	$heap->{server}->put("NICK $Irc{nickname_}\n");
	$Irc{nickname} = $Irc{nickname_};
	printd("$Irc{nickname} is in use, responded with new nickname $Irc{nickname_}\n");
    }

    # Motd message, append to motd buffer:
    if ($msg =~ /$Irc{host}\s372\s$Irc{nickname}\s:-(.*)/ ) {
        $Irc{motd} .= "$1\n";
    }

    # End of motd, ready to join a channel:
    if ($msg =~ /$Irc{host}\s376\s$Irc{nickname}/ ) {

        foreach (@{$Irc{channels}}) {
            $heap->{server}->put("JOIN $_\n");
            printd("Jointing channel: $_\n");
        }
    }

    # Handle PING:
    if ($msg =~ /^PING\s(.*)/i ) {
        $heap->{server}->put("PONG $1\n");
	printd("Ping reply: $1\n");
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

sub irc_disconnected {
    die("Disconncted from $Irc{server}\n");
}

# Functionality

sub privmsg {
    my ($destination, $message) = @_;
    $srv_ref->put("PRIVMSG $destination $message\n");    
}

# for debugging messages.
sub printd {
    # Just here to prevent repetition.
    my $msg = shift;
    if (defined($Irc{debug})) {
        print $msg;
    }
}


############# COMMANDS #################

sub cmd_whoami {
    my ($kernel, $heap, $session, $nick, $user, $host, $channel, $command) = @_;
    privmsg($channel, "PRIVMSG $channel You are $nick ($nick\@$host)");
}

sub cmd_whoareyou {
    my ($channel) = $_[6];
    privmsg($channel, "Just Sera, of course!");
}

sub cmd_eval {
    my $channel = $_[6];
    privmsg($channel, "Sorry, eval is currently disabled.");
}

sub cmd_reload {
    if (-e $Irc{pluginconfig}) {
        $Irc{pluginsystem}->{enabled} = 1;
    }
    if ($Irc{pluginsystem}->{enabled}) {
        open($Irc{pluginsystem}->{handle}, '<', $Irc{pluginconfig}) or die (
            "Can not manage to open $Irc{pluginconfig}: $!\n");
        # Read the configuration:
        my $filehandle = $Irc{pluginsystem}->{handle};
        while (my $line = <$filehandle>) {
            if ((my ($param, $value)) = $line =~ /^(.+):(.*)/ ) {
                if (-e $value) {            
                    $Irc{pluginsystem}->{registry}->{$param} = $value;
                    require($value);
	    	    printd("Loaded plugin $param ($value)\n");
	        }
	    }
        }
        close($Irc{pluginsystem}->{handle});
    }
    Module::Reload->check();
}

sub cmd_pluginlist {
    my $channel = $_[6];
    my $plugin_list;
    unless ($Irc{pluginsystem}{enabled}) {
        privmsg($channel, "Plugins are disabled.\n");
        return;
    }
    my %plugin_registry = %{$Irc{pluginsystem}{registry}};
    while (my ($key, $value) = each(%plugin_registry)) {
        $plugin_list .= "$key, ";
    }
    $plugin_list =~ s/,\s+$//; # Trim the end of the list.
    privmsg($channel, "Current registered plugins are: $plugin_list.");
}

########################################

POE::Kernel->run(); # Get everything started.
