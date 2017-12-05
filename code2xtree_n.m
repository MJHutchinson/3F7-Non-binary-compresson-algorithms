function xt = code2xtree_n(c, cl, base)
% code2xtree(c, cl) converts a variable length code described by the matrix
% c of codewords (one codeword per row) and codeword lengths cl to an
% extended tree representation of the prefix-free code where every node
% points to its parent and child(ren) node(s).
%
% Modified from the FTR files provided by Jossy Sayir by Basil Mustafa and
% Michael Hutchinson, 2017

xt = zeros(base+1,1); % root

for k = 1:length(cl)
    n = 1; % start at root
    for j = 1:cl(k)
        child = xt(2+c(k,j),n);
        if (child == 0) % no such child yet
            % create child
            xt = [xt [n;zeros(base,1)]];
            child = size(xt,2);
            xt(2+c(k,j),n) = child;
        end
        n = child;
    end
end
