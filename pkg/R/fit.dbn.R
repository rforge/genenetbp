###################################################################################
# \name{fit-methods}
# \alias{fit.gnbp}
# \alias{fit.dbn}
# %- Also NEED an '\alias' for EACH other topic documented here.
# \title{Fit a Conditional Gaussian Bayesian Network or Discrete Bayesian Network to QTL data}
# 
# \description{Learn the structure of a genotype-phenotype network from quantitative trait loci (QTL) data and the conditional probability table for each node in the network. 
# }
# \usage{
#   ## Fit a conditional gaussian or a discrete bayesian network using RHugin.
#   fit.gnbp(geno,pheno,constraints,learn="TRUE",graph,type ="cg",
#            alpha=0.001,tol=1e-04,maxit=0)
#   ## Fit a discrete bayesian network using bnlearn.
#   fit.dbn(geno,pheno,graph,learn="TRUE",method="hc",whitelist,blacklist)
# }
# %- maybe also 'usage' for other objects documented here.
# \arguments{
#   \item{geno}{a data frame of column vectors of class factor (or one that can be coerced to that class) and non-empty column names.
#               
#   }
#   \item{pheno}{a data frame of column vectors of class numeric for \code{fit.gnpb} if \code{type = "cg"} or class factor if \code{type = "db"} and for \code{fit.dbn}. Non-empty column names. 
#   }
#   \item{constraints}{an optional list of constraints on the edges for specifying required and forbidden edges for \code{fit.dbn}. See details.
#   }
#   \item{learn}{a boolean value. If TRUE (default), the network structure will be learnt. If FALSE, only conditional probabilities will be learnt (a graph must be provided in this case.)
#   }
#   \item{graph}{graph structure of class "graphNEL" or a data frame with two columns of (labeled "from" and "to"), containing a set of edges to be included in the graph to be provided if learn == FALSE. See details.
#   }
#   \item{type}{specify the type of network for \code{fit.gnbp}. \code{"cg"} for \code{Conditional Gaussian} (default) and \code{"db"} for \code{Discrete Bayesian}.
#   }
#   
#   \item{method}{a character string. The score-based or constraint-based algorithms available in the package \pkg{bnlearn}. Valid options are \code{"hc"}, \code{"tabu"}, \code{"gs"}, \code{"iamb"}, \code{"fast.iamb"}, \code{"inter.iamb"}, \code{"mmhc"}. See details below. 
#   }
#   
#   \item{whitelist}{a data frame with two columns of (labeled "from" and "to"), containing a set of edges to be included in the graph.
#   }
#   \item{blacklist}{a data frame with two columns (labeled "from" and "to"), containing a set of edges NOT to be included in the graph.
#   }
#   
#   \item{alpha}{a single numeric value specifying the significance level (for use with RHugin). Default is 0.001.
#   }
#   \item{tol}{a positive numeric value (optional) specifying the tolerance for EM algorithm to learn conditional probability tables (for use with RHugin). Default value is 1e-04. See \code{learn.cpt} for details.
#              
#   }
#   \item{maxit}{a positive integer value (optional) specifying the maximum number of iterations of EM algorithm to learn conditional probability tables (for use with RHugin). See \code{learn.cpt} for details.
#   }
# \value{
#     \code{fit.gnbp} returns an object of class "gpfit" containing the following components.
#     
#     \item{gp}{a pointer to a compiled RHugin domain that is the inferred network structure and the conditional probability tables for each node in the network.}
#     \item{gp_nodes}{a data frame containing information about nodes for internal use with other functions.}
#     \item{gp_flag}{a character string specifying the type of network : "cg" for (\code{Conditional Gaussian} or "db"/"dbn" for \code{Discrete Bayesian})}
#     
#     \code{fit.dbn} returns an object of class "dbnfit" containing the following components. 
#     \item{dbn}{an object of class bn. See \code{\linkS3class{bn-class}} for details. This object contains the inferred network structure and the conditional probability tables for each node in the network.}
#     \item{dbn_nodes}{a data frame containing information about nodes for internal use with other functions.}
#     \item{dbn_flag}{a character string specifying the type of network \code{"dbn"} for \code{Discrete Bayesian})}
#   }

###################################################################################
## Learn Bayesian Network Structure
## from eQTL data (all discrete variables)
###################################################################################
fit.dbn=function(geno,pheno,graph,learn="TRUE",method="hc",whitelist,blacklist)
  
