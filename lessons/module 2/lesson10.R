
# Установить пакеты httr2, readr, rvest
# Изучить схему для эндпоинта laureates
# Получить данные по нобелевским лауреатам по экономике за последние 10 лет в формате json
# Написать фукнцию для превращения информации о лауреате в табличный формат со следующими колонками: id, fullName, gender, birth_date, birth_country, prize_year. Год награды брать первый
# Преобразовать список в data.frame с помощью последовательного выполнения функций Map и Reduce
# Сохранить результат в локальный файл в формате tsv (файл прилагать не надо)
# Выбрать десять курсов на otus
# Собрать информацию о дате начала, длительности и стоимости каждого курса
# Записать результаты в таблицу вида ""ссылка, название курса, дата начала, длительность, стоимость""
# Сохранить результаты в формате csv (файл прилагать не надо)

# Вопрос по задачкам. Например: добавить несколько примеров
# для самостоятельного решения в конце презентации

# Код к занятию про БД

# install.packages("httr2")
library(httr2)
library(readr)

base_url <- 'https://api.nobelprize.org/2.1'

# nobelPrizeCategory=eco, nobelPrizeYear=2013, yearTo=2022
request(base_url = base_url) %>% 
  req_url_path_append('laureates') %>%
  req_url_query(nobelPrizeCategory = 'eco',
                nobelPrizeYear = 2013,
                yearTo = 2022) %>% 
  req_perform() %>% 
  resp_body_json() %>% 
  `$`(., 'laureates') %>% 
  Map(\(x) {
    laureat_row <- data.frame(
      id = laureat$id,
      full_name = laureat$fullName$en,
      gender = laureat$gender,
      birth_date = laureat$birth$date,
      birth_country = laureat$birth$place$country$en,
      prize_year = laureat$nobelPrizes[[1]]$awardYear
    )
    return(laureat_row)
  }, .) %>% 
  dplyr::bind_rows()

# Написать фукнцию для превращения информации о лауреате в табличный формат со следующими колонками: id, fullName, gender, birth_date, birth_country, prize_year. Год награды брать первый

str(laureates)

laureates$laureates[[1]]$id
laureates$laureates[[1]]$fullName$en
laureates$laureates[[1]]$gender
laureates$laureates[[1]]$birth$date
laureates$laureates[[1]]$birth$place$country$en
laureates$laureates[[1]]$nobelPrizes[[1]]$awardYear

extract_laureat <- function(laureat) {
  laureat_row <- data.frame(
    id = laureat$id,
    full_name = laureat$fullName$en,
    gender = laureat$gender,
    birth_date = laureat$birth$date,
    birth_country = laureat$birth$place$country$en,
    prize_year = laureat$nobelPrizes[[1]]$awardYear
  )
  return(laureat_row)
}

laureates_df_list <- Map(extract_laureat, laureates$laureates)

Reduce(rbind, laureates_df_list, accumulate = TRUE) |> View()

library(rvest)
"<a class = 'dsfb onojn'>"

html_elements(css = 'a.dsfb.onojn')