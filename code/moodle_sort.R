# moodle sorting
# выгрузка
# 1. клик по тесту
# 2. клик по шестерёнке справа
# 3. клик по "файлы ответов эссе"
# 4. галочки не ставим

library(tidyverse)
library(rio)

setwd('~/Downloads/Q588283/')

stud_list = import('21-22_hse_probability.xlsx', sheet = 1)
glimpse(stud_list)

code_list = import('filestat.xlsx', col_names = c('mail', 'id'))
glimpse(code_list)



code_list = left_join(code_list, stud_list, by = 'mail')

# не привязались:
filter(code_list, is.na(group))

unique_folders = unique(code_list$group)
unique_folders

for (folder in unique_folders) {
  dir.create(folder)
}

glimpse(code_list)

for (i in 1:nrow(code_list)) {
  old_name = code_list$id[i]
  new_name = paste0(code_list$group[i], '/', code_list$student[i], '__', code_list$id[i])

  cat('from:', old_name, 'to:', new_name, '\n')
  file.rename(old_name, new_name)
}

