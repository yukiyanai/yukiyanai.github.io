// d4-sim-poisson.stan
// 2016-11-30 Yuki Yanai
data {
    int<lower=0> N;
    matrix[N, 4] X;    // prepare the matrix whose first column is all 1s
    int<lower=0> Y[N]; // cannot use vector because Y must be integers
}

parameters {
    vector[4] b;
}

transformed parameters {
    vector[N] mu;
    mu = multiply(X, b);  // matrix multiplication
}

model {
    Y ~ poisson_log(mu);
    b ~ normal(0, 100);
}

generated quantities {
    int<lower=0> y_pred[N];
    vector[N] log_lik;
    for (n in 1:N) {
        y_pred[n] = poisson_log_rng(mu[n]);
        log_lik[n] = poisson_log_lpmf(Y[n] | mu[n]);
    }
}
