# \name{plot-methods}
# \alias{plot.gnbp}
# \alias{plot.dbn}
# \alias{plot.gpfit}
# \alias{plot.dbfit}
# \title{
#   Plot a Genotype-Phenotype Network
# }
#   \usage{
#   \method{plot}{gnbp}(x, y="JSI",ncol = 1, col.palette,col.length = 100, 
#   fontsize=14, fontcolor="black",...)
#   \method{plot}{dbn}(x, y="state",col.palette,col.length = 100, 
#   fontsize=14, fontcolor="black",...)  
#   \method{plot}{gpfit}(x, fontsize=14, fontcolor="black",...)
#   \method{plot}{dbnfit}(x, fontsize=14, fontcolor="black",...)            
#   
#   }
#   \arguments{
#   \item{x}{
#   An object of class "gnbp" (\code{plot.gnbp}), "dbn" (\code{plot.dbn}), "gpfit" (\code{plot.gpfit}) or "dbnfit" (\code{plot.dbnfit})
#   }
#   \item{y}{
#   A character string. Valid options are \code{"JSI"} (default) or \code{"belief"} for Conditional Gaussian network and \code{"FC"} or \code{"state"} for Discrete Bayesian networks. \code{plot.dbn} plots only discrete bayesian networks. Note that \code{y} will be ignored for \code{plot.dbnfit} and \code{gpfit}
#   }
#   \item{ncol}{a positive integer specifying the column number of JSI / belief / FC to plot. By default, the first column will be used.}
#   \item{col.palette}{A list of character strings. For \code{"JSI"},\code{"belief"} and \code{"FC"} a list of 6 elements specifying colors for colormap.All 6 elements should be character strings specifying the colour for 
#   \code{pos_high}= high end of gradient of positive values (default = "red" (JSI, belief), "darkmagenta",(FC))
#   \code{pos_low}=low end of gradient of positive values (default = "wheat1" (JSI, belief), "palegoldenrod",(FC))
#   \code{neg_high}=high end of gradient of positive values (default = "cyan" (JSI, belief), "palegoldenrod",(FC))
#   \code{neg_low}=low end of gradient of positive values (default = "blue" (JSI, belief), "gold2",(FC))
#   \code{dsep_col}= \emph{d}-separated nodes (default = "white")
#   \code{qtl_col}= discrete nodes (QTLs) (default = "grey")
#   \code{node_abs_col}= nodes for which evidence has been absorbed (default = "palegreen2")
#   
#   For \code{"state"}, a list of 4 elements specifying colors for colormap should be specified. All 4 elements should be character strings specifying the colour for 
#   \code{col_nodes}- a vector of colors for phenotype states should be specified. The length of the vector should be equal to the maximum number of phenotype states possible.
#   \code{dsep_col}= \emph{d}-separated nodes (default = "white")
#   \code{qtl_col}= discrete nodes (QTLs) (default = "grey")
#   \code{node_abs_col}= nodes for which evidence has been absorbed (default = "palegreen2")
#   
#   }
#   \item{col.length}{
#   a positive integer (default = 100) specifying the resolution of the colormap (number of colors) in case of \code{"belief"}, \code{"JSI"} and \code{"FC"}. For \code{"state"}, this argument will be ignored.
#   }
#   \item{fontsize}{a single numeric value. fontsize for node labels}
#   \item{fontcolor}{fontcolor for node labels}
#   \item{...}{further arguments to the function \code{\link{plot}}. These will be ignored}
#   }
#############################################################################

## plot.gpfit plots output from fit.gnbp
plot.gpfit=function(x,fontsize=14, fontcolor="black",...)
{
  ## get node attributes
  class_nodes=x$gp_nodes
  
  requireNamespace("RHugin") || stop("Package not loaded: RHugin");
  
  ## convert to graphNEL object for use with Rgraphviz
  BNgraph<-RHugin::as.graph.RHuginDomain(x$gp)
  
  ## set node attributes
  z<-graph::nodes(BNgraph)
  names(z)<-graph::nodes(BNgraph)
  
  nAttrs <- list()
  eAttrs <- list()
  attrs<-list()
  nAttrs$label<-z
  
  attrs$node$fontsize<-fontsize
  attrs$node$fontcolor<-fontcolor
  attrs$node$fixedsize<-F
  attrs$node$height<-1.2
  
  nAttrs$shape<-rep("ellipse",length(z))
  names(nAttrs$shape)<-graph::nodes(BNgraph)
  nAttrs$shape[class_nodes[which(class_nodes[,"type"]=="geno"),1]]<-"box"
  
  plot(BNgraph, nodeAttrs=nAttrs,attrs=attrs) 
  
}


