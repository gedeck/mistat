# ====================
# Essential imports
# ====================
import numpy as np
import pandas as pd
from diversipy import (halton, lhd_matrix, maximin_reconstruction,
                       random_k_means, random_uniform, sukharev_grid,
                       transform_spread_out)
from pyDOE2 import lhs, pbdesign

from .pydoe_corrected import (bbdesign_corrected, ccdesign_corrected,
                              fracfact_by_res, fullfact_corrected)

# ===========================================================================================================
# Function for constructing a DataFrame from a numpy array generated by PyDOE function and individual lists
# ===========================================================================================================


def construct_df(x, r):
    """
    Function for constructing a DataFrame from a numpy array generated by PyDOE function and individual lists
    """
    result = []
    for _, column in enumerate(x):
        result.append([rcolumn[int(idx)] for rcolumn, idx in zip(r, column)])
    return pd.DataFrame(result)


# ===================================================================================================
# Function for constructing a DataFrame from a matrix with floating point numbers between -1 and +1
# ===================================================================================================


def construct_df_from_matrix(x, factor_array):
    """
    This function constructs a DataFrame out of x and factor_array, both of which are assumed to be numpy arrays.
    It projects the numbers in the x (which is output of a design-of-experiment build) to the factor array ranges.
    Here factor_array is assumed to have only min and max ranges.
    Matrix x is assumed to have numbers ranging from -1 to 1.
    """

    row_num = x.shape[0]  # Number of rows in the matrix x
    col_num = x.shape[1]  # Number of columns in the matrix x

    empty = np.zeros((row_num, col_num))

    def simple_substitution(idx, factor_list):
        if idx == -1:
            return factor_list[0]
        if idx == 0:
            return factor_list[1]
        if idx == 1:
            return factor_list[2]
        alpha = np.abs(factor_list[2] - factor_list[0]) / 2
        if idx < 0:
            beta = np.abs(idx) - 1
            return factor_list[0] - (beta * alpha)
        beta = idx - 1
        return factor_list[2] + (beta * alpha)

    for i in range(row_num):
        for j in range(col_num):
            empty[i, j] = simple_substitution(x[i, j], factor_array[j])

    return pd.DataFrame(data=empty)


# =================================================================================================
# Function for constructing a DataFrame from a matrix with floating point numbers between 0 and 1
# =================================================================================================


def construct_df_from_random_matrix(x, factor_array):
    """
    This function constructs a DataFrame out of matrix x and factor_array, both of which are assumed to be numpy arrays.
    It projects the numbers in the x (which is output of a design-of-experiment build) to the factor array ranges.
    Here factor_array is assumed to have only min and max ranges.
    Matrix x is assumed to have numbers ranging from 0 to 1 only.
    """

    row_num = x.shape[0]  # Number of rows in the matrix x
    col_num = x.shape[1]  # Number of columns in the matrix x

    empty = np.zeros((row_num, col_num))

    def simple_substitution(idx, factor_list):
        alpha = np.abs(factor_list[1] - factor_list[0])
        beta = idx
        return factor_list[0] + (beta * alpha)

    for i in range(row_num):
        for j in range(col_num):
            empty[i, j] = simple_substitution(x[i, j], factor_array[j])

    return pd.DataFrame(data=empty)


# ======================================================================================
# Function for building full factorial DataFrame from a dictionary of process variables
# ======================================================================================


def build_full_fact(factor_level_ranges):
    """
    Builds a full factorial design dataframe from a dictionary of factor/level ranges
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,60,70],'Temperature':[290, 320, 350],'Flow rate':[0.9,1.0]}
    """

    factor_lvl_count = []
    factor_lists = []

    for key in factor_level_ranges:
        factor_lvl_count.append(len(factor_level_ranges[key]))
        factor_lists.append(factor_level_ranges[key])

    x = fullfact_corrected(factor_lvl_count)
    df = construct_df(x, factor_lists)
    df.columns = factor_level_ranges.keys()

    return df


# ===========================================================================
# Function for building 2-level fractional factorial DataFrame from a
# dictionary of process variables and a generator string representing the
# confounded variable
# ===========================================================================