{
  
  ## Geno Class Check ##
  for(i in 1:dim(geno)[2])
    if (class(geno[,i])!="factor")
    {warning("column vectors of 'geno' are not of class factor. converting to factor...")
     geno[,i]<-as.factor(geno[,i])
    }
  
  ## Pheno Class Check ##
  class_pheno=lapply(pheno,class)
    X<-which(class_pheno=="factor")
    if(length(X)!=dim(pheno)[2])
      stop("column vectors of 'pheno' should be of class factor.")
  
  ## Combine data
  Data=cbind(pheno,geno)
  
  if (learn=="TRUE")
  {
  #### Create the blacklist
  ## Impose prior knowledge on the ordering of the variables....
    # Block 2: SNPs (geno)
    # Block 1: Genes (pheno)
  block<-matrix(1,nrow=dim(Data)[2],ncol=1)#assign variables a block
  block[(dim(pheno)[2]+1):dim(Data)[2]]<-2
  block=as.vector(block)
  blM <- matrix(0, nrow = dim(Data)[2], ncol = dim(Data)[2])
  rownames(blM) <- colnames(Data)
  colnames(blM) <- colnames(Data)
  
  # fill in the disallowed edges
  blM[block <= 2, block ==2] <- 1
  
 if(!missing(blacklist))
 {
   for (i in dim(blacklist)[1])
   blM[blacklist[,"from"],blacklist[,"to"]]<-1
 }
  
  blackL <- data.frame(get.edgelist(as(blM, "igraph")))
  names(blackL) <- c("from", "to")
  
  if(!missing(whitelist))
    whiteL=whitelist
  else
   whiteL=NULL
  
  
  ## bnlearn:: hc (Hill-climbing)  
  if(method=="hc") 
    Data.bn <- bnlearn::hc(Data, whitelist=whiteL,blacklist = blackL)
 
  ## bnlearn:: tabu (TABU) 
  if(method=="tabu") 
    Data.bn <- bnlearn::tabu(Data, whitelist=whiteL,blacklist = blackL)
  
  ## bnlearn:: hc (Grow-Shrink)
  if(method=="gs") 
    Data.bn <- bnlearn::gs(Data, whitelist=whiteL,blacklist = blackL)
  
  ## bnlearn:: iamb (Incremental-Association)
  if(method=="iamb") 
    Data.bn <- bnlearn::iamb(Data, whitelist=whiteL,blacklist = blackL)
  
  ## bnlearn:: fast.iamb (Fast Incremental Association)
  if(method=="fast.iamb") 
    Data.bn <- bnlearn::fast.iamb(Data, whitelist=whiteL,blacklist = blackL)
  
  ## bnlearn:: inter.iamb (Interleaved Incremental Association)
  if(method=="inter.iamb") 
    Data.bn <- bnlearn::inter.iamb(Data, whitelist=whiteL,blacklist = blackL)

  ## bnlearn:: MMHC (Max-Min Hill Climbing)
  if(method=="mmhc") 
    Data.bn <- bnlearn::mmhc(Data, whitelist=whiteL,blacklist = blackL)

  # Fit the graphical independence network
  network<-bnlearn::bn.fit(Data.bn,Data)

 
 }else{
    
   if (missing(graph))
      stop("if learn == FALSE, a graph structure (graphNEL object or data.frame of edges) must be provided.")
  
    if(class(graph)=="graphNEL")
    {
      bngraph<-bnlearn::as.bn(graph)
      # Fit the graphical independence network
      network<-bnlearn::bn.fit(bngraph,Data)  
    }
    
    if(class(graph)=="data.frame") 
    {
      ## get nodes
      nodes<-c(colnames(geno),colnames(pheno))
      ## create edge list
      edgeL<-vector("list",length(nodes))
      ## name the list
      names(edgeL) <- nodes
      ## add edges
      for(i in 1:length(edgeL))
        edgeL[[i]]<-list(edges=graph[which(graph[,1]==names(edgeL)[i]),2])
      
      ## create a graphNEL object
      edge.graph<-graphNEL(names(edgeL),edgeL,edgemode="directed")
      
      bngraph<-bnlearn::as.bn(edge.graph)
      # Fit the graphical independence network
      network<-bnlearn::bn.fit(bngraph,Data)  
    }

  }
  
 
 ## Determine type of nodes (discrete or continuous)
 class_nodes=matrix(nrow=dim(Data)[2],ncol=3)
 
 for (i in 1:dim(Data)[2])
   class_nodes[i,]=c(colnames(Data)[i],class(Data[,i]),length(levels(Data[,i])))
 
 class_nodes=cbind(class_nodes,t(cbind(t(rep("pheno",dim(pheno)[2])),t(rep("geno",dim(geno)[2])))))
 colnames(class_nodes)=c("node","class","levels","type")

 
 #########################################
 ## get marginals
 #########################################

 network.grain<-as.grain(network)
## using setEvidence gives error on Mac. network can be queried directly
## by querygrain.
 setEvidence(network.grain)
 grn<-querygrain(network.grain)

  ## create matrices to store results
  cpt<-matrix(NA,nrow=dim(class_nodes)[1],ncol=as.numeric(max(class_nodes[,3])))
  rownames(cpt)=class_nodes[,1]
   
  ## get marginals
  for (j in 1:dim(class_nodes)[1]) 
  {
   cpt_temp<-unlist(grn[class_nodes[j,1]])
   cpt[class_nodes[j,1],1:length(cpt_temp)]<-cbind(cpt_temp)
  }
   
   ## annotate columns     
   
   if(length(cpt)!=0)
   {
     freqnames<-matrix(nrow=as.numeric(max(class_nodes[,3])),ncol=1)
     for (i in 1:max(class_nodes[,3]))
       freqnames[i]=paste("state",i,sep="")
     
     colnames(cpt)=freqnames
   }
   
 X=which(class_nodes[,"type"]=="pheno")
 Y=which(class_nodes[,"type"]=="geno")

 phenomarginal<- cpt[class_nodes[X,1],1:as.numeric(max(class_nodes[X,3]))]
 genomarginal<- cpt[class_nodes[Y,1],1:as.numeric(max(class_nodes[Y,3]))]
 
 ## Return variables
 dbnfit<-list(dbn=network,marginal=list(pheno=list(freq=phenomarginal),geno=list(freq=genomarginal)),
              dbn_nodes=class_nodes,dbn_flag="dbn")
 class(dbnfit)<-"dbnfit"
 
 return(dbnfit)

    
}

