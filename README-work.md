# Raku::Statistics::OutlierIdentifiers

## In brief

This a Raku package for 1D outlier identifier functions. 
If follows closely the Mathematica package [AAp1] and the R package [AAp3].

------

## Installation 

*TBD...*

------

## Usage examples

Load packages:

```perl6
use Data::Generators;
use Statistics::OutlierIdentifiers;
```

Generate a vector with random numbers:

```perl6
srand(121);
my @vec=random-variate(NormalDistribution.new(:mean(10), :sd(20)), 10);
say @vec
```

Find outlier positions and values:

```perl6
say outlier-identifier(@vec);
say outlier-identifier(@vec):values;
```

Find **top** outlier positions and values:

```perl6
say outlier-identifier(@vec, identifier => (&top-outliers o &hampel-identifier-parameters));
say outlier-identifier(@vec, identifier => (&top-outliers o &hampel-identifier-parameters)):values;
```

Find **bottom** outlier positions and values (using quartiles-based identifier):

```perl6
say outlier-identifier(@vec, identifier => (&bottom-outliers o &quartile-identifier-parameters));
say outlier-identifier(@vec, identifier => (&bottom-outliers o &quartile-identifier-parameters)):values;
```

The available outlier parameters functions are:

- `hampel-identifier-parameters`
- `splus-quartile-identifier-parameters`
- `quartile-identifier-parameters`

```perl6
.say for (&hampel-identifier-parameters, &splus-quartile-identifier-parameters, &quartile-identifier-parameters).map({ $_ => $_.(@vec) });
```

------

## References 
