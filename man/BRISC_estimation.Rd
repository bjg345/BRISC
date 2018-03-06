\name{BRISC_estimation}
\alias{BRISC_estimation}
\title{Function for estimation with BRISC}

\description{
  The function \code{BRISC_estimation} fits univariate spatial
  regression models using BRISC with Nearest Neighbor Gaussian Processes (NNGP).
}

\usage{
BRISC_estimation(coords, x, y, sigma.sq = 1, tau.sq = 0.1, phi = 1, nu = 0.5, n.neighbors = 15, n_omp = 1, order = "MMD", cov.model = "exponential", search.type = "tree", verbose = FALSE, eps = 2e-05)
}

\arguments{

  \item{coords}{an \eqn{n \times 2}{n x 2} matrix of the observation
  coordinates in \eqn{R^2}{R^2} (e.g., easting and northing). }

  \item{x}{an \eqn{n \times p}{n x p} matrix of the covariates in the observation coordinates. }

  \item{y}{a \eqn{n}{n} length vector of response at the observed coordinates. }

  \item{sigma.sq}{starting value of sigma square. Default value is 1. }

  \item{tau.sq}{starting value of tau square. Default value is 0.1. }

  \item{phi}{starting value of phi. Default value is 1. }

  \item{nu}{starting value of nu, only required for matern covariance model. Default value is 0.5. }

  \item{n.neighbors}{number of neighbors used in the NNGP. Default value is 15. }

  \item{n_omp}{number of threads to be used, value can be more than 1 if source code is compiled with OpenMP support. Default is 1. }

  \item{order}{Keyword that specifies the ordering scheme to be used in ordering the observations. Supported keywords are: "MMD" and "Sum_coords" for approximate Maximum Minimum Distance and sum of coordinate based ordering, respectively. Default value is "MMD". }

  \item{cov.model}{Keyword that specifies the covariance function to be used in modelling the spatial dependence structure among the observations. Supported keywords are: "exponential", "matern", "spherical", and "gaussian" for exponential, matern, spherical and gaussian covariance function respectively. Default value is "exponential". }

  \item{search.type}{Keyword that specifies type of nearest neighbor search algorithm to be used. Supported keywords are: "tree" and "brute". Both of them provide the same result, though "tree" should be faster. Default value is "tree". }

  \item{verbose}{if TRUE, model specifications along with information regarding OpenMP support and progress of the algorithm is printed to the screen. Otherwise, nothing is printed to the screen. Default value is FALSE. }

  \item{eps}{The tolerance to be used in centred finite difference approximation of derivatives. Default value is 2e-05. }
}

\value{
  An object of class \code{BRISC_Out}, which is a list comprising:

  \item{ord}{the vector of indices used to order data necessary for fitting the NNGP
    model.}

  \item{coords}{the matrix \code{coords[ord,]}. }

  \item{y}{the vector \code{y[ord]}. }

  \item{X}{the matrix \code{x[ord,,drop=FALSE]}. }

  \item{n.neighbors}{the used value of \code{n.neighbors}. }

  \item{cov.model}{the used covariance model. }

  \item{eps}{value of used \code{eps}. }

  \item{init}{Initial values of the parameters of the covariance model. }

  \item{Beta}{estimate of beta. }

  \item{Theta}{estimate of parameters of covarinace model. }

   \item{estimation.time}{time (in seconds) required to perform the model fitting after ordering and preprocessing data in R, reported using \code{proc.time()}. }

  \item{BRISC_Object}{Object required for bootstrap and prediction. }

}


\author{
  Arkajyoti Saha \email{asaha8@jhmi.edu}, \cr
  Abhirup Datta \email{abhidatta@jhu.edu}
}

\examples{

rmvn <- function(n, mu = 0, V = matrix(1)){
  p <- length(mu)
  if(any(is.na(match(dim(V),p))))
    stop("Dimension not right!")
  D <- chol(V)
  t(matrix(rnorm(n*p), ncol=p)\%*\%D + rep(mu,rep(n,p)))
}

set.seed(1)
n <- 1000
coords <- cbind(runif(n,0,1), runif(n,0,1))

beta <- c(1,5)
x <- cbind(rnorm(n), rnorm(n))

sigma.sq = 1
phi = 5
tau.sq = 0.1

B <- as.matrix(beta)
D <- as.matrix(dist(coords))
R <- exp(-phi*D)
w <- rmvn(1, rep(0,n), sigma.sq*R)

y <- rnorm(n, x\%*\%B + w, sqrt(tau.sq))

estimation_result <- BRISC_estimation(coords, x, y)
estimation_result$Theta ## Gives estimation of covariance model parameters.
estimation_result$Beta ## Gives estimation of Beta

}

\keyword{model}