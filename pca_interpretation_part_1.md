This post is related to Principal Component Analysis (PCA), one of the
most popular dimensionality reduction techniques used in machine
learning. The application of PCA and its variants are ubiquitous. In
almost all software, such as MATLAB, R, etc., built-in commands are
available to perform PCA. In this post we will show how can we obtain
results of PCA from raw data first using and then without using built in
commands. Then we will reproduce the results of a published paper on PCA
that is very popular in academic circles. The post is divided into three
parts to make it manageable to read. Readers who are totally familiar
with PCA should read none and leave the page immediately. Other readers
who are familiar with PCA but want to see different implementations,
should jump to the part they wish to read. Absolute beginners should
start with Part-I and work their way through gradually. Beginners are
also encouraged to explore the references for further information. Here
is the outline of different parts:

-   [Part-I: Basic Theory of
    PCA](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-i/)
-   [Part-II: PCA Implementation with and without using built-in
    functions](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-ii/)
-   [Part-III: Reproducing results of a published paper on
    PCA](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-iii/)

For
[Part-II](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-ii/),
both MATLAB and R codes are available to reproduce all the results.
[Part-III](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-iii/)
contains only R codes. Equivalent [MATLAB
codes](https://github.com/biswajitsahoo1111/PCA/blob/master/pca_part_II_MATLAB_codes.pdf)
can be obtained by using commands of
[Part-II](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-ii/).
In this post, we will discuss the theory behind PCA.

Principal Component Analysis (PCA) is one of the most popular
dimensionality reduction techniques. Though its origin dates back to
early 20th century, it has never gone out of fashion it seems. Its
popularity grows steady as can be gauged by the number of papers and
articles published related to PCA or its variants.

All popular programming platforms contain built in functions that
perform PCA given a data matrix. In this blog we will use the open
source statistical programming environment R to demonstrate the result.

We will also show how we can obtain the results using simple matrix
operations without using the built-in function.

In this blog we will reproduce using R all the results of an immensely
popular paper on PCA by Abdi et. al. The paper got published in 2010 and
within 8 years it has got more than 3800 citations. The data will be
taken from the paper itself.

Principal Component Analysis
============================

Theory:
-------

The usual convention is to place variables as columns and different
observations as rows (Data frames in R follow this convention). For
example, let's suppose we are collecting data about daily weather for a
year. Our variables of interest may include maximum temperature in a
day, minimum temperature, humidity, max. wind speed, etc. For every day,
we have to collect observations for each of these variables. In vector
form, our data point for one day will contain number of observations
equal to the number of variables under study and this becomes one row of
our data matrix. Assuming that we are observing 10 variables everyday,
our data matrix for one year (assuming it's not a leap year) will
contain 365 rows and 10 columns. Once data matrix is obtained, further
analysis is done on this data matrix to obtain important hidden
information regarding the data. We will use notations from matrix theory
to simplify our analysis.

Let be the data matrix of size *n* × *p*, where is the number of data
points and is the number of variables. We can assume without any loss of
generality that is centered, meaning its column means are zero. This
only shifts the data towards the origin without changing their relative
orientation. So if originally is not centered, it is first centered
before doing PCA. From now onward we will assume that is always
centered.

Variance of a variable (a column)in **X** is equal to sum of squares of
entries (because the column is centered) of that column divided by (n -
1) to make it unbiased. So sum of variance of all variables is
$\\frac{1}{n - 1}$ times sum of squares of all elements of the matrix .
Readers who are familiar with matrix norms would instantly recognize
that total variance is $\\frac{1}{n - 1}$ times the square of
**Frobenius norm** of **X**.

Total variance before transformation =
$$\\frac{1}{n-1}\\sum\_{i,j}{x\_{ij}^2}=trace(\\frac{1}{n-1}\\textbf{X}^T\\textbf{X})=\\frac{1}{n-1}\\|\\textbf{X}\\|\_{F}^2$$
 Where trace of a matrix is sum of its diagonal entries.

The aim of PCA is to transform the data in such a way that along first
principal direction, variance of transformed data is maximum. It
subsequently finds second principal direction orthogonal to the first
one in such a way that it explains maximum of the remaining variance
among all possible direction in the orthogonal subspace.

In matrix form the transformation can be written as
**Y**<sub>*n* × *p*</sub> = **X**<sub>*n* × *p*</sub>**P**<sub>*p* × *p*</sub>
 Where **Y** is the transformed data matrix. The columns of **Y** are
called principal components and **P** is usually called loading matrix.
Our aim is to find matrix **P**. Once we find **P** we can then find
**Y** just by a matrix multiplication. Though we will not go into to
proof here, it can be easily proved (see references), that matrix **P**
is the eigenvector matrix of the covariance matrix. Let's first define
covariance matrix.

Given a data matrix **X**(centered), its covariance matrix (**S**) is
defined as
$$S = \\frac{1}{n-1}\\textbf{X}^T\\textbf{X}$$
 As principal directions are orthogonal, we will also require **P** to
be an orthogonal matrix.

Now, it is straightforward to form the covariance matrix and by placing
its eigenvectors as columns, we can find matrix **P** and consequently
the principal components. The eigenvectors are arranged in such a way
that first column is the eigenvector corresponding to largest
eigenvector, second column (second eigenvector) corresponds to second
largest eigenvalue and so on. Here we have assumed that we will always
be able to find all the *p* orthogonal eigenvectors. In fact, we will
always be able to find *p* orthogonal eigenvectors as the matrix is
symmetric. It can also be shown that the transformed matrix **Y** is
centered and more remarkably, total variance of columns of **Y** is same
as total variance of columns of **X**. We will prove these two
propositions as the proof are short.

Let **1** be a column vector of all ones of size (*n* × 1). To prove
that columns of **Y** are centered, just premultiply it by
**1**<sup>*T*</sup> (this finds column sum for each column). So
**1**<sup>*T*</sup>**Y** = **1**<sup>*T*</sup>**X****P**
 But columns of **X** are already centered, so
**1**<sup>*T*</sup>**X** = **0**. Thus **1**<sup>*T*</sup>**Y** = **0**.
Hence columns of **Y** are centered.

To prove that total variance of **Y** also remains same, observe that

total covariance of **Y** =
$$trace(\\frac{1}{n-1}\\textbf{Y}^{T}\\textbf{Y})=\\frac{1}{n-1}trace((\\textbf{P}^T\\textbf{X}^{T}\\textbf{X})\\textbf{P})=\\\\\\frac{1}{n-1}trace((\\textbf{P}\\textbf{P}^T)\\textbf{X}^{T}\\textbf{X})=trace(\\frac{1}{n-1}\\textbf{X}^T\\textbf{X})$$
 The previous equation uses the fact that trace is
commutative(i.e.*t**r**a**c**e*(**AB**)=*t**r**a**c**e*(**BA**)) and
**P** is orthogonal (i.e. **P****P**<sup>*T*</sup> = **I**).

### Link between total variance and eigenvalues

Total variance is sum of eigenvalues of covriance matrix (**S**). We
will further discuss this point in
[Part-II](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-ii/).

### Variations in PCA

Sometimes our data matrix contains variables that are measured in
different units. So we might have to scale the centered matrix to reduce
the effect of variables with large variation. So depending on the matrix
on which PCA is performed, it is divided into two types.

-   Covariance PCA (Data matrix is centered but not scaled)
-   Correlation PCA (Data matrix is centered and scaled)

Examples of these two types can be found in
[Part-II](https://biswajitsahoo1111.wordpress.com/2018/12/28/principal-component-analysis---part-ii/).

Some common terminology associated with PCA:
--------------------------------------------

-   Factor scores corresponding to a principal component

Values of that column of **Y** that corresponds to the principal
component.

-   Loading score

Values corresponding to a column of **P**. For example,loading scores of
variables corresponding to first principal component are the values of
the first column of **P**.

-   Inertia

Square of Frobenius norm of the matrix.

### How actually are principal components computed

The previously stated method of finding eigenvectors of covariance
matrix is not computationally effective. In practice, singular value
decomposition (SVD) is used to find the matrix **P**. SVD theorem tells
that any real matrix **X** can be decomposed into three matrices such
that
**X** = **U***Σ***V**<sup>*T*</sup>
 Where, **X** is of size *n* × *p*. **U** and **V** are orthogonal
matrices of size *n* × *n* and *p* × *p* respectively. *Σ* is a diagonal
matrix of size *n* × *p*.

Given the SVD decomposition of a matrix **X**,
**X**<sup>*T*</sup>**X** = **V***Σ*<sup>2</sup>**V**<sup>*T*</sup>
 This is the eigen-decomposition of **X**<sup>*T*</sup>**X**. So **V**
is the eigenvector matrix of **X**<sup>*T*</sup>**X**. For PCA we need
eigenvector matrix of covariance matrix. So converting the equation into
convenient form, we get
$$\\textbf{S} = \\frac{1}{n-1}\\textbf{X}^T\\textbf{X}=\\textbf{V}(\\frac{1}{n-1}\\Sigma^2)\\textbf{V}^T$$
 Thus eigenvalues of S are diagonal entries of
$(\\frac{1}{n-1}\\Sigma^2)$. As SVD is computationally efficient, all
built-in functions use SVD to find the loading matrix and then use it to
find principal components.

In the interest of keeping the post at a reasonable length, we will stop
our exposition of theory here. Whatever we have discussed is only a
fraction of everything. Entire books have been written on PCA.
Interested readers who want to pursue further can refer to the
references given here and later to the references given in the
references. Please comment below if you find any errors.

References
----------

1.  I.T. Jolliffe, Principal component analysis, 2nd ed, Springer, New
    York,2002.
2.  Abdi, H., & Williams, L. J. (2010). Principal component analysis.
    Wiley interdisciplinary reviews: computational statistics, 2(4),
    433-459.
