<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="lower">0</xsl:param>
<xsl:template match="/">
<events>
    <xsl:apply-templates select="root/*[@nr &gt; $lower][@committed='X']">
      <xsl:sort order="ascending" data-type="number" select="@nr"/>
    </xsl:apply-templates>
  </events>
</xsl:template>



<xsl:template match="*">
  <xsl:if test="@clip='true'">
    <e type="marker" n="{@nr * 2 - 1}" c="y">
      <xsl:copy-of select="@lang"/>
      <xsl:copy-of select="@time"/>
    </e>
  </xsl:if>
  <e>
    <xsl:apply-templates select="@*"></xsl:apply-templates>
    </e>
  </xsl:template>

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
</xsl:stylesheet>
