<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml"/>
  <xsl:param name="firstLang">F</xsl:param>
  <xsl:variable name="langMismatch">
    <xsl:choose>
      <xsl:when test="$firstLang='F'">fragmentNL</xsl:when>
      <xsl:when test="$firstLang='N'">fragmentFR</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="langMismatchCol3">
    <xsl:choose>
      <xsl:when test="$firstLang='F'">fragmentFR</xsl:when>
      <xsl:when test="$firstLang='N'">fragmentNL</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="tr">
    <xsl:choose>
      <xsl:when test="td[2]/*[contains(@class, $langMismatch)]">
        <xsl:apply-templates mode="col2" select="td[2]/*[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="rowForFragment">
    <xsl:param name="col2content"/>
    <xsl:param name="col3content"/>
    <xsl:param name="col2init"/>
    <xsl:param name="col3init"/>
    <xsl:param name="invert"/>
    <xsl:choose>
      <xsl:when test="$invert='yes'">
        <tr>
          <td>i</td>
          <td>
            <xsl:copy-of select="$col3content"/>
          </td>
          <td>
            <xsl:copy-of select="$col2content"/>
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td>r</td>
          <td>
            <xsl:copy-of select="$col2content"/>
          </td>
          <td>
            <xsl:copy-of select="$col3content"/>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="col2" select="../preceding-sibling::td/*[position()=2+$col2init]">
      <xsl:with-param name="col3init" select="$col3init"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="*" mode="col2">
    <xsl:param name="col2content"/>
    <xsl:param name="col3init">-1</xsl:param>
    <xsl:variable name="nextClass" select="following-sibling::*[1]/@class"/>
    <xsl:choose>
      <xsl:when
        test="following-sibling::*[1] and ((contains(@class, $langMismatch) and contains($nextClass, $langMismatch)) or (not(contains(@class, $langMismatch)) and not(contains($nextClass, $langMismatch))))">
        <xsl:apply-templates mode="col2" select="following-sibling::*[1]">
          <xsl:with-param name="col2content">
            <xsl:copy-of select="$col2content"/>
            <xsl:copy-of select="."/>
          </xsl:with-param>
          <xsl:with-param name="col3init" select="$col3init"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="col3" select="../following-sibling::td/*[position()=2+$col3init]">
          <xsl:with-param name="col2content">
            <xsl:copy-of select="$col2content"/>
            <xsl:copy-of select="."/>
          </xsl:with-param>
          <xsl:with-param name="col2init" select="count(preceding-sibling::*)"/>
          <xsl:with-param name="invert">
            <xsl:if test="contains(@class, $langMismatch)">yes</xsl:if>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="col3">
    <xsl:param name="col2content"/>
    <xsl:param name="col3content"/>
    <xsl:param name="col2init"/>
    <xsl:param name="invert"/>
    <xsl:variable name="nextClass" select="following-sibling::*[1]/@class"/>
    <xsl:choose>
      <xsl:when
        test="following-sibling::*[1] and  ((contains(@class, $langMismatchCol3) and contains($nextClass, $langMismatchCol3)) or (not(contains(@class, $langMismatchCol3)) and not(contains($nextClass, $langMismatchCol3))))">
        <xsl:apply-templates mode="col3" select="following-sibling::*[1]">
          <xsl:with-param name="col2init" select="$col2init"/>
          <xsl:with-param name="invert" select="$invert"/>
          <xsl:with-param name="col2content" select="$col2content"/>
          <xsl:with-param name="col3content">
            <xsl:copy-of select="$col3content"/>
            <xsl:copy-of select="."/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="rowForFragment">
          <xsl:with-param name="col2content" select="$col2content"/>
          <xsl:with-param name="col3content">
            <xsl:copy-of select="$col3content"/>
            <xsl:copy-of select="."/>
          </xsl:with-param>
          <xsl:with-param name="col3init" select="count(preceding-sibling::*)"/>
          <xsl:with-param name="col2init" select="$col2init"/>
          <xsl:with-param name="invert" select="$invert"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
