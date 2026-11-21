%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Drew A. Hall
% DrewHall@ucsd.edu
% 28-Feb-2012
% 
% Lookup functions from Gm/Id charts
%
% Notes:
%   - See EE164 course notes
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y = lookup(L, Lvector, X, Xmatrix, Ymatrix) 
    numL = length(unique(Lvector));
    Pts = length(Lvector)/numL;
    Lengths = Lvector(1:Pts:end);

    idx1 = max(find(Lengths <= L, 1));
    idx2 = min(find(Lengths >= L, 1));
        
    Y1 = interp1(Xmatrix((idx1-1)*Pts+1:idx1*Pts), Ymatrix((idx1-1)*Pts+1:idx1*Pts), X);
    Y2 = interp1(Xmatrix((idx2-1)*Pts+1:idx2*Pts), Ymatrix((idx2-1)*Pts+1:idx2*Pts), X);
    
    if Y1 == Y2
       Y = Y1;
    else        
       Y = interp1( [Lengths(idx1) Lengths(idx2)], [Y1 Y2], L);
    end
    
return