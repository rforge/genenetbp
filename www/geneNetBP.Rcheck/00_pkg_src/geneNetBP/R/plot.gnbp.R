plot.gnbp=function(x, y="JSI",col.palette,col.length = 100, ncol = 1, ...)
{
                  
#   if (!require(Rgraphviz)) 
#     stop("plotting an RHugin domain requires the Rgraphviz package")
#   
  ## get node attributes
  Data<-get.cases(x$gp)
  
  class_nodes=matrix(nrow=(dim(Data)[2])-1,ncol=3)
  
  for (i in 1:(dim(Data)[2])-1)
  {
    class_nodes[i,]=c(colnames(Data)[i],class(Data[,i]),length(levels(Data[,i])))
  }
  
  colnames(class_nodes)=c("node","class","levels")
  
  ## get d-connected nodes
  dnodes<-get.dconnected.nodes(x$gp,x$node)
  dnodes<-class_nodes[match(setdiff(class_nodes[match(dnodes,class_nodes),1],x$node),class_nodes),]
  dnodes<-matrix(dnodes,ncol=3)
  
  ## convert to graphNEL object for use with Rgraphviz
  BNgraph<-as.graph.RHuginDomain(x$gp)
  
  ## set node attributes
  z<-nodes(BNgraph)
  names(z)<-nodes(BNgraph)
  
  nAttrs <- list()
  eAttrs <- list()
  attrs<-list()
  nAttrs$label<-z
  
  attrs$node$fontsize<-10
  attrs$node$fontcolor<-"black"
  attrs$node$fixedsize<-F
  attrs$node$height<-1.2

  
  nAttrs$shape<-rep("ellipse",length(z))
  nAttrs$shape[which(class_nodes[,"class"]=="factor")]<-"box"
  names(nAttrs$shape)<-nodes(BNgraph)
  
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
  
  X=length(dnodes[which(dnodes[,2]=="factor"),1])
  nAttrs$fillcolor<-rep(col.palette$dsep_col,length(z))
  names(nAttrs$fillcolor)<-nodes(BNgraph)
  
    
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
      
      names(colormap_network)=c(c(names(score),x$node),dnodes[which(dnodes[,2]=="factor"),1])
      nAttrs$fillcolor<-colormap_network
      
      non_dnodes<-setdiff(class_nodes[,1],names(colormap_network))
      colormap<-c(c(colormap1,col.palette$dsep_col),colormap2)
      
      
      layout(matrix(c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,2,2,0), 4, 6, byrow = F))
      
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
 
  
  invisible(x)
  
}
