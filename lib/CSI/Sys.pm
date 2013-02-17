package CSI::Sys;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Time ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
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
__END__


=head1 NAME

Sys - Perl/Fuse extension to handle the /sys/ subdir in the Common Scripting Interface

=head1 SYNOPSIS

  use CSI::Sys;

  print sys_kern();
  print sys_devnull();
  print sys_separator();
  print sys_boottime();
  print sys_bits();

=head1 DESCRIPTION

CSI::Sys is a very tiny little information pool about the current kernel and OS we're running on. It has several uses in many
scripts and so it has been included here in CSI.


=head2 METHODS

=over 4

=item * sys_kern()
	Returns a kernel string similar to uname -a

=item * sys_devnull()
	Returns the location of the bit bucket

=item * sys_separator()
	Returns the character used to separate paths. Or... at least it tries to, it makes an educated guess is better

=item * sys_boottime()
	Does nothing at the moment, should return a string to help with uptime, but I'm too lazy to do it properly

=item * sys_bits()
	Returns whether or not the kernel is running 32bit or 64bit. This one is a tad sketchy, as architectures fade in and
	out of obscurity this may become an obsolete way of doing it. It also assumes that if you're not 32bit, you're 64 at the moment.


=head1 SEE ALSO

We've started to encroach on both /proc/ and /sys/ here. Look at those, learn them, love them.

=head1 AUTHOR

James Condron, E<lt>james@jamescondron.co.uk<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by James Condron

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
