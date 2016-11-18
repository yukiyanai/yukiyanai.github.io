// d3-ex2.stan
// 2016-11-18 Yuki Yanai
data {
    int<lower=0> N;
    int<lower=0> M[N];
    int<lower=0> Y[N];
    int<lower=0, upper=1> A[N];
    real<lower=0, upper=1> S[N];
}

parameters {
    real b[3];
}

transformed parameters {
    real<lower=0, upper=1> theta[N];
    for (n in 1:N)
        theta[n] = inv_logit(b[1] + b[2]*A[n] + b[3]*S[n]);
}

model {
    for (n in 1:N)
        Y[n] ~ binomial(M[n], theta[n]);
    b ~ normal(0, 10);
}

generated quantities {
    int y_pred[N];
    real log_lik[N];
    for (n in 1:N) {
        y_pred[n] = binomial_rng(M[n], theta[n]);
        log_lik[n] = binomial_lpmf(Y[n] | M[n], theta[n]);
    }
}
