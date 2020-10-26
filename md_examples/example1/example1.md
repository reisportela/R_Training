---
title: A simple example using Markdown
author: Paulo Guimaraes and Miguel Portela
date: 23 January 2020 
---

# Working with text

Markdown is very easy to use.
You can write in *italics* or in **bold**. 
You can even ~~strikeout~~

It is very easy to make headers

## Sub header

some text

### Lower level

and more text

# Blocking text

> This is how
> blocked text
> looks like

# Introducing a link

If you click on [*Stata Winter School*](//https://www.timberlake.co.uk/stata-econometrics-winter-school-2019.html) it will send you to the website

# Introducing an image

This is how you had an image. The image can be read from your computer or even from the internet
![text](https://upload.wikimedia.org/wikipedia/commons/7/79/Stata_logo_med_blue.png "Stata Logo")

# Making lists is simple

* Item 1
  * Item 11
  * Item 12
* Item 2

or even numeric lists

1. This is item1

2. This is item2

5. This is item3

# An here is a simple table

|      | col1 | col2 |
|:-----|-----:|-----:|
| row1 | 1    | 4    |
| row2 | 2    | 3    |


# Writing in Latex

If you have $LaTeX$ installed you can write $LaTeX$ expressions directly. All you need is to enclose the code in `$` signs.
Here is an expression written inline $a^2+b^2=c^2$.
And this is how you write a display equation[^1]

[^1]: But you must have $LaTeX$ installed. 

$$
a^2+b^2=c^2
$$

# Adding HTML (works with HTML)

Markdown will recognize raw HTML code!

<em> Emphasizing a line using HTML </em> 

<a href="//www.stata.com/"> Go to Stata Website</a> 
