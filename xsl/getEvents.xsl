<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="/">
		<html>
        <p>Transformation succesful</p>
				<p>Bla bla bla</p>
        <xsl:apply-templates></xsl:apply-templates>
        
        </html>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="span[@title]">
        <p>EVENT</p>
    </xsl:template>
    
    <xsl:template match="span[@title='']">
        <p>NEW EVENT</p>
    </xsl:template>
    
    <xsl:template match="text()"></xsl:template>
</xsl:stylesheet>