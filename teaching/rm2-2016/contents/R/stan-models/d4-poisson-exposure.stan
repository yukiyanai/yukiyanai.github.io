// d4-poisson-exposure.stan
data {
    int<lower=0> N;
    int<lower=0> Y[N];
    vector<lower=0, upper=1>[N] U;
    vector<lower=0>[N] X; // exposure
}

parameters {
    real a;
    real b;
}

transformed parameters {
    vector[N] mu;
    for (n in 1:N)
        mu[n] = a + b*U[n] + log(X[n]);
}

model {
    Y ~ poisson_log(mu);
}
