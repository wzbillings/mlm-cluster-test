###
# Fitting a test Bayesian model on the cluster
# Zane
# 2025-03-27
###

library(lme4)
library(brms)
library(qs2)

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

qs2::qs_save(
  complete_pooling,
  here::here(out_dir, "mod-complete-pooling.qs2")
)

qs2::qs_save(
  no_pooling,
  here::here(out_dir, "mod-no-pooling.qs2")
)

qs2::qs_save(
  partial_pooling,
  here::here(out_dir, "mod-partial-pooling.qs2")
)
