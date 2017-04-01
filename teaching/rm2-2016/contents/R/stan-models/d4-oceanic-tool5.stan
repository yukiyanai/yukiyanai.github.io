// d4-oceanic-tool5.stan
// 2016-12-01 Yuki Yanai
data {
    int<lower=0> N;
    int<lower=0> T[N];
}

parameters {
    real a;
}

model {
    T ~ poisson_log(a);
    a ~ normal(0, 10);
}

generated quantities {
    int<lower=0> t_pred[N];
    vector[N] log_lik;
    for (n in 1:N) {
        t_pred[n] = poisson_log_rng(a);
        log_lik[n] = poisson_log_lpmf(T[n] | a);
    }
}
