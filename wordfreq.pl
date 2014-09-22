#! /usr/bin/perl

our %dict = ();
our %data_in_dict = ();
our %data_not_in_dict = ();

open(my $file, "<", "words")
  or die "cannot open dictionary";

while(<$file>) {
  chomp;
  $_ = lc;
  $dict{$_} = 1;
}

while(<>) {
	my @words_in_line = /[a-z](?:[a-z']*[a-z])?/ig;
  foreach(@words_in_line) {
      $_ = lc;
      if(!exists($dict{$_})) {
	      $data_not_in_dict{$_}++;
			}
			else {
				$data_in_dict{$_}++;
			}
	}
}

print
	"Number of distinct words: ",
	scalar(keys %data_in_dict) + scalar(keys %data_not_in_dict),
	"\n";

print
	"Number of distinct words not in dictionary: ",
	scalar(keys %data_not_in_dict),
	"\n";
