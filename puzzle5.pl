#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw( min max );

sub binarySearch {
    if ($_[2] eq "") {
        return $_[0];
    }

    my $min = $_[0];
    my $max = $_[1];
    my $row_bit = substr($_[2], 0, 1);
    my $shift_lower = $_[3];
    my $shift = (($max + 1) - $min) / 2;

    if ($row_bit eq $shift_lower) {
        binarySearch($min, $max - $shift, substr($_[2], 1), $shift_lower);
    } else {
        binarySearch($min + $shift, $max, substr($_[2], 1), $shift_lower);
    }
}

my $handle;
unless (open $handle, "<:encoding(utf8)", $ARGV[0]) {
   print STDERR "Could not open file '$ARGV[0]': $!\n";
   return undef
}
chomp(my @passes = <$handle>);
unless (close $handle) { print STDERR "Don't care error while closing '$ARGV[0]': $!\n"; }

my @seat_ids = ();

foreach ( @passes ) {
    my $row = binarySearch(0, 127, substr($_, 0, 7), "F");
    my $column = binarySearch(0, 7, substr($_, 7, 10), "L");
    my $seat_id = ($row * 8) + $column;
    
    push @seat_ids, $seat_id;
}

my $min = min @seat_ids;
my $max = max @seat_ids;

for (my $i = $min; $i <= $max; $i++) {
    if (!grep( /^$i$/, @seat_ids)) {
        print("$i\n");
    }
}
