function [c, cl] = huffman_n(p, base)
% huffman(p, n) implements the Huffman algorithm to determine the optimal
% prefix-free code for a random variable with probability distribution p.
% The input vector p must consist of non-negative numbers that sum to 1.
% The output is a tree in matrix form, each row is a node in the tree and
% the entries in a row are the "children" of the node. The first length(p)
% nodes are leaves (corresponding to the source alphabet) and the last node
% in the list is the root.
%
% Modified from the FTR files provided by Jossy Sayir by Basil Mustafa and
% Michael Hutchinson, 2017


nz =find(p); % for now provide codewords only for non-zero probabilities
p_orig = p; % (we will introduce zero-length codewords for other symbols
p = p(nz); % at the end)


% The Huffman algorithm operates on two data structure:
% - a tree, built up by the algorithm
% - a list of probabilities and associated tree nodes 
%   (represented as an nx2 matrix where the first column contains the
%   probabilities and the second colum the index of the associated nodes)


% get length of input probability vector
n = length(p);
n_orig = n;

% replace the probability vector by a matrix with probabilities in its left
% column and the index of the corresponding tree nodes on the right
p = [p(:) (1:n)'];

% in order to ensure a fully bound tree, dummy symbols with zero
% probability must be added until (symbols)mod(base - 1) == 1. This need
% not be done in base 2
dummies = 0;
if base ~= 2
    while mod(n, base-1) ~= 1
       p = [p ; 0 n+1];
       n = length(p);
       dummies = dummies + 1;
    end
end

% initialise tree to the all-zero vector of length n, i.e.,
% one tree leaf per possible source symbol, all leaves are orphans for the
% moment until the algorithm connects them to the tree
t = zeros(1,n);

%%%%%%%%%%%%%%%%%%%%%%%
% HUFFMAN ALGORITHM  %%
%%%%%%%%%%%%%%%%%%%%%%%
while (size(p,1) > 1) % while there are at least 2 probs in the list
    [pp,ii] = sort(p(:,1)); % sort the probabilities
    % re-order the probabilities cum index by order of increasing probs
    p = p(ii,:); 
    
    % Implement the following steps:
    % 1) add a new "orphan" node to the end of the tree t (value 0)
    % 2) make this new node the parent of the two nodes with the smallest
    % probabilities (their indices being p(1,2) and p(2,2))
    % 3) replace the two smallest nodes in the "p" matrix by their new
    % parent nodes: for example, keep the second row of p and replace its
    % first entry by the sum of the two previous smallest probabilities,
    % and its second entry by the index of the new node you have created in
    % the tree, and then remove row 1 of p.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PLEASE COMPLETE THIS PART OF THE FUNCTION. %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t = [t  0];
    p_cum = 0;
    
    % determine how many nodes to connect in this iteration of the
    % algorithm. If less than base nodes left, connect those together, else
    % connect the next base nodes together with the smallest probabilities.
    j = 0;
    if(base > length(p))
        j = length(p);
    else
        j = base;
    end
    
    % sum the probabilities of the nodes connected together in this step
    % and connect them to the parent node.
    for i=1:j
       p_cum = p_cum + p(i,1);
       t(p(i,2)) = length(t); 
    end
    
    % remove the nodes connected together on this iteration together
    for i=1:(j-1)
       p(1,:) = []; 
    end
    
    % add a new node to the list with probability the sum of its children
    % at the correct location in the tree
    p(1,:) = [ p_cum length(t) ];
end

% if dummy nodes were added to the code, remove them and readjust the tree
% to reflect this
if dummies ~= 0
   t(n_orig+1:n_orig+dummies) = [];
   t(1:length(t)-1) = t(1:length(t)-1) - dummies;
end

% convert the tree to a code
[c_nz,cl_nz] = tree2code_n(t);

% now introduce zero length codewords for zero probability symbols
cl = zeros(length(p_orig),1);
c = zeros(length(p_orig),size(c_nz,2));
cl(nz) = cl_nz;
c(nz,:) = c_nz;

return;


