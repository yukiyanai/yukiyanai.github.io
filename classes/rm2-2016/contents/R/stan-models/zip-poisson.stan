// zip-poisson.stan
data {
    int<lower=0> N;
    vector[N] C;
    vector[N] P;
    vector[N] K;
    int<lower=0> Y[N];
}

parameters {
    vector[4] beta;
}

transformed parameters {
    vector[N] mu;
    mu = beta[1] + beta[2]*C + beta[3]*P + beta[4]*K;
}

model {
    Y ~ poisson_log(mu);
}

generated quantities {
    vector[N] lambda;
    int<lower=0> y_pred[N];
    vector[N] log_lik;
    for (n in 1:N) {
        y_pred[n] = poisson_log_rng(mu[n]);
        lambda[n] = exp(mu[n]);
        log_lik[n] = poisson_log_lpmf(Y[n] | mu[n]);
    }
}
