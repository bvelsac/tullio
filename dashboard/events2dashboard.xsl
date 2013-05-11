<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
   
    <xsl:template match="/">
        
  
  
  
        <div id="dashboard">
            <div id="stats">
                <ul>
                    <li>Clips: <xsl:value-of select="count(//e[@c='true'])"/></li>
                    <li>F: <xsl:value-of select="count(//e[@c='true'][@lang='F'])"/></li>
                    <li>N: <xsl:value-of select="count(//e[@c='true'][@lang='N'])"/></li>
                </ul>
            </div>
            <div id="listing">
            
            
<table>
    <xsl:apply-templates select="//e"></xsl:apply-templates>
    
    
</table>  
         
            
            
            </div>
            
            
            
        </div>
        
        
    </xsl:template>
    
    
    
    <xsl:template match="e">
        
        <xsl:variable name="error">
            <xsl:if test="@type='INT' or @type='INT JOINTE' or @type='QA-DV' or @type='QA-DV JOINTE' or @type='QO-MV' or @type='QO-MV'">
                <xsl:if test="not(string(@speaker))">no speaker found</xsl:if>
            </xsl:if>
            <xsl:if test=" @type='PRES' or @type='PRES-CH'">
                <xsl:if test="not(string(@speaker))">no name of president found</xsl:if>
            </xsl:if>
            
            <xsl:if test="normalize-space(@speaker)">
                    <xsl:if test="not(@speaker=//reference/person/@id)">name not found</xsl:if>
            </xsl:if>
            
            
            
            
            
            
        </xsl:variable>
        
        
    <tr >
        <xsl:attribute name="class">
            <xsl:value-of select="@type"/>
            <xsl:if test="string($error)"> error</xsl:if>
        </xsl:attribute>
        
        <td class="n"><xsl:value-of select="@n"/></td>
       
        <td class="lang {@lang}"><xsl:value-of select="@lang"/></td>
        <td class="type {@type}"><xsl:value-of select="@type"/></td>
        <td class="person"><xsl:value-of select="@speaker"/></td>
        
        <td class="comment"><xsl:value-of select="@notes"/></td>
        <td class="time"><xsl:value-of select="@time"/></td>
        <td>
            <xsl:attribute name="class">
                <xsl:text>validation </xsl:text>
                <xsl:if test="string($error)">error</xsl:if>
            </xsl:attribute>
            <xsl:value-of select="$error"/>
        </td>
    
    </tr>
   
    </xsl:template>
</xsl:stylesheet>