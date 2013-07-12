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
		<xsl:choose>
			<xsl:when test="$type='continu'">
				<html>
					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
						<title>ASSEMBLAGE <xsl:value-of select="$type"/>
						</title>
					</head>
					<body>
						<div style="font-size: {$fontSize};">

							<xsl:apply-templates select="response/resultSet/events//e[@c='true']" mode="continu"></xsl:apply-templates>

						</div>
					</body>
    

				</html>

			</xsl:when>
			<xsl:otherwise>
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
			</xsl:otherwise>
		</xsl:choose>
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
			
			
			
			<p/>
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

	
	

	<xsl:template match="e" mode="continu">

		<p style="text-indent: -40px;">
			<span style="font-size: 10px; font-family: monospace;">[<xsl:value-of select="@n"/>] </span>
		</p>
		<xsl:apply-templates select="key('text', @n)"></xsl:apply-templates>
  
  
  
  
  <!-- 
  <p style="font-size: 10px; font-family: monospace;"><xsl:value-of select="concat('[', @n, ']')" /></p>
  -->

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

  <xsl:template match="trans//p[contains(@class, 'title')]//span[string(@title) and string(@class)]">
  		<span style="font-style: normal;">
  		<xsl:apply-templates />
  		</span>
  </xsl:template>
  
	<xsl:template match="p">
	<p style="font-style: normal;">
	<xsl:apply-templates />
	</p>
	<!-- 
		<xsl:copy>
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="ancestor::trans and  not( @title and string(@class) ) ">font-style: italic;</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>

			</xsl:attribute>

			<xsl:apply-templates></xsl:apply-templates>
		</xsl:copy>
		 -->
	</xsl:template>
	
	<xsl:template match="trans//p">
		<xsl:copy>
		<xsl:attribute name="style">
		<xsl:choose>
					<xsl:when test="not( @title and string(@class) ) and not(contains(@class, 'title'))">font-style: italic;</xsl:when>
					<xsl:when test="contains(@class, 'title1')">font-style: normal; font-weight: bold; text-align: center; text-transform: uppercase;</xsl:when>
					
					
					<xsl:otherwise>font-style: normal;</xsl:otherwise>
				</xsl:choose>
				</xsl:attribute>
				<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>
	
	

	<xsl:template match="p[@class='proc']">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="p[@class='title4']">
		
		<xsl:choose>
			<xsl:when test="preceding-sibling::p[string()][1][not(@class='title4')] or preceding-sibling::p[string()][1][@class='title4'][starts-with(.,'betreffende') or starts-with(.,'concernant')]">
				<h4 style="font-style: normal; font-weight: bold; margin-left:25px;  text-indent:-25px;  text-transform:uppercase;   font-size: {$fontSize};">
					<xsl:apply-templates />
					
					
				</h4>
				
			</xsl:when>
			<xsl:when test="not(starts-with(., 'concernant') or starts-with(., 'betreffende'))">
				<p style="font-style: normal; font-weight: bold; margin-left:25px; text-transform:uppercase;      font-size: {$fontSize}" >
					<xsl:apply-templates />
					
				</p>
				
			</xsl:when>
			<xsl:otherwise>
				<p style="font-style: normal; font-weight: bold; margin-left:25px;     font-size: {$fontSize}" >
					<xsl:apply-templates />
					
				</p>
				
			</xsl:otherwise>
		</xsl:choose>
		
		
	</xsl:template>

	<xsl:template match="span[@class='speaker']">
		<xsl:copy>
			<xsl:attribute name="style">font-weight: bold; font-style:normal;</xsl:attribute>
			<xsl:choose>
				<xsl:when test="not(contains(., '.-'))">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(., '.-')"/>
				</xsl:otherwise>

			</xsl:choose>
</xsl:copy>
			<xsl:if test="ancestor::trans and not(contains(.,'voorzitter')  and not (contains(., 'College'))  ) and not(contains(.,'résident') and not (contains(., 'réuni')))">
				<xsl:choose>
					<xsl:when test="key('events', ancestor::p/@c)/@lang='F'">
					<xsl:text> (in het Frans)</xsl:text>
						
					</xsl:when>
					<xsl:otherwise>
						 <xsl:text> (en néerlandais)</xsl:text>
					</xsl:otherwise>

				</xsl:choose>
			</xsl:if>
<xsl:if test="ancestor::trans and contains(., 'ministre-président') and key('events', ancestor::p/@c)/@lang='N'">
 <xsl:text> (en néerlandais)</xsl:text>

</xsl:if>
<xsl:text>.-</xsl:text>
<xsl:if test="contains(substring-after(., '.-'), ' ')">
	<xsl:text> </xsl:text>
	</xsl:if>

	</xsl:template>

	<xsl:template match="span[contains(@class, 'pres')]">
		<xsl:copy>
			<xsl:attribute name="style">font-weight: bold; font-style:normal;</xsl:attribute>
			<xsl:choose>
				<xsl:when test="not(contains(., '.-'))">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(., '.-')"/>
				</xsl:otherwise>

			</xsl:choose>
		</xsl:copy>
		<xsl:text>.- </xsl:text>
	</xsl:template>

	<xsl:template match="p[normalize-space()='...']"></xsl:template>

	<xsl:template match="p[normalize-space()='']"></xsl:template>

	<xsl:template match="p[@class='comment']"></xsl:template>

	<xsl:template match="p[@class='front']">
		<h1>
			<xsl:attribute name="style">font-style: normal; font-weight: bold; text-align:center; font-size: <xsl:value-of select="$fontSize"/>;</xsl:attribute>
			<xsl:apply-templates />
			
		</h1>
		
		
	</xsl:template>
	
	<xsl:template match="p[@class='title1']">
		<h1>
			<xsl:attribute name="style">font-style: normal; font-weight: bold; text-align:center; text-transform:uppercase;  font-size: <xsl:value-of select="$fontSize"/>;</xsl:attribute>
			<xsl:apply-templates />
			
		</h1>
		
	</xsl:template>
	
	<xsl:template match="p[@class='title2']">
		<h2>
			<xsl:attribute name="style">font-weight: normal; font-style: italic; text-align:center;  font-size: <xsl:value-of select="$fontSize"/>; </xsl:attribute>
			<xsl:apply-templates />
			
		</h2>
		
		
	</xsl:template>


	<xsl:template match="p[@class='realia']">
		<xsl:copy>
			<xsl:attribute name="style">font-style: italic;</xsl:attribute>
			<xsl:apply-templates />

		</xsl:copy>

	</xsl:template>

	<xsl:template match="text()">
		<xsl:variable name="temp">
			<xsl:choose>
				<xsl:when test="substring(., 1, 2)='.-'">
   	<!-- <span style="font-weight: bold;">.-</span> -->
					<xsl:value-of select="concat('', substring-after(., '.-'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
   

			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="translate($temp,'_','&#160;')"/>

	</xsl:template>
  
  
  
  
<!--
	<xsl:template match="translation//span[@class='speaker']">
		<xsl:copy>
			<xsl:attribute name="style">font-style: normal</xsl:attribute>

			<xsl:value-of select="substring-before(., '.-')"/>
			
		</xsl:copy>
		<span style="font-style: italic">
			<xsl:choose>
				<xsl:when test="key('events', parent::p/@clip)/@lang='F'">(en néerlandais)</xsl:when>
				<xsl:otherwise>(in het Frans))</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:text>.-</xsl:text>
	</xsl:template>
  -->

	<xsl:template match="span[@class='langInd']">
		<xsl:copy>
			<xsl:attribute name="style">font-style: italic</xsl:attribute>
			<xsl:copy-of select="text()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
