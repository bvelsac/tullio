<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
   
<xsl:include href="group.xsl"/>
    
      <xsl:output indent="yes"/>
  <xsl:key name="clip" match="//e" use="@clip"/>
  
  <!-- Chrome heeft een issue waardoor de document() functie niet werkt, dus alles moet worden toegevoegd aan het input-document -->
  <!-- Volgende declaratie werkt dus NIET:
  <xsl:variable name="conf" select="document('/exist/tullio/xml/titles.xml')" >
  </xsl:variable>
  -->
  
  <xsl:template match="/">
      <doc>
			<p c="0">Begin tekst</p>
            <xsl:for-each select="//e[@c='y']">
              
              <xsl:apply-templates select="key('clip', @n)" mode="initialize-text"></xsl:apply-templates>
              </xsl:for-each>
      </doc>  
  </xsl:template>
    
</xsl:stylesheet>