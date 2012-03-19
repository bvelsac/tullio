<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
     <!ENTITY ntilde  "&#241;" ><!-- small n, tilde -->
     <!ENTITY nbsp  "&#160;" ><!-- non breaking space -->
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml"/>
  <xsl:variable name="number" select="//events/e[1]/@n"/>
  <xsl:template match="/">
    <wrapper>
      <xsl:apply-templates select="//div[@id='text']/*"/>
      <xsl:if test="not(//div[@id='text']/*[not(@class='init' or @class='marker')])">
        <p c="{$number}" class="init"></p>
      </xsl:if>
    </wrapper>
  </xsl:template>
  <xsl:template match="*[not(@class='init' or @class='marker')]">
    <xsl:copy>
      <xsl:attribute name="c">
        <xsl:choose>
          <xsl:when test="preceding-sibling::p[@class='marker']">
            <xsl:value-of select="preceding-sibling::p[@class='marker'][1]/@title"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$number"/></xsl:otherwise>
        </xsl:choose>
        
      </xsl:attribute>
      <xsl:copy-of select="@title"/>
      <xsl:copy-of select="@class"/>
      <xsl:apply-templates></xsl:apply-templates>
     
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
