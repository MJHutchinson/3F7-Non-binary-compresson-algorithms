function t = code2tree_n(c, cl, base)
% code2tree(c, cl) converts a variable length code described by the matrix
% c of codewords (one codeword per row) and codeword lengths cl to a tree
% representation of the prefix-free code where every node points to its
% parent node.
%
% Copyright Jossy, 2016

xt = code2xtree_n(c,cl, base);
t = xt(1,:);
end
