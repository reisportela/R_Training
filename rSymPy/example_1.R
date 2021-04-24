# https://rdrr.io/cran/rSymPy/

library(rSymPy)

# create a SymPy variable called x
sympy("var('x')")
sympy("y = x*x")
sympy("y")

sympy("limit(1/x, x, oo)")

# the next line fails under jython even without R
# and seems to corrupt the rest of the session
# sympy("(1/cos(x)).series(x, 0, 10)")

sympy("diff(sin(2*x), x, 1)")
sympy("diff(sin(2*x), x, 2)")

sympy("integrate(exp(-x), (x, 0, oo))")

sympy("xr = Symbol('xr', real=True)")
sympy("exp(I*xr).expand(complex=True)")

# Matrices are stored row by row (unlike R matrices)
cat(sympy("A = Matrix([[1,x], [y,1]])"), "\n")
cat(sympy("A**2"), "\n")



## End(Not run)



## https://rpubs.com/djlofland/math_workshop_1

library(Deriv)
library(mosaic)
library(mosaicCalc)
library(rSymPy)

myf1=function(x){1-exp(-lambda*x)}
print(Deriv(myf1))

#####


eq <- "x^2 + 4 + 2*x + 2*x"
yac_str(eq) # No task was given to yacas, so we simply get the same returned

yac_str(paste0("Simplify(", eq, ")"))
