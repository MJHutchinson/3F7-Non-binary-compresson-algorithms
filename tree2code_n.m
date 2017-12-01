function [c, cl] =tree2code_n(t)
% tree2code(t) converts a varialble length prefix-free code from tree
% notation to code notation (list of codewords and list of lengths).
%
% Copyright Jossy, 2016

assert(nargin == 1);

% determine alphabet size: any number between 1 and length(t) that is not a
% 'parent' in the tree must be a leaf and hence correspond to a source
% symbol.
alphabet = setdiff(1:length(t),t);
asize = length(alphabet);


% initialise codeword table with all zeros
c = zeros(asize,length(t)); 
% c is to hold the encoder matrix in its rows. The number of columns is
% meaningless at this point and has set to length(t) so as to definitely be
% larger than the longest codeword
cl = zeros(asize,1); % codeword lengths initialise to 0
for k = 1:asize % for each source symbol
   n = alphabet(k); % set n to point to corresponding leaf
   % n will creep up the tree to the root
   while (t(n) ~= 0) % as long as root not reached
       % if this is the 'first' child of its parent t(n) in order of
       % indexing in the tree, do nothing (code matrix is already
       % pre-loaded with zeros), otherwise insert a 1 in codeword
       a = find(t(1:(n-1)) == t(n));
       if (~isempty(a))
           c(k,cl(k)+1) = length(a); % ONLY LINE CHANGED length(a) is number 
                                     % of children already of parent node
       end
       cl(k) = cl(k)+1; % increase codeword length
       n = t(n);
   end
   % reverse direction of codeword so it is from root to leaf, as it's been
   % constructed from leaf to root
   c(k,1:cl(k)) = c(k,cl(k):-1:1); 
end
% redimension encoder matrix to the length of the longest codeword
c = c(:,1:max(cl));

return;