<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:trans="http://www.thomasoandrews.com/xmlns/bridge/trans"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:bridge="http://www.thomasoandrews.com/xmlns/bridge"
                xmlns:common="http://exslt.org/common"
                extension-element-prefixes="common"
                exclude-result-prefixes="trans bridge common">

<!-- Copyright 2002, Thomas Andrews, thomaso@best.com -->

<xsl:template name="call">
<xsl:param name="context"/>
<xsl:param name="code"/>
<xsl:variable name="callnode" select="$translations/trans:call[@id=$code]"/>
<span class="call">
<xsl:choose>

<xsl:when test="$callnode">
<xsl:value-of 
    select="$callnode/trans:context[@id=$context or @id='default'][position()=1]"/>
</xsl:when>

<xsl:otherwise>
<xsl:value-of select="number(substring(@code,1,1))"/>
<xsl:text> </xsl:text>
<xsl:call-template name="suitsym">
<xsl:with-param name="letter" select="substring(@code,2)"/>
</xsl:call-template>
</xsl:otherwise>

</xsl:choose>
</span>
</xsl:template>

<xsl:template name="addemptycalls">
<xsl:param name="callswithannotations"/>
<xsl:param name="column"/>
<xsl:param name="seatorder"/>
<xsl:param name="gap" select="0"/>

<xsl:copy-of select="$translations/trans:gaps/bridge:call[$gap>=position()]"/>
<xsl:variable name="colnumber" select="($column+$gap) mod 4"/>
<xsl:variable name="expectedseat" select="$seatorder[$colnumber+1]/@id"/>

<xsl:if test="$callswithannotations">
<xsl:variable name="nextitem" select="$callswithannotations[1]"/>
<xsl:variable name="rest" select="$callswithannotations[position()>1]"/>

<xsl:choose>

<xsl:when test="$callswithannotations[position()=last()][self::bridge:annotation]">

<xsl:call-template name="addemptycalls">
<xsl:with-param name="callswithannotations" 
	select="$callswithannotations[position()&lt;last()]"/>
<xsl:with-param name="column" select="$column"/>
<xsl:with-param name="seatorder" select="$seatorder"/>
<xsl:with-param name="gap" select="0"/>
</xsl:call-template>

<xsl:copy-of select="$callswithannotations[position()=last()]"/>

</xsl:when>

<xsl:when test="$nextitem/self::bridge:call[not(@seat) or (@seat=$expectedseat)]">
<xsl:copy-of select="$nextitem"/>
<xsl:call-template name="addemptycalls">
<xsl:with-param name="callswithannotations" select="$rest"/>
<xsl:with-param name="column" select="($colnumber+1) mod 4"/>
<xsl:with-param name="seatorder" select="$seatorder"/>
</xsl:call-template>
</xsl:when>

<xsl:when test="$nextitem/self::bridge:annotation">
<!-- End this row -->
<xsl:if test="$colnumber>0">
<xsl:copy-of select="$translations/trans:gaps/bridge:call[position()>$colnumber]"/>
</xsl:if>

<xsl:copy-of select="$nextitem"/>

<xsl:call-template name="addemptycalls">
<xsl:with-param name="callswithannotations" select="$rest"/>
<xsl:with-param name="column" select="$colnumber"/>
<xsl:with-param name="gap" select="$colnumber"/>
<xsl:with-param name="seatorder" select="$seatorder"/>
</xsl:call-template>
</xsl:when>

<xsl:otherwise>
<!-- Call with wrong seat for current column -->
<bridge:call code="_skip_"/>
<xsl:call-template name="addemptycalls">
<xsl:with-param name="callswithannotations" select="$callswithannotations"/>
<xsl:with-param name="column" select="($colnumber+1) mod 4"/>
<xsl:with-param name="gap" select="0"/>
<xsl:with-param name="seatorder" select="$seatorder"/>
</xsl:call-template>
</xsl:otherwise>

</xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template name="normalizecalls">
<xsl:param name="calls"/>

<xsl:variable name="callcount" select="count($calls[self::bridge:call])"/>
<xsl:variable name="realcount" select="count($calls[self::bridge:call and not(@code='_empty_')])"/>
<xsl:variable name="entrycount" select="count($calls)"/>

