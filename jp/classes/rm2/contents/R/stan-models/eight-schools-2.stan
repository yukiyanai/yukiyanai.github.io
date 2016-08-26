// eight-schools2.stan
//
// An example in BDA3, Section 5.5

data {
    int<lower=1> J;            // num of schools
    real y[J];                 // estimated treatment effects
    real<lower=0> sigma[J];    // se of effect estimates
}
parameters {
    real mu;                   // population mean
    real<lower=0> tau;         // population sd
    real eta[J];               // school-level errors
}
transformed parameters {
    real theta[J];             // school effects
    for (j in 1:J) {
        theta[j] <- mu + tau * eta[j];
    }
}
model {
    eta ~ normal(0, 1);
    y ~ normal(theta, sigma);
}