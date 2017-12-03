bases = floor(2.^(1:1.5:16));

lengths = 10:5:200;

N = 10000;

closness_to_optimal = zeros(length(bases), length(lengths), N);

for n = 1:N
    x = abs(randn(2000,1));
    x = floor(x*4);
    x(x>3) = 3;

    p = hist(x, 0:3);
    p = p/sum(p);

    for j = 1:length(lengths)
       l = lengths(j);

       p = hist(x(1:l), 0:3);
       p = p/sum(p);

       for k = 1:length(bases)
           base = bases(k);

           nits = length(arith_encode_n(x(1:l), p, base));
           h = Hn(p, base);

           closness_to_optimal(k, j, n) = (nits/l)/h;

       end   

    end
    if mod(n,100) == 0
        disp(n)
    end
end

closness_to_optimal = mean(closness_to_optimal, 3);

fig = figure(3);
figure(3);

hold on;

legend on;
for j = 1:length(bases)
    plot(lengths, closness_to_optimal(j,:), 'DisplayName', num2str(bases(j)));
end

title('Convergance to optimality across bases')
xlabel('Length of randomly generated file')
ylabel('nits per symbol / entropy in base N')
set(fig, 'position', [0 0 800 500])