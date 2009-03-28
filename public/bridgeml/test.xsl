<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:check="http://www.thomasoandrews.com/xmlns/checklink"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
                exclude-result-prefixes="bridge check">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->
<!-- This file defines the handling of test documents, so that
     sections which look like:

         <test title="Verbose Auction">
         <testbody>
           <auction dealer="W">
             <call seat="W" code="P"/>
             <call seat="N" code="1S"/>
             <call seat="E" code="2H"/>
             <call seat="S" code="3C"/>
         
             <call seat="W" code="X"/>
             <call seat="N" code="XX"/>
             <call seat="E" code="P"/>
             <call seat="S" code="P"/>
         
             <call seat="W" code="P"/>
           </auction>
         </testbody>

     End up being duplicated into the HTML *and* processed as standard
     BridgeML so that the article includes both the output and the
     input.

     Also includes code for handling check-link calls
-->

<xsl:template name="textcopy">
<xsl:param name="string"/>
<xsl:choose>
<xsl:when test="contains($string,'&amp;')">
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-before($string,'&amp;')"/>
</xsl:call-template>
<xsl:text>&amp;amp;</xsl:text>
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-after($string,'&amp;')"/>
</xsl:call-template>
</xsl:when>

<xsl:when test="contains($string,'&lt;')">
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-before($string,'&lt;')"/>
</xsl:call-template>
<xsl:text>&amp;lt;</xsl:text>
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-after($string,'&lt;')"/>
</xsl:call-template>
</xsl:when>

<xsl:when test="contains($string,'&gt;')">
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-before($string,'&gt;')"/>
</xsl:call-template>

<xsl:text>&amp;gt;</xsl:text>
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-after($string,'&gt;')"/>
</xsl:call-template>
</xsl:when>

<xsl:when test="contains($string,'&gt;')">
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-before($string,'&gt;')"/>
</xsl:call-template>

<xsl:text>&amp;gt;</xsl:text>
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-after($string,'&gt;')"/>
</xsl:call-template>
</xsl:when>

<xsl:when test='contains($string,"&apos;")'>

<xsl:call-template name="textcopy">
<xsl:with-param name="string" select='substring-before($string,"&apos;")'/>
</xsl:call-template>

<xsl:text>&amp;apos;</xsl:text>

<xsl:call-template name="textcopy">
<xsl:with-param name="string" select='substring-after($string,"&apos;")'/>
</xsl:call-template>

</xsl:when>

<xsl:when test="contains($string,'&quot;')">

<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-before($string,'&quot;')"/>
</xsl:call-template>

<xsl:text>&amp;quot;</xsl:text>

<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="substring-after($string,'&quot;')"/>
</xsl:call-template>

</xsl:when>

<xsl:otherwise>
<xsl:value-of select="$string"/>
</xsl:otherwise>

</xsl:choose>

</xsl:template>

<xsl:template mode="test" match="@*">
<xsl:text> </xsl:text>
<xsl:value-of select="name()"/>
<xsl:text>="</xsl:text>
<xsl:call-template name="textcopy">
<xsl:with-param name="string" select="."/>
</xsl:call-template>
<xsl:text>"</xsl:text>
</xsl:template>

<xsl:template mode="test" match="*">
<xsl:variable name="children" select="*|text()"/>
<xsl:text>&lt;</xsl:text>
<xsl:value-of select="name()"/>
<xsl:apply-templates select="@*" mode="test"/>
<xsl:choose>
<xsl:when test="$children">
<xsl:text>&gt;</xsl:text>
<xsl:apply-templates select="$children" mode="test"/>
<xsl:text>&lt;/</xsl:text>
<xsl:value-of select="name()"/>
<xsl:text>&gt;</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>/&gt;</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="bridge:test">
<div class="test">
<xsl:if test="@title">
<h2><xsl:value-of select="@title"/></h2>
</xsl:if>
<xsl:apply-templates select="bridge:testbody|bridge:testnote"/>
</div>
</xsl:template>

<xsl:template match="bridge:testnote">
<div class="testnote"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="bridge:testbody">
Input:
<pre class="testcode"><xsl:apply-templates mode="test"/></pre>
XSL Output:
<div class="testoutput">
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template mode="test" match="text()">
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="check:articles">
<xsl:variable name="dir" select="@dir"/>

<xsl:variable name="table" select="document(concat('xml/',$dir,'/table.xml'))"/>

<xsl:for-each select="$table//bridge:article[@href]">

    <xsl:call-template name="articlelinks">
    <xsl:with-param name="article" select="@href"/>
    <xsl:with-param name="dir" select="$dir"/>
    </xsl:call-template>

</xsl:for-each>

</xsl:template>

<xsl:template match="check:article">
<xsl:variable name="file" select="@file"/>

