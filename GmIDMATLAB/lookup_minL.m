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
function L = lookup_minL(tech, type, gmId, gmgds)
    k = find(ismember(tech.DeviceNames, type));
    Lvector = unique(tech.L(k,:));

    % Loop over the lengths (smallest to largest) until we find one that 
    % has enough gain
    for k = 1:length(Lvector)
        L = Lvector(k);
        retVal = lookup_gmro(tech, type, L, gmId);
        
        if(retVal > gmgds)
            return
        end
    end
 
    % Couldn't find an L to meet the requirement
    L = NaN;
return