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
<xsl:param name="latex.preamble.late"><xsl:text>
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% attempts at noindent + parskip
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\usepackage[parfill]{parskip}
%\setlength{\parindent}{0pt}
%\setlength{\parskip}{0.5pc}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% title and toc entry formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\titleformat{\chapter}[display]
{\divisionfont\LARGE\scshape\bfseries}{\divisionnameptx\space\thechapter}{20pt}{\huge\upshape#1}
%
\titlecontents{part}%
[0pt]%
{\contentsmargin{0em}\addvspace{1pc}\contentsfont\bfseries}%
{\Large\contentslabel[\hfill\thecontentslabel]{1.33em}\enspace}%
{\Large}%
{}%
[]% \addvspace{?pc}
%
\titlecontents{chapter}%
[0pt]%
{\contentsmargin{0em}\contentsfont}%
{\large\contentslabel[\hfill\thecontentslabel]{1.33em}\enspace}%
{\large}%
{\titlerule*[1pc]{.}\thecontentspage}%
[]% \addvspace{?pc}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hyphenation fixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\hyphenation{eigen-space}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mathscr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage[mathscr]{eucal}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Greg's L for asides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\tcbset{ asidestyle/.style={
	bwminimalstyle, runintitlestyle, blockspacingstyle, after title={\space},
	enhanced,
	breakable,
	frame hidden,
	after skip={2.5ex},
	overlay unbroken={
		\draw[thin] ([shift={(-0.75ex,-0.5ex)}]frame.north west)--([shift={(-0.75ex,-0.75ex)}]frame.south west)--([shift={(4ex,-0.75ex)}]frame.south west);
	},
	overlay first={
		\draw[thin] ([shift={(-0.75ex,-0.5ex)}]frame.north west)--([shift={(-0.75ex,-0.75ex)}]frame.south west);
	},
	overlay middle={
		\draw[thin] ([shift={(-0.75ex,-0.5ex)}]frame.north west)--([shift={(-0.75ex,-0.75ex)}]frame.south west);
	},
	overlay last={
		\draw[thin] ([shift={(-0.75ex,-0.5ex)}]frame.north west)--([shift={(-0.75ex,-0.75ex)}]frame.south west)--([shift={(4ex,-0.75ex)}]frame.south west);
	}
} }
</xsl:text></xsl:param>

</xsl:stylesheet>
