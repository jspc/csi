#!/usr/bin/env perl
#
# Common Scripting Interface
#

use strict;
use warnings;

use Fuse::Simple qw( :all );       # OTT, but easiest
use threads;
use threads::shared;
use CWD;

my $cwd = getcwd;
my $hdr = $ENV{ 'HOME' };
use dir "$cwd/lib";
use dir "$hdr/lib";

use CSI::Time;
use CSI::Sys;
use CSI::FS;
use CSI::Rand;

my $mpoint = $argv[1] || "/csi";
my $debug  = 0;

# Some things will remain static and so re-working them each time
# Would just be plain stupid. Instead we work them out at start up

my $kern_string = &sys_kern;
my $dev_null    = &sys_devnull;
my $separator   = &sys_separator;
my $boottime    = &sys_boottime;
my $bits        = &sys_bits;
my $fs          = &determine_df;

# The filesystem
my $filesystem = {
    "time" => { "date"        =>       \&time_date,
		"time"        =>       \&time_time,
		"epoch"       =>       \&time_epoch,
		"sleep"       =>       \&time_sleep,
    },
    "sys"  => { "kernel"      =>       sub { return $kern_string },
		"dev_null"    =>       sub { return $dev_null },
		"separator"   =>       sub { return $separator },
		"boot_time"   =>       sub { return $boottime },
		"bits"        =>       sub { return $bits },
    },
    "rand" => { "max"         =>       \&rand_max,
		"range"       =>       \&rand_range,
    },
    "fs"   => $fs,
};


# Our main hash for fuse

main(
    "mountpoint"    => $mpoint,
    "debug"         => $debug,
    "fuse_debug"    => $debug,
    "threaded"      => 0,
    "/"             => $filesystem,
    "mountopts"     => "allow_other"
    );

1;

