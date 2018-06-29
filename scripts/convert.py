#!/usr/bin/python

import sys

with open(sys.argv[1],'r') as input, open(sys.argv[1][:-3] + 'xml','w') as output:
    file_content = input\
        .read()\
        .replace("``","<q>")\
        .replace("''","</q>")\
        .replace("\\ie","<ie />")\
        .replace("\\eg","<eg />")\
        .replace("\\dots ","<ellipsis /> ")\
        .replace("\\emph{","<em>")\
        .replace("\\inlinedef{","<term>")\
        .replace("\\inlinedefnoidx{","<term>")\
        .replace("\\[","<me>")\
        .replace("\\]","</me>")\
        .replace("\\begin{enumerate}","<ol>")\
        .replace("\\end{enumerate}","</ol>")\
        .replace("\\begin{lecsubexercises}","<ol label=\"alph\">")\
        .replace("\\end{lecsubexercises}","</ol>")\
        .replace("\\begin{itemize}","<ul>")\
        .replace("\\end{itemize}","</ul>")\
        .replace("\\begin{description}","<dl>")\
        .replace("\\end{description}","</dl>")\
        .replace("\\begin{numthm}","<theorem>")\
        .replace("\\end{numthm}","</theorem>")\
        .replace("\\begin{numprop}","<proposition>")\
        .replace("\\end{numprop}","</proposition>")\
        .replace("\\begin{numlem}","<lemma>")\
        .replace("\\end{numlem}","</lemma>")\
        .replace("\\begin{numcor}","<corollary>")\
        .replace("\\end{numcor}","</corollary>")\
        .replace("\\begin{proof}","<proof><p>")\
        .replace("\\end{proof}","</p></proof>")\
        .replace("\\begin{proofof}","<proof><p>")\
        .replace("\\end{proofof}","</p></proof>")\
        .replace("\\begin{goal}","<heuristic><statement><p> <!-- heuristic has been hijacked to \"Goal\" -->")\
        .replace("\\end{goal}","</p></statement></heuristic>")\
        .replace("\\begin{quest}","<question><statement><p>")\
        .replace("\\end{quest}","</p></statement></question>")\
        .replace("\\begin{note}","<note><p>")\
        .replace("\\end{note}","</p></note>")\
        .replace("\\begin{remark}","<remark><p>")\
        .replace("\\end{remark}","</p></remark>")\
        .replace("\\begin{hint}","<hint><p>")\
        .replace("\\end{hint}","</p></hint>")\
        .replace("\\begin{hintnb}","<hint><p>")\
        .replace("\\end{hintnb}","</p></hint>")\
        .replace("\\begin{warn}","<warning><p>")\
        .replace("\\end{warn}","</p></warning>")\
        .replace("\\begin{align*}","<md><mrow>")\
        .replace("\\end{align*}","</mrow></md>")\
        .replace("\\begin{multline*}","<md><mrow>")\
        .replace("\\end{multline*}","</mrow></md>")\
        .replace("\\subsection*{","<subsection xml:id=\"subsection-TODO-TODO-TODO\"><title>")\
        .replace("\\item","<li>")\
        .replace("\\hsp","")\
        .replace("\\medhsp","")\
        .replace("\\smhsp","")\
        .split('$')
    while len(file_content) > 1:
        output.write(file_content.pop(0))
        output.write("<m>")
        output.write(file_content.pop(0))
        output.write("</m>")
    if len(file_content) == 1:
        output.write(file_content.pop(0))
    output.close()
