<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:key name="moved" match="//moved" use="e/@n"/>
  <xsl:key name="new" match="container/div[@id='integratedEvents']/events/e" use="@id"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="container/div[@id='integratedEvents']">
        <!-- we're working on the result of a user edit -->
        <div id="consolidated">
          <div id="rawEvents">
            <!-- this one can be sent to the server, is a copy of the integratedResults -->
            <content/>
          </div>
          
          <div id="text">
            <!-- this one is our text content -->
            <xsl:apply-templates mode="write" select="container/div[@id='text']"></xsl:apply-templates>          
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <!-- just do the usual -->
        <xsl:call-template name="default"></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template mode="write" match="*">
   
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="write"></xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates></xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="text()">
    ping 
  </xsl:template>
  
  <xsl:template match="*[@title]" mode="write">
    <!-- match any element with a title attribute, we need to update the reference
      <moved><e n="2.5"/>
      <new-nr>2.7</new-nr>
      <p title="2.5"/>
      </moved>
    -->
    <xsl:variable name="eventRef">
      <xsl:choose>
        <xsl:when test="key('moved', @title)">
          <xsl:value-of select="key('moved', @title)/new-nr"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:copy>
      <xsl:attribute name="title"><xsl:value-of select="$eventRef"/>
      </xsl:attribute>
      
      <xsl:apply-templates mode="write"></xsl:apply-templates>    
    </xsl:copy>
    
  </xsl:template>
  <xsl:template mode="write" match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>
  
 
  
  
</xsl:stylesheet>
