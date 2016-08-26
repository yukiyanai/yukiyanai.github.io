// rat-tumor-2.stan
//
// An example in BDA3, Ch.5
// 2015-06-08 Yuki Yanai

data {
    int<lower=1> J;
    int<lower=0> y[J];
    int<lower=1> n[J];
}
parameters {
    real<lower=0, upper=1> theta[J];
    real phi1;
    real phi2;    
}
transformed parameters {
    real<lower=0> alpha;
    real<lower=0> beta;
    alpha <- exp(phi1 + phi2) / (1 + exp(phi1));
    beta <- exp(phi2) / (1 + exp(phi1));
}
model {
    theta ~ beta(alpha, beta);
    y ~ binomial(n, theta);
}