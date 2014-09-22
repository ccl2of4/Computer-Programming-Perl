#! /usr/bin/perl
use v5.10;
use actors;
use movie;
use IO::Uncompress::Gunzip qw($GunzipError);

$debug = 0;

my %all_actors;
my %all_movies;

#per actor


while(my $input = shift)
{
	my $INP = IO::Uncompress::Gunzip->new( $input )
	    or die "IO::Uncompress::Gunzip failed: $GunzipError\n";
	#open(my $INP, "<", $input) or die "Cound not open input file: $_\n";
	my $atActorsNames = 0;

	while(<$INP>){
		##for each actor
		chomp;

		if($atActorsNames < 1)
		{
			#find the start
			#Name			Titles 
			#----			------
			if(index($_,"Name") != -1 && index($_,"Titles") != -1)
			{
				$atActorsNames = 1;
				#print "found names\n";
			}
			
		}
		elsif ($atActorsNames < 2)
		{
			$atActorsNames= 2;
			#print "throwaway line $atActorsNames\n";
		}
		else
		{
			@things_in_line = split('\t');
			$first = shift(@things_in_line);
			if(0 and index($first, "-") != -1) {
				undef $INP;
				undef @things_in_line;
				undef $first;
			}
			if($first)
			{
				$actor_name = lc $first;
				#print "$actor_name\n---------------\n";	

				#add new person to data structure
				$all_actors{$actor_name} = actors->new($actor_name);
			}

			for(@things_in_line){
				if(!($_ eq ""))
				{
					if(index($_,"(TV)") == -1 && index($_,"(V)") == -1 && index($_,"(VG)") == -1 && index($_,"\"") != 0)
					{
						#getting the movie
						$movie = /( (?:(?:\w|[-!?,.:"'&\/])+\s)+\s*    (?:  \( (?:\d|[?])+ (?:\/\w+)?  \) )?)/x;
						#print "\t\t$1\n";
						$movie_name = lc $1;

						#adding tot he dtat structure
						$all_actors{$actor_name}->moviesIn($movie_name);
						if(exists $all_movies{$movie_name}){
							$all_movies{$movie_name}->actorsIn($actor_name);
						}
						else{
							$all_movies{$movie_name} = movie->new($movie_name,$actor_name);
						}
					}
				}
			}
		}
	}
}


print "Enter an actor to trace.\n";

while(<>)
{

	chomp;
	if($_ eq ""){exit(0);}

	my $search_name = lc $_;
	my $search_actor = undef;
	my @possible_actors = ();
	if(exists $all_actors{$search_name}) {
		$search_actor = $all_actors{$search_name};
	}
	if(!defined $search_actor)
	{
		@possible_actors = grep{ index($_,$search_name) != -1} keys %all_actors;
		if(scalar(@possible_actors) == 1)
		{		
			$search_name = pop @possible_actors;
			$search_actor = $all_actors{$search_name};
		}
	}
	if(defined $search_actor) {
		print "Finding path on: $search_name\n";
		&algorithm($search_actor);
		foreach (keys %all_actors) {
			$all_actors{$_}->visited(0);
		}
		foreach( keys %all_movies) {
			$all_movies{$_}->visited(0);
		}
	}
	else
	{
		if(scalar(@possible_actors))
		{
			print "Did you mean:\n";
			for(@possible_actors)
			{
				print"\t$_\n";
			}
		}	
		else
		{
			print "no actor matching name: $_\n";
		}
	}
	print "Enter an actor to trace.\n";
}

sub algorithm {
	my $end_actor = shift;
	my $start_actor = $all_actors{"bacon, kevin (i)"};
	my @queue = ();
	push @queue, $start_actor;
	$start_actor->visited(1);
	while(scalar(@queue)) {
		my $actor = shift @queue;
		if($actor == $end_actor) {
			print $actor->actor_name(),"\n";
			while(!($actor->actor_name() eq "bacon, kevin (i)")) {
				my $par_movie = $actor->parent_movie();
				my $par_actor = $par_movie->parent_actor();
				print "\t",$par_movie->movie_name(),"\n";
				print $par_actor->actor_name(),"\n";
				$actor = $par_actor;
			}
			return;
		}
		foreach ($actor->moviesIn) {
			my $movie = $all_movies{$_};
			if(!$movie->visited()) {
				$movie->visited(1);
				$movie->parent_actor($actor);
				foreach($movie->actorsIn) {
					my $next_actor = $all_actors{$_};
					if(!$next_actor->visited()) {
						$next_actor->visited(1);
						$next_actor->parent_movie($movie);
						push @queue, $next_actor;
					}
				}
			}
		}
	}
	print "No link to Kevin Bacon found.\n";
	return;
}