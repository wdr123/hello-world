function [a ,b, R] = least_squares_with_bias(x,y)

ybar  = mean(y);
xbar  = mean(x);
xybar = mean(x.*y);
x2bar = mean(x.^2);
b = (ybar-xbar*xybar/x2bar)/(1-xbar^2/x2bar);
a = (1/xbar)*(ybar-b);


R = norm(a*x+b-y)^2;