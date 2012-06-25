<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="/exist/tullio/golden.css" />
        
      </head>
      <body>
        
        <h1>Types d'événéments - Evenementtypes</h1>
        <!-- 
        <xsl:apply-templates select="//event" mode="contents">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        -->
        <table>
        <xsl:apply-templates select="//event">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="event">
    <tr>
      <td><xsl:value-of select="@id"/></td>
      <td class="cell-F">
        <h3><xsl:value-of select="name[@lang='fr']"/></h3>
        
        <xsl:choose>
          <xsl:when test="string(description[@lang='fr'])">
            <p><xsl:value-of select="description[@lang='fr']"/></p>
          </xsl:when>
        </xsl:choose>
        
      </td>
      <td class="cell-N">
        <h3><xsl:value-of select="name[@lang='nl']"/></h3>
        <xsl:choose>
          <xsl:when test="string(description[@lang='nl'])">
            <p><xsl:value-of select="description[@lang='nl']"/></p>
          </xsl:when>
        </xsl:choose>
      </td>  
    </tr>
    
    
    
    
  </xsl:template>
  
  

</xsl:stylesheet>
