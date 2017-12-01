function y = Hn(p, base)
% H(p) returns the uncertainty (or entropy) in bits of a random variable 
%  described by the probability vector p.
%  If p is a matrix, then H(p) returns a row vector where the k-th element
%  is the entropy of the k-th column of p.
%
% Copyright Jossy 1992

if (length(p) == 1)
   y = He([p 1-p])/log(base);
else
   y = He(p)/log(base);
end

return;


function y = He(p)
% H(p) returns the uncertainty (or entropy) in nats (base e!!!) of a random
% variable described by the probability vector p.
%  If p is a matrix, then H(p) returns a row vector where the k-th element
%  is the entropy of the k-th column of p.

ii = find(p <= 0.0 | p > 1.0);
p(ii) = 1.0;

y = -sum(p.*log(p));

return;




   