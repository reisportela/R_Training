# R training

Use one of the following alternatives to run the code:

## 1. [RStudioCloud](https://rstudio.cloud)

> Direct link to the project, [https://rstudio.cloud/spaces/100541/project/2953903](https://rstudio.cloud/spaces/100541/project/2953903)

## 2. myBinder project:

> [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/R_Training/HEAD?urlpath=rstudio)

> Link: `https://mybinder.org/v2/gh/reisportela/R_Training/HEAD?urlpath=rstudio`

## 3. myBinder repository:

> [https://github.com/reisportela/R_plus_RStudio](https://github.com/reisportela/R_plus_RStudio)

> and clone the contents of the exercise:

### The direct link to RStudio is

RStudio: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/R_plus_RStudio/HEAD?urlpath=rstudio)

or to the notebook

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/R_plus_RStudio/HEAD)

### Go to:

File > New Project > Version Control > Git

> and paste the following link `https://github.com/reisportela/R_Training.git` in **Repository URL**

## 4. GESIS Notebooks:

> [https://notebooks.gesis.org/](https://notebooks.gesis.org/)

## 5. CodeOcean

> Go to [https://codeocean.com](https://codeocean.com) and create a new capsule from [https://github.com/reisportela/R_Training](https://github.com/reisportela/R_Training)

## 6. WHOLETALE

> Try it at [https://wholetale.org/](https://wholetale.org/)

## 7. GitHub Codespaces

## 8. Install R & RStudio in your machine and download the [project](https://github.com/reisportela/R_Training/archive/refs/heads/master.zip)

## 9. Other

<!--- SEE: https://www.dataschool.io/cloud-services-for-jupyter-notebook -->

> [Google Cloud Platform](https://console.cloud.google.com/)

<!--- [Azure](https://azure.microsoft.com/) -->

> [IBM Cloud Shell](https://cloud.ibm.com/shell)

> [CognitiveLabs (IBM)](https://labs.cognitiveclass.ai/)

> [Colab (Google)](https://colab.research.google.com/)

> [Kaggle Kernels](https://www.kaggle.com/)

> [CoCalc](https://cocalc.com/)

> [Datalore](https://datalore.io/)

> [StarCluster](http://star.mit.edu/cluster/)

## 10. Data

- [Binder Examples](https://github.com/binder-examples)

- [Causality with `R`](https://bookdown.org/paul/applied-causal-analysis/)

- [PSID](https://psidonline.isr.umich.edu/)

- [PORDATA](https://www.pordata.pt/)

- [Harvard Dataverse](https://dataverse.harvard.edu/)

- [European Social Survey](http://www.europeansocialsurvey.org/)

- [Orbis](http://orbiseurope.bvdinfo.com/ip)

- [Angrist Data Archive](https://economics.mit.edu/faculty/angrist/data1/data) -- (see, *e.g.*, [Card](http://economics.mit.edu/faculty/angrist/data1/mhe/card))

- [AMECO](https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco/ameco-database_en)

- [Comtrade](https://comtrade.un.org/)

- [INE](https://www.ine.pt/)

- [Eurostat](https://ec.europa.eu/eurostat)

- [OECD](https://stats.oecd.org/)

- [World Bank](https://data.worldbank.org/)

- [FRED](https://fred.stlouisfed.org/)

- [Journal of Applied Econometrics Data Archive](http://qed.econ.queensu.ca/jae/)

- [Banco de Portugal Microdata Research Laboratory (BPLIM) ](https://bplim.bportugal.pt/)

- [Google Public Data](https://www.google.com/publicdata/directory)

- [NBER](https://www.nber.org/research/data)

- [American Economic Association::Journal Data and Program Archives / Replication Studies](https://www.aeaweb.org/rfe/showCat.php?cat_id=9)

- check [Datasets list in EEG's website](https://www.eeg.uminho.pt/en/investigar/recursos/Pages/default.aspx)



# Build your container

- You can write a script to build your container using our definition file template [container_BPLIM_RStudio_researchers.def](https://github.com/BPLIM/Manuals/tree/master/ExternalServer/container_BPLIM_RStudio_researchers.def) available at our [GitHub repository](https://github.com/BPLIM/Manuals/tree/master/ExternalServer)

- In this template we setup a machine running Ubuntu 20.04, R 4.1 and RStudio 1.3.1093

- You can add your packages in line 90 within `c()`; e.g.,

> `c("tidyverse","haven")`

- Test your script and build the container using [SylabsCloud](https://cloud.sylabs.io/) (you can use your GitHub account to login)

- Click in 'CREATE'

![](media/SylabsCreate.png)

- In the following step upload your '.def' file or copy/paste its contents in the Text box:

![](media/SylabsBuildContainer.png)

- Sylabs runs a first test on the validity of your script and releases the button 'Build' (click on it)

- Follow the outcome at the bottom of the screen and check for possible error messages

- Once you succeed in building the container, you can send us the definition file with your changes

### Use the container in BPLIM's server

- Open a `Terminal`

- Move to your project's folder

> `cd /bplimext/projects/YOURPROJECTID/tools/containers`

- Start the container by typing

> `singularity shell YOURPROJECTID.sif`

- The prompt of the `Terminal` will show: `Singularity`

- Start RStudio by typping `rstudio` (small caps)

![](media/Singularity_Terminal_Prompt.png)



- Once inside RStudio you have access to the original folder structure of your project



<!-- https://lamadon.com/computing.html -->

<!--
# Training

## LITERATE PROGRAMMING EM R MARKDOWN | 12 e 14/10/2021 | By: Miguel Portela

Data: 12 e 14 de Outubro | 18h00-21h00

Lecionado por: Miguel Portela, Universidade do Minho

Literate Programming trata-se de fusão de uma narrativa descritiva com um código de computador num único documento, a partir do qual tanto a documentação legível por humanos, quanto os arquivos legíveis por computador, podem ser criados.

O trabalho deve ser transparente, fácil de atualizar, manter e replicar.

Literate Programming permite economizar tempo e esforço, permitindo dedicar mais tempo à pesquisa. Literate Programming também é útil para o ensino.

Programa: 

1. Markdown e Pandoc
2. Crie um documento de Markdown e execute o código
3. Desenvolva um relatório
4. Publique o relatório

Referências:

Xie, Y., Allaire, J.J. and Grolemund, G., 2018. *R markdown: The definitive guide*. CRC Press.

[https://bookdown.org/yihui/rmarkdown/](https://bookdown.org/yihui/rmarkdown/)

-->