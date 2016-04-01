
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

<h1>The geneNetBP Homepage</h1>

The geneNetBP package provides functions to fit Conditional Gaussian Bayesian network (CG-BN) to genotype-phenotype or Quantitative Trait Loci (QTL) data, absorb evidence in the genotype-phenotype network and quantify and visualize the changes in network beliefs. 

<p>geneNetBP facilitates the smooth transition from QTL mapping to graphical modeling to system-wide prediction after absorbing network evidence. Specifically, geneNetBP can be used to absorb and propagate phenotypic evidence through a given CG-BN representation of a genotype-phenotype network, compute the Jeffery’s Information across the network, and provide visualizations for interpretation.</p>


<hr />
<h2> Download </h2>

The <code>geneNetBP</code> package version 1.0.0 is now available and can be downloaded from <a href="https://cran.r-project.org/web/packages/geneNetBP/">CRAN</a>. 

<hr />

<h2>Installation</h2>

The geneNetBP package makes extensive use of RHugin package that provides an R interface for the Hugin Decision Engine (HDE) - a commercial software developed by <a href="http://www.hugin.com">HUGIN EXPERT A/S</a> for building and making inference from Bayesian belief networks.  The RHugin package provides an interface to communicate with the HDE from within R. 

<p>The geneNetBP package <b>requires HDE and the R package RHugin</b> to be installed.</p> 

<dl><h3> Installation Steps</h3> 
	<dt><b> 1. Install Hugin Decision Engine:</b> </dt>
	<dd> The <code>geneNetBP</code> package is compatible with 	the free 	demo version of Hugin Researcher/Developer, 	Hugin Lite 	Demo that can be obtained from <a 	href="http://www.hugin.com/productsservices/demo/hugin-	lite"> HUGIN</a>. The free demo version is limited to 	handle only 50 states and 500 cases.    
	If you do not have Hugin installed in the default location 	you will need to set the HUGINHOME environment variable 	before using the RHugin package. Also, you will need to 	modify the HUGINHOME variable. Please see the instructions 	on the project homepage for <a href="http://rhugin.r-	forge.r-project.org/">RHugin</a>.
	</dd>

	<dt><b> 2. Install RHugin package:</b> </dt>
	<dd> RHugin is available on R-Forge and NOT on CRAN. 
	Installation instructions for RHugin can be found 	on 	its project homepage <a href="http://rhugin.r-	forge.r-	project.org/"> RHugin</a>.It is important to 	install 	the matching versions and the architecture (32/64 	bit) 	of Hugin Lite, <code>RHugin</code> and R as listed on 	RHugin 	project homepage.Please note that RHugin is 	required for 	proper functioning of geneNetBP. The 	package RHugin will 	not automatically load upon loading 	geneNetBP package. 	Please use library(RHugin) or require	(RHugin) to load it 	before using geneNetBP.
	</dd>

	<dt><b> 3. Install other package dependencies:</b></dt> 
	<dd> Both <code>geneNetBP</code> and <code>RHugin</code> 	depend on the Bioconductor 	packages <code>graph	</code> and <code>Rgraphviz</code>. 	Run the following 	commands to install them.
	<pre>
  	source(&quot;http://bioconductor.org/biocLite.R&quot;)
  	biocLite(c(&quot;graph&quot;, &quot;Rgraphviz&quot;))
	</pre>
	<p> scales: </p>The package <code>scales</code> should 	automatically get installed with the package <code>	geneNetBP</code>. If it does not, then you can manually 	install it. It is available on CRAN. Use R install 	command
	<pre> install.packages(&quot;scales&quot;)</pre>
	</dd>
	
	<dt><b> 4. Install the geneNetBP package:</b> </dt>
	<dd> The geneNetBP package version 1.0.0 can be downloaded 	from <a href="https://cran.r-	project.org/web/packages/geneNetBP/">CRAN</a>. 
	</dd>

</dl>
<hr />

<h2>Documentation</h2>

<hr />
<h2>Examples</h2>

<hr />
<h2>References</h2>

<dl> 
<dt></dt> 
<dd><a href="http://www.degruyter.com/view/j/sagmb.ahead-of-print/sagmb-2015-0058/sagmb-2015-0058.xml">Belief Propagation in genotype-phenotype networks</a></dd> 
<dd>Moharil, J., May, P.,Gaile, D.P. and Blair, R.H. (<b>2016</b>)</dd>
<dd><i>Stat Appl Genet Mol Biol.</i> , Vol. 15(1), pp. 39-53</dd> 

<dt></dt> 
<dd><a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.46.631&rep=rep1&type=pdf">Stable local computation with conditional gaussian distributions(<b>2001</b>)</a></dd> 
<dd>Lauritzen, S. L. and F. Jensen </dd> 
<dd><i>Stat. Comput.</i>, Vol. 11(2), pp. 191-203</dd> 

<dt></dt> 
<dd><a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.52.2564&rep=rep1&type=pdf">Propagation of probabilities, means, and variances in mixed graphical association models(<b>1992</b>)</a></dd> 
<dd>Lauritzen, S. L.</dd> 
<dd><i>J. Am. Statist. Assoc.</i>, Vol. 87, pp. 1098-1108</dd> 

<dt></dt> 
<dd><a href="http://www.jstor.org/stable/2345762?origin=JSTOR-pdf&seq=1#page_scan_tab_contents">Local computations with probabilities on graphical structures and their application to expert systems(<b>1988</b>)</a></dd> 
<dd>Lauritzen, S. L. and D. J. Spiegelhalter </dd> 
<dd><i>J. Roy. Stat. Soc. B Met.</i>, Vol. 50 (2), pp. 157-224</dd> 


</body>
</html>
