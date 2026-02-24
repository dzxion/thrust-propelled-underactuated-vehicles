function y = mu_tao(s,tao)

if s <= tao
    y = sin(pi*s^2 / (2*tao^2)); 
else 
    y = 1;
end

end