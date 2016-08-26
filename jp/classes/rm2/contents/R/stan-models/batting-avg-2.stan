// batting-avg-2.stan
// Problem 2 of hw10
// 2015-06-24 Yuki Yanai
data {
    int<lower=1> J;
    int<lower=0> r[J];
    int<lower=1> n[J];
}
parameters {
    real<lower=0, upper=1> theta[J];
    real<lower=0> alpha;
    real<lower=0> beta;
}
model {
    alpha ~ exponential(2);     // hyperprior
    beta ~ exponential(2);      // hyperprior
    theta ~ beta(alpha, beta);  // prior
    r ~ binomial(n, theta);     // likelihood
}
