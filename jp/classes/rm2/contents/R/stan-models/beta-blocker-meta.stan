// beta-blocker.stan
//
// An example in BDA3, Section 5.6
//
// 2015-06-09 Yuki Yanai
data {
  int<lower=1> J; 
  real y[J];
  real<lower=0> sigma[J];
}
parameters {
  real theta[J];
  real mu;
  real<lower=0> tau;
}
model {
  theta ~ normal(mu, tau);
  y ~ normal(theta, sigma);
}