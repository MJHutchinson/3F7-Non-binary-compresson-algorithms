function y = vl_decode_n(x, c, cl, base, alphabet)
% vl_decode(x,c,cl) decodes a stream of bits x using the variable length
% code described by the code table c and lengths cl. The source alphabet
% is assumed to be the numbered leaves of the tree (starting from zero).
% Alternatively, a source alphabet can be specified and provided as an
% optional argument.
%
% Copyright Jossy 2016

if (~(nargin >= 4 && nargin <= 5))
    error('Syntax: vl_decode(x,cl,cl,base[,alphabet])');
end

% analyse the tree and pick out the root and the leaves
nz = find(cl)';
xt = code2xtree_n(c(nz,:),cl(nz), base);
root = find(xt(1,:) == 0);
leaves = setdiff(1:size(xt,2), xt(1,:));


if (nargin == 4)
    alphabet = nz-1;
else
    if (length(alphabet) ~= length(leaves))
        error('Alphabet size does not match number of leaves in tree');
    end
end


% decode input vector
y =[]; % output vector
n = root; % n points to current node, initially root
for k = 1:length(x) % for every input symbol
    % shift n to left or right child node depending on x(k)
    n = xt(2+x(k),n);
    [isleaf, locleaf] = ismember(n, leaves); % is n a leaf?
    if (isleaf) % if a leaf has been reached 
        y = [y alphabet(locleaf)]; % generate output symbol
        n = root; % return to root
    end
end

return;

