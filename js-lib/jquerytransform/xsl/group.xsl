<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:key name="clip" match="//e" use="@clip"/>
    <xsl:key name="text" match="//p" use="@c"/>
    <xsl:output indent="yes"/>
    
    
    <xsl:template match="/">
      
            <xsl:for-each select="//e[@c='y']">
                <tr id="{concat('R', @n)}">
                    <td>
										<!--<div class="meta-xml">
										<xsl:copy-of select="."/>
										</div>
										-->
									
										<xsl:variable name="top" select="@n"/>
                    <ul>
												
										
										
                        <xsl:for-each select="key('clip', @n)">
                            
                            <li>
														<xsl:if test="position()=1">
														<xsl:attribute  name="id" ><xsl:text>startevent-</xsl:text><xsl:value-of select="@n"/></xsl:attribute>
														  
														</xsl:if>
                              <xsl:if test="position()=last()">
                                <xsl:attribute  name="id" ><xsl:text>stopevent-</xsl:text>
																<xsl:value-of select="$top"/>
																</xsl:attribute>
                                
                              </xsl:if>
														<xsl:value-of select="@n"/></li>    
                            
                        </xsl:for-each>
                        
                    </ul>
                    </td>
                    <td id="{concat('R', @n, '-o')}" rel="test" class="orig">
										   <div class="editable">
												  
                          <xsl:copy-of select="key('text', @n)"/>
												</div>
                    </td>
                </tr>
            </xsl:for-each>
            
    	
    </xsl:template>
    
    
    
</xsl:stylesheet>