\name{geneNetBP-package}
\alias{geneNetBP-package}
\alias{geneNetBP}
\docType{package}
\title{Belief Propagation in Genotype-Phenotype Networks}
\description{The geneNetBP package implements algorithms to infer Conditional Gaussian Bayesian Networks (CG-BN) from genotype-phenotype or Quantitative Trait Loci (QTL) data, absorb evidence in the network and quantify and visualize the changes in network beliefs. Inference of Discrete Bayesian networks is also supported. 
}
\details{
\tabular{ll}{
Package: \tab geneNetBP\cr
Type: \tab Package\cr
Version: \tab 1.0.0\cr
Date: \tab 2016-05-14\cr
License: \tab GPL-2\cr
}
This package implements structure learning and conditional probability learning methods from the packages \code{RHugin}, \pkg{gRain} and \pkg{bnlearn} to Quantative Trait Loci (QTL) data and provides functions to query and visualize the network beliefs. The function \code{\link{fit.gnbp}} can be used to learn conditional gaussian bayesian networks from genotype-phenotype data while and \code{\link{fit.dbn}} allows infering discrete bayesian networks from categorical data. The main function for absorbing evidence and quantifying the changes in beliefs is \code{\link{absorb.gnbp}} for CG-BN and \code{\link{absorb.dbn}} for discrete networks. A generic \code{plot} method is available for visualizing network beliefs. 

For belief propagation in CG-BN, the package makes extensive use of \code{RHugin} package that provides an R interface for the Hugin Decision Engine (commercial software for belief propagation). geneNetBP is compatible with demo versino of HuginLite. Note that the demo version of Hugin is restricted to 50 states and 500 cases.The package {RHugin} is not available on CRAN and can be obtained from R-Forge by accessing the link given below. Hugin Decision Engine should also be installed. Please visit the project homepage for installation instructions. 

For discrete bayesian networks, algorithms from the package \pkg{bnlearn} are implemented for structural learning while belief propagation is implemented using \pkg{gRain}. 

All the functions in the geneNetBP package are documented. For a complete list of functions, use the command ls(pos = "package:geneNetBP"). A vignette illustrating the use of geneNetBP is available. 

}
\author{
Janhavi Moharil <janhavim@buffalo.edu>

Maintainer: Janhavi Moharil <janhavim@buffalo.edu> 
}
\references{

Janhavi Moharil, Paul May, Daniel P. Gaile, Rachael Hageman Blair (2016). "Belief Propagation in Genotype-Phenotype Networks", \emph{Stat Appl Genet Mol Biol}, 15(1):39-53. \href{http://www.degruyter.com/view/j/sagmb.2016.15.issue-1/sagmb-2015-0058/sagmb-2015-0058.xml?format=INT}{pdf}

The geneNetBP Homepage: \url{http://genenetbp.r-forge.r-project.org/}

The RHugin Homepage: \url{http://rhugin.r-forge.r-project.org}

HUGIN EXPERT website: \url{http://www.hugin.com} 

\href{http://download.hugin.com/webdocs/manuals/api-manual.pdf}{HUGIN API Reference Manual}

}



