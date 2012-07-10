<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:template match="/">
	<html >
	
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Agenda <xsl:value-of select="/xml/data/info/meeting"/></title>
	</head>
	<body>
	<h2>Agenda <xsl:value-of select="/xml/data/info/meeting"/></h2>
	<div class="tableWrapper">
    <table class="agenda" border="1">
      
      <xsl:apply-templates  select="//row"></xsl:apply-templates>
    </table>
</div>
    </body>
    </html>
    
    
    
  </xsl:template>
  
  <xsl:template match="row[string(col_type)]">
    <tr class="agenda">
      
      <xsl:apply-templates></xsl:apply-templates>
    </tr>
    
    <xsl:if test="string(col_type)='QO-MV' or string(col_type)='INT' or string(col_type)='QA-DV'">
      
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
    
    <xsl:if test="string(col_type)='QO-MV JOINTE' or string(col_type)='QA-DV JOINTE'">
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
    <xsl:if test="( contains(col_type, 'INT') or contains(col_type, 'QO-MV') or contains(col_type, 'QA-DV') ) and not(contains(col_type, 'START'))">
    
		<xsl:call-template name='insertGov'>
		  <xsl:with-param name="nameString" select="normalize-space(col_gov)"></xsl:with-param>
		  <xsl:with-param name="lang" select="col_lang"></xsl:with-param>
		  
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
        <td class="ref"></td>
        <td class="type">INC</td>
        <td class="lang"><xsl:value-of select="col_lang"/></td>
        <td class="subjectN"></td>
        <td class="subjectF"></td>
        <td class="short"></td>
        <td class="speaker"></td>
        <td class="gov"></td>
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
	
	
	
	
	
	 <xsl:template name="insertGov">
    <xsl:param name="nameString"></xsl:param>
    <xsl:param name="lang"></xsl:param>
    <xsl:param name="counter" select="'1'"></xsl:param>
    <xsl:variable name="firstPart" >
      <xsl:choose>
        <xsl:when test="contains($nameString, ' ')">
          <xsl:value-of select="substring-before($nameString, ' ')"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$nameString"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
     

		
		
		      <tr class="agenda">
        <td class="ref"></td>
        <td class="type">ORA-SPR</td>
        <td class="lang"><xsl:value-of select="col_lang"/></td>
        <td class="subjectN"></td>
        <td class="subjectF"></td>
        <td class="short"></td>
        <td class="speaker"><xsl:value-of select="$firstPart"/></td>
        <td class="gov"></td>
      </tr>

		
    
    <xsl:choose>
      <xsl:when test="contains($nameString, ' ')">
        <xsl:call-template name="insertGov">
          <xsl:with-param name="nameString" select="substring-after($nameString, ' ')"></xsl:with-param>
          <xsl:with-param name="counter" select="counter+1"></xsl:with-param>
          <xsl:with-param name="lang" select="$lang"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>
	
	
	
	
	
	
	
	

</xsl:stylesheet>
