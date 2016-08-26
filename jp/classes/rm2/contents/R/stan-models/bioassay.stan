// bioassay.stan
//
// An example in BDA3, Ch. 3
//
// 2015-06-07 Yuki Yanai

data {
    int<lower=0> J;
    int<lower=0> y[J];
    int<lower=1> n[J];
    real x[J];
}
parameters {
    real alpha;
    real beta;
}
transformed parameters {
    real<lower=0, upper=1> theta[J];
    for (j in 1:J) {
        theta[j] <- 1 / (1 + exp(-alpha - beta * x[j]));
    }
}
model {
    y ~ binomial(n, theta);
}