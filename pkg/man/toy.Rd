\name{toy}
\docType{data}
\alias{toy}
\title{Toy example dataset 
}
\description{Toy example, Simulated data set 
}
\usage{
data(toy)
}
\format{The data set \code{toy} contains the following variables:
\itemize{
\item{toygeno}{ a data frame of 500 observations of 3 variables. All column vectors are of class factor}
\item{toypheno}{ a data frame of 500 observations of 6 variables. All column vectors are of class numeric }
}
}
\details{
The simulated dataset consists of 3 genotypes each with 2 states and 6 phenotypes.
}

\examples{
\dontrun{
# load the data and fit a genotype-phenotype network
data(toy)
fit.gnbp(toygeno,toypheno)}
}
\keyword{datasets}