<xsl:call-template name="articlelinks">
    <xsl:with-param name="article" select="$file"/>
    <xsl:with-param name="dir" select="'.'"/>
</xsl:call-template>

<xsl:call-template name="articlediagrams">
    <xsl:with-param name="article" select="$file"/>
    <xsl:with-param name="dir" select="'.'"/>
</xsl:call-template>

</xsl:template>


<xsl:template name="articlelinks">

<xsl:param name="article"/>
<xsl:param name="dir"/>

<xsl:variable name="articlefile" select="concat('xml/',$dir,'/',$article,'.xml')"/>
<xsl:variable name="doc" select="document($articlefile)"/>

<xsl:if test="$doc//bridge:source[@href]|$doc//bridge:link">
<dl>
<dt>In <xsl:value-of select="$dir"/>/<xsl:value-of select="$article"/>.html
    (<em><xsl:value-of select="$doc/bridge:article/bridge:title"/></em>):</dt>
  <xsl:for-each select="$doc//bridge:source[@href]">
<dd> From: <a href="{@href}"><xsl:apply-templates/></a></dd>
  </xsl:for-each>

  <xsl:for-each select="$doc//bridge:link[@external or @mypage]">
<dd> ... <xsl:apply-templates select="."/> ...</dd>
  </xsl:for-each>

  <xsl:for-each select="$doc//bridge:link[@internal]">
        <dd> ... <a href="../{$dir}/{@internal}.html"> 
<xsl:apply-templates/>
</a> ...</dd>
  </xsl:for-each>
</dl>
</xsl:if>
</xsl:template>

<xsl:template name="articlediagrams">

<xsl:param name="article"/>
<xsl:param name="dir"/>

<xsl:variable name="articlefile" select="concat('xml/',$dir,'/',$article,'.xml')"/>
<xsl:variable name="doc" select="document($articlefile)"/>

<xsl:for-each select="$doc//bridge:diagram">
<xsl:variable name="south" select="bridge:hand[@seat='S']"/>
<xsl:variable name="north" select="bridge:hand[@seat='N']"/>
<xsl:variable name="east" select="bridge:hand[@seat='E']"/>
<xsl:variable name="west" select="bridge:hand[@seat='W']"/>
<xsl:variable name="spades" select="bridge:hand/@sp"/>
<xsl:variable name="hearts" select="bridge:hand/@he"/>
<xsl:variable name="diamonds" select="bridge:hand/@di"/>
<xsl:variable name="clubs" select="bridge:hand/@cl"/>
<xsl:choose>
<xsl:when test="bridge:hand[string-length(translate(concat(@sp,@he,@di,@cl),'^',''))>13]">
<dl>
<dt>In <xsl:value-of select="$dir"/>/<xsl:value-of select="$article"/>.html
    (<em><xsl:value-of select="$doc/bridge:article/bridge:title"/></em>):</dt>
<dd>Error - hand has more than thirteen cards.</dd>
<dd><xsl:apply-templates select="."/></dd>
</dl>
</xsl:when>

<xsl:when test="string-length(translate($spades,'^',''))>13">
<dt>In <xsl:value-of select="$dir"/>/<xsl:value-of select="$article"/>.html
    (<em><xsl:value-of select="$doc/bridge:article/bridge:title"/></em>):</dt>
<dd>Error - more than 13 spades.</dd>
<dd><xsl:apply-templates select="."/></dd>
</xsl:when>

<xsl:when test="string-length(translate($hearts,'^',''))>13">
<dt>In <xsl:value-of select="$dir"/>/<xsl:value-of select="$article"/>.html
    (<em><xsl:value-of select="$doc/bridge:article/bridge:title"/></em>):</dt>
<dd>Error - more than 13 hearts.</dd>
<dd><xsl:apply-templates select="."/></dd>
</xsl:when>

<xsl:when test="string-length(translate($diamonds,'^',''))>13">
<dt>In <xsl:value-of select="$dir"/>/<xsl:value-of select="$article"/>.html
    (<em><xsl:value-of select="$doc/bridge:article/bridge:title"/></em>):</dt>
<dd>Error - more than 13 diamonds.</dd>
<dd><xsl:apply-templates select="."/></dd>
</xsl:when>

<xsl:when test="string-length(translate($clubs,'^',''))>13">
<dt>In <xsl:value-of select="$dir"/>/<xsl:value-of select="$article"/>.html
    (<em><xsl:value-of select="$doc/bridge:article/bridge:title"/></em>):</dt>
<dd>Error - more than 13 clubs.</dd>
<dd><xsl:apply-templates select="."/></dd>
</xsl:when>

</xsl:choose>

</xsl:for-each>

</xsl:template>

</xsl:stylesheet>
