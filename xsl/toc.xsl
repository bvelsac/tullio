<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output encoding="UTF-8" method="html"/>
	<xsl:param name="numbering"></xsl:param>
	<xsl:param name="type"></xsl:param>
	<xsl:param name="firstLang"></xsl:param>
	<xsl:key match="/response/resultSet/events//e" name="events" use="@n"/>
	<xsl:key match="/response/resultSet/doc/p" name="text" use="@c"/>
	<xsl:key match="/response/resultSet/trans/p" name="trans" use="@c"/>
	<xsl:variable name="fontSize" select="'14.5'"></xsl:variable>

	<xsl:template match="/">
	
				<html>
					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
						<title>COMPLET <xsl:value-of select="$type"/>
							<xsl:value-of select="$firstLang"/>
						</title>
					</head>
					<body>
						<div style="font-size: {$fontSize};">
							<table>
							<xsl:apply-templates select="/response/resultSet/events/group" />
							</table>
						</div>
					</body>
    

				</html>
	
	</xsl:template>
	
	<xsl:template match="group">
	
	
	<tr>
	<td style="width: 20px; vertical-align: top;">
				<span style="color:gray">[<xsl:value-of select="e[1]/@n"/>] </span>
			</td>
			
			
			
			
			<td  style="width: 600px; vertical-align: top; text-align: justify;">
			<xsl:for-each select="e[@c='true']">
				<xsl:choose>
				<xsl:when test="@lang=$firstLang">
					
						<xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
					
					
				</xsl:when>
				<xsl:otherwise>
					
						<xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
					

				</xsl:otherwise>
			</xsl:choose>

			
			
			</xsl:for-each>
			
			
			
			<p></p>
			</td>
			
				<td  style="width: 600px; vertical-align: top; text-align: justify;">
			<xsl:for-each select="e[@c='true']">
				<xsl:choose>
				<xsl:when test="@lang=$firstLang">
					
						<xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
					
					
				</xsl:when>
				<xsl:otherwise>
					
						<xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
					

				</xsl:otherwise>
			</xsl:choose>

			
			
			</xsl:for-each>
			
			
			
			<p/>
			</td>
			
			<!--

			<td style="vertical-align: top; text-align: justify;">
								<td style="vertical-align: top; text-align: justify;">
						<xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
					</td>

						<xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
					</td>
            

			
			
			
			
	
		<xsl:apply-templates select="response/resultSet/events/e[@c='true']" mode="complete"></xsl:apply-templates>
	-->
	</tr>
					
							
							
							
							
			
	
	</xsl:template>

	
	

	
  
  

	<xsl:template match="e" mode="complete">
		<tr>
			
      
        <!-- this column should always be Dutch -->

			<xsl:choose>
				<xsl:when test="@lang=$firstLang">
					<td style="vertical-align: top; text-align: justify;">
						<xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
					</td>
					<td style="vertical-align: top; text-align: justify;">
						<xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
					</td>
            

				</xsl:when>
				<xsl:otherwise>
					<td style="vertical-align: top; text-align: justify;">
						<xsl:apply-templates select="key('trans', @n)"></xsl:apply-templates>
					</td>
					<td style="vertical-align: top; text-align: justify;">
						<xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
					</td>

				</xsl:otherwise>
			</xsl:choose>

		</tr>

	</xsl:template>
  
  
  <!-- 
  title: alle tekst die rechtstreeks een event representeert, komt in principe nooit in cursief
  -->

  
  <xsl:template match="p[contains(@class, 'title')]">
        <xsl:variable name="level" select="substring(substring-after(@class, 'title'), 1, 1)"/>
        <xsl:element name="h{$level}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="p[span/@class='speaker']">
        <xsl:if test="not(contains(span, 'président') or contains(span, 'voorzitter'))">
            <p>
                <xsl:value-of select="span"/>
            </p>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text()"/>
  
  
  
  
  
  
</xsl:stylesheet>
