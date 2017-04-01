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
    vector[3] b;
}

transformed parameters {
    vector<lower=0, upper=1>[N] theta;
    for (n in 1:N)
        theta[n] = inv_logit(b[1] + b[2]*A[n] + b[3]*S[n]);
}

model {
    Y ~ binomial(M, theta);
    b ~ normal(0, 10);
}

generated quantities {
    int<lower=0> y_pred[N];
    vector[N] log_lik;
    for (n in 1:N) {
        y_pred[n] = binomial_rng(M[n], theta[n]);
        log_lik[n] = binomial_lpmf(Y[n] | M[n], theta[n]);
    }
}
