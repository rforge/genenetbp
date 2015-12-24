absorb.gnbp=function(gp,node,evidence)

{
  ## get node attributes
#   Data<-get.cases(network)
#   
#   class_nodes=matrix(nrow=(dim(Data)[2])-1,ncol=3)
#   
#   for (i in 1:(dim(Data)[2])-1)
#   {
#     class_nodes[i,]=c(colnames(Data)[i],class(Data[,i]),length(levels(Data[,i])))
#   }
#   
#   colnames(class_nodes)=c("node","class","levels")
#   
  
  class_nodes=gp$gp_nodes
  network<-gp$gp
  
  ## get d-connected nodes
  dnodes<-get.dconnected.nodes(network,node)
  dnodes<-class_nodes[match(setdiff(class_nodes[match(dnodes,class_nodes),1],node),class_nodes),]
  dnodes<-matrix(dnodes,ncol=4)
  
  ## get marginal distribution
  marginal<-.get.marginal.bn(network,dnodes)
  
  ## check if class of evidence is matrix
  if(class(evidence)!="matrix")
    stop("In function(absorb.gpBP),'evidence' must be a matrix")
  
  ## create matrices to store results
  JSI=matrix(nrow=length(dnodes[which(dnodes[,2]=="numeric"),1]),ncol=dim(evidence)[2])
  belief_mean=matrix(nrow=length(dnodes[which(dnodes[,2]=="numeric"),1]),ncol=dim(evidence)[2])
  belief_var=matrix(nrow=length(dnodes[which(dnodes[,2]=="numeric"),1]),ncol=dim(evidence)[2])
  # create variables for belief frequencies 
  belief_freq_list=list()
  belief_freq=vector()
  
  for (i in 1:dim(evidence)[2])
  {
   
    ##absorb evidence
    for (j in 1:length(node))
    {
      set.finding(network,node[j],evidence[j,i])
    }
      propagate(network)
    
    ## get belief
    belief<-.get.belief.bn(network,dnodes)

    ## calculate KL divergence
    JSI[,i]<-.get.jsi(marginal,belief,dnodes) 
    
    belief_mean[,i]<-belief[dnodes[which(dnodes[,2]=="numeric"),1],1]
    belief_var[,i]<-belief[dnodes[which(dnodes[,2]=="numeric"),1],2]
    
    if(length(which(dnodes[,2]=="factor"))!=0)
         belief_freq = cbind(belief_freq,matrix(belief[dnodes[which(dnodes[,2]=="factor"),1],3:ncol(belief)],
                                         nrow=length(dnodes[which(dnodes[,2]=="factor"),1]),
                                         ncol=as.numeric(max(class_nodes[,3])),
                                         dimnames=(list(dnodes[which(dnodes[,2]=="factor"),1],
                                                        colnames(belief)[3:ncol(belief)]))))
    
    ##retract the evidence
    retract(network)
  }
  
 
  ## annotate rows and columns

  rownames(JSI)=dnodes[which(dnodes[,2]=="numeric"),1]
  rownames(belief_mean)=dnodes[which(dnodes[,2]=="numeric"),1]
  rownames(belief_var)=dnodes[which(dnodes[,2]=="numeric"),1]

  
if(length(belief_freq)!=0)  
{
  
  
  for (j in 1:as.numeric(max(class_nodes[,3])))
  {
    belief_freq_temp = matrix(belief_freq[,seq(j,ncol(belief_freq),by=as.numeric(max(class_nodes[,3])))],
                              nrow=nrow(belief_freq),
                              ncol=dim(evidence)[2],
                              dimnames=list(rownames(belief_freq),NULL))
    
    name<-paste("state",j,sep="")
    belief_freq_list[[name]]= belief_freq_temp
  }
  
 genomarginal<- matrix(marginal[dnodes[which(dnodes[,2]=="factor"),1],3:ncol(marginal)],
         nrow = length(dnodes[which(dnodes[,2]=="factor"),1]),
         ncol = as.numeric(max(class_nodes[,3])),
         dimnames = list(dnodes[which(dnodes[,2]=="factor"),1],colnames(marginal)[3:ncol(marginal)]))
  
  
}
else
{
  belief_freq_list<-NULL
  genomarginal<-NULL
}

  
  results=list(gp=network,
               evidence=evidence,
               node=node,
               marginal=list(pheno=list(mean = as.matrix(marginal[dnodes[which(dnodes[,2]=="numeric"),1],1]),
                                        var = as.matrix(marginal[dnodes[which(dnodes[,2]=="numeric"),1],2])),
                             geno=list(freq = genomarginal)),
               belief=list(pheno=list(mean=belief_mean,var=belief_var),geno=belief_freq_list),
               JSI=JSI)
  
  class(results)<-"gnbp"
  
  return(results)
  
}



