<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output encoding="UTF-8" method="html"/>
  <xsl:param name="numbering"></xsl:param>
  <xsl:param name="type"></xsl:param>
  <xsl:key match="/response/resultSet/events/e" name="events" use="@c"/>
  <xsl:key match="/response/resultSet/doc/p" name="text" use="@c"/>
  <xsl:key match="/response/resultSet/trans/p" name="trans" use="@c"/>
  
<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$type='1C'">
      <div>
        <xsl:apply-templates select="response/resultSet/events/e[@c='true']" mode="continu"></xsl:apply-templates>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <table>
        <xsl:apply-templates select="response/resultSet/events/e[@c='true']" mode="complete"></xsl:apply-templates>
      </table>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>
  
  
  
  <xsl:template match="e" mode="complete">
    <tr>
      <td style="width: 20px;"><span style="color:gray">[<xsl:value-of select="@n"/>] </span></td>
      
        <!-- this column should always be Dutch -->
  
        <xsl:choose>
          <xsl:when test="e/@lang='N'">
            <td>
            <xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
            </td>
            <td>
              <xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
            </td>
            
            
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
            </td>
            <td>
              <xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
            </td>
            
          </xsl:otherwise>
        </xsl:choose>
        
    </tr>
    
  </xsl:template>
  
  
  <!-- 
  title: alle tekst die rechtstreeks een event representeert, komt in principe nooit in cursief
  -->
  
  <xsl:template match="p | span">
    <xsl:copy>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="ancestor::trans and not(@title)">font-style: italic;</xsl:when>
          <xsl:otherwise>font-style: normal;</xsl:otherwise>
        </xsl:choose>  
        <xsl:if test="@title">font-weight:bold</xsl:if>
      </xsl:attribute>
      
      <xsl:apply-templates></xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="span/text()">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  
  <xsl:template match="translation//span[@class='speaker']">
    <xsl:copy>
      <xsl:attribute name="style">font-style: normal</xsl:attribute>
      
      <xsl:value-of select="substring-before(., '.-')"/>
      <xsl:text> </xsl:text>
    </xsl:copy>
    <span style="font-style: italic">
    <xsl:choose>
      <xsl:when test="key('events', parent::p/@clip)/@lang='F'">(in het Frans)</xsl:when>
      <xsl:otherwise>(en néerlandais)</xsl:otherwise>
    </xsl:choose>
      <xsl:text>.-</xsl:text>
    </span>
  </xsl:template>
  
  
  <xsl:template match="span[@class='langInd']">
    <xsl:copy>
      <xsl:attribute name="style">font-style: italic</xsl:attribute>
      <xsl:copy-of select="text()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>