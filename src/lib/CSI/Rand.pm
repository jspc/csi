package CSI::Rand;

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
our @EXPORT = qw( rand_range rand_max );
our $VERSION = '1.00';

our $rand = 100;

sub rand_range {
	# Either set the 'range' value, or return a random number
	# Hopefully.

    my ($val, $off) = @_;

    if (defined $val ){
		if ( int( $val ) ){
			$rand = $val;
		}
		return "1\n";
	}
	my $r = int( rand( $rand ) );
	return "$r\n";
}


sub rand_max {
	# Return a random number from 0 to 4,294,967,295
	# Which is the max an unsigned integer can be, fyi

	my $r = int( rand( 4294967295 ) );
	return "$r\n";
}	



1;
__END__


=head1 NAME

Rand - Perl/Fuse extension to handle the /rand/ subdir in the Common Scripting Interface

=head1 SYNOPSIS

  use CSI::Rand;

  print rand_max();   # Returns a random number from 0 - 4,294,967,295

=head1 DESCRIPTION

CSI::Rand handles returning random integers. It can either handle from a preset number (4,294,967,295 - unsigned 32bit integer)
or from a user input number, via the file /rand/range

=head2 METHODS

=item * rand_max()
=item * rand_range()
	When an integer is written to this file the user maximum is set. This essentially means that when the file is read a 
	random integer from 0 to this number is returned. So if I were to write the number 25 to this file, and read would return an int
	between 0 and 25. (Until I set a new number). The default is 100 or so.


=head1 SEE ALSO

Perldocs for rand, since we're essentially using this.

=head1 AUTHOR

James Condron, E<lt>james@jamescondron.co.uk<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by James Condron

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
