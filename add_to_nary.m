function nary = add_to_nary(nary, add, n)
    l = length(nary);
    carry = add;
    for i = 0:(l-1)
        a = nary(l-i) + carry;
        if a > n-1
            carry = floor(a/n);
            a = a - n * carry;
            nary(l-i) = a;
        else
            nary(l-i) = a;
            carry = 0;
            break;
        end
    end
    
    if carry ~= 0 
        error('Addition overflowed');
    end
end