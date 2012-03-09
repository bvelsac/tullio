<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:template match="/">
    <container>
     
        <xsl:apply-templates mode="text" select="container/div[@id='text']"/>
    
      <xsl:copy-of select="container/reference"/>
      <div id="events">
        <events>
          <xsl:copy-of select="container/div[@id='events']/events/@next"/>
          <xsl:copy-of select="container/div[@id='events']/events/*"/>
          <xsl:choose>
            <xsl:when test="string(container/div[@id='events']/events/@next)">
              <e n="{container/div[@id='events']/events/@next}"/>
            </xsl:when>
            <xsl:otherwise>
              <e n="{container/div[@id='events']/events/*[position()=last()]/@n+1}"/>
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
    <xsl:if test="@clip='y'">
      <!-- insert clipmarker for new clip -->
      <event id="{concat('marker:', generate-id())}" type="marker"/>
    </xsl:if>
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="*[@title]">
    <!-- this will match any existing element with a reference to a title -->
    <p title="{@title}"/>
    <xsl:apply-templates/>
  </xsl:template>
  <!-- text mode will copy everything and add ids to elements representing new events -->
  <!-- new events must be placed outside paragraphs, not inside
  in text mode the stylesheet will delete them
  only the template for p-elements will retrieve them and start standard processing on them
  -->
  <xsl:template match="p" mode="text">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="text"/>
    </xsl:copy>
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
