package CSI::FS;

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
our @EXPORT = qw( determine_df fs_free  );
our $VERSION = '1.00';

use Filesys::DiskSpace;


sub determine_df {
	# Return a hashref of the FS stuff. This run at the
	# Start of the program and determines what mounts are where.
	# It means we're not working it out every time

	my $fs_hash = {};
	my ($fs_type, $fs_desc, $used, $avail, $fused, $favail);

	open MTAB, "/etc/mtab";
	while (<MTAB>) {
		my @line = split " ", $_;
		my $device = $line[0];
		my $point = $line[1];
		my $san = $point;

		if ( $point eq "/" ){
			$san = "root";
		} else {
			$san =~ s/\//_/g;
			$san = substr $san, 1;
		}

		eval {
			($fs_type, $fs_desc, $used, $avail, $fused, $favail) = df $point;
		};
		if ($@) {
			# If its broken we'll just lie, or work it out
			$fs_type = "Unknown";
			$fs_desc = $line[2];
			$used = 0;
			$avail = 0;
		}
									# Yes, I'm using anon methods and not coderefs.
									# Fuse::Simple and Fuse have their own way on handling
									# coderefs and what they're passed. This interferes somewhat
		my $tmp_fs = { "free"     => sub { return fs_free( "$point", "free" ) },
                       "used"     => sub { return fs_free( "$point", "used" ) },
                       "type"     => sub { return "$line[2]\n" },  # Use from mtab, df under fuse just  keeps reporting fusctrl
                       "device"   => sub { return "$device\n" },
                       "point"    => sub { return "$point\n" }, 
					 };
		$fs_hash->{ $san } = $tmp_fs;
	}
	close MTAB;
	return $fs_hash;
}

sub fs_free {
	# Return the amount of free space from the mountpoint given

	my $point = shift(@_);
	my $which = shift(@_);

	my ($fs_type, $fs_desc, $used, $avail, $fused, $favail);

	eval {
		($fs_type, $fs_desc, $used, $avail, $fused, $favail) = df $point;
	};
	if ($@) {
		$avail = 0;
		$used = 0;
	}

	if ( $which eq "free" ){
		return "$avail\n";
	} else {
		return "$used\n";
	}
}

1;
__END__


=head1 NAME

FS - Perl/Fuse extension to handle the /fs/ subdir in the Common Scripting Interface

=head1 SYNOPSIS

  use CSI::FS;

  my $filesystems_hashref = determine_df()
  print "Free space of mountpoint $mountpoint is " . fs_free( $mountpoint, "free" );
  print "Used space of mountpoint $mountpoint is " . fs_free( $mountpoint, "used" );

=head1 DESCRIPTION

CSI::FS is more or less a text based version of df; it returns everything needs in a very nice and neat little selection
of hashrefs that Fuse and Fuse::Simple will find very useful.

=head2 METHODS

=item * fs_free( mountpoint, [free|used] )
	Given mountpoint return the free space/ used space (in kb) as specified.

=item * determine_df()
	Reads /etc/mtab line by line, and for each mounted system creates a hashref (which in fuse is treated as a directory)
	containing an anonymous method to determine free space, another to determine used space, and then others to return 
	the Filesystem type, the device/file mounted and the properly formatted mount point. These are all treated as files.

	Essentially, we've just created /proc/ crossed with df


=head1 WARNINGS

Certain systems which make it difficult to use perl modules from CPAN (I'm looking at you, Debian) are using older versions of
Filesys::DiskSpace and the df subroutine it provides. This is a problem because the version in Debian's libfilesys-diskspace-perl
is missing a fair chuck of FS magic numbers and so doesn't recognise some filesystems. It makes no difference in the output, since
we're taking that bit from mtab, but it can make things a little hairy.

=head1 AUTHOR

James Condron, E<lt>james@jamescondron.co.uk<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by James Condron

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
