<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output indent="yes" method="xml"/>
  <xsl:include href="/exist/tullio/editor/xsl/formattingRules.xsl"/>
  
  <xsl:key match="//e" name="clip" use="@clip"/>
  <xsl:key match="//l" name="snippets" use="@id"/>
  <xsl:key match="//doc/p[not(@d='init')]" name="text" use="@c"/>
  <xsl:key match="//trans/p[not(@d='init')]" name="trans" use="@c"/>
  <xsl:key match="//moved" name="moved" use="e/@n"/>
  <xsl:key match="container/div[@id='integratedEvents']/events/e" name="new" use="@id"/>
  <xsl:key match="container/div[@id='integratedEvents']/events/e" name="all" use="@n"/>
  <xsl:key match="//s" name="statusCodes" use="@n"/>
  <xsl:key match="//person" name="people" use="@id"/>
  <xsl:param name="mode"></xsl:param>
  <xsl:param name="server" select="'no'"/>
  <xsl:variable name="conf" select="//reference"/>
  <xsl:variable name="meeting-type"></xsl:variable>
  <xsl:template match="/">
    <!-- we're working on the result of a user edit -->
    <div id="consolidated">
      <div id="rawEvents">
        <events>
          <xsl:copy-of select="container/div[@id='integratedEvents']/events/@next"/>
          <xsl:for-each select="container/div[@id='integratedEvents']//e">
            <xsl:choose>
              <xsl:when test="parent::moved">
                <e>
                  <xsl:copy-of select="@*"/>
                  <xsl:attribute name="n">
                    <xsl:value-of select="following-sibling::new-nr"/>
                  </xsl:attribute>
                  <xsl:attribute name="history">moved</xsl:attribute>
                  <xsl:copy-of select="*"/>
                </e>
              </xsl:when>
              <xsl:when test="parent::leftovers">
                <xsl:copy>
                  <xsl:copy-of select="@*"/>
                  <xsl:attribute name="active">no</xsl:attribute>
                  <xsl:copy-of select="*"/>
                </xsl:copy>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </events>
        <!-- this one can be sent to the server, is a copy of the integratedResults -->
      </div>
      <div id="structuredEvents">
        <!-- this one replaces the overview in the UI -->
        <table class="events-table">
          <xsl:apply-templates mode="events-table"
            select="container/div[@id='integratedEvents']/events//e"/>
        </table>
      </div>
      <!-- this one is our text content -->
      <xsl:apply-templates mode="write" select="container/div[@id='text']"/>
    </div>
    
    
    
    
  </xsl:template>
  <xsl:template match="*[@title]" mode="write">
    
    <!-- match any element with a title attribute, we need to update the reference
      <moved><e n="2.5"/>
      <new-nr>2.7</new-nr>
      <p title="2.5"/>
      </moved>
    -->
    <!-- This template also takes care of reformatting so some language handling is necessary for translations -->
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
    <xsl:choose>
      <xsl:when test="self::span[@class='pres reformat'] | self::a[@class='pres reformat']">
        <xsl:call-template name="president">
          <xsl:with-param name="event" select="key('all', $eventRef)"/>
          <xsl:with-param name="lang" select="key('all', $eventRef)/@lang"/>
        </xsl:call-template>
      </xsl:when>
      <!--
        <xsl:when test="self::span[@type='comp']">
        <xsl:call-template name="competences">
        <xsl:with-param name="event" select="key('all', $eventRef)"></xsl:with-param>
        </xsl:call-template>
        </xsl:when>-->
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*[local-name() != 'title']" />
          

          <xsl:attribute name="title">
            <xsl:value-of select="$eventRef"/>
          </xsl:attribute>
          <xsl:apply-templates mode="write"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="br" mode="write">
    <xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="*" mode="write">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="write"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="text()" mode="write">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="event" mode="write">
    <xsl:apply-templates mode="initialize-text" select="key('new', @id)"/>
  </xsl:template>
</xsl:stylesheet>
