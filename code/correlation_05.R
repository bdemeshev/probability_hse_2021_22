library(mvtnorm)
library(tidyverse)

V = matrix(c(1, 0.5, 0.5, 1), nrow = 2)
V

xy = rmvnorm(n = 10^4, mean = c(0, 0), sigma = V)
colnames(xy) = c('x', 'y')
xy_df = as_tibble(xy)
xy_df

mod_yx = lm(data=xy_df, y~x)
coef(mod_yx)

mod_xy = lm(data=xy_df, x~y)
coef(mod_xy)
xy_slope = 1 / coef(mod_xy)[2]
xy_int = - coef(mod_xy)[1] / coef(mod_xy)[2]

qplot(data=xy_df, x=x, y=y) +
  geom_abline(slope = coef(mod_yx)[2], intercept = coef(mod_yx)[1], color = 'blue') +
  geom_abline(slope = 1, intercept = 0, color = 'red') +
  geom_abline(slope = xy_slope, intercept = xy_int, color = 'blue')





