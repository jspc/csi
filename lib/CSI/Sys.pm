package CSI::Sys;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw( sys_kern sys_devnull sys_separator sys_boottime sys_bits );
our $VERSION = '1.00';

use POSIX;
use File::Spec;
use Switch;

our $osver = $^O;

sub sys_kern {
    # Much the same as the uname command. Specifically uname -a.
    # Going to misappropriate Config module here and hope that
    # no problems arise.
    
    my ($sysname, $nodename, $release, $version, $machine) = uname();
    return "$nodename $sysname-$release, $version $machine\n";
} 


sub sys_devnull {
    # Return the location of the bit-bucket. Useful to have when needed.
    
    my $dn = File::Spec->devnull();
    return "$dn\n";
}


sub sys_separator {
    # Return the separator on the system, be it '/', '\', '//' or whatever
    # FIXME: Make sure we've covered all we'll need
    
    my @unix = qw( aix bsdos freebsd linux hpux openbsd sunos solaris netbsd ); 
    my @dos = qw( dos MSWin32 );
    my @mac = qw( MacOS );
    switch ($osver) {
	case (\@unix)   { return "/ \n" }
	case (\@dos)    { return "\\ \n" }
	case (\@mac)    { return ": \n" }
    }
}


sub sys_boottime {
    # Return the epoch time from when the machine booted up
    # TODO: Is this better being left in the capable hands of /proc/stat?
    
    return "Time of boot not yet implemented\n";
}


sub sys_bits {
    # Return the 'bits' number; ie: 16/32/64
    # FIXME: Got them all? Too simplistic?
    
    my $kern = &sys_kern;
    my @splat = split( " ", $kern );
    $kern = $splat[-1];
    
    my @thirtytwo = qw( i386 i686 i486 i586 arm armeb armel m32r m68k powerpc s390 sh3 sh3eb sh4 sh4eb );
    
    switch ($kern) {
	case (\@thirtytwo)   { return "32\n" }
	else                 { return "64\n" }
    }
}

1;
