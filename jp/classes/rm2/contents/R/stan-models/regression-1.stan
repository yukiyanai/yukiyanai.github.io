// regression-1.stan
//
// Basic linear regressio using Stan
//
// 2015-07-22 Yuki Yanai
data {
    int<lower=0> N;
    vector[N] y;
    vector[N] x2;
    vector[N] x3;
    vector[N] x4;
}
parameters {
    vector[4] beta;
    real<lower=0> sigma;
}
model {
    y ~ normal(beta[1] + beta[2] * x2 + beta[3] * x3 + beta[4] * x4, sigma);
}
