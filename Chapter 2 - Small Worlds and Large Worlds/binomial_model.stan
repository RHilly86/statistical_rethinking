data {
    int<lower=1> N;
    int<lower=0> y;
}

parameters {
    real <lower=0, upper=1> p;
}

model {
    y ~ binomial(N, p);
    p ~ uniform(0, 1);
}
