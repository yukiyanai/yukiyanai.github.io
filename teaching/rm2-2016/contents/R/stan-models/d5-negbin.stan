// d5-negbin.stan
data {
    int N;
    int<lower=0> Y[N];
    int<lower=0> D;    // number of programs 
    int<lower=1, upper=D> P[N];
    vector[N] M;
}

parameters {
    vector[D] alpha;
    real beta;
    real<lower=0> phi;
    real a;
    real<lower=0> s;
}

transformed parameters {
    vector[N] mu;
    for (n in 1:N)
        mu[n] = exp(alpha[P[n]] + beta*M[n]);
}

model {
    Y ~ neg_binomial_2(mu, phi);
    alpha ~ normal(a, s);
    beta ~ normal(0, 10);
    phi ~ cauchy(0, 10);
    a ~ normal(0, 100);
    s ~ cauchy(0, 10);
}

generated quantities {
    int<lower=0> y_pred[N];
    vector[N] log_lik;
    for (n in 1:N) {
        y_pred[n] = neg_binomial_2_rng(mu[n], phi);
        log_lik[n] = neg_binomial_2_lpmf(Y[n] | mu[n], phi);
    }
}