## plot.dbnfit plots output from fit.gnbp
plot.dbnfit=function(x,fontsize=14, fontcolor="black",...)
{
  ## get node attributes
  class_nodes=x$dbn_nodes
  
  ## convert to graphNEL object for use with Rgraphviz
  BNgraph<-as.graphNEL(x$dbn)
  
  ## set node attributes
  z<-graph::nodes(BNgraph)
  names(z)<-graph::nodes(BNgraph)
  
  nAttrs <- list()
  eAttrs <- list()
  attrs<-list()
  nAttrs$label<-z
  
  attrs$node$fontsize<-fontsize
  attrs$node$fontcolor<-fontcolor
  attrs$node$fixedsize<-F
  attrs$node$height<-1.2
  
  nAttrs$shape<-rep("ellipse",length(z))
  names(nAttrs$shape)<-graph::nodes(BNgraph)
  nAttrs$shape[class_nodes[which(class_nodes[,"type"]=="geno"),1]]<-"box"
  
  plot(BNgraph, nodeAttrs=nAttrs,attrs=attrs) 
  
}

## plot.gnbp plots cgbn and discrete bayesian networks, output from absorb.gnbp
plot.gnbp=function(x, y="JSI",ncol = 1, col.palette,col.length = 100, fontsize=14, fontcolor="black",...)

{
  ## get node attributes
  class_nodes=x$gp_nodes
  
  ## get network type
  type=x$gp_flag
  
  requireNamespace("RHugin") || stop("Package not loaded: RHugin");
  
  ## extract data
  Data<-RHugin::get.cases(x$gp)

  ## get d-connected nodes
  dnodes<-RHugin::get.dconnected.nodes(x$gp,x$node)
  dnodes<-class_nodes[match(setdiff(class_nodes[match(dnodes,class_nodes),1],x$node),class_nodes),]
  dnodes<-matrix(dnodes,ncol=4)
  colnames(dnodes)<-colnames(class_nodes)
  
  ## convert to graphNEL object for use with Rgraphviz
  BNgraph<-RHugin::as.graph.RHuginDomain(x$gp)

  
  ## set node attributes
  z<-graph::nodes(BNgraph)
  names(z)<-graph::nodes(BNgraph)
  
  nAttrs <- list()
  eAttrs <- list()
  attrs<-list()
  nAttrs$label<-z
  
  attrs$node$fontsize<-fontsize
  attrs$node$fontcolor<-fontcolor
  attrs$node$fixedsize<-F
  attrs$node$height<-1.2

  
  nAttrs$shape<-rep("ellipse",length(z))
  names(nAttrs$shape)<-graph::nodes(BNgraph)
  nAttrs$shape[class_nodes[which(class_nodes[,"type"]=="geno"),1]]<-"box"
  
  if (type == "cg")
  {
  
      if(missing(col.palette))
      col.palette<-list(pos_high="red", pos_low= "wheat1", 
                        neg_high="cyan", neg_low = "blue",
                        dsep_col="white",qtl_col="grey",node_abs_col="palegreen2") 
      
      
      if (y=="JSI")
      {score=x$JSI[,ncol]} else
        {if (y=="belief")
          {score=x$belief$pheno$mean[,ncol]} else
            {warning("invalid option for the argument 'y': plotting JSI ....")
             score=x$JSI[,ncol]}}
      
      X=length(dnodes[which(dnodes[,4]=="geno"),1])
      nAttrs$fillcolor<-rep(col.palette$dsep_col,length(z))
      names(nAttrs$fillcolor)<-graph::nodes(BNgraph)
      
        
        score_no<-seq(floor(range(score)[1]),ceiling(range(score)[2]),length.out=col.length)
        score_range<-cbind(score_no[-length(score_no)],score_no[-1])
        score_int<-findInterval(score,sort(score_no))
      
        if (!is.null(x$node) || !is.null(score))
        {
          if (length(which(score_no<0))!=0)
           {colormap1<-cscale(1:(length(which(score_no<0))-1),palette=seq_gradient_pal(low=col.palette$neg_low,high=col.palette$neg_high))}   
          else
            {colormap1<-NULL}
          if (length(which(score_no>0))!=0)
            colormap2<-cscale(1:(length(which(score_no>0))-1),palette=seq_gradient_pal(low=col.palette$pos_low,high=col.palette$pos_high))   
          else
            colormap2<-NULL
          
          colormap_network<-c(colormap1,colormap2)[score_int]
          
          for (i in 1:length(x$node))
          {
            colormap_network<-c(colormap_network,col.palette$node_abs_col)
          }
          
          colormap_network<-c(colormap_network, rep(col.palette$qtl_col,X))
          
          names(colormap_network)=c(c(names(score),x$node),dnodes[which(dnodes[,4]=="geno"),1])
          nAttrs$fillcolor<-colormap_network
          
#           non_dnodes<-setdiff(class_nodes[,1],names(colormap_network))
          colormap<-c(c(colormap1,col.palette$dsep_col),colormap2)
          
          
          layout(matrix(c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,2,2,0), 4, 6, byrow = F))
          
#           layout(matrix(c(1,2), 1, 2, byrow = F),c(4,1),c(1,1))

          plot(BNgraph, nodeAttrs=nAttrs,attrs=attrs) 
    
          scale = (length(colormap)-1)/(round(max(score_no))-round(min(score_no)))
          ticks=seq(round(min(score_no)),0, len=3)
          ticks<-ticks[-3]
          ticks=c(ticks,seq(0,round(max(score_no)),len=3))
          
          plot(c(0,10), c(round(min(score_no)),round(max(score_no))), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='')
          axis(2, pos=3,ticks, las=1,font=1)
          for (i in 1:(length(colormap)-1)) 
            {
              y = (i-1)/scale + round(min(score_no))
              rect(3.05,y,4.05,y+(1/scale), col=colormap[i], border=NA)
            }
        
       }
  }

