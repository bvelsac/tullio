<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="type">1C</xsl:param>
  
  <xsl:key match="//doc/p[not(@d='init')]" name="text" use="@c"/>
  <xsl:key match="//trans/p[not(@d='init')]" name="trans" use="@c"/>
  
<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$type='1C'">
      <div>
        <xsl:apply-templates select="all/events/e[@c='y']" mode="continu"></xsl:apply-templates>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <table>
        <xsl:apply-templates select="all/events/e[@c='y']" mode="complete"></xsl:apply-templates>
      </table>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>
  
  <xsl:template match="e" mode="complete">
    <tr>
      <td>
        <!-- this column should always be Dutch -->
        <xsl:choose>
          <xsl:when test="e/@lang='N'">
            <xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <i>
            <xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
            </i>
          </xsl:otherwise>
        </xsl:choose>
        
        
      </td>
      
      
    </tr>
    
    
    
    
    
  </xsl:template>
  
  
  
</xsl:stylesheet>
