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
## from QTL data
###################################################################################
fit.gnbp=function(geno,pheno,constraints,learn="TRUE",graph,type ="cg",
                  alpha=0.001,tol=1e-04,maxit=0)

  {
  

    ## Geno Class Check ##
    for(i in 1:dim(geno)[2])
      if (class(geno[,i])!="factor")
        {warning("column vectors of 'geno' are not of class factor. converting to factor...")
         geno[,i]<-as.factor(geno[,i])
        }
    
    ## Pheno Class Check ##
      class_pheno=lapply(pheno,class)
     
    if (type=="cg")
      { 
       X<-which(class_pheno=="numeric")
       if(length(X)!=dim(pheno)[2])
        stop("column vectors of 'pheno' should be of class numeric.")
      }
    
    if (type=="db")
    { 
      X<-which(class_pheno=="factor")
      if(length(X)!=dim(pheno)[2])
        stop("column vectors of 'pheno' should be of class factor.")
    }
    
    Data=cbind(pheno,geno)
    
    #####################################
    ## Create RHugin domain
    ## Specify nodes and constraints
    #####################################
    

      requireNamespace("RHugin") || stop("Package not loaded: RHugin");
     
    ## Create a RHugin domain
    network<-RHugin::hugin.domain()
    Nnodes<-length(colnames(Data))
    
      
    ## Determine type of nodes (discrete or continuous)
      class_nodes=matrix(nrow=dim(Data)[2],ncol=3)

    for (i in 1:dim(Data)[2])
    {
        class_nodes[i,]=c(colnames(Data)[i],class(Data[,i]),length(levels(Data[,i])))
    }
    
    class_nodes=cbind(class_nodes,t(cbind(t(rep("pheno",dim(pheno)[2])),t(rep("geno",dim(geno)[2])))))
    
    colnames(class_nodes)=c("node","class","levels","type")
    
     
    Xpheno=which(class_nodes[,"type"]=="pheno")
    Xgeno=which(class_nodes[,"type"]=="geno")

     
    ## Add nodes
    for (node in 1:length(Xpheno))
    {
      if(class_nodes[Xpheno[node],"class"]=="numeric")
        RHugin::add.node(network,class_nodes[Xpheno[node],"node"],kind="continuous") 
      if(class_nodes[Xpheno[node],"class"]=="factor")
        RHugin::add.node(network,class_nodes[Xpheno[node],"node"],states=levels(Data[,class_nodes[Xpheno[node],"node"]]))    
    }

    for (node in 1:length(Xgeno))
      RHugin::add.node(network,class_nodes[Xgeno[node],"node"],states=levels(Data[,class_nodes[Xgeno[node],"node"]]))

    
    ## Set cases
    RHugin::set.cases(network,Data)
     
    if (learn=="TRUE")
    {
 
    # Disallow interaction between discrete nodes
    qtl_constraints<-.GenConstraints(class_nodes)
    
      if(!missing(constraints))
      {
      directed.required<- constraints$directed$required
      directed.forbidden<- constraints$directed$forbidden
        
        if (is.null(constraints$undirected$required))
          {undirected.required<-qtl_constraints$undirected$required} else 
          {idx <- unique(c(names(constraints$undirected$required), names(qtl_constraints$undirected$required)))
           undirected.required<-setNames(mapply(c, constraints$undirected$required[idx], qtl_constraints$undirected$required[idx]), idx)} 
        if (is.null(constraints$undirected$forbidden))
           {undirected.forbidden<-qtl_constraints$undirected$forbidden} else 
           {idx <- unique(c(names(constraints$undirected$forbidden), names(qtl_constraints$undirected$forbidden)))
            undirected.forbidden<-setNames(mapply(c, constraints$undirected$forbidden[idx], qtl_constraints$undirected$forbidden[idx]), idx)}
              
              all_constraints=list(directed=list(required=directed.required,forbidden=directed.forbidden),
                                   undirected=list(required=undirected.required,forbidden=undirected.forbidden))
              
      } else
          all_constraints<-qtl_constraints

  
    ####################################
    ## Learn structure and cpt
    ####################################
     
    RHugin::learn.structure(network,alpha=alpha,constraints=all_constraints)
    
    }else
      
    {
      if (missing(graph))
        stop("if learn == FALSE, a graph structure must be provided.")
      
      if(class(graph)=="graphNEL")
      {
        edges<-data.frame(get.edgelist(igraph.from.graphNEL(graph)))
        RHugin::add.edge(network,edges[2],edges[1])   
      }
        
      if(class(graph)=="data.frame") 
      {
        for(i in 1:dim(graph)[1])
          RHugin::add.edge(network,graph[2],graph[1])
      }
    }
  
    ##Add experience table to all nodes
    for (node in 1:Nnodes)
      RHugin::get.table(network,colnames(Data)[node],type="experience")
    
    ## Compile network and learn cpt
    RHugin::compile(network)
    RHugin::learn.cpt(network,tol=tol,maxit=maxit)
    
    ## get marginals
    cpt<-.get.marginal.bn(network,class_nodes)
        
    gpfit<-list(gp=network,marginal=cpt,gp_nodes=class_nodes,gp_flag=type)
    
    class(gpfit)<-"gpfit"
    
    return(gpfit)
   
  }  

