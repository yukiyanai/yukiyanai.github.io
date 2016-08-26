// residential-vehicle.stan
//
// BDA3, Ex 5-14 (p.137)
//
// 2015-06-14 Yuki Yanai
data{
    int<lower=1> J;
    int<lower=1> n[J];
}
parameters {
    real<lower=0> theta[J];
    real<lower=0> alpha;
    real<lower=0> beta;    
}
model {
    alpha ~ gamma(0.01, 0.01);
    beta ~ gamma(0.01, 0.01);
    theta ~ gamma(alpha, beta);
    n ~ poisson(theta);
}