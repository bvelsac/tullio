<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="e" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="string(@type)">
        <xsl:choose>
          <xsl:when test="$lang='N'">
            <p c="{@clip}" class="comment" title="{@n}"><xsl:value-of select="@type"/>: (nog) geen
              macro, handmatig aanvullen.</p>
          </xsl:when>
          <xsl:otherwise>
            <p c="{@clip}" class="comment" title="{@n}"><xsl:value-of select="@type"/>: pas (encore)
              de macro, à completer par le rédacteur.</p>
          </xsl:otherwise>
        </xsl:choose>
        <p c="{@clip}" title="{@n}">...</p>
      </xsl:when>
      <xsl:when test="string(@notes)">
        <p c="{@clip}" class="comment" title="{@n}">
          <xsl:value-of select="@notes"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <!-- don't generate text, this event is not useful -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='INC']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}">...</p>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" class="realia" title="{@n}">- Het incident is gesloten.</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="realia" title="{@n}">- L'incident est clos.</p>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='INC2']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}">...</p>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" class="realia" title="{@n}">- De incidenten zijn gesloten.</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="realia" title="{@n}">- Les incidents sont clos.</p>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='SUITE']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <!-- 
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" title="{@n}" class="comment">Vervolg (zelfde spreker)</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" title="{@n}" class="comment">Suite (même orateur)</p>
      </xsl:when>
    </xsl:choose>
    -->
    <p c="{@clip}">...</p>
  </xsl:template>
  <xsl:template match="e[@type='PRES']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <xsl:choose>
      <xsl:when test="$meeting-type='PFB'">
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:text>Présidence de </xsl:text>
          <xsl:value-of select="key('snippets', concat('titleSmall-', $person/@gender, '-',
            $lang))"/>
          <xsl:value-of select="$person/first"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$person/last"/>, <span class="incomplete">TITRE / TITEL</span>
        </p>
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:text>La séance plénière est ouverte à </xsl:text>
          <span class="incomplete">XXhXX.</span>
        </p>
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:call-template name="president">
            <xsl:with-param name="meeting-type" select="$meeting-type"/>
            <xsl:with-param name="event" select="."/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
          <xsl:text> Mesdames et Messieurs, la séance plénière est ouverte.</xsl:text>
        </p>
        
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:value-of select="key('snippets', concat('presi-', $lang))"/>
          <xsl:value-of select="key('snippets', concat('titleSmall-', $person/@gender, '-',
            $lang))"/>
          <xsl:value-of select="$person/first"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$person/last"/>, <span class="incomplete">TITRE / TITEL</span>. </p>
        <xsl:variable name="precType" select="preceding-sibling::e[1]/@type"/>
        <xsl:if test="$precType='O-BXL' or $precType='O-ARVV'">
          <xsl:choose>
            <xsl:when test="$lang = 'N'">
              <p c="{@clip}" class="realia">- De vergadering wordt geopend om X.XX uur.</p>
            </xsl:when>
            <xsl:otherwise>
              <p c="{@clip}" class="realia">- La séance est ouverte à XhXX.</p>
            </xsl:otherwise>
          </xsl:choose>
          <p c="{@clip}" class="proc" title="{@n}">
            <xsl:call-template name="president">
              <xsl:with-param name="meeting-type" select="$meeting-type"/>
              <xsl:with-param name="event" select="."/>
              <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
            <xsl:choose>
              <xsl:when test="$lang='N' and $precType='O-BXL'"> Ik verklaar de plenaire vergadering
                van het Brussels Hoofdstedelijk Parlement van vrijdag XX maand 2013
                geopend.</xsl:when>
              <xsl:when test="$lang='F' and $precType='O-BXL'"> Je déclare ouverte la séance
                plénière du parlement de la Région de Bruxelles-Capitale du vendredi XX mois
                2011.</xsl:when>
              <xsl:when test="$lang='N' and $precType='O-ARVV'"> Ik verklaar de plenaire vergadering
                van de Verenigde Vergadering van de Gemeenschappelijke Gemeenschapscommissie van
                vrijdag XX maand 2011 geopend.</xsl:when>
              <xsl:when test="$lang='F' and $precType='O-ARVV'"> Je déclare ouverte la séance
                plénière de l'Assemblée réunie de la Commission communautaire commune du vendredi XX
                mois 2011.</xsl:when>
            </xsl:choose>
          </p>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='PRES-CH']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <p c="{@clip}" class="realia" title="{@n}"> (<xsl:value-of select="key('snippets',
        concat('title-', $person/@gender, '-',  $lang))"/>
      <xsl:value-of select="$person/first"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$person/last"/>, <span class="incomplete">TITRE / TITEL</span>, <xsl:choose>
        <xsl:when test="$lang='N'"> treedt <span class="incomplete">opnieuw</span> als voorzitter
          op)</xsl:when>
        <xsl:when test="$lang='F'">
          <span class="incomplete">reprend</span> place au fauteuil présidentiel)</xsl:when>
      </xsl:choose>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='GEN-ALG']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <!-- 
    <xsl:if test="string(@notes)">
      <p c="{@clip}" title="{@n}" class="comment" ><xsl:value-of select="@notes"/></p>
      
    </xsl:if>
    -->
    <p c="{@clip}" class="title1" title="{@n}">
      <xsl:variable name="subject" select="string(@*[name()=concat('text', translate($lang, 'FN', 'fn')) or name()=concat('text', $lang)])"/>
      <xsl:choose>
        <xsl:when test="string($subject)">
          <xsl:value-of select="$subject"/>
        </xsl:when>
        <xsl:otherwise>
          <span class="incomplete">TITEL / TITRE</span>
        </xsl:otherwise>
      </xsl:choose>
    </p>
    <p c="{@clip}" class="proc" title="{@n}">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="meeting-type" select="$meeting-type"/>
      </xsl:call-template>
      <xsl:text>...</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='POINT']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" class="proc" title="{@n}">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="meeting-type" select="$meeting-type"/>
      </xsl:call-template>
      <xsl:text>...</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='CONT-N']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" class="realia" title="{@n}">
      <xsl:value-of select="key('snippets', concat('contN-', $lang))"/>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='CONT-F']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" class="realia" title="{@n}">
      <xsl:value-of select="key('snippets', concat('contF-', $lang))"/>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='START-INT']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" class="title1" title="{@n}">
      <xsl:value-of select="key('snippets', concat('startInt-', $lang))"/>
    </p>
    <p c="{@clip}" class="proc" title="{@n}">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="meeting-type" select="$meeting-type"/>
      </xsl:call-template>
      <xsl:value-of select="key('snippets', concat('startIntOrd-', $lang))"/>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='START-MV']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" class="title1" title="{@n}">
      <xsl:value-of select="key('snippets', concat('startMV-', $lang))"/>
    </p>
    <p c="{@clip}" class="proc" title="{@n}">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="meeting-type" select="$meeting-type"/>
      </xsl:call-template>
      <xsl:value-of select="key('snippets', concat('startMVOrd-', $lang))"/>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='START-DV']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <p c="{@clip}" class="title1" title="{@n}">
      <xsl:value-of select="key('snippets', concat('startDV-', $lang))"/>
    </p>
    <p c="{@clip}" class="proc" title="{@n}">
      <xsl:call-template name="president">
        <xsl:with-param name="event" select="."/>
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="meeting-type" select="$meeting-type"/>
      </xsl:call-template>
      <xsl:value-of select="key('snippets', concat('startDVOrd-', $lang))"/>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='OUV-OPE']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$meeting-type='PFB'">
        <p c="{@clip}" class="front" title="{@n}">PARLEMENT FRANCOPHONE BRUXELLOIS</p>
        <p c="{@clip}" class="front" title="{@n}">(Assemblée de la Commission communautaire française)</p>
        <p c="{@clip}" class="front" title="{@n}">Session 2012-2013</p>
        <p c="{@clip}" class="front" title="{@n}">Séance plénière du vendredi XX XX 2013</p>
        <p c="{@clip}" class="front" title="{@n}">Compte rendu</p>
        
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$lang='N'">
            <p c="{@clip}" class="front" title="{@n}">BRUSSELS HOOFDSTEDELIJK PARLEMENT</p>
            <p c="{@clip}" class="front" title="{@n}">VERENIGDE VERGADERING VAN DE
              GEMEENSCHAPPELIJKE GEMEENSCHAPSCOMMISSIE</p>
            <p c="{@clip}" class="front" title="{@n}">Integraal verslag van de interpellaties en
              mondelinge vragen</p>
            <p c="{@clip}" class="front" title="{@n}">
              <span class="incomplete">Commissie voor de Financiën, Begroting, Openbaar Ambt,
                Externe Betrekkingen en Algemene Zaken / Commissie voor de Infrastructuur, belast
                met Openbare Werken en Verkeerswezen / Commissie voor de Ruimtelijke Ordening, de
                Stedenbouw en het Grondbeleid / Commissie voor de Huisvesting en Stadsvernieuwing /
                Commissie voor Leefmilieu, Natuurbehoud, Waterbeleid en Energie / Commissie voor
                Binnenlandse Zaken, belast met de Lokale Besturen en de Agglomeratiebevoegdheden /
                Commissie voor de Economische Zaken, belast met het Economisch Beleid, het
                Werkgelegenheidsbeleid en het Wetenschappelijk Onderzoek / Commissie voor de
                Gezondheid of Commissie voor de Sociale Zaken / Verenigde commissies voor de
                Gezondheid en Sociale Zaken</span>
            </p>
            <p c="{@clip}" class="front" title="{@n}">
              <span class="incomplete">VERGADERING VAN DAG XX MAAND 2013</span>
            </p>
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
            <p c="{@clip}" title="{@n}">Compte rendu intégral des interpellations et des questions
              orales</p>
            <p c="{@clip}" class="incomplete" title="{@n}">Commission des Finances, du Budget, de la
              Fonction publique, des Relations extérieures et des Affaires générales / Commission de
              l'Infrastructure, chargée des Travaux publics et des Communications / Commission de
              l'Aménagement du territoire, de l'Urbanisme et de la Politique foncière / Commission
              du Logement et de la Rénovation urbaine / Commission de l'Environnement, de la
              Conservation de la Nature, de la Politique de l'Eau et de l'Énergie / Commission des
              Affaires intérieures, chargée des Pouvoirs locaux et des Compétences d'Agglomération /
              Commission des Affaires économiques, chargée de la Politique économique, de la
              Politique de l'Emploi et de la Recherche scientifique / Commission de la Santé /
              Commission des Affaires sociales / Commissions réunies de la Santé et des Affaires
              sociales </p>
            <p c="{@clip}" class="incomplete" title="{@n}">RÉUNION DU JOUR XX MOIS 2013</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='O-BXL' or @type='O-ARVV']" mode="initialize-text" priority="5">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="front" title="{@n}">
          <xsl:choose>
            <xsl:when test="@type='O-BXL'">PARLEMENT DE LA RÉGION DE BRUXELLES-CAPITALE</xsl:when>
            <xsl:otherwise>ASSEMBLÉE RÉUNIE DE LA COMMISSION COMMUNAUTAIRE COMMUNE</xsl:otherwise>
          </xsl:choose>
        </p>
        <p c="{@clip}" class="front" title="{@n}"> Compte rendu intégral </p>
        <p c="{@clip}" class="front" title="{@n}"> Séance plénière du </p>
        <p c="{@clip}" class="front" title="{@n}">
          <span class="incomplete">JOUR XX MOIS 2013</span>
        </p>
        <p c="{@clip}" class="front" title="{@n}">
          <span class="incomplete">(Séance de l'après-midi)/(Séance du matin)</span>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}" class="front" title="{@n}">
          <xsl:choose>
            <xsl:when test="@type='O-BXL'">BRUSSELS HOOFDSTEDELIJK PARLEMENT</xsl:when>
            <xsl:otherwise>VERENIGDE VERGADERING VAN DE GEMEENSCHAPPELIJKE
              GEMEENSCHAPSCOMMISSIE</xsl:otherwise>
          </xsl:choose>
        </p>
        <p c="{@clip}" class="front" title="{@n}"> Integraal verslag </p>
        <p c="{@clip}" class="front" title="{@n}"> Plenaire vergadering van </p>
        <p c="{@clip}" class="front" title="{@n}">
          <span class="incomplete">DAG XX MAAND JAAR</span>
        </p>
        <p c="{@clip}" class="front" title="{@n}">
          <span class="incomplete">(Ochtendvergadering/Namiddagvergadering)</span>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="insertGov">
    <xsl:param name="meeting-type"/>
    <xsl:param name="nameString"/>
    <xsl:param name="lang"/>
    <xsl:param name="counter" select="'1'"/>
    <xsl:variable name="firstPart">
      <xsl:choose>
        <xsl:when test="contains($nameString, '+')">
          <xsl:value-of select="substring-before($nameString, '+')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nameString"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="gov" select="key('people', $firstPart)"/>
    <p c="{@clip}" class="title4" title="{@n}">
      <!-- 
      <xsl:value-of select="$nameString"/>
      <xsl:value-of select="$firstPart"/>
      -->
      <xsl:choose>
        <xsl:when test="$counter = 1">
          <xsl:choose>
            <xsl:when test="@type='INT' and $lang='N'">tot </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="key('snippets', concat('to-', $lang))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="@type='INT' and $lang='N'">en tot </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="key('snippets', concat('toExtra-', $lang))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="key('snippets', concat('titleSmall-', $gov/@gender, '-',  $lang))"/>
      <xsl:value-of select="$gov/first"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$gov/last"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="$gov/ti[@l=$lang][@meeting-type=$meeting-type]"/>
      <xsl:text>,</xsl:text>
      <xsl:choose>
        <xsl:when test="contains($nameString, '+') and normalize-space(substring-after($nameString,
          '+'))">
          <xsl:call-template name="insertGov">
            <xsl:with-param name="nameString" select="substring-after($nameString, '+')"/>
            <xsl:with-param name="counter" select="counter+1"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="meeting-type" select="$meeting-type"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='QA-DV'] | e[@type='QO-MV'] | e[@type='INT'] | e[@type='INT JOINTE']
    | e[@type='QO-MV JOINTE'] | e[@type='QA-DV JOINTE']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <p c="{@clip}" class="title4" title="{@n}">
      <xsl:choose>
        <xsl:when test="$lang='N'">
          <xsl:choose>
            <xsl:when test="@type='INT JOINTE'">Toegevoegde interpellatie van </xsl:when>
            <xsl:when test="@type='QO-MV JOINTE'">Toegevoegde mondelinge vraag van </xsl:when>
            <xsl:when test="@type='QA-DV JOINTE'">Toegevoegde dringende vraag van </xsl:when>
            <xsl:when test="@type='INT'">Interpellatie van </xsl:when>
            <xsl:when test="@type='QO-MV'">
              <xsl:text>Mondelinge vraag van </xsl:text>
            </xsl:when>
            <xsl:otherwise>Dringende vraag van </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$lang='F'">
          <xsl:choose>
            <xsl:when test="@type='INT JOINTE'">Interpellation jointe de </xsl:when>
            <xsl:when test="@type='QO-MV JOINTE'">Question orale jointe de </xsl:when>
            <xsl:when test="@type='QA-DV JOINTE'">Question d'actualité jointe de </xsl:when>
            <xsl:when test="@type='INT'">Interpellation de </xsl:when>
            <xsl:when test="@type='QO-MV'">
              <xsl:text>Question orale de </xsl:text>
            </xsl:when>
            <xsl:otherwise>Question d'actualité de </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="key('snippets', concat('titleSmall-', $person/@gender, '-',  $lang))"/>
      <xsl:value-of select="$person/first"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$person/last"/>
      <xsl:if test="contains(@type, 'JOINTE')">,</xsl:if>
    </p>
    <!-- more than one member of governement might be addressed -->
    <xsl:if test="not(contains(@type, 'JOINTE'))">
      <xsl:call-template name="insertGov">
        <xsl:with-param name="nameString" select="normalize-space(@props)"/>
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="meeting-type" select="$meeting-type"/>
      </xsl:call-template>
    </xsl:if>
    <p c="{@clip}" class="title4" title="{@n}">
      <xsl:value-of select="key('snippets', concat('concerning-', $lang))"/>
      <xsl:text> "</xsl:text>
      <xsl:choose>
        <xsl:when test="$lang='N'">
          <xsl:value-of select="@textN"/>
          <xsl:value-of select="@textn"/>
        </xsl:when>
        <xsl:when test="$lang='F'">
          <xsl:value-of select="@textF"/>
          <xsl:value-of select="@textf"/>
        </xsl:when>
      </xsl:choose>
      <xsl:text>".</xsl:text>
    </p>
    <p c="{@clip}" class="write" title="{@n}">...</p>
  </xsl:template>
  <xsl:template name="president">
    <xsl:param name="meeting-type"/>
    <xsl:param name="class" select="'pres'"/>
    <xsl:param name="segment"/>
    <xsl:param name="event"/>
    <xsl:param name="reformat"/>
    <xsl:param name="lang" select="$event/@lang"/>
    <xsl:param name="clipId"></xsl:param>
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
-->
        <xsl:when test="$event/self::e[@type='PRES' or @type='PRES-CH']">
          <xsl:value-of select="key('people', $event/self::e[@type='PRES' or
            @type='PRES-CH']/@speaker)/@gender"/>
        </xsl:when>
        <xsl:when test="$event/preceding-sibling::e[@type='PRES' or @type='PRES-CH']">
          <xsl:value-of select="key('people', $event/preceding-sibling::e[@type='PRES' or
            @type='PRES-CH'][1]/@speaker)/@gender"/>
        </xsl:when>
        <xsl:when test="key('all', $clipId)/self::e[@type='PRES' or @type='PRES-CH']">
          <xsl:value-of select="key('people', key('all', $clipId)/self::e[@type='PRES' or
            @type='PRES-CH']/@speaker)/@gender"/>
        </xsl:when>
        <xsl:when test="key('all', $clipId)/preceding-sibling::e[@type='PRES' or @type='PRES-CH']">
          <xsl:value-of select="key('people', key('all', $clipId)/preceding-sibling::e[@type='PRES' or
            @type='PRES-CH'][1]/@speaker)/@gender"/>
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
    <!--<xsl:text>debug</xsl:text>
    <xsl:value-of select="$clipId"/>
    <xsl:value-of select="$pres-gender"/>-->
    <xsl:choose>
      <xsl:when test="$meeting-type='PFB'">
        <span class="{$class} reformat pres" href="#" title="{$event/@n}">
          <xsl:if test="string($segment)">
            <xsl:attribute name="segment">
              <xsl:value-of select="$segment"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$pres-gender='m'">M. le président</xsl:when>
            <xsl:otherwise>Mme la présidente</xsl:otherwise>
          </xsl:choose>
        </span>
        <xsl:text>.- </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <span class="{$class} reformat pres" href="#" title="{$event/@n}">
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
              <xsl:text>PRES </xsl:text>
              <xsl:value-of select="concat('pres-', $pres-gender, '-', $lang, '-', $event/@n, '-', $clipId)"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
        <xsl:if test="not($reformat='true')">
          <xsl:text>.- </xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ZAAL-APP	
