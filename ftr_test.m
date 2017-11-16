%% LOAD IN FILE
fid = fopen('test_files/hamlet.txt','r');
hamlet = fread(fid)';
fclose(fid);
%% HISTOGRAM OF TEXT
p = hist(hamlet, 0:255);
p = p/sum(p);

%% ARITHMETIC CODE
hamlet_bin = arith_encode_base_n(hamlet, p);


%% ENCODING
%fprintf(['\nCHECK: Hamlet bin length = ' num2str(length(hamlet_bin)) ' \n\n'])

%hamlet_cz1 = bits2bytes(hamlet_bin);
%fprintf(['Compressed length is ' num2str(length(hamlet_cz1))]);
%R_cz1 = length(hamlet_cz1)/length(hamlet);
%fprintf(['\nThis corresponds to a compression rate of R = ' num2str(round(R_cz1,7))]);
%fprintf(['\nCompressed bits per byte = ' num2str(round(8*R_cz1,7)) '\n']);

%fprintf(['\nThe entropy of the distribution is ' num2str(round(H(p),7)) ' - this is also a lower bound.\n'])

%% DECODING
%hamlet_decoded = arith_decode(hamlet_bin, p,length(hamlet_bin));
%char(hamlet_decoded(1:500))

