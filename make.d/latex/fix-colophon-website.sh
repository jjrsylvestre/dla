#!/bin/sh

sed -i \
	-e 's|{https:\\slash{}\\slash{}sites\.ualberta\.ca\\slash{}\\textasciitilde{}jsylvest\\slash{}books\\slash{}dla\.html}{Discover Linear Algebra}|{https://sites.ualberta.ca/~jsylvest/books/dla.html}{Discover Linear Algebra} (\\url{https://sites.ualberta.ca/~jsylvest/books/dla.html})|' \
	-e 's|{https:\\slash{}\\slash{}github\.com\\slash{}jjrsylvestre\\slash{}dla\\slash{}}{GitHub source code repository}|{https://github.com/jjrsylvestre/dla/}{GitHub source code repository} (\\url{https://github.com/jjrsylvestre/dla/})|' \
	${1}