def build_frac_fact_res(factor_level_ranges, res=None):
    """
    Builds a 2-level fractional factorial design dataframe from a dictionary
    of factor/level ranges and given resolution.

    Parameters
    ----------
    factor_level_ranges : Dictionary of factors and ranges
                         Only min and max values of the range are required.
                         If more than two levels are given, the extreme values
                         will be set to the low/high levels.
                         Example of the dictionary which is needed as the input:
                        {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    res : int
        Desired design resolution.
        Default: Set to half of the total factor count.

        Notes
    -----
    The resolution of a design is defined as the length of the shortest
    word in the defining relation. The resolution describes the level of
    confounding between factors and interaction effects, where higher
    resolution indicates lower degree of confounding.
    For example, consider the 2^4-1-design defined by
        gen = "a b c ab"
    The factor "d" is defined by "ab" with defining relation I="abd", where
    I is the unit vector. In this simple example the shortest word is "abd"
    meaning that this is a resolution III-design.
    In practice resolution III-, IV- and V-designs are most commonly applied.
    * III: Main effects may be confounded with two-factor interactions.
    * IV: Main effects are unconfounded by two-factor interactions, but
          two-factor interactions may be confounded with each other.
    * V: Main effects unconfounded with up to four-factor interactions,
         two-factor interactions unconfounded with up to three-factor
         interactions. Three-factor interactions may be confounded with
         each other.
    Examples
    --------
    ::
        >>> d1 = {'A':[1,5],'B':[0.3,0.7],'C':[10,15],'D':[3,7],'E':[-2,-1]}
        >>> build_frac_fact_res(d1,3)
             A    B     C    D    E
        0  1.0  0.3  10.0  7.0 -1.0
        1  5.0  0.3  10.0  3.0 -2.0
        2  1.0  0.7  10.0  3.0 -1.0
        3  5.0  0.7  10.0  7.0 -2.0
        4  1.0  0.3  15.0  7.0 -2.0
        5  5.0  0.3  15.0  3.0 -1.0
        6  1.0  0.7  15.0  3.0 -2.0
        7  5.0  0.7  15.0  7.0 -1.0

        It builds a dataframe with only 8 rows (designs) from a dictionary with 6 factors.
        A full factorial design would have required 2^6 = 64 designs.
        >>> build_frac_fact_res(d1,5)
        Traceback (most recent call last):
        ...
        ValueError: design not possible
    """

    factor_count = len(factor_level_ranges)
    factor_lists = []

    if res is None:
        res = int(factor_count / 2) + 1

    assert (
        factor_count > res
    ), "Number of factors must be greater than desired resolution"

    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = fracfact_by_res(factor_count, res)

    def index_change(x):
        if x == -1:
            return 0
        return x

    vfunc = np.vectorize(index_change)
    x = vfunc(x)

    df = construct_df(x, factor_lists)
    df.columns = factor_level_ranges.keys()

    return df


# =====================================================================================
# Function for building Plackett-Burman designs from a dictionary of process variables
# =====================================================================================


def build_plackett_burman(factor_level_ranges):
    """
    Builds a Plackett-Burman dataframe from a dictionary of factor/level ranges.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}

        Plackett–Burman designs are experimental designs presented in 1946 by
        Robin L. Plackett and J. P. Burman while working in the British Ministry
        of Supply.(Their goal was to find experimental designs for investigating
        the dependence of some measured quantity on a number of independent
        variables (factors), each taking L levels, in such a way as to minimize
        the variance of the estimates of these dependencies using a limited number
        of experiments.

    Interactions between the factors were considered negligible. The solution to
    this problem is to find an experimental design where each combination of levels
    for any pair of factors appears the same number of times, throughout all the
    experimental runs (refer to table).
        A complete factorial design would satisfy this criterion, but the idea was
        to find smaller designs.

        These designs are unique in that the number of trial conditions (rows)
        expands by multiples of four (e.g. 4, 8, 12, etc.).
        The max number of columns allowed before a design increases the number of
        rows is always one less than the next higher multiple of four.
    """

    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = pbdesign(factor_count)

    def index_change(x):
        if x == -1:
            return 0
        return x

    vfunc = np.vectorize(index_change)
    x = vfunc(x)

    df = construct_df(x, factor_lists)
    df.columns = factor_level_ranges.keys()

    return df


# ===================================================================================
# Function for building Sukharev Grid designs from a dictionary of process variables
# ===================================================================================


