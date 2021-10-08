# colab.to/r
# rstudio
# клик +, клик r-script

# Задача 1
# X ~ Poisson(rate = 2)
# P(X = k) = exp(-lambda) * lambda ^ k / k!
# P(X = 3) = exp(-2) * 2^3 / 3!

# оцените экспериментально
# a = P(X = 3)
# b = E(X ^ 3)
# c = P(X > 3 |X > 1)
# d = E(X ^ 2 |X > 1)

n_exp = 100000

set.seed(777) # зерно генератора случайных чисел
x = rpois(n_exp, lambda = 2)
x[1:5]

hat_a = mean(x == 3)
hat_a

hat_b = mean(x ^ 3)
hat_b

x_sel = x[x > 1]
x_sel
length(x_sel)

hat_c = mean(x_sel == 3)
hat_c

hat_d = mean(x_sel ^ 2)
hat_d

# Задача 2
# X1, X2, X3 — независимы и равномерны U[5;7]
# раскладка Ильи Бирмана
# оцените
# a = P(X1 + X2 + X3 > 18)
# b = E(X1 * X2 / (X2 + X3))
# c = P(X1 + X2 + X3 > 18 | X2 + X3 > 11)
# d = E(X1 * X2 / (X2 + X3) | X2 + X3 > 11)

sims = data.frame(x1 = runif(n_exp, min = 5, max = 7),
                  x2 = runif(n_exp, min = 5, max = 7),
                  x3 = runif(n_exp, min = 5, max = 7))

sims$event_a = sims$x1 + sims$x2 + sims$x3 > 18
head(sims)

hat_a = mean(sims$event_a)
hat_a

sims$ratio = sims$x1 * sims$x2 / (sims$x2 + sims$x3)

hat_b = mean(sims$ratio)
hat_b

sims_sel = sims[sims$x2 + sims$x3 > 11, ]
head(sims_sel)

hat_c = mean(sims_sel$event_a)
hat_c

hat_d = mean(sims_sel$ratio)
hat_d


