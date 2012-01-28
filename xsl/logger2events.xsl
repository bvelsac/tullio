<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
  <events>
    <xsl:apply-templates select="root/*[@nr &gt; 0][@committed='X']">
      <xsl:sort order="ascending" data-type="number" select="@nr"/>
    </xsl:apply-templates>
  </events>
</xsl:template>



<xsl:template match="*">
  <e>
    <xsl:apply-templates select="@*"></xsl:apply-templates>
    </e>
  </xsl:template>

<xsl:template match="@nr">
  <xsl:attribute name="n">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>
  
  <xsl:template match="@duration">
    <xsl:attribute name="length">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@clip">
    <xsl:attribute name="c">
      <xsl:choose>
        <xsl:when test="'true'">y</xsl:when>
        <xsl:otherwise>n</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@*">
    <xsl:if test="not(.='null')">
      <xsl:copy-of select="."/>  
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