def build_sukharev(factor_level_ranges, num_samples=None):
    """
    Builds a Sukharev-grid hypercube design dataframe from a dictionary of factor/level
    ranges.
    Number of samples raised to the power of (1/dimension), where dimension is the number
    of variables, must be an integer.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    num_samples: Number of samples to be generated

        Special property of this grid is that points are not placed on the boundaries of
        the hypercube, but at centroids of the  subcells constituted by individual samples.
        This design offers optimal results for the covering radius regarding distances
        based on the max-norm.
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    check = num_samples ** ((1 / factor_count))
    if check - int(check) > 1e-5:
        num_samples = (int(check) + 1) ** (factor_count)
        print(
            "\nNumber of samples not adequate to fill a Sukharev grid. Increasing sample size to: ",
            num_samples,
        )

    x = sukharev_grid(num_points=num_samples, dimension=factor_count)
    factor_lists = np.array(factor_lists)

    df = construct_df_from_random_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df


# ===================================================================================
# Function for building Box-Behnken designs from a dictionary of process variables
# ===================================================================================


def build_box_behnken(factor_level_ranges, center=1):
    """
    Builds a Box-Behnken design dataframe from a dictionary of factor/level ranges.
    Note 3 levels of factors are necessary. If not given, the function will automatically
    create 3 levels by linear mid-section method.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,60,70],'Temperature':[290, 320, 350],'Flow rate':[0.9,1.0,1.1]}

        In statistics, Box–Behnken designs are experimental designs for response surface
        methodology, devised by George E. P. Box and Donald Behnken in 1960, to achieve
        the following goals:
                * Each factor, or independent variable, is placed at one of three equally
                  spaced values, usually coded as −1, 0, +1. (At least three levels are
                  needed for the following goal.)
                * The design should be sufficient to fit a quadratic model, that is, one
                  containing squared terms, products of two factors, linear terms and an
                  intercept.
                * The ratio of the number of experimental points to the number of coefficients
                  in the quadratic model should be reasonable (in fact, their designs
                  kept it in the range of 1.5 to 2.6).*estimation variance should more
                  or less depend only on the distance from the centre (this is achieved
                  exactly for the designs with 4 and 7 factors), and should not vary too
                  much inside the smallest (hyper)cube containing the experimental points.
        """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) == 2:
            factor_level_ranges[key].append(
                (factor_level_ranges[key][0] + factor_level_ranges[key][1]) / 2
            )
            factor_level_ranges[key].sort()
            print(
                f"{key} had only two end points. Creating a mid-point by averaging them"
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = bbdesign_corrected(factor_count, center=center)
    x = x + 1  # Adjusting the index up by 1

    df = construct_df(x, factor_lists)
    df.columns = factor_level_ranges.keys()

    return df


# =====================================================================================================
# Function for building central-composite (Box-Wilson) designs from a dictionary of process variables
# =====================================================================================================


def build_central_composite(factor_level_ranges, center=(2, 2), alpha="o", face="ccc"):
    """
    Builds a central-composite design dataframe from a dictionary of factor/level ranges.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}

        In statistics, a central composite design is an experimental design, useful in
        response surface methodology, for building a second order (quadratic) model for
        the response variable without needing to use a complete three-level factorial
        experiment.
        The design consists of three distinct sets of experimental runs:
                * A factorial (perhaps fractional) design in the factors studied, each having
                  two levels;
                * A set of center points, experimental runs whose values of each factor are
                  the medians of the values used in the factorial portion. This point is often
                  replicated in order to improve the precision of the experiment;
                * A set of axial points, experimental runs identical to the centre points
                  except for one factor, which will take on values both below and above the
                  median of the two factorial levels, and typically both outside their range.
                  All factors are varied in this way.
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    # Creates the mid-points by averaging the low and high levels
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) == 2:
            factor_level_ranges[key].append(
                (factor_level_ranges[key][0] + factor_level_ranges[key][1]) / 2
            )
            factor_level_ranges[key].sort()

    factor_count = len(factor_level_ranges)
    factor_lists = []

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = ccdesign_corrected(factor_count, center=center, alpha=alpha, face=face)
    factor_lists = np.array(factor_lists)

    df = construct_df_from_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df


# ====================================================================================
# Function for building simple Latin Hypercube from a dictionary of process variables
# ====================================================================================


