// d3-ex3.stan
// 2016-11-18 Yuki Yanai
data {
    int<lower=0> I;
    int<lower=0, upper=1> Y[I];
    vector<lower=0, upper=1>[I] A;
    vector<lower=0, upper=1>[I] S;
    vector<lower=0, upper=1>[I] W;
}

parameters {
    vector[4] b;
}

transformed parameters {
    vector<lower=0, upper=1>[I] theta;
    for (i in 1:I)
        theta[i] = inv_logit(b[1] + b[2]*A[i] + b[3]*S[i] + b[4]*W[i]);
}

model {
    Y ~ bernoulli(theta);
    b ~ normal(0, 10);
}

generated quantities {
    vector[I] log_lik;
    for (i in 1:I)
        log_lik[i] = bernoulli_lpmf(Y[i] | theta[i]);
}
