.SUFFIXES: .tex .dvi .aux .bbl .pdf .md
all: c83.dvi c83.pdf
PARTS = 0.maegaki.tex 1.about_git.tex 2.release.tex 3.branch.tex 4.workflow.tex

.dvi.pdf:
	dvipdfmx -p a4 -f dlbase14.map -o $@ $<
c83.dvi:$(PARTS)
	platex c83.tex
	platex c83.tex
.md.tex:
	pandoc -S -o $@ -f markdown $<

clean:
	rm *.aux *.log $(PARTS)
