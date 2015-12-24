
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

The package makes extensive use of RHugin package that provides an R interface for the Hugin Decision Engine (HDE) which is a commercial software developed by <a href="http://www.hugin.com">HUGIN EXPERT A/S</a> for building and making inference from Bayesian belief networks.  The RHugin package provides a suite of functions allowing the HDE to be controlled from within R. Please note that RHugin is currently not available on CRAN. The package {RHugin} can be obtained from R-Forge by accessing the link <a href="http://r-forge.r-project.org/projects/rhugin/"></a>. 

<h2>Package Installation</h2>

<p> HUGIN Decision Engine.</p>


<h4>Dependencies</h4>

<p>
RHugin has dependencies on the Bioconductor packages <code>graph</code> and <code>Rgraphviz</code>. Run the commands
</p>

<pre>
  source(&quot;http://bioconductor.org/biocLite.R&quot;)
  biocLite(c(&quot;graph&quot;, &quot;Rgraphviz&quot;))
</pre>

<p>
to install them.
</p>


</body>
</html>
