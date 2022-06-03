library(tidyverse)
library(rio)
library(estimatr)
library(lmtest)
library(ggridges)
library(forcats)
library(corrplot)
library(factoextra)
stud_list = import('~/Downloads/21-22_hse_probability - main(1).csv', sheet = 1)
stud_list = mutate(stud_list, 
                   auditorka = as.numeric(str_replace(auditorka, ',', '.'))
)
# glimpse(stud_list)

stud_list$sex = NA_character_

female_strings = 'вна$|ова |ева |ина$|ия$|Алла|Виолетта|Русана'
male_strings = 'ич$|ов |ев |ан$|ен$|Мустафа|Дмитрий|Александр|Лукас|Амантур|Назар|Джангир|Артём|Абзалбек|Халиужий|Габриел'

stud_list = mutate(stud_list, sex = case_when(str_detect(student, male_strings) ~ 'male',
                                              str_detect(student, female_strings) ~ 'female',
                                              TRUE ~ sex))

levs = c("БЭК201", "БЭК202", "БЭК203", "БЭК205", "БЭК206", "БЭК207", "БЭК208", "БЭК209",
         "БЭК2010", "БЭК2011", "БЭК2012")

stud_list = mutate(stud_list, sex = factor(sex),
                   group = factor(group, levels = levs))
stud_list = mutate(stud_list, ip = 1 * (group %in% c('БЭК201', 'БЭК202', 'БЭК203')))

filter(stud_list, is.na(sex))
stud_list_random = stud_list[sample(nrow(stud_list)), ]

glimpse(stud_list_random)

stud_list_anon = select(stud_list_random, 
                        -(student:private_comment1), -(V46:V54), -comment, -private_comment2,
                        -k1_reply4)

export(stud_list_anon, '~/Documents/probability_hse_2021_22/stud_anon.csv')
