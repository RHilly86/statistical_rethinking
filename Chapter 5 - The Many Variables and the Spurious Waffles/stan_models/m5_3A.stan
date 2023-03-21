 data {
    int<lower=1> N;
    vector[N] median_age_at_marriage;
    vector[N] marriage_rate;
    vector[N] divorce_rate;
 }

 parameters {
    real a;
    real bM;
    real bA;
    real<lower=0> sigma;

    real aM;
    real bAM;
    real<lower=0> sigma_M;
 }

 transformed parameters {
    vector[N] mu;
    vector[N] mu_M;

    mu = a + bM * marriage_rate + bA * median_age_at_marriage;
    mu_M = aM + bAM * median_age_at_marriage;
 }

 model {
    divorce_rate ~ normal(mu, sigma);
    a ~ normal(0, 0.2);
    bM ~ normal(0, 0.5);
    bA ~ normal(0, 0.5);
    sigma ~ exponential(1);

    marriage_rate ~ normal(mu_M, sigma_M);
    aM ~ normal(0, 0.2);
    bAM ~ normal(0, 0.5);
    sigma_M ~ exponential(1);
 }

 generated quantities {
    array[N] real divorce_rep = normal_rng(mu, sigma);
    array[N] real marriage_rep = normal_rng(mu_M, sigma_M);
 }
 


