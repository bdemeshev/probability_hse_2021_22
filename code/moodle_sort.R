# moodle sorting
# шаг 1. выгрузка прикрепленных ответов:
# 1. клик по тесту
# 2. клик по шестерёнке справа
# 3. клик по "файлы ответов эссе"
# 4. галочки не ставим
# шаг 2. выгрузка фактических условий:
# 1. клик по тесту
# 2. клик по шестерёнке справа
# 3. клик по "отчеты в pdf" ? "выгрузка попыток в pdf"
# иногда глючит и говорит что нет какого-то плагина wkhtmlpdf
# лечится чем-то типа выйти и снова зайти как положено
# 4. сформировать отчёт "для вступительных"
# ждём пару минут
# 5. клик по скачать
# шаг 3. разархивируем оба архива с шага 1 и шага 2 в общую папку.
# шаг 4. в эту же папку скачиваем xlsx со списком студентов из гугл-дока
# правим в скрипте setwd() на эту папку.


library(tidyverse)
library(rio)

setwd('~/Downloads/kr2/Q721799/')
setwd('~/Downloads/kr2/Q721805/')

stud_list = import('21-22_hse_probability - main(7).csv', sheet = 1)
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

  cat('answers from:', old_name, 'to:', new_name, '\n')
  file.rename(old_name, new_name)

  old_name = paste0('no_asav_id_', code_list$id[i], '.pdf')
  new_name = paste0(code_list$group[i], '/', code_list$student[i], '__', code_list$id[i], '/', code_list$student[i], '__', code_list$id[i], '__variant.pdf')
  cat('variant from:', old_name, 'to:', new_name, '\n')
  file.rename(old_name, new_name)
}