.GenConstraints=function(class_nodes)
{
  X=which(class_nodes[,"type"]=="geno")
  blackL<-matrix(0,nrow=choose(length(X),2) ,ncol=2)
  k=1
  for (i in 1:(length(X)-1))
    for (j in (i+1):length(X))
    {
      blackL[k,]=cbind(class_nodes[X[i],1],class_nodes[X[j],1])
      k=k+1
    }
  

  undirected.forbidden <- vector("list", nrow(blackL))
  
  for (i in 1:nrow(blackL))
  {
    undirected.forbidden[[i]] <- blackL[i,]
  }
  
  undirected <- list(required = NULL,forbidden = undirected.forbidden)
  
  # put into constraints list
  qtl_constraints <- list(directed = NULL, undirected = undirected)
  return(qtl_constraints)
}

## get marginals 
.get.marginal.bn=function(network,class_nodes)
  
{
  
  ## create matrices to store results
  marg_mean<-matrix(nrow=dim(class_nodes)[1],ncol=1)
  marg_var<-matrix(nrow=dim(class_nodes)[1],ncol=1)
  marg_freq<-matrix(nrow=dim(class_nodes)[1],ncol=as.numeric(max(class_nodes[,3])))
  
  
  ## get mean and var
  for (j in 1:dim(class_nodes)[1])
  {  
    
    pmarginal<-RHugin::get.marginal(network,class_nodes[j,1])
    if(class_nodes[j,2]=="numeric")
    {
      marg_mean[j,1]<-pmarginal$mean
      marg_var[j,1]<-unlist(pmarginal$cov)
    }
    
    
    if(class_nodes[j,2]=="factor")
    {
      marg_freq[j,1:class_nodes[j,4]]<-pmarginal$table[,2]
    }
    
  }
  
  ## annotate rows and columns     
  
  if(length(marg_freq)!=0)
  {
    freqnames<-matrix(nrow=as.numeric(max(class_nodes[,3])),ncol=1)
    
    for (i in 1:max(class_nodes[,3]))
      freqnames[i]=paste("state",i,sep="")
    
    colnames(marg_freq)=freqnames
  }
  
  if(length(marg_mean)!=0)
  {
    colnames(marg_var)=c("var")
    colnames(marg_mean)=c("mean")
  }
  
  marginal<-cbind(cbind(marg_mean,marg_var),marg_freq)
  rownames(marginal)=class_nodes[,1]
  
  ## return cpt
  
  return(marginal)
  
}


