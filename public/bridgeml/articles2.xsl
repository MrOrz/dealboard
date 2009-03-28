<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                exclude-result-prefixes="trans bridge">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->
<xsl:import href="shared.xsl"/>

<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

<xsl:variable name="dest"><xsl:value-of select="/bridge:book/@dest"/></xsl:variable>

<xsl:variable name="booktitle"><xsl:value-of select="/bridge:book/bridge:booktitle"/></xsl:variable>

<xsl:variable name="copyright">&#169; <xsl:value-of select="/bridge:book/bridge:copyright"/></xsl:variable>

<xsl:variable name="signature">
<div class="signature">
<xsl:value-of select="/bridge:book/bridge:author"/>
(<a><xsl:attribute name="href">mailto:<xsl:value-of select="/bridge:book/bridge:author/@email"/></xsl:attribute>
<xsl:value-of select="/bridge:book/bridge:author/@email"/></a>),
<xsl:value-of select="$copyright"/>.
</div>
</xsl:variable>

<xsl:variable name="firstArticle">
<xsl:value-of select="//bridge:article[@href][1]/@href"/>
</xsl:variable>

<xsl:template match="/">

<html>
<head>
<xsl:copy-of select="$shortcuticon"/>
<link rel="stylesheet" type="text/css" href="../article.css"/>
<script language="javascript" src="../articles.js"> 
</script>
<title>
<xsl:copy-of select="$booktitle"/>
</title>

</head>
<body onload='defaultStartArticle("{$firstArticle}")'>

<div id="back">
<a href="../../" target="_top">Back to the <em>Bridge Fantasia</em></a>
</div>

<div id="toc">
<h1>Contents</h1>
<xsl:apply-templates mode="toc" select="bridge:book/bridge:chapter|bridge:book/bridge:article"/>
</div> <!-- tocindex -->

<div id="body">
<!--<div id="booktitle"><h1><xsl:value-of select="$booktitle"/></h1></div>-->
<div id="loadingthearticles"><h2>Loading articles...</h2></div>
<xsl:apply-templates select="bridge:book/bridge:chapter|bridge:book/bridge:article"/>
<div id="articlesfooter">
<table class="prevandnext"><tr><td></td><td class="middle">
<xsl:copy-of select="$signature"/>
</td><td class="next">
</td></tr>
</table>
<div class="signature"><xsl:copy-of select="$creationNote"/></div>
</div>
</div>
</body>
</html>

</xsl:template>

<xsl:template mode="toc" match="bridge:chapter">
<div class="tocchapter"><xsl:value-of select="bridge:title"/></div>
<xsl:apply-templates mode="toc" select="bridge:article"/>
</xsl:template>

<xsl:template mode="toc" match="bridge:article[@href]">
<xsl:variable name="toctitle">
<xsl:value-of select="document(concat('xml/',$dest,'/',@href,'.xml'))/bridge:article/bridge:title"/>
</xsl:variable>
<div class="tocentry">
<div id="{@href}toclink" style="display: block;"><a href='javascript:openEntry("{@href}")'>
<xsl:value-of select="$toctitle"/>
</a></div>
<div id="{@href}tocselected" style="font-weight: bold;  display: none;"><xsl:value-of select="$toctitle"/></div>
</div>
</xsl:template>

<xsl:template match="bridge:article[@href]">
<xsl:call-template name="article">
<xsl:with-param name="article" select="document(concat('xml/',$dest,'/',@href,'.xml'))/bridge:article"/>
<xsl:with-param name="name"  select="@href"/>
<xsl:with-param name="dest"  select="$dest"/>
<xsl:with-param name="prev"  select="preceding::bridge:article[@href][position()=1]/@href"/>
<xsl:with-param name="next"  select="following::bridge:article[@href][position()=1]/@href"/>
</xsl:call-template>
</xsl:template>

<xsl:template match="bridge:article">
<div class="body">
<xsl:apply-templates select="bridge:title"/>
<xsl:apply-templates select="bridge:body"/> 
</div>
</xsl:template>

<xsl:template match="bridge:chapter">
<xsl:apply-templates select="bridge:article"/>
</xsl:template>

<xsl:template name="article">
<xsl:param name="article"/>
<xsl:param name="name"/>
<xsl:param name="dest"/>
<xsl:param name="prev"/>
<xsl:param name="next"/>

<xsl:variable name="title"><xsl:value-of select="$article/bridge:title"/></xsl:variable>

<xsl:message>
Handling <xsl:value-of select="$name"/> (<xsl:value-of select="$title"/>)
</xsl:message>
<xsl:variable name="prevnexttop">
<table class="prevandnext"><tr><td class="prev">
<xsl:if test="$prev">
<a href='javascript:openEntry("{$prev}")'>&lt;&lt; <xsl:value-of select="document(concat('xml/',$dest,'/',$prev,'.xml'))/bridge:article/bridge:title"/></a>
</xsl:if>
</td><td class="middle">
<xsl:copy-of select="$sym.club"/><xsl:copy-of select="$sym.diamond"/><xsl:text> </xsl:text><xsl:value-of select="$booktitle"/><xsl:text> </xsl:text><xsl:copy-of select="$sym.heart"/><xsl:copy-of select="$sym.spade"/>
</td><td class="next">
<xsl:if test="$next">
<a href='javascript:openEntry("{$next}")'><xsl:value-of select="document(concat('xml/',$dest,'/',$next,'.xml'))/bridge:article/bridge:title"/> &gt;&gt;</a>
</xsl:if>
</td></tr>
</table>
</xsl:variable>
<xsl:variable name="prevnextbottom">
</xsl:variable>
<div id="{$name}" style="display:none;">
<xsl:copy-of select="$prevnexttop"/>
<xsl:apply-templates select="$article"/>
</div>
</xsl:template>

<xsl:template match="bridge:link[@internal]">
<a href='javascript:openEntry("{@internal}")'>
<xsl:apply-templates/>
</a>
</xsl:template>
</xsl:stylesheet>
