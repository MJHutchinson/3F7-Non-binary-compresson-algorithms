clM = [];
clN = [];

N = 100000;
m = 2;
n = 1000;

for i = 1:N
    
    x = abs(randn(1000,1));
    x = floor(x*4);
    x(x>3) = 3;
    
    p = hist(x, 0:3);
    p = p/sum(p);
    
    clM = [clM length(arith_encode_n(x, p, m))];
    clN = [clN length(arith_encode_n(x, p, n))];        
    
end

clNM = clN * (log(n)/log(m));

mn = min([clM clNM]);
mx = max([clM clNM]);

fig = figure(2);
figure(2);

clf;
hold on
histogram(clM, mn:mx);
yl = ylim;
ylabel('count')

yyaxis right
histogram(clNM, mn:mx, 'FaceColor', 'red');
ylim(yl*(log(n)/log(m)))
ylabel('count')

xlabel('Expected length stored in binary (bits)')
title('Expected length when stored in binary for base 1000')
legend({'base 2','base 1000'})

set(fig, 'position', [0 0 800 500])




% disp(mean(clNM) - mean(clM));