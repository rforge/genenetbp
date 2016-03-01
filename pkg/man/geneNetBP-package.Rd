\name{geneNetBP-package}
\alias{geneNetBP-package}
\alias{geneNetBP}
\docType{package}
\title{Belief Propagation in Genotype-Phenotype Networks}
\description{The geneNetBP package provides functions to fit Conditional Gaussian Bayesian network to genotype-phenotype or Quantitative Trait Loci (QTL) data, absorb evidence in the genotype-phenotype network and quantify and visualize the changes in network beliefs. The package makes extensive use of \code{RHugin} package that provides an R interface for the Hugin Decision Engine. The package {RHugin} can be obtained from R-Forge by accessing the link given below. All the functions in the geneNetBP package are documented. For a complete list of functions, use the command ls(pos = "package:geneNetBP").
}
\details{
\tabular{ll}{
Package: \tab geneNetBP\cr
Type: \tab Package\cr
Version: \tab 1.0.0\cr
Date: \tab 2016-02-29\cr
License: \tab GPL-2\cr
}
This package implements structure learning and conditional probability learning methods from RHugin package to Quantative Trait Loci (QTL) data and provides functions to query and visualize the network beliefs. The function \code{\link{fit.gnbp}} can be used to learn conditional gaussian bayesian networks from genotype-phenotype data. The main function for absorbing evidence and quantifying the changes in beliefs is \code{\link{absorb.gnbp}}. A \code{plot} method is available for visualizing network beliefs.

All functions in the package work on RHugin domains. Since Hugin domains are external pointers and cannot be saved in R workspace, the RHugin package provides functions \code{read.rhd} and \code{write.rhd} for loading and saving the Hugin domains. See RHugin documentation for more information. 

A vignette illustrating the use of geneNetBP is available. 

}
\author{
Janhavi Moharil <janhavim@buffalo.edu>
Rachael Hageman Blair <hageman@buffalo.edu>

Maintainer: Janhavi Moharil <janhavim@buffalo.edu> 
}
\references{

Janhavi Moharil, Paul May, Daniel P. Gaile, Rachael Hageman Blair (2016). "Belief Propagation in Genotype-Phenotype Networks", \emph{Stat Appl Genet Mol Biol}, 15(1):39-53.

The RHugin Project website: \url{http://rhugin.r-forge.r-project.org}

HUGIN EXPERT website: \url{http://www.hugin.com}

HUGIN API Reference Manual \url{http://download.hugin.com/webdocs/manuals/api-manual.pdf}

}



