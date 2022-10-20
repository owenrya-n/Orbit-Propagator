filename = 'tb.csv'
M = csvread(filename);
figure()
plot3Dbody('earthImage.Jpg',6371,0)
hold on
x=M(1,:);
y=M(2,:);
z=M(3,:);
plot3(x(1:3:end), y(1:3:end), z(1:3:end))
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
