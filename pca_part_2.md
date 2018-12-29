This post is Part-II of a three part series post on PCA. Other parts of
the series can be found at the links below.

-   [Part-I: Basic Theory of
    PCA](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-i/)
-   [Part-III: Reproducing results of a published paper on
    PCA](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-iii/)

In this post we will first apply built in commands to obtain results and
then we will show how the same results can be obtained without using
built-in commands. By this post, our aim is not to advocate the use of
non-built-in functions. Rather, in our opinion, it enhances
understanding by knowing what happens under the hood when a built-in
function is called. In actual applications, readers should always use
built functions as they are robust(almost always) and tested for
efficiency.

In this post readers can find code snippets for R. Equivalent [MATLAB
codes](https://github.com/biswajitsahoo1111/PCA/blob/master/pca_part_II_MATLAB_codes.pdf)
for the same can be obtained from this
[link](https://github.com/biswajitsahoo1111/PCA/blob/master/pca_part_II_MATLAB_codes.pdf).

We will use French food data form reference \[2\]. Refer to the paper to
know about the original source of the data. We will apply different
methods to this data and compare the result.

### Load Data
```r
#Load abdi food data
(food = read.csv("pca_abdi_food.csv",header= T))
```
    ##           class children bread vegetables fruit meat poultry milk wine
    ## 1   Blue_collar        2   332        428   354 1437     526  247  427
    ## 2  White_collar        2   293        559   388 1527     567  239  258
    ## 3   Upper_class        2   372        767   562 1948     927  235  433
    ## 4   Blue_collar        3   406        563   341 1507     544  324  407
    ## 5  White_collar        3   386        608   396 1501     558  319  363
    ## 6   Upper_class        3   438        843   689 2345    1148  243  341
    ## 7   Blue_collar        4   534        660   367 1620     638  414  407
    ## 8  White_collar        4   460        699   484 1856     762  400  416
    ## 9   Upper_class        4   385        789   621 2366    1149  304  282
    ## 10  Blue_collar        5   655        776   423 1848     759  495  486
    ## 11 White_collar        5   584        995   548 2056     893  518  319
    ## 12  Upper_class        5   515       1097   887 2630    1167  561  284
```r
    # Centerd data matrix
    cent_food = scale(food[,3:9],scale = F)
    # Scaled data matrix
    scale_food = scale(food[,3:9],scale = T)
```
Covariance PCA
--------------

### Using built-in function
```
    # Using built-in function
    pca_food_cov = prcomp(food[,3:9],scale = F)
    # Loading scores (we have printed only four columns out of seven)
    (round(pca_food_cov$rotation[,1:4],2)) # Factor score (we have printed only four PCs out of seven)
```
    ##              PC1   PC2   PC3   PC4
    ## bread       0.07 -0.58 -0.40  0.11
    ## vegetables  0.33 -0.41  0.29  0.61
    ## fruit       0.30  0.10  0.34 -0.40
    ## meat        0.75  0.11 -0.07 -0.29
    ## poultry     0.47  0.24 -0.38  0.33
    ## milk        0.09 -0.63  0.23 -0.41
    ## wine       -0.06 -0.14 -0.66 -0.31
```
    

We have printed only four columns of loading scores out of seven.
```
    (round(pca_food_cov$x[,1:4],2))
```
    ##           PC1     PC2     PC3    PC4
    ##  [1,] -635.05  120.89  -21.14 -68.97
    ##  [2,] -488.56  142.33  132.37  34.91
    ##  [3,]  112.03  139.75  -61.86  44.19
    ##  [4,] -520.01  -12.05    2.85 -13.70
    ##  [5,] -485.94   -1.17   65.75  11.51
    ##  [6,]  588.17  188.44  -71.85  28.56
    ##  [7,] -333.95 -144.54  -34.94  10.07
    ##  [8,]  -57.51  -42.86  -26.26 -46.55
    ##  [9,]  571.32  206.76  -38.45   3.69
    ## [10,]  -39.38 -264.47 -126.43 -12.74
    ## [11,]  296.04 -235.92   58.84  87.43
    ## [12,]  992.83  -97.15  121.13 -78.39

We have printed only four principal components out of seven.
```
    # Variances using built-in function
    (round(pca_food_cov$sdev^2,2))
```
    ## [1] 274831.02  26415.99   6254.11   2299.90   2090.20    338.39     65.81
```
    # Total variance
    (sum(round(pca_food_cov$sdev^2,2)))
```
    ## [1] 312295.4

Comparison of variance before and after transformation
------------------------------------------------------
```
    # Total variance before transformation
    sum(diag(cov(food[,3:9])))
```
    ## [1] 312295.4
```
    # Total variance after transformation
    sum(diag(cov(pca_food_cov$x)))
```
    ## [1] 312295.4

Another important observation is to see how variance of each variable
before transformation changes into variance of principal components.
Note that total variance in this process remains same as seen from above
codes.
``
    # Variance along variables before transformation
    round(diag(cov(food[,3:9])),2)
```
    ##      bread vegetables      fruit       meat    poultry       milk 
    ##   11480.61   35789.09   27255.45  156618.39   62280.52   13718.75 
    ##       wine 
    ##    5152.63

Note that calculation of variance is unaffected by centering data
matrix. So variance of original data matrix as well as centered data
matrix is same. Check it for yourself. Now see how PCA transforms these
variance.
```
    # Variance along principal compoennts
    round(diag(cov(pca_food_cov$x)),2)
```
    ##       PC1       PC2       PC3       PC4       PC5       PC6       PC7 
    ## 274831.02  26415.99   6254.11   2299.90   2090.20    338.39     65.81
```
    # We can obtain the same result using built-in fucntion
    round(pca_food_cov$sdev^2,2)
```
    ## [1] 274831.02  26415.99   6254.11   2299.90   2090.20    338.39     65.81

### Performing covariance PCA manually using SVD
```
    svd_food_cov = svd(cent_food)
    # Loading scores
    round(svd_food_cov$v[,1:4],2) # We have printed only four columns
```
    ##       [,1]  [,2]  [,3]  [,4]
    ## [1,]  0.07 -0.58 -0.40  0.11
    ## [2,]  0.33 -0.41  0.29  0.61
    ## [3,]  0.30  0.10  0.34 -0.40
    ## [4,]  0.75  0.11 -0.07 -0.29
    ## [5,]  0.47  0.24 -0.38  0.33
    ## [6,]  0.09 -0.63  0.23 -0.41
    ## [7,] -0.06 -0.14 -0.66 -0.31
```
    # Factor scores
    round((cent_food %*% svd_food_cov$v)[,1:4],2) # only 4 columns printed
```
    ##          [,1]    [,2]    [,3]   [,4]
    ##  [1,] -635.05  120.89  -21.14 -68.97
    ##  [2,] -488.56  142.33  132.37  34.91
    ##  [3,]  112.03  139.75  -61.86  44.19
    ##  [4,] -520.01  -12.05    2.85 -13.70
    ##  [5,] -485.94   -1.17   65.75  11.51
    ##  [6,]  588.17  188.44  -71.85  28.56
    ##  [7,] -333.95 -144.54  -34.94  10.07
    ##  [8,]  -57.51  -42.86  -26.26 -46.55
    ##  [9,]  571.32  206.76  -38.45   3.69
    ## [10,]  -39.38 -264.47 -126.43 -12.74
    ## [11,]  296.04 -235.92   58.84  87.43
    ## [12,]  992.83  -97.15  121.13 -78.39
```
    # Variance of principal components
    round(svd_food_cov$d^2/11,2)
```
    ## [1] 274831.02  26415.99   6254.11   2299.90   2090.20    338.39     65.81

Our data matrix contains 12 data points. So to find variance of
principal components we have to divide the square of the diagonal matrix
by 11. To know the theory behind it, refer
[Part-I](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-i/)

### Performing covariance PCA using Eigen-decomoposition(Not recommended)

This procedure is not recommended because forming a covariance matrix is
computationally not efficient for large matrices if data matrix contains
smaller entries. So doing eigen analysis on covariance matrix may give
erroneous results. However, for our example we can use it to obtain
results.
```
    eigen_food_cov = eigen(cov(cent_food))
    # Loading scores
    round(eigen_food_cov$vectors[,1:4],2)
```
    ##       [,1]  [,2]  [,3]  [,4]
    ## [1,] -0.07  0.58 -0.40  0.11
    ## [2,] -0.33  0.41  0.29  0.61
    ## [3,] -0.30 -0.10  0.34 -0.40
    ## [4,] -0.75 -0.11 -0.07 -0.29
    ## [5,] -0.47 -0.24 -0.38  0.33
    ## [6,] -0.09  0.63  0.23 -0.41
    ## [7,]  0.06  0.14 -0.66 -0.31
```
    # Factor scores
    round((cent_food %*% eigen_food_cov$vectors)[,1:4],2)
```
    ##          [,1]    [,2]    [,3]   [,4]
    ##  [1,]  635.05 -120.89  -21.14 -68.97
    ##  [2,]  488.56 -142.33  132.37  34.91
    ##  [3,] -112.03 -139.75  -61.86  44.19
    ##  [4,]  520.01   12.05    2.85 -13.70
    ##  [5,]  485.94    1.17   65.75  11.51
    ##  [6,] -588.17 -188.44  -71.85  28.56
    ##  [7,]  333.95  144.54  -34.94  10.07
    ##  [8,]   57.51   42.86  -26.26 -46.55
    ##  [9,] -571.32 -206.76  -38.45   3.69
    ## [10,]   39.38  264.47 -126.43 -12.74
    ## [11,] -296.04  235.92   58.84  87.43
    ## [12,] -992.83   97.15  121.13 -78.39
```
    # Variance along principal components
    round(eigen_food_cov$values,2)
```
    ## [1] 274831.02  26415.99   6254.11   2299.90   2090.20    338.39     65.81

Instead of using the 'cov()' command to find the covariance matrix
manually and perform its eigen analysis.
```
    cov_matrix_manual_food = (1/11)*t(cent_food) %*% cent_food
    eigen_food_new = eigen(cov_matrix_manual_food)
    # Loading scores
    round(eigen_food_new$vectors[,1:4],2)
```
    ##       [,1]  [,2]  [,3]  [,4]
    ## [1,] -0.07  0.58 -0.40  0.11
    ## [2,] -0.33  0.41  0.29  0.61
    ## [3,] -0.30 -0.10  0.34 -0.40
    ## [4,] -0.75 -0.11 -0.07 -0.29
    ## [5,] -0.47 -0.24 -0.38  0.33
    ## [6,] -0.09  0.63  0.23 -0.41
    ## [7,]  0.06  0.14 -0.66 -0.31
```
    # Variance along principal components
    round(eigen_food_new$values,2)
```
    ## [1] 274831.02  26415.99   6254.11   2299.90   2090.20    338.39     65.81

There are also different ways to find total variance of the data matrix.
We will explore some of the options.
```
    # Total varaiance before transformation
    sum(diag(cov(cent_food)))
```
    ## [1] 312295.4

Note that total variance is invariant to translations. So calculating
the total variance on raw data will also give the same answer. Check it
to convince yourself.

Correlation PCA
---------------

When PCA is performed on a scaled data matrix (each variable is centered
as well as variance of each variable is one), it is called correlation
PCA. Before discussing correlation PCA we will take some time to see
different ways in which we can obtain correlation matrix.

### Different ways to obtain correlation matrix.
```
    # Using built-in command
    round(cor(food[,3:9]),2)[,1:4] # We have printed only four columns
```
    ##            bread vegetables fruit  meat
    ## bread       1.00       0.59  0.20  0.32
    ## vegetables  0.59       1.00  0.86  0.88
    ## fruit       0.20       0.86  1.00  0.96
    ## meat        0.32       0.88  0.96  1.00
    ## poultry     0.25       0.83  0.93  0.98
    ## milk        0.86       0.66  0.33  0.37
    ## wine        0.30      -0.36 -0.49 -0.44
```
    # manually
    round((1/11)*t(scale_food) %*% scale_food,2)[,1:4]
```
    ##            bread vegetables fruit  meat
    ## bread       1.00       0.59  0.20  0.32
    ## vegetables  0.59       1.00  0.86  0.88
    ## fruit       0.20       0.86  1.00  0.96
    ## meat        0.32       0.88  0.96  1.00
    ## poultry     0.25       0.83  0.93  0.98
    ## milk        0.86       0.66  0.33  0.37
    ## wine        0.30      -0.36 -0.49 -0.44

Performing correlation PCA using built-in function
--------------------------------------------------
```
    pca_food_cor = prcomp(food[,3:9],scale = T)
    # Loading scores
    round(pca_food_cor$rotation[,1:4],2) # Printed only four
```
    ##              PC1   PC2   PC3   PC4
    ## bread       0.24 -0.62  0.01 -0.54
    ## vegetables  0.47 -0.10  0.06 -0.02
    ## fruit       0.45  0.21 -0.15  0.55
    ## meat        0.46  0.14 -0.21 -0.05
    ## poultry     0.44  0.20 -0.36 -0.32
    ## milk        0.28 -0.52  0.44  0.45
    ## wine       -0.21 -0.48 -0.78  0.31
```
    # Factor scores
    round(pca_food_cor$x[,1:4],2)
```
    ##         PC1   PC2   PC3   PC4
    ##  [1,] -2.86  0.36 -0.40  0.36
    ##  [2,] -1.89  1.79  1.31 -0.16
    ##  [3,] -0.12  0.73 -1.42  0.20
    ##  [4,] -2.04 -0.32  0.11  0.10
    ##  [5,] -1.69  0.16  0.51  0.16
    ##  [6,]  1.69  1.35 -0.99 -0.43
    ##  [7,] -0.93 -1.37  0.28 -0.26
    ##  [8,] -0.25 -0.63 -0.27  0.29
    ##  [9,]  1.60  1.74 -0.10 -0.40
    ## [10,]  0.22 -2.78 -0.57 -0.25
    ## [11,]  1.95 -1.13  0.99 -0.32
    ## [12,]  4.32  0.10  0.57  0.72
```
    # Variances along principal componentes
    round(pca_food_cor$sdev^2,2)
```
    ## [1] 4.33 1.83 0.63 0.13 0.06 0.02 0.00
```
    # Sum of vairances
    sum(pca_food_cor$sdev^2)
```
    ## [1] 7

Comparison of variance before and after transformation
------------------------------------------------------
```
    # Total variance before transformation
    sum(diag(cov(scale_food)))
```
    ## [1] 7
```
    # Total variance after transformation
    sum(diag(cov(pca_food_cor$x)))
```
    ## [1] 7

Another important observation is to see how variance of each variable
before transformation changes into variance of principal components.
Note that total variance in this process remains same as seen from above
codes.
```
    # Variance along variables before transformation
    round(diag(cov(scale_food)),2)
```
    ##      bread vegetables      fruit       meat    poultry       milk 
    ##          1          1          1          1          1          1 
    ##       wine 
    ##          1

This is obvious as we have scaled the matrix. Now see how PCA transforms
these variance.
```
    # Variance along principal compoennts
    round(diag(cov(pca_food_cor$x)),2)
```
    ##  PC1  PC2  PC3  PC4  PC5  PC6  PC7 
    ## 4.33 1.83 0.63 0.13 0.06 0.02 0.00
```
    # We can obtain the same result using built-in fucntion
    round(pca_food_cor$sdev^2,2)
```
    ## [1] 4.33 1.83 0.63 0.13 0.06 0.02 0.00

### Performing correlation PCA manually using SVD
```
    svd_food_cor = svd(scale_food)
    # Loading scores
    round(svd_food_cor$v[,1:4],2)
```
    ##       [,1]  [,2]  [,3]  [,4]
    ## [1,]  0.24 -0.62  0.01 -0.54
    ## [2,]  0.47 -0.10  0.06 -0.02
    ## [3,]  0.45  0.21 -0.15  0.55
    ## [4,]  0.46  0.14 -0.21 -0.05
    ## [5,]  0.44  0.20 -0.36 -0.32
    ## [6,]  0.28 -0.52  0.44  0.45
    ## [7,] -0.21 -0.48 -0.78  0.31
```
    # Factor scores
    round((scale_food %*% svd_food_cor$v)[,1:4],2)
```
    ##        [,1]  [,2]  [,3]  [,4]
    ##  [1,] -2.86  0.36 -0.40  0.36
    ##  [2,] -1.89  1.79  1.31 -0.16
    ##  [3,] -0.12  0.73 -1.42  0.20
    ##  [4,] -2.04 -0.32  0.11  0.10
    ##  [5,] -1.69  0.16  0.51  0.16
    ##  [6,]  1.69  1.35 -0.99 -0.43
    ##  [7,] -0.93 -1.37  0.28 -0.26
    ##  [8,] -0.25 -0.63 -0.27  0.29
    ##  [9,]  1.60  1.74 -0.10 -0.40
    ## [10,]  0.22 -2.78 -0.57 -0.25
    ## [11,]  1.95 -1.13  0.99 -0.32
    ## [12,]  4.32  0.10  0.57  0.72
```
    # Variance along each principcal component
    round(svd_food_cor$d^2/11,2)
```
    ## [1] 4.33 1.83 0.63 0.13 0.06 0.02 0.00
```
    # Sum of variances
    sum(svd_food_cor$d^2/11)
```
    ## [1] 7

Again we have to divide by 11 to get eigenvalues of correlation matrix.
Check the formulation of correlation matrix using scaled data matrix to
convince yourself.

### Using eigen-decomposition (Not Recommended)
```
    eigen_food_cor = eigen(cor(food[,3:9]))
    # Loading scores
    round(eigen_food_cor$vectors)
```
    ##      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
    ## [1,]    0    1    0   -1    0    1    0
    ## [2,]    0    0    0    0    1    0    0
    ## [3,]    0    0    0    1    0    1    0
    ## [4,]    0    0    0    0    0    0    1
    ## [5,]    0    0    0    0    0    0   -1
    ## [6,]    0    1    0    0    0    0    0
    ## [7,]    0    0   -1    0    0    0    0
```
    # Factor scores
    round((scale_food %*% eigen_food_cor$vectors)[,1:4],2)
```
    ##        [,1]  [,2]  [,3]  [,4]
    ##  [1,]  2.86 -0.36 -0.40  0.36
    ##  [2,]  1.89 -1.79  1.31 -0.16
    ##  [3,]  0.12 -0.73 -1.42  0.20
    ##  [4,]  2.04  0.32  0.11  0.10
    ##  [5,]  1.69 -0.16  0.51  0.16
    ##  [6,] -1.69 -1.35 -0.99 -0.43
    ##  [7,]  0.93  1.37  0.28 -0.26
    ##  [8,]  0.25  0.63 -0.27  0.29
    ##  [9,] -1.60 -1.74 -0.10 -0.40
    ## [10,] -0.22  2.78 -0.57 -0.25
    ## [11,] -1.95  1.13  0.99 -0.32
    ## [12,] -4.32 -0.10  0.57  0.72
```
    # Variances along each principal component
    round(eigen_food_cor$values,2)
```
    ## [1] 4.33 1.83 0.63 0.13 0.06 0.02 0.00

I hope this post would help clear some of the confusions that a beginner
might have while encountering PCA for the first time. Please comment
below if you find any errors.

References
----------

1.  I.T. Jolliffe, Principal component analysis, 2nd ed, Springer, New
    York,2002.
2.  Abdi, H., & Williams, L. J. (2010). Principal component analysis.
    Wiley interdisciplinary reviews: computational statistics, 2(4),
    433-459.
