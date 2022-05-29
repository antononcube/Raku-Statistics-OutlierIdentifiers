#!/usr/bin/env raku
use v6.d;

use Statistics::OutlierIdentifiers;
use Data::Generators;

# Generated random values using Normal distribution
my @vec = random-variate(NormalDistribution.new(:mean(10), :sd(20)), 16);
say @vec;

# Find outlier positions
say outlier-identifier( @vec );

# Find outliers
say outlier-identifier( @vec):values;

# Find top outliers using the SPLUS quartile-based identifier
say outlier-identifier(@vec, identifier => (&top-outliers o &splus-quartile-identifier-parameters)):values;
