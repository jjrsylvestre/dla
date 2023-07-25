<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" cdata-section-elements="latex-image"/>

<!-- kill copyright headers, replace with one single header at the top -->
<!-- TODO figure out how to kill copyright headers in included .tex files -->
<xsl:template match="comment()[substring(string(.), 1, 4) = '****']" />
<xsl:template match="/">
	<xsl:copy-of select="document('./src/copyright-header.xml')/copyright/comment()" />
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="@*|node()|text()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()|text()"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
