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

<xsl:import href="./mathbook-xsl.d/mathbook-html.xsl" />

<!-- customizations -->
<xsl:param name="numbering.projects.level" select="2" />
<xsl:param name="html.knowl.example" select="'no'" />
<!-- <xsl:param name="numbering.theorems.level" select="2" /> -->
<!-- ^^^^ Don't like this: theorems share numbering with remarks, etc., so theorem numbering won't start at 1 in each Theory section. -->
<!-- <xsl:param name="toc.level" select="2" />                -->
<!-- ^^^^ In principle I like this, but in current incarnation it makes it difficult to navigate web book. Wish there was a toc.level=2.5. Have discussed with David Farmer. -->

</xsl:stylesheet>


