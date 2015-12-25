
<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->

<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">

  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $group_name; ?></title>
	<link href="http://<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
  </head>

<body>

<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="http://r-forge.r-project.org/"><img src="http://<?php echo $themeroot; ?>/imagesrf/logo.png" border="0" alt="R-Forge Logo" /> </a> </td> </tr>
</table>


<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->

<h1>The geneNetBP Package Homepage</h1>

The geneNetBP package provides functions to fit Conditional Gaussian Bayesian network to genotype-phenotype or Quantitative Trait Loci (QTL) data, absorb evidence in the genotype-phenotype network and quantify and visualize the changes in network beliefs. 

The package makes extensive use of RHugin package that provides an R interface for the Hugin Decision Engine (HDE) which is a commercial software developed by <a href="http://www.hugin.com">HUGIN EXPERT A/S</a> for building and making inference from Bayesian belief networks.  The RHugin package provides an interface to communicate with the HDE from within R. Please note that RHugin is currently not hosted on CRAN. The package RHugin is available on R-Forge and can be obtained <a href="http://r-forge.r-project.org/projects/rhugin/">here</a>. 

<h2>Installation</h2>

The geneNetBP package requires HDE and the R package RHugin to be installed to function. Here 

<p> Installation Steps </p>
1. Install Hugin Decision Engine
2. Install the corresponding version of RHugin package
3. Install other package dependencies (Rgraphviz, scales)
4. Install the geneNetBP package

<p> HUGIN Decision Engine.</p>

The geneNetBP package is compatible with the free demo version of Hugin Researcher/Developer, Hugin Lite Demo that can be obtained from http://www.hugin.com/productsservices/demo/hugin-lite. The free demo version is limited to handle only 50 states and 500 cases.    
If you do not have Hugin installed in the default location you will need to set the HUGINHOME environment variable before using the RHugin package. Also, you will need to modify the HUGINHOME variable. Please see the instructions on the project homepage for <a href="http://rhugin.r-forge.r-project.org/">RHugin</a>

<h4>Package Dependencies</h4>

<p> RHugin
geneNetBP package depends on RHugin package which is not on CRAN, installing geneNetBP will not automatically install RHugin. Installation instructions for RHugin can be found on its project homepage http://rhugin.r-forge.r-project.org/

It is important to install the matching versions and the architecture (32/64 bit) of Hugin Lite and RHugin.

<p> Rgraphviz, graph</p>
Both geneNetBP and RHugin depend on the Bioconductor packages <code>graph</code> and <code>Rgraphviz</code>. Run the commands
<pre>
  source(&quot;http://bioconductor.org/biocLite.R&quot;)
  biocLite(c(&quot;graph&quot;, &quot;Rgraphviz&quot;))
</pre>

<p>to install them.</p>


</body>
</html>
