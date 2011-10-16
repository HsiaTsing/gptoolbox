function [ A ] = internalangles( V, F)
% INTERNALANGLES
%
% A = internalangles(V,F)
%
% Compute internal angles per face (in degrees)
%
% Inputs:
%  V  #V x 3 matrix of vertex coordinates
%  F  #F x 3  matrix of indices of triangle corners
% Output:
%  A  #F x 3 list of triples of triangle angles
%
i1 = F(:,1); i2 = F(:,2); i3 = F(:,3);

s12 = normrow(V(i2,:) - V(i1,:));
s13 = normrow(V(i3,:) - V(i1,:));
s23 = normrow(V(i3,:) - V(i2,:));

a12 = acos((s13.^2 + s23.^2 - s12.^2)./(2.*s13.*s23));
a13 = acos((s12.^2 + s23.^2 - s13.^2)./(2.*s12.*s23));
a23 = acos((s12.^2 + s13.^2 - s23.^2)./(2.*s12.*s13));

A = [a23 a13 a12];

end
