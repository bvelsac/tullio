<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="exsl" version="1.0" xmlns:exsl="http://exslt.org/common"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml"/>
  <!--xsl:include href="http://localhost:8080/exist/tullio/editor/xsl/formattingRules.xsl"/-->
  <xsl:include href="/exist/tullio/editor/xsl/formattingRules.xsl"/>
  <xsl:key match="//event" name="eventNames" use="@id"/>
  <xsl:key match="//e" name="clip" use="@clip"/>
  <xsl:key match="//l" name="snippets" use="@id"/>
  <xsl:key match="//doc/p[not(@class='init')]" name="text" use="@c"/>
  <xsl:key match="//trans/p[not(@d='init')]" name="trans" use="@c"/>
  <xsl:key match="//moved" name="moved" use="e/@n"/>
  <xsl:key match="container/div[@id='integratedEvents']/events/e" name="new" use="@id"/>
  <xsl:key match="/all/events/e" name="all" use="@n"/>
  <xsl:key match="//s" name="statusCodes" use="concat(@n,@v)"/>
  <xsl:key match="//person" name="people" use="@id"/>
  <xsl:param name="mode"/>
  <xsl:param name="channel"/>
  <xsl:param name="server" select="'no'"/>
  <!-- Chrome heeft een issue waardoor de document() functie niet werkt, dus alles moet worden toegevoegd aan het input-document
    Google Chrome currently has limited support for XSL. If your XSL refers to any external resources (document() function, xsl:import, xsl:include or external entities), the XSL will run but the result will either be empty or invalid.
  
  -->
  <!-- Volgende declaratie werkt dus NIET:
  <xsl:variable name="conf" select="document('/exist/tullio/xml/titles.xml')" >
  </xsl:variable>
  -->
  <!--<xsl:variable name="testLoad" select="document('http://localhost:8080/exist/tullio/xq/list-collections.xql')"></xsl:variable>-->
  <xsl:variable name="soundURL" select="'../soundmanager/recordings/'"/>
  <xsl:variable name="soundURL2" select="'/exist/sound/canal3/'"/>
  <!--  http://localhost:8080/exist/sound/canal3/201203211040.mp3
-->
  <xsl:variable name="soundExt" select="'.mp3'"/>
  <xsl:variable name="audioLength" select="'10'"/>
  <xsl:variable name="conf" select="//reference"/>
  <xsl:variable name="global-meeting-type">
    <xsl:choose>
      <xsl:when
        test="/all/variables/type = 'VVGGC' or /all/variables/type = 'BHP' or /all/variables/type='PFB'">
        <xsl:value-of select="/all/variables/type"/>
      </xsl:when>
      <xsl:when test="contains(/all/variables/type, 'ARVV')">VVGGC</xsl:when>
      <xsl:when test="contains(/all/variables/type, 'BXL')">BHP</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="datestringCurrent" select="//events/meeting"/>
  <xsl:template name="addTranslation">
    <xsl:variable name="language">
      <xsl:choose>
        <xsl:when test="@lang='N'">F</xsl:when>
        <xsl:when test="@lang='F'">N</xsl:when>
        <xsl:when test="@lang='M'">M</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!--    <td class="status status-{key('statusCodes', @n)/@val}"
      id="{concat('status-', @n, '-orig')}">
      
      <p class="status-wrapper" >      
        <span class="status-code" id="{concat('status-', @n, '-orig-code')}">
          <xsl:value-of select="key('statusCodes', concat(@n,'orig'))/@val"/>
        </span>
        <span class="status-lang" id="{concat('status-', @n, '-orig-lang')}">
          <xsl:value-of select="@lang"/>
        </span>
        <xsl:text>&#160;</xsl:text>
      </p>
      <div class="lockid">
        <p></p>
      </div>
    </td>
