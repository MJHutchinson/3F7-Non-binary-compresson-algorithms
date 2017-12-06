N = 31;
A = clM;%cl(1,:);
%B = cl(N,:);
a = m; %bases(1);
b = n; %bases(N);
Amod=mod(A, log(b)/log(2));
histogram(Amod, -0.5:1:(ceil(log(b)/log(2)) - 0.5));
set(gcf, 'position', [0 0 400 500])
xlabel('Additional Length');
ylabel('Count');
title(sprintf('Aditional expected length when \n encoding in base %d',b));
