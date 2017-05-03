%%%%2D patterns - SHAPEBUGS %%%%
clear all;
%%%%INITIALIZATIONS%%%%%
prevj = 1;%Variables for previous positions
prevz = 1;
low = [prevj prevz];%The lower (bottom left) postition of the figure to initialize the "robots"
var = 0;%Variable used on a condition for changing "low" in a two figure scenario
% mat = mat1;%Initialization of the scenario mat1
% mat = mat2;%Initialization of the scenario mat2
% mat = mat3;%Initialization of the scenario mat3
% mat = mat4;%Initialization of the scenario mat4
% mat = mat5;%Initialization of the scenario mat5
[mat, low2, var] = mat6;%Initialization of the two-figure scenario mat6
display = true;

%%%%Function for searching the bottom left cell of the figure%%%%%
for j = 1:size(mat,1)
    for z = 1:size(mat,2)
         if mat(j,z) == 1
            if j > prevj && z <= prevz;
                low = [j z];
            end
            prevj = j;
            prevz = z;
         end
    end
end

m1 = [low(1) low(2)];%We store the position of goal while we study its adjacent cells
mat(low(1), low(2)) = 2;%We give the goal a cost of 2
adjacent = [ 1 0; 0 1; -1 0; 0 -1;1 1;-1 -1;1 -1;-1 1];  % We initialize a matrix of immediate adjacents
display = true;

%%%%%WAVEFRONT ALGORITHM FOR COMPUTING ROBOT CELL'S COST%%%%%%%%%
%%%%%Start of the wavefront algorithm%%%%%
while size(m1,1) ~= 0
  % For each cell adjacent to the current one check its particularities
  for k=1:size(adjacent,1)
    % Calculate index for current adjacent cell:
    adj = m1(1,:)+adjacent(k,:);
    % Check the existance of the adjacent cell in the map
    if min(adj) < 1
      continue
    end
    if adj(1) > size(mat,1)
      continue
    end
    if adj(2) > size(mat,2)
      continue
    end
    % Check if the adjacent cell hasn't been already visited
    if mat(adj(1), adj(2)) ~= 0
      continue
    end
    % Set the cost and add the adjacent to the m1 set
    if low(1)+10>=adj(1) && adj(1)>=low(1) &&...
            low(2)-10<=adj(2) && adj(2)<=low(2)
        mat(adj(1), adj(2)) = mat(m1(1,1), m1(1,2)) + 1;
        m1(size(m1,1)+1,:) = adj;
    end
  end
  m1 = m1(2:end,:);
end   

%%%Computation of the maximum value of the matrix to move the outsider
%%%robots
maxval = 0;
for i=1:size(mat,1)
    for j=1:size(mat,2)
        if mat(i,j)>maxval
            maxval = mat(i,j);
        end
    end
end

ml = [];%List of maximum cost robot x position
ml2 = [];%List of maximum cost robot y position
aux = 1;
%%%%%We fill the maximum value's lists%%%%%
for i=1:size(mat,1)
    for j=1:size(mat,2)
        if mat(i,j) == maxval
            ml(aux) = i;
            ml2(aux) = j;
            aux = aux + 1;
        end
    end
end

