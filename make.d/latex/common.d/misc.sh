#!/bin/sh

# unnecessary \par's
sed -i -e "/lititle{Complete the formulas\.}/ s|\\\\par||" ${1}

# don't indent a par inside a sidebyside when it's the first in the division
sed -i -e "/A vector describes a change in position\./ s|^|\\\\noindent\n|" ${1}
sed -i -e "/The effects of the elementary row operations on the determinant are/ s|^|\\\\noindent\n|" ${1}
sed -i -e "/To subtract vectors/ s|^|\\\\noindent\n|" ${1}
sed -i -e "/Applied to our diagram/ s|^|\\\\noindent\n|" ${1}
sed -i -e "/we combined vector geometry with some high school geometry/ s|^|\\\\noindent\n|" ${1}
