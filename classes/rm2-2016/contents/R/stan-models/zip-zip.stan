//zip-zip.stan
functions {
    real ZIP_lpmf(int Y, real theta, real lambda) {
        if (Y == 0) {
            return log_sum_exp(
                bernoulli_lpmf(0 | theta),
                bernoulli_lpmf(1 | theta) + poisson_lpmf(0 | lambda)
            );
        } else {
            return bernoulli_lpmf(1 | theta) + poisson_lpmf(Y | lambda);
        }
    }
}

data {
    int<lower=0> N;
    vector[N] P;
    vector[N] C;
    vector[N] K;
    int<lower=0> Y[N];
}

parameters {
    vector[2] alpha;
    vector[3] gamma;
}

transformed parameters {
    vector[N] theta;
    vector[N] lambda;
    for (n in 1:N) {
        theta[n] = inv_logit(alpha[1] + alpha[2]*P[n]);
        lambda[n] = exp(gamma[1] + gamma[2]*C[n] + gamma[3]*K[n]);
    }
}

model {
    for (n in 1:N)
        Y[n] ~ ZIP(theta[n], lambda[n]);
    alpha ~ normal(0, 10);
    gamma ~ normal(0, 10);
}

generated quantities {
    int<lower=0> y_pred[N];
    vector[N] log_lik;
    for (n in 1:N) {
        y_pred[n] = bernoulli_rng(theta[n]) * poisson_rng(lambda[n]);
        log_lik[n] = ZIP_lpmf(Y[n] | theta[n], lambda[n]);
    }
}
