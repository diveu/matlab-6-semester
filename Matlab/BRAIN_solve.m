function solve = BRAIN_solve(inputTaskTableData, conditionsTableData, segBegin, segEnd, stepsCount, accuracyExternal, accuracyInternal, solvingMethodForInternalTask, stepSize, solvingMethodForExternalTask, timeOfT, initialVectorTableData)
        ftx = inputTaskTableData;
        ftx = ftx(1:end-1, 2);
        n = size(ftx, 1);
        
        dftx = BRAIN_findDftx(ftx);
        XMatrix = BRAIN_generateXMatrix(size(ftx, 1));
        initConditionForXMatrix = BRAIN_generateInitConditionForXMatrix(size(ftx, 1))';
        initConditionsForInternalTask = [initialVectorTableData initConditionForXMatrix];
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
        toFile = [ftx; strDX];
        BRAIN_writeSystemToFile(toFile);
        charFP = conditionsTableData;
        FP = BRAIN_makeFP(charFP, segBegin, segEnd);
        p0 = initialVectorTableData;
        
        global DRXA XAP DRXB XBP FP0;
        symArray1 = sym('xa%d', [1 n]);
        symArray1 = [symArray1 sym('xb%d', [1 n])];
        syms(symArray1);
        symArray1 = num2cell(symArray1);
        
        symArray2 = sym('xa%d', [1 n]);
        syms(symArray2);
        
        symArray3 = sym('xb%d', [1 n]);
        syms(symArray3);
        
        internalTaskStepSize = 0.01;
        
        h = waitbar(0,'Пожалуйста, подождите...');
        for i = 1:stepsCount
            steps = 1/stepSize;
            for j = 0:stepSize:(1-stepSize)
                switch solvingMethodForInternalTask
                    case 1
                        if timeOfT == segBegin
                            [T, X] = ode45(@systemTemp, [segBegin:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                        elseif timeOfT == segEnd
                            [T, X] = ode45(@systemTemp, [segEnd:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = T(end:-1:1, :);
                            X = X(end:-1:1, :);
                        else 
                            [T1, X1] = ode45(@systemTemp, [timeOfT:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            [T2, X2] = ode45(@systemTemp, [timeOfT:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = [T1(end:-1:2); T2];
                            X = [X1(end:-1:2, :); X2];
                        end
                    case 2
                        if timeOfT == segBegin
                            [T, X] = ode23(@systemTemp, [segBegin:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                        elseif timeOfT == segEnd
                            [T, X] = ode23(@systemTemp, [segEnd:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = T(end:-1:1, :);
                            X = X(end:-1:1, :);
                        else 
                            [T1, X1] = ode23(@systemTemp, [timeOfT:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            [T2, X2] = ode23(@systemTemp, [timeOfT:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = [T1(end:-1:2); T2];
                            X = [X1(end:-1:2, :); X2];
                        end
                    case 3
                        if timeOfT == segBegin
                            [T, X] = ode23t(@systemTemp, [segBegin:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                        elseif timeOfT == segEnd
                            [T, X] = ode23t(@systemTemp, [segEnd:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = T(end:-1:1, :);
                            X = X(end:-1:1, :);
                        else 
                            [T1, X1] = ode23t(@systemTemp, [timeOfT:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            [T2, X2] = ode23t(@systemTemp, [timeOfT:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = [T1(end:-1:2); T2];
                            X = [X1(end:-1:2, :); X2];
                        end
                    case 4
                        if timeOfT == segBegin
                            [T, X] = ode113(@systemTemp, [segBegin:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                        elseif timeOfT == segEnd
                            [T, X] = ode113(@systemTemp, [segEnd:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = T(end:-1:1, :);
                            X = X(end:-1:1, :);
                        else 
                            [T1, X1] = ode113(@systemTemp, [timeOfT:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            [T2, X2] = ode113(@systemTemp, [timeOfT:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = [T1(end:-1:2); T2];
                            X = [X1(end:-1:2, :); X2];
                        end
                    case 5
                        if timeOfT == segBegin
                            [T, X] = ode23s(@systemTemp, [segBegin:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                        elseif timeOfT == segEnd
                            [T, X] = ode23s(@systemTemp, [segEnd:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = T(end:-1:1, :);
                            X = X(end:-1:1, :);
                        else 
                            [T1, X1] = ode23s(@systemTemp, [timeOfT:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            [T2, X2] = ode23s(@systemTemp, [timeOfT:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = [T1(end:-1:2); T2];
                            X = [X1(end:-1:2, :); X2];
                        end
                    case 6
                        if timeOfT == segBegin
                            [T, X] = ode15s(@systemTemp, [segBegin:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                        elseif timeOfT == segEnd
                            [T, X] = ode15s(@systemTemp, [segEnd:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = T(end:-1:1, :);
                            X = X(end:-1:1, :);
                        else 
                            [T1, X1] = ode15s(@systemTemp, [timeOfT:-internalTaskStepSize:segBegin], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            [T2, X2] = ode15s(@systemTemp, [timeOfT:internalTaskStepSize:segEnd], initConditionsForInternalTask, odeset('RelTol', accuracyInternal));
                            T = [T1(end:-1:2); T2];
                            X = [X1(end:-1:2, :); X2];
                        end
                end

                n = size(FP, 1);

                XAP = X(1, n+1:end);
                XAP = reshape(XAP, [n n]);
                XBP = X(end, n+1:end);
                XBP = reshape(XBP, [n n]);

                XP0 = num2cell([X(1, 1:n) X(end, 1:n)]);

                FP0 = subs(FP(:, 1), symArray1, XP0);
                
                DRXA = jacobian(FP, symArray2);
                DRXB = jacobian(FP, symArray3);
                
                DRXA = subs(DRXA, symArray1, XP0);
                DRXB = subs(DRXB, symArray1, XP0);
                
                switch solvingMethodForExternalTask
                    case 1
                        [mu, p] = ode45(@BRAIN_findDFP, [j (j+stepSize)], p0, odeset('RelTol', accuracyExternal));
                    case 2
                        [mu, p] = ode23(@BRAIN_findDFP, [j (j+stepSize)], p0, odeset('RelTol', accuracyExternal));
                    case 3
                        [mu, p] = ode23t(@BRAIN_findDFP, [j (j+stepSize)], p0, odeset('RelTol', accuracyExternal));
                    case 4
                        [mu, p] = ode113(@BRAIN_findDFP, [j (j+stepSize)], p0, odeset('RelTol', accuracyExternal));
                    case 5
                        [mu, p] = ode23s(@BRAIN_findDFP, [j (j+stepSize)], p0, odeset('RelTol', accuracyExternal));
                    case 6
                        [mu, p] = ode15s(@BRAIN_findDFP, [j (j+stepSize)], p0, odeset('RelTol', accuracyExternal));
                    case 7
                        p = (BRAIN_findDFP*stepSize+p0')';
                end
                p(end, :);
                p0 = p(end, :);
                initConditionsForInternalTask = [p0 initConditionForXMatrix];
                waitbar((j/stepsCount) + ((i-1)/stepsCount));
            end
        end
        close(h);
        solve = [T(:, :), X(:, 1:n)];
end