N = 10000;


bases = [2:16 2.^(2:0.5:16)];

bases = sort(unique(floor(bases)));

cl = zeros(length(bases), N);

for n = 1:N
    
    x = abs(randn(1000,1));
    x = floor(x*4);
    x(x>3) = 3;
    
    p = hist(x, 0:3);
    p = p/sum(p);
    
    for j = 1:length(bases)  
        base = bases(j);
        
        l = length(arith_encode_n(x, p, base));
        
        cl(j, n) = l * (log(base)/log(2));
    
    end
    
end

mean_cl = mean(cl, 2);
mean_cl = mean_cl - mean_cl(1);
z = (log(bases)/log(2) -1)/2;

fig = figure(1);
figure(1);

hold on;
scatter(log(bases)./log(2), mean_cl);
plot(log(bases)./log(2), z);

xlabel('log_2(base)')
ylabel('Average redundant length compared to binary (bits)')
title('Redundant length of code in base N vs binary')
legend({'Observed data over 10,000 samples', 'Expected line from prediction'});
set(fig, 'position', [0 0 800 500])