leader = 2;%Leader value i.e. cost value of the bottom left cell of the figure
check = 0;
summl = 1;%Stopping condition variable
while summl ~=0
    ml3 = ml;%Auxiliar maximum value's lists
    ml4 = ml2;
    if var == 1 && mat(22,20) == 2%Condition for changing low value in a two figures scenario
        low = low2;
        var = 0;
    end
    %%%%%%%CONDITIONS FOR MOVING THE ROBOTS AND LEAVING THEM IN A CERTAIN
    %%%%%%%POSITION
    if mat(ml(1)+1,ml2(1)) == 1 %If you find a figure under your position...
        ml(1) = ml(1)+1;%Move downwards
        for i=1:length(ml)%Update costs of moving robots
            %%%%All leader's surrounding robots will cost leader + 1
            if (mat(ml(i)+1,ml2(i)+1) == leader || ...
                mat(ml(i)+1,ml2(i)-1) == leader || ...
                mat(ml(i)-1,ml2(i)-1) == leader || ...
                mat(ml(i)-1,ml2(i)+1) == leader) && ...
                (mat(ml(1)+1,ml2(1)) == 1 || mat(ml(1),ml2(1)+1) == 1)
                mat(ml(i),ml2(i)) = leader + 1;
            %%%%Here a cost for stopping conditions
            elseif mat(ml(1),ml2(1)-1) == leader && mat(ml(1)+1,ml2(1)) == 0 
                 mat(ml(1),ml2(1)) = 40; 
            %%%%Here the cost for any other case
            else
                mat(ml(i),ml2(i)) = abs(ml(i)-low(1))+abs(ml2(i)-low(2))+2;
            end

        end
        mat(ml(length(ml)),ml2(length(ml2))) = 0;
    elseif mat(ml(1),ml2(1)+1) <= 1 && mat(ml(1)+1,ml2(1)) ~= 0
        ml2(1) = ml2(1)+1;
        for i=1:length(ml)
            if mat(ml(i)+1,ml2(i)+1) == leader || ...
                mat(ml(i)+1,ml2(i)-1) == leader || ...
                mat(ml(i)-1,ml2(i)-1) == leader || ...
                mat(ml(i)-1,ml2(i)+1) == leader
                mat(ml(i),ml2(i)) = leader + 1;
            elseif mat(ml(1),ml2(1)-1) == leader && mat(ml(1)+1,ml2(1)) == 0 
                mat(ml(1),ml2(1)) = 40;
            else
                mat(ml(i),ml2(i)) = abs(ml(i)-low(1))+abs(ml2(i)-low(2))+2; 
            end
        end
        mat(ml(length(ml)),ml2(length(ml2))) = 0;
    elseif mat(ml(1)-1,ml2(1)) <= 1
        ml(1) = ml(1)-1;
        for i=1:length(ml)
            if mat(ml(i)+1,ml2(i)+1) == leader || ...
                    mat(ml(i)+1,ml2(i)-1) == leader || ...
                    mat(ml(i)-1,ml2(i)-1) == leader || ...
                    mat(ml(i)-1,ml2(i)+1) == leader
                mat(ml(i),ml2(i)) = leader + 1;
                imagesc(mat);
            elseif mat(ml(1),ml2(1)-1) == leader && mat(ml(1)+1,ml2(1)) == 0 
                mat(ml(1),ml2(1)) = 40;
            else
                mat(ml(i),ml2(i)) = abs(ml(i)-low(1))+abs(ml2(i)-low(2))+2;
            end
        end
        mat(ml(length(ml)),ml2(length(ml2))) = 0;
    end
    %%%%Updating lists so that the robots follow each other 
    %%%%We use the auxiliary lists to do the transition
    for i=2:length(ml)
       ml(i) = ml3(i-1); %Robot i+1 takes the position of robot i
       ml2(i) = ml4(i-1); 
    end
    
    %%%Checking if the whole figure has been filled in
    temp = 0;
    for i=1:size(mat,1)
        for j=1:size(mat,2)
            if mat(i,j) == 1
                temp = 1;
            end
        end
    end
    %%%If it has been filled in, we make "disappear" the rest of the robots        
    if temp == 0
        for i=1:size(mat,1)
            for j=1:size(mat,2)
                if mat(i,j) > 2
                    mat(i,j) = 0;
                end
            end
        end
        summl = 0;
    end
    
    %%%%Checking if the robot i has a final position to see if i+1 needs to
    %%%%continue or stay in its position
    if mat(ml(1),ml2(1)) == 40
        for i=1:length(ml)-1
            ml(i) = ml(i+1);%%Turning i+1 into i
            ml2(i) = ml2(i+1);
        end
        ml(length(ml)) = [];
        ml2(length(ml2)) = [];
        
        %%%%Checking robots positions to compute stopping conditions
        for i=1:length(ml)
            if check == 0
                if (mat(ml(1)+1,ml2(1)) == 40)|| ...
                        (mat(ml(1),ml2(1)+1) == 40 && mat(ml(1),ml2(1)-1) == leader +1)
                    mat(ml(1),ml2(1)) = 40;
                    for i=1:length(ml)-1
                        ml(i) = ml(i+1);
                        ml2(i) = ml2(i+1);
                    end
                    ml(length(ml)) = [];
                    ml2(length(ml2)) = [];
                end
            else
                if mat(ml(1)+1,ml2(1)) == 40 && ...
                        mat(ml(1),ml2(1)+1) ~= 0
                    mat(ml(1),ml2(1)) = 40;
                    for i=1:length(ml)-1
                        ml(i) = ml(i+1);
                        ml2(i) = ml2(i+1);
                    end
                    ml(length(ml)) = [];
                    ml2(length(ml2)) = [];
                end
            end
        end
        if mat(ml(1)-1,ml2(1)+1) == 0
            check = 1;
        end
    end
    %%%If the surrounding robots are in the good position, they become
    %%%leaders
    for i=1:size(mat,1)
        for j=1:size(mat,2)
            if mat(i,j) == 40
                mat(i,j) = leader;
            end
        end
    end
    
    %%%Updating maximum value's lists with maxval - 1 positions
    if mat(ml(length(ml))+1,ml2(length(ml2))) == maxval - 1
        maxval = maxval - 1;
        aux = maxval;
        for i=1:size(mat,1)
            for j=1:size(mat,2)
                if mat(i,j) == maxval
                    ml = [ml i];
                    ml2 = [ml2 j];
                end
            end
        end
    end
    
    imagesc(mat);
    if display 
        disp('click/press any key');
        waitforbuttonpress; 
    end

end

