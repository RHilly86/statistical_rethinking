data {
    int<lower=1> N;
    vector[N] marriage_rate;
    vector[N] median_age_at_marriage;
    vector[N] divorce_rate;
}

parameters {
    real a;
    real bM;
    real bA;
    real<lower=0> sigma;
}

transformed parameters {
   vector[N] mu;
   mu = a + bM * marriage_rate + bA * median_age_at_marriage;
}

model {
    divorce_rate ~ normal(mu, sigma);
    a ~ normal(0, 0.2);
    bM ~ normal(0, 0.5);
    bA ~ normal(0, 0.5);
    sigma ~ exponential(1);
}

