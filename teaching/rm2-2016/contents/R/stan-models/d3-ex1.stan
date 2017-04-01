// d3-ex1.stan
// 2016-11-18 Yuki Yanai
data {
    int N;
    real<lower=0, upper=1> Y[N];
    int<lower=0, upper=1> A[N];
    real<lower=0, upper=1> Score[N];
}

parameters {
    real b1;
    real b2;
    real b3;
    real<lower=0> sigma;
}

transformed parameters {
    real mu[N];
    for (n in 1:N)
        mu[n] = b1 + b2*A[n] + b3*Score[n];
}

model {
    for (n in 1:N) 
        Y[n] ~ normal(mu[n], sigma);
    
    b1 ~ normal(0, 10);
    b2 ~ normal(0, 10);
    b3 ~ normal(0, 10);
    sigma ~ cauchy(0, 20);
}

generated quantities {
    real y_pred[N];
    real log_lik[N];
    for (n in 1:N) {
        y_pred[n] = normal_rng(mu[n], sigma);
        log_lik[n] = normal_lpdf(Y[n] | mu[n], sigma);
    }
}
