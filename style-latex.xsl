<?xml version='1.0'?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:b64="https://github.com/ilyakharlamov/xslt_base64"
    xmlns:exsl="http://exslt.org/common"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="b64"
    extension-element-prefixes="exsl date str"
>

<xsl:import href="./mathbook-xsl.d/mathbook-latex.xsl" />

<!-- customizations -->
<xsl:param name="numbering.projects.level" select="2" />
<!-- <xsl:param name="numbering.theorems.level" select="2" /> -->
<!-- <xsl:param name="toc.level" select="2" />                -->

</xsl:stylesheet>
