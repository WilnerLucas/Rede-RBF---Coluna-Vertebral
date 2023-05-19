function [ y ] = ativacao( u )
    
    y = zeros(1, length(u));
    max_valor = max(u);
    for i=1:length(u)
        if (u(i)==max_valor)
            y(i) = 1;
        else
            y(i) = 0;
        end
    end
     
end