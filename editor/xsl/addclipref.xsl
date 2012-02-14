<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:output encoding="UTF-8" method="xml"/>
    <xsl:template match="/">
      
      
      
        <all>
            <events>
                <xsl:apply-templates select="/all/events/e"></xsl:apply-templates>
                
            </events>
            <xsl:copy-of select="all/doc"/>
        </all>
        
        
        
        
    </xsl:template>
    <xsl:template match="e">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="clip">
                <xsl:choose>
                    <xsl:when test="@c='y'">
                        <xsl:value-of select="@n"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="preceding-sibling::e[@c='y'][1]/@n"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                
            </xsl:attribute>
            
        </xsl:copy>
        
        
    </xsl:template>
    
    
    
    
</xsl:stylesheet>