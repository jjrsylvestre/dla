#!/bin/sh

# Current manual page breaks:
#   * end each discovery section with a newpage
#   * Section 1.3
#   * Section 2.3
#   * Section 2.5
#   * Section 4.5
#   * Subsection 4.5.2
#   * Subsection 5.3.2
#   * Subsection 5.4.3
#   * Section 5.5
#   * Section 11.5
#   * Section 13.3
#   * Section 13.5
#   * Section 14.3.5
#   * Section 15.4
#   * Section 18.5
#   * Section 20.5
#   * Subsection 20.5.2

# newpage @ end of each discovery section
sed -i -e '/\\end{worksheet-section}/ s|$|\n\\newpage|' ${1}

# other manual page breaks
lines=(
	"begin{sectionptx}{Section}{Concepts}{}{Concepts}{}{}{section-section-systems-concepts}"
	"begin{sectionptx}{Section}{Concepts}{}{Concepts}{}{}{section-section-row-red-concepts}"
	"begin{sectionptx}{Section}{Theory}{}{Theory}{}{}{section-section-row-red-theory}"
	"begin{sectionptx}{Section}{Theory}{}{Theory}{}{}{section-section-matrix-ops-theory}"
	"begin{sectionptx}{Section}{Theory}{}{Theory}{}{}{section-section-inverses-theory}"
	"begin{sectionptx}{Section}{Theory}{}{Theory}{}{}{section-section-vectors-theory}"
	"begin{sectionptx}{Section}{Concepts}{}{Concepts}{}{}{section-section-orthog-concepts}"
	"begin{sectionptx}{Section}{Theory}{}{Theory}{}{}{section-section-orthog-theory}"
	"begin{sectionptx}{Section}{Concepts}{}{Concepts}{}{}{section-section-system-geom-concepts}"
	"begin{sectionptx}{Section}{Concepts}{}{Concepts}{}{}{section-section-abstract-vec-spaces-concepts}"
	"begin{sectionptx}{Section}{Theory}{}{Theory}{}{}{section-section-basis-coords-theory}"
	"begin{sectionptx}{Section}{Theory}{}{Theory}{}{}{section-section-col-row-null-space-theory}"
)
for l in ${lines[@]}
do
	sed -i -e "/\\\\${l}/ s|^|\\\\newpage\n|" ${1}
done

# spaces cause problems with the nice array/loop above, can't figure out why
sed -i \
  -e '/\\begin{subsectionptx}{Subsection}{Linear systems as matrix equations}{}{Linear systems as matrix equations}{}{}{subsection-subsection-matrix-ops-theory-sys-as-matrix-eqns}/ s|^|\\newpage\n|' \
  -e '/\\begin{subsectionptx}{Subsection}{Inverse matrices}{}{Inverse matrices}{}{}{subsection-subsection-inverses-concepts-inverses}/ s|^|\\newpage\n|' \
  -e '/\\begin{subsectionptx}{Subsection}{Solving other matrix equations using inverses}{}{Solving other matrix equations using inverses}{}{}{subsection-subsection-inverses-examples-solving-alg-eqns}/ s|^|\\newpage\n|' \
  -e '/\\begin{subsectionptx}{Subsection}{Row space}{}{Row space}{}{}{subsection-subsection-col-row-null-space-theory-rowspace}/ s|^|\\newpage\n|' \
  ${1}
