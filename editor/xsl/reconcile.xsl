<?xml version="1.0"?>
<!DOCTYPE stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:key name="events" match="//div[@id='events']//e" use=" @n"/>
<!-- Sample formats



-->	
	
	
	
	<!-- matches all p elements that do not represent an event -->
  <!-- they don't have any output -->
	<xsl:template match="*">
		<xsl:param name="processed"/>
		<xsl:param name="refIndexStart"/>
		<xsl:param name="offset"/>
		<xsl:param name="memo"></xsl:param>

		<xsl:apply-templates select="following-sibling::*[1]">
			<xsl:with-param name="refIndexStart" select="$refIndexStart"/>
			<xsl:with-param name="processed" select="$processed"/>
			<xsl:with-param name="offset" select="$offset"/>
			<xsl:with-param name="memo" select="$offset"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- matches elements that represent a new or existing event -->
  <!-- they have output: the reconciled event list -->
	<xsl:template match="p[@title] | span[@title] | event">
		<xsl:param name="processed"/>
		<xsl:param name="refIndexStart" select="'0'"/>
		<xsl:param name="refIndexStop" select="'1'"/>
		<xsl:param name="offset" select="0"/>
		<xsl:choose>
		<!-- new event, introduced by the user -->
			<xsl:when test="self::event or @title='new'">
			<!-- calculate a correct ID -->
				<xsl:variable name="n-value">
					<xsl:call-template name="increment">
						<xsl:with-param name="preceding">
						<xsl:value-of select="//e[count(preceding-sibling::e) = $refIndexStart]/@n + $offset"/>
						</xsl:with-param>
						<xsl:with-param name="following" select="//e[count(preceding-sibling::e) = $refIndexStart +1]/@n"/>
					</xsl:call-template>
				</xsl:variable>
			  
			  <e n="{$n-value}">
			    <xsl:copy-of select="@*"/>
			    <xsl:copy-of select="*"/>
			  </e>

				<!-- continue processing -->
				<xsl:apply-templates select="following-sibling::*[1]">
					<xsl:with-param name="offset" select="$n-value - //e[count(preceding-sibling::e) = $refIndexStart]/@n"/>
					<xsl:with-param name="refIndexStart" select="$refIndexStart"/>
					<xsl:with-param name="processed" select="$processed"/>
				</xsl:apply-templates>
			</xsl:when>
			<!-- element represents an existing event -->
			<xsl:otherwise>
				<xsl:choose>
				<!-- the p representation is in the same order as the event reference -->
					<xsl:when test="@title = $processed">
						<xsl:copy-of select="."/>
					  <normal>
					    <xsl:copy-of select="//e[@n=current()/@title]"/>
					  </normal>
						<xsl:apply-templates select="following-sibling::p[1]">
							<xsl:with-param name="refIndexStart" select="$refIndexStart"/>
							<xsl:with-param name="processed" select="$processed"/>
							<xsl:with-param name="offset" select="$offset"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="//e[count(preceding-sibling::e) = $refIndexStart]/@n &gt; @title ">
						<!-- means a title has been moved in the document , first it was missing, now it is found but the numbering is wrong  -->
						
						<xsl:variable name="n-value">
							<xsl:call-template name="increment">
								<xsl:with-param name="preceding">
								<xsl:value-of select="//e[count(preceding-sibling::e) = $refIndexStart]/@n + $offset"/>
									
								</xsl:with-param>
								<xsl:with-param name="following" select="//e[count(preceding-sibling::e) = $refIndexStart +1]/@n"/>
							</xsl:call-template>
						</xsl:variable>
						<moved>
							<xsl:copy-of select="//e[@n=current()/@title]"/>
							<new-nr>
							<xsl:value-of select="$n-value"/>
						</new-nr>
						<xsl:copy-of select="."/>
						</moved>
						<xsl:apply-templates select="following-sibling::*[1]">
							<xsl:with-param name="offset" select="$n-value - //e[count(preceding-sibling::e) = $refIndexStart]/@n"/>
							<xsl:with-param name="refIndexStart" select="$refIndexStart"/>
							<xsl:with-param name="processed" select="@title"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="@title &gt; //e[count(preceding-sibling::e) = $refIndexStart+1]/@n">
							<leftovers>
								<!--<cutoff>
									<xsl:value-of select="$refIndexStart"/>
								</cutoff>-->
								<xsl:copy-of select="//e[@n=current()/@title]/preceding-sibling::e[count(preceding-sibling::e) &gt;= $refIndexStart+1]"/>
							</leftovers>
						</xsl:if>
						<xsl:copy-of select="//e[@n=current()/@title]"/>
						<xsl:apply-templates select="following-sibling::*[1]">
							<xsl:with-param name="refIndexStart" select="count(//e[@n=current()/@title]/preceding-sibling::e) "/>
							<xsl:with-param name="processed" select="@title"/>
							<xsl:with-param name="offset" select="'0'"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="/">
	  <container>
	    <xsl:copy-of select="container/*[not(@id='flattened')]"/>
	    
	    <div id="integratedEvents">
	      <events  next="{container/div[@id='events']//e[position()=last()]/@n}">
	      <xsl:copy-of select="container/div[@id='events']//e[position()=1]"/>
	      
	      <xsl:choose>
	        <xsl:when test="not(/container/div[@id='flattened']/p[@title][not(@title='new')])">
	          <!-- all events deleted -->
	          <leftovers>
	            <xsl:copy-of select="container/div[@id='events']//e[not(position()=1)][not(position()=last())]"/>
	          
	          
	          </leftovers>
	          
	          <xsl:apply-templates select="container/div[@id='flattened']/*[1]"/>
	          
	        </xsl:when>
	        <xsl:otherwise>
	          <xsl:apply-templates select="container/div[@id='flattened']/*[1]"/>
	        </xsl:otherwise>
	      </xsl:choose>  
	      </events>
	    </div>
	    
	    
	    </container>
	  

	  </xsl:template>
	
<!-- next template to calculate the id -->	
	
	<xsl:template name="increment">
		<xsl:param name="preceding" select="1000" />
		<xsl:param name="following" select="1000"/>
		<xsl:param name="factor" select="'1'"/>
			
			<xsl:variable name="diff" select="$following - $preceding"></xsl:variable>
			<xsl:variable name="product" select="$diff * $factor"></xsl:variable>
		<!--<xsl:comment>
		  diff: <xsl:value-of select="$diff"/>
		  product:  <xsl:value-of select="$product"/>
		  product - 1= <xsl:value-of select="$product - 1"/>
		  </xsl:comment>-->
		
		
		<xsl:choose>
			<xsl:when test="($product - 1) &gt; 0.00000000000000001">
				<xsl:value-of select="format-number($preceding + (1 div $factor), concat('#.', substring-after($factor, '1')))"/>
			
			</xsl:when>
	<xsl:when test="$following - $preceding = 0">
	<xsl:text>10000</xsl:text>
	</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="increment">
					<xsl:with-param name="preceding" select="$preceding"/>
					<xsl:with-param name="following" select="$following"/>
					<xsl:with-param name="factor" select="$factor * 10"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
