<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
  <!-- Events should be ordered -->
  
    <table id="statusTable"> 
      <xsl:for-each select="events/e[@c='y']">
        
        <xsl:variable name="status-orig">
          <xsl:choose>
            <xsl:when test="string(@status-orig)">
              <xsl:value-of select="@status-orig"/>
            </xsl:when>
            <xsl:otherwise>N</xsl:otherwise>
          </xsl:choose>
          
        </xsl:variable>
        
        <xsl:variable name="status-trans">
          <xsl:choose>
            <xsl:when test="string(@status-trans)">
              <xsl:value-of select="@status-trans"/>
            </xsl:when>
            <xsl:otherwise>N</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <tr id="{@n}">
          <td class="n"><xsl:value-of select="@n"/></td>
          <td class="start"><xsl:value-of select="@time"/></td>
          <td class="length">&#160;</td>
          
          <td class="status-orig {concat($status-orig, @lang)}"><xsl:value-of select="$status-orig"/></td>
          <td class="lang-orig"><xsl:value-of select="@lang"/></td>
          <td class="icon-orig">&#160;</td>
          <td class="lock-orig">&#160;</td>
          <td class="spacer">&#160;</td>
          <xsl:variable name="langTrans">
            <xsl:choose>
              <xsl:when test="@lang='M'">M</xsl:when>
              <xsl:when test="@lang='F'">N</xsl:when>
              <xsl:when test="@lang='N'">F</xsl:when>
          
              </xsl:choose>
          </xsl:variable>
          
          
          <td class="status-trans {concat($status-trans, $langTrans)}">
            <xsl:value-of select="$status-trans"/>
          </td>
          
          <td class="lang-trans {$langTrans}"> 
            <xsl:value-of select="$langTrans"/></td>
          <td class="icon-trans">&#160;</td>
          <td class="lock-trans">&#160;</td>
        </tr>  
       </xsl:for-each>
    </table>
  
   </xsl:template>
  </xsl:stylesheet>
