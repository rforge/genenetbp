\name{plot.gnbp}
\alias{plot.gnbp}
\title{
Plot a Genotype-Phenotype Network
}
\description{
Plot method for gnbp objects. Plots genotype-phenotype network in which evidence has been absorbed and propagated and maps the beliefs or Jeffrey's signed information onto the network.
}
\usage{
\method{plot}{gnbp}(x, y="JSI",col.palette,col.length = 100, ncol = 1, fontsize=10, fontcolor="black",...)
}
\arguments{
  \item{x}{
An object of class gnbp
}
  \item{y}{
A character string. Valid options are \code{"JSI"} (default) or \code{"belief"} for Conditional Gaussian network. For Discrete Bayesian networks, the argument will be ignored and the phenotype states with maximum probability will be plotted.
}
  \item{col.palette}{A list of character strings. For Conditional Gaussian networks, a list of 6 elements specifying colors for colormap.All 6 elements should be character strings specifying the colour for 
\code{pos_high}= high end of gradient of positive values (default = "red")
\code{pos_low}i=low end of gradient of positive values (default = "wheat1")
\code{neg_high}=high end of gradient of positive values (default = "cyan")
\code{neg_low}=low end of gradient of positive values (default = "blue")
\code{dsep_col}= \emph{d}-separated nodes (default = "white")
\code{qtl_col}= discrete nodes (QTLs) (default = "grey")
\code{node_abs_col}= nodes for which evidence has been absorbed (default = "palegreen2")

For Discrete Bayesian networks, a list of 4 elements specifying colors for colormap should be specified. All 4 elements should be character strings specifying the colour for 
\code{col_nodes}- a vector of colors for phenotype states should be specified. The length of the vector should be equal to the maximum number of phenotype states possible. See example below.
\code{dsep_col}= \emph{d}-separated nodes (default = "white")
\code{qtl_col}= discrete nodes (QTLs) (default = "grey")
\code{node_abs_col}= nodes for which evidence has been absorbed (default = "palegreen2")

}
  \item{col.length}{
a positive integer (default = 100) specifying the resolution of the colormap (number of colors).
}
  \item{ncol}{a positive integer specifying the column number of JSI / belief / FC to plot. By default, the first column will be plot}
  \item{fontsize}{fontsize for node labels}
  \item{fontcolor}{fontcolor for node labels}
  \item{...}{further arguments to the function \code{\link{plot}}. These will be ignored}
}
\details{
This function plots the genotype-phenotype network in which evidence has been absorbed and propagated. The \code{plot} method will convert the RHugin domain into an object of class "graphNEL" by using Rgraphviz package. The argument \code{nodeAttrs} to \code{plot} method for \code{graph} objects in Rgraphviz package is then used to customize the plot. Users can specify the colormap options such as end colors for the positive and negative gradients and the resolution of the colormap. The default node shapes are "ellipse" for the phenotype nodes and "box" for genotype nodes.The \emph{d}-separated nodes are white while the colored nodes are \emph{d}-connected, with the color indicating the strength and direction of change. The node for which evidence is absorbed is colored green (default color).
}
\value{
\code{x} is invisibly returned
}

\author{
Janhavi Moharil<janhavim@buffalo.edu>

Rachael Hageman-Blair<hageman@buffalo.edu> 
}
\seealso{
\code{\link{absorb.gnbp}}
}

\examples{
## Fit, absorb and plot a genotype-phenotype network
data(mouse)
\dontrun{
network<-fit.gnbp(geno,pheno,alpha=0.1)
network<-absorb.gnbp(network,node="Tlr12",evidence=matrix(-0.99))
plot(x=network)
}
}
