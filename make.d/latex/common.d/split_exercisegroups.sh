#!/bin/sh

# WARNING *************************************
# these refs might change if exercises are added/removed

# 1-column exercise groups
lines=(
	"begin{divisionexerciseegcol}.*{exercises-systems-7-6}"
	"begin{divisionexerciseegcol}.*{exercises-row-red-6-5}"
	"begin{divisionexerciseegcol}.*{exercisegroup-matrix-ops-matrix-arithmetic-9}"
	"begin{divisionexerciseegcol}.*{exercisegroup-matrix-ops-matrix-arithmetic-20}"
	"begin{divisionexerciseegcol}.*{exercise-matrix-ops-mult-three-rows-against-same-column-2-combine}"
	"begin{divisionexerciseegcol}.*{exercisegroup-matrix-ops-matrix-arithmetic-42}"
	"begin{divisionexerciseegcol}.*{exercise-matrix-ops-systems-as-matrix-eqns-3eqns-3vars}"
	"begin{divisionexerciseegcol}.*{exercise-matrix-ops-power-diag}"
	"begin{divisionexerciseegcol}.*{exercise-matrix-ops-vector-form-3x3-nonhomog}"
	"begin{divisionexerciseegcol}.*{exercise-inverses-solve-sys-3x3-1a}"
	"begin{divisionexerciseegcol}.*{exercises-special-forms-2-13}"
	"begin{divisionexerciseegcol}.*{exercises-special-forms-2-18}"
	"begin{divisionexerciseegcol}.*{exercises-special-forms-2-28}"
	"begin{divisionexerciseegcol}.*{exercises-special-forms-2-35}"
	"begin{divisionexerciseegcol}.*{exercises-det-by-row-red-3-9}"
	"begin{divisionexerciseegcol}.*{exercises-more-det-4-5}"
)
for l in ${lines[@]}
do
	sed -i -e "/${l}/ s|^|\\\\end{exercisegroupcol}\\\\begin{exercisegroupcol}{1}\n|" ${1}
done

# 2-column exercise groups
lines=(
	"begin{divisionexerciseegcol}.*{exercisegroup-matrix-ops-matrix-arithmetic-10}"
	"begin{divisionexerciseegcol}.*{exercisegroup-matrix-ops-matrix-arithmetic-39}"
	"begin{divisionexerciseegcol}.*{exercise-matrix-ops-matrix-arithmetic-1x2-x-2x1-first}"
	"begin{divisionexerciseegcol}.*{exercise-matrix-ops-unipotent-isolates-addition}"
	"begin{divisionexerciseegcol}.*{exercises-special-forms-2-14}"
	"begin{divisionexerciseegcol}.*{exercises-special-forms-2-24}"
	"begin{divisionexerciseegcol}.*{exercises-special-forms-2-29}"
)

for l in ${lines[@]}
do
	sed -i -e "/${l}/ s|^|\\\\end{exercisegroupcol}\\\\begin{exercisegroupcol}{2}\n|" ${1}
done
