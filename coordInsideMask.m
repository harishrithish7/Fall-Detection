function [xcoord,ycoord] = coordInsideMask(fgMask,box)

y1 = box(2);y2 = box(2)+box(4);x1 = box(1);x2 = box(1)+box(3);
if box(2)+box(4)> size(fgMask,1)
    y2 = size(fgMask,1);
end
if box(1)+box(3)> size(fgMask,2)
    x2 = size(fgMask,2);
end


vec = find(fgMask==1);
rowsz = size(fgMask,1);
rows = mod(vec-1,rowsz)+1;
cols = double(((vec-1)/rowsz)+1);

boxpos = find(cols < x2 & cols > x1 & rows < y2 & rows > y1);
xcoord = cols(boxpos);
ycoord = rows(boxpos);