<xsl:choose>

<!-- 
     When the last element of the auction is an annotation, normalize
     all but last, and copy the annotation
 -->
<xsl:when test="$calls[position()=$entrycount][self::bridge:annotation]">

<xsl:variable name="previous">
<xsl:call-template name="normalizecalls">
<xsl:with-param name="calls" select="$calls[position()&lt;last()]"/>
</xsl:call-template>
</xsl:variable>

<xsl:copy-of select="$previous"/>

<xsl:variable name="callcolumn" 
	select="count(common:node-set($previous)/bridge:call) mod 4"/>

<xsl:if test="$callcolumn>0">
<xsl:copy-of select="$translations/trans:gaps/bridge:call[position()>$callcolumn]"/>
</xsl:if>

<xsl:copy-of select="$calls[position()=last()]"/>

</xsl:when>

<!-- When the auction is a passout auction, and there are no
     notes or comments in any of the bids -->
<xsl:when 
    test="($realcount=4) and not($calls[position()>last()-4][not(self::bridge:call) or @code!='P' or @comment or bridge:note])">

<xsl:copy-of select="$calls[last()>=position()+4]"/>
<xsl:copy-of select="$translations/trans:call[@id='_PO_']/bridge:call"/>

</xsl:when>

<!-- When there are less than four bids, or when the last three 
     bids are not unadorned passes, show all calls -->
<xsl:when
    test="($realcount&lt;4) or $calls[(position()> last() - 3) and (@code!='P' or @comment or bridge:note or self::bridge:annotation)]">
<xsl:copy-of select="$calls"/>
</xsl:when>

<!-- Now, we know that the last three calls are unadorned passes
     If the auction is length four and starts with a pass, then we
     want to show all calls -->
<xsl:when test="($calls[1][@code='P'][not(@comment) or not(bridge:note)]) and ($callcount=4)">
<xsl:copy-of select="$calls"/>
</xsl:when>


<!-- It ends with three passes - make sure that it is not a case
     where a bid out of turn caused the auction to revert -->
<xsl:when test="$calls[last()-3][@code='_skip_']">
<xsl:copy-of select="$calls"/>
</xsl:when>

<xsl:when test="$calls[last()-4][@code='_skip_'] and $calls[last()-3][@code='P']">
<xsl:copy-of select="$calls"/>
</xsl:when>

<xsl:when test="$calls[last()-5][@code='_skip_'] and $calls[last()-4][@code='P'] and $calls[last()-3][@code='P']">
<xsl:copy-of select="$calls"/>
</xsl:when>

   <!-- Ends with three unadorned passes, not a pass-out auction, then
     replace the last three calls with "All Pass" -->
<xsl:otherwise>
<xsl:copy-of select="($calls[position()&lt;$entrycount - 2])|($translations/trans:call[@id='_AP_']/bridge:call)"/>
</xsl:otherwise>

</xsl:choose>

</xsl:template>

<xsl:template name="auctioncall">
<xsl:param name="notecount"/>
<xsl:apply-templates select="."/>

<xsl:if test="bridge:note">
    <span class="footnotetag">
    <xsl:for-each select="bridge:note">
    <xsl:if test="position()&gt;1">
    <xsl:text>,</xsl:text>
    </xsl:if>

    <xsl:choose>

    <xsl:when test="@ref">
        <xsl:variable name="id" select="@ref"/>
        <xsl:variable name="realnote" 
            select="../preceding-sibling::bridge:call/bridge:note[$id=@id]"/>

        <xsl:call-template name="notetag">
        <xsl:with-param name="index" 
          select="1+count($realnote/preceding-sibling::bridge:note[not(@ref)]|$realnote/../preceding-sibling::bridge:call/bridge:note[not(@ref)])"/>
        <xsl:with-param name="count" select="$notecount"/>
        </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
        <xsl:call-template name="notetag">
        <xsl:with-param name="count" select="$notecount"/>
        <xsl:with-param name="index" 
            select="1+count(preceding-sibling::bridge:note[not(@ref)]|../preceding-sibling::bridge:call/bridge:note[not(@ref)])"/>
        </xsl:call-template>
    </xsl:otherwise>

    </xsl:choose>
    </xsl:for-each>
    </span>
