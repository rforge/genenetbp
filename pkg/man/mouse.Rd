\name{mouse}
\docType{data}
\alias{mouse}
\title{Mus Musculus Kidney eQTL data from Hageman et. al. (2011)
} 
\description{Kidney eQTL data was obtained from a F2 inner-cross between inbred MRL/MpJ and SM/J strains of mice.
}
\usage{
data(mouse)
}
\format{The data set \code{mouse} is a data frame consisting of 173 observations of 19 variables: genotype data (genotype states at 5 SNP markers) and phenotype data (normalized expression data of 14 genes).   Genotype data is of class \code{factor} and phenotype data is of  class \code{numeric}. }
}

\details{
Kidney eQTL data was obtained from a F2 inner-cross between inbred MRL/MpJ and SM/J strains of mice.
}
\source{
Hageman,R.S., Leduc,M.S., Caputo,C.R., Tsaih,S.-W., Churchill,
G.A., and Korstanje,R.(2011). "Uncovering genes and regulatory pathways related
to urinary albumin excretion." \emph{Journal of the American Society of Nephrology22}, 1, 73-81.
}

\examples{
\dontrun{
# load the data and fit a genotype-phenotype network
data(mouse)
fit.gnbp(mousegeno,mousepheno)
}
}
\keyword{datasets}
