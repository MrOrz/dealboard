<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                xmlns:common="http://exslt.org/common"
                extension-element-prefixes="common"
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


<xsl:template match="/">
<html>
<head>
<xsl:copy-of select="$shortcuticon"/>

<title>
<xsl:copy-of select="$booktitle"/>
</title>
    <FRAMESET COLS="225,*">
    <FRAME SRC="toc.html" name="toc"></FRAME>
    <FRAME name="display">
	<xsl:attribute name="src"><xsl:value-of select="bridge:book/bridge:article[position()=1]/@href"/>.html</xsl:attribute>
    </FRAME>
    </FRAMESET>
</head>
<body>

<common:document href='toc.html'> 
<html>
<head>
<link rel="stylesheet" type="text/css" href="../article.css"/>
<xsl:copy-of select="$shortcuticon"/>
<title>
<xsl:copy-of select="$booktitle"/>
</title>
</head>
<body class="toc">
<div class="back">
<a href="../../" target="_top">Back to the
<em>Bridge Fantasia</em></a>
</div>
<div class="tocindex">
<!--<h3><xsl:copy-of select="$booktitle"/></h3>-->
<h3>Contents</h3>
<xsl:apply-templates select="bridge:book/bridge:chapter|bridge:book/bridge:article"/>
<br/>
</div> <!-- tocindex -->
<div class="tocsignature">
<xsl:value-of select="$copyright"/>
</div>
</body>
</html>
</common:document>
</body>
</html>
</xsl:template>

<xsl:template match="bridge:article[@href]">
<xsl:call-template name="article">
<xsl:with-param name="article" select="document(concat('xml/',$dest,'/',@href,'.xml'))/bridge:article"/>
<xsl:with-param name="html"  select="concat(@href,'.html')"/>
<xsl:with-param name="dest"  select="$dest"/>
<xsl:with-param name="prev"  select="preceding::bridge:article[@href][position()=1]/@href"/>
<xsl:with-param name="next"  select="following::bridge:article[@href][position()=1]/@href"/>
<xsl:with-param name='tag' select='@tag'/>
</xsl:call-template>
</xsl:template>

<xsl:template match="bridge:article">
<div class="body">
<xsl:apply-templates select="bridge:title"/>
<xsl:apply-templates select="bridge:body"/> 
</div>
</xsl:template>

<xsl:template match="bridge:chapter">
<h3><xsl:value-of select="bridge:title"/></h3>
<xsl:apply-templates select="bridge:article"/>
</xsl:template>

<xsl:template name="article">
<xsl:param name="article"/>
<xsl:param name="html"/>
<xsl:param name="dest"/>
<xsl:param name="prev"/>
<xsl:param name="next"/>
<xsl:param name="tag"/>

<xsl:variable name="title"><xsl:value-of select="$article/bridge:title"/></xsl:variable>

<xsl:message>
Creating <xsl:value-of select="concat($dest,'/',$html)"/> (<xsl:value-of select="$title"/>)
</xsl:message>

<xsl:variable name="prevnexttop">
<table class="prevandnext"><tr><td class="prev">
<xsl:if test="$prev">
<a href="{$prev}.html">&lt;&lt; <xsl:value-of select="document(concat('xml/',$dest,'/',$prev,'.xml'))/bridge:article/bridge:title"/></a>
</xsl:if>
</td><td class="middle">
<xsl:copy-of select="$sym.club"/><xsl:copy-of select="$sym.diamond"/><xsl:text> </xsl:text><xsl:value-of select="$booktitle"/><xsl:text> </xsl:text><xsl:copy-of select="$sym.heart"/><xsl:copy-of select="$sym.spade"/>
</td><td class="next">
<xsl:if test="$next">
<a href="{$next}.html"><xsl:value-of select="document(concat('xml/',$dest,'/',$next,'.xml'))/bridge:article/bridge:title"/> &gt;&gt;</a>
</xsl:if>
</td></tr>
</table>
</xsl:variable>

<xsl:variable name="prevnextbottom">
<table class="prevandnext"><tr><td class="prev">
<xsl:if test="$prev">
<a href="{$prev}.html">&lt;&lt; <xsl:value-of select="document(concat('xml/',$dest,'/',$prev,'.xml'))/bridge:article/bridge:title"/></a>
</xsl:if>
</td><td class="middle">
<xsl:copy-of select="$signature"/>
</td><td class="next">
<xsl:if test="$next">
<a href="{$next}.html"><xsl:value-of select="document(concat('xml/',$dest,'/',$next,'.xml'))/bridge:article/bridge:title"/> &gt;&gt;</a>
</xsl:if>
</td></tr>
</table>
<div class="signature"><xsl:copy-of select="$creationNote"/></div>
</xsl:variable>

<div class="tocentry"><a target="display" href="{$html}">
<xsl:if test="$tag!=''">
<span class='tag'><xsl:value-of select='$tag'/>
<xsl:text> </xsl:text></span>
</xsl:if><xsl:value-of select="$title"/></a></div>
<common:document href="{$html}">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<link rel="stylesheet" type="text/css" href="../article.css"/>
<xsl:if test="$next">
<link rel="next" href="{$next}.html"/>
</xsl:if>
<xsl:if test="$prev">
<link rel="prefetch" href="{$prev}.html"/>
</xsl:if>
<xsl:copy-of select="$shortcuticon"/>
<title><xsl:value-of select="$article/bridge:title"/></title>
</head>
<body>
<xsl:copy-of select="$prevnexttop"/>
<xsl:apply-templates select="$article"/>
<xsl:copy-of select="$prevnextbottom"/>
</body>
</html>
</common:document>
</xsl:template>

</xsl:stylesheet>
