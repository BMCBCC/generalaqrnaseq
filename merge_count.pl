#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename;

my $usage = "usage: $0 --labels sampleA sampleB [...] --raw_counts sampleA.counts sampleB.counts [...]\n\n";

unless (@ARGV) {
	die $usage;
}

unless (scalar @ARGV >= 6) {
	die $usage;
}

my @sample_labels;
my @rawcounts_files;
my $list_aref;
while (@ARGV) {
	my $param = shift;
	if ($param eq "--labels") {
		$list_aref = \@sample_labels;
	}
	elsif ($param eq "--raw_counts") {
		$list_aref = \@rawcounts_files;
	}
	else {
		unless ($list_aref) {
		die "Error, cannot determine input category for entry $param";
		}
		push (@$list_aref, $param);
	}
}

unless (scalar(@sample_labels) == scalar(@rawcounts_files)) {
	die "Error, the number of sample labels != number of count files:\n"
	. "sample labels: " . join(", ", @sample_labels) . "\n"
	. "count files: " . join(", ", @rawcounts_files) . "\n";
}

unless (scalar(@sample_labels) >= 2 && scalar(@rawcounts_files) >= 2) {
	die "numbers of sample labels and count files do not match";
}


main: {
	my %data;
	foreach my $file (@rawcounts_files) {
		open (my $fh, $file) or die "Error, cannot open file $file";
		while (<$fh>) {
			chomp;
			my ($seq,$count) = split(/\t/);
			$data{$seq}->{$file} = $count;
		}
		close $fh;
	}
	print "seqeunce";
	print join("\t", "", @sample_labels) . "\n";
	foreach my $seq (keys %data) {
		print "$seq";
		foreach my $file (@rawcounts_files) {
		my $count = $data{$seq}->{$file};
			unless (defined $count) {
				$count =0;
			}
			print "\t$count";    
		}
		print "\n";
	}
	exit(0);
}
