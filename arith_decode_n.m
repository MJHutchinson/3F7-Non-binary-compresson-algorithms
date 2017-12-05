function y = arith_decode_n(x, p, n, ny, alphabet)
% Modified from the FTR files provided by Jossy Sayir by Basil Mustafa and
% Michael Hutchinson, 2017

log_n = log(n)/log(2);

precision = floor(48/log_n);
one = n^precision - 1;
divider = ceil(one/n);
divider2 = ceil(one/n^2);

if (nargin < 4)
    error('Syntax: arith_decode(x,p,ny[,alphabet])');
end
if (nargin < 5)
    alphabet = (1:length(p))-1;
else
    if (length(alphabet) ~= length(p))
        error('Alphabet size does not match probability distribution');
    end
end
if (~isempty(find(p<0)) || abs(sum(p)-1) > 1e-5)
    error('Illegal probability distribution');
end

f = cumsum(p(:));
f = [0 ; f((2:end)-1)];
y = zeros(1,ny);

nary2dec = @(x,n) dot(x, n.^((length(x) - 1:-1:0)));

hi = one;
lo = 0;
x = [x(:)' zeros(1,precision+1)]; % make row vector and add dummy zeros
value = nary2dec(x(1:precision), n); % target value for interval
xp = precision + 1; % pointer to next symbol in the input pipeline


for k = 1:ny
    range = hi - lo + 1;
    
    ind = find(lo+ceil(f*range)<=value, 1, 'last' );
    y(k) = alphabet(ind);
    
    lo = lo + ceil(f(ind)*range); 
    hi = lo + floor(p(ind)*range);  

    if (hi == lo)
        error('Interval has become zero: check that you have no zero probs and increase precision');
    end
    
    while (1)
        
        if hi - lo > divider
            break; % can't zoom any further without interval leaving bound
            
        elseif floor(lo/divider) == floor(hi/divider) % lo and high sit between the same endpoints
            a = floor(lo/divider);
            
            % take off the nearest below quater step to rescale
            hi = hi - a * divider; 
            lo = lo - a * divider;
            value = value - a*divider;
            
        elseif ceil(lo/divider) == floor(hi/divider)
            a2 = floor(lo/divider2);
            
            % take off the nearest below sixteenth step to rescale
            hi = hi - a2 * divider2; 
            lo = lo - a2 * divider2;
            value = value - a2*divider2;
        else
            break;
        end   
        
        lo = lo * n;
        hi = (hi * n) + 1;
        value = n*value + x(xp);
        
        xp = xp+1;
        if (xp == length(x))
            error('Unable to decompress');
        end
    end
end

