<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
                exclude-result-prefixes="trans bridge">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->

<xsl:variable name="translations" select="document('translations.xml')/trans:table"/>

<!-- Constant suit symbols -->
<xsl:variable name="sym.spade">
    <xsl:call-template name="suitsym">
        <xsl:with-param name="letter" select="'S'"/>
    </xsl:call-template>
</xsl:variable>

<xsl:variable name="sym.heart">
    <xsl:call-template name="suitsym">
        <xsl:with-param name="letter" select="'H'"/>
    </xsl:call-template>
</xsl:variable>

<xsl:variable name="sym.diamond">
    <xsl:call-template name="suitsym">
        <xsl:with-param name="letter" select="'D'"/>
    </xsl:call-template>
</xsl:variable>

<xsl:variable name="sym.club">
    <xsl:call-template name="suitsym">
        <xsl:with-param name="letter" select="'C'"/>
    </xsl:call-template>
</xsl:variable>

<!-- Routine to generate a suit symbol from a suit letter (S,H,D,C,N.) -->
<!-- Uses the translation file trans:denom elements.                   -->
<!-- If you want to use gif images rather than text, you can change
        this routine.                                                  -->
<xsl:template name="suitsym">
<xsl:param name="letter"/>
<xsl:variable name="color" select="$translations/trans:denom[@id=$letter]/@color"/>
<xsl:variable name="symbol" select="$translations/trans:denom[@id=$letter]/@symbol"/>
<span>
<xsl:attribute name="class"><xsl:value-of select="concat($color,'suit')"/></xsl:attribute>
<xsl:value-of select="$symbol"/>
</span>
</xsl:template>

<!-- Suit and notrump tags -->
<xsl:template match="bridge:notrump">
    <xsl:call-template name="suit">
        <xsl:with-param name="symbol">NT</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="bridge:club">
    <xsl:call-template name="suit">
        <xsl:with-param name="symbol" select="$sym.club"/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="bridge:diamond">
    <xsl:call-template name="suit">
        <xsl:with-param name="symbol" select="$sym.diamond"/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="bridge:heart">
    <xsl:call-template name="suit">
        <xsl:with-param name="symbol" select="$sym.heart"/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="bridge:spade">
    <xsl:call-template name="suit">
        <xsl:with-param name="symbol" select="$sym.spade"/>
    </xsl:call-template>
</xsl:template>

<!-- Handling the card tag -->
<xsl:template match="bridge:card">
<xsl:call-template name="holding">
<xsl:with-param name="symbol">
<xsl:call-template name="suitsym">
<xsl:with-param name="letter" select="substring(@code,1,1)"/>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="attr" select="substring(@code,2,1)"/>
</xsl:call-template>
</xsl:template>

<!--    Handling the holding tag    -->
<!--    <holding cards="AQJT"/>     -->
<!--    <holding cards="S:AJ"/>     -->
<xsl:template match="bridge:holding">
<xsl:variable name="suit" select="substring-before(@cards,':')"/>
<xsl:choose>
<xsl:when test="$suit">

<xsl:call-template name="holding">
<xsl:with-param name="attr" select="substring-after(@cards,':')"/>

<xsl:with-param name="symbol">
<xsl:call-template name="suitsym">
<xsl:with-param name="letter" select="substring-before(@cards,':')"/>
</xsl:call-template>

</xsl:with-param>

<xsl:with-param name="separator" select="'-'"/>

</xsl:call-template>

</xsl:when>

<xsl:otherwise>
<xsl:call-template name="holding">
<xsl:with-param name="attr" select="@cards"/>
<xsl:with-param name="separator" select="'-'"/>
</xsl:call-template>
</xsl:otherwise>

</xsl:choose>
</xsl:template>

<!-- This template handles the common logic for <spade>, <heart>,
    <diamond>, <club>, and <notrump> tags                           -->
