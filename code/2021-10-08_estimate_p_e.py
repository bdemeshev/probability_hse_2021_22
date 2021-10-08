#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct  8 13:12:00 2021

@author: boris
"""


from numpy import mean, exp
import numpy as np
import pandas as pd
# import seaborn as sns
from scipy import stats
!pip install scipy 

# Задачушечка 0.25
# Найдите тильдочку на клавиатурочке

# Задачулька 0.5
# X ~ U[0;1]
# a) сгенерируйте 5 величин равномерных на [0;1] и независимых
stats.uniform.rvs(size=5)
# print()
# colab.to
# b = E(X^3)
# оцените b
n_exp = 100000 
np.random.seed(8888) # задаём зерно генератора
x = stats.uniform.rvs(size=n_exp)
x[0:5]

x ** 3
hat_b = mean(x ** 3)
hat_b


# Задача 1
# X ~ Poisson(rate = 2)
# P(X = k) = exp(-lambda) * lambda ^ k / k!
# P(X = 3) = exp(-2) * 2^3 / 3!

# оцените экспериментально
# a = P(X = 3)
# b = E(X ^ 3)
# c = P(X > 3 |X > 1)
# d = E(X ^ 2 |X > 1) 

# генерация случайных величин
# numpy.random
# scipy.stats
np.random.seed(8888) # задаём зерно генератора
x = stats.poisson.rvs(size=n_exp, mu=2)
x[0:5]

x == 3

hat_a = mean(x == 3)
hat_a

hat_b = mean(x ** 3)
hat_b

x_sel = x[x > 1]
x_sel[0:10]
len(x_sel)

hat_c = mean(x_sel > 3)
hat_c

hat_d = mean(x_sel ** 2)
hat_d

# Задача 2
# X1, X2, X3 — независимы и равномерны U[5;7]
# раскладка Ильи Бирмана
# оцените
# a = P(X1 + X2 + X3 > 18)
# b = E(X1 * X2 / (X2 + X3))
# c = P(X1 + X2 + X3 > 18 | X2 + X3 > 11)
# d = E(X1 * X2 / (X2 + X3) | X2 + X3 > 11)
 
from scipy.stats import uniform

np.random.seed(13) # задаём зерно генератора
sims = pd.DataFrame({'x1': uniform.rvs(size=n_exp, loc=5, scale=2),
    'x2': uniform.rvs(size=n_exp, loc=5, scale=2),
    'x3': uniform.rvs(size=n_exp, loc=5, scale=2)})
sims.head(10)

sims['event_a'] = sims['x1'] + sims['x2'] + sims['x3'] > 18
sims.head()

hat_a = mean(sims['event_a'])
hat_a

sims['ratio'] = sims['x1'] * sims['x2'] / (sims['x2'] + sims['x3'])
sims.head()

hat_b = mean(sims['ratio'])
sims_sel = sims[sims['x2'] + sims['x3'] > 11]

hat_c = mean(sims_sel['event_a'])
hat_c

hat_d = mean(sims_sel['ratio'])
hat_d
