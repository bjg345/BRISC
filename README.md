BRISC
====

## Overview
Bootstrap for Rapid Inference on Spatial Covariances: Provides parameter estimates and bootstrap based confidence intervals for all parameters in a Gaussian Process based spatial regression model.


## Installation
In order to download the package, please run the following command in R:

```{r }
if (!require("devtools")) install.packages("devtools")
devtools::install_github("ArkajyotiSaha/BRISC")
```

## Function description
For help on the functions in Brisc please use the following:
```{r }
?BRISC_estimation #(for estimation)

?BRISC_bootstrap #(for bootstrap)

?BRISC_prediction #(for prediction)
```

## Note
The code of package "liblbfgs (Naoaki Okazaki)" are also available here for user convenience. Some code snippets are borrowed from R package "spNNGP (Andrew Finley et al.)". The code for approximate MMD ordering is borrowed from https://github.com/joeguinness/gp_reorder after minor modifications. The code for configure.ac is borrowed from https://github.com/cran/ARTP2/blob/master/configure.ac with minor adaptations. The code for covariance models other than exponential model are in beta testing stage.


## Citation
Please cite the following paper when you use BRISC

Saha, A., & Datta, A. (2018). BRISC: bootstrap for rapid inference on spatial covariances. Stat, e184, DOI: 10.1002/sta4.184.


## References:
1. Vecchia, A. V. (1988). Estimation and model identification for continuous spatial processes. Journal of the Royal Statistical Society. Series B (Methodological), 297-312.

2. Datta, A., Banerjee, S., Finley, A. O., & Gelfand, A. E. (2016). Hierarchical nearest-neighbor Gaussian process models for large geostatistical datasets. Journal of the American Statistical Association, 111(514), 800-812.

3. Guinness, J. (2018). Permutation and Grouping Methods for Sharpening Gaussian Process Approximations. Technometrics, DOI: 10.1080/00401706.2018.1437476.

4. Saha, A., & Datta, A. (2018). BRISC: bootstrap for rapid inference on spatial covariances. Stat, e184, DOI: 10.1002/sta4.184.

