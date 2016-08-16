function drawEllipse(Cx,Cy,Rx,Ry,Rotation)

% Create an ellipse
t = linspace(-4,4);

NoiseLevel = 0;
x = Rx * cos(t);
y = Ry * sin(t);
nx = x*cos(Rotation)-y*sin(Rotation) + Cx + randn(size(t))*NoiseLevel;
ny = x*sin(Rotation)+y*cos(Rotation) + Cy + randn(size(t))*NoiseLevel;

% Show the window
hold on;
plot(nx,ny,'r-');
plot(Cx,Cy,'go','MarkerSize',2,'LineWidth',2);
hold off;
return
end