### R code from vignette source 'geneNetBPvignette.Rnw'

###################################################
### code chunk number 1: dataset
###################################################
data(mouse,package="geneNetBP")
head(geno,n=3)
head(pheno,n=3)


###################################################
### code chunk number 2: A
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
library(geneNetBP)
fit.gnbp(geno,pheno)
  }


###################################################
### code chunk number 3: B
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
fit.gnbp(geno,pheno,alpha = 0.1)
}


###################################################
### code chunk number 4: B1
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
network<-fit.gnbp(geno,pheno,alpha = 0.1)
##convert the RHugin domain to a graph object
BNgraph<-as.graph.RHuginDomain(network$gp)
##set node font size
attrs<-list()
attrs$node$fontsize<-30
## plot method for graph objects
plot(BNgraph,attrs=attrs) 
}


###################################################
### code chunk number 5: C
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
##Fit network
network<-fit.gnbp(geno,pheno,alpha = 0.1)
##Generate evidence
evidence<-gen.evidence(network,node="Tlr12",std=2,length.out=20)
}


###################################################
### code chunk number 6: F
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
## Fit network
network<-fit.gnbp(geno,pheno,alpha=0.1)
## Absorb evidence
absorb.gnbp(network,node="Tlr12",evidence=matrix(-0.99))
}


###################################################
### code chunk number 7: G
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
## Fit network
network<-fit.gnbp(geno,pheno,alpha=0.1)
##Absorb evidence
absorb.gnbp(network,node="Tlr12",evidence=matrix(2.5,3,3.5,4))
}


###################################################
### code chunk number 8: I
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
## Fit, absorb and plot a genotype-phenotype network
network<-fit.gnbp(geno,pheno,alpha=0.1)
network<-absorb.gnbp(network,node="Tlr12",evidence=matrix(-0.99))
plot(x=network)
}


###################################################
### code chunk number 9: J
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
col.palette<-list(pos_high="darkgreen", pos_low= "palegreen2", 
                    neg_high="wheat1", neg_low = "red",
                    dsep_col="white",qtl_col="grey",node_abs_col="yellow") 
plot(x=network,col.palette=col.palette)
}


###################################################
### code chunk number 10: K
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
##Fit network
network<-fit.gnbp(geno,pheno,alpha = 0.1)
##Generate evidence
evidence<-gen.evidence(network,node="Tlr12",std=2,length.out=20)
network<-absorb.gnbp(network,node="Tlr12",evidence=evidence)
plot(x=network,y="belief",ncol=20)
}


###################################################
### code chunk number 11: L
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
## Load the toy dataset
data(toy)
## Create a list of edges ("from (parent)", "to (child)")
edgelist=list()
edgelist[[1]]<-cbind("Q1","X1")
edgelist[[2]]<-cbind("Q2","X1")
edgelist[[3]]<-cbind("Q2","X2")
edgelist[[4]]<-cbind("Q2","X4")
edgelist[[5]]<-cbind("X1","X2")
edgelist[[6]]<-cbind("Q3","X2")
edgelist[[7]]<-cbind("Q3","X3")
edgelist[[8]]<-cbind("X2","X5")
edgelist[[9]]<-cbind("X2","X6")
edgelist[[10]]<-cbind("X4","X6")
}


###################################################
### code chunk number 12: M
###################################################
if(!suppressWarnings(require("RHugin"))) 
  {
     stop(paste("This package uses RHugin, but you do not currently have it installed. ",
            "You can get it by visiting [http://rhugin.r-forge.r-project.org/] and",
            "following the instructions there."))
  }
if(suppressWarnings(require("RHugin"))) 
  {
##Fit network
network<-fit.gnbp(toygeno,toypheno,learn=FALSE,edgelist=edgelist)
##Generate evidence
evidence<-gen.evidence(network,node="X2",std=2,length.out=20)
network<-absorb.gnbp(network,node="X2",evidence=evidence)
plot(x=network,y="JSI",ncol=17)
}


