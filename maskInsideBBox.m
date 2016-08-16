function fgMask = maskInsideBBox(fgMask,box)
fgMask(:,1:box(1)-1) = 0;
fgMask(:,box(1)+box(3)+1:end) = 0;
fgMask(1:box(2)-1,:) = 0;
fgMask(box(2)+box(4)+1:end,:) = 0;
end