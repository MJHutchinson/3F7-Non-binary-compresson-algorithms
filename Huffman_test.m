fid = fopen('test_files/hamlet.txt','r');
hamlet = fread(fid)';
fclose(fid);

%p = hist(hamlet, 0:255);
%p = p/sum(p);

N = 256;

p = abs(randn(1,N));
p = p/sum(p);

% p = ones(1,N);
% p = p/sum(p);

% p = 2.^(1./[1:4/N:4]);
% p = p/sum(p);


base = [];
eff = [];
h = [];
ex = [];


for b=2:1000
    
    hn = Hn(p,b);
    [c,cl] = huffman_n(p,b);
    e = huffman_expected_length(p, cl);
    
    base = [base b];
    eff = [eff e/hn];
    h = [h (hn)];
    ex = [ex (e * (log(b)/log(2)))];
    
    if mod(b, 100) == 0
        disp(b);
    end
    
end

fig = figure(3);
figure(3);
clf;
hold on;
plot(log(N)./log(base), eff);
h_r = ((rem(h, 1) - 0.5) * 2);
ylabel('Expected length / Entropy in Base')
yyaxis right;
plot(log(N)./log(base), h_r.^20)

title('Closeness to optimality vs base for non uniform distibution (256 symbols)')
xlabel('1/log_{256}(base)')
set(fig, 'position', [0 0 800 500])
