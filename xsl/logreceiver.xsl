<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="lower">1</xsl:param>
  <xsl:output indent="yes"/>
  <xsl:template match="/">
    <xmlData>
      <success>true</success>
      <events>
        <xsl:apply-templates select="/records/e[position()=last()][commit='P']">
          <xsl:with-param name="counter" select="$lower"/>
        </xsl:apply-templates>
      </events>
      <debug><xsl:copy-of select="."/></debug>
    </xmlData>
    <!--
  <events>
    <xsl:apply-templates select="root/*[@nr &gt; $lower][@committed='P']">
      
    </xsl:apply-templates>
  </events> -->
  </xsl:template>
  <xsl:template match="e[commit='P']">
    <!-- F-event can have an id but should not yet be stored as it will be submitted again when its length is defined -->
    
    <xsl:param name="counter"/>
    <xsl:param name="inheritedLang" select="lang"/>
    
    <xsl:variable name="langSelection">
      <xsl:choose>
        <xsl:when test="string(lang)">
          <xsl:value-of select="lang"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$inheritedLang"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>
    
    
  <xsl:if test="c='true'">
    <e type="marker" n="{$counter * 2 - 1}" c="true">
      <xsl:attribute name="lang"><xsl:value-of select="$langSelection"/></xsl:attribute>
      <xsl:attribute name="time"><xsl:value-of select="time"/></xsl:attribute>
      <xsl:attribute name="length"><xsl:value-of select="length"/></xsl:attribute>
      <xsl:attribute name="commit">P</xsl:attribute>
    </e>
  </xsl:if>
  
    <e>
      <xsl:attribute name="n">
        <xsl:value-of select="$counter * 2"/>
      </xsl:attribute>
      <xsl:attribute name="lang">
        <xsl:value-of select="$langSelection"/>
      </xsl:attribute>
      <xsl:apply-templates select="*"></xsl:apply-templates>
      
    </e>
    <xsl:apply-templates select="preceding-sibling::e[1]">
      <xsl:with-param name="counter" select="$counter + 1"/>
      <xsl:with-param name="inheritedLang" select="$langSelection"></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="n"></xsl:template>

  <xsl:template match="lang"></xsl:template>
  
  <xsl:template match="c">
    <xsl:attribute name="c">false</xsl:attribute>
   </xsl:template>
  
  <xsl:template match="*">
  
  <xsl:attribute name="{name()}">
  <xsl:value-of select="."/>
  </xsl:attribute>
  
  </xsl:template>
  <!-- 
  <xsl:template match="@nr">
    <xsl:attribute name="n">
      <xsl:value-of select=". * 2"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="@duration">
    <xsl:attribute name="length">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="@clip">
    <xsl:attribute name="c">n</xsl:attribute>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:if test="not(.='null')">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  -->
</xsl:stylesheet>
