%=======================================================================
% 2014-11-22: Han Lin & Dongyao Chen
% A function called by Anticor_main for the update of bt.
%=======================================================================

function bt1=anticor(w,t,X,m,bt0)
% w: window size
% t: index of last trading day
% X: Historical market sequence
% bt0: current portfolio
% bt1: portfolio for next trading day

if t<2*w
    bt1=bt0;
else
    % LX1 and LX2 are the market sequence of past two window
    LX1=log(X(t-2*w+1:t-w,:));
    LX2=log(X(t-w+1:t,:));
    % mean of LX1 and LX2
    mu1=mean(LX1);
    mu2=mean(LX2);
    % standard deviation of LX1 and LX2
    sigma1=std(LX1);
    sigma2=std(LX2);
    
    % compute covariance and correlation matrix for LX1 and LX2
    Mcov=(LX1-repmat(mu1,w,1))'*(LX2-repmat(mu2,w,1))/(w-1);
    Mcor=zeros(size(Mcov));
    for i=1:m
        for j=1:m
            if sigma1(i)*sigma2(j)~=0
                Mcor(i,j)=Mcov(i,j)/(sigma1(i)*sigma2(j));
            end
        end
    end
    
    % if statment to compute claim matrix
    claim=zeros(m,m);
    for i=1:m
        for j=1:m
            claim(i,j)=(mu2(i)>=mu2(j))*(claim(i,j)+(Mcor(i,j)>0)*Mcor(i,j)-(Mcor(i,i)<0)*Mcor(i,i)-(Mcor(j,j)<0)*Mcor(j,j));
        end
    end
    
    % compute transfer matrix and then get result of portfolio for next
    % trading day
    bt1=bt0;
    trans=zeros(m,m);
    for i=1:m
        for j=1:m
            trans(i,j)=bt0(i)*claim(i,j)/sum(claim(i,:));
        end
    end
    for i=1:m
        for j=1:m
            bt1(i)=bt1(i)-(trans(i,j)-trans(j,i))*(i~=j);
        end
    end
end


end