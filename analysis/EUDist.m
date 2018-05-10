% EUclidian Distance:
% First option - between a curve and a point 
% Second option - between two matrices of same size.
function [d] = EUDist(m1,m2)
d = zeros(length(m1),1);
if size(m2)==size(m1)
    d = sqrt((m1(:,1)-m2(:,1)).^2 + (m1(:,2)-m2(:,2)).^2);
else if numel(m2)==2
        d = sqrt((m1(:,1)-m2(1)).^2 + (m1(:,2)-m2(2)).^2);
    else
        warning('bad size of m2 in EUDist - it is neither a point nor a same sized matrix as m1');
    end
end

if isempty(d)
    d=0;
end
end
