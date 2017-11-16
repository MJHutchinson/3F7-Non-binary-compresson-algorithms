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
% create vectors of fractional values
fracs = uint64(zeros(256,1));
fracs(1) = ceil(one / 256);
for i = 1:255
    fracs(i) = fracs(1) * i;
end
fracs(256) = one;

%create mask for first 8bits
mask = @(x) bitand(bitcmp(bitshift(bitcmp(uint64(0)),-8)),x);
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
for k = 1:length(x) % for every input symbol
    k
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   PLEASE COMPLETE NUMBERED STEPS BELOW AS INSTRUCTED          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % 1) calculate the interval range to be the difference between hi and lo + 1
    % The +1 is necessary to avoid rounding issues
    range = hi - lo + uint64(1);
    
    % The following command finds the index of the next input symbols in
    % the cumulative probability distribution f
    ind = find(alphabet == x(k)); 

    % 2) narrow the interval end-points [lo,hi) to the new range [f,f+p]
    % within the old interval [lo,hi], being careful to round 'innwards' so
    % the code remains prefix-free (you want to use the functions ceil and
    % floor). This will require two instructions
    %
    lo = lo + uint64(range * f(ind)) + uint64(1); %multiplying uint64 by decimal automatically rounds down
    hi = lo + range * p(ind);
    
    % reset lo_master and hi_master
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
            % between a recip-256 interval
            if isempty(straddle)
                %disp(['NO STRADDLE: lo = ' num2str(lo) ' with interval ' num2str(interval(lo))])
                %disp(['Low interval = ' num2str(interval(lo)) ' next interval = ' num2str(interval(bitshift(lo, 8)))])
                
                y = [y, interval(bitshift(lo, 8))];
                hi = hi - mask(hi);
                lo = lo - mask(lo);
            else
                strad_comp = [straddle(2:length(straddle)), interval(lo)];
                strad_comp = uint8((strad_comp > (255 - straddle)));
                straddle = straddle + strad_comp;
%                 disp(['Number of zeros in straddle = ' num2str(sum(straddle == 0))])
                %disp(['lo = ' num2str(lo) ' with interval ' num2str(interval(lo))])
                %y = [y, straddle, interval(lo)];
                y = [y, straddle];
                hi = hi - mask(hi);
                lo = lo - mask(lo);
                straddle = [];
            end
        elseif interval(hi) - interval(lo) > 2
            % need to include more symbols
            % to narrow down probability range enough to assign a value
            break;
        else
            %the probability interval straddles either side of
            %interval(lo) + 1 (= interval(hi))
            if interval(hi - lo) == 1
                %it straddles, but cannot narrow down this range without
                %including another symbol
                break;
            else
                lo_shift = interval(bitshift(lo,8));
                straddle = [straddle, lo_shift];

                lo = lo - uint64(lo_shift)*fracs(1);
                hi = hi - uint64(lo_shift)*fracs(1);
            end
        end    
        
        % 7) now multiply the interval end-points by 256 (the -1/2 or -1/4
        % operations have already been performed if appropriate, so the
        % interval is now in all cases within [0,1/256] and can simply be
        % multiplied by 2 to stretch to [0,1]. ADD 1 TO THE HI END-POINT
        % AFTER MULTIPLYING. THIS ENSURES THAT A 1 BIT IS PIPELINED INTO
        % THE HI BOUND AND WILL HELP AVOID UNDERFLOW/OVERFLOW.
        % 
        %disp(['Lo interval is ' num2str(interval(lo)) ' and gap is ' num2str(interval(hi) - interval(lo))]);
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

        