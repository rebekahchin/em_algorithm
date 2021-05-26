# em_algorithm
EM algorithm for improving factors found with during factor analysis

## What is the EM algorithm?

## What does this code do?

## Using the R file
### Prerequisites
* R 4.0.5
* the openblas package
 
### Description
Given a matrix of observations, a matrix of factor loadings, and a diagonal matrix of the variance of the errors, `em` iteratively computes a new factor loadings and variance of errors until they converge with the previous terms. \
`em` returns a list of the new factor loadings, variance of errors, and the score of the new factor loadings. 

### Usage
    em(Z,L,psi,tol,maxite)

### Arguments
Arguments | Description
--------- | --------------
`Z` | a *normalized* numeric data matrix or data frame that provided the data for factor analysis
`L` | a numeric data matrix of factor loadings
`psi` | a diagonal numeric data matrix of the variance of the errror term, ε
`tol` | maximum error between the new and old **L** and **Ψ**. Recommended value: `10^-5`
`maxite` | maximum iterations before function quits. Recommended value: `1000` 

### Details
`em` uses `cov` to determine the correlation matrix of `Z`, `solve` to invert matrices, and `diag` to obtain a new **Ψ**.

### Values
`em` returns a generic list containing the following components: \
Values | Description
------ | -----------
`L_new` | a numeric data matrix of improved factor loadings
`psi_new` | a diagonal numeric data matrix of the new variance of the error term
`scores` | a numeric data matrix of the scores calculated using the `L_new`

### Notes
You can use the priciple component method to calculate `L`.
Given an `(nxp)` matrix of observations, `X`, `L` would be a `(pxk)` matrix where `k ≤ 0.5p`. 
`k` is determined by plotting a scree diagram of eigenvalues of the variance of each component against the number of components in the model. A smaller `k` is preferred. \
`L` is then a matrix of vectors of ![image](https://user-images.githubusercontent.com/83638650/119684020-bf4f5d80-be76-11eb-80b9-5482f25298f0.png) for j=1,...,k, where ![image](https://user-images.githubusercontent.com/83638650/119684474-1bb27d00-be77-11eb-8f05-ddd76898d938.png) is an eigenvalue and its corresponding eigenvector of the correlation matrix `R`. Note that the eigenvalue-eigenvector pair are arranged from largest to smallest eigenvalue. \
`psi` is then calculated using ![image](https://user-images.githubusercontent.com/83638650/119685786-40f3bb00-be78-11eb-9794-2116563f3c42.png), where the non-diagonal entries are zero.\

## References
1. H. Peng, *EM algorithm for factor models*, 2021, https://www.math.hkbu.edu.hk/~hpeng/Math3806/EM-factor.html (accessed 2021/05/14).
2. R. A. Johnson, D. W. Wichern, *Applied Multivariate Statistical Analysis*, Pearson Prentice Hall, Upper Saddle River, New Jersey, 2007.
