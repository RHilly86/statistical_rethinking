data {
   int<lower=1> N;
   vector[N] median_age_marriage;
   vector[N] divorce_rate;
}

parameters {
   real a;
   real bA;
   real<lower=0> sigma;
}

transformed parameters {
    vector[N] mu;
    mu = a + bA * median_age_marriage;
}

model {
    divorce_rate ~ normal(mu, sigma);
    a ~ normal(0, 0.2);
    bA ~ normal(0, 0.5);
    sigma ~ exponential(1);
}

generated quantities {
    real a_prior = normal_rng(0, 0.2);
    real bA_prior = normal_rng(0, 0.5);
    vector[N] mu_prior;
    mu_prior = a_prior + bA_prior * median_age_marriage;
}
