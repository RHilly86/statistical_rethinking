data {
  int<lower=1> N;
  int<lower=1> ID;
  vector[N] kcal_per_g;
  array[N] int<lower=1, upper=ID> clade_id;
}

parameters {
  vector[ID] a;
  real<lower=1> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = a[clade_id];
}

model {
  kcal_per_g ~ normal(mu, sigma);
  a ~ normal(0, 0.5);
  sigma ~ exponential(1);
}

