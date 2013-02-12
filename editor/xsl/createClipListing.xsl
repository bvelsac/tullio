<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  
  <xsl:template match="/">
    <div id="prepare">
    <div class="clipstatus-orig">
      <xsl:apply-templates select="//e" mode="orig"></xsl:apply-templates>
      
    </div>
    <div class="clipstatus-trans">
      <xsl:apply-templates select="//e" mode="trans"></xsl:apply-templates>
    
    </div>
    </div>
  </xsl:template>
  
  <xsl:template match="e" mode="orig">
    <div class="stat-N lang-{@lang}  n{@n}">
      <span class="n"><xsl:value-of select="@n"/></span>
      <span class="code">N</span>
      <span class="lang"><xsl:value-of select="@lang"/></span>
      <span class="lockid">--</span>
    </div>
  </xsl:template>
  
  <xsl:template match="e" mode="trans">
    <xsl:variable name="lang">
      <xsl:choose>
        <xsl:when test="@lang='F'">
          <xsl:text>N</xsl:text>
        </xsl:when>
        <xsl:when test="@lang='N'">
          <xsl:text>F</xsl:text>
        </xsl:when>
        
        <xsl:otherwise>M</xsl:otherwise>
      </xsl:choose>
      
      
    </xsl:variable>
    <div class="stat-N lang-{$lang} n{@n}">
      <span class="n"><xsl:value-of select="@n"/></span>
      <span class="code">N</span>
      <span class="lang"><xsl:value-of select="$lang"/></span>
      <span class="lockid">--</span>
    </div>
  </xsl:template>
  

</xsl:stylesheet>
