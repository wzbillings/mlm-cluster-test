###
# Fitting a test Bayesian model on the cluster
# Zane
# 2025-03-27
###

library(lme4)
library(brms)

options(brms.backend = "cmdstanr")
out_dir <- here::here("output")
dir.create(out_dir, showWarnings = FALSE)

complete_pooling <- brms::brm(
  Reaction ~ 1 + Days,
  data = sleepstudy,
  prior = c(
    brms::prior(normal(0, 1), class = "Intercept"),
    brms::prior(normal(0, 1), class = "b"),
    brms::prior(normal(0, 1), class = "sigma")
  ),
  warmup = 2500,
  iter = 12500,
  chains = 4,
  cores = 4
)

# These days I would actually probably write the "no pooling" model as
# Reaction ~ 0 + Subject + Days * Subject
# but I think those are pretty much the same
no_pooling <- brms::brm(
  Reaction ~ 0 + (1 || Subject) + (0 + Days || Subject),
  data = sleepstudy,
  prior = c(
    #brms::prior(normal(0, 1), class = "Intercept"),
    #brms::prior(normal(0, 1), class = "b"),
    brms::prior(normal(0, 1), class = "sigma"),
    brms::prior(normal(0, 1), class = "sd")
  ),
  warmup = 2500,
  iter = 12500,
  chains = 4,
  cores = 4
)

partial_pooling <- brms::brm(
  Reaction ~ 1 + Days + (1 + Days | Subject),
  data = sleepstudy,
  prior = c(
    brms::prior(normal(0, 1), class = "Intercept"),
    brms::prior(normal(0, 1), class = "b"),
    brms::prior(normal(0, 1), class = "sigma"),
    brms::prior(normal(0, 1), class = "sd")
  ),
  warmup = 2500,
  iter = 12500,
  chains = 4,
  cores = 4
)

readr::write_rds(
  complete_pooling,
  here::here(out_dir, "mod-complete-pooling.Rds")
)

readr::write_rds(
  no_pooling,
  here::here(out_dir, "mod-no-pooling.Rds")
)

readr::write_rds(
  partial_pooling,
  here::here(out_dir, "mod-partial-pooling.Rds")
)
