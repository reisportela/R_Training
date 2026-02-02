# R Training

Materials for learning and teaching R (data analysis, econometrics, and reproducible workflows).

## Contents

- [Quick start](#quick-start)
- [Repository structure](#repository-structure)
- [Data sources](#data-sources)
- [Containers (BPLIM and Singularity)](#containers-bplim-and-singularity)
- [Reproducibility resources](#reproducibility-resources)
- [Course links](#course-links)
- [References](#references)
- [Power BI example](#power-bi-example)

## Quick start

### Run online (no installation)

- **Posit Cloud**: open the workspace at <https://rstudio.cloud/spaces/100541/project/2953903>.
- **Binder (RStudio, this repo)**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/R_Training/HEAD?urlpath=rstudio)  
  Direct link: <https://mybinder.org/v2/gh/reisportela/R_Training/HEAD?urlpath=rstudio>
- **GitHub Codespaces**: use the GitHub “Code” button → “Codespaces” (recommended when you need a more stable session).
- **Other hosted options**:
  - GESIS Notebooks: <https://notebooks.gesis.org/>
  - Code Ocean: create a new capsule from <https://github.com/reisportela/R_Training>
  - Whole Tale: <https://wholetale.org/>

<details>
<summary>More environments (mostly Jupyter-focused)</summary>

- Google Cloud Platform: <https://console.cloud.google.com/>
- IBM Cloud Shell: <https://cloud.ibm.com/shell>
- CognitiveLabs (IBM): <https://labs.cognitiveclass.ai/>
- Google Colab: <https://colab.research.google.com/>
- Kaggle: <https://www.kaggle.com/>
- CoCalc: <https://cocalc.com/>
- Datalore: <https://datalore.io/>
- StarCluster: <http://star.mit.edu/cluster/>
- Galileo: <https://hypernetlabs.io/galileo/>
- Binder examples: <https://github.com/binder-examples>

</details>

<details>
<summary>Alternative Binder setup (using <code>reisportela/R_plus_RStudio</code>)</summary>

1. Open Binder with RStudio: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/R_plus_RStudio/HEAD?urlpath=rstudio)
2. In RStudio, go to: <kbd>File</kbd> → <kbd>New Project</kbd> → <kbd>Version Control</kbd> → <kbd>Git</kbd>
3. Paste `https://github.com/reisportela/R_Training.git` into **Repository URL**.

</details>

### Run locally

1. Install **R**: <https://cran.r-project.org/>
2. Install **RStudio Desktop** (recommended): <https://posit.co/download/rstudio-desktop/>
   - Alternative: install Anaconda/Miniconda (if you already use conda): <https://www.anaconda.com/>
3. Get the materials:
   - Download ZIP: <https://github.com/reisportela/R_Training/archive/refs/heads/master.zip>
   - Or clone: `git clone https://github.com/reisportela/R_Training.git`
4. Install packages used across the notebooks/scripts:
   - From a terminal: `Rscript install.R`
   - Or inside R: `source("install.R")`

## Repository structure

- `RIntro/` — introductory material.
- `EDA/` — exploratory data analysis.
- `regression/` — regression + causality material.
- `Econometrics/` — econometrics examples.
- `paneldata/` — panel data.
- `timeseries/` — time series.
- `fuzzy/` — fuzzy logic examples.
- `data/` — datasets and supporting files.
- `jupyter_notebooks/` — Jupyter-based notebooks and notes.
- `latex/`, `literate_programming/` — writing/reporting material.

## Data sources

<details>
<summary>Portugal</summary>

- [Banco de Portugal Microdata Research Laboratory (BPLIM)](https://bplim.bportugal.pt/)
- [INE](https://www.ine.pt/)
  - [Microdados (protocolo INE/FCT)](https://www.dgeec.medu.pt/art/6499db7d9eff36f307f07bdb/65293837121f641a986cc618/65495a4a79026a41502e3e82/64ef206c6358acfd7e9fa9fb)
  - [Censos](https://censos.ine.pt/)
  - [Anuários Estatísticos Regionais](https://www.ine.pt/xportal/xmain?xpid=INE&xpgid=ine_doc_municipios)

![INE products](images/INE_Produtos.PNG)

- [PORDATA](https://www.pordata.pt/)
- [Dados abertos (Data.gov.pt)](https://data.gov.pt/)
- [Portal Autárquico](https://www.portalautarquico.pt/) (e.g., “contas de gerência”)
- [Fundação José Neves — Brighter Future](https://brighterfuture.joseneves.org/)
- [Orbis](https://orbiseurope.bvdinfo.com/ip)
- [Marktest — Sales Index](https://www.marktest.com/wap/a/grp/p~18.aspx) (EEG computer lab)

![Sales Index app](images/SalesIndex.png)

</details>

<details>
<summary>Other</summary>

- [Causality with R](https://bookdown.org/paul/applied-causal-analysis/)
- [PSID](https://psidonline.isr.umich.edu/)
- [Harvard Dataverse](https://dataverse.harvard.edu/)
- [European Social Survey](http://www.europeansocialsurvey.org/)
- [Angrist Data Archive](https://economics.mit.edu/people/faculty/josh-angrist/angrist-data-archive)
- [AMECO](https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco/ameco-database_en)
- [UN Comtrade](https://comtrade.un.org/)
- [Eurostat](https://ec.europa.eu/eurostat)
- [OECD](https://stats.oecd.org/)
- [World Bank](https://data.worldbank.org/)
- [FRED](https://fred.stlouisfed.org/)
- [Journal of Applied Econometrics — Data Archive](http://qed.econ.queensu.ca/jae/)
- [Google Public Data](https://www.google.com/publicdata/directory)
- [NBER Data](https://www.nber.org/research/data)
- [AEA — Journal Data/Programs & replication](https://www.aeaweb.org/rfe/showCat.php?cat_id=9)
- [EEG datasets list](https://www.eeg.uminho.pt/en/investigar/recursos/Pages/default.aspx)

</details>

## Containers (BPLIM and Singularity)

<details>
<summary>Build and run an RStudio container for BPLIM</summary>

- Start from the template [`container_BPLIM_RStudio_researchers.def`](https://github.com/BPLIM/Manuals/tree/master/ExternalServer/container_BPLIM_RStudio_researchers.def)
  - Repository: <https://github.com/BPLIM/Manuals/tree/master/ExternalServer>
- The template targets Ubuntu 20.04 with R 4.1 and RStudio 1.3.1093.
- Add your R packages in the `c(...)` list (around line ~90). Example: `c("tidyverse", "haven")`.
- Build using [Sylabs Cloud](https://cloud.sylabs.io/) → **CREATE** (you can log in with GitHub):
  - Upload your `.def` file or paste its contents.
  - Check the build log for errors; if the build succeeds, share the updated `.def` file with your changes.

![](media/SylabsCreate.png)

![](media/SylabsBuildContainer.png)

### Use the container on the BPLIM server

```bash
cd /bplimext/projects/YOURPROJECTID/tools/containers
singularity shell YOURPROJECTID.sif
rstudio
```

![](media/Singularity_Terminal_Prompt.png)

</details>

## Reproducibility resources

- [AEA Data Editor — Docker for reproducibility in economics](https://aeadataeditor.github.io/posts/2021-11-16-docker)
- [AEA Data Editor — Stata project with automated Docker builds](https://github.com/AEADataEditor/stata-project-with-docker)

## Course links

### Applied Economics project (Projeto em Economia Aplicada)

This repository is used as supporting material. See [Quick start](#quick-start) for setup options.

### R Training (Nelson Areal, Universidade do Minho)

- Course site: <https://intro2r.nelsonareal.net/en>
- Posit Cloud signup: <https://login.posit.cloud/>
- Sessions:
  - Introduction to R — Session 1: <https://nareal.net/g-intro2r-s1>
  - Introduction to R — Session 2: <http://nareal.net/g-intro2r-s2>
  - Data visualisation — Session 1: <http://nareal.net/g-dv-s1>
  - Data visualisation — Session 2: <http://nareal.net/g-dv-s2>

### Building a dashboard with R

- Flexdashboard:
  - Examples: <https://rstudio.github.io/flexdashboard/articles/examples.html>
  - Using flexdashboard: <https://rstudio.github.io/flexdashboard/articles/using.html>
  - Package docs: <https://pkgs.rstudio.com/flexdashboard/>

<details>
<summary>Literate programming</summary>

- Reference: *R Markdown: The Definitive Guide* — <https://bookdown.org/yihui/rmarkdown/>

</details>

## References

1. [R for Data Science](https://r4ds.had.co.nz/)
2. [R Graphics Cookbook](https://r-graphics.org/)
3. [R Markdown: The Definitive Guide](https://bookdown.org/yihui/rmarkdown/)
4. [How to Choose the Right Data Visualization](https://chartio.com/learn/charts/how-to-choose-data-visualization/)
5. [Practical Statistics for Data Scientists](https://www.oreilly.com/library/view/practical-statistics-for/9781491952955/)
6. [A Visual Guide to Stata Graphics](https://www.stata.com/bookstore/visual-guide-to-stata-graphics/)
7. [Causal Inference: The Mixtape](https://mixtape.scunning.com/introduction.html)
8. [Purdue OWL (APA style basics)](https://owl.purdue.edu/owl/research_and_citation/apa_style/apa_formatting_and_style_guide/in_text_citations_the_basics.html)

## Power BI example

- Brighter Future (FBA): <https://www.brighterfuture.pt/>
