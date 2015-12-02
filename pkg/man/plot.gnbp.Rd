\name{plot.gnbp}
\alias{plot.gnbp}
\title{
Plot a Genotype-Phenotype Network
}
\description{
Plot method for gnbp objects. Plots genotype-phenotype network in which evidence has been absorbed and propagated and maps the beliefs or Jeffrey's signed information onto the network.
}
\usage{
\method{plot}{gnbp}(x, y, col.palette, col.length = 100, ncol = 1, ...)
}
\arguments{
  \item{x}{
An object of class gnbp
}
  \item{y}{
A character string specifying what to plot. Valid options are "JSI" (default) or "belief".
}
  \item{col.palette}{A list of 6 elements specifying colors for colormap.All 6 elements should be character strings specifying the colour for 
\emph{pos_high}= high end of gradient of positive values (default = "red")
\emph{pos_low}i=low end of gradient of positive values (default = "wheat1")
\emph{neg_high}=high end of gradient of positive values (default = "cyan")
\emph{neg_low}=low end of gradient of positive values (default = "blue")
\emph{dsep_col}= \emph{d}-separated nodes (default = "white")
\emph{qtl_col}= discrete nodes (QTLs) (default = "grey")
\emph{node_abs_col}= nodes for which evidence has been absorbed (default = "palegreen2")
}
  \item{col.length}{
a positive integer (default = 100) specifying the resolution of the colormap (number of colors).
}
  \item{ncol}{a positive integer specifying the column number of JSI or belief to plot. By default, the first column will be plot}
  \item{...}{further arguments to the function \emph{plot}. These will be ignored}
}
\details{
This function plots the genotype-phenotype network in which evidence has been absorbed and propagated. The \emph{plot} method will convert the RHugin domain into an object of class "graphNEL" by using Rgraphviz package. The argument \emph{nodeAttrs} to \emph{plot} method for \emph{graph} objects in Rgraphviz package is then used to customize the plot. Users can specify the colormap options such as end colors for the positive and negative gradients and the resolution of the colormap. The default node shapes are "ellipse" for the continuous nodes and "box" for discrete nodes.The \emph{d}-separated nodes are white while the colored nodes are \emph{d}-connected, with the color indicating the strength and direction of change. The node for which evidence is absorbed is colored green (default color).
}
\value{
\emph{x} is invisibly returned
}

\author{
Janhavi Moharil<janhavim@buffalo.edu>

Rachael Hageman-Blair<hageman@buffalo.edu> 
}
\seealso{
\link{absorb.gnbp}
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
