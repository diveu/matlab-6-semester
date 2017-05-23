function solve = BRAIN_solve(inputTaskTableData, conditionsTableData, segBegin, segEnd, stepsCount, accuracyExternal, accuracyInternal, solvingMethod, timeOfT, initialVectorTableData)
        ftx = inputTaskTableData;
        ftx = ftx(1:end-1, 2)
        n = size(ftx, 1);
        
        dftx = BRAIN_findDftx(ftx)
        XMatrix = BRAIN_generateXMatrix(size(ftx, 1));
        initConditionForXMatrix = BRAIN_generateInitConditionForXMatrix(size(ftx, 1));
        initialVectorTableData = str2double(initialVectorTableData)'
        initConditionsForInternalTask = [initialVectorTableData; initConditionForXMatrix]';
        DX = dftx*XMatrix;
        
        strDX = zeros(0);
        tmpStrDX = zeros(0);
        
        for i = 1:n
            for j = 1:n
                a = char(DX(j, i));
                A = string(a);
                tmpStrDX = [tmpStrDX; A];
            end
            strDX = [strDX tmpStrDX];
            tmpStrDX = zeros(0);
        end
        
        strDX = reshape(strDX, [n*n, 1]);
        toFile = [ftx; strDX]
        BRAIN_writeSystemToFile(toFile);
        [T, X] = ode45(@systemTemp, [segBegin segEnd], initConditionsForInternalTask);
        solve = [T, X];
%         charFP = conditionsTableData;
%         FP = BRAIN_makeFP(charFP, segBegin, segEnd);
%         BRAIN_findDFP(FP, X)
end