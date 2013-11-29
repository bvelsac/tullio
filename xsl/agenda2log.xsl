<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <title>Agenda <xsl:value-of select="/xml/data/info/meeting"/>
                </title>
            </head>
            <body>
                <h2>Agenda <xsl:value-of select="/xml/data/info/meeting"/>
                </h2>
                <div class="tableWrapper">
                    <table class="agenda" border="1">
                        <xsl:apply-templates select="//TR"/>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="TR">
        <xsl:variable name="type" select="TD[1]/@data-pants"/>
        <xsl:if test="normalize-space($type)">
            <tr class="agenda">
                <xsl:apply-templates/>
            </tr>
        </xsl:if>
        <xsl:if test="$type='QO-MV' or $type='INT' or $type='QA-DV'">
            <tr class="agenda">
                <td class="type">ORA-SPR</td>
                <td class="lang">
                    <xsl:value-of select="TD[2]/@data-pants"/>
                </td>
                <td class="subjectN"/>
                <td class="subjectF"/>
                <td class="short"/>
                <td class="speaker">
                    <xsl:value-of select="TD[6]"/>
                </td>
                <td class="gov"/>
            </tr>
        </xsl:if>
        <xsl:if test="$type='QO-MV JOINTE'">
            <tr class="agenda">
                <td class="type">ORA-J QO</td>
                <td class="lang">
                    <xsl:value-of select="TD[2]/@data-pants"/>
                </td>
                <td class="subjectN"/>
                <td class="subjectF"/>
                <td class="short"/>
                <td class="speaker">
                    <xsl:value-of select="TD[6]"/>
                </td>
                <td class="gov"/>
            </tr>
        </xsl:if>
        <xsl:if test="$type='QA-DV JOINTE'">
            <tr class="agenda">
                <td class="type">ORA-J QA</td>
                <td class="lang">
                    <xsl:value-of select="TD[2]/@data-pants"/>
                </td>
                <td class="subjectN"/>
                <td class="subjectF"/>
                <td class="short"/>
                <td class="speaker">
                    <xsl:value-of select="TD[6]"/>
                </td>
                <td class="gov"/>
            </tr>
        </xsl:if>
        <xsl:if test="$type='INT JOINTE'">
            <tr class="agenda">
                <td class="type">ORA-J INT</td>
                <td class="lang">
                    <xsl:value-of select="TD[2]/@data-pants"/>
                </td>
                <td class="subjectN"/>
                <td class="subjectF"/>
                <td class="short"/>
                <td class="speaker">
                    <xsl:value-of select="TD[6]"/>
                </td>
                <td class="gov"/>
            </tr>
        </xsl:if>
        <xsl:if test="( contains($type, 'INT') or contains($type, 'QO-MV') or contains($type, 'QA-DV') ) and not(contains($type, 'START'))">
            <xsl:call-template name="insertGov">
                <xsl:with-param name="lang" select="TD[2]/@data-pants"/>
            </xsl:call-template>
            
            
            
            <!-- 
		<tr class="agenda">
        <td class="ref"></td>
        <td class="type">ORA-SPR</td>
        <td class="lang"><xsl:value-of select="col_lang"/></td>
        <td class="subjectN"></td>
        <td class="subjectF"></td>
        <td class="short"></td>
        <td class="speaker"><xsl:value-of select="normalize-space(col_gov)"/></td>
        <td class="gov"></td>
      </tr>
		-->
            <tr class="agenda">
                <td class="type">INC</td>
                <td class="lang">
                    <xsl:value-of select="TD[2]/@data-pants"/>
                </td>
                <td class="subjectN"/>
                <td class="subjectF"/>
                <td class="short"/>
                <td class="speaker"/>
                <td class="gov"/>
            </tr>
        </xsl:if>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsName-event')]">
        <td class="type">
            <xsl:if test="not(normalize-space(@data-pants)='null')">
                <xsl:value-of select="@data-pants"/>
            </xsl:if>
        </td>
    </xsl:template>
    <xsl:template match="TD[contains(@class, 'keywords')]">
        <td class="short">
            <xsl:if test="not(normalize-space()='null' or normalize-space()='...')">
                <xsl:value-of select="."/>
            </xsl:if>
        </td>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsName-speaker')]">
        <td class="speaker">
            <xsl:if test="not(normalize-space()='null')">
                <xsl:value-of select="."/>
            </xsl:if>
        </td>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsName-gov')]">
        <td class="gov">
            <xsl:if test="normalize-space() and not(normalize-space()='null')">
                <xsl:for-each select="TAGS/TAG">
                    <xsl:value-of select="ID"/>
                    <xsl:if test="not(position()=last())">+</xsl:if>
                </xsl:for-each>
            </xsl:if>
        </td>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsName-lang')]">
        <td class="lang">
            <xsl:value-of select="@data-pants"/>
        </td>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsName-textn')]">
        <td class="subjectN">
            <xsl:if test="not(normalize-space()='null' or normalize-space()='...')">
                <xsl:value-of select="."/>
            </xsl:if>
        </td>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsName-textf')]">
        <td class="subjectF">
            <xsl:if test="not(normalize-space()='null' or normalize-space()='...')">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:if>
        </td>
    </xsl:template>
    <xsl:template match="*"/>
    <xsl:template name="insertGov">
        <xsl:param name="lang"/>
        <xsl:for-each select="TD/TAGS/TAG">
            <tr class="agenda">
                <td class="type">ORA-SPR</td>
                <td class="lang">
                    <xsl:value-of select="$lang"/>
                </td>
                <td class="subjectN"/>
                <td class="subjectF"/>
                <td class="short"/>
                <td class="speaker">
                    <xsl:value-of select="ID"/>
                </td>
                <td class="gov"/>
            </tr>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>