<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:key match="//e" name="clip" use="@clip"/>
  <xsl:key match="//p" name="text" use="@c"/>
  <!-- Chrome heeft een issue waardoor de document() functie niet werkt, dus alles moet worden toegevoegd aan het input-document -->
  <!-- Volgende declaratie werkt dus NIET:
  <xsl:variable name="conf" select="document('/exist/tullio/xml/titles.xml')" >
  </xsl:variable>
  -->
  <xsl:variable name="soundURL" select="'../soundmanager/recordings/'"></xsl:variable>
  <xsl:variable name="soundExt" select="'.mp3'"></xsl:variable>
  <xsl:variable name="conf" select="//reference"/>
  <xsl:variable name="meeting-type">
    <xsl:choose>
      <xsl:when test="contains(/all/type/e/@type, 'VVGGC')">
        <xsl:value-of select="'VVGGC'"/>
      </xsl:when>
      <xsl:otherwise>BHP</xsl:otherwise>
    </xsl:choose>
    
    
  </xsl:variable>
  
  <xsl:variable name="datestringCurrent" select="//events/meeting"></xsl:variable>
  
  
  <xsl:template match="/">
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

          <xsl:variable name="hours" select="substring-before(@time,':')"></xsl:variable>
          <xsl:variable name="minutes" select="substring-before(substring-after(@time, ':'), ':')"></xsl:variable>
          <xsl:variable name="seconds" select="substring-after(substring-after(@time, ':'), ':')"></xsl:variable>
          <xsl:comment>
            <xsl:value-of select="$hours"/>,
            <xsl:value-of select="$minutes"/>,
            <xsl:value-of select="$seconds"/>,
          </xsl:comment>
          
          <xsl:variable name="recording">
            <xsl:choose>
              <xsl:when test="$minutes &lt; 15">
                <xsl:value-of select="concat($datestringCurrent, $hours, '00', $soundExt)"/>
              </xsl:when>
              <xsl:when test="$minutes &lt; 30">
                <xsl:value-of select="concat($datestringCurrent, $hours, '15', $soundExt)"/>
              </xsl:when>
              <xsl:when test="$minutes &lt; 45">
                <xsl:value-of select="concat($datestringCurrent, $hours, '30', $soundExt)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($datestringCurrent, $hours, '45', $soundExt)"/>
              </xsl:otherwise>
            
            </xsl:choose>
            
            
          </xsl:variable>
          
          <a class='startRec' href='#'>
            
            <xsl:text>Play</xsl:text>
          </a>
          <div calss="playlistWrapper">
          <ul class="playlist hidden">
            
            <li ><a id='play-{@n}' href="{concat($soundURL,$recording)}">
  
              <!-- time calculations inc. offset in js -->
            </a> <span class="offset">start: 00:07</span>
              <div class="metadata">
                <div class="duration">15:00</div> <!-- total track time (for positioning while loading, until determined -->
                <ul>
                  
                  <xsl:for-each select="key('clip', @n)">
                    <!-- must be updated using js before loading the track -->
                    <li><p><xsl:value-of select="@speaker"/></p><span>0:00</span></li> <!-- first scene -->
                      
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
              <xsl:copy-of select="key('clip', @n)" />
            </events>
            
          </div>
          <table class="events-table">
            <xsl:for-each select="key('clip', @n)">
              
              <xsl:apply-templates mode="events-table" select="."/>
              <li class="startstop">
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
              </li>
            </xsl:for-each>
          </table>
        </td>
        <td class="orig" id="{concat('R', @n, '-o')}" rel="test">
          <div class="editable">
            <!-- de eerste keer bestaat er nog geen tekst, die moet dan worden aangemaakt op basis van de events -->
            <xsl:choose>
              <xsl:when test="key('text', @n)">
							<p class="debug">Existing text</p>
                <xsl:copy-of select="key('text', @n)"/>
              </xsl:when>
              <xsl:when test="key('clip', @n)">
							<p class="debug">New text</p>
                <xsl:apply-templates mode="initialize-text" select="key('clip', @n)"/>
              </xsl:when>
              <xsl:otherwise>
                <p class="placeholder">
                  <xsl:text>...</xsl:text>
                </p>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  
  
  
  
  <xsl:template match="e" mode="events-table">
    <tr>
      <td class="e-n">
        <xsl:value-of select="@n"/>
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
    </tr>
  </xsl:template>
  <!--
    <xsl:template mode="initialize-text" match="*">
      <p>Default template, n=<xsl:value-of select="@n"/></p>
    </xsl:template>
    -->
  <xsl:template match="e[@type='OUV-OPE']" mode="initialize-text">
    <xsl:choose>
      <xsl:when test="@lang='N'">
        <p c="{@clip}">Integraal verslag</p>
        <p c="{@clip}">Plenaire vergadering van <span class="incomplete">DATUM</span></p>
        <p c="{@clip}">
          <span class="incomplete">(Ochtendvergadering/Namiddagvergadering)</span>
        </p>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  
  
  
  
  
  
  
  <xsl:template match="e[@type='QA-AV'] | e[@type='QO-MV'] | e[@type='INT']" mode="initialize-text">
    <xsl:variable name="speaker" select="@speaker"/>
    <xsl:variable name="gov" select="@props"/>
    <xsl:variable name="lang" select="@lang"></xsl:variable>
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
        <xsl:when test="contains(preceding-sibling::*[contains(@type, 'VVGGC') or contains(@type, 'BHP')][1]/@type, 'BHP')">BHP</xsl:when>
        <xsl:otherwise>VVGGC</xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="@lang='N'">
        <p c="{@clip}">
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
        <p c="{@clip}">
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
        <p c="{@clip}">
          <xsl:text>betreffende "</xsl:text>
          <xsl:value-of select="@notes"/>
          <xsl:text>".</xsl:text>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}">
          <xsl:value-of select="$type-FR"/>
          
          <xsl:choose>
            <!--  test="$conf//p[@code=$speaker]/gender='M'" -->
            <xsl:when test="true()">M. </xsl:when>
            <xsl:otherwise>Mme</xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$conf//p[@code=$speaker]/name"/>
          
        </p>
        <p c="{@clip}">
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
        <p c="{@clip}">
          <xsl:text>concernant "</xsl:text>
          <xsl:value-of select="@notes"/>
          <xsl:text>".</xsl:text>
        </p>
        
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='EXC-AFW']" mode="initialize-text">
    <p c="{@clip}">VERONTSCHULDIGD</p>
    <p c="{@clip}">
      <xsl:choose>
        <xsl:when test="preceding-sibling::row[col_type='GEN-ALG'][1]/col_speaker='M'">
          <xsl:text>De voorzitter.- </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Mevrouw de voorzitter.- </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>Verontschuldigen zich voor hun afwezigheid:</xsl:text>
    </p>
    <p c="{@clip}">
      <span class="incomplete">Lijst van afwezigen</span>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='']" mode="initialize-text"> </xsl:template>
  <xsl:template match="e" mode="initialize-text">
    <p c="{@clip}">Unsupported event
		
      <!-- 
      <xsl:text>[</xsl:text><xsl:value-of select="@clip"/><xsl:text>]</xsl:text>
      -->
    </p>
    <!-- 
      <xsl:copy-of select="preceding-sibling::*[1]"/>
    -->
  </xsl:template>
</xsl:stylesheet>
