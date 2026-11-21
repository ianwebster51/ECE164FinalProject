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
function IdW = lookup_IdW(tech, type, L, gmId)
    k = find(ismember(tech.DeviceNames, type));
    IdW = lookup(L, tech.L(k,:), gmId, tech.gmId(k,:), tech.IdW(k,:));
return
