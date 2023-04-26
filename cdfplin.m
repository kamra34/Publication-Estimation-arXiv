function [h,vecper,perc]=cdfplin(vec,sign,perc,swPlot);
%function [h,vecper,perc]=cdfplin(vec,sign,perc,swPlot);
% Plots the Cumulative Distribution Function (C.D.F.) of a vector or 
% matrix. If the paramater 'vec' is a matrix, the function will plot
% the C.D.F. for each column.
%
% vec    =  vector or matrix to plot CDF for
% sign   =  linestyle or label (optional)
% perc   =  percentiles to plot (optional, default [0:0.5:100])
% swPlot =  enable (1) / disable (0) plotting
%
% By Anders Furusk�r 980225
% last modified 121102, Stefan Eriksson L�wenmark
 
if nargin < 2, sign='-'; end;
if nargin < 3, perc=[0:0.5:100]; end;
if nargin < 4, swPlot=1;end;
if size(vec,1)==1
  vec = vec(:);
end

vecper=cdfperc3(vec,perc);
if swPlot
  h=plot(vecper,perc,sign);
  ylabel('C.D.F. [%]')
  grid on
else
  h=nan;
end


function res = cdfperc3(a, proc)

if size(a,1) < 1
  res = [];
else
   b = csort(a);
  
  res = b(max(1, min(size(a,1), ceil(proc/100*size(a,1)))),:);
end

% $Id: cdfplin.m,v 1.1 1998/04/27 10:40:38 erafura Exp $
% Copyright (c) ERICSSON RADIO SYSTEMS AB
