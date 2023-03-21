data {
    int<lower=1> N;
    vector[N] median_age_at_marriage;
    vector[N] marriage_rate; 
}

parameters {
    real a;
    real bAM;
    real<lower=0> sigma;
}

transformed parameters {
   vector[N] mu;
   mu = a + bAM * median_age_at_marriage;
}

model {
    marriage_rate ~ normal(mu, sigma);
    a ~ normal(0, 0.2);
    bAM ~ normal(0, 0.5);
    sigma ~ exponential(1);
}