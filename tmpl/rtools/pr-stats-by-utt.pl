#!/usr/bin/env perl
# Calculate per-utt precision-recall from output of pr-from-table.awk
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
printf " # key precision recall TP FR FA Total\n";

my $nTPTotal = 0;
my $nFRTotal = 0;
my $nFATotal = 0;
while (<>) {
  chomp;
  s/\s+$//;
  next if (length($_) == 0); # Empty line, skip
  next if (/^ /); # Comment line, skip

  if (/^([^ ]+)$/) { # Empty case: key only, no content
    output($1, 0, 0, 0);

  } elsif (/^([^ ]+) (.*)$/) { # Normal case
    my $key = $1;
    my @detections = split(/\s+/, $2);
    
    my $nTP = reduce { $b =~ /^TP:/ ? $a + 1 : $a } 0, @detections;
    my $nFR = reduce { $b =~ /^FR:/ ? $a + 1 : $a } 0, @detections;
    my $nFA = reduce { $b =~ /^FA:/ ? $a + 1 : $a } 0, @detections;

    # Add to global accumulator
    $nTPTotal += $nTP;
    $nFRTotal += $nFR;
    $nFATotal += $nFA;

    output($1, $nTP, $nFR, $nFA);
  }
}

# Final average
output(" _", $nTPTotal, $nFRTotal, $nFATotal);
