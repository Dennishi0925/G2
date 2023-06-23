library(tidyverse)
library(jsonlite)

df_penguin <- fromJSON("https://assets.antv.antgroup.com/g2/penguins.json") %>% as_tibble()
df_citizen <- fromJSON("data/citizen.json") %>% as_tibble()


