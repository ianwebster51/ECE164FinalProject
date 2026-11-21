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
function fT = lookup_ft(tech, type, L, gmId)
    k = find(ismember(tech.DeviceNames, type));
    fT = lookup(L, tech.L(k,:), gmId, tech.gmId(k,:), tech.fT(k,:));
return
