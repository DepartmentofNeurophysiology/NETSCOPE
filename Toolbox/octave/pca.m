function [coeff,score] = pca(x)
%% Octave-compatible alternative for MATLAB pca function.
% This function simply wraps the Octave PCA function princomp into another
% function so that the toolbox works in Octave and MATLAB.

[coeff,score] = princomp(x);