def build_lhs(factor_level_ranges, num_samples=None, prob_distribution=None):
    """
    Builds a Latin Hypercube design dataframe from a dictionary of factor/level ranges.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    num_samples: Number of samples to be generated
    prob_distribution: Analytical probability distribution to be applied over the randomized sampling.
        Takes strings like: 'Normal', 'Poisson', 'Exponential', 'Beta', 'Gamma'

        Latin hypercube sampling (LHS) is a form of stratified sampling that can be applied
        to multiple variables. The method commonly used to reduce the number or runs necessary
        for a Monte Carlo simulation to achieve a reasonably accurate random distribution.
        LHS can be incorporated into an existing Monte Carlo model fairly easily, and work with
        variables following any analytical probability distribution.
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    if num_samples is None:
        num_samples = factor_count

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = lhs(n=factor_count, samples=num_samples)
    factor_lists = np.array(factor_lists)

    df = construct_df_from_random_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df


# ============================================================================================
# Function for building space-filling Latin Hypercube from a dictionary of process variables
# ============================================================================================


def build_space_filling_lhs(factor_level_ranges, num_samples=None):
    """
    Builds a space-filling Latin Hypercube design dataframe from a dictionary of factor/level ranges.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    num_samples: Number of samples to be generated
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    if num_samples is None:
        num_samples = factor_count

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = transform_spread_out(
        lhd_matrix(num_points=num_samples, dimension=factor_count)
    )  # create latin hypercube design
    factor_lists = np.array(factor_lists)

    df = construct_df_from_random_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df


# =====================================================================================================
# Function for building designs with random _k-means_ clusters from a dictionary of process variables
# =====================================================================================================


def build_random_k_means(factor_level_ranges, num_samples=None):
    """
    This function aims to produce a centroidal Voronoi tesselation of the
    unit random hypercube and generate k-means clusters.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    num_samples: Number of samples to be generated
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    if num_samples is None:
        num_samples = factor_count

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = random_k_means(
        num_points=num_samples, dimension=factor_count
    )  # create latin hypercube design
    factor_lists = np.array(factor_lists)

    df = construct_df_from_random_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df


# =============================================================================================
# Function for building maximin reconstruction matrix from a dictionary of process variables
# =============================================================================================


def build_maximin(factor_level_ranges, num_samples=None):
    """
    Builds a maximin reconstructed design dataframe from a dictionary of factor/level ranges.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    num_samples: Number of samples to be generated

        This algorithm carries out a user-specified number of iterations to maximize the minimal
        distance of a point in the set to
                * other points in the set,
                * existing (fixed) points,
                * the boundary of the hypercube.
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    if num_samples is None:
        num_samples = factor_count

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = maximin_reconstruction(
        num_points=num_samples, dimension=factor_count
    )  # create latin hypercube design
    factor_lists = np.array(factor_lists)

    df = construct_df_from_random_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df


# ========================================================================================
# Function for building Halton matrix based design from a dictionary of process variables
# ========================================================================================


def build_halton(factor_level_ranges, num_samples=None):
    """
    Builds a quasirandom dataframe from a dictionary of factor/level ranges using
    prime numbers as seed.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    num_samples: Number of samples to be generated

    Quasirandom sequence using the default initialization with first n prime numbers
    equal to the number of factors/variables.
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    if num_samples is None:
        num_samples = factor_count

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = halton(
        num_points=num_samples, dimension=factor_count
    )  # create Halton matrix design
    factor_lists = np.array(factor_lists)

    df = construct_df_from_random_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df


# ==========================================================================================
# Function for building uniform random design matrix from a dictionary of process variables
# ==========================================================================================


def build_uniform_random(factor_level_ranges, num_samples=None):
    """
    Builds a design dataframe with samples drawn from uniform random distribution based on a
    dictionary of factor/level ranges.
    Only min and max values of the range are required.
    Example of the dictionary which is needed as the input:
    {'Pressure':[50,70],'Temperature':[290, 350],'Flow rate':[0.9,1.0]}
    num_samples: Number of samples to be generated
    """
    for key in factor_level_ranges:
        if len(factor_level_ranges[key]) != 2:
            factor_level_ranges[key][1] = factor_level_ranges[key][-1]
            factor_level_ranges[key] = factor_level_ranges[key][:2]
            print(
                f"{key} had more than two levels. Assigning the end point to the high level."
            )

    factor_count = len(factor_level_ranges)
    factor_lists = []

    if num_samples is None:
        num_samples = factor_count

    for key in factor_level_ranges:
        factor_lists.append(factor_level_ranges[key])

    x = random_uniform(
        num_points=num_samples, dimension=factor_count
    )  # create Halton matrix design
    factor_lists = np.array(factor_lists)

    df = construct_df_from_random_matrix(x, factor_lists)
    df.columns = factor_level_ranges.keys()
    return df
