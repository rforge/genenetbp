\name{gen.evidence}
\alias{gen.evidence}
\title{Generate a sequence of evidence for a continuous node in a conditional gaussian bayesian network.
}
\description{
The evidence for a node in an RHugin domain is generated as a linear sequence within the specified standard deviation from the marginal mean of the node. The evidence can be given as an input to \link{absorb.gnbp}
}
\usage{
gen.evidence(gpfit, node, std = 2, length.out = 10, std.equal = TRUE)
}
\arguments{
  \item{gpfit}{an object of class "gpfit" obtained by using fit.gnbp
}
  \item{node}{
a character string specifying the name of a continuous node in the domain
}
  \item{std}{
a numeric value specifying the number of standard deviations of marginal distribution within which the evidence is generated. A numeric vector of length = number of nodes, must be specified when std.equal=FALSE. 
}
  \item{length.out}{
a positive integer giving the desired length of the sequence.
}
  \item{std.equal}{a logical value indicating whether same number of standard deviations should be used to generate evidence for all nodes. Default is TRUE. 
}
}
\details{The evidence for a node in an RHugin domain is generated as a linear sequence within the specified standard deviation from the marginal mean of the node. The evidence can be given as an input to \link{absorb.gnbp}
}
\value{
A matrix of evidence for each specified node
}

\author{
Janhavi Moharil<janhavim@buffalo.edu>
}

\seealso{
\code{\link{absorb.gnbp}},\code{\link{fit.gnbp}}
}
\examples{

##Fit a network
data(mouse)
\dontrun{
mouse.cgbn<-fit.gnbp(mouse[,1:5],mouse[,6:14],alpha=0.1)

##Generate a sequence of evidence for a single node
evidence<-gen.evidence(mouse.cgbn,node="Tlr12",std=2,length.out=20)
}

}
