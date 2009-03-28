<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
                exclude-result-prefixes="bridge trans">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->

<xsl:key name="diagram" match="bridge:diagram[@id]" use="@id"/>

<xsl:template match="bridge:dealer">
<div class="dealer"><xsl:apply-templates/> Deals</div>
</xsl:template>

<xsl:template match="bridge:vul">
<xsl:variable name="vulstring" select="string(.)"/>
<div class="vul">
<xsl:choose>
<xsl:when test="$translations/trans:vul[@id=$vulstring]">
<xsl:value-of select="$translations/trans:vul[@id=$vulstring]"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates/>
</xsl:otherwise>
</xsl:choose>
Vul
</div>
</xsl:template>

<xsl:template match="bridge:scoring">
<div class="scoring"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="bridge:source[@href]">
<div class="source">From: <a href="{@href}" target="_top"><xsl:apply-templates/></a></div>
</xsl:template>

<xsl:template match="bridge:source">
<div class="source">From: <xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="bridge:author"></xsl:template>

<xsl:template match="bridge:programdata">
</xsl:template>

<xsl:template match="bridge:diagram[@copyid]">
<xsl:apply-templates select="key('diagram',@copyid)"/>
</xsl:template>

<xsl:template match="bridge:diagram[@src]">
<xsl:choose>
<xsl:when test="starts-with(@src,'#')">
<xsl:apply-templates select="key('diagram',substring-after(@src,'#'))"/>
</xsl:when>
<xsl:when test="contains(@src,'#')">
<xsl:variable name="doc" select="document(substring-before(@src,'#'))"/>
<xsl:variable name="id" select="substring-after(@src,'#')"/>
<xsl:apply-templates select="$doc//bridge:diagram[@id=$id][position()=1]"/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="doc" select="document(string(@src))"/>
<xsl:apply-templates select="$doc//bridge:diagram[position()=1]"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="bridge:diagram">
<xsl:variable name="hasheader" select="boolean(bridge:header)"/>
<xsl:variable name="width">
<xsl:choose>
<xsl:otherwise>
<xsl:text>10</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="class">
<xsl:choose>
<xsl:when test="$hasheader">
<xsl:text>dealwithheader</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>deal</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<table class="{$class}">
<colgroup span="10" width="{$width}%"/>
<tr class="north">
<xsl:choose>

<xsl:when test="$hasheader">
  <td colspan="3" valign="top" class="diagramheader"><xsl:apply-templates select="bridge:header"/></td>
</xsl:when>

<xsl:otherwise>
  <td valign="bottom" colspan="3"></td>
</xsl:otherwise>

</xsl:choose>

<td valign="bottom" colspan="4" class="north"><xsl:apply-templates select="bridge:hand[@seat='N']"/></td>
<td colspan="3"/>
</tr><tr class="eastwest">
<td align="left" colspan="4" class="west"><xsl:apply-templates select="bridge:hand[@seat='W']"/></td>
<td colspan="2">&#160;</td> <!-- added to ensure some space in north/south diagrams -->
<td align="left" colspan="4" class="east"><xsl:apply-templates select="bridge:hand[@seat='E']"/></td>
</tr><tr class="south">
<td valign="bottom" colspan="3"><xsl:apply-templates select="bridge:contract|bridge:lead"/></td>
<td valign="top" colspan="4" class="south"><xsl:apply-templates select="bridge:hand[@seat='S']"/></td>
<td colspan="3"/>
</tr>
</table>
<xsl:apply-templates select="bridge:auction"/>
</xsl:template>


<xsl:template match="bridge:diagram/bridge:header">
<div class="diagheader">
<xsl:apply-templates/>
</div>
</xsl:template>

</xsl:stylesheet>