</xsl:if>

</xsl:template>

<xsl:template match="bridge:call">
<xsl:call-template name="call">
<xsl:with-param name="context" select="@context"/>
<xsl:with-param name="code" select="@code"/>
</xsl:call-template>
<xsl:value-of select="@comment"/>
</xsl:template>

<xsl:template match="bridge:auction">
<xsl:variable name="dealer" 
    select="(@dealer|(bridge:call[1]/@seat)|$translations/trans:auctions/@defaultdealer)[1]"/>
<xsl:variable name="left" select="$translations/trans:leftmost[@dealer=$dealer]/@left"/>
<xsl:variable name="gap" select="$translations/trans:leftmost[@dealer=$dealer]/@gap"/>
<xsl:variable name="leftseat" select="$translations/trans:seats/trans:seat[@id=$left][1]"/>
<xsl:variable name="seats" select="$leftseat|($leftseat/following-sibling::trans:seat[4>position()])"/>
<xsl:variable name="show" select="@show"/>
<xsl:variable name="notes" select="bridge:call/bridge:note[not(@ref)]"/>
<xsl:variable name="notecount" select="count($notes)"/>
<xsl:variable name="callcount" select="count(bridge:call)"/>

<xsl:variable name="withemptycalls">
<xsl:call-template name="addemptycalls">
<xsl:with-param name="callswithannotations" select="bridge:call|bridge:annotation"/>
<xsl:with-param name="seatorder" select="$seats"/>
<xsl:with-param name="column" select="0"/>
<xsl:with-param name="gap" select="$gap"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="names" select="ancestor-or-self::*/bridge:name"/>

<!-- Outer table, containing bids and notes -->
<table class="auctionplusnotes">  
<colgroup span="4" width="25%"/>
<tr valign="top"><td>
<table class="auctiontable">  <!-- Includes bidding only -->
<!-- Headers row -->
<tr class="heading" valign="top">
    <xsl:for-each select="$seats">
    <xsl:variable name="code" select="@id"/>
        <td>
        <xsl:if test="not($show) or contains($show,$code)">
        <xsl:apply-templates select="$translations/trans:seatname[@id=$code]/@ucase"/>
        <xsl:if test="$names[@seat=$code]">
           <br/><xsl:apply-templates select="$names[@seat=$code][1]"/>
        </xsl:if>
        </xsl:if>
        </td>
    </xsl:for-each>
</tr>

<!-- end auction header -->

<xsl:variable name="normalized">
<xsl:call-template name="normalizecalls">
<xsl:with-param name="calls" select="common:node-set($withemptycalls)/*"/>
</xsl:call-template>
</xsl:variable>


<xsl:call-template name="auction">
<xsl:with-param name="gap" select="0"/>
<xsl:with-param name="notecount" select="$notecount"/>
<xsl:with-param name="calls" select="common:node-set($normalized)/*"/>
</xsl:call-template>
</table>
</td>

<!-- A column of the table for footnotes -->
<xsl:if test="$notes">
<td valign="bottom" class="notes">
<xsl:for-each select="$notes">
<div class="auctionnote">
<xsl:call-template name="note">
<xsl:with-param name="count" select="$notecount"/>
<xsl:with-param name="index" select="position()"/>
</xsl:call-template>
<xsl:apply-templates/>
</div>
</xsl:for-each>
</td>
</xsl:if>
</tr>
</table>
</xsl:template>

<xsl:template name="auction">
<xsl:param name="gap"/>
<xsl:param name="notecount"/>
<xsl:param name="calls"/>

<xsl:choose>
<xsl:when test="$calls[1]/self::bridge:annotation">
<tr><td colspan="4" class="auctionannotation">
<div>
<xsl:apply-templates select="$calls[1]"/>
</div>
</td></tr>

<xsl:call-template name="auction">
<xsl:with-param name="gap" select="$gap"/>
<xsl:with-param name="notecount" select="$notecount"/>
<xsl:with-param name="calls" select="$calls[position()>1]"/>
</xsl:call-template>

</xsl:when>

