#! /usr/bin/perl

package movie;

use v5.10;

#use strict;
#use warnings;

#contrains
# [0] value
# [1] array of actor strings
# [2] boolean - visited or not visited? used for search
# [3] reference to actor used to reach this movie

sub new
{
	my ($class, $value, $actor) = @_;
	my $self = [];
	bless $self, $class;
	$self->movie_name($value);
	$self->actorsIn($actor);
	return $self;
}

sub movie_name
{
	my $self = shift;
	if(@_)
	{
		$self->[0] = shift;
	}
	return $self->[0];
}
sub actorsIn
{
	my $self = shift;
	if(@_)
	{
		push( @{$self->[1]} , @_);
	}
	return @{$self->[1]};
}

sub print
{
	my $self = shift;
	print "$self->[0]:\n";
	for(@{$self->[1]})
	{
		print "\t$_\n";
	}
}
sub parent_actor
{
	my $self = shift;
	if(@_)
	{
		$self->[3] = shift;
	}
	return $self->[3];
}
sub visited
{
	my $self = shift;
	if(@_)
	{
		$self->[3] = shift;
	}
	return $self->[3];
}

return 1;