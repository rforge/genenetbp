\name{yeast}
\docType{data}
\alias{yeast}
\title{Saccharomyces Cerevisiae eQTL data from Kruglak et. al. (2005)
}
\description{eQTL data from 112 F1 segregants from a cross between BY4716 and RM11-1a strains of \emph{Saccharomyces Cerevisiae}.
}

\usage{
data(yeast)
}
\format{The data set \code{yeast} is a data frame of 112 observations of 25 variables: genotype data (genotype states at 9 SNP markers) and phenotype data (normalized expression values of 16 genes).Genotypes are of class \code{factor} and phenotypes are of class \code{numeric}.
}

}
\details{
The \code{yeast} dataset is a subset of the widely studied yeast expression dataset comprising of 112 F1 segregants from a cross between BY4716 and RM11-1a strains of \emph{Saccharomyces Cerevisiae}. The original dataset consists of expression values reported as log2(sample/ BY reference) for 6216 genes. The data can be accessed in Gene Expression Omnibus (GEO) by accession number (GSE1990). After linkage analysis and filtering based on location and significance of QTL, a final set of 16 genes and their corresponding 9 SNP markers were identified and included in the yeast dataset.\\ 

Thus the final dataset is a data frame of 112 observations (genotype) of 9 variables (SNP markers)  and normalized gene expression of 16 variables (genes).\\
}
\source{
Brem RB, Kruglyak L. The landscape of genetic complexity across 5,700 gene expression traits in yeast. Proc Natl Acad Sci U S A 2005 Feb 1;102(5):1572-7.\\

Brem RB, Storey JD, Whittle J, Kruglyak L. Genetic interactions between polymorphisms that affect gene expression in yeast. Nature 2005 Aug 4;436(7051):701-3.\\
}


\examples{
\dontrun{
# load the data and fit a genotype-phenotype network
data(yeast)
fit.gnbp(yeastgeno,yeastpheno)
}
}
\keyword{datasets}
