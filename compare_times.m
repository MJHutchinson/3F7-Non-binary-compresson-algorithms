function times = compare_times(filename, bases, huffman)
%Returns encoding & decoding times for different bases, using MATLAB's
%timeit function
% b x 3 matrix where first column is the base, second column is encoding
% time and third column is decoding time

% open files
if nargin < 3
	huffman = false;
end

f = fopen(filename, 'r');
if (f == -1)
    error(['Could not open ' filename])
end
in = fread(f)';
fclose(f);

% compute probabilities
p = hist(in, 0:255);
p = p/sum(p);

% initialise time vectors
bases = bases(:);
times = -1*ones(length(bases), 3);

for b_id = 1:length(bases)
    times(b_id, 1) = bases(b_id);
    % encode once without timing for the decoder
    try
        if huffman
            [c,cl] = huffman_n(p, bases(b_id));
            encoded = vl_encode_n(in, c, cl, bases(b_id));
        else	
            encoded = arith_encode_n(in, p, bases(b_id));
        end

        % time encoder
        %disp(['Timing encoder for base ' num2str(bases(b_id))]);
        if huffman
            func = @() vl_encode_n(in, c, cl, bases(b_id));
        else
            func = @() arith_encode_n(in, p, bases(b_id));
        end
        times(b_id,2) = -1; %timeit(func);

        % time decoder
        %disp(['Timing decoder for base ' num2str(bases(b_id))]);
        if huffman
            func = @() vl_decode_n(encoded,c,cl,bases(b_id));
        else
            func = @() arith_decode_n(encoded, p, bases(b_id), length(in));
        end
        times(b_id,3) = timeit(func);
    catch
        disp(['Could not encode for base ' num2str(bases(b_id))])
    end
    
    
end

