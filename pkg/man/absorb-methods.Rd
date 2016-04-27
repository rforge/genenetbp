\name{absorb-methods}
\alias{absorb.gnbp}
\alias{absorb.dbn}
\title{
Absorb evidence and propagate beliefs in a genotype-phenotype network
}
\description{
Absorb a single piece or a spectrum of evidence for one or more phenotype nodes, propagate the beliefs, obtain the updated beliefs and quantify the effects. 
}
\usage{
## For Conditional Gaussian Bayesian Networks
## and Discrete Bayesian Networks (Implements RHugin)
absorb.gnbp(object, node, evidence)
## For Discrete Bayesian Networks (Implements gRain)
absorb.dbn(object, node, evidence)
}
\arguments{
  \item{object}{
an object of class "gpfit" (output from \code{\link{fit.gnbp}}) for \code{absorb.gnbp}or an object of class "dbnfit" (Output from \code{\link{fit.dbn}})for \code{absorb.dbn}. 
}
  \item{node}{
a character vector specifying the names of the nodes for which the evidence is to be absorbed.
}
  \item{evidence}{
a matrix or a numeric vector of evidence. number of rows of the matrix or the length of the vector should be equal to the length of \code{node}. 
}
}

\details{The function \code{absorb.gnbp} is compatible with the output produced by \code{fit.gnbp}. It absorbs evidence in both conditional gaussian bayesian networks or discrete bayesian networks inferred by RHugin and propagates beliefs by the PC algorithm implemented in the \code{RHugin} package. Jeffrey's Signed information is calculated to quantify the effects of the evidence absorption on the marginals. Note that the demo version of HuginLite is restricted to 50 states and 500 cases. 

The function \code{absorb.dbn} is compatible with the output produced by \code{fit.dbn}. It absorbs evidence in only discrete bayesian networks that are inferred by \code{bnlearn}. Belief propagation is implemented using \code{gRain} package. 
}

\value{
\code{absorb.gnbp} returns an object of class "gnbp" while \code{absorb.dbn} returns an object of class "dbn". An object of class "gnbp" or "dbn" is a list containing the following components

\item{gp}{an RHugin domain (for \code{absorb.gnbp}) or a grain object (for \code{absorb.dbn}) that is triangulated, compiled and with the latest absorbed evidence propagated.  }
\item{gp_flag}{type of network.}
\item{node}{a character vector specifying the nodes for which evidence has been absorbed}
\item{marginal}{a list of marginal probabilities for phenotypes (\code{pheno}) and genotypes (\code{geno})}
\item{belief}{a list of updated beliefs for phenotypes (\code{pheno}) and genotypes (\code{geno})}
\item{JSI}{a matrix of Jeffrey's signed information if network is \code{Conditional Gaussian}, otherwise \code{NULL} if network is \code{Discrete Bayesian}}. 
\item{FC}{a list of two. a matrix \code{FC} of fold changes and a matrix \code{pheno_state} of phenotype node beliefs - state with maxium probability. If network is \code{Conditional Gaussian}, a \code{NULL} value is returned.}

The marginals, beliefs and JSI or FC are calculated for only \emph{d}-connected nodes.

If a sequence of evidence is absorbed for a single node in a Conditional Gaussian network, a plot of \code{JSI} vs \code{evidence} is produced. 

}

\author{
Janhavi Moharil<janhavim@buffalo.edu>
}

\seealso{
\code{\link{gen.evidence}},\code{\link{plot-methods}}
}
\examples{

## load the mouse kidney eQTL dataset
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
