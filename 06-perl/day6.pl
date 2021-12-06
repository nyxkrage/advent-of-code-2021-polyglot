#!/bin/perl

open(FH, '<', "input") or die $!;
my $input = <FH>;
close(FH);
my @input = split(/,/, $input);
my @fishes = (0,0,0,0,0,0,0,0,0);
foreach $fish (@input) {
    $fishes[$fish] += 1;
}

my $cnt = "256";
while ("$cnt" > "0") {
    @newfishes = (0,0,0,0,0,0,0,0,0);
    foreach my $age (1..7) {
        $newfishes[$age] = $fishes[$age + 1];
        $newfishes[$age-1] = $fishes[$age];
    }
    $newfishes[8] = $fishes[0];
    $newfishes[6] = $fishes[0] + $newfishes[6];
    @fishes = @newfishes;
    $cnt = $cnt - 1;
}
my $total = 0;
foreach my $fish (@fishes) {
    $total += $fish;
}
print("$total");
print("\n");
