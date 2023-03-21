data {
  int<lower=1> N;
  vector[N] kcal_per_g;
  vector[N] body_mass;
}

parameters {
  real a;
  real bM;
  real<lower=1> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = a + bM * body_mass;
}

model {
  kcal_per_g ~ normal(mu, sigma);
  
  a ~ normal(0, 0.2);
  bM ~ normal(0, 0.5);
  sigma ~ exponential(1);
}

