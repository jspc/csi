package CSI::FS;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw( determine_df fs_free  );
our $VERSION = '1.00';

use Filesys::DiskSpace;

sub determine_df {
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

