// d3-ex1b.stan
// vectorize d3-ex1.stan
// 2016-11-18 Yuki Yanai
data {
    int N;
    vector<lower=0, upper=1>[N] Y;
    vector<lower=0, upper=1>[N] A;
    vector<lower=0, upper=1>[N] Score;
}

parameters {
    vector[3] b;
    real<lower=0> sigma;
}

transformed parameters {
    vector[N] mu;
    mu = b[1] + b[2]*A + b[3]*Score;
}

model {
    Y ~ normal(mu, sigma);
    b ~ normal(0, 10);
    sigma ~ cauchy(0, 20);
}

generated quantities {
    real y_pred[N];
    real error[N];
    real log_lik[N];
    for (n in 1:N) {
        y_pred[n] = normal_rng(mu[n], sigma);
        error[n] = Y[n] - mu[n];
        log_lik[n] = normal_lpdf(Y[n] | mu[n], sigma);
    }
}
