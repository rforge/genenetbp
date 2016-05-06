\name{plot methods}
\alias{plot.gnbp}
\alias{plot.dbn}
\alias{plot.gpfit}
\alias{plot.dbnfit}
\title{
Plot a Genotype-Phenotype Network
}
\description{
Plot methods for genotype-phenotype networks. \code{plot.gnbp} and \code{plot.dbn} can be used to plot networks in which evidence has been absorbed and propagated. The beliefs or Jeffrey's signed information for conditional gaussian and phenotypic states and Fold Changes for discrete bayesian networks is mapped onto the network. \code{plot.gpfit} and \code{plot.dbfit} are plot methods for objects of class "gpfit" and "dbnfit" respectively.
}
\usage{
\method{plot}{gnbp}(x, y="JSI",ncol = 1, col.palette,col.length = 100, 
                    fontsize=14, fontcolor="black",...)
\method{plot}{dbn}(x, y="state",ncol = 1, col.palette,col.length = 100, 
                    fontsize=14, fontcolor="black",...)  
\method{plot}{gpfit}(x, fontsize=14, fontcolor="black",...)
\method{plot}{dbnfit}(x, fontsize=14, fontcolor="black",...)            
                    
}
\arguments{
  \item{x}{
An object of class "gnbp" (\code{plot.gnbp}), "dbn" (\code{plot.dbn}), "gpfit" (\code{plot.gpfit}) or "dbnfit" (\code{plot.dbnfit})
}
  \item{y}{
A character string. Valid options are \code{"JSI"} (default) or \code{"belief"} for Conditional Gaussian network and \code{"FC"} or \code{"state"} for Discrete Bayesian networks. \code{plot.dbn} plots only discrete bayesian networks. Note that \code{y} will be ignored for \code{plot.dbnfit} and \code{gpfit}
}
  \item{ncol}{a positive integer specifying the column number of JSI / belief / FC to plot. By default, the first column will be used.}
  
  \item{col.palette}{A list of character strings. For \code{"JSI"},\code{"belief"} and \code{"FC"} a list of 6 elements specifying colors for colormap.All 6 elements should be character strings specifying the colour for 
\code{pos_high}= high end of gradient of positive values (default = "red" (JSI, belief), "darkmagenta",(FC))
\code{pos_low}=low end of gradient of positive values (default = "wheat1" (JSI, belief), "palegoldenrod",(FC))
\code{neg_high}=high end of gradient of positive values (default = "cyan" (JSI, belief), "palegoldenrod",(FC))
\code{neg_low}=low end of gradient of positive values (default = "blue" (JSI, belief), "gold2",(FC))
\code{dsep_col}= \emph{d}-separated nodes (default = "white")
\code{qtl_col}= discrete nodes (QTLs) (default = "grey")
\code{node_abs_col}= nodes for which evidence has been absorbed (default = "palegreen2")

For \code{"state"}, a list of 4 elements specifying colors for colormap should be specified. All 4 elements should be character strings specifying the colour for 
\code{col_nodes}- a vector of colors for phenotype states should be specified. The length of the vector should be equal to the maximum number of phenotype states possible.
\code{dsep_col}= \emph{d}-separated nodes (default = "white")
\code{qtl_col}= discrete nodes (QTLs) (default = "grey")
\code{node_abs_col}= nodes for which evidence has been absorbed (default = "palegreen2")

}
  \item{col.length}{
a positive integer (default = 100) specifying the resolution of the colormap (number of colors) in case of \code{"belief"}, \code{"JSI"} and \code{"FC"}. For \code{"state"}, this argument will be ignored.
}
  \item{fontsize}{a single numeric value. fontsize for node labels}
  \item{fontcolor}{fontcolor for node labels}
  \item{...}{further arguments to the function \code{\link{plot}}. These will be ignored}
}
\details{
\code{plot.gpfit} and \code{plot.dbnfit} are generic plot methods for objects of class"gpfit" and "dbnfit" respectively that are output from the fit-methods. These are networks in which evidence has not been absorbed and propagated.  

\code{plot.gnbp} and \code{plot.dbn} are generic plot methods for objects of class "gnbp" and "dbn" that are outputs from the absorb methods. These functions plot the genotype-phenotype networks in which evidence has been absorbed and propagated and maps the quantitative system wide effects on the network. Both conditional gaussian and discrete bayesian networks are supported. Users can specify the colormap options such as end colors for the positive and negative gradients and the resolution of the colormap. The default node shapes are "ellipse" for the phenotype nodes and "box" for genotype nodes.The \emph{d}-separated nodes are white while the colored nodes are \emph{d}-connected, with the color indicating the strength and direction of change. The node for which evidence is absorbed is colored green (default color).
}
\value{
\code{x} is invisibly returned
}

\author{
Janhavi Moharil<janhavim@buffalo.edu>
}

\seealso{
\code{\link{absorb.gnbp}}, \code{\link{absorb.dbn}}, \code{\link{fit.gnbp}}, \code{\link{fit.dbn}}
}

\examples{
## Fit, absorb and plot a genotype-phenotype network
data(mouse)
\dontrun{
mouse.cgbn<-fit.gnbp(mouse[,1:5],mouse[,6:19],alpha=0.1)
plot(mouse.cgbn)
mouse.cgbn.abs<-absorb.gnbp(network,node="Tlr12",evidence=matrix(-0.99))
plot(mouse.cgbn.abs)
}
}