<xsl:template name="suit">
<xsl:param name="symbol"/>
<xsl:choose>
<xsl:when test="@bid">
<span class="bid">
<xsl:value-of select="@bid"/>
<xsl:text> </xsl:text>
<xsl:copy-of select="$symbol"/></span>
</xsl:when>
<xsl:when test="@card">
<xsl:call-template name="holding">
<xsl:with-param name="attr" select="@card"/>
<xsl:with-param name="symbol" select="$symbol"/>
<xsl:with-param name="separator" select="'-'"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="@cards">
<xsl:call-template name="holding">
<xsl:with-param name="attr" select="@cards"/>
<xsl:with-param name="symbol" select="$symbol"/>
<xsl:with-param name="separator" select="'-'"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:copy-of select="$symbol"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- This template handles the common logic for all holdings.   -->
<!-- Single cards are formatted as a holding of one card.       -->
<xsl:template name="holding">
<xsl:param name="elt"/>
<xsl:param name="attr"/>
<xsl:param name="symbol"/>
<xsl:param name="separator"><xsl:text> </xsl:text></xsl:param>
<span class="holding">
<xsl:if test="$symbol">
<xsl:copy-of select="$symbol"/><xsl:text> </xsl:text>
</xsl:if>
<xsl:choose>
<xsl:when test="string($elt)"><xsl:apply-templates select="$elt"/></xsl:when>
<xsl:when test="string($attr)"><xsl:call-template name="complex-holding">
<xsl:with-param name="current" select="$attr"/>
<xsl:with-param name="separator" select="$separator"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>&#x2014;</xsl:otherwise>
</xsl:choose>
</span>
</xsl:template>

<!-- Recursive part of holdings -->
<xsl:template name="complex-holding">
<xsl:param name="current"/>
<xsl:param name="separator"><xsl:text> </xsl:text></xsl:param>
<xsl:param name="depth" select="0"/>
    <xsl:choose>
    <xsl:when test="''=$current"></xsl:when>
    <xsl:when test="substring($current,1,1)='^'">
	<span class="played"><xsl:call-template name="card">
	   <xsl:with-param name="card" select="substring($current,2,1)"/>
	   <xsl:with-param name="separator" select="$separator"/>
	   <xsl:with-param name="depth" select="$depth"/>
	</xsl:call-template></span><xsl:call-template name="complex-holding">
            <xsl:with-param name="current"
                 select="substring($current,3)"/>
	    <xsl:with-param name="separator" select="$separator"/>
	    <xsl:with-param name="depth" select="$depth+1"/>
	</xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
    <xsl:call-template name="card">
       <xsl:with-param name="card" select="substring($current,1,1)"/>
       <xsl:with-param name="separator" select="$separator"/>
       <xsl:with-param name="depth" select="$depth"/>
    </xsl:call-template>
    <xsl:call-template name="complex-holding">
	<xsl:with-param name="current" select="substring($current,2)"/>
	<xsl:with-param name="separator" select="$separator"/>
        <xsl:with-param name="depth" select="$depth+1"/>
    </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Add a single card to a holding - seperator is used if depth
     is greater than 0.                                             -->
<xsl:template name="card">
<xsl:param name="card"/>
<xsl:param name="depth" select="0"/>
<xsl:param name="separator"><xsl:text> </xsl:text></xsl:param>
<xsl:if test="$depth&gt;0">
<xsl:value-of select="$separator"/>
</xsl:if>
<xsl:variable name="trans" select="$translations/trans:card[@id=$card]"/>
<xsl:choose>
<xsl:when test="$trans/@short">
<xsl:value-of select="$trans/@short"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$card"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- Handling hands which are inlined -->
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

<xsl:template name="inlinecontract">
<xsl:param name="code"/>
<xsl:variable name="level" select="substring(@code,1,1)"/>
<xsl:variable name="denom" select="substring(@code,2,1)"/>
<xsl:variable name="rest" select="substring(@code,3)"/>
<xsl:variable name="symbol">
<xsl:call-template name="suitsym">
<xsl:with-param name="letter" select="$denom"/>
</xsl:call-template>
</xsl:variable>
<span class="contract">
<xsl:value-of select="$level"/>
<xsl:text> </xsl:text>
<xsl:copy-of select="$symbol"/>
<xsl:if test="$rest">
<xsl:text> </xsl:text>
<xsl:value-of select="$translations/trans:call[@id=$rest]/trans:context[@id='contract'][1]"/>
</xsl:if>
<xsl:if test="@declarer">
<xsl:text> by </xsl:text>
<xsl:value-of select="$translations/trans:seatname[(current()/@declarer)=@id][1]/@ucase"/>
</xsl:if>
</span>
</xsl:template>

<xsl:template match="bridge:contract[@code]">
<xsl:call-template name="inlinecontract">
<xsl:with-param name="code" select="@code"/>
</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
