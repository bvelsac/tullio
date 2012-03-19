<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    <doc>
      <xsl:for-each select="events/e[@c='y']">
        <p c="{@n}" class="init"></p>
      </xsl:for-each>
    </doc>
    
    
  </xsl:template>
</xsl:stylesheet>
