%=======================================================================
% 2014-11-22: Guangsha Shi
% This is a function called by CWMR_ASAS_main to select the stock
% that has the largest weight from portfolio.
%=======================================================================

function [w,ii] = select(b, ns)

n = size(b, 1);  
w = zeros(n,1);

[bp, idx] = sort(b, 'descend');

for i = 1 : ns
    w(idx(i)) = bp(i);
end

sumw = norm(w, 1);

for i = 1 : n
    if ( w(i) > 0 )
        ii = i;
    end
    w(i) = w(i) / sumw;
end

end