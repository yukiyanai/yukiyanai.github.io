// batting-avg-1.stan
// Problem 1 of hw10
// 2015-06-24 Yuki Yanai
data {
    int<lower=1> J;
    real<lower=0, upper=1> y[J];
    real<lower=0> sigma;
}
parameters {
    real<lower=0, upper=1> theta[J];
    real<lower=0, upper=1> mu0;
    real<lower=0> sigma0_sq;
}
model {
    mu0 ~ normal(0.225, sqrt(0.0098));    // hyperprior
    sigma0_sq ~ inv_gamma(7, 0.0175);     // hyperprior
    theta ~ normal(mu0, sqrt(sigma0_sq)); // prior
    y ~ normal(theta, sigma);             // likelihood
}
