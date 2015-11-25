\name{fit.gnbp}
\alias{fit.gnbp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Fit a Conditional Gaussian Bayesian Network to QTL data}
\description{Learn the structure of a genotype-phenotype network from quantitative trait loci (QTL) data and the conditional probability table for each node in the network using the PC algorithm and the EM algorithm implemented in the RHugin package. 
}
\usage{
fit.gnbp(geno,pheno,constraints,learn="TRUE",edgelist,alpha=0.001,tol=1e-04,maxit=0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{geno}{a data frame of column vectors of class factor (or one that can be coerced to that class) and non-empty column names.

}
  \item{pheno}{a data frame of column vectors of class numeric or class factor and non-empty column names. 
}
  \item{constraints}{an optional list of constraints on the edges for specifying required and forbidden edges. See details.
}
  \item{learn}{a boolean value. If TRUE (default), the network structure will be learnt using the PC algorithm in RHugin package. If FALSE, only conditional probabilities will be learnt.
}
  \item{edgelist}{a list of edges to be provided if learn == FALSE.
}
  \item{alpha}{a single numeric value specifying the significance level (for use with RHugin). Default is 0.001.
}
  \item{tol}{a positive numeric value (optional) specifying the tolerance for EM algorithm to learn conditional probability tables (for use with RHugin). Default value is 1e-04. See \link[RHugin]{learn.cpt} for details.

}
\item{maxit}{a positive integer value (optional) specifying the maximum number of iterations of EM algorithm to learn conditional probability tables (for use with RHugin). See \code{learn.cpt} for details.
}


}
\details{The function fit.gnbp fits a conditional gaussian bayesian network at the specified level of significance alpha, to genotype-phenotype (QTL) data by the PC algorithm implemented in the RHugin package. The conditional probability tables are learnt for each node in the domain by the EM algorithm implemented in the RHugin package. 

Edges between the genotypes at SNP markers are not allowed and the genotypes are constrained to precede the phenotypes. The phenotypes should be either all numeric or all discrete. The function does not currently support mixture of discrete and continuous phenotypes. Additional domain knowledge in terms of edges should be provided as a list of constraints, the structure of which is described in detail in \code{learn.structure}. Briefly, the constraints argument is a list of two elements: directed and undirected. Each of these elements in turn should be a list with two elements: required and forbidden. The elements of required and forbidden must be a character vector of length two specifying the names of the nodes. See \code{learn.cpt} for details.
}
\value{
Returns an object of class "gpfit". 
\code{gp} - a pointer to a compiled RHugin domain. There is a cpt table associated with each node in the network.
\code{gp_nodes} - a data frame containing information about nodes for use with other functions
}

\author{
Janhavi Moharil <janhavim@buffalo.edu>

Rachael Hageman-Blair<hageman@buffalo.edu> 
}

\seealso{
\code{\link{absorb.gnbp}}
}

\examples{
\dontrun{
data(mouse)

## Simple example : Fit a bayesian network to genotype-phenotype data using the default values
fit.gnbp(geno,pheno)

## Fit a bayesian network to genotype-phenotype data at a specified significance level
fit.gnbp(geno,pheno,alpha = 0.1)
}
}