.get.marginal.bn=function(network,dnodes)
  
{
  
  ## create matrices to store results
  marg_mean<-matrix(nrow=dim(dnodes)[1],ncol=1)
  marg_var<-matrix(nrow=dim(dnodes)[1],ncol=1)
  marg_freq<-matrix(nrow=dim(dnodes)[1],ncol=as.numeric(max(dnodes[,3])))
  
  
    ## get mean and var
    for (j in 1:dim(dnodes)[1])
    {  
    
      pmarginal<-get.marginal(network,dnodes[j,1])
      if(dnodes[j,2]=="numeric")
      {
        marg_mean[j,1]<-pmarginal$mean
        marg_var[j,1]<-unlist(pmarginal$cov)
      }
    
      if(dnodes[j,2]=="factor")
      {
        marg_freq[j,]<-pmarginal$table[,2]
      }
    
    }

  ## annotate rows and columns     
  
    if(length(marg_freq)!=0)
    {
      freqnames<-matrix(nrow=as.numeric(max(dnodes[,3])),ncol=1)
      
      for (i in 1:max(dnodes[,3]))
        freqnames[i]=paste("state",i,sep="")
      
      colnames(marg_freq)=freqnames
    }
  
   if(length(marg_mean)!=0)
   {
     colnames(marg_var)=c("var")
     colnames(marg_mean)=c("mean")
   }

marginal<-cbind(cbind(marg_mean,marg_var),marg_freq)
rownames(marginal)=dnodes[,1]
  
  ## return cpt
 
    return(marginal)
  
}



.get.belief.bn=function(network,dnodes)
{
  ## create matrices for storing mean and var of marginal distribution
  belief_mean<-matrix(nrow=dim(dnodes)[1],ncol=1)
  belief_var<-matrix(nrow=dim(dnodes)[1],ncol=1)
  belief_freq<-matrix(nrow=dim(dnodes)[1],ncol=as.numeric(max(dnodes[,3])))
  
  ## predictions for different genotypes
  ## Note:each column is replicated for coding purpose
  
  for (j in 1:(dim(dnodes)[1]))
  { 
    temp<-get.belief(network,dnodes[j,1])
    
    if(dnodes[j,2]=="numeric")
    {
      belief_mean[j,1]<-temp[1]
      belief_var[j,1]<-temp[2]
    }
    
    if(dnodes[j,2]=="factor")
      belief_freq[j,]<-temp
    
  }
  
  
  ## annotate the rows and columns
  if(length(belief_freq)!=0)
  
  {
    freqnames<-matrix(nrow=as.numeric(max(dnodes[,3])),ncol=1)
  
    for (i in 1:max(dnodes[,3]))
      freqnames[i]=paste("state",i,sep="")

    colnames(belief_freq)=freqnames
  }

  if(length(belief_mean)!=0)
  {
    colnames(belief_mean)<-c("mean")
    colnames(belief_var)<-c("var")
  }
  
  belief<-cbind(cbind(belief_mean,belief_var),belief_freq)
  rownames(belief)<-dnodes[,1]
  
  return(belief)
  
}


.get.jsi=function(marginal,belief,dnodes)

  { 
    KLDiv1 = matrix(nrow=length(dnodes[which(dnodes[,2]=="numeric"),1]),ncol=1)
    KLDiv2 = matrix(nrow=length(dnodes[which(dnodes[,2]=="numeric"),1]),ncol=1)
    jsi = matrix(nrow=length(dnodes[which(dnodes[,2]=="numeric"),1]),ncol=1)
    
    k=1 
    
    for (i in 1:nrow(dnodes))
    {
      
      if(dnodes[i,2]=="numeric")
      {
        mu0=marginal[rownames(marginal)==dnodes[i,1],1]
        mu=belief[rownames(belief)==dnodes[i,1],1]
        
        sigma20=marginal[rownames(marginal)==dnodes[i,1],2]
        sigma2=belief[rownames(belief)==dnodes[i,1],2]
        
        KLDiv1[k,1]=0.5*(((mu-mu0)^2)/sigma2 +(sigma20/sigma2)-log(sigma20/sigma2)-1)
        KLDiv2[k,1]=0.5*(((mu0-mu)^2)/sigma20 +(sigma2/sigma20)-log(sigma2/sigma20)-1)
        jsi[k,1]=0.5*(KLDiv1[k,1]+KLDiv2[k,1])*sign(mu-mu0)     
        
        k=k+1
      }   
      
    }
    
    return(jsi)
  
  }
