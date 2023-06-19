library(jsonlite)
library(tidyverse)

df_citizen <- fromJSON("data/citizen.json") %>% as_tibble()
df_citizen
