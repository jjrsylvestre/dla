<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" cdata-section-elements="latex-image"/>

<xsl:param name="version" select="'unset'" />

<!-- kill copyright headers, replace with one single header at the top -->
<!-- TODO figure out how to kill copyright headers in included .tex files -->
<xsl:template match="comment()[substring(string(.), 1, 4) = '****']" />
<xsl:template match="/">
	<xsl:copy-of select="document('./src/copyright-header.xml')/copyright/comment()" />
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="restrictversion[@onlyin]">
	<xsl:if test="@onlyin=$version">
		<xsl:apply-templates select="node()|text()" />
	</xsl:if>
</xsl:template>

<xsl:template match="*[@onlyin]">
	<xsl:if test="@onlyin=$version">
		<xsl:copy>
			<xsl:apply-templates select="@*[name(.)!='onlyin']|node()|text()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="restrictversion[@excludefrom]">
	<xsl:if test="not(@excludefrom=$version)">
		<xsl:apply-templates select="node()|text()" />
	</xsl:if>
</xsl:template>

<xsl:template match="*[@excludefrom]">
	<xsl:if test="not(@excludefrom=$version)">
		<xsl:copy>
			<xsl:apply-templates select="@*[name(.)!='excludefrom']|node()|text()"/>
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="@*|node()|text()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()|text()"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>


