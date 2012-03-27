<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="node()|@*">
    <!-- Copy the current node -->
    <xsl:copy>
      <!-- Including any attributes it has and any child nodes -->
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="p">
    <xsl:copy>
    
    <xsl:attribute name="d">init</xsl:attribute>
    <xsl:apply-templates select="@*|node()" ></xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
