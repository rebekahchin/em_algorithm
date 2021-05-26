# em_algorithm
EM algorithm for improving factors found with principle component method

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
`Z` | a *normalized* numeric data matrix or data frame that provided the data for factor analysis \
`L` | a numeric data matrix of factor loadings found with the principle component method during factor analysis \
`psi` | a diagonal numeric data matrix of the variance of the errror term, ε \
`tol` | maximum error between the new and old **L** and **Ψ**. Recommended value: `10^-5` \
`maxite` | maximum iterations before function quits. Recommended value: `1000` 

### Details
`em` uses `cov` to determine the correlation matrix of `Z`, `solve` to invert matrices, and `diag` to obtain a new **Ψ**.

### Values
`em` returns a generic list containing the following components: \
Values | Description
------ | -----------
`L_new` | a numeric data matrix of improved factor loadings \
`psi_new` | a diagonal numeric data matrix of the new variance of the error term \
`scores` | a numeric data matrix of the scores calculated using the `L_new`

## References
