function [ DFP ] = BRAIN_findDFP( FP, X )
    DFP = zeros(0);
    n = size(FP, 1);
    
    FP
    symArray = sym('xa%d', [1 n]);
    syms(symArray);
    DRXA = jacobian(FP, symArray)
    
    symArray = sym('xb%d', [1 n]);
    syms(symArray);
    DRXB = jacobian(FP, symArray)
end
