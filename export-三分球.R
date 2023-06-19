library(tidyverse)
### import
df_clean <- read_rds("data/P聯盟冠軍賽/2022-playoff-round-02.rds")

value_color = c("新北國王"="#d9c500","新竹街口攻城獅"="#531078",
                "福爾摩沙台新夢想家"="#80B136","臺北富邦勇士"="#007CB5",
                "高雄鋼鐵人"="#000000","桃園領航猿"="#EE450D",
                "聯盟與贊助商"="black")

df_three <- df_clean %>%
  filter(!is.na(per_three)) %>%
  filter(try_three > 1) %>%
  mutate(try_avg_three = try_three/n_game, shot_avg_three = shot_three/n_game) %>%
  filter(try_avg_three >= 1) %>%
  select(name, team, n_game, matches("three")) %>% arrange(desc(per_three))
value_three_avg <- df_clean %>% summarise(shot_three = sum(shot_three, na.rm = T), try_three = sum(try_three, na.rm = T)) %>%
  mutate(per_three = shot_three/try_three) %>% pull(per_three)
value_three_avg2 <- round(value_three_avg,2) %>% scales::percent()

df_three %>% jsonlite::write_json("/Users/macuser/Documents/GitHub/G2/test/data/three.json")