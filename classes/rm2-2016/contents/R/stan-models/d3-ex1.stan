// d3-ex1.stan
// 2016-11-18 Yuki Yanai
data {
    int N;
    real<lower=0, upper=1> Y[N];
    int<lower=0, upper=1> A[N];
    real<lower=0, upper=1> Score[N];
}

parameters {
    real alpha;
    real beta;
    real gamma;
    real<lower=0> sigma;
}

transformed parameters {
    real mu[N];
    for (n in 1:N)
        mu[n] = alpha + beta*A[n] + gamma*Score[n];
}

model {
    for (n in 1:N) 
        Y[n] ~ normal(mu[n], sigma);
    
    alpha ~ normal(0, 10);
    beta ~ normal(0, 10);
    gamma ~ normal(0, 10);
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
