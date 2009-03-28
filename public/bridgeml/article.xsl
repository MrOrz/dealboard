<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                exclude-result-prefixes="trans bridge">
<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->
<xsl:import href="shared.xsl"/>
<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

<xsl:variable name="copyright">&#169; <xsl:value-of select="/bridge:article/bridge:copyright"/>.</xsl:variable>

<xsl:variable name="signature">
<div class="signature noprevnext">
<xsl:value-of select="/bridge:article/bridge:author"/>
(<a><xsl:attribute name="href">mailto:<xsl:value-of select="/bridge:article/bridge:author/@email"/></xsl:attribute>
<xsl:value-of select="/bridge:article/bridge:author/@email"/></a>),
<xsl:value-of select="$copyright"/><br/>
<xsl:copy-of select="$creationNote"/>
</div>
</xsl:variable>

<xsl:template name='htmltitle'>
<xsl:param name='title' value='"Default Title"'/>
<xsl:variable name="applied">
<xsl:apply-templates select="$title"/>
</xsl:variable>
<title><xsl:value-of select="$applied"/></title>
</xsl:template>

<xsl:template match="/">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<link rel="stylesheet" type="text/css" href="../article.css"/>
<meta name="keywords" content="contract bridge, humor, card games"/>
<xsl:copy-of select="$shortcuticon"/>
<xsl:call-template name='htmltitle'>
<xsl:with-param name='title' select='bridge:article/bridge:title'/>
</xsl:call-template>
<!--<title><xsl:apply-templates select="bridge:article/bridge:title"/></title>-->
</head>
<body>
<div class="back">Back to <em><a href="../../">Thomas's Bridge Fantasia</a></em></div>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="bridge:article">
<div class="body">
<xsl:apply-templates select="bridge:title"/>
<xsl:apply-templates select="bridge:body"/> 
</div>
<xsl:copy-of select="$signature"/>
</xsl:template>

</xsl:stylesheet>
