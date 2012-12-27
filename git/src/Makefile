.SUFFIXES: .tex .dvi .aux .bbl .pdf .md
all: c83.dvi c83.pdf
PARTS = maegaki.tex about_git.tex release.tex branch.tex workflow.tex release_auto.tex deploy_stage.tex gitflow.tex branch_rule.tex

.dvi.pdf:
	dvipdfmx -p a4 -f dlbase14.map -o $@ $<
c83.dvi:$(PARTS)
	platex c83.tex
	platex c83.tex
.md.tex:
	pandoc -S -o $@ -f markdown $<

clean:
	rm *.aux *.log $(PARTS)
