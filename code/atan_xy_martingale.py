#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec  2 22:16:38 2021

@author: boris
"""

import numpy as np

from sympy import *
init_printing(use_unicode=True)

x, y = symbols('x y')
simplify(diff(diff(atan(x/y), x), x) + diff(diff(atan(x/y), y), y))

atan
