# \name{absorb-methods}
# \alias{absorb.gnbp}
# \alias{absorb.dbn}
# \title{
#   Absorb evidence and propagate beliefs in a genotype-phenotype network
# }
# \usage{
#   ## For Conditional Gaussian Bayesian Networks / Discrete Bayesian Networks (Implements RHugin)
#   absorb.gnbp(object, node, evidence)
#   ## For Discrete Bayesian Networks (Implements gRain)
#   absorb.dbn(object, node, evidence)
# }
# \arguments{
#   \item{gpfit}{
#     an object of class "gpfit" (output from \code{\link{fit.gnbp}}) for \code{absorb.gnbp}or an object of class "dbnfit" (Output from \code{\link{fit.dbn}})for \code{absorb.dbn}. 
#   }
#   \item{dbnfit}{
#     
#   }
#   \item{node}{
#     a character vector specifying the names of the nodes for which the evidence is to be absorbed.
#   }
#   \item{evidence}{
#     a matrix or a numeric vector of evidence. number of rows of the matrix or the length of the vector should be equal to the length of \code{node}. 
#   }
# }
# 
# \value{
# \code{absorb.gnbp} returns an object of class "gnbp" while \code{absorb.dbn} returns an object of class "dbn". An object of class "gnbp" or "dbn" is a list containing the following components
# 
# \item{gp}{an RHugin domain (for \code{absorb.gnbp}) or a grain object (for \code{absorb.dbn}) that is triangulated, compiled and with the latest absorbed evidence propagated.  }
# \item{gp_flag}{type of network.}
# \item{node}{a character vector specifying the nodes for which evidence has been absorbed}
# \item{marginal}{a list of marginal probabilities for phenotypes (\code{pheno}) and genotypes (\code{geno})}
# \item{belief}{a list of updated beliefs for phenotypes (\code{pheno}) and genotypes (\code{geno})}
# \item{JSI}{a matrix of Jeffrey's signed information if network is \code{Conditional Gaussian}, otherwise \code{NULL} if network is \code{Discrete Bayesian}}. 
# \item{FC}{a list of two. a matrix \code{FC} of fold changes and a matrix \code{pheno_state} of phenotype node beliefs - state with maxium probability. If network is \code{Conditional Gaussian}, a \code{NULL} value is returned.}
#
#}
#############################################################################
absorb.dbn=function(object,node,evidence)
  
