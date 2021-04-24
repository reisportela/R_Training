## https://github.com/r-cas/ryacas0/

## Source: https://www.andrewheiss.com/blog/2019/02/16/algebra-calculus-r-yacas/

# without vignettes
# devtools::install_github("r-cas/ryacas0")

# with vignettes
devtools::install_github("r-cas/ryacas0", 
                         build_opts = c("--no-resave-data", "--no-manual"))
# after installation
help(package = Ryacas0)
# or
vignette(package = "Ryacas0")


library(tidyverse)
library(Ryacas0)

update_geom_defaults("label", list(family = "Encode Sans Condensed Bold"))

# Define some variables to work with
x <- Sym("x")
y <- Sym("y")
U <- Sym("U")


# Prices and budget -------------------------------------------------------
total_budget <- 45
price_x <- 3
price_y <- 1.5

# Build budget line
n_pizza <- total_budget / price_x
n_yogurt <- total_budget / price_y
slope <- -n_yogurt / n_pizza

budget <- function(x) (slope * x) + n_yogurt


# Utility and indifference ------------------------------------------------
# U = x^2 0.25y
utility_u <- function(x, y) x^2 * (0.25 * y)

# Rewrite as y = something
utility_y <- function(my_x, my_U) {
  solved <- Solve(utility_u(x, y) == U, y)
  solution <- Eval(solved, list(x = my_x, U = my_U))
  as.numeric(str_extract(solution, "-?[0-9]\\d*(\\.\\d+)?"))
}

# Marginal rate of substitution
marginal_utility <- function(my_x) {
  mux_muy <- Simplify(deriv(utility_u(x, y), x) / deriv(utility_u(x, y), y))
  mux_muy_price <- Solve(paste(mux_muy, "==", price_x, "/", price_y), y)
  solution <- Eval(mux_muy_price, list(x = my_x))
  as.numeric(str_extract(solution, "-?[0-9]\\d*(\\.\\d+)?"))
}


# Optimal points ----------------------------------------------------------
# Find best x
optimal_x <- uniroot(function(x) budget(x) - marginal_utility(x), c(0, 100))$root

# Plug best x into the budget function to find best y
optimal_y <- budget(optimal_x)

# Plug optimal x and y into utility function to find maximum utils given the budget
max_utility <- utility_u(optimal_x, optimal_y)


# Plot everything ---------------------------------------------------------
ggplot() + 
  # Budget line
  stat_function(data = tibble(x = 0:15), aes(x = x),
                fun = budget, color = "#638ccc", size = 1.5) +
  annotate(geom = "label", x = 2.5, y = budget(2.5), 
           label = "Budget", color = "#638ccc") +
  # Best indifference curve
  stat_function(data = tibble(x = 1:15), aes(x = x),
                fun = utility_y, args = list(my_U = max_utility),
                color = "#ca5670", size = 1.5) +
  annotate(geom = "label", x = 7, y = utility_y(7, max_utility), 
           label = paste0("U = ", max_utility), color = "#ca5670") +
  # Dotted lines to show x and y
  annotate(geom = "segment", x = 0, y = optimal_y, xend = optimal_x, yend = optimal_y,
           linetype = "dashed", color = "grey50", size = 0.5) +
  annotate(geom = "segment", x = optimal_x, y = 0, xend = optimal_x, yend = optimal_y,
           linetype = "dashed", color = "grey50", size = 0.5) +
  # Dot at optimal point
  annotate(geom = "point", x = optimal_x, y = optimal_y, size = 3) +
  labs(x = "Slices of pizza", y = "Bowls of frozen yogurt") +
  scale_x_continuous(expand = c(0, 0), breaks = seq(0, 15, 5)) +
  scale_y_continuous(expand = c(0, 0), breaks = seq(0, 30, 10)) +
  coord_cartesian(xlim = c(0, 16), ylim = c(0, 32)) +
  theme_classic(base_family = "Encode Sans Condensed") + 
  theme(axis.title.x = element_text(margin = margin(t = 10)),
        axis.title.y = element_text(margin = margin(r = 10)),
        axis.title = element_text(family = "Encode Sans Condensed Medium"))
