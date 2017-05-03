function mat = mat5
    mat = zeros(40,40);
    aux = 27;
    for i=10:20
        for j=aux:28
            mat(i,j) = 1;
        end
        aux = aux - 1;
        if aux == 10
            break;
        end
    end
end