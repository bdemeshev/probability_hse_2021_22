library(tidyverse)
library(rio)
library(estimatr)
library(lmtest)
library(ggridges)
library(forcats)


setwd('~/Downloads/Q588283/')

stud_list = import('21-22_hse_probability.xlsx', sheet = 1)
glimpse(stud_list)

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

?fct_recode


filter(stud_list, is.na(sex))

stud_list_ = filter(stud_list, !is.na(sex))


ggplot(stud_list_, aes(col = sex, x = kr_1_test, fill = sex)) +
  geom_density() + geom_rug(aes(y = 0), position = 'jitter', sides='b') +
  facet_grid(sex ~ .)



group_summary = group_by(stud_list, group) %>% summarise(av = mean(kr_1_test, na.rm = TRUE),
                                                         sd = sd(kr_1_test, na.rm = TRUE),
                                                         min = min(kr_1_test, na.rm = TRUE),
                                                         max = max(kr_1_test, na.rm = TRUE),
                                                         n = n())
group_summary = mutate(group_summary, group_no = as.numeric(str_extract(group, '[0-9]*$')))
group_summary = mutate(group_summary, group_text = paste0(group, '\n(n=', n, ')'))

group_summary

levels(stud_list_$group) = group_summary$group_text


ggplot(stud_list_, aes(x = kr_1_test, y = sex, fill = stat(x))) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01)

ggplot(stud_list_, aes(x = kr_1_test, y = group, fill = stat(x))) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
  labs(title = 'Результаты тестовой части кр 1', x = 'Балл', y = '') +
  theme(legend.position = 'none')


n_obs = nrow(stud_list_) - sum(is.na(stud_list_$kr_1_test))
n_obs

the_title = paste0('Результаты тестовой части кр 1 по теории вероятностей (2021 год, n = ', n_obs, ')')

ggplot(stud_list_, aes(x = kr_1_test, y = group, fill = factor(stat(quantile)))) +
  stat_density_ridges(
    geom = "density_ridges_gradient",
    calc_ecdf = TRUE,
    quantiles = c(0.05, 0.95),
    jittered_points = TRUE,
    position = position_points_jitter(width = 0.33, height = 0.0),
    point_shape = '|', point_size = 3, point_alpha = 1, alpha = 0.7
  ) +
  scale_fill_manual(
    name = "Квантили", values = c("#FF0000A0", "#A0A0A0A0", "#0000FFA0"),
    labels = c("Левые 5%", "Серединка", "Правые 5%")
  ) +
  labs(title = the_title, x = 'Балл', y = '')


ggplot(stud_list_, aes(x = kr_1_test, y = sex, fill = factor(stat(quantile)))) +
  stat_density_ridges(
    geom = "density_ridges_gradient",
    calc_ecdf = TRUE,
    quantiles = c(0.05, 0.95),
    jittered_points = TRUE,
    position = position_points_jitter(width = 0.33, height = 0.0),
    point_shape = '|', point_size = 4, point_alpha = 1, alpha = 0.7
  ) +
  scale_fill_manual(
    name = "Квантили", values = c("#FF0000A0", "#A0A0A0A0", "#0000FFA0"),
    labels = c("Левые 5%", "Серединка", "Правые 5%")
  ) +
  labs(title = the_title, x = 'Балл', y = '')




sex_summary = group_by(stud_list, sex) %>% summarise(av = mean(kr_1_test, na.rm = TRUE),
                                 sd = sd(kr_1_test, na.rm = TRUE),
                                 n = n())
sex_summary

reg = lm_robust(data = res, kr_1_test ~ sex, se_type = 'HC3')
summary(reg)

bptest(data = res,
       formula = kr_1_test ~ sex,
       varformula = ~ sex)


