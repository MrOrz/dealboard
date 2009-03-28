<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                exclude-result-prefixes="trans bridge">
<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->
<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

<xsl:include href="default.xsl"/>
<xsl:include href="auction.xsl"/>
<xsl:variable name="translations" select="document('translations.xml')/trans:table"/>

<xsl:template match="/">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<link rel="stylesheet" type="text/css" href="../article.css"/>
<meta name="keywords" content="contract bridge, humor, card games"/>
<title><xsl:value-of select="bridge:article/bridge:title"/></title>
</head>
<body>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="bridge:article">
<div class="body">
<xsl:apply-templates select="bridge:title"/>
<xsl:apply-templates select="bridge:body"/> 
</div>
</xsl:template>

</xsl:stylesheet>
