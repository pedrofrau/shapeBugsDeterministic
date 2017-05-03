function [mat, low2, var] = mat6
    mat = zeros(40,40);
    aux = 27;
    for i=10:15
        for j=aux:28
            mat(i,j) = 1;
        end
        aux = aux - 1;
        if aux == 21
            break;
        end
    end
    for i=17:22
        for j=15:20
            mat(i,j) = 1;
        end
    end
   
    low2 = [15 aux+1];
    mat(low2(1),low2(2)) = 2;
    var = 1;


end