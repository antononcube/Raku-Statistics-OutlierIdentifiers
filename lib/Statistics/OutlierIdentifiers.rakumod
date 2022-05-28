use v6.d;

use Stats;

unit module Statistics::OutlierIdentifiers;

#| Top outliers only thresholds
#| @description Drops the bottom threshold of a pair of thresholds.
#| @param pair A pair of bottom and top thresholds.
#| @family Outlier identifier parameters
#| @export
sub top-outliers(@pair --> List) is export {
    if !(@pair.all ~~ Numeric && @pair.elems == 2) {
        die "A pair of numbers is expected as a first argument.";
    }
    return (-Inf, @pair[1]);
}

#| Bottom outliers only thresholds
#| @description Drops the bottom threshold of a pair of thresholds.
#| @param pair A pair of bottom and top thresholds.
#| @family Outlier identifier parameters
#| @export
sub bottom-outliers(@pair --> List) is export {
    if !(@pair.all ~~ Numeric && @pair.elems == 2) {
        die "A pair of numbers is expected as a first argument.";
    }
    return (@pair[0], Inf);
}

#| Hampel identifier parameters
#| @description Find an Hampel outlier thresholds for a data vector.
#| @param data A data vector.
#| @family Outlier identifier parameters
sub  hampel-identifier-parameters(@data --> List) is export {
    my $x0 = median(@data);
    my $md = 1.4826 * median(@data.map({ $_ - $x0 })>>.abs);
    return ($x0 - $md, $x0 + $md);
}

#| Quartile identifier parameters
#| @description Find an Quartile outlier for a data vector.
#| @param data A data vector.
#| @family Outlier identifier parameters
#| @export
sub quartile-identifier-parameters(@data) is export {
    my @res = quartiles(@data);
    my $xL = @res[0];
    my $x0 = @res[1];
    my $xU = @res[2];
    return ($x0 - ($xU - $xL), $x0 + ($xU - $xL));
}

#| SPLUS quartile identifier parameters
#| @description Find an SPLUS Quartile outlier for a data vector.
#| @param data A data vector.
#| @family Outlier identifier parameters
#| @export
sub splus-quartile-identifier-parameters(@data) is export {

    my $xL;
    my $xU;

    if @data.elems <= 4 {
        $xL = min(@data);
        $xU = max(@data);
    } else {
        my @res = quartiles(@data);
        $xL = @res[0];
        $xU = @res[1];
    }

    return ($xL - 1.5 * ($xU - $xL), $xU + 1.5 * ($xU - $xL));
}

#| Outlier identifier.
#| @description Find an outlier threshold for a data vector.
#| @param data A data vector.
#| @param identifier An outlier identifier function.
#| @param valueQ Should values be returned or not?
#| @return A numeric vector of outliers or a logical vector.
#| @details The outlier identifier function \code{identifier}
#| should return a list or tuple of two numbers \code{c(lowerThreshold, upperThreshold)}.
#| @family Outlier identifiers
sub outlier-identifier(@data,
                       :&identifier is copy = WhateverCode,
                       Bool :$values = False) is export {

    if not @data.all ~~ Numeric {
        die "The first argument is expected to be a numeric vector.";
    }

    if &identifier.isa(WhateverCode) {
        &identifier = &hampel-identifier-parameters;
    };

    my $lowerAndUpperThresholds = &identifier(@data);

    if !($lowerAndUpperThresholds ~~ Positional && $lowerAndUpperThresholds.elems ≥ 2) {
        die "The argument &identivier is expected to produce a list of two numeric values.";
    }

    my @predInds = @data.pairs.grep({ $_.value < $lowerAndUpperThresholds[0] || $lowerAndUpperThresholds[1] < $_.value })>>.key;
    return $values ?? @data[@predInds] !! @predInds;
}