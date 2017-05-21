function [ initConditionForXMatrix ] = generateInitConditionForXMatrix( n )
    tmpMatrix = eye(n, n);
    initConditionForXMatrix = mat2str(tmpMatrix(:));

end

