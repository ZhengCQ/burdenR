# burdenR
![PyPI](https://img.shields.io/pypi/v/burdenr)
![Build](https://img.shields.io/badge/build-passing-brightgreen)

**burdenR** is a Python command-line tool for calculating the relative mutation burden (burden relative risk) between populations from annotated vcf  with snpEff
It supports input from either VCF files or pre-computed genotype frequency tables and produces risk analysis results and visual plots.

---

## Features
✅ Accepts Anno VCF with SnpEFF or genotype frequency tables as input  
✅ Computes burden relative risk between two populations  
✅ Supports bootstrapping for confidence intervals  
✅ Multi-threaded processing and rapid computing for large datasets (10S for 10K variants)
✅ Outputs risk results and PDF/PNG plots  
✅ Automatic cleaning of malformed rows in input files

---



## Installation

Recommended for Python ≥ 3.8.

Install via pip:

```bash
pip install burdenR
```

## Usage
### Basic Command
```bash
python burdenr/cli.py \
  -f <INPUT_FILE> \
  -w <WORK_DIR> \
  -A <POPULATION_A> \
  -B <POPULATION_B> \
  -G <GROUP_INFO_FILE>
```
### Example
Calculate burden relative risk for population popA vs. popB from a VCF file:
```
burdenr -f GATK_vcftoolsfilter.recode.anno.vcf.gz \
        -w work_dir -A popA -B popB \
        -G group_info.tsv  \
        --n-cores 4 \
        --boostrap_n 100 \
```
### Option
| Option             | Description                                                                                                                              |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `-f, --infile`     | Input file path. Supports VCF (`.vcf`, `.vcf.gz`) or genotype frequency table (`gt_freq_info.tsv` or `.tsv.gz`).                         |
| `-w, --work-dir`   | Working directory where output files will be saved. Default: `./workdir`.                                                                |
| `-A`               | Name of population A (target population).                                                                                                |
| `-B`               | Name of population B (reference population).                                                                                             |
| `-C`               | Name of population C (outgroup population), optional.                                                                                    |
| `-G, --group-info` | Path to a tab-separated file specifying sample groups. Format: `Group<TAB>Sample`.                                                       |
| `--freq`           | Allele frequency threshold. Variants with frequencies above this threshold in either population will be excluded. Default: no filtering. |
| `--fix-sites`      | Number of fixed sites to use for jackknife resampling. Defaults to one-fifth of total sites if not specified.                            |
| `--boostrap_n`     | Number of bootstrap iterations to calculate risk. Default: 100.                                                                          |
| `--n-cores`        | Number of CPU cores to use for multiprocessing. Default: 4.                                                                              |

### Group Info File Format
Example `group_info.tsv`:
```txt
Group   Sample
popA    Sample_1
popA    Sample_2
popB    Sample_3
popB    Sample_4
popC    Sample_5
```

### Supported Input Formats
* VCF files (e.g. `example.vcf.gz`), should be annotation by snpEff
* Pre-computed genotype frequency tables (e.g. `gt_freq_info.popA_vs_popB.tsv`)
  
### Output
The following files are produced in your specified `work-dir`:  
* `derived_info.<popA>_vs_<popB>.tsv`  
Derived allele information and population frequencies.

* `riskAB/results.<popA>_vs_<popB>.tsv`  
Table summarizing burden relative risk estimates.

* Visual plots:

* riskAB/Burden_risk.<popA>_vs_<popB>.pdf

* riskAB/Burden_risk.<popA>_vs_<popB>.png

If the `--freq` parameter is used, filenames will include frequency threshold information.

### Workflow

1. Read sample group information.

2. Process the input file:

* If VCF, convert to genotype frequency table.

* If already a frequency table, read directly.

3. Compute derived allele frequencies.

4. Estimate burden relative risk (AB method).

5. Generate result tables and plots.