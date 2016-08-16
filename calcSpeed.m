function [mhimage,speed] = calcSpeed(mhimage,fgBBox,tmhi)

%updating motion history image(mhimg)
mhimage = max(zeros(size(mhimage)),mhimage-1);
mhimage(fgBBox==true) = tmhi;

%co-effecient of mhi for speed
speed = sum(sum(mhimage))/(sum(sum(fgBBox))*tmhi);

end