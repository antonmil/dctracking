function [E, D, S, L, labeling] = ...
    doAlphaExpansion(Dcost, Scost, Lcost, Neighborhood)

% minimize E(f,T) wrt. f by alpha expansion
% Note: This only works for submodular energies
% 
% The gco code is available at
% http://vision.csd.uwo.ca/code/


% set up GCO structure
[nLabels, nPoints]=size(Dcost);

h=setupGCO(nPoints,nLabels,Dcost,Lcost,Scost,Neighborhood);

GCO_SetLabelOrder(h,1:nLabels);
GCO_Expansion(h);
labeling=GCO_GetLabeling(h)';
[E, D, S, L] = GCO_ComputeEnergy(h);

% clean up
GCO_Delete(h);
end