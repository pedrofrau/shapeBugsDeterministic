function mat = mat4
    mat = zeros(40,40);
    for i=18:25
        for j=15:18
            mat(i,j) = 1;
        end
    end
    for i=18:22
        for j=18:30
            mat(i,j) = 1;
        end
    end
end