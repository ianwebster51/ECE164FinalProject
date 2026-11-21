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
function gmId = lookup_gmid(tech, type, L, fT)
    k = find(ismember(tech.DeviceNames, type));
    gmId = lookup(L, tech.L(k,:), fT, tech.fT(k,:), tech.gmId(k,:));
return
