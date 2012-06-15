<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:template match="/">
    <xmlData>
      <xsl:apply-templates select="events/e">
        <xsl:sort order="descending" select="time"/>
      </xsl:apply-templates>
    </xmlData>
  </xsl:template>
  <xsl:template match="e">
    <xsl:copy-of select=".">
    </xsl:copy-of>
  </xsl:template>

</xsl:stylesheet>
