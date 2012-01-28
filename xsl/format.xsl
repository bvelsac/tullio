<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="pres"></xsl:param>
  <xsl:param name="l"></xsl:param>
  <xsl:param name="proc-type"></xsl:param>
  
  
  <xsl:template   mode="initialize-text" match="e[@type='OUV-OPE']">
    <p c="{@clip}">Integraal verslag</p>
    <p c="{@clip}">Plenaire vergadering van <span class="incomplete">DATUM</span></p>
    <p c="{@clip}">
      <span class="incomplete">(Ochtendvergadering/Namiddagvergadering)</span>
    </p>
  </xsl:template>
  
  <xsl:template match="e[@type='QA-AV']"   mode="initialize-text">
    
    <xsl:variable name="speaker" select="@speaker"></xsl:variable>
    <xsl:variable name="gov" select="@props"></xsl:variable>
    <!-- 
    <xsl:value-of select="$speaker"/>
    <xsl:value-of select="$conf"/>
    -->
    <p  c="{@clip}">
      <xsl:text>Dringende vraag van </xsl:text> 
      <xsl:choose>
        <!--  test="$conf//p[@code=$speaker]/gender='M'" -->
        <xsl:when test="true()">
          de heer
        </xsl:when>
        <xsl:otherwise>mevrouw</xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      
      <xsl:value-of select="$conf//p[@code=$speaker]/name"/>
      <xsl:text> aan </xsl:text>
    </p>
    <p c="{@clip}">
      <xsl:choose>
        <xsl:when test="$conf//p[@code=$gov]/gender='M'">
          de heer
        </xsl:when>
        <xsl:otherwise>mevrouw</xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$conf//p[@code=$gov]/name"/>
      <xsl:text>, </xsl:text>
      <xsl:copy-of select="$conf//p[@code=$gov]/*"/>
      <xsl:value-of select="$conf//p[@code=$gov]/title[1]"/>
      
      <xsl:text>,</xsl:text></p> 
    
    <p c="{@clip}"><xsl:text>betreffende "</xsl:text>
      <xsl:value-of select="@notes"/>
      <xsl:text>".</xsl:text></p>
      
  </xsl:template>
  <xsl:template match="e[@type='EXC-AFW']"   mode="initialize-text">
    <p c="{@clip}">VERONTSCHULDIGD</p>
    <p c="{@clip}">
      <xsl:choose>
        <xsl:when test="preceding-sibling::row[col_type='GEN-ALG'][1]/col_speaker='M'">
          <xsl:text>De voorzitter.- </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Mevrouw de voorzitter.- </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>Verontschuldigen zich voor hun afwezigheid:</xsl:text>
    </p>
    <p c="{@clip}"><span class="incomplete">Lijst van afwezigen</span></p>
  </xsl:template>
  <xsl:template match="e[@type='']"   mode="initialize-text">
    
  </xsl:template>
  
  <xsl:template match="e"  mode="initialize-text">
    <p c="{@clip}">
      
        <xsl:text>[</xsl:text><xsl:value-of select="@clip"/><xsl:text>]</xsl:text>
      
  </p>
    <!-- 
    <xsl:copy-of select="preceding-sibling::*[1]"/>
    -->
  
  
  </xsl:template>
</xsl:stylesheet>
