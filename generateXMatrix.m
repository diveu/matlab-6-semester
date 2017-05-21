 function [ XMatrix ] = generateXMatrix( n )
    %n = 3;
    tmpSymArray = zeros(0);
    XMatrix = zeros(0);
    for i = 1:n
        for j = 1:n
            tmpStr = ['x' num2str(i) num2str(j)];
            tmpSymArray = [tmpSymArray sym(tmpStr)];
        end
        XMatrix = [XMatrix; tmpSymArray];
        tmpSymArray = zeros(0);
    end
 end

