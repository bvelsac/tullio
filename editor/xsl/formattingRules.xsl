<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="e" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="string(@type)">
        <xsl:choose>
          <xsl:when test="$lang='N'">
            <p c="{@clip}" title="{@n}" class="comment"><xsl:value-of select="@type"/>: (nog) geen macro, handmatig aanvullen.</p>
          </xsl:when>
          <xsl:otherwise><p c="{@clip}" title="{@n}" class="comment"><xsl:value-of select="@type"/>: pas (encore) de macro, à completer par le rédacteur.</p></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        
        <p c="{@clip}" title="{@n}" class="comment">Event <xsl:value-of select="@n"/>
          <xsl:if test="string(@notes)">, <xsl:value-of select="@notes"/></xsl:if>
        </p>    
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  
  <xsl:template match="e[@type='SUITE']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" title="{@n}" class="comment">Vervolg (zelfde spreker)</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" title="{@n}" class="comment">Suite (même orateur)</p>
      </xsl:when>
    </xsl:choose>
    
    
  </xsl:template>
  
  <xsl:template match="e[@type='PRES']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"></xsl:variable>
    <p c="{@clip}" title="{@n}" class="proc">
    <xsl:value-of select="key('snippets', concat('presi-', $lang))"/>
    <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
    <xsl:value-of select="$person/first"/>
    <xsl:text> </xsl:text>
      <xsl:value-of select="$person/last"/>,  <span class="incomplete">TITRE / TITEL</span>.
    </p>
  </xsl:template>
  
  <xsl:template match="e[@type='GEN-ALG']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    
    <p c="{@clip}" title="{@n}" class="title1" ><span class="incomplete">TITEL / TITRE</span></p>
    <xsl:if test="string(@notes)">
      <p c="{@clip}" title="{@n}" class="comment" ><xsl:value-of select="@notes"/></p>
      
    </xsl:if>
    
    
    <p c="{@clip}" title="{@n}" class="proc">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
      <xsl:text>...</xsl:text>
    </p>
  </xsl:template>
  
  <xsl:template match="e[@type='POINT']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:if test="string(@notes)">
      <p c="{@clip}" title="{@n}" class="comment" ><xsl:value-of select="@notes"/></p>
      
    </xsl:if>
    
    
    <p c="{@clip}" title="{@n}" class="proc">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
      <xsl:text>...</xsl:text>
    </p>
  </xsl:template>
  
  
  <xsl:template match="e[@type='CONT-N']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>    
    <p c="{@clip}" title="{@n}" class="realia">
      <xsl:value-of select="key('snippets', concat('contN-', $lang))"/>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='CONT-F']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>    
    <p c="{@clip}" title="{@n}" class="realia">
      <xsl:value-of select="key('snippets', concat('contF-', $lang))"/>
    </p>
  </xsl:template>
  
  
  <xsl:template match="e[@type='START-INT']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" title="{@n}" class="title1">
      <xsl:value-of select="key('snippets', concat('startInt-', $lang))"/>
    </p>
    <p c="{@clip}" title="{@n}" class="proc">
      <xsl:call-template name="president">
      <xsl:with-param name="event" select="."/>
      <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
      
      <xsl:value-of select="key('snippets', concat('startIntOrd-', $lang))"/>
    </p>
    
  </xsl:template>
  
  
  <xsl:template match="e[@type='OUV-OPE']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p class="front" c="{@clip}" title="{@n}">BRUSSELS HOOFDSTEDELIJK PARLEMENT</p>
        <p class="front"  c="{@clip}" title="{@n}">VERENIGDE VERGADERING VAN DE GEMEENSCHAPPELIJKE GEMEENSCHAPSCOMMISSIE</p>
        <p class="front" c="{@clip}" title="{@n}">Integraal verslag van de interpellaties en mondelinge vragen</p>
        <p class="front" c="{@clip}" title="{@n}" ><span class="incomplete">NAAM COMMISSIE</span></p>
        <p class="front" c="{@clip}" title="{@n}" ><span class="incomplete">VERGADERING VAN DAG XX MAAND 2012</span></p>
        <!-- 
        <p c="{@clip}" title="{@n}">Plenaire vergadering van <span class="incomplete">DATUM</span></p>
        <p c="{@clip}" title="{@n}">
          <span class="incomplete" title="{@n}">(Ochtendvergadering/Namiddagvergadering)</span>
        </p>
        -->
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}" title="{@n}">PARLEMENT DE LA RÉGION DE BRUXELLES-CAPITALE</p>
        <p c="{@clip}" title="{@n}">ASSEMBLÉE RÉUNIE DE LA COMMISSION COMMUNAUTAIRE COMMUNE</p>
        <p c="{@clip}" title="{@n}">Compte rendu intégral des interpellations et des questions orales</p>
        <p c="{@clip}" title="{@n}" class="incomplete">NOM DE LA COMMISSION</p>
        <p c="{@clip}" title="{@n}" class="incomplete">RÉUNION DU JOUR XX MOIS 2011</p>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="e[@type='O-BXL']" priority="5" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose >
      <xsl:when test="$lang='F'">
        <p c="{@clip}" title="{@n}" class="front">
          PARLEMENT DE LA RÉGION DE BRUXELLES-CAPITALE  
        </p>
        
        <p c="{@clip}" title="{@n}" class="front">
          Compte rendu intégral
        </p>
        <p c="{@clip}" title="{@n}" class="front">
          Séance plénière du 
        </p>
        <p c="{@clip}" title="{@n}" class="front">
          <span class="incomplete">VENDREDI XX MOIS 2011</span>
        </p>
        <p  c="{@clip}" title="{@n}" class="front">
          <span class="incomplete">(Séance de l'après-midi)/(Séance du matin)</span>
        </p>
        
        
      </xsl:when>
      <xsl:otherwise>
       
        <p c="{@clip}" title="{@n}" class="front">
          BRUSSELS HOOFDSTEDELIJK PARLEMENT  
          </p>
        
        <p c="{@clip}" title="{@n}" class="front">
          Integraal verslag
        </p>
        <p c="{@clip}" title="{@n}" class="front">
          Plenaire vergadering van
        </p>
        <p c="{@clip}" title="{@n}" class="front">
          <span class="incomplete">DAG XX MAAND JAAR</span>
        </p>
        <p  c="{@clip}" title="{@n}" class="front">
          <span class="incomplete">(Ochtendvergadering/Namiddagvergadering)</span>
        </p>
        
        
        
        
        
        
        
        
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="e[@type='QA-AV'] | e[@type='QO-MV'] | e[@type='INT']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <xsl:variable name="gov" select="key('people', normalize-space(@props))"/>
    <p>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <xsl:choose>
          <xsl:when test="@type='INT'">Interpellatie van </xsl:when>
          <xsl:when test="@type='QO-MV'">
            <xsl:text>Mondelinge vraag van </xsl:text>
          </xsl:when>
          <xsl:otherwise>Dringende vraag van </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <xsl:choose>
          <xsl:when test="@type='INT'">Interpellation de </xsl:when>
          <xsl:when test="@type='QO-MV'">
            <xsl:text>Question orale de </xsl:text>
          </xsl:when>
          <xsl:otherwise>Question d'actualité de </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
    <xsl:variable name="meeting-type" select="'BHP'"/>
    <!--<xsl:choose>
      <xsl:when
      test="contains(preceding-sibling::*[contains(@type, 'VVGGC') or contains(@type, 'BHP')][1]/@type, 'BHP')"
      >BHP</xsl:when>
      <xsl:otherwise>VVGGC</xsl:otherwise>
      </xsl:choose>-->
    <xsl:value-of select="key('snippets', concat('titleSmall-', $person/@gender, '-',  $lang))"/>
    <xsl:value-of select="$person/first"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$person/last"/>
    <xsl:value-of select="key('snippets', concat('to-', $lang))"/>
    <xsl:value-of select="key('snippets', concat('titleSmall-', $gov/@gender, '-',  $lang))"/>
    <xsl:value-of select="$gov/first"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$gov/last"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gov/ti[@l=$lang][@meeting-type=$meeting-type]"/>
    <xsl:text>,</xsl:text>
    </p>
    <p class="title4" c="{@clip}" title="{@n}">
      <xsl:value-of select="key('snippets', concat('concerning-', $lang))"/>
      <xsl:text> "</xsl:text>
      <xsl:choose>
        <xsl:when test="$lang='N'">
          <xsl:value-of select="@textN"/>
        </xsl:when>
        <xsl:when test="$lang='F'">
          <xsl:value-of select="@textF"/>
        </xsl:when>
      </xsl:choose>
      <xsl:text>".</xsl:text>
    </p>
    <!--<xsl:choose>
      <xsl:when test="$lang='N'">
      <p c="{@clip}" title="{@n}">
      <xsl:value-of select="$type-NL"/>
      <xsl:choose>
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
      </xsl:choose>-->
    <p c="{@clip}" class="write" title="{@n}">...</p>
  </xsl:template>
  <xsl:template name="president">
    <xsl:param name="class" select="'pres'"/>
    <xsl:param name="segment"/>
    <xsl:param name="event"/>
    <xsl:param name="lang" select="$event/@lang"/>
    <!--<xsl:text>debug</xsl:text><xsl:value-of select="$lang"/>-->
    <!--<xsl:comment>
      <xsl:value-of
      select="concat('pres-', preceding-sibling::e[pres][1]/pres/person/@gender, '-', @lang)"/>
      </xsl:comment>-->
    <xsl:variable name="pres-gender">
      <xsl:choose>
<!--        <xsl:when test="$event/preceding-sibling::e[pres]">
          <xsl:value-of select="$event/preceding-sibling::e[pres][1]/pres/person/@gender"/>
        </xsl:when>
-->        <xsl:when test="$event/preceding-sibling::e[@type='PRES' or @type='PRES-CH']">
          <xsl:value-of
            select="key('people', $event/preceding-sibling::e[@type='PRES' or @type='PRES-CH'][1]/@speaker)/@gender"/>
        </xsl:when>
        <!--
          <xsl:when test="/all/pres">
          <xsl:value-of select="key('people', /all/info/pres/@id)/@gender"/>
          </xsl:when>
        -->
        <xsl:when test="/container/info/pres/person">
          <xsl:value-of select="/container/info/pres/person/@gender"/>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:value-of select="key('people', /all/variables/pres)/@gender"/>
          <!--
            <xsl:value-of select="/container/info/pres/person/@gender"/>
          -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <span class="{$class} reformat pres" title="{$event/@n}" href="#">
      <xsl:if test="string($segment)">
        <xsl:attribute name="segment">
          <xsl:value-of select="$segment"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="key('snippets', concat('pres-', $pres-gender, '-', $lang))">
          <xsl:value-of select="key('snippets', concat('pres-', $pres-gender, '-', $lang))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>.-</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  <xsl:template match="e[@type='NEW']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    
    <p c="{@clip}">
      <span class="speaker" title="{@n}" ><xsl:value-of
        select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/><xsl:value-of
          select="$person/first"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$person/last"/></span> 
      <xsl:text>.-</xsl:text>
    </p>
  </xsl:template>
  
  
  
  
  
  
  <xsl:template match="e[@type='ORA-SPR']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <p c="{@clip}" title="{@n}" class="proc">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$lang='F'">
          <xsl:value-of select="key('snippets', concat('parole-', $lang))"/>
          <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
          <xsl:value-of select="$person/first"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$person/last"/>.
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
          <xsl:value-of select="$person/first"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$person/last"/>
          <xsl:value-of select="key('snippets', concat('parole-', $lang))"/>.
        </xsl:otherwise>
      </xsl:choose>
    </p>
    
    <p c="{@clip}">
      <span class="speaker" title="{@n}"><xsl:value-of
          select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/><xsl:value-of
          select="$person/first"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$person/last"/></span>
      <xsl:text>.- </xsl:text>
      
    </p>

  </xsl:template>
  <xsl:template match="e[@type='EXC-AFW']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" title="{@n}" class="title1">Verontschuldigd</p>
    <p c="{@clip}" title="{@n}" class="proc">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
      <span class="incomplete"><xsl:value-of select="key('snippets', concat('exc-', $lang))"/></span>
      
    </p>
    <p c="{@clip}" class="proc">
      <span class="incomplete">Lijst van afwezigen</span>
    </p>
  </xsl:template>
<!--  <xsl:template match="e[@type='']" mode="initialize-text">
    <p c="{@clip}" class="debug" title="{@n}">Event type missing</p>
  </xsl:template>-->
  <xsl:template match="e[@type='marker']" mode="initialize-text">
    <p c="{@clip}" class="comment" title="{@n}">Start clip <xsl:value-of select="@n"/></p>

  </xsl:template>

  
  
  <!-- Code for formatted events overview table -->
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
  
</xsl:stylesheet>
