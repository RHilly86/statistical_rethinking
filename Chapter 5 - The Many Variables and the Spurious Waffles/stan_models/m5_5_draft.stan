data {
  int<lower=1> N;
  vector[N] neo_cortex_perc;
  vector[N] kcal_per_g;
}

parameters {
  real a;
  real bN;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = a + bN * neo_cortex_perc;
}

model {
  kcal_per_g ~ normal(mu, sigma);
  
  a ~ normal(0, 1);
  bN ~ normal(0, 1);
  sigma ~ exponential(1);
}

generated quantities {
  real a_prior = normal_rng(0, 1);
  real bN_prior = normal_rng(0, 1);
  vector[N] mu_prior;
  mu_prior = a_prior + bN_prior * neo_cortex_perc;
}
