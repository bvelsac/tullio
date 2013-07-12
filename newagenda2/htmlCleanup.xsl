<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml"/>
    <xsl:template match="/">
        <data>
            <info>
                <meeting><xsl:value-of select="//TABLE/@data-pants-meeting"/></meeting>
                <name><xsl:value-of select="substring-before(substring(//TABLE/@data-pants-meeting, 15), '_')"/></name>
                <date><xsl:value-of select="substring(//TABLE/@data-pants-meeting, 1, 10)"/></date>
                
                
                
            </info>
            
            
    
        
        
        <TABLE>
            <xsl:copy-of select="@*"/>
            <thead>
                <tr>
                    <th>TYPE</th>
                    <th>F/N</th>
                    <th>SUJET / ONDERWERP NL</th>
                    <th>SUJET / ONDERWERP FR</th>
                    <th>KEYWORD</th>
                    <th>ORATEUR / SPREKER</th>
                    <th>GOUV. / REG.</th>
                    <th>-</th>
                    
                </tr>
            </thead>
            
            
            
            <xsl:apply-templates select="//TR"/>
        </TABLE>
        </data>
    </xsl:template>
    <xsl:template match="TR">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="TD"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsType-dropdown')]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            
        </xsl:copy>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsType-text')]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="normalize" select="node()"></xsl:apply-templates>
        </xsl:copy>
        
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsType-tags')]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="TAGS"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsType-autocomplete')]">
    <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:value-of select="INPUT/@value"/>
       
    </xsl:copy>
    </xsl:template>
    <xsl:template match="TD[contains(@class, '-pantsType-commands')]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
        </xsl:copy>
        
    </xsl:template>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template mode="normalize" match="*">
        <xsl:apply-templates mode="normalize"></xsl:apply-templates>
    </xsl:template>
    <xsl:template mode="normalize" match="br|BR" priority="5">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="text()" mode="normalize" >
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>
    
</xsl:stylesheet>
