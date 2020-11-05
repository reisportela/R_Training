---
output:
  pdf_document: default
  html_document: default
---
# WEB-BASED TOOLS FOR DATA ANALYSIS: JUPYTERLAB ENVIRONMENT AND WORKFLOW OPTIMIZATION
 *M Portela, November 3, 2020*
 
**The material is available in GitHub**

[https://github.com/reisportela/R_Training](https://github.com/reisportela/R_Training)

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/R_Training/HEAD?urlpath=lab)

# 1. Operating system

- Linux (e.g., Ubuntu 20.04), OSX Catalina, Windows 10

# 2. Packages

> **Windows**: consider installing [Chocolatey](https://chocolatey.org/), a package manager for Windows (similar to `yum` in CentOS or `brew` in OSX)

- Python: install Anaconda -- [https://www.anaconda.com](https://www.anaconda.com/)

> **Example, using Chocolatey**: `choco install anaconda3`
>
> or download and install

- **R**: [https://www.r-project.org](https://www.r-project.org/)
- **Julia**: [https://julialang.org](https://julialang.org/)
- **Stata**: [https://www.stata.com](https://www.stata.com/)

> Recomendation: install [RStudio](https://rstudio.com/products/rstudio/download/)

# 3. [Jupyter](https://jupyter.org/)

> "The Jupyter Notebook is an open-source web application that allows you to **create and share** documents that contain _live code_, equations, visualizations and **narrative text**. Uses include: data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more."

## 3.1 Install [jupyter](https://jupyter.org/install)

- Open a Terminal in either Linux or OSX
- Open Windows Powershell as Administrator

_*Run the following lines*_

- **jupyter notebook**: *pip install notebook* **or** *conda install -c conda-forge notebook*
- **jupyter lab**: *pip install jupyterlab* **or** *conda install -c conda-forge jupyterlab*

## 3.2 Install your [kernels](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels)

- **Python**: this should be the first one installed [ipykernel](https://pypi.org/project/ipykernel/)

- **R**: [irkernel](https://irkernel.github.io/installation/)

    Open an R console, e.g. within RStudio, and execute sequentially, *install.packages('IRkernel')*, *IRkernel::installspec()*
    
    Add `Node.js` and `npm`
    
    Visit [Nodejs.org](https://nodejs.org/en/download/) to **install** `Node.js` and `npm`

- **Julia**: [IJulia](https://github.com/JuliaLang/IJulia.jl)

    Run Julia and execute sequentially, *using Pkg*, *Pkg.add("IJulia")*

- **Stata**: [stata_kernel](https://github.com/kylebarron/stata_kernel)

>   for Stata see the instructions by [Kyle Barron](https://kylebarron.dev/stata_kernel/getting_started/)
>
>    [Magics](https://kylebarron.dev/stata_kernel/using_stata_kernel/magics/) -- "Magics are programs provided by stata_kernel that enhance the experience of working with Stata in Jupyter."


## 3.3 Start 'notebook' or 'lab'

Open a `Terminal`/`Power shell`, move to your working folder and type:

- **jupyter notebook**: *jupyter notebook*

- **jupyter lab**: *jupyter lab*

It should open your browser with the notebook and the installed kernels.


## 3.4 Remove a Kernel

> `jupyter kernelspec list`
>
> `jupyter kernelspec uninstall unwanted-kernel`

# 4. [Binder](https://jupyter.org/binder)

[Running R Projects in MyBinder: Dockerfile Creation With Holepunch](https://www.r-bloggers.com/running-r-projects-in-mybinder-dockerfile-creation-with-holepunch/)

- myBinder
- Gesis Notebooks

Check the following link

[Configuration Files](https://mybinder.readthedocs.io/en/latest/using/config_files.html)

**mybinder** allows you to create a linked icon to your interactive notebook

> [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/R_Training/HEAD?urlpath=lab)

> Check the example in GitHub with RStudio & R 3.6 + Python + Julia + Stata 

[`reisportela/prjs`](https://github.com/reisportela/prjs)

- or a setup where we can build a notebook with Python 3.0 or R (you can also run RStudio from this link)

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/reisportela/prjs/master)

Even better, use [GESIS notebooks](https://notebooks.gesis.org/hub/home) to launch your image

[The concept using GESIS](https://notebooks.gesis.org/user/reisportela@gmail.com)

MyBinder: [EXAMPLES](https://github.com/binder-examples)


# 5. A gallery of interesting Jupyter Notebooks

- [Gallery](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)

- [Plotting and Programming in Python](https://swcarpentry.github.io/python-novice-gapminder/)

- [Exploratory data analysis in Python](https://nbviewer.jupyter.org/github/Tanu-N-Prabhu/Python/blob/master/Exploratory_data_Analysis.ipynb)

# 6. Books

- [Python Data Science Handbook](https://jakevdp.github.io/PythonDataScienceHandbook/)

- [Bookdown](https://bookdown.org/)

- [How to Hide all the code cells in Jupyter Notebook Python with single Click](https://www.youtube.com/watch?v=rJsWJMBksK0)

# 7. Checks

- [Binder Multi-language demo](https://github.com/binder-examples/multi-language-demo)

- [mybinder.io](https://mybinder.readthedocs.io/en/latest/index.html)

# 8. SoS [NOTEBOOK](https://vatlab.github.io/sos-docs/)

- [Local installation](https://vatlab.github.io/sos-docs/running.html#Local-installation)

## pip installation

pip3 install sos

pip3 install sos-pbs

pip3 install sos-notebook

pip3 install sos-papermill

pip3 install sos-r

pip3 install sos-julia

pip3 install sos-stata

python3 -m sos_notebook.install

jupyter kernelspec list

jupyter notebook

# 9. Discussion on Julia

- use an environment [julia-python](https://github.com/binder-examples/julia-python)

- a [multi-language-demo](https://blog.jupyter.org/i-python-you-r-we-julia-baf064ca1fb6)

- [Using Julia in Binder: interactive web environment for running your code](https://discourse.julialang.org/t/using-julia-in-binder-interactive-web-environment-for-running-your-code/21802)

By default I will not activate a machine running Python, R and Julia as it takes too long to build the image. I recomend using the [link](http://beta.mybinder.org/v2/gh/binder-examples/julia_python/master).

# 10. [GESIS Notebooks](https://notebooks.gesis.org/)

- Create a login in GESIS Notebooks and add your machine (running RStudio)

![](figures/GESISNotebooks.png)

or a **Jupyter Lab**

![](figures/jupyter_lab.png)

# 11. Further notes

## 11.1 Jupyter's extensions

*conda install -c conda-forge jupyter_contrib_nbextensions*

*jupyter contrib nbextension install --user*

## 11.2 Kaggle Kernels

[Kaggle](https://towardsdatascience.com/introduction-to-kaggle-kernels-2ad754ebf77)


## 11.3 

[How to Hide all the code cells in Jupyter Notebook Python with single Click](https://www.youtube.com/watch?v=rJsWJMBksK0)

## 11.4 Pandas

[Pandas cookbook](https://mybinder.org/v2/gh/jvns/pandas-cookbook/master)

## R and Dropbox

[rdrop2](https://github.com/karthik/rdrop2)

# 12. Usefull links

> [Binder](https://mybinder.org/)
> 
> [CODE OCEAN](https://codeocean.com/)
> 
> [GESIS Notebooks](https://notebooks.gesis.org/hub/home)
> 
> [Hypernet Labs](https://codeocean.com/)
> 
> [IBM Skills Network Lab](https://labs.cognitiveclass.ai/)
> 
> [RStudio Cloud](https://rstudio.cloud/)