if (type == "db")
{
  if(y=="FC")
  {
    
    if(missing(col.palette))
      col.palette=list(pos_high="darkmagenta",pos_low="palegoldenrod",
                       neg_high="palegoldenrod",neg_low="gold2",
                       dsep_col="white",qtl_col="grey",node_abs_col="palegreen2")
    
    score=x$FC$FC[,ncol]
    
    X=length(dnodes[which(dnodes[,4]=="geno"),1])
    nAttrs$fillcolor<-rep(col.palette$dsep_col,length(z))
    names(nAttrs$fillcolor)<-graph::nodes(BNgraph)
    
    score_no<-seq(floor(range(score)[1]),ceiling(range(score)[2]),length.out=col.length)
    score_range<-cbind(score_no[-length(score_no)],score_no[-1])
    score_int<-findInterval(score,sort(score_no))
    
    if (!is.null(x$node) || !is.null(score))
    {
      if (length(which(score_no<1))!=0)
      {colormap1<-cscale(1:(length(which(score_no<1))-1),palette=seq_gradient_pal(low=col.palette$neg_low,high=col.palette$neg_high))}   
      else
      {colormap1<-NULL}
      if (length(which(score_no>1))!=0)
        colormap2<-cscale(1:(length(which(score_no>1))-1),palette=seq_gradient_pal(low=col.palette$pos_low,high=col.palette$pos_high))   
      else
        colormap2<-NULL
      
      colormap_network<-c(colormap1,colormap2)[score_int]
      
      for (i in 1:length(x$node))
      {
        colormap_network<-c(colormap_network,col.palette$node_abs_col)
      }
      
      colormap_network<-c(colormap_network, rep(col.palette$qtl_col,X))
      
      names(colormap_network)=c(c(names(score),x$node),dnodes[which(dnodes[,4]=="geno"),1])
      nAttrs$fillcolor<-colormap_network
      
      #           non_dnodes<-setdiff(class_nodes[,1],names(colormap_network))
      colormap<-c(colormap1,colormap2)
      
      
      layout(matrix(c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,2,2,0), 4, 6, byrow = F))
      
      #           layout(matrix(c(1,2), 1, 2, byrow = F),c(4,1),c(1,1))
      
      plot(BNgraph, nodeAttrs=nAttrs,attrs=attrs) 
      
      scale = (length(colormap)-1)/(round(max(score_no))-round(min(score_no)))
      ticks=seq(round(min(score_no)),0, len=3)
      ticks<-ticks[-3]
      ticks=c(ticks,seq(0,round(max(score_no)),len=3))
      
      plot(c(0,10), c(round(min(score_no)),round(max(score_no))), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='')
      axis(2, pos=3,ticks, las=1,font=1)
      for (i in 1:(length(colormap)-1)) 
      {
        y = (i-1)/scale + round(min(score_no))
        rect(3.05,y,4.05,y+(1/scale), col=colormap[i], border=NA)
      }
      
    }
    
    
  }
  
  if(y=="state")
  {
    if(missing(col.palette))
      col.palette<-list(col_nodes=c("Red","Blue","Orange","Yellow","Magenta","Brown"),
                        dsep_col="white",qtl_col="grey",node_abs_col="palegreen2") 
    
    ## generate colors for node states
    colormap<-dscale(factor(x$FC$pheno_state[,ncol]),manual_pal(col.palette$col_nodes))
    
    ## add color for absorbed nodes
    colormap_network<-colormap
    for (i in 1:length(x$node))
    {
      colormap_network<-c(colormap_network,col.palette$node_abs_col)
    }
    
    
    ## add color for d-connected qtl nodes
    X=length(dnodes[which(dnodes[,4]=="geno"),1])
    colormap_network<-c(colormap_network, rep(col.palette$qtl_col,X))
    
    
    ## set node names to colormap_network
    names(colormap_network)=c(c(names(colormap),x$node),dnodes[which(dnodes[,4]=="geno"),1])
    
    ## set default color of all nodes
    nAttrs$fillcolor<-rep(col.palette$dsep_col,length(z))
    names(nAttrs$fillcolor)<-graph::nodes(BNgraph)
    
    ## set color for all nodes
    nAttrs$fillcolor<-colormap_network
    
    layout(matrix(c(1,2), 1, 2, byrow = F),c(4,1),c(1,1))
    
    plot(BNgraph, nodeAttrs=nAttrs,attrs=attrs)
    
    node_leg=c(paste("state",c(1:max(dnodes[which(dnodes[,4]=="pheno"),"levels"]))))
    names(node_leg)=col.palette$col_nodes[1:length(node_leg)]
    
    leg=c(node_leg,"d-separated","d-connected","absorbed node")
    leg.col=c(names(node_leg),col.palette$dsep_col,col.palette$qtl_col,col.palette$node_abs_col)  
    
    pch=c(rep(21,length(node_leg)),22,22,21)
    
    plot(c(1:length(leg)),type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='',bg=leg.col,col="black",pch=pch)
    legend("center",legend=leg,col=par("col"),pt.bg=leg.col,pch=pch,bty='n',pt.cex=1.5,cex=0.8)
  } 
  
  
}

   
invisible(x)

}

