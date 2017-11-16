function y = arith_encode_base_n(x, p, alphabet)
% arith_encode(x,p) implements the binary arithmetic encoder for the source
% sequence x using the memoryless probability model p.
%
% Copyright Jossy 1994, inspired by Witten, Neal & Cleary 1987

% anonymous function to convert bin to uint64
%bin2uint64 = @(b) uint64(bin2dec(b(:,1:32)))*(2^32) + uint64(bin2dec(b(:,33:64))); 
% define the integer versions of 1.0, 0.5, 0.25 and 0.75
%precision = 32*8;

one = bitcmp(uint64(0)); % this is max_integer
int_size = ceil(one / 256);

% create mask for first 8bits
mask = @(x) bitand(bitcmp(bitshift(bitcmp(uint64(0)),-8)),x);
% returns integer value corresponding to first 8 bits of uint64
interval = @(x) uint8((bitshift(mask(x), -56)));

% check input symbols
if (nargin < 3)
    alphabet = (1:length(p))-1;
else
    if (length(alphabet) ~= length(p))
        error('Alphabet size does not match probability distribution');
    end
end
if (~isempty(find(p<0, 1)) || abs(sum(p)-1) > 1e-5)
    error('Illegal probability distribution');
end

% calculate the cumulative probability distribution
f = cumsum(p(:));
f = [0 ; f((2:end)-1)];


% initialise output string, interval end-points and straddle counter
y = [];
lo = uint64(0);
hi = one;
straddle = ([]);


% MAIN ENCODING ROUTINE
% Loop over input
for k = 1:length(x)
    % Calculate interval range
    range = hi - lo + uint64(1);
    
    % Find index of input symbol
    ind = find(alphabet == x(k)); 

    % Narrow interval range (inwards)
    % N.B. multiplying uint64 by decimal automatically rounds down
    lo = lo + uint64(range * f(ind)) + uint64(1); 
    hi = lo + range * p(ind);
    
    straddle = [];
    % check that the interval has not narrowed to 0
    if (hi == lo)
        error('Interval has become zero: check that you have no zero probs and increase precision');
    end
    
    % Now we need to re-scale the interval if its end-points have bits in
    % common, and output the corresponding bits where appropriate
    while (1) % we will break loop when interval reaches its final state
       % disp(['Interval gap = ' num2str(interval(hi) - interval(lo))])
        if mask(hi) == mask(lo)
            % if first 8 bits the same then the current interval lies perfectly
            % between a n-ic interval
            if isempty(straddle)
                y = [y, interval(lo)];
            else
                strad_comp = [straddle(2:length(straddle)), interval(lo)];
                strad_comp = uint8((strad_comp > (255 - straddle)));
                straddle = straddle + strad_comp;
                y = [y, straddle, interval(lo)];
                straddle = [];
            end
            hi = hi - mask(hi);
            lo = lo - mask(lo);
        elseif interval(hi) - interval(lo) > 2
            % need to include more symbols
            % to narrow down probability range enough to assign a value
            break;
        else
            %the probability interval straddles either side of
            %interval(lo) + 1 (= interval(hi))
            if (hi - lo) > int_size
                %it straddles, but cannot narrow down this range without
                %including another symbol
                break;
            else
                lo_shift = interval(bitshift(lo,8));
                straddle = [straddle, lo_shift];

                lo = lo - uint64(lo_shift)*int_size;
                hi = hi - uint64(lo_shift)*int_size;
            end
        end    
        
        %Rescale interval
        hi = 256*hi + 1;
        lo = 256*lo;
    end
end

% Add termination bits to the output string to ensure that the final
% dyadic interval lies within the source interval

if isempty(straddle)
    y = [y, interval(lo)];
else
    strad_comp = [straddle(2:length(straddle)), interval(lo)];
    strad_comp = uint8((strad_comp > straddle));
    straddle = straddle + strad_comp;
    y = [y, straddle, interval(lo)];
    straddle = [];
end

% THAT'S ALL FOLKS

        
