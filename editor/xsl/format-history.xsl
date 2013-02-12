<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="//s">
        <h2><xsl:value-of select="concat(//s[1]/@n, '-', //s[1]/@v)"/></h2>
        <table>
          <xsl:apply-templates/>
        
        </table>
        
      </xsl:when>
      <xsl:otherwise>
        <h2>No history</h2>
      </xsl:otherwise>
    </xsl:choose>
    

    <button type="button" id="close">Close</button>
    <button type="button" id="unlock">Force Unlock</button>
  </xsl:template>
  <xsl:template match="s">
    <tr>
      <td>
        <xsl:value-of select="@au"/>
      </td>
      <td>
        <xsl:value-of select="@val"/>
      </td>
      <td>
        <xsl:value-of select="substring-before(substring-after(@ts, 'T'), '.')"/>
      </td>
      <td>
        <xsl:value-of select="substring-before(@ts, 'T')"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
