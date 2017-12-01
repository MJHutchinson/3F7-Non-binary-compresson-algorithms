function times = compare_times(filename, bases)
%Returns encoding & decoding times for different bases, using MATLAB's
%timeit function
% b x 3 matrix where first column is the base, second column is encoding
% time and third column is decoding time

% open files
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
        encoded = arith_encode_n(in, p, bases(b_id));
        
        % time encoder
        disp(['Timing encoder for base ' num2str(bases(b_id))]);
        func = @() arith_encode_n(in, p, bases(b_id));
        times(b_id,2) = timeit(func);
        
        % time decoder
        disp(['Timing decoder for base ' num2str(bases(b_id))]);
        func = @() arith_decode_n(encoded, p, bases(b_id), length(in));
        times(b_id,3) = timeit(func);
    catch
        disp(['Could not encode for base ' num2str(bases(b_id))])
    end
    
    
end

