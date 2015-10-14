%=======================================================================
% 2014-11-22: Han Lin & Dongyao Chen
% ret_T is the cumulative wealth and to see the result
% plot(log10(ret_T))
%=======================================================================

clear all
clc

load nyse_o.mat

X=data;

[n,m]=size(X);

% initialize portfolio
B=zeros(n+1,m);
B(1,:)=ones(1,m)/m;

% initialize window w
w=25;

% initialize return for every day
ret=zeros(1,n);

% calculate portfolio day by day
for i=1:n
    B(i+1,:)=anticor(w,i,X,m,B(i,:));
    ret(i)=B(i,:)*X(i,:)';
    B(i,:)=B(i+1,:);
end

% calculate total return for each day by multiplying the return before that
% day together
ret_T=ones(size(ret));
for i=1:n
    for j=1:i
        ret_T(i)=ret_T(i)*ret(j);
    end
end

