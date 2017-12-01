function y = arith_encode_n(x, p, n, alphabet)
log_n = log(n)/log(2);

precision = floor(48/log_n);
one = n^precision - 1;
divider = ceil(one/n);
divider2 = ceil(one/n^2);
%divider = n*divider2;

if (nargin < 4)
    alphabet = (1:length(p))-1;
else
    if (length(alphabet) ~= length(p))
        error('Alphabet size does not match probability distribution');
    end
end
if (~isempty(find(p<0)) || abs(sum(p)-1) > 1e-5)
    error('Illegal probability distribution');
end

% calculate the cumulative probability distribution
f = cumsum(p(:));
f = [0 ; f((2:end)-1)];

% initialise output string, interval end-points and straddle counter
y = [];
lo = 0;
hi = one;
bottom = [0];


% MAIN ENCODING ROUTINE
for k = 1:length(x) % for every input symbol
    % Calculate range
    % + 1 to avoid rounding issues
    range = hi - lo + 1;
    
    % Find index of the next input symbols in
    % the cumulative probability distribution f
    ind = find(alphabet == x(k)); 

    % Narrow the interval end-points [lo,hi) to the new range [f,f+p]
    % within the old interval [lo,hi]
    % Round inwards for to avoid overlaps
    lo = lo + ceil(f(ind)*range); 
    hi = lo + floor(p(ind)*range);  
    
    % check that the interval has not narrowed to 0
    if (hi == lo)
        error('Interval has become zero: check that you have no zero probs and increase precision');
    end
    
    % Now we need to re-scale the interval if its end-points have bits in
    % common, and output the corresponding bits where appropriate
    
    while (1) % we will break loop when interval reaches its final state
        
        if hi - lo > divider
            break; % can't zoom any further without interval leaving bound
            
        elseif floor(lo/divider) == floor(hi/divider) % lo and high sit between the same endpoints
            a = floor(lo/divider);

            y = [y add_to_nary(bottom, a, n)]; % resolve straddling
            bottom = [0]; % reset bottom tracker
            hi = hi - a * divider; % take off the nearest below quater step to rescale
            lo = lo - a * divider;
            
        elseif ceil(lo/divider2) == floor(hi/divider2)
            bottom = [bottom 0];
            
            a2 = floor(lo/divider2);
            
            bottom = add_to_nary(bottom, a2, n);  
            
            hi = hi - a2 * divider2; % take off the nearest below sixteenth step to rescale
            lo = lo - a2 * divider2;
            
        else
            break;
        end   
        
        lo = lo * n;
        hi = (hi * n) + 1;
        
    end
end


if lo == 0
    a = 0;
elseif floor(lo/divider) + 1 == floor((hi)/divider)
    bottom = [bottom 0];
    a = ceil(lo/divider2);
else
    a = ceil(lo/divider);
end

%bottom = [bottom 0];

bottom  = add_to_nary(bottom, a, n);

y = [y bottom];
        