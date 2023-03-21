data {
  int<lower=1> N;
  int<lower=1> S;
  vector[N] height;
  array[N] int<lower=1, upper=S> sex;
}

parameters {
  vector[S] a;
  real<lower=1> sigma;
}

transformed parameters {
  vector[N] mu;
  mu = a[sex];
}

model {
  height ~ normal(mu, sigma);
  a ~ normal(178, 20);
  sigma ~ cauchy(0, 2);
}
