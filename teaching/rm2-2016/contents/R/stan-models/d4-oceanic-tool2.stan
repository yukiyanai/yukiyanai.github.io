// d4-oceanic-tool2.stan
// 2016-12-01 Yuki Yanai
data {
    int<lower=0> N;
    vector[N] P;
    vector[N] C;
    int<lower=0> T[N];
}

parameters {
    real a;
    vector[2] b;
}

transformed parameters {
    vector<lower=0>[N] mu;
    mu = a + b[1]*C + b[2]*P;
}

model {
    T ~ poisson_log(mu);
    a ~ normal(0, 10);
    b ~ normal(0, 1);
}

generated quantities {
    int<lower=0> t_pred[N];
    vector[N] log_lik;
    for (n in 1:N) {
        t_pred[n] = poisson_log_rng(mu[n]);
        log_lik[n] = poisson_log_lpmf(T[n] | mu[n]);
    }
}
