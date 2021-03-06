function px = histcounts2(x,y,ex1,ex2)
%% Alternative for MATLAB histcounts2 function.
% This is the Octave alternative for the MATLAB histcounts2 function.
% Choosing bins is slightly different because the MATLAB method is very
% convoluted, and this will in the end lead to slightly different values
% for entropy and mutual information, but the difference should not be
% significant.
%
% This function should only be used in Octave - when working in MATLAB,
% please use the MATLAB version of the toolbox, which does not include this
% file.

px = hist3([x(:) y(:)],"edges",{ex1,ex2});

px(:,end-1) += px(:,end);
%px(:,end-1)=px(:,end-1)+px(:,end);
px = px(:,1:end-1);

px(end-1,:) += px(end,:);
%px(end-1,:) = px(end-1,:)+px(end,:);
px = px(1:end-1,:);