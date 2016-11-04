// d2-model4.stan
// 2016-11-04 Yuki Yanai
data {
    int<lower=0> N;
    int<lower=0, upper=1> V[N];
    int<lower=0> P[N];
    real X[N];
    int<lower=25> A[N];
    int<lower=1, upper=4> PARTY[N];
}

parameters {
    real alpha[4];
    real beta[3];
}

transformed parameters {
    real<lower=0, upper=1> theta[N];
    for (n in 1:N) {
        theta[n] = inv_logit(alpha[PARTY[n]] + beta[1]*P[n] + beta[2]*X[n] + beta[3]*A[n]);
    }
}

model {
    for (n in 1:N) {
        V[n] ~ bernoulli(theta[n]);
    }
    for (p in 1:4) {
        alpha[p] ~ normal(0, 100);
    }
    for (k in 1:3) {
        beta[k] ~ normal(0, 10);
    }
}

generated quantities {
    int<lower=0, upper=1> v_pred[N];
    real log_lik[N];
    for (n in 1:N) {
        v_pred[n] = bernoulli_rng(theta[n]);
        log_lik[n] = bernoulli_lpmf(V[n] | theta[n]);
    }
}
