library(tidyverse)

df_sister_third <- read_rds("data/df_reply_third.rds")
df_sister_agg <- df_sister_third %>% select(matches("請按照喜愛度排序")) %>%
  mutate(id = row_number()) %>%
  select(id, everything()) %>%
  pivot_longer(cols = -1, names_to = "type", values_to = "value") %>%
  mutate(type = str_extract(type, "\\[.*")) %>%
  mutate(type = str_remove_all(type, "\\[|\\]")) %>%
  count(type, value)

df_sister_agg %>% group_by(type) %>% summarise(top_n = max(n), n = sum(n))
df_sister_agg %>% write_csv("data/df_sister_agg.csv")
