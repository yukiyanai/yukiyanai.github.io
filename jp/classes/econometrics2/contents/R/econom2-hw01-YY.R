## econom2-hw01-YY.R
##
## 計量経済学応用
## 課題1
## 矢内勇生（やない ゆうき）
## 学籍番号：1234567890
## yanai.yuki@kochi-tech.ac.jp
## 2018-05-06

## データセットの作成
set.seed(2018-04-19)
N <- 100
x <- rnorm(N, mean = 20, sd = 3)
y <- -0.7*x + rnorm(N, mean = 0, sd = 2)
myd <- data.frame(x, y)

## 基本的な統計量

### x の平均値、中央値、分散、標準偏差
mean(x)
median(x)
var(x)
sd(x)

### y の平均値、中央値、分散、標準偏差
mean(y)
median(y)
var(y)
sd(y)

## ヒストグラム
hist(myd$x, xlab = "x", ylab = "度数", main = "", col = "gray")
hist(myd$y, xlab = "y", ylab = "度数", main = "", col = "gray")

## ggplotでヒストグラムを作る場合
library("ggplot2")
hist_x <- ggplot(data = myd, aes(x = x)) +
  geom_histogram(color = "black", bins = 10) +
  labs(y = "度数")
print(hist_x)
hist_y <- ggplot(data = myd, aes(x = y)) +
  geom_histogram(color = "black", bins = 10) +
  labs(y = "度数")
print(hist_y)


## 散布図と相関係数
plot(myd$x, myd$y, xlab = "x", ylab = "y")
cor(myd$x, myd$y)

## ggplotで散布図
sct <- ggplot(data = myd, aes(x = x, y = y)) +
  geom_point()
print(sct)
# 散布図と相関係数から、xとyには負の相関があることがわかる。


## 因果関係と相関関係
# 毎日朝食を食べる生徒ほど成績が良いという相関関係は、一見すると朝食をとることが好成績の原因であるかのようにみえる。しかし、親がどれだけ子どもの世話をするかという第三の要因があり、それが朝食をとることと成績の両者に正の影響を及ぼしていると考えられる。したがって、朝食をとることと成績の間に因果関係はないかもしれない。