<xsl:otherwise>
<xsl:if test="count($calls)>0">
<tr>
<xsl:if test="$gap>0">
<td colspan="{$gap}"></td>
</xsl:if>
<xsl:for-each select="$calls[4>=$gap+position()]">
<td>
<xsl:call-template name="auctioncall">
<xsl:with-param name="notecount" select="$notecount"/>
</xsl:call-template>
</td>
</xsl:for-each>
</tr>

<xsl:call-template name="auction">
<xsl:with-param name="gap" select="0"/>
<xsl:with-param name="calls" select="$calls[$gap+position()>4]"/>
<xsl:with-param name="notecount" select="$notecount"/>
</xsl:call-template>
</xsl:if>

</xsl:otherwise>

</xsl:choose>

</xsl:template>

<xsl:template match="bridge:auction[@type='inline']">

<xsl:variable name="callsfrag">
<xsl:call-template name="normalizecalls">
<xsl:with-param name="calls" select="bridge:call|bridge:annotation"/>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="calls" select="common:node-set($callsfrag)/*"/>
<xsl:variable name="dealer" select="@dealer"/>
<xsl:variable name="show" select="@hands"/>
<xsl:variable name="sequence" select="($translations/trans:bidding[trans:case[@dealer=$dealer and $show=@hands]]|$translations/trans:bidding[@hands='all'])[position()=1]"/>

<span class="inlineauction">
<xsl:for-each select="$calls">
<xsl:variable name="index" select="((position()-1) mod 4)+1"/>
<xsl:variable name="code" select="@code"/>

<!-- seperator -->
<xsl:variable name="seperator">
<xsl:choose>
<!-- No seperator before first call -->
<xsl:when test="position()=1"></xsl:when> 

<!-- First call in a new round -->
<xsl:when test="$index=1">
<xsl:text>; </xsl:text>
</xsl:when>

<!-- Uses spaces in two-handed auctions -->
<xsl:when test="$show">
<xsl:text> </xsl:text>
</xsl:when>

<!-- Use hyphens in four-handed auctions -->
<xsl:otherwise><xsl:text> - </xsl:text></xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="showbid" select="$sequence/trans:showbid[$index]"/>

<!-- show the call -->
<xsl:choose>

<!-- Ignore All Pass -->
<xsl:when test="$code='_AP_'"></xsl:when>

<!-- If the seat's bid is always shown, show it -->
<xsl:when test="$showbid[not('optional'=@show)]">
<xsl:copy-of select="$seperator"/>
<xsl:call-template name="call">
<xsl:with-param name="code" select="$code"/>
<xsl:with-param name="context" select="'inline'"/>
</xsl:call-template>
<xsl:if test="@comment">
<span class="footnotetag"><xsl:value-of select="@comment"/></span>
</xsl:if>
</xsl:when>


<!-- If the seat's bids are optional, but the call is either the first
     call in the auction or the call is not "Pass," show it with
     parenthesis. -->
<xsl:when test="$showbid[@show='optional'] and (@comment or $code!='P' or position()=1)">
<span class="optionalcall"><xsl:copy-of select="$seperator"/><xsl:text>(</xsl:text>
<xsl:call-template name="call">
<xsl:with-param name="code" select="@code"/>
<xsl:with-param name="context" select="'inline'"/>
</xsl:call-template>
<xsl:text>)</xsl:text></span>
</xsl:when>

<!-- If the bid is not shown, but starts a new round _and_ there
     are non-passes later, then show the round seperator -->
<xsl:when test="$seperator='; ' and (following-sibling::bridge:call[@code!='P'])">
<xsl:copy-of select="$seperator"/>
</xsl:when>

</xsl:choose>
</xsl:for-each>
</span>
</xsl:template>

<xsl:template name="notetag">
<xsl:param name="count"/>
<xsl:param name="index"/>
<xsl:choose>
<xsl:when test="$count=1">
<xsl:text>*</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="number($index)"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="note">
<xsl:param name="count"/>
<xsl:param name="index"/>
<xsl:choose>
<xsl:when test="$count=1">
<xsl:text>*</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="number($index)"/><xsl:text>. </xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="bridge:name">
<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