Applaudissements
	
Applaus
ZAAL-GLIM	
Sourires
	
Vrolijkheid
ZAAL-OPM	
Opmerkingen
	
Opmerkingen
ZAAL-RUM	
Rumeurs
	
Rumoer
ZAAL-SS	
Colloques
	
Samenspraak -->
  <xsl:template match="e[@type='ZAAL-APP']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" class="realia" title="{@n}">(Applaus)</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="realia" title="{@n}">(Applaudissements)</p>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="string(@notes)">
      <p c="{@clip}" class="comment">
        <xsl:value-of select="@notes"/>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="e[@type='ZAAL-GLIM']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" class="realia" title="{@n}">(Vrolijkheid)</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="realia" title="{@n}">(Sourires)</p>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="string(@notes)">
      <p c="{@clip}" class="comment">
        <xsl:value-of select="@notes"/>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="e[@type='ZAAL-OPM']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" class="realia" title="{@n}">(Opmerkingen)</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="realia" title="{@n}">(Remarques)</p>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="string(@notes)">
      <p c="{@clip}" class="comment">
        <xsl:value-of select="@notes"/>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="e[@type='ZAAL-RUM']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" class="realia" title="{@n}">(Rumoer)</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="realia" title="{@n}">(Rumeurs)</p>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="string(@notes)">
      <p c="{@clip}" class="comment">
        <xsl:value-of select="@notes"/>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="e[@type='ZAAL-SS']" mode="initialize-text">
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$lang='N'">
        <p c="{@clip}" class="realia" title="{@n}">(Samenspraak)</p>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <p c="{@clip}" class="realia" title="{@n}">(Colloques)</p>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="string(@notes)">
      <p c="{@clip}" class="comment">
        <xsl:value-of select="@notes"/>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="e[@type='NEW']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <p c="{@clip}">
      <span class="speaker" title="{@n}">
        <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
        <xsl:value-of select="$person/first"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$person/last"/>
        <xsl:choose>
          <xsl:when test="$person/@gov='yes'">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$person/short[@l=$lang][@meeting-type=$meeting-type]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$meeting-type='PFB'">
              <xsl:value-of select="concat(' (', $person/@group, ')')"/>
            </xsl:if>
            <!--  -->
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <xsl:text>.- </xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="e[@type='COMM-MED']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <xsl:choose>
      <xsl:when test="$meeting-type='PFB'">
        <p c="{@clip}" class="title1">Communications</p>
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}">
          <span class="speaker" title="{@n}">
            <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
            <xsl:value-of select="$person/first"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$person/last"/>
          </span>
          <xsl:text>.-</xsl:text>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='ORA-J QO'] | e[@type='ORA-J QA'] | e[@type='ORA-J INT'] |
    e[@type='ORA-SPR']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:variable name="person" select="key('people', @speaker)"/>
    <!-- <p >DEBUG <xsl:value-of select="$meeting-type"/>   MT <xsl:value-of select="@type"/> 
      prev
      <xsl:for-each select="preceding-sibling::e">
        <xsl:value-of select="@n"/>, 
      </xsl:for-each>
       </p>
    -->
    <xsl:choose>
      <!-- <xsl:when test="$meeting-type='PFB'"> -->
      <xsl:when test="false()">
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:call-template name="president">
            <xsl:with-param name="meeting-type" select="$meeting-type"/>
            <xsl:with-param name="event" select="."/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
          <xsl:text> La parole est à </xsl:text>
          <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$person/last"/>
          <xsl:choose>
            <xsl:when test="$person/@gov='yes'">
              <xsl:text>, </xsl:text>
              <span class="incomplete">(fonction à compléter)</span>
              <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>.</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </p>
        <p c="{@clip}">
          <span class="speaker" title="{@n}">
            <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
            <xsl:value-of select="$person/first"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$person/last"/>
            <xsl:choose>
              <xsl:when test="$person/@gov='yes'">
                <xsl:text>, </xsl:text>
                <span class="incomplete">
                  <xsl:value-of select="$person/ti[@l=$lang][@meeting-type=$meeting-type]"/>
                </span>
                <xsl:text>.</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(' (', $person/@group, ')')"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
          <xsl:text>.- </xsl:text>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:call-template name="president">
            <xsl:with-param name="meeting-type" select="$meeting-type"/>
            <xsl:with-param name="event" select="."/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
          <xsl:choose>
            <xsl:when test="$lang='F'">
              <xsl:value-of select="key('snippets', concat('parole-', $lang))"/>
              <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
              <xsl:value-of select="$person/last"/>
              <xsl:choose>
                <xsl:when test="@type='ORA-J QO'">
                  <xsl:text> pour sa question orale jointe</xsl:text>
                </xsl:when>
                <xsl:when test="@type='ORA-J QA'">
                  <xsl:text> pour sa question d'actualité jointe</xsl:text>
                </xsl:when>
                <xsl:when test="@type='ORA-J INT'">
                  <xsl:text> pour son interpellation jointe</xsl:text>
                </xsl:when>
              </xsl:choose>
              <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
              <xsl:value-of select="$person/last"/>
              <xsl:value-of select="key('snippets', concat('parole-', $lang))"/>
              <xsl:choose>
                <xsl:when test="contains(@type, 'ORA-J')">
                  <xsl:text> voor </xsl:text>
                  <xsl:value-of select="key('snippets', concat('zijnhaar-', $person/@gender))"/>
                  <xsl:text> </xsl:text>
                  <xsl:choose>
                    <xsl:when test="@type='ORA-J QA'">
                      <xsl:text>toegevoegde dringende vraag</xsl:text>
                    </xsl:when>
                    <xsl:when test="@type='ORA-J QO'">
                      <xsl:text>toegevoegde mondelinge vraag</xsl:text>
                    </xsl:when>
                    <xsl:when test="@type='ORA-J INT'">
                      <xsl:text>toegevoegde interpellatie</xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
              <xsl:text>.</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </p>
        <p c="{@clip}">
          <span class="speaker" title="{@n}">
            <xsl:value-of select="key('snippets', concat('title-', $person/@gender, '-',  $lang))"/>
            <xsl:value-of select="$person/first"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$person/last"/>
            
            <xsl:choose>
              <xsl:when test="$person/@gov='yes'">
                <xsl:text>, </xsl:text>
                
                  <xsl:value-of select="$person/short[@l=$lang][@meeting-type=$meeting-type]"/>
                
                <xsl:text></xsl:text>
              </xsl:when>
              <xsl:when test="$meeting-type='PFB'"> 
                
                <xsl:value-of select="concat(' (', $person/@group, ')')"/>
              </xsl:when>
            </xsl:choose>
            
           
          </span>
          <xsl:text>.- </xsl:text>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="e[@type='EXC-AFW']" mode="initialize-text">
    <xsl:param name="meeting-type"/>
    <xsl:param name="lang" select="@lang"/>
    <xsl:choose>
      <xsl:when test="$meeting-type='PFB'">
        <p c="{@clip}" class="title1" title="{@n}">Excusés</p>
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:call-template name="president">
            <xsl:with-param name="meeting-type" select="$meeting-type"/>
            <xsl:with-param name="event" select="."/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
          <span class="incomplete">Ont prié d'excuser leur absence :</span>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p c="{@clip}" class="title1" title="{@n}">Verontschuldigd</p>
        <p c="{@clip}" class="proc" title="{@n}">
          <xsl:call-template name="president">
            <xsl:with-param name="meeting-type" select="$meeting-type"/>
            <xsl:with-param name="event" select="."/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
          <span class="incomplete">
            <xsl:value-of select="key('snippets', concat('exc-', $lang))"/>
          </span>
        </p>
        <p c="{@clip}" class="proc">
          <span class="incomplete">Lijst van afwezigen</span>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--  <xsl:template match="e[@type='']" mode="initialize-text">
    <p c="{@clip}" class="debug" title="{@n}">Event type missing</p>
  </xsl:template>-->
  <xsl:template match="e[@type='marker']" mode="initialize-text">
    <!--  <p c="{@clip}" class="comment" title="{@n}">Start clip <xsl:value-of select="@n"/></p> -->
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
        <xsl:choose>
          <xsl:when test="@lang='N'">
            <xsl:choose>
              <xsl:when test="string(key('eventNames', @type)/name[@lang='nl'])">
                <xsl:value-of select="key('eventNames', @type)/name[@lang='nl']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@type"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="string(key('eventNames', @type)/name[@lang='fr'])">
                <xsl:value-of select="key('eventNames', @type)/name[@lang='fr']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@type"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="e-speaker">
        <xsl:value-of select="key('people', @speaker)/last"/>
        <xsl:if test="string(@notes) and string(@speaker)">, </xsl:if>
        <xsl:value-of select="@notes"/>
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
