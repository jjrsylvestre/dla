#!/bin/sh

# newpage @ end of each discovery section
sed -i -e '/\\end{worksheet-section}/ s|$|\n\\newpage|' ${1}

# Manual page breaks:
# (these are DLA1 numbers)
# * Section 1.3
# * Section 1.6
# * Section 2.3
# * Section 4.3
# * Section 4.4
# * Section 4.5
# * Section 7.5
# * Section 8.6
# * Section 10.4
# * Section 11.3
# * Section 12.4
# * Section 13.3
# * Section 15.4
# * Section 18.5
# * Section 20.5
# * Section 22.4
lines=(
	"begin{sectionptx}.*{section-systems-concepts}"
	"begin{reading-questions-section}.*{reflections-systems}"
	"begin{sectionptx}.*{section-row-red-concepts}"
	"begin{sectionptx}.*{section-matrix-ops-concepts}"
	"begin{sectionptx}.*{section-matrix-ops-examples}"
	"begin{sectionptx}.*{section-matrix-ops-theory}"
	"begin{sectionptx}.*{section-special-forms-theory}"
	"begin{exercises-section}.*{exercises-det}"
	"begin{sectionptx}.*{section-more-det-examples}"
	"begin{sectionptx}.*{section-vectors-concepts}"
	"begin{sectionptx}.*{section-vector-geom-examples}"
	"begin{sectionptx}.*{section-orthog-concepts}"
	"begin{sectionptx}.*{section-abstract-vec-spaces-concepts}"
	"begin{sectionptx}.*{section-basis-coords-theory}"
	"begin{sectionptx}.*{section-col-row-null-space-theory}"
	"begin{sectionptx}.*{section-diagonalization-concepts}"
)
	# "begin{activity}.*{activity-vector-geom-dot-product}"
for l in ${lines[@]}
do
	sed -i -e "/${l}/ s|^|\\\\newpage\n|" ${1}
done
