MODEL ?= meta-llama/Llama-2-7b-hf
N ?= 100
OUT ?= results
VERSION ?= dev
RESULTS ?= results/latest.json

.PHONY: help install install-dev test lint experiment analysis bayesian dashboard simulate paper archive clean

help:
	@echo "make install         - install Python dependencies"
	@echo "make test            - run unit tests"
	@echo "make experiment      - run the two-group experiment (MODEL=..., N=...)"
	@echo "make analysis        - frequentist analysis of latest results"
	@echo "make bayesian        - Bayesian analysis of latest results"
	@echo "make dashboard       - launch Streamlit dashboard"
	@echo "make simulate        - generate synthetic data"
	@echo "make paper           - build the LaTeX preprint"
	@echo "make archive         - build clean ZIP archive"

install:
	pip install -r requirements.txt

test:
	pytest -q tests/

experiment:
	python -m src.main --model $(MODEL) --n $(N) --out $(OUT)

analysis:
	python -m src.analysis --results $(RESULTS)

bayesian:
	python -m src.bayesian --results $(RESULTS)

dashboard:
	streamlit run dashboard/app.py

simulate:
	python -m src.simulate --out $(OUT)

paper:
	cd paper && pdflatex preprint.tex && bibtex preprint && pdflatex preprint.tex && pdflatex preprint.tex

archive:
	python scripts/build_archive.py --version $(VERSION)

clean:
	rm -rf __pycache__ src/__pycache__ tests/__pycache__ .pytest_cache .mypy_cache .ruff_cache
	rm -f paper/*.aux paper/*.log paper/*.out paper/*.toc paper/*.bbl paper/*.blg
	rm -rf dist/
