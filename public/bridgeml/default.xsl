<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
                exclude-result-prefixes="bridge">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->

<!-- Code to handle non-bridge tags - structures, headers, titles, etc -->
<xsl:template match="bridge:title">
<h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="bridge:a[@href]">
<a target="_top"><xsl:attribute name="href">
<xsl:value-of select="@href"/>
</xsl:attribute><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="bridge:chapter">
<h3><xsl:value-of select="bridge:title"/></h3>
<xsl:apply-templates select="bridge:article"/>
</xsl:template>

<xsl:template match="bridge:h2">
<h3><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match="bridge:h3">
<h4><xsl:apply-templates/></h4>
</xsl:template>

<xsl:template match="bridge:a[@name]">
<a><xsl:attribute name="name">
<xsl:value-of select="@name"/>
</xsl:attribute><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="bridge:body">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="bridge:p[not(@class)]">
<div class="paragraph">
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="bridge:br">
<br class="dummy"/>
</xsl:template>


<xsl:template match="*">
<xsl:choose>
<xsl:when test="namespace-uri()='http://www.thomasoandrews.com/xmlns/bridge'">
<xsl:element name="{local-name()}">
<xsl:for-each select="@*">
<xsl:copy/>
</xsl:for-each>
<xsl:apply-templates/>
</xsl:element>
</xsl:when>
<xsl:when test="namespace-uri()='http://www.w3.org/TR/REC-html40'">
<xsl:element name="{local-name()}">
<xsl:for-each select="@*">
<xsl:copy/>
</xsl:for-each>
<xsl:apply-templates/>
</xsl:element>
</xsl:when>
<xsl:otherwise>
<xsl:copy><xsl:apply-templates/></xsl:copy>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
