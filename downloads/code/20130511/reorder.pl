#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode;

my $infile = $ARGV[0];

if(!$infile) {
    die "Usage: $0 [infile]\n";
}

my $file;
my %W;

open($file, $infile) || die "$!\n";

while(<$file>) {
    my $line = decode('cp932', $_);

    if($line =~ /^(.+)? : /) {
	my $key = $1;

	#$key =~ s/\{.+\}//;
	#$key =~ s/\s+$//;

	# 優先的に最初に持ってくるようにkeyにｽﾍﾟｰｽを追加
	$key =~ s/\{/ \{/;

	$_ =~ s/\r//;

	$W{$key} = $_;
    }
}

close($file);

foreach (sort keys %W) {
    print $W{$_};
}
