package CSI::Rand;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
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
