// d2-model1.stan
// an example of RStan model
// 2016-11-03 Yuki Yanai
data {
    int<lower=0> N;
    real Y[N];
    real X2[N];
    real X3[N];
    real X4[N];
}

parameters {
    real beta[4];
    real<lower=0> sigma;
}

transformed parameters {
    real mu[N];
    for (n in 1:N) {
        mu[n] = beta[1] + beta[2]*X2[n] + beta[3]*X3[n] + beta[4]*X4[n];
    }
}

model {
    for (n in 1:N) {
        Y[n] ~ normal(mu[n], sigma);
    }
    for (p in 1:4) {
        beta[p] ~ normal(0, 100);
    }
    sigma ~ uniform(0, 100);
}
