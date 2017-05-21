function [ dftx ] = findDftx( ftx )
    %ftx = [{'x1+x2*x3-cos(x4)'}; {'x1-x2/x3-sin(x4)'}; {'x1+x2*x3-cos(x4)'}; {'x1+x2*x3-cos(x4)'}];
    dftx = zeros(0);
    symArray = zeros(0);
    tmpFtx = ftx;
    for i = 1:size(ftx, 1)
        tmpStr = ['x' num2str(i)];
        symArray = [symArray; sym(tmpStr)];
    end
    syms(symArray);
    for i = 1:size(ftx, 1)
        x = sym(['x' num2str(i)]);
        tmpFtx = diff(tmpFtx, x, 1);
        dftx = [dftx tmpFtx];
        tmpFtx = ftx;
    end
end

% s = [sym('x1'); sym('x2'); sym('x3'); sym('x4')];
% x = sym('x4');
% syms(s); 
% f = x1+x2*x3-cos(x4);
% mf = matlabFunction(f);
% diff(mf, x, 1)

