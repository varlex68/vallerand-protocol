# Vallerand Protocol — Infomechanodynamics & Distinctive Distonic Science

Experimental metrology protocol for testing the informational impedance collapse under a participatory endo-modeling posture (β → 0).

**Author:** Alexandre Vallerand (DOI: 10.5281/zenodo.22969532)  
**Official Portal:** [https://infomecanodynamics.space-z.ai/](https://infomecanodynamics.space-z.ai/)  
**Status:** Pre-registered / Reproducible

## Overview

This repository contains the complete open-science pipeline:
- LaTeX preprint of the protocol (`paper/`);
- Pre-registration document (`preregistration/`);
- Python pipeline to run the two-group experiment (`src/`);
- Frequentist & Bayesian statistical analysis (`src/analysis.py`, `src/bayesian.py`);
- Streamlit interactive dashboard (`dashboard/app.py`);
- Synthetic data simulator for CPU-only validation (`src/simulate.py`);
- Physical correlation interface for Johnson-Nyquist noise & NV magnetometry (`src/physical.py`);
- Automated unit tests, Docker environment, and GitHub/Zenodo CI workflows.

## Quick start

```bash
git clone <[repo](https://github.com/varlex68/vallerand-protocol)>
cd vallerand-protocol
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# Run unit tests
make test

# Run simulator (no GPU required)
make simulate

# Run frequentist & Bayesian analysis
make analysis
make bayesian

# Launch visualization dashboard
make dashboard
```

## Running with Real LLM (GPU required)

```bash
make experiment MODEL=meta-llama/Llama-2-7b-hf N=100
```

## License
MIT — see LICENSE.
