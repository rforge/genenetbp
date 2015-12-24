\name{mouse}
\docType{data}
\alias{mouse}
\title{\emph{Mus Musculus} Kidney eQTL data from Hageman \emph{et. al.} (2011)
}
\description{Kidney eQTL data was obtained from a F2 inner-cross between inbred MRL/MpJ and SM/J strains of mice.
}
\usage{
data(mouse)
}
\format{The data set \code{mouse} contains the following variables:
\itemize{
\item{mousegeno}{  a data frame of 173 observations of 5 variables. All column vectors are of class factor}
\item{mousepheno}{ a data frame of 173 observations of 14 variables. All column vectors are of class numeric }
}
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
# load the data and fit a genotype-phenotype network
data(mouse)
\dontrun{fit.gnbp(geno,pheno)}
}
\keyword{datasets}
