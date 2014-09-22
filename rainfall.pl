#! /usr/bin/perl
use feature "switch";

$total_rainfall = 0;
$num_days_rainy = 0;
$num_days_trace = 0;
$num_days_no_rain = 0;
$num_days_no_data = 0;

while(<>){
    chomp;
    given ($_) {
	when (999.9) { $num_days_no_data++;}
	when ("T") { $num_days_trace++;}
	when (0) { $num_days_no_rain++;}
	default { $total_rainfall+=$_ ; $num_days_rainy++;}
    }
}

print "Total rainfall: ",$total_rainfall," inches\n";
print $num_days_rainy," days of rain\n";
print $num_days_trace," days with trace precipitation\n";
print $num_days_no_rain," days with no rain\n";
print $num_days_no_data," days with missing data\n";
