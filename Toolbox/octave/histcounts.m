function [px,ex] = histcounts(x,ex)
%% Alternative for MATLAB histcounts function.
% This is the Octave alternative for the MATLAB histcounts function.
% Choosing bins is slightly different because the MATLAB method is very
% convoluted, and this will in the end lead to slightly different values
% for entropy and mutual information, but the difference should not be
% significant.
%
% This function should only be used in Octave - when working in MATLAB,
% please use the MATLAB version of the toolbox, which does not include this
% file.

nbins = length(ex)-1;
px = histc(x,ex);
%px(nbins) += px(nbins+1);
px(nbins)=px(nbins)+px(nbins+1);
px = px(1:nbins);