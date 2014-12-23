use strict;
use utf8;
use Encode;


my ($key, $value, $word, $class, $prevword, $in) = ('', '', '', '', '');
my %desc;
my %classvalue = (
    '語源' => 23,
    '名' => 22,
    '代' => 21,
    '動' => 20,
    '自他動' => 19,
    '他動' => 18,
    '自動' => 17,
    '形' => 16,
    '副' => 15,
    '助動' => 14,
    '前' => 13,
    '助' => 12,
    '接続' => 11,
    '接頭' => 10,
    '接尾' => 9,
    '間' => 8,
    '句動' => 7,
    '句他動' => 6,
    '句自動' => 5,
    '略' => 4,
    '人名' => 3,
    '地名' => 2,
    '組織' => 1
    );


while (<>) {
    chomp;
    $in = decode('cp932', $_);
    if ( ($key, $value) = ($in =~ m/^■(.+) : (.+)$/) ) {
	if ( $key =~ m/^([^\{]*[^\{\s])\s+\{([^\}]+)\}$/ ) {
	    ($word, $class) = ($1, $2);
	}
	else {
	    ($word, $class) = ($key, '-');
	}

	$value =~ s/\\/\\\\/g;
	$value =~ s/■・/\\n   /g;
	$value =~ s/■/\\n/g;
	$value =~ s/([a-zA-Z]+)・/$1‧/g;


# $value =~ s/｛[ぁ-ゔ／（）・＿ー ]+｝//g; # to remove (most of) FURIGANAs
# $value =~ s/【＠】([^、【]+、)+//; # to remove KANA pronunciations


	if ( $word !~ m/[。、]/ ) { # to remove sentences, i.e. non-words, in order to avoid StarDict crashing
	    if ( ($word ne $prevword) && ($prevword ne '') ) {
		flush($prevword, %desc);
		undef %desc;
	    }
	    $desc{$class} = $value;
	    $prevword = $word;
	}
    }
    else {
	print STDERR encode('cp932', "irregular line[$.]: $in\n");
    }
    ($key, $value, $word, $class) = ('', '', '', '');
}
flush($prevword, %desc);


sub flush {
    my ($word, %desc) = @_;
    my ($key);

    print encode('utf8', "$word\t");
    if ( $desc{'-'} ) {
	print encode('utf8', "$desc{'-'}\\n");
	delete $desc{'-'};
    }
    foreach $key (sort byclass keys %desc) {
	print encode('utf8', "〖$key〗$desc{$key}\\n");
    }
    print "\n";
}


sub byclass {
    my ($as, $ac, $am) = ( $a =~ m/^(?:([0-9]+)\-)?([^\-\s]+)(?:\-([0-9]+))?/ );
    my ($bs, $bc, $bm) = ( $b =~ m/^(?:([0-9]+)\-)?([^\-\s]+)(?:\-([0-9]+))?/ );
    my @diffs = ($as - $bs, $ac - $bc, $classvalue{$bc} - $classvalue{$ac}, $ac cmp $bc, $am - $bm);
    my $diff;


    foreach $diff (@diffs) {
	if ($diff != 0) {
	    return $diff;
	}
    }
    return 0;
}
