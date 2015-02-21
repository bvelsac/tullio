<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>
  <xsl:variable name="number" select="wrapper/@n"/>
  <xsl:template match="/">
    <wrapper>
      <xsl:apply-templates select="wrapper/*"/>
    </wrapper>
  </xsl:template>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:attribute name="c">
        <xsl:value-of select="$number"/>
      </xsl:attribute>
      <xsl:copy-of select="text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>