%% LOAD IN FILE
fid = fopen('test_files/hamlet.txt','r');
hamlet = fread(fid)';
fclose(fid);
%% HISTOGRAM OF TEXT
p = hist(hamlet, 0:255);
p = p/sum(p);

%% ARITHMETIC CODE
%hamlet_bin = arith_encode(hamlet, p);
base = 2^16 - 1;
hamlet_bin_n = arith_encode_n(hamlet, p, base);
%comp = (hamlet_bin ~= hamlet_bin_n);
%find(hamlet_bin_n == 0,1)
hamlet_decoded = arith_decode_n(hamlet_bin_n, p,base, length(hamlet));
char(hamlet_decoded(1:500))

%% TRIVIAL TEST
% p = [0.2 0.5 0.3];
% alphabet = ['A' 'B' 'C'];
% input = ['A' 'B' 'A' 'C' 'A' 'B' 'C'];
% base = 2;
% 
% encoded = arith_encode(input, p, alphabet);
% decoded = arith_decode(encoded, p, length(input),  alphabet);
% 
% encoded_n = arith_encode_n(input, p, base,  alphabet);
% decoded_n = arith_decode_n(encoded, p, base, length(input), alphabet);
% encoded_n == encoded
% %decoded_n == decoded


