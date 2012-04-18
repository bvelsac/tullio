<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:template match="/">
    <container>
     
        <xsl:apply-templates mode="text" select="container/div[@id='text']"/>
    
      <xsl:copy-of select="container/reference"/>
      <xsl:copy-of select="container/info"/>
      <div id="events">
        <events>
          <xsl:copy-of select="container/div[@id='events']/events/@next"/>
          <xsl:copy-of select="container/div[@id='events']/events/*[not(@active='no')]"/>
          <xsl:choose>
            <xsl:when test="string(container/div[@id='events']/events/@next)">
              <e n="{container/div[@id='events']/events/@next}"/>
            </xsl:when>
            <xsl:otherwise>
              <e n="{container/div[@id='events']/events/*[not(@active='no')][position()=last()]/@n+1}"/>
            </xsl:otherwise>
          </xsl:choose>
        </events>
      </div>
      <div id="flattened">
        <xsl:apply-templates/>
      </div>
    </container>
  </xsl:template>
  <!-- default mode will keep only elements with @title or event-elements  -->
  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="text()"/>
  <xsl:template match="event">
    <xsl:if test="@c='true'">
      <!-- insert clipmarker for new clip -->
      <event c="y" id="{concat('marker:', generate-id())}" type="marker">
        <xsl:copy-of select="@lang"/>
        <xsl:copy-of select="@time"/>
      </event>
    </xsl:if>
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:copy-of select="@*"/>
      <xsl:if test="@c='true'">
        <xsl:attribute name="c">false</xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="*"/>
     
    </xsl:copy>
  </xsl:template>
  <xsl:template match="*[@title]">
    <!-- this will match any first occurrence with a reference to a title -->
    <xsl:if test="normalize-space() and not(preceding::*[@title=current()/@title])">
      <p title="{@title}"/>  
    </xsl:if>
    
    <xsl:apply-templates/>
  </xsl:template>
  <!-- text mode will copy everything and add ids to elements representing new events -->
  <!-- new events must be placed outside paragraphs, not inside
  in text mode the stylesheet will delete them
  only the template for p-elements will retrieve them and start standard processing on them
  -->
  <xsl:template match="p" mode="text">

    <xsl:if test="normalize-space() or * or @class='write'">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="text"/>
      </xsl:copy>  
    </xsl:if>
    <xsl:apply-templates select="descendant::event"/>
    
  </xsl:template>
  <xsl:template match="*" mode="text">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="text"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="text()" mode="text">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="event" mode="text"> </xsl:template>
</xsl:stylesheet>
