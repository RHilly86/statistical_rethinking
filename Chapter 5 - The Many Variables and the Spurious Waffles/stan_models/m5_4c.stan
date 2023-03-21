data {
    int<lower=1> N;
    vector[N] marriage_rate;
    vector[N] divorce_rate;
}

parameters {
    real a;
    real bM;
    real<lower=0> sigma;
}

transformed parameters {
   vector[N] mu;
   mu = a + bM * marriage_rate;
}

model {
    divorce_rate ~ normal(mu, sigma);
    a ~ normal(0, 0.2);
    bM ~ normal(0, 0.5);
    sigma ~ exponential(1);
}