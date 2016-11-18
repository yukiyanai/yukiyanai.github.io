// d3-ex3.stan
// 2016-11-18 Yuki Yanai
data {
    int<lower=0> I;
    int<lower=0, upper=1> Y[I];
    int<lower=0, upper=1> A[I];
    real<lower=0, upper=1> S[I];
    real<lower=0, upper=1> W[I];
}

parameters {
    real b[4];
}

transformed parameters {
    real<lower=0, upper=1> theta[I];
    for (i in 1:I)
        theta[i] = inv_logit(b[1] + b[2]*A[i] + b[3]*S[i] + b[4]*W[i]);
}

model {
    for (i in 1:I) 
        Y[i] ~ bernoulli(theta[i]);
    b ~ normal(0, 10);
}

generated quantities {
    real log_lik[I];
    for (i in 1:I)
        log_lik[i] = bernoulli_lpmf(Y[i] | theta[i]);
}
