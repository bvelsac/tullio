<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="type">dcscd</xsl:param>
  <xsl:key match="/doc/events/e" name="events" use="@c"/>
  <xsl:key match="/doc/original/p" name="text" use="@c"/>
  <xsl:key match="/doc/translation/p" name="trans" use="@c"/>
  
<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$type='1C'">
      <div>
        <xsl:apply-templates select="all/events/e[@c='true']" mode="continu"></xsl:apply-templates>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <table>
        <xsl:apply-templates select="/doc/events/e[@c='true']" mode="complete"></xsl:apply-templates>
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
  
  <xsl:template match="p | span | a">
    <xsl:copy>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="ancestor::translation and not(@title)">font-style: italic</xsl:when>
          <xsl:otherwise>font-style: normal</xsl:otherwise>
        </xsl:choose>  
        <xsl:if test="@title">;font-weight:bold</xsl:if>

      </xsl:attribute>
      
      
      
      <xsl:apply-templates></xsl:apply-templates>
</xsl:copy>
    </xsl:template>
  
  <xsl:template match="span/text()">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="a/text()">
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
  
  
  <xsl:template match="*[@class='langInd']">
    <p>
      <xsl:attribute name="style">font-style: italic</xsl:attribute>
      <xsl:copy-of select="text()"/>
    </p>
  </xsl:template>
  
</xsl:stylesheet>
