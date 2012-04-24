<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:template match="/">
    <table class="agenda" border="1">
      
      <xsl:apply-templates  select="//row"></xsl:apply-templates>
    </table>
    
    
    
    
    
  </xsl:template>
  
  <xsl:template match="row[string(col_type)]">
    <tr class="agenda">
      
      <xsl:apply-templates></xsl:apply-templates>
    </tr>
    
    <xsl:if test="string(col_type)='QO-MV' or string(col_type)='INT'">
      
      <tr class="agenda">
        <td class="ref"></td>
        <td class="type">ORA-SPR</td>
        <td class="lang"><xsl:value-of select="col_lang"/></td>
        <td class="subjectN"></td>
        <td class="subjectF"></td>
        <td class="short"></td>
        <td class="speaker"><xsl:value-of select="col_speaker"/></td>
        <td class="gov"></td>
      </tr>
    </xsl:if>
    
    <xsl:if test="string(col_type)='QO-MV JOINTE'">
      <tr class="agenda">
        <td class="ref"></td>
        <td class="type">ORA-SPR QJ</td>
        <td class="lang"><xsl:value-of select="col_lang"/></td>
        <td class="subjectN"></td>
        <td class="subjectF"></td>
        <td class="short"></td>
        <td class="speaker"><xsl:value-of select="col_speaker"/></td>
        <td class="gov"></td>
      </tr>
    </xsl:if>
    
    <xsl:if test="string(col_type)='INT JOINTE'">
      <tr class="agenda">
        <td class="ref"></td>
        <td class="type">ORA-SPR INT J</td>
        <td class="lang"><xsl:value-of select="col_lang"/></td>
        <td class="subjectN"></td>
        <td class="subjectF"></td>
        <td class="short"></td>
        <td class="speaker"><xsl:value-of select="col_speaker"/></td>
        <td class="gov"></td>
      </tr>
    </xsl:if>
    <xsl:if test="contains(col_type, 'INT') or contains(col_type, 'QO-MV')">
      <tr class="agenda">
        <td class="ref"></td>
        <td class="type">ORA-SPR</td>
        <td class="lang"><xsl:value-of select="col_lang"/></td>
        <td class="subjectN"></td>
        <td class="subjectF"></td>
        <td class="short"></td>
        <td class="speaker"></td>
        <td class="gov"><xsl:value-of select="col_gov"/></td>
      </tr>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template match="col_type">
    <td class="type">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
      
    </td>
  </xsl:template>
  
  <xsl:template match="col_short">
    <td class="short">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
    </td>
  </xsl:template>
  
  <xsl:template match="id">
    <td class="ref">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
    </td>
  </xsl:template>
  <xsl:template match="col_speaker">
    <td class="speaker">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
    </td>
  </xsl:template>
  
  <xsl:template match="col_gov">
    <td class="gov">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
    </td>
  </xsl:template>
  
  <xsl:template match="col_lang">
    <td class="lang">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
    </td>
  </xsl:template>
  <xsl:template match="col_textN">
    <td class="subjectN">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
    </td>
  </xsl:template>
  <xsl:template match="col_textF">
    <td class="subjectF">
      <xsl:if test="not(normalize-space()='null')">
        <xsl:value-of select="."/>  
      </xsl:if>
    </td>
  </xsl:template>
  
  
  <xsl:template match="*"></xsl:template>

</xsl:stylesheet>
