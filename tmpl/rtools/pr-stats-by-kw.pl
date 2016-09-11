#!/usr/bin/env perl
# Calculate per-keyword precision-recall from output of pr-from-table.awk
#***************************************************************************
#  Copyright 2014-2016, mettatw
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#***************************************************************************

use strict;
use warnings;

use List::Util qw(reduce);

my $USAGE = "Usage: $0 [keyword weighting]";

# Get precision from (TP, FR, FA)
sub getPrec {
  my ($nTP, $nFR, $nFA) = @_;
  return 0.0 if ($nTP + $nFA == 0);
  return $nTP * 1.0 / ($nTP + $nFA);
}

# Get recall from (TP, FR, FA)
sub getRecl {
  my ($nTP, $nFR, $nFA) = @_;
  return 0.0 if ($nTP + $nFR == 0);
  return $nTP * 1.0 / ($nTP + $nFR);
}

# Get recall from (key, TP, FR, FA)
sub output {
  my ($key, $nTP, $nFR, $nFA) = @_;

  printf "%s %.3f %.3f %d %d %d %d\n", $key,
    getPrec($nTP, $nFR, $nFA),
    getRecl($nTP, $nFR, $nFA),
    $nTP, $nFR, $nFA, $nTP + $nFR;
}

# Initial comment
printf " # keyword precision recall TP FR FA Total\n";

my %mTPTotal;
my %mFRTotal;
my %mFATotal;
while (<>) {
  chomp;
  s/\s+$//;
  next if (length($_) == 0); # Empty line, skip
  next if (/^ /); # Comment line, skip

  if (/^([^ ]+) (.*)$/) { # Normal case, we only need this one
    my $key = $1;
    my @detections = split(/\s+/, $2);
    
    foreach my $detect (@detections) {
      my ($type, $keyword) = split(':', $detect);
      # Initialize all three types at once
      if (not exists $mTPTotal{$keyword}) {
        $mTPTotal{$keyword} = 0;
        $mFRTotal{$keyword} = 0;
        $mFATotal{$keyword} = 0;
      }

      if ($type eq "TP") {
        $mTPTotal{$keyword} += 1;
      } elsif ($type eq "FR") {
        $mFRTotal{$keyword} += 1;
      } elsif ($type eq "FA") {
        $mFATotal{$keyword} += 1;
      }
    }
  }
}

foreach my $keyword (sort keys %mTPTotal) {
  output($keyword, $mTPTotal{$keyword}, $mFRTotal{$keyword}, $mFATotal{$keyword});
}
