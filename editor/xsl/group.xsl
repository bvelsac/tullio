<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="exsl" version="1.0" xmlns:exsl="http://exslt.org/common"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml"/>
  <xsl:key match="//e" name="clip" use="@clip"/>
  <xsl:key match="//l" name="snippets" use="@id"/>
  <xsl:key match="//doc/p[not(@d='init')]" name="text" use="@c"/>
  <xsl:key match="//trans/p[not(@d='init')]" name="trans" use="@c"/>
  <xsl:key match="//moved" name="moved" use="e/@n"/>
  <xsl:key match="container/div[@id='integratedEvents']/events/e" name="new" use="@id"/>
  <xsl:key match="container/div[@id='integratedEvents']/events/e" name="all" use="@n"/>
  <xsl:key match="//s" name="statusCodes" use="@n"/>
  <xsl:key match="//person" name="people" use="@id"/>
  <xsl:param name="mode"/>
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
  <xsl:variable name="conf" select="//reference"/>
  <xsl:variable name="meeting-type">
    <xsl:choose>
      <xsl:when test="contains(/all/type/e/@type, 'VVGGC')">
        <xsl:value-of select="'VVGGC'"/>
      </xsl:when>
      <xsl:otherwise>BHP</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="datestringCurrent" select="//events/meeting"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="container/div[@id='integratedEvents']">
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
      </xsl:when>
      <xsl:when test="$server='yes'">
        <original>
          <xsl:apply-templates mode="initialize-text" select="//e"/>
        </original>
        <translation>
          <xsl:variable name="inversion">
            <transEvent>
              <xsl:apply-templates mode="invert" select="//e"/>
            </transEvent>
          </xsl:variable>
          <xsl:apply-templates mode="initialize-text" select="exsl:node-set($inversion)//e"/>
        </translation>
      </xsl:when>
      <xsl:otherwise>
        <!-- just do the usual -->
        <xsl:call-template name="default"/>
      </xsl:otherwise>
    </xsl:choose>
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
    <xsl:choose>
      <xsl:when test="self::span[@class='pres reformat']">
        <xsl:call-template name="president">
          <xsl:with-param name="event" select="key('all', $eventRef)"/>
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
          <xsl:copy-of select="@class"/>
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
  <xsl:template name="addTranslation">
    <td class="status" id="{concat('status-', @n, '-trans')}">&#160;</td>
    <td class="trans content" id="{concat('R', @n, '-t')}">
      <div class="editable">
        <!-- de eerste keer bestaat er nog geen tekst, die moet dan worden aangemaakt op basis van de events -->
        <xsl:choose>
          <xsl:when test="key('trans', @n)">
            <xsl:copy-of select="key('trans', @n)"/>
          </xsl:when>
          <xsl:when test="key('clip', @n)">
            <p class="debug">(Generated text)</p>
            <xsl:variable name="inversion">
              <transEvent>
                <xsl:apply-templates mode="invert" select="key('clip', @n)"/>
              </transEvent>
            </xsl:variable>
            <xsl:apply-templates mode="initialize-text" select="exsl:node-set($inversion)//e"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- deze optie is in principe niet mogelijk, de clipmarker heeft ook @c -->
            <p class="write" title="{@n}">
              <xsl:text>...</xsl:text>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
  </xsl:template>
  <xsl:template match="text()" mode="write">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="event" mode="write">
    <xsl:apply-templates mode="initialize-text" select="key('new', @id)"/>
  </xsl:template>
  <xsl:template name="default">
    <xsl:for-each select="//e[@c='y']">
      <tr id="{concat('R', @n)}">
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
          <xsl:variable name="hours" select="substring-before(@time,':')"/>
          <xsl:variable name="minutes" select="substring-before(substring-after(@time, ':'), ':')"/>
          <xsl:variable name="seconds" select="substring-after(substring-after(@time, ':'), ':')"/>
          <xsl:comment>
            <xsl:value-of select="$hours"/>, <xsl:value-of select="$minutes"/>, <xsl:value-of
              select="$seconds"/>, </xsl:comment>
          <xsl:variable name="recordingStart">
            <xsl:choose>
              <xsl:when test="$minutes &gt; 50">50</xsl:when>
              <xsl:when test="$minutes &lt; 10">00</xsl:when>
              <xsl:when test="$minutes &lt; 20">10</xsl:when>
              <xsl:when test="$minutes &lt; 30">20</xsl:when>
              <xsl:when test="$minutes &lt; 40">30</xsl:when>
              <xsl:when test="$minutes &lt; 50">40</xsl:when>
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
                <a href="{concat($soundURL2,'201203211040.mp3')}" id="play-{@n}">
                  <xsl:value-of select="concat('Clip ', @n)"/>
                </a>
                <!--                <span class="offset">00:07</span>-->
                <div class="metadata">
                  <div class="duration">20:00</div>
                  <!-- total track time (for positioning while loading, until determined -->
                  <ul>
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
          <!--
            yyyymmddhhmm.mp3
            <li>
              <a href="http://freshly-ground.com/data/audio/binaural/Rubber%20Chicken%20Launch%20%28office%29.mp3">Rubber Chicken Launch (Office)</a>
              <div class="metadata">
                <div class="duration">0:47</div>
                <ul>
                  <li>
                    <p>First attempt</p>
                    <span>0:00</span>
                  </li>
                  <li>
                    <p>Fire!</p>
                    <span>0:02</span>
                  </li>
                  <li>
          -->
        </td>
        <td class="events">
          <!--<div class="meta-xml">
										<xsl:copy-of select="."/>
										</div>
										-->
          <xsl:variable name="top" select="@n"/>
          <div class="structured-events">
            <events>
              <xsl:attribute name="next">
                <xsl:choose>
                  <xsl:when test="following-sibling::e[@c='y']">
                    <xsl:value-of select="following-sibling::e[@c='y'][1]/@n"/>
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
              <!--<li class="startstop">
                <xsl:if test="position()=1">
                  <xsl:attribute name="id">
                    <xsl:text>startevent-</xsl:text>
                    <xsl:value-of select="@n"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="position()=last()">
                  <xsl:attribute name="id">
                    <xsl:text>stopevent-</xsl:text>
                    <xsl:value-of select="$top"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@n"/>
              </li>-->
            </xsl:for-each>
          </table>
        </td>
        <td class="status status-{key('statusCodes', @n)/@val}"
          id="{concat('status-', @n, '-orig')}">
          <p class="status-wrapper">
            <span class="status-code" id="{concat('status-', @n, '-orig-code')}">
              <xsl:value-of select="key('statusCodes', @n)/@val"/>
            </span>
            <span class="status-lang" id="{concat('status-', @n, '-orig-lang')}">
              <xsl:value-of select="@lang"/>
            </span>
          </p>
          <p class="lockid"/>
        </td>
        <td class="orig content {concat(generate-id(), 'R', @n, '-o')}" id="{concat('R', @n, '-o')}">
          <div class="editable">
            <!-- de eerste keer bestaat er nog geen tekst, die moet dan worden aangemaakt op basis van de events -->
            <xsl:choose>
              <xsl:when test="key('text', @n)">
                <xsl:copy-of select="key('text', @n)"/>
              </xsl:when>
              <xsl:when test="key('clip', @n)">
                <p class="debug">(Generated text)</p>
                <xsl:apply-templates mode="initialize-text" select="key('clip', @n)"/>
              </xsl:when>
              <xsl:otherwise>
                <p class="write" title="{@n}">
                  <xsl:text>...</xsl:text>
                </p>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
        <xsl:choose>
          <xsl:when test="$mode = 'yes'">
            <xsl:call-template name="addTranslation"/>
          </xsl:when>
        </xsl:choose>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="e" mode="invert">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="lang">
        <xsl:choose>
          <xsl:when test="@lang='N'">F</xsl:when>
          <xsl:when test="@lang='F'">N</xsl:when>
          <xsl:when test="@lang=''"/>
          <xsl:when test="@lang='M'">M</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="events//e" mode="events-table">
    <tr class="{name(parent::*)}">
      <td class="e-n">
        <xsl:choose>
          <xsl:when test="parent::moved">
            <xsl:value-of select="following-sibling::new-nr"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@n"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="e-time">
        <xsl:value-of select="@time"/>
      </td>
      <td class="e-type">
        <xsl:value-of select="@type"/>
      </td>
      <td class="e-speaker">
        <xsl:choose>
          <xsl:when test="string(@speaker)">
            <xsl:value-of select="@speaker"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@notes"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">
          <xsl:text>offset</xsl:text>
          <xsl:choose>
            <xsl:when test="parent::moved">
              <xsl:value-of select="following-sibling::new-nr"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@n"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="text()" mode="events-table"/>
  <!--
    <xsl:template mode="initialize-text" match="*">
      <p>Default template, n=<xsl:value-of select="@n"/></p>
    </xsl:template>
    -->
  <xsl:template match="e[@type='OUV-OPE']" mode="initialize-text">
    <xsl:choose>
      <xsl:when test="@lang='N'">
        <p c="{@clip}" title="{@n}">Integraal verslag</p>
        <p c="{@clip}" title="{@n}">Plenaire vergadering van <span class="incomplete">DATUM</span></p>
        <p c="{@clip}" title="{@n}">
          <span class="incomplete" title="{@n}">(Ochtendvergadering/Namiddagvergadering)</span>
        </p>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='QA-AV'] | e[@type='QO-MV'] | e[@type='INT']" mode="initialize-text">
    <xsl:variable name="speaker" select="@speaker"/>
    <xsl:variable name="gov" select="@props"/>
    <xsl:variable name="lang" select="@lang"/>
    <xsl:variable name="type-NL">
      <xsl:choose>
        <xsl:when test="@type='INT'">Interpellatie van </xsl:when>
        <xsl:when test="@type='QO-MV'">
          <xsl:text>Dringende vraag van</xsl:text>
        </xsl:when>
        <xsl:otherwise>Mondelinge vraag van</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="type-FR">
      <xsl:choose>
        <xsl:when test="@type='INT'">Interpellation de </xsl:when>
        <xsl:when test="@type='QO-MV'">
          <xsl:text>Question orale de</xsl:text>
        </xsl:when>
        <xsl:otherwise>Question d'actualité de </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="meeting-type">
      <xsl:choose>
        <xsl:when
          test="contains(preceding-sibling::*[contains(@type, 'VVGGC') or contains(@type, 'BHP')][1]/@type, 'BHP')"
          >BHP</xsl:when>
        <xsl:otherwise>VVGGC</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@lang='N'">
        <p c="{@clip}" title="{@n}">
          <xsl:value-of select="$type-NL"/>
          <xsl:choose>
            <!--  test="$conf//p[@code=$speaker]/gender='M'" -->
            <xsl:when test="$conf//p[@code=$speaker]/gender='M'"> de heer </xsl:when>
            <xsl:otherwise>mevrouw</xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$conf//p[@code=$speaker]/name"/>
          <xsl:text> aan </xsl:text>
        </p>
        <p c="{@clip}" title="{@n}">
          <xsl:choose>
            <xsl:when test="$conf//p[@code=$gov]/gender='M'"> de heer </xsl:when>
            <xsl:otherwise>mevrouw</xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$conf//p[@code=$gov]/name"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$conf//p[@code=$gov]/ti[@l=$lang][@meeting-type=$meeting-type]"/>
          <xsl:text>,</xsl:text>
        </p>
        <p c="{@clip}" title="{@n}">
          <xsl:text>betreffende "</xsl:text>
          <xsl:value-of select="@notes"/>
          <xsl:text>".</xsl:text>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}" title="{@n}">
          <xsl:value-of select="$type-FR"/>
          <xsl:choose>
            <!--  test="$conf//p[@code=$speaker]/gender='M'" -->
            <xsl:when test="true()">M. </xsl:when>
            <xsl:otherwise>Mme</xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$conf//p[@code=$speaker]/name"/>
        </p>
        <p c="{@clip}" title="{@n}">
          <xsl:text> à </xsl:text>
          <xsl:choose>
            <xsl:when test="$conf//p[@code=$gov]/gender='M'">M. </xsl:when>
            <xsl:otherwise>Mme</xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$conf//p[@code=$gov]/name"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$conf//p[@code=$gov]/ti[@l=$lang][@meeting-type=$meeting-type]"/>
          <xsl:text>,</xsl:text>
        </p>
        <p c="{@clip}" title="{@n}">
          <xsl:text>concernant "</xsl:text>
          <xsl:value-of select="@notes"/>
          <xsl:text>".</xsl:text>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <p class="write">...</p>
  </xsl:template>
  <xsl:template name="president">
    <xsl:param name="class" select="'pres'"/>
    <xsl:param name="segment"/>
    <xsl:param name="event"/>
    <!--<xsl:comment>
      <xsl:value-of
        select="concat('pres-', preceding-sibling::e[pres][1]/pres/person/@gender, '-', @lang)"/>
        </xsl:comment>-->
    <xsl:variable name="pres-gender">
      <xsl:choose>
        <xsl:when test="$event/preceding-sibling::e[pres]">
          <xsl:value-of select="$event/preceding-sibling::e[pres][1]/pres/person/@gender"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/container/info/pres/person/@gender"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <span class="{$class} reformat" title="{$event/@n}">
      <xsl:if test="string($segment)">
        <xsl:attribute name="segment">
          <xsl:value-of select="$segment"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="key('snippets', concat('pres-', $pres-gender, '-', $event/@lang))">
          <xsl:value-of select="key('snippets', concat('pres-', $pres-gender, '-', $event/@lang))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>.-</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  <xsl:template match="e[@type='ORA-SPR']" mode="initialize-text">
    <xsl:variable name="person" select="key('people', @speaker)"/>
    
    <p c="{@clip}" title="{@n}">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
      </xsl:call-template>
      
      <xsl:choose>
        <xsl:when test="@lang='F'">
          <xsl:value-of select="key('snippets', concat('parole-', @lang))"/>
          
          <xsl:value-of
            select="key('snippets', concat('title-', $person/@gender, '-',  @lang))"/><xsl:value-of
              select="$person/first"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$person/last"/>
          
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="key('snippets', concat('title-', $person/@gender, '-',  @lang))"/><xsl:value-of
              select="$person/first"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$person/last"/>
        
        
          <xsl:value-of select="key('snippets', concat('parole-', @lang))"/>   
        </xsl:otherwise>
         
      </xsl:choose>
      
      

      
    </p>
    <p c="{@clip}">
      <span class="speaker" title="{@n}"><xsl:value-of
          select="key('snippets', concat('title-', $person/@gender, '-',  @lang))"/><xsl:value-of
          select="$person/first"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$person/last"/>.- </span>
    </p>
    <p c="{@clip}">
      <span class="incomplete">Lijst van afwezigen</span>
    </p>
    <p c="{@clip}" class="incomplete"/>
    <p class="write"> </p>
  </xsl:template>
  <xsl:template match="e[@type='EXC-AFW']" mode="initialize-text">
    <p c="{@clip}" title="{@n}">VERONTSCHULDIGD</p>
    <p c="{@clip}" title="{@n}">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
      </xsl:call-template>
      <xsl:value-of select="key('snippets', concat('exc-', @lang))"/>
    </p>
    <p c="{@clip}">
      <span class="incomplete">Lijst van afwezigen</span>
    </p>
    <p c="{@clip}" class="incomplete"/>
    <p class="write"> </p>
  </xsl:template>
  <xsl:template match="e[@type='']" mode="initialize-text">
    <p class="debug" title="{@n}">Event type missing</p>
  </xsl:template>
  <xsl:template match="e[@type='marker']" mode="initialize-text">
    <p c="{@clip}" class="marker" title="{@n}">Start clip <xsl:value-of select="@n"/>
    </p>
    <p class="write">...</p>
  </xsl:template>
  <xsl:template match="e" mode="initialize-text">
    <p c="{@clip}" title="{@n}">Unsupported event
      <!-- 
      <xsl:text>[</xsl:text><xsl:value-of select="@clip"/><xsl:text>]</xsl:text>
      -->
    </p>
    <p class="write">...</p>
    <!-- 
      <xsl:copy-of select="preceding-sibling::*[1]"/>
    -->
  </xsl:template>
</xsl:stylesheet>
