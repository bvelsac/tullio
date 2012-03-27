<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    
    
    <root>
      
      <xsl:apply-templates></xsl:apply-templates>
    </root>
  </xsl:template>
  <xsl:template match="row">
    <entry>
      
      
      <xsl:apply-templates></xsl:apply-templates>
    </entry>
    
    
  </xsl:template>
  <xsl:template match="col_type[.='P.E.CONS-INOVERW']">
    
    
    flauwe zever
  </xsl:template>
  

</xsl:stylesheet>
