BRISC_correlation <- function(coords, sim, sigma.sq = 1, tau.sq = 0, phi = 1, nu = 0.5, n.neighbors = 15, n_omp = 1,
                             cov.model = "exponential", search.type = "tree", verbose = TRUE
){
  n <- nrow(coords)
  ##Coords
  if(!is.matrix(coords)){stop("error: coords must n-by-2 matrix of xy-coordinate locations")}
  if(ncol(coords) != 2 || nrow(coords) != n){
    stop("error: either the coords have more than two columns or then number of rows is different than
         data used in the model formula")
  }
  coords <- round(coords, 14)

  if(tau.sq < 0 ){stop("error: tau.sq must be non-negative")}
  if(sigma.sq < 0 ){stop("error: sigma.sq must be non-negative")}
  if(phi < 0 ){stop("error: phi must be non-negative")}
  if(nu < 0 ){stop("error: nu must be non-negative")}

  if(!is.matrix(sim)){stop("error: sim must n-by-k matrix")}
  if(nrow(sim)!=n){stop("error: sim must n-by-k matrix")}
  sim_number <- ncol(sim)

  ##Covariance model
  cov.model.names <- c("exponential","spherical","matern","gaussian")
  cov.model.indx <- which(cov.model == cov.model.names) - 1
  storage.mode(cov.model.indx) <- "integer"


  ##Parameter values
  if(cov.model!="matern"){
    initiate <- c(sigma.sq, tau.sq, phi)
    names(initiate) <- c("sigma.sq", "tau.sq", "phi")
  }
  else{
    initiate <- c(sigma.sq, tau.sq, phi, nu)
    names(initiate) <- c("sigma.sq", "tau.sq", "phi", "nu")}

  alpha.sq.starting <- sqrt(tau.sq/sigma.sq)
  phi.starting <- sqrt(phi)
  nu.starting <- sqrt(nu)

  storage.mode(alpha.sq.starting) <- "double"
  storage.mode(phi.starting) <- "double"
  storage.mode(nu.starting) <- "double"


  ##Search type
  search.type.names <- c("brute", "tree")
  if(!search.type %in% search.type.names){
    stop("error: specified search.type '",search.type,"' is not a valid option; choose from ", paste(search.type.names, collapse=", ", sep="") ,".")
  }
  search.type.indx <- which(search.type == search.type.names)-1
  storage.mode(search.type.indx) <- "integer"


  ##Option for Multithreading if compiled with OpenMp support
  n.omp.threads <- as.integer(n_omp)
  storage.mode(n.omp.threads) <- "integer"

  fix_nugget <- 1
  ##type conversion
  storage.mode(n) <- "integer"
  storage.mode(coords) <- "double"
  storage.mode(n.neighbors) <- "integer"
  storage.mode(verbose) <- "integer"
  storage.mode(sim) <- "double"
  storage.mode(sim_number) <- "integer"
  storage.mode(fix_nugget) <- "double"

  p1<- proc.time()


  ##estimtion
  result <- .Call("BRISC_correlationcpp", n, n.neighbors, coords, cov.model.indx, alpha.sq.starting, phi.starting, nu.starting, search.type.indx, n.omp.threads, verbose, sim, sim_number, fix_nugget,
                 PACKAGE = "BRISC")

  p2 <- proc.time()

  Theta <- initiate
  if(cov.model!="matern"){
    names(Theta) <- c("sigma.sq", "tau.sq", "phi")
  }
  else{names(Theta) <- c("sigma.sq", "tau.sq", "phi", "nu")}

  simulated.data <- matrix(result$sim*sqrt(sigma.sq),n,sim_number)


  result_list <- list ()
  result_list$coords <- coords
  result_list$n.neighbors <- n.neighbors
  result_list$cov.model <- cov.model
  result_list$Theta <- Theta
  result_list$time <-  p2 - p1
  result_list$input.data <- sim
  result_list$output.data <-  simulated.data
  result_list
}
