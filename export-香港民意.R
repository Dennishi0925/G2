library(tidyverse)
# fs::dir_ls("data/香港民意調查/")

df_citizen_good <- read_csv("data/香港民意調查/香港市民對各國人民好感程度.csv")
df_citizen_bad <- read_csv("data/香港民意調查/香港市民對各國人民惡感程度.csv")
df_government_good <- read_csv("data/香港民意調查/香港市民對各國政府好感程度.csv")
df_government_bad <- read_csv("data/香港民意調查/香港市民對各國政府惡感程度.csv")

df_citizen_good_long <- df_citizen_good %>% select(1,2,matches("Mainland|Taiwan|Macau|Hong Kong")) %>%
  select(-1) %>%
  rename(date = 1, hk = 2, china = 3, taiwan = 4, macau = 5) %>%
  pivot_longer(cols = -1, names_to = "location", values_to = "per") %>%
  mutate(attitude = "good", target = "citizen")

df_citizen_bad_long <- df_citizen_bad %>% select(1,2,matches("Mainland|Taiwan|Macau|Hong Kong")) %>%
  select(-1) %>%
  rename(date = 1, hk = 2, china = 3, taiwan = 4, macau = 5) %>%
  pivot_longer(cols = -1, names_to = "location", values_to = "per") %>%
  mutate(attitude = "bad", target = "citizen")

df_government_good_long <- df_government_good %>% select(1,2,matches("Mainland|Taiwan|Macau|Hong Kong")) %>%
  select(-1) %>%
  rename(date = 1, hk = 2, china = 3, taiwan = 4, macau = 5) %>%
  pivot_longer(cols = -1, names_to = "location", values_to = "per") %>%
  mutate(attitude = "good", target = "government")

df_government_bad_long <- df_government_bad %>% select(1,2,matches("Mainland|Taiwan|Macau|Hong Kong")) %>%
  select(-1) %>%
  rename(date = 1, hk = 2, china = 3, taiwan = 4, macau = 5) %>%
  pivot_longer(cols = -1, names_to = "location", values_to = "per") %>%
  mutate(attitude = "bad", target = "government")

df_attidute <- 
  df_citizen_bad_long %>% bind_rows(df_citizen_good_long) %>% bind_rows(df_government_bad_long) %>% bind_rows(df_government_good_long) %>%
  mutate(per = as.double(str_remove(per, "%"))/100)

df_attidute_diff <- df_attidute %>%
  pivot_wider(names_from = attitude, values_from = per) %>%
  mutate(diff = good - bad) %>%
  select(-bad,-good) %>%
  mutate(location2 = case_when(location == "hk" ~ "香港",
                               location == "china" ~ "中國大陸",
                               location == "taiwan" ~ "台灣",
                               location == "macau" ~ "澳門",
                               TRUE ~ location)) %>%
  mutate(location = as_factor(location)) %>%
  mutate(location = fct_relevel(location, "hk","china","taiwan","macau")) %>%
  mutate(location2 = as_factor(location2)) %>%
  mutate(location = fct_relevel(location2, "香港","中國大陸","台灣","澳門"))

df_attidute_citizen <- df_attidute_diff %>% filter(target == "citizen")
df_attidute_government <- df_attidute_diff %>% filter(target == "government")

df_attidute_citizen %>% jsonlite::write_json("/Users/macuser/Documents/GitHub/G2/test/data/citizen.json")
df_attidute_government %>% jsonlite::write_json("/Users/macuser/Documents/GitHub/G2/test/data/government.json")
