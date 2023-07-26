<?xml version='1.0'?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:exsl="http://exslt.org/common"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:str="http://exslt.org/strings"
	xmlns:pi="http://pretextbook.org/2020/pretext/internal"
	extension-element-prefixes="exsl date str"
>
<xsl:import href="./pretext/xsl/pretext-latex.xsl" />

<!-- customizations -->
<xsl:param name="latex.preamble.late">
	<xsl:text>
%
% attempts at noindent + parskip
%
%\usepackage[parfill]{parskip}
%\setlength{\parindent}{0pt}
%\setlength{\parskip}{0.5pc}
%
%
% chapter title formatting
%
\titleformat{\chapter}[display]
{\divisionfont\LARGE\scshape\bfseries}{\divisionnameptx\space\thechapter}{20pt}{\huge\upshape#1}
%
%
% hyphenation fixes
%
\hyphenation{eigen-space}
	</xsl:text>
</xsl:param>

</xsl:stylesheet>
