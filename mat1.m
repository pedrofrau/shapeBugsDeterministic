function mat = mat1
    mat = zeros(40,40);
    for i = 15:24
        for k = 15:24
            mat(i,k) = 1;
        end
    end
end