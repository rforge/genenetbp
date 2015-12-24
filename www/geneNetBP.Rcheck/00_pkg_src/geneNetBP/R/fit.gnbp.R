####################################
## Learn Bayesian Network Structure
## from QTL data
####################################
fit.gnbp=function(geno,pheno,constraints,learn="TRUE",edgelist,alpha=0.001,tol=1e-04,maxit=0)

  {
  
    ## Geno Class Check ##
    for(i in 1:dim(geno)[2])
      if (class(geno[,i])!="factor")
        {warning("column vectors of 'geno' are not of class factor. converting to factor...")
         geno[,i]<-as.factor(geno[,i])
        }
    
    ## Pheno Class Check ##
      class_pheno=apply(pheno,2,class)
      X<-which(class_pheno=="numeric")
    if (length(X)!=dim(pheno)[2])
      stop("column vectors of 'pheno' should be either all numeric or all factor.")
         
    Data=cbind(pheno,geno)
    
    #####################################
    ## Create RHugin domain
    ## Specify nodes and constraints
    #####################################
     
    ## Create a RHugin domain
    network<-hugin.domain()
    Nnodes<-length(colnames(Data))
    
      
    ## Determine type of nodes (discrete or continuous)
      class_nodes=matrix(nrow=dim(Data)[2],ncol=3)

    for (i in 1:dim(Data)[2])
    {
        class_nodes[i,]=c(colnames(Data)[i],class(Data[,i]),length(levels(Data[,i])))
    }
    
    class_nodes=cbind(class_nodes,t(cbind(t(rep("pheno",dim(pheno)[2])),t(rep("geno",dim(geno)[2])))))
    
    colnames(class_nodes)=c("node","class","levels","type")
    
     
    Xnum=which(class_nodes[,"type"]=="pheno")
    Xfac=which(class_nodes[,"type"]=="geno")

     
    ## Add nodes
    for (node in 1:length(Xnum))
    {
      if(class_nodes[node,"class"]=="numeric")
        add.node(network,colnames(Data)[Xnum[node]],kind="continuous") 
      if(class_nodes[node,"class"]=="factor")
        add.node(network,colnames(Data)[Xnum[node]],kind="discrete",states=class_nodes[node,"levels"])    
    }

    for (node in 1:length(Xfac))
      add.node(network,colnames(Data)[Xfac[node]],kind="discrete",states=levels(Data[,Xfac[node]]))

    
    ## Set cases
    set.cases(network,Data)
     
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
        
      } 
      else
          all_constraints<-qtl_constraints

  
    ####################################
    ## Learn structure and cpt
    ####################################
     
    learn.structure(network,alpha=alpha,constraints=all_constraints)
    
    }
    
    else
    {
      if (missing(edgelist))
        stop("if learn == TRUE, edgelist must be provided.")
      
      for (i in 1:length(edgelist))
      {
        edges<-unlist(edgelist[[i]])
        add.edge(network,edges[,2],edges[,1])
      }

    }
  
    ##Add experience table to all nodes
    for (node in 1:Nnodes)
      get.table(network,colnames(Data)[node],type="experience")
    
    ## Compile network and learn cpt
    compile(network)
    learn.cpt(network,tol=tol,maxit=maxit)
        
    gpfit<-list(gp=network,gp_nodes=class_nodes)
    
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




