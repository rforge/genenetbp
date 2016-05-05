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
\format{The data set \code{toy} is a data frame of 500 observations of 9 variables: genotype data (genotype states at 3 SNP markers) and phenotype data (6 variables).Genotypes are of class \code{factor} and phenotypes are of class \code{numeric}.
}

\details{
The simulated dataset consists of 3 genotypes each with 2 states and 6 phenotypes.
}

\examples{
\dontrun{
# load the data and fit a genotype-phenotype network
data(toy)
fit.gnbp(toy[,1:3],toy[,4:9])}
}
\keyword{datasets}
