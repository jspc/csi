package CSI::Time;

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
__END__


=head1 NAME

Time - Perl/Fuse extension to handle the /time/ subdir in the Common Scripting Interface

=head1 SYNOPSIS

  use CSI::Time;
  print time_date();   # Prints Date in ASCII
  print time_time();   # C'mon now...
  print time_epoch();  # Seconds since the epoch

  # When a write() is called on $CSI_DIR/time/sleep time_sleep()
  #	returns after the specified number of seconds. read(), however...

  print time_sleep();
  # When you write an integer to this file it blocks for that amount of seconds.\n

=head1 DESCRIPTION

CSI::Time contains a couple of basic methods for the $CSI_DIR/time/ directory under the Common Scripting Interface.
Most of these are mainly calls to other modules, but are all kept in here and seperate for later expansion and tidyness. 
This may seem pointless, but it can only help.

=head2 METHODS

=item * time_date()
=item * time_time()
=item * time_epoch()
=item * time_sleep()


=head1 SEE ALSO

Relevant pages on sleep() and, of course, whatever helps you understand the epoch

=head1 AUTHOR

James Condron, E<lt>james@jamescondron.co.uk<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by James Condron

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
