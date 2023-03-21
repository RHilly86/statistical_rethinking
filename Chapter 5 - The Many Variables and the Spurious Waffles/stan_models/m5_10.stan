data {
  int<lower=1> N;
  int <lower=1> id_idx;
  int <lower=1> house_idx; 
  vector[N] kcal_per_g;
  array[N] int<lower=1, upper=id_idx> clade_id;
  array[N] int<lower=1, upper=house_idx> house;
}

parameters {
  vector[id_idx] a;
  vector[house_idx] h;
  real<lower=1> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = a[clade_id] + h[house];
}

model {
  kcal_per_g ~ normal(mu, sigma);
  a ~ normal(0, 0.5);
  h ~ normal(0, 0.5);
  sigma ~ exponential(1);
}