-->
    <td class="status status-{key('statusCodes', @n)/@val}" id="{concat('status-', @n, '-trans')}">
      <p class="status-wrapper">
        <span class="status-code" id="{concat('status-', @n, '-trans-code')}">
          <xsl:value-of select="key('statusCodes', concat(@n,'trans'))/@val"/>
        </span>
        <span class="status-lang" id="{concat('status-', @n, '-trans-lang')}">
          <xsl:value-of select="$language"/>
        </span>&#160;</p>
      <div class="lockid">
        <p/>
      </div>
    </td>
    <td class="trans content" id="{concat('R', @n, '-t')}">
      <div class="editable">
        <!-- als er nog geen save is gebeurd, bestaat er nog geen tekst, die moet dan worden aangemaakt op basis van de events -->
        <xsl:choose>
          <!-- er is wel vertaalde tekst beschikbaar -->
          <xsl:when test="key('trans', @n)[not(@class='init')]">
            
            <xsl:apply-templates mode="write" select="key('trans', @n)">
              <xsl:with-param name="language" select="$language"></xsl:with-param>
              
            </xsl:apply-templates>
           
          </xsl:when>
          <!-- er is nog geen vertaalde tekst beschikbaar -->
          <xsl:when test="key('clip', @n)">
            <xsl:for-each select="key('clip', @n)">
              <xsl:apply-templates mode="initialize-text" select=".">
                <xsl:with-param name="lang" select="$language"></xsl:with-param>
                <xsl:with-param name="meeting-type">
                  <xsl:choose>
                    <xsl:when test="/all/variables/status='VAR'">
                      <xsl:variable name="prevMT" select="preceding-sibling::e[@type='HERV-ARVV' or @type='HERV-BXL' or @type='O-ARVV' or @type='O-BXL'][1]"></xsl:variable>
                      <xsl:choose>
                        <xsl:when
                          test="$prevMT">
                          
                          
                          <xsl:choose>
                            <xsl:when test="contains($prevMT/@type, 'ARVV')">VVGGC</xsl:when>
                            <xsl:when test="contains($prevMT/@type, 'BXL')">BHP</xsl:when>
                            
                          </xsl:choose>
                          
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$global-meeting-type"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$global-meeting-type"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:apply-templates>
            </xsl:for-each>
          </xsl:when>
         
          <xsl:otherwise>
            <!-- er zijn helemaal geen events bekend voor deze clip -->
            <!-- deze optie is in principe niet mogelijk, de clipmarker heeft ook @clip -->
            <p c="{@n}" class="init" title="{@n}">
              <xsl:text>...</xsl:text>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
  </xsl:template>
  <xsl:template name="sound">
    <td class="sound">
      <!-- create a list of events for the sound markers -->
      <!--  time="15:53:07"
        if the clip has a start time before 8AM, the link will point to the sound file of the day after the meeting (nightly meeting) 
        *** day of meeting AND next day need to be specified when creating the agenda ! ***
        and also
        - meeting type
        - AM / PM
        as separate fields
      -->
      <xsl:comment> next tc : <xsl:value-of select="/all/variables/nextTimeCode"/>
      </xsl:comment>
      <xsl:variable name="hours" select="substring-before(@time,':')"/>
      <xsl:variable name="minutes" select="substring-before(substring-after(@time, ':'), ':')"/>
      <xsl:variable name="seconds" select="substring-after(substring-after(@time, ':'), ':')"/>
      <xsl:comment>
        <xsl:value-of select="$hours"/>, <xsl:value-of select="$minutes"/>, <xsl:value-of
          select="$seconds"/>, </xsl:comment>
      <xsl:variable name="recordingStart">
        <xsl:choose>
        <xsl:when test="$minutes &gt;= 55">55</xsl:when>
		  <xsl:when test="$minutes &lt; 05">00</xsl:when>
		  <xsl:when test="$minutes &lt; 10">05</xsl:when>
          <xsl:when test="$minutes &lt; 15">10</xsl:when>
          <xsl:when test="$minutes &lt; 20">15</xsl:when>
          <xsl:when test="$minutes &lt; 25">20</xsl:when>
          <xsl:when test="$minutes &lt; 30">25</xsl:when>
          <xsl:when test="$minutes &lt; 35">30</xsl:when>
          <xsl:when test="$minutes &lt; 40">35</xsl:when>
          <xsl:when test="$minutes &lt; 45">40</xsl:when>
          <xsl:when test="$minutes &lt; 50">45</xsl:when>
          <xsl:when test="$minutes &lt; 55">50</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="audioRef"
        select="concat($datestringCurrent, $hours, $recordingStart, $soundExt)"/>
      <xsl:comment>
        <xsl:value-of select="$audioRef"/>
      </xsl:comment>
      <a class="startRec" href="#" onclick="return false;">
        <xsl:text>Play </xsl:text>
        <p>
          <xsl:value-of select="concat($hours, ':', $recordingStart, ':00')"/>
        </p>
      </a>
      <div class="playlistWrapper">
        <p class="timecodes">
          <xsl:for-each select="key('clip', @n)">
            <xsl:if test="string(@time)">
              <span id="tc{generate-id()}">
                <xsl:value-of select="@time"/>
              </span>
            </xsl:if>
          </xsl:for-each>
        </p>
        <ul class="playlist hidden">
          <li>
            <!-- <a href="{concat($soundURL2,$recordingStart)}" id="play-{@n}"> -->
            <a href="{concat('/exist/sound/', $channel, '/', $audioRef)}" id="play-{@n}">
              <xsl:value-of select="concat('Clip ', @n)"/>
            </a>
            <!--                <span class="offset">00:07</span>-->
            <div class="metadata">
              <div class="duration"><xsl:value-of select="$audioLength"/>:00</div>
              <!-- total track time (for positioning while loading, until determined -->
              <ul>
                <li>
                  <p/>
                  <span>0:00</span>
                </li>
                <xsl:for-each select="key('clip', @n)">
                  <!-- must be updated using js before loading the track -->
                  <xsl:if test="string(@time)">
                    <li>
                      <p>
                        <xsl:value-of select="@n"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="@type"/>
                        <xsl:if test="string(@speaker)">
                          <xsl:value-of select="concat(' ', @speaker)"/>
                        </xsl:if>
                      </p>
                      <span id="offset{generate-id()}">0:00</span>
                    </li>
                  </xsl:if>
                  <!-- first scene -->
                </xsl:for-each>
              </ul>
            </div>
          </li>
        </ul>
      </div>
    </td>
  </xsl:template>
  <xsl:template match="/">
    <!-- this is the template that processes updated clip info from the server -->
    <xsl:for-each select="//e[@c='true']">
      <tr id="{concat('R', @n)}">
        <!-- Add audio metadata for player -->
        <xsl:call-template name="sound"/>
        <!-- Add events as raw xml and as structured table -->
        <td class="events">
          <xsl:variable name="top" select="@n"/>
          <div class="structured-events">
            <events>
              <xsl:attribute name="next">
                <xsl:choose>
                  <xsl:when test="following-sibling::e[@c='true']">
                    <xsl:value-of select="following-sibling::e[@c='true'][1]/@n"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="/all/@next"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:copy-of select="key('clip', @n)"/>
            </events>
          </div>
          <table class="events-table">
            <xsl:for-each select="key('clip', @n)">
              <xsl:apply-templates mode="events-table" select="."/>
            </xsl:for-each>
          </table>
        </td>
        <!-- add cell for status code and locking state -->
        <td class="status status-{key('statusCodes', @n)/@val}"
          id="{concat('status-', @n, '-orig')}">
          <p class="status-wrapper">
            <span class="status-code" id="{concat('status-', @n, '-orig-code')}">
              <xsl:value-of select="key('statusCodes', concat(@n,'orig'))/@val"/>
            </span>
            <span class="status-lang" id="{concat('status-', @n, '-orig-lang')}">
              <xsl:value-of select="@lang"/>
            </span>
            <xsl:text>&#160;</xsl:text>
          </p>
          <div class="lockid">
            <p/>
          </div>
        </td>
        <!-- add cell with the original text -->
        <td class="orig content {concat(generate-id(), 'R', @n, '-o')}" id="{concat('R', @n, '-o')}">
          <div class="editable">
            <!-- de eerste keer bestaat er nog geen tekst, die moet dan worden aangemaakt op basis van de events -->
            <xsl:choose>
              <!-- text has been edited, use stored paragraphs -->
              <xsl:when test="key('text', @n)">
                <xsl:apply-templates mode="write" select="key('text', @n)"/>
                <xsl:for-each select="key('text', @n)"> </xsl:for-each>
              </xsl:when>
              <!-- no edited text, use events to generate text -->
              <xsl:when test="key('clip', @n)">
                <xsl:for-each select="key('clip', @n)">
                  <xsl:apply-templates mode="initialize-text" select=".">
                    
                    <xsl:with-param name="meeting-type">
                      <xsl:choose>
                        <xsl:when test="/all/variables/status='VAR'">
                          <xsl:variable name="prevMT" select="preceding-sibling::e[@type='HERV-ARVV' or @type='HERV-BXL' or @type='O-ARVV' or @type='O-BXL'][1]"></xsl:variable>
                          <xsl:choose>
                            <xsl:when
                              test="$prevMT">
                              
                              
                              <xsl:choose>
                                <xsl:when test="contains($prevMT/@type, 'ARVV')">VVGGC</xsl:when>
                                <xsl:when test="contains($prevMT/@type, 'BXL')">BHP</xsl:when>
                                
                              </xsl:choose>
                              
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$global-meeting-type"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$global-meeting-type"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                  </xsl:apply-templates>
                </xsl:for-each>
              </xsl:when>
              <!-- somehow there are not even events -->
              <xsl:otherwise>
                <p c="{@n}" class="write" title="{@n}">
                  <xsl:text>...</xsl:text>
                </p>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
        <!-- Should we add the translations ? -->
        <xsl:choose>
          <xsl:when test="$mode = 'yes'">
            <xsl:call-template name="addTranslation"/>
          </xsl:when>
        </xsl:choose>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="span[contains(@class, 'pres reformat')] | a[@class='pres reformat']"
    mode="write">
    <xsl:param name="language" select="key('all', @title)/@lang"></xsl:param>
    <xsl:variable name="defLang">
      <xsl:choose>
        <xsl:when test="not(normalize-space($language))">
          <xsl:value-of select="key('all', ancestor::p[1]/@c)/@lang"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$language"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>
    
    
    <!--<xsl:copy-of select="key('all', @title)"/>-->
    <xsl:call-template name="president">
      <xsl:with-param name="event" select="key('all', @title)"/>
      <xsl:with-param name="clipId" select="ancestor::p[1]/@c"></xsl:with-param>
      <xsl:with-param name="lang" select="$defLang"/>
      <xsl:with-param name="reformat" select="'true'"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="*" mode="write">
    <xsl:param name="language" select="key('all', @title)/@lang"></xsl:param>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="write">
        <xsl:with-param name="language" select="$language"></xsl:with-param>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="text()" mode="write">
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:stylesheet>
