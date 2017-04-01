// d4-oceanic-tool.stan
// 2016-12-01 Yuki Yanai
data {
    int<lower=0> N;
    vector[N] P;
    vector[N] C;
    int<lower=0> T[N];
}

parameters {
    real a;
    vector[3] b;
}

transformed parameters {
    vector[N] gamma;
    vector<lower=0>[N] mu;
    gamma = b[2] + b[3]*C;
    mu = a + b[1]*C + gamma .* P;
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
