function [b, aind] = csort(a)
% function [b, aind] = csort(a)    sort of matrix columnwise
% also in the case when the matrix is only one row.
% by Magnus Almgren 951130

if size(a,1) ~=1 
  [b, aind] = sort(a);
else
  b = a;
  aind = ones(size(a));
end

% $Id: csort.m,v 4.0 1997/04/14 06:58:41 eplpede Exp $
% Copyright (C) ERICSSON RADIO SYSTEMS AB 1996
