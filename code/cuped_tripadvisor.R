library(tidyverse)

# Simulate some data
n_experiments <- 3
n_users_per_exp <- 10000
set.seed(171104)

n_experiments <- 1
d <- cross_df(list(exp_id = seq(n_experiments),
                   user_id = seq(n_users_per_exp))) %>%
  mutate(group = sample(c("base", "variant"), n(), replace = TRUE),
         covariate = rnorm(n()),
         metric = covariate + rnorm(n(), sd = 0.3) + as.numeric(group == "variant"))
%         covariate = if_else(runif(n()) > 0.2, covariate, NA_real_))

print(d, n = 5)
#> # A tibble: 30,000 x 5
#>   exp_id user_id   group  covariate      metric
#>    <int>   <int>   <chr>      <dbl>       <dbl>
#> 1      1       1 variant -0.9815665 -0.07581224
#> 2      2       1 variant         NA -0.13754373
#> 3      3       1 variant -1.6105574 -0.79136708
#> 4      1       2 variant -1.2811401 -0.72244066
#> 5      2       2 variant  0.1324251  1.37553241
#> # ... with 3e+04 more rows

# Connect to Spark
# sc <- spark_connect(master = "local")
#> * Using Spark: 2.1.0

# Copy data to spark (and keep connection to it)
d_tbl <- copy_to(sc, d)

# Do CUPED adjustment per experiment in Spark
cuped_results <- d %>%
  group_by(exp_id) %>%
  mutate(cuped_metric = metric - (covariate - mean(covariate)) * cov(metric, covariate)/var(covariate)) %>%
  mutate(cuped_metric_coal = coalesce(cuped_metric, metric))

res = group_by(cuped_results, exp_id, group) %>% summarise(av = mean(metric), av_cuped = mean(cuped_metric)) %>%
  ungroup()

res %>% pivot_wider(id_cols = c('exp_id'), values_from = c('av', 'av_cuped'), names_from = group) %>%
  mutate(delta = av_base - av_variant, delta_cuped = av_cuped_base - av_cuped_variant)
?pivot_wider




a = mutate(group = sample(c("base", "variant"), n(), replace = TRUE),
       covariate = rnorm(n()),
       metric = covariate + rnorm(n(), sd = 0.3) + as.numeric(group == "variant"))



mod = lm(data=d, metric ~ covariate)

d2 = mutate(d, resid = resid(mod))
d2

mod2 = lm(data=d2, resid ~ group)
summary(mod2)
confint(mod2)


mod1 = lm(data=d2, metric ~ group)
summary(mod1)
confint(mod1)


mod3 = lm(data=d2, metric ~ group + covariate)
summary(mod3)
confint(mod3)
