function [efficiencies] = arith_compare(x, base_arr, symbols)

    efficiencies = zeros(length(base_arr), length(symbols));
    
    for j = 1:length(base_arr)
       base = base_arr(j);
       
       for k = 1:length(symbols)
           syms = symbols(k);
           
           if(syms == -1)
               syms = length(x);
           end
           
           p = hist(x(1:syms),0:255);
           p = p/sum(p);
           
           h = Hn(p, base);         
           
           y = arith_encode_n(x(1:syms), p, base);
           
           c = length(y)/syms;
           
           efficiencies(j,k) = c/h;
       end
    end
end

