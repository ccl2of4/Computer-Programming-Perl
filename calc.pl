#! /usr/bin/perl
use feature qw(switch);
use Scalar::Util qw(looks_like_number);

our @stack = ();

while(<>) {
	chomp;
	$print = 1;
	given($_) {
		when("+") {
			push( @stack, (pop(@stack) + pop(@stack)) );
		}
		when("-") {
			push( @stack, (-1*pop(@stack) + pop(@stack)) );
		}
		when("*") {
			push( @stack, (pop(@stack) * pop(@stack)) );
		}
		when("/") {
			push( @stack, (1/pop(@stack) * pop(@stack)) );
		}
		when("sqrt") {
			push( @stack, sqrt(pop(@stack)) );
		}
		when("sum") {
			my $register = 0;
			while(scalar(@stack)) {
				$register += pop(@stack);
			}
			push(@stack,$register);
		}
		when("mean") {
			my $register_a = 0;
			my $register_b = 0;
			while(scalar(@stack)) {
				$register_a += pop(@stack);
				++$register_b;
			}
			push(@stack,$register_a/$register_b);
		}
		when("squares") {
			@stack = map { $_ * $_ } @stack;
		}
		when("residuals") {
			my $register_a = 0;
			my $register_b = 0;
			foreach(@stack) {
				$register_a += $_;
				++$register_b;
			}
			$register_a /= $register_b;
			@stack = map { $_ - $register_a } @stack;
		}
		when("stddev") {
			my $register_a = 0;
			my $register_b = 0;
			foreach(@stack) {
				$register_a += $_;
				++$register_b;
			}
			$register_a /= $register_b;
			@stack = map { $_ - $register_a } @stack;
			$register_a = 0;
			$register_b = 0;
			while(scalar(@stack)) {
				$register_a += (pop(@stack) ** 2);
				++$register_b;
			}
			push(@stack,sqrt($register_a / $register_b));
		}
		default {
			if(looks_like_number($_)) {
				push(@stack, $_);
				$print = 0;
			}
			else {
				print "Invalid Input\n";
			}
		}
	}
	if($print) { print "Stack: @stack\n"; }
}
