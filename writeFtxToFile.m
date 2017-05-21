function writeFtxToFile(system)
    fileID = fopen('ftxTemp.m', 'w'); 
    fclose(fileID);
    if fileID == -1 
        error('File is not opened'); 
    end
    fileID = fopen('ftxTemp.m', 'a'); 
    fileHeader = ['function [ dx ] = ftxTemp(t, x)\n\tdx = zeros(' num2str((size(system, 1))) ', 1);\n'];
    fprintf(fileID, fileHeader);
    
    for i = 1:size(system, 1)
        strTmp = system(i, 1);
        for j = 1:size(system, 1)
            toReplace = ['x' num2str(j)];
            replacement = ['x(' num2str(j) ')'];
            strTmp = strrep(strTmp, toReplace, replacement); 
        end
        str = ['\tdx(' num2str(i) ') = ' char(strTmp) ';\n'];
        fprintf(fileID, str);
    end
    fprintf(fileID, 'end');
    fclose(fileID);
end
