<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
                exclude-result-prefixes="trans bridge">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->

<xsl:template match="bridge:handlist">
<table>
<tr>
<xsl:for-each select="bridge:hand">
<td><xsl:apply-templates select="."/></td>
</xsl:for-each>
</tr>
</table>
</xsl:template>

<xsl:template match="bridge:hand[parent::bridge:p or @type='inline']">
<span class="inlinehand"><xsl:call-template name="holding">
<xsl:with-param name="attr" select="@sp"/>
<xsl:with-param name="symbol" select="$sym.spade"/>
<xsl:with-param name="separator" select="'-'"/>
</xsl:call-template>
<xsl:text> </xsl:text><xsl:call-template name="holding">
<xsl:with-param name="attr" select="@he"/>
<xsl:with-param name="symbol" select="$sym.heart"/>
<xsl:with-param name="separator" select="'-'"/>
</xsl:call-template>
<xsl:text> </xsl:text><xsl:call-template name="holding">
<xsl:with-param name="attr" select="@di"/>
<xsl:with-param name="symbol" select="$sym.diamond"/>
<xsl:with-param name="separator" select="'-'"/>
</xsl:call-template>
<xsl:text> </xsl:text><xsl:call-template name="holding">
<xsl:with-param name="attr" select="@cl"/>
<xsl:with-param name="symbol" select="$sym.club"/>
<xsl:with-param name="separator" select="'-'"/>
</xsl:call-template><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="bridge:north|bridge:east|bridge:south|bridge:west|bridge:hand">
<table class="hand">
<xsl:if test="bridge:handhead">
<tr><td colspan="2"><div class="handheader"><xsl:apply-templates select="bridge:handhead"/></div></td></tr>
</xsl:if>

<xsl:if test="bridge:sp|@sp">
<tr><td align="center"><xsl:copy-of select="$sym.spade"/></td><td><xsl:call-template name="holding">
	<xsl:with-param name="elt" select="bridge:sp"/>
	<xsl:with-param name="attr" select="@sp"/>
   </xsl:call-template></td></tr>
</xsl:if>

<xsl:if test="bridge:he|@he">
<tr><td align="center"><xsl:copy-of select="$sym.heart"/></td>
    <td><xsl:call-template name="holding">
	<xsl:with-param name="elt" select="bridge:he"/>
	<xsl:with-param name="attr" select="@he"/>
   </xsl:call-template></td></tr>
</xsl:if>

<xsl:if test="bridge:di|@di">
<tr><td align="center"><xsl:copy-of select="$sym.diamond"/></td>
   <td><xsl:call-template name="holding">
	<xsl:with-param name="elt" select="bridge:di"/>
	<xsl:with-param name="attr" select="@di"/>
   </xsl:call-template></td></tr>
</xsl:if>

<xsl:if test="bridge:cl|@cl">
<tr><td align="center"><xsl:copy-of select="$sym.club"/></td>
   <td><xsl:call-template name="holding">
	<xsl:with-param name="elt" select="bridge:cl"/>
	<xsl:with-param name="attr" select="@cl"/>
   </xsl:call-template></td></tr>
</xsl:if>
</table>

</xsl:template>

</xsl:stylesheet>
