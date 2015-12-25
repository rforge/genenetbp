\name{absorb.gnbp}
\alias{absorb.gnbp}
\title{
Absorb evidence and infer a genotype-phenotype network
}
\description{
Absorb a single piece or a spectrum of evidence for one or more continuous nodes in a compiled RHugin domain, obtain the updated beliefs and the Jeffrey's signed information. 
}
\usage{
absorb.gnbp(gpfit, node, evidence)
}
\arguments{
  \item{gpfit}{
an object of class "gpfit". Output from \code{\link{fit.gnbp}}. 
}

  \item{node}{
a character vector specifying the names of the continuous nodes for which the evidence is to be absorbed.
}
  \item{evidence}{
a matrix or a numeric vector of evidence. number of rows of the matrix or the length of the vector should be equal to the length of node. 
}
}

\value{
absorb.gnbp returns an object of class "gnbp". The functions summary and print can be used for objects of class "gnbp". An object of class "gnbp" is a list containing the following components

\item{gp}{an RHugin domain that is triangulated, compiled and with the latest absorbed evidence propagated }
\item{gp_flag}{type of network}
\item{node}{a character vector specifying the nodes for which evidence was been absorbed}
\item{marginal}{a list of marginal probabilities for phenotypes (\code{pheno}) and genotypes (\code{geno})}
\item{belief}{a list of updated beliefs for phenotypes (\code{pheno}) and genotypes (\code{geno})}
\item{JSI}{a matrix of Jeffrey's signed information if network is \code{Conditional Gaussian}, otherwise\code{NULL} if network is \code{Discrete Bayesian}}
\item{FC}{a list of two. a matrix \code{FC} of fold changes and a matrix \code{pheno_state} of phenotype node beliefs - state with maxium probability. If network is \code{Conditional Gaussian}, a \code{NULL} value is returned.}

The marginal, beliefs and JSI or FC are calculated for only \code{d}-connected nodes.

If a sequence of evidence is absorbed for a single node in a Conditional Gaussian network, a plot of \code{JSI} vs \code{evidence} is drawn. 

}

\author{
Janhavi Moharil<janhavim@buffalo.edu>

Rachael Hageman-Blair<hageman@buffalo.edu> 
}

\seealso{
\code{\link{gen.evidence}}
}
\examples{

data(mouse)

\dontrun{
## Simple example : Fit a bayesian network to genotype-phenotype data 
network<-fit.gnbp(mousegeno,mousepheno,alpha=0.1)

## Absorb a single evidence for a single node
absorb.gnbp(network,node="Tlr12",evidence=matrix(2.5))

## Absorb a sequence of evidence for a single node generated using \code{\link{gen.evidence}
network<-fit.gnbp(mousegeno,mousepheno,alpha=0.1)
evidence<-gen.evidence(network,node="Tlr12")
absorb.gnbp(network,node="Tlr12",evidence=evidence)

##Absorb sequence of evidence for multiple nodes}
network<-fit.gnbp(mousegeno,mousepheno,alpha=0.1)
evidence<-gen.evidence(network,node=c("Ak2","Ptp4a2","Hmgcl"),std=2,std.equal=TRUE)
absorb.gnbp(network,node=rownames(evidence),evidence=evidence)
}

}
