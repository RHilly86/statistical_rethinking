data {
  int<lower=1> N;
  vector[N] kcal_per_g;
  vector[N] neocortex_pct;
}

parameters {
  real a;
  real bN;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = a + bN * neocortex_pct;
}

model {
  kcal_per_g ~ normal(mu, sigma);
  
  a ~ normal(0, 0.2);
  bN ~ normal(0, 0.5);
  sigma ~ exponential(1);
}

generated quantities {
  real a_prior = normal_rng(0, 0.2);
  real bN_prior = normal_rng(0, 0.5);
  vector[N] mu_prior;
  mu_prior = a_prior + bN_prior * neocortex_pct;
}