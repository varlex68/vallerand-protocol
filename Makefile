.PHONY: help install install-dev test lint format clean simulate analysis bayesian dashboard paper archive

# Default parameters
MODEL ?= meta-llama/Llama-2-7b-hf
N ?= 100
OUT ?= results
VERSION ?= dev

help:
	@echo "Vallerand Protocol — Makefile targets:"
	@echo ""
	@echo "Setup:"
	@echo "  make install       Install Python dependencies"
	@echo "  make install-dev   Install dev dependencies (ruff, mypy, pytest)"
	@echo ""
	@echo "Testing & Quality:"
	@echo "  make test          Run unit tests"
	@echo "  make lint          Check code style with ruff"
	@echo "  make format        Auto-format code with ruff"
	@echo ""
	@echo "Experiments:"
	@echo "  make simulate      Generate synthetic data (CPU only)"
	@echo "  make experiment    Run two-group experiment (requires GPU)"
	@echo "                     Parameters: MODEL=<model> N=<sample_size>"
	@echo ""
	@echo "Analysis:"
	@echo "  make analysis      Run frequentist statistical analysis"
	@echo "  make bayesian      Run Bayesian statistical analysis"
	@echo "  make dashboard     Launch Streamlit interactive dashboard"
	@echo ""
	@echo "Documentation & Build:"
	@echo "  make paper         Build LaTeX preprint (PDF)"
	@echo "  make archive       Create clean distribution archive"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         Remove build artifacts and cache"

install:
	pip install --upgrade pip
	pip install -r requirements.txt

install-dev: install
	pip install ruff mypy pytest pytest-cov

test:
	pytest -v tests/ --tb=short

lint:
	ruff check src/ tests/
	mypy src/ --ignore-missing-imports || true

format:
	ruff check --fix src/ tests/
	ruff format src/ tests/

simulate:
	python -m src.simulate --out $(OUT)

experiment:
	python -m src.main --model $(MODEL) --n $(N) --out $(OUT)

analysis:
	python -m src.analysis --results $(OUT)/latest.json

bayesian:
	python -m src.bayesian --results $(OUT)/latest.json

dashboard:
	streamlit run dashboard/app.py

paper:
	cd paper && pdflatex -interaction=nonstopmode preprint.tex && \
	bibtex preprint && \
	pdflatex -interaction=nonstopmode preprint.tex && \
	pdflatex -interaction=nonstopmode preprint.tex

archive:
	@mkdir -p dist
	@tar --exclude=.git \
	     --exclude=.github \
	     --exclude=.venv \
	     --exclude=dist \
	     --exclude=__pycache__ \
	     --exclude=.pytest_cache \
	     --exclude=.mypy_cache \
	     --exclude=.ruff_cache \
	     -czf dist/vallerand-protocol-$(VERSION).tar.gz .
	@echo "Archive created: dist/vallerand-protocol-$(VERSION).tar.gz"

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .pytest_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .mypy_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .ruff_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	rm -rf paper/*.aux paper/*.log paper/*.out paper/*.toc paper/*.bbl paper/*.blg
	rm -rf dist/ build/ *.egg-info
	@echo "Clean complete"
