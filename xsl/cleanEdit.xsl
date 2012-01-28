<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
     <!ENTITY ntilde  "&#241;" ><!-- small n, tilde -->
     <!ENTITY nbsp  "&#160;" ><!-- non breaking space -->
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
      <xsl:apply-templates></xsl:apply-templates>
     
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
