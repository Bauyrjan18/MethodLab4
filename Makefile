PAPER_DIR = paper
FIGURES_DIR = figures
SCRIPTS_DIR = scripts

all: pdf

pdf:
	cd $(PAPER_DIR) && pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex

clean:
	cd $(PAPER_DIR) && rm -f *.aux *.bbl *.blg *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz

tables:
	python $(SCRIPTS_DIR)/export_metrics.py

diagram:
	powershell -ExecutionPolicy Bypass -File $(SCRIPTS_DIR)/generate_architecture.ps1

.PHONY: all pdf clean tables diagram
