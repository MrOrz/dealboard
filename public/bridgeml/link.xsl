<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
                exclude-result-prefixes="trans bridge">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->

<xsl:variable name="mytop">../../..</xsl:variable>

<xsl:template match="bridge:link[@mypage]">
<a target="_top" href="{$mytop}{@mypage}">
<xsl:apply-templates/>
</a>
</xsl:template>

<xsl:template match="bridge:link[@external]">
<a target="_top">
<xsl:attribute name="href"><xsl:value-of select="@external"/></xsl:attribute>
<xsl:apply-templates/>
</a>
</xsl:template>

<xsl:template match="bridge:link[@internal]">
<a target="display">
<xsl:attribute name="href"><xsl:value-of select="concat(@internal,'.html')"/></xsl:attribute>
<xsl:apply-templates/>
</a>
</xsl:template>


</xsl:stylesheet>

