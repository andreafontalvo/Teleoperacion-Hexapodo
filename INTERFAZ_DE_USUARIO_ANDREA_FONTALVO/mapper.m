function last_coords = mapper(init_coords,init_angle,angle,movement,front,left,right)
init_angle = -init_angle * pi / 180;
angle = -angle * pi / 180;

angle_readj = angle - (init_angle - pi/2);
angle_readj_right = angle_readj + pi/2;
angle_readj_left = angle_readj - pi/2;

if movement == 1
    distance = -5;
elseif movement == 2
    distance = 5;
else
    distance =0;
end

last_coords = [init_coords(1)+distance*cos(angle_readj),...
    init_coords(2)+distance*sin(angle_readj)];

right_coords = [last_coords(1)+right*cos(angle_readj_right),...
    last_coords(2)+right*sin(angle_readj_right)];

left_coords = [last_coords(1)+left*cos(angle_readj_left),...
    last_coords(2)+left*sin(angle_readj_left)];

front_coords = [last_coords(1)-front*cos(angle_readj),...
    last_coords(2)-front*sin(angle_readj)];
%figure(1)
%xlim([-200 200]);ylim([-200 200]);
% plot(app.AxesMap,[init_coords(1) last_coords(1)],[init_coords(2) last_coords(2)],'b','Linewidth',2);
% hold on
plot(app.AxesMap,0.5,0.5,'r*')
% plot(right_coords(1),right_coords(2),'r*')
% hold on
% plot(left_coords(1),left_coords(2),'g*')
% hold on
% hold on
% plot(front_coords(1),front_coords(2),'k*')
% hold on

end