    function y=vl_encode_n(x, c, cl, base, alphabet)
% vl_encode(x, c, cl) encodes the input word x using the variable length
% code described in c (every row contains a codeword) and cl (lengths of
% the codewords.) The alphabet is assumed to be the set of distinct
% elements in x sorted in increasing order and the code size is checked
% for consistency with this alphabet. Alternatively, the alphabet can be
% supplied as an optional extra argument and if so, its size can exceed the
% number of distinct symbols in x (e.g. if there are codewords for symbols
% that don't occur in x and hence won't be used in this encoding run.)
%
% Copyright Jossy, 2016


% CHECK INPUT ARGUMENTS
if (nargin < 3 | nargin > 4)
    error('Function needs 3 or 4 arguments');
end
if (size(c,1) ~= length(cl))
    error('Code table and code lengths have inconsistent dimensions.');
end

if (nargin == 4)
    if (~isempty(setdiff(unique(x), alphabet)))
        error('There are symbols in data that are not in alphabet.');
    end
else
    alphabet = unique(x);
end
asize = size(alphabet);

if (asize > length(cl))
    error('Input word alphabet inconsistent with code dimension.');
end

% binary encode
y = [];
for k = 1:length(x)
    a = find(alphabet == x(k));
    y= [y c(a,1:cl(a))];
end

return;
