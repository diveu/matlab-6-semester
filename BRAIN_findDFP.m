function [ DFP ] = BRAIN_findDFP( FP, X )
    DFP = zeros(0);
    n = size(FP, 1);
    
    XAP = X(1, n+1:end);
    XAP = reshape(XAP, [n n]);
    XBP = X(end, n+1:end);
    XBP = reshape(XBP, [n n]);
    
    symArray = sym('xa%d', [1 n]);
    symArray = [symArray sym('xb%d', [1 n])];
    syms(symArray);
    
    symArray = num2cell(symArray);
    XP0 = num2cell([X(1, 1:n) X(end, 1:n)]);

    FP0 = subs(FP(:, 1), symArray, XP0);
    symArray = sym('xa%d', [1 n]);
    syms(symArray);
    DRXA = jacobian(FP, symArray)
    
    symArray = sym('xb%d', [1 n]);
    syms(symArray);
    DRXB = jacobian(FP, symArray)
  
    FP = DRXA*XAP+DRXB*XBP
    FP = FP^(-1)
    FP = -FP
    FP*FP0
end
