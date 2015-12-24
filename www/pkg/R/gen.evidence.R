gen.evidence=function(gpfit,node,std=2,length.out=10,std.equal=TRUE)
  
{  
  retract(gpfit$gp)
  
  ## Get node attributes
  Data<-get.cases(gpfit$gp)

  class_nodes<-gpfit$gp_nodes
  
  ## Determine type of nodes (discrete or continuous)
    if (is.element("factor",class_nodes[match(node,class_nodes),2]))
        stop("One or more nodes specified is not continuous")
  

  ## calculate marginals
  marg_node_abs<-get.marginal(gpfit$gp,node)
  mean1<-marg_node_abs$mean
  var1<-diag(matrix(unlist(marg_node_abs$cov),nrow=length(node)))

  evidence=matrix(nrow=length(node),ncol=length.out)
  
  if (std.equal==FALSE & length(std)!=length(node))
    stop("length of std is not equal to the number of nodes") 
    

#      warning("std.equal is set to true. using the first element of the vector std")
#    
     std<-rep(std[1],length(node)) 
    
     for (i in 1:length(node))
       {
         a<-mean1[i]-std[i]*sqrt(var1[i])
         b<-mean1[i]+std[i]*sqrt(var1[i])
         evidence[i,]=seq(a,b,length.out=length.out)
       }

rownames(evidence)=node


  return(evidence)
}
