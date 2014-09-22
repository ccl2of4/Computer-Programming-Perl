#! /usr/bin/perl

package actors;

use v5.10;

#use strict;
#use warnings;

#contrains
# [0] value
# [1] reference to array of movie strings
# [2] boolean - visited or not visited? used for search
# [3] reference to movie used to reach this actor

sub new
{
	my ($class, $value, $movies) = @_;
	my $self = [];
	bless $self, $class;
	$self->actor_name($value);
	if($movies){
		$self->moviesIn($movies);
	}
	return $self;
}

sub actor_name
{
	my $self = shift;
	if(@_)
	{
		$self->[0] = shift;
	}
	return $self->[0];
}
sub moviesIn
{
	my $self = shift;
	if(@_)
	{
		push( @{$self->[1]} , @_);
	}
	return @{$self->[1]};
}
sub parent_movie
{
	my $self = shift;
	if(@_)
	{
		$self->[3] = shift;
	}
	return $self->[3];
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
sub visited
{
	my $self = shift;
	if(@_)
	{
		$self->[2] = shift;
	}
	return $self->[2];
}
return 1;