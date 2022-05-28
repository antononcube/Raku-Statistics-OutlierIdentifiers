# Raku::Statistics::OutlierIdentifiers

## In brief

This a Raku package for 1D outlier identifier functions. 
If follows closely the Mathematica package [AAp1] and the R package [AAp3].

------

## Installation 

From Raku.land:

```shell
zef install Statistics::OutlierIdentifiers
```

From GitHub:

```shell
zef install https://github.com/antononcube/Raku-Statistics-OutlierIdentifiers.git
```

------

## Usage examples

Load packages:

```perl6
use Data::Generators;
use Statistics::OutlierIdentifiers;
```
```
# (Any)
```

Generate a vector with random numbers:

```perl6
srand(121);
my @vec=random-variate(NormalDistribution.new(:mean(10), :sd(20)), 10);
say @vec
```
```
# [34.660719020315 -8.030075964297922 7.9024919424237945 -1.6431949264279329 -62.06920928324861 5.844068195507269 1.654648693137439 -9.477538748192543 26.94082690136212 37.086889685282394]
```

Find outlier positions and values:

```perl6
say outlier-identifier(@vec);
say outlier-identifier(@vec):values;
```
```
# [0 4 8 9]
# (34.660719020315 -62.06920928324861 26.94082690136212 37.086889685282394)
```

Find *top* outlier positions and values:

```perl6
say outlier-identifier(@vec, identifier => (&top-outliers o &hampel-identifier-parameters));
say outlier-identifier(@vec, identifier => (&top-outliers o &hampel-identifier-parameters)):values;
```
```
# [0 8 9]
# (34.660719020315 26.94082690136212 37.086889685282394)
```

Find *bottom* outlier positions and values (using quartiles-based identifier):

```perl6
say outlier-identifier(@vec, identifier => (&bottom-outliers o &quartile-identifier-parameters));
say outlier-identifier(@vec, identifier => (&bottom-outliers o &quartile-identifier-parameters)):values;
```
```
# [4]
# (-62.06920928324861)
```

The available outlier parameters functions are:

- `hampel-identifier-parameters`
- `splus-quartile-identifier-parameters`
- `quartile-identifier-parameters`

```perl6
.say for (&hampel-identifier-parameters, &splus-quartile-identifier-parameters, &quartile-identifier-parameters).map({ $_ => $_.(@vec) });
```
```
# &hampel-identifier-parameters => (-14.787835171599149 22.286552060243856)
# &splus-quartile-identifier-parameters => (-25.699227577228335 21.418510057252767)
# &quartile-identifier-parameters => (-31.221544421337683 38.72026130998239)
```

------

## References 

[AA1] Anton Antonov,
["Outlier detection in a list of numbers"](https://mathematicaforprediction.wordpress.com/2013/10/16/outlier-detection-in-a-list-of-numbers/),
(2013),
[MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).


[AAp1] Anton Antonov,
["Implementation of one dimensional outlier identifying algorithms in Mathematica"](https://github.com/antononcube/MathematicaForPrediction/blob/master/OutlierIdentifiers.m),
(2013),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp2] Anton Antonov,
[OutlierIdentifiers R-package](https://github.com/antononcube/R-packages/tree/master/OutlierIdentifiers),
(2019),
[R-packages at GitHub/antononcube](https://github.com/antononcube/R-packages).
