%%% Correlated Data

clear
clf
S = [1,1.5;1.5,2.5];%sigma correlated x/y
mu = [2,3];
N = 1000;%samples
R = mvnrnd(mu,S,N);
xS = R(:,1);
yS = R(:,2);

hold on
plot(R(:,1),R(:,2), 'b+')

calcxmu = mean(xS);%mean of x values
calcymu = mean(yS);
calcSxx = sqrt(sum((xS - calcxmu).^2)/(N-1)); %std dev
calcSyy = sqrt(sum((yS - calcymu).^2)/(N-1));
calcSxy = sqrt(sum((xS - calcxmu).*(yS - calcymu))/(N-1));

Sigma = [calcSxx calcSxy; calcSxy, calcSyy];
%eigen gives angle tilted
[V,D] = eig(Sigma); %%eigen velctor

quiver(calcxmu, calcymu, V(1,1), V(2,1))

quiver(calcxmu, calcymu, V(1,2), V(2,2))
axis equal

theta = linspace(0,2*pi,1000);
xpl = 2*sqrt(D(1,1))*cos(theta);%%2 std dev
ypl = 2*sqrt(D(2,2))*sin(theta);

plpts = [xpl; ypl];
plpts_r = V*plpts;%rotated plot points

xpl = plpts_r(1,:) + calcxmu;
ypl = plpts_r(2,:) + calcymu;

plot(xpl,ypl,'k')


