function y = sat(x, m)

if 1 > m/norm(x)
    temp = m/norm(x);
else
    temp = 1;
end

y = x*temp;

end