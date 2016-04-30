\name{fit-methods}
\alias{fit.gnbp}
\alias{fit.dbn}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Fit a Conditional Gaussian Bayesian Network or Discrete Bayesian Network to QTL data}

\description{Learn the structure of a genotype-phenotype network from quantitative trait loci (QTL) data and the conditional probability table for each node in the network. 
}
\usage{
## Fit a conditional gaussian or a discrete bayesian network using RHugin.
fit.gnbp(geno,pheno,constraints,learn="TRUE",graph,type ="cg",
                  alpha=0.001,tol=1e-04,maxit=0)
## Fit a discrete bayesian network using bnlearn.
fit.dbn(geno,pheno,graph,learn="TRUE",method="hc",whitelist,blacklist)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{geno}{a data frame of column vectors of class factor (or one that can be coerced to that class) and non-empty column names.

}
  \item{pheno}{a data frame of column vectors of class numeric for \code{fit.gnpb} if \code{type = "cg"} or class factor if \code{type = "db"} and for \code{fit.dbn}. Non-empty column names. 
}
  \item{constraints}{an optional list of constraints on the edges for specifying required and forbidden edges for \code{fit.dbn}. See details.
}
  \item{learn}{a boolean value. If TRUE (default), the network structure will be learnt. If FALSE, only conditional probabilities will be learnt (a graph must be provided in this case.)
}
  \item{graph}{graph structure of class "graphNEL" or a data frame with two columns of (labeled "from" and "to"), containing a set of edges to be included in the graph to be provided if learn == FALSE. See details.
}
  \item{type}{specify the type of network for \code{fit.gnbp}. \code{"cg"} for \code{Conditional Gaussian} (default) and \code{"db"} for \code{Discrete Bayesian}.
}

\item{method}{a character string. The score-based or constraint-based algorithms available in the package \pkg{bnlearn}. Valid options are \code{"hc"}, \code{"tabu"}, \code{"gs"}, \code{"iamb"}, \code{"fast.iamb"}, \code{"inter.iamb"}, \code{"mmhc"}. See details below. 
}

\item{whitelist}{a data frame with two columns of (labeled "from" and "to"), containing a set of edges to be included in the graph.
}
  \item{blacklist}{a data frame with two columns (labeled "from" and "to"), containing a set of edges NOT to be included in the graph.
}

  \item{alpha}{a single numeric value specifying the significance level (for use with RHugin). Default is 0.001.
}
  \item{tol}{a positive numeric value (optional) specifying the tolerance for EM algorithm to learn conditional probability tables (for use with RHugin). Default value is 1e-04. See \code{learn.cpt} for details.

}
\item{maxit}{a positive integer value (optional) specifying the maximum number of iterations of EM algorithm to learn conditional probability tables (for use with RHugin). See \code{learn.cpt} for details.
}


}
\details{The function \code{fit.gnbp} fits a conditional gaussian bayesian network or a discrete bayesian network at the specified level of significance alpha, to genotype-phenotype (QTL) data by the PC algorithm implemented in the RHugin package. The conditional probability tables are learnt for each node in the domain by the EM algorithm implemented in the RHugin package. 

Edges between the genotypes at SNP markers are not allowed and the genotypes are constrained to precede the phenotypes. The phenotypes should be either all numeric or all discrete. The function does not currently support mixture of discrete and continuous phenotypes. Additional domain knowledge in terms of edges should be provided as a list of constraints, the structure of which is described in detail in \code{learn.structure}. Briefly, the constraints argument is a list of two elements: directed and undirected. Each of these elements in turn should be a list with two elements: required and forbidden. The elements of required and forbidden must be a character vector of length two specifying the names of the nodes. See \code{learn.cpt} for details.

Note that this function works on Hugin domains. Since Hugin domains are external pointers and cannot be saved in R workspace, the RHugin package provides functions \code{read.rhd} and \code{write.rhd} for loading and saving the Hugin domains. See RHugin documentation for more information.

The function fit.dbn infers a discrete bayesian network structure from genotype-phenotype (QTL) categorical data by implementing score based and constraint based algorithms from the \pkg{bnlearn} package. The conditional probability tables are learnt for each node in the inferred network. The phenotypes should be ALL discrete variables.  Additional domain knowledge in terms of edges should be provided as a \code{whitelist} and \code{blacklist}.Edges between the genotypes at SNP markers are not allowed and the genotypes are constrained to precede the phenotypes. 

The supported algorithms from \pkg{\link{bnlearn}} are 
\enumerate{
\item{Score-based:}{ \emph{Hill-Climbing} (\code{\link[bnlearn]{hc}},default), \emph{Tabu Search} (\code{\link[bnlearn]{tabu}})}
\item{Constraint-based:}{ \emph{Grow-Shrink} (\code{\link[bnlearn]{gs}}), \emph{Incremental Association} (\code{\link[bnlearn]{iamb}}), \emph{Fast Incremental Association} (\code{\link[bnlearn]{fast.iamb}}), \emph{Interleaved Incremental Association} (\code{\link[bnlearn]{inter.iamb}})}
\item{Hybrid:}{ \emph{Max-Min Hill-Climbing} (\code{\link[bnlearn]{mmhc}}).} 
}

The algorithm can be specified by \code{method}. Structure learning functions are implemented with their default parameters. If different parameter values are desired, it is recommended to learn the network structure independently using the bnlearn package.The inferred structure can be input as a graph object to \code{fit.dbn} and then set learn="FALSE".
}

\value{
\code{fit.gnbp} returns an object of class "gpfit" containing the following components.

\item{gp}{a pointer to a compiled RHugin domain that is the inferred network structure and the conditional probability tables for each node in the network.}
\item{gp_nodes}{a data frame containing information about nodes for internal use with other functions.}
\item{gp_flag}{a character string specifying the type of network : "cg" for \code{Conditional Gaussian} or "db" for \code{Discrete Bayesian}.}

\code{fit.dbn} returns an object of class "dbnfit" containing the following components. 
\item{dbn}{an object of class bn. See \code{\link[bnlearn]{bn-class}} for details. This object contains the inferred network structure and the conditional probability tables for each node in the network.}
\item{dbn_nodes}{a data frame containing information about nodes for internal use with other functions.}
\item{dbn_flag}{a character string specifying the type of network \code{"dbn"} for \code{Discrete Bayesian}.}
}

\author{
Janhavi Moharil <janhavim@buffalo.edu>
}

\seealso{
\code{\link{plot.gpfit}}, \code{\link{plot.dbnfit}}, \code{\link{absorb.gnbp}}, For discrete bayesian networks : \code{\link{fit.dbn}},\code{\link{absorb.dbn}}
}

\examples{
\dontrun{
## load the mouse kidney eQTL dataset
data(mouse)

## get genotype and phenotype data
mousegeno<-mouse[,1:5]
mousepheno<-mouse[,6:14]

## Simple example : Fit a bayesian network to genotype-phenotype data using the default values
fit.gnbp(mousegeno,mousepheno)

## Fit a bayesian network to genotype-phenotype data at a specified significance level
fit.gnbp(mousegeno,mousepheno,alpha = 0.1)

## load HDL dataset
data(hdl)

## Discretize data around median
hdlpheno_dis<-hdlpheno
for (i in 1:dim(hdlpheno)[2])
{
  hdlpheno_dis[which(hdlpheno[,i]>=median(hdlpheno[,i])),i]<-"1"
  hdlpheno_dis[which(hdlpheno[,i]<median(hdlpheno[,i])),i]<-"-1"
  hdlpheno_dis[,i]<-as.factor(hdlpheno_dis[,i])
}

## Simple example : Fit a discrete bayesian network to genotype-phenotype data
fit.dbn(hdlgeno,hdlpheno_dis)

## Fit a discrete bayesian network by Grow-Shrink method and plot it.
hdlgs<-fit.dbn(hdlgeno,hdlpheno_dis,method="gs")
plot(hdlgs)


}
}
