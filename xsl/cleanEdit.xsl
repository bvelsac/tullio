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
      <xsl:apply-templates select="//div[@id='text']/node()"/>
      <xsl:if test="not(//div[@id='text']/*[not(@class='marker')])">
        <p c="{$number}" class="init"></p>
      </xsl:if>
    </wrapper>
  </xsl:template>
  
  <xsl:template match="div/text()">
  <!-- sometimes after copy / paste loose text nodes end up in the clip text, they must be wrapped in a p-element -->
  <xsl:call-template name="wrapText">
  	<xsl:with-param name="text" select="." />
  </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="wrapText">
  <xsl:param name="text" />
  <p>
  <xsl:attribute name="c">
        <xsl:choose>
          <xsl:when test="preceding-sibling::p[@class='marker']">
            <xsl:value-of select="preceding-sibling::p[@class='marker'][1]/@title"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$number"/></xsl:otherwise>
        </xsl:choose>
        
      </xsl:attribute>
  <xsl:copy-of select="$text" />
  </p>
  </xsl:template>
  
  <xsl:template priority="5" match="font | u | b | sup | i | span[not(@class)] ">
  <xsl:choose>
  	<xsl:when test="parent::div">
  		<p>
  <xsl:attribute name="c">
        <xsl:choose>
          <xsl:when test="preceding-sibling::p[@class='marker']">
            <xsl:value-of select="preceding-sibling::p[@class='marker'][1]/@title"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$number"/></xsl:otherwise>
        </xsl:choose>
        
      </xsl:attribute>
  	<xsl:apply-templates />
  </p>
  	
  	
  	</xsl:when>
  	<xsl:otherwise>  	<xsl:apply-templates /></xsl:otherwise>
  
  </xsl:choose>

  </xsl:template>
  
  
  <xsl:template match="*[not(@class='marker')]">
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
      <xsl:copy-of select="@*[local-name() != 'class' and local-name() != 'c'  and local-name() != 'align'  and local-name() != 'style']"/>
			<xsl:if test="not(@class='init')">
				<xsl:copy-of select="@class"/>
			</xsl:if>
      <xsl:apply-templates></xsl:apply-templates>
     
    </xsl:copy>
  </xsl:template>
  <xsl:template match="p[@class='marker']"></xsl:template>
</xsl:stylesheet>