{
  
  ## get node attributes and network
  class_nodes=object$dbn_nodes
  
  ## get d-connected nodes
  blM<-as.adjMAT(bngraph)
  dnodes=c()
  for (i in 1:dim(class_nodes)[1])
  {
    if(!dSep(blM,node,class_nodes[i,1],cond=NULL))
      dnodes<-rbind(dnodes,class_nodes[i,])
  }
  
  for (i in 1:length(node))
  {
    Xnode<-which(dnodes[,1]==node[i])
    dnodes<-dnodes[-Xnode,]
  }
  
  ## check if class of evidence is matrix
  if(!is.matrix(evidence))
    stop("In function(absorb.dbn),'evidence' must be a matrix of factors")
  
  
  ## get marginals
  network<-as.grain(object$dbn)
  setEvidence(network)
  grn<-querygrain(network)
  marginal<-.get.cpt.grn(grn,dnodes)
  
  ## index dconnected genotypes & phenotypes
  Y<-which(dnodes[,4]=="geno" )
  Z<-which(dnodes[,4]=="pheno")
  
  ## create matrices to store phenotype results
  FC=matrix(nrow=length(dnodes[Z,1]),ncol=dim(evidence)[2])
  pheno_state=matrix(nrow=length(dnodes[Z,1]),ncol=dim(evidence)[2])
  belief_pheno_freq_list=list()
  belief_pheno_freq=vector()

  ## create variables to store genotype results
  belief_geno_freq_list=list()
  belief_geno_freq=vector()
  
  
  ## Absorb evidence and calculate FC
  for (i in 1:dim(evidence)[2])
  {
    retractEvidence(network)
    grn<-setEvidence(network,node,evidence[,i])
    grnstate<-querygrain(grn)

    ## get belief
    belief<-.get.cpt.grn(grnstate,dnodes)
    
    ## calculate FC
    FC_temp<-.get.FC.grn(marginal,belief,dnodes)
      
    ## extract FC
    FC[,i]<- FC_temp[,2]
      
    ## extract the state with maximum probability
    pheno_state[,i]<-FC_temp[,1]
      
    ## extract phenotype beliefs
    if(length(Z)!=0)
      belief_pheno_freq = cbind(belief_pheno_freq,matrix(belief[dnodes[Z,1],1:ncol(belief)],
                                                           nrow=length(dnodes[Z,1]),
                                                           ncol=as.numeric(max(dnodes[,3])),
                                                           dimnames=(list(dnodes[Z,1],
                                                                          colnames(belief)))))
    print(colnames(belief))
    
    ## extract genotype beliefs
    if(length(Y)!=0)
      belief_geno_freq = cbind(belief_geno_freq,matrix(belief[dnodes[Y,1],1:ncol(belief)],
                                                       nrow=length(dnodes[Y,1]),
                                                       ncol=as.numeric(max(dnodes[,3])),
                                                       dimnames=(list(dnodes[Y,1],
                                                                      colnames(belief)))))
  }

  
  ## annotate rows and columns
    rownames(FC)=dnodes[Z,1]
    rownames(pheno_state)=dnodes[Z,1]
#     colnames(FC)=paste("ev=",as.character(evidence))
#     colnames(pheno_state)=paste("ev=",as.character(evidence))
    
    FC=list(FC=FC,pheno_state=pheno_state)


      
    for (j in 1:as.numeric(max(dnodes[Z,3])))
    {
      belief_pheno_freq_temp = matrix(belief_pheno_freq[,seq(j,ncol(belief_pheno_freq),by=as.numeric(max(dnodes[,3])))],
                                      nrow=nrow(belief_pheno_freq),
                                      ncol=dim(evidence)[2],
                                      dimnames=list(rownames(belief_pheno_freq),NULL))
      
      name<-paste("state",j,sep="")
#       colnames(belief_pheno_freq_temp)<-paste("ev=",as.character(evidence))
      belief_pheno_freq_list[[name]]= belief_pheno_freq_temp
    }
    
  
    phenomarginal<- marginal[dnodes[Z,1],1:as.numeric(max(dnodes[Z,3]))]

  
  ## create a list for belief genotype frequencies
  if(length(belief_geno_freq)!=0)  
  {
    for (j in 1:as.numeric(max(dnodes[Y,3])))
    {
      belief_geno_freq_temp = matrix(belief_geno_freq[,seq(j,ncol(belief_geno_freq),by=as.numeric(max(dnodes[,3])))],
                                     nrow=nrow(belief_geno_freq),
                                     ncol=dim(evidence)[2],
                                     dimnames=list(rownames(belief_geno_freq),NULL))
      
      name<-paste("state",j,sep="")
#       colnames(belief_geno_freq_temp)<-paste("ev=",as.character(evidence))
      belief_geno_freq_list[[name]]= belief_geno_freq_temp
    }
    
    genomarginal<- marginal[dnodes[Y,1],1:as.numeric(max(dnodes[Y,3]))]
  }else
  {
    belief_geno_freq_list<-NULL
    genomarginal<-NULL
  }

  
  ## store & return results
    results=list(gp=grn,
                 gp_flag="db",
                 gp_nodes=class_nodes,
                 evidence=evidence,
                 node=node,
                 marginal=list(pheno = list(freq = phenomarginal),
                               geno = list(freq = genomarginal)),
                 belief=list(pheno = belief_pheno_freq_list,geno = belief_geno_freq_list),
                 FC=FC)
  
  class(results)<-"dbn"
  
  return(results)
  
}



.get.cpt.grn=function(grnstate,dnodes)
  
{
  ## create matrices to store results
  cpt<-matrix(NA,nrow=dim(dnodes)[1],ncol=as.numeric(max(dnodes[,3])))
  rownames(cpt)=dnodes[,1]
  
  ## get marginals
  for (j in 1:dim(dnodes)[1]) 
    {
    cpt_temp<-unlist(grnstate[dnodes[j,1]])
    cpt[dnodes[j,1],1:length(cpt_temp)]<-cbind(cpt_temp)
    }
  
  ## annotate columns     
  
  if(length(cpt)!=0)
  {
    freqnames<-matrix(nrow=as.numeric(max(dnodes[,3])),ncol=1)
    for (i in 1:max(dnodes[,3]))
      freqnames[i]=paste("state",i,sep="")
  
    colnames(cpt)=freqnames
  }
   
  ## return 
  return(cpt)
  
}



.get.FC.grn=function(marginal,belief,dnodes)
  
{ 
  Z<- which(dnodes[,4]=="pheno")
  FC = matrix(nrow=length(dnodes[Z,1]),ncol=2)
  
  for (i in 1:nrow(dnodes[Z,]))
  {
    FC[i,1] = which.max(belief[dnodes[Z[i],1],])
    FC[i,2] = belief[dnodes[Z[i],1],FC[i,1]]/marginal[dnodes[Z[i],1],FC[i,1]]  
  }
  
  return(FC)
  
}
