function orientation = calcOrientation(ellipse,noiseYxmin)

theta = radtodeg(ellipse(5));
t = linspace(-4,4);
NoiseLevel = 0;
x = ellipse(3) * cos(t);
y = ellipse(4) * sin(t);
nx = x*cos(ellipse(5))-y*sin(ellipse(5)) + ellipse(1) + randn(size(t))*NoiseLevel;
ny = x*sin(ellipse(5))+y*cos(ellipse(5)) + ellipse(2) + randn(size(t))*NoiseLevel;
xminpos = nx == min(nx);
yxmin = ny(xminpos);
rx = max(nx)-ellipse(1);
ry = max(ny)-ellipse(2);
if (yxmin <= ellipse(2)) || ((yxmin <= ellipse(2)+1) && (rx > ry) && ((theta <= noiseYxmin && theta >= 0) || (theta <= (noiseYxmin-90) && theta >= -90)))
    if theta >= 0 && theta <= 90
        orientation = theta;
    elseif theta+90 >= 0 && theta+90 <= 90
        orientation = theta+90;
    elseif theta+180 >= 0 && theta+180 <= 90
        orientation = theta+180;
    end
else
    if theta >= 90 && theta <= 180
        orientation = theta;
    elseif theta+90 >= 90 && theta+90 <= 180
        orientation = theta+90;
    elseif theta+180 >= 90 && theta+180 <= 180
        orientation = theta+180;
    end
end
end


