// d4-sim-poisson0.stan
// 2016-11-30 Yuki Yanai
data {
    int<lower=0> N;
    real X2[N];
    real X3[N];
    real X4[N];
    int<lower=0> Y[N];
}

parameters {
    vector[4] b;
}

transformed parameters {
    real mu[N];
    for (n in 1:N)
        mu[n] = exp(b[1] + b[2]*X2[n] + b[3]*X3[n] + b[4]*X4[n]);
}

model {
    for (n in 1:N)
        Y[n] ~ poisson(mu[n]);
    b ~ normal(0, 100);
}

generated quantities {
    int<lower=0> y_pred[N];
    real log_lik[N];
    for (n in 1:N) {
        y_pred[n] = poisson_rng(mu[n]);
        log_lik[n] = poisson_lpmf(Y[n] | mu[n]);
    }
}
