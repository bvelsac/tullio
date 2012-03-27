<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:template match="/">
    <table class="agenda" border="1">
      
      <xsl:apply-templates  select="//row"></xsl:apply-templates>
    </table>
    
    
    
    
    
  </xsl:template>
  
  <xsl:template match="row[string()]">
    <tr class="agenda">
      
      <xsl:apply-templates></xsl:apply-templates>
          </tr>    
    
  </xsl:template>
  
  <xsl:template match="col_type">
    <td class="type">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="col_short">
    <td class="short">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="id">
    <td class="ref">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  <xsl:template match="col_speaker">
    <td class="speaker">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="col_gov">
    <td class="gov">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="col_lang">
    <td class="lang">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  <xsl:template match="col_textN">
    <td class="subject-N">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  <xsl:template match="col_textF">
    <td class="subject-F">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  
  <xsl:template match="*"></xsl:template>

</xsl:stylesheet>
