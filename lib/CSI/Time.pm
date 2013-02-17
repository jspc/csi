package CSI::Time;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw( time_time time_date time_epoch time_sleep );
our $VERSION = '1.00';

our @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
our @week_days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

sub time_meta {
    # Essentially return either the date as a string or the time as a string
    # Based upon the first arg passed to the subroutine.
    
    my $which = shift( @_ );
    
    my ( $second, $minute, $hour, $month_day, $month, $year, $week_day, $year_day, $daylight_savings ) = localtime();
    $year = 1900 + $year;
    
    my $date = "$week_days[ $week_day ] $months[$month] $month_day, $year";
    my $time = "$hour:$minute:$second";
    
    if ( $which eq "date" ){
	return "$date\n";
    } else {
	return "$time\n";
    }
}

sub time_date {
    # Return the date from time_meta
    
    return time_meta( "date" );
}


sub time_time {
    # Return the time from time_meta
    
    return time_meta( "time" );
}


sub time_epoch {
    # Return the time as expressed as seconds past the epoch
    
    my $tim = time();
    return "$tim\n";
}

sub time_sleep {
    # Sleep for the time set in $sleep and then return
    # If it works, an ingenius method, but will be interesting to see what happens
    # If multiple scripts are calling sleep
    
    my ($contents, $off) = @_;
    
    if ( defined $contents && int( $contents ) ){
	sleep $contents;
    } else {
	return "When you write an integer to this file it blocks for that amount of seconds.\n";
    }
}

1;
