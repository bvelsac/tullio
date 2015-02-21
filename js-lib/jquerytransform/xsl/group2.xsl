<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:key name="clip" match="//e" use="@clip"/>
    <xsl:key name="text" match="//p" use="@c"/>
    
    <xsl:template match="/">
    		
            <xsl:for-each select="//e[@c='y']">
                <div id="{concat('R', @n)}" class="row">
                    <div class="cell-events">
                    <ul>
                        <xsl:for-each select="key('clip', @n)">
                            
                            <li><xsl:value-of select="@n"/></li>    
                            
                        </xsl:for-each>
                        
                    </ul>
                    </div>
                    <div class="cell-orig" id="{concat('R', @n, '-o')}" rel="test">
										   <div>
												  <p class="id"><xsl:value-of select="@n"/></p>
                          <xsl:copy-of select="key('text', @n)"/>
												</div>
                    </div>
										<div class="cell-trans" id="{concat('R', @n, '-t')}" rel="test">
										   
                    </div>
										
                </div>
            </xsl:for-each>
            
        
    </xsl:template>
    
    
    
</xsl:stylesheet>