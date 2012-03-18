<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output indent="yes" method="xml"/>
	<xsl:template match="/">
		<members>
			<xsl:apply-templates select="members/group/p">
</xsl:apply-templates>
		</members>
	</xsl:template>
	<xsl:template match="p">
		<person id="{concat(normalize-space(nl), '_', normalize-space(nf))}" gov="no" group="{parent::group/@id}" lang="{parent::group/@lang}">
			<xsl:attribute name="gender"><xsl:choose><xsl:when test="normalize-space(g)='M.'">m</xsl:when><xsl:otherwise>f</xsl:otherwise></xsl:choose></xsl:attribute>
			<first>
				<xsl:value-of select="normalize-space(nf)"/>
			</first>
			<last>
				<xsl:apply-templates select="nl"/>
			</last>
		</person>
	</xsl:template>
	<xsl:template match="nl">
	
	
	
	
		<xsl:for-each select="tokenize(normalize-space(), '\s+')">
			<xsl:choose>
				<xsl:when test="lower-case(substring(.,1,1))=substring(.,1,1)">
					<xsl:copy-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(.,1,1)"></xsl:value-of>
					<xsl:value-of select="lower-case(substring(.,2))"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(position()=last())">
			<xsl:text> </xsl:text>			
			</xsl:if>

		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