#################################################################################################
## plot.dbn : plots discrete bayesian networks. output from absorb.dbn
#################################################################################################
plot.dbn=function(x, y="state",ncol=1,col.palette,col.length = 100, fontsize=14, fontcolor="black",...)
  
{
  ## get node attributes
  class_nodes=x$gp_nodes
  
  ## get network type
  type=x$gp_flag
  
  ##get node for which evidence is absorbed.
  
  ## convert to graphNEL object for use with Rgraphviz
  BNgraph<-as.graphNEL(bnlearn::as.bn.fit(x$gp))
    
  ## get d-connected nodes
  blM<-grMAT(BNgraph)
  dnodes=c()
  for (i in 1:dim(class_nodes)[1])
  {
    if(!dSep(blM,x$node,class_nodes[i,1],cond=NULL))
      dnodes<-rbind(dnodes,class_nodes[i,])
  }
  
  for (i in 1:length(x$node))
  {
    Xnode<-which(dnodes[,1]==x$node[i])
    if(length(Xnode)!=0)
    dnodes<-dnodes[-Xnode,]
  }
  
  
  ## set node attributes
  z<-graph::nodes(BNgraph)
  names(z)<-graph::nodes(BNgraph)
  
  nAttrs <- list()
  eAttrs <- list()
  attrs<-list()
  nAttrs$label<-z
  
  attrs$node$fontsize<-fontsize
  attrs$node$fontcolor<-fontcolor
  attrs$node$fixedsize<-F
  attrs$node$height<-1.2
  
  nAttrs$shape<-rep("ellipse",length(z))
  names(nAttrs$shape)<-graph::nodes(BNgraph)
  nAttrs$shape[class_nodes[which(class_nodes[,"type"]=="geno"),1]]<-"box"

    
    if(y=="FC")
    {
      
      if(missing(col.palette))
        col.palette=list(pos_high="darkmagenta",pos_low="palegoldenrod",
                        neg_high="palegoldenrod",neg_low="gold2",
                        dsep_col="white",qtl_col="grey",node_abs_col="palegreen2")
      
      score=x$FC$FC[,ncol]
      
      X=length(dnodes[which(dnodes[,4]=="geno"),1])
      nAttrs$fillcolor<-rep(col.palette$dsep_col,length(z))
      names(nAttrs$fillcolor)<-graph::nodes(BNgraph)
      
      score_no<-seq(floor(range(score)[1]),ceiling(range(score)[2]),length.out=col.length)
      score_range<-cbind(score_no[-length(score_no)],score_no[-1])
      score_int<-findInterval(score,sort(score_no))
      
      if (!is.null(x$node) || !is.null(score))
      {
        if (length(which(score_no<1))!=0)
        {colormap1<-cscale(1:(length(which(score_no<1))-1),palette=seq_gradient_pal(low=col.palette$neg_low,high=col.palette$neg_high))}   
        else
        {colormap1<-NULL}
        if (length(which(score_no>1))!=0)
          colormap2<-cscale(1:(length(which(score_no>1))-1),palette=seq_gradient_pal(low=col.palette$pos_low,high=col.palette$pos_high))   
        else
          colormap2<-NULL
        
        colormap_network<-c(colormap1,colormap2)[score_int]
        
        for (i in 1:length(x$node))
        {
          colormap_network<-c(colormap_network,col.palette$node_abs_col)
        }
        
        colormap_network<-c(colormap_network, rep(col.palette$qtl_col,X))
        
        names(colormap_network)=c(c(names(score),x$node),dnodes[which(dnodes[,4]=="geno"),1])
        nAttrs$fillcolor<-colormap_network
        
        #           non_dnodes<-setdiff(class_nodes[,1],names(colormap_network))
        colormap<-c(colormap1,colormap2)
        
        
        layout(matrix(c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,2,2,0), 4, 6, byrow = F))
        
        #           layout(matrix(c(1,2), 1, 2, byrow = F),c(4,1),c(1,1))
        
        plot(BNgraph, nodeAttrs=nAttrs,attrs=attrs) 
        
        scale = (length(colormap)-1)/(round(max(score_no))-round(min(score_no)))
        ticks=seq(round(min(score_no)),0, len=3)
        ticks<-ticks[-3]
        ticks=c(ticks,seq(0,round(max(score_no)),len=3))
        
        plot(c(0,10), c(round(min(score_no)),round(max(score_no))), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='')
        axis(2, pos=3,ticks, las=1,font=1)
        for (i in 1:(length(colormap)-1)) 
        {
          y = (i-1)/scale + round(min(score_no))
          rect(3.05,y,4.05,y+(1/scale), col=colormap[i], border=NA)
        }
        
      }
      
      
    }
    
    if(y=="state")
    {
      if(missing(col.palette))
        col.palette<-list(col_nodes=c("Red","Blue","Orange","Yellow","Magenta","Brown"),
                          dsep_col="white",qtl_col="grey",node_abs_col="palegreen2") 
     
      ## generate colors for node states
      colormap<-dscale(factor(x$FC$pheno_state[,ncol]),manual_pal(col.palette$col_nodes))
      
      ## add color for absorbed node
      colormap_network<-colormap
      for (i in 1:length(x$node))
      {
        colormap_network<-c(colormap_network,col.palette$node_abs_col)
      }
      
  
      ## add color for d-connected qtl nodes
      X=length(dnodes[which(dnodes[,4]=="geno"),1])
      colormap_network<-c(colormap_network, rep(col.palette$qtl_col,X))
      
      
      ## set node names to colormap_network
      names(colormap_network)=c(c(names(colormap),x$node),dnodes[which(dnodes[,4]=="geno"),1])
      
      ## set default color of all nodes
      nAttrs$fillcolor<-rep(col.palette$dsep_col,length(z))
      names(nAttrs$fillcolor)<-graph::nodes(BNgraph)
      
      ## set color for all nodes
      nAttrs$fillcolor<-colormap_network
      
      layout(matrix(c(1,2), 1, 2, byrow = F),c(4,1),c(1,1))
      
      plot(BNgraph, nodeAttrs=nAttrs,attrs=attrs)
      
      node_leg=c(paste("state",c(1:max(dnodes[which(dnodes[,4]=="pheno"),"levels"]))))
      names(node_leg)=col.palette$col_nodes[1:length(node_leg)]
      
      leg=c(node_leg,"d-separated","d-connected","absorbed node")
      leg.col=c(names(node_leg),col.palette$dsep_col,col.palette$qtl_col,col.palette$node_abs_col)  
      
      pch=c(rep(21,length(node_leg)),22,22,21)
      
      plot(c(1:length(leg)),type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='',bg=leg.col,col="black",pch=pch)
      legend("center",legend=leg,col=par("col"),pt.bg=leg.col,pch=pch,bty='n',pt.cex=1.5,cex=0.8)
    } 
   
    
  
  invisible(x)
  
}
