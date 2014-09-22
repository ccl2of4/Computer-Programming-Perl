#! /usr/bin/perl

my %addresses = ();
my @keys = ();

sub comparator {
	my $result = $addresses{$b} <=> $addresses{$a};
	if(!$result) {
		$result = $b cmp $a;
	}
	$result;
}

while(<>) {
	my @matches = /(?<![.\w])((?:[0-9a-z_-]+[.])*[0-9a-z_-]+@(?:[0-9a-z_-]+[.])*[0-9a-z_-]+(?:[.]com)?)[,.;-]?[\s\n]/xig;
	next unless scalar(@matches);
	for(@matches) {
		++$addresses{$_};
	}
}

@keys = sort comparator (keys %addresses);

my $num_addresses = @keys;
print "$num_addresses distinct addresses found.\n";

for(@keys) {
	print "$_ ($addresses{$_}) \n";
}
