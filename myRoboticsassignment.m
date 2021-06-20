clc;
clear;

obstacle1 = [1 1;1.5 1;1.5 1.5;1,1.5];
obstacle2 = [-1.5 -1;-1 -2;-1.5 -2];

th1 = 5;
th2 = 40;

x1 = 0;
y1 = 0;


W1 = 1;%half width of link 1
L1 = 0.1;%half thickness of link 1

W2 = 0.5;%half width of link 2
L2 = 0.1;%half thickness of link 2


link1_geometry = [-W1, -L1; W1, -L1; W1, L1; -W1, L1];
link2_geometry = [-W2, -L2; W2, -L2; W2, L2; -W2, L2];

axis([-5 5 -5 5]);
daspect([1 1 1]);
grid on;

hold on;
grid on;
fill(obstacle1(:,1), obstacle1(:,2), 'r');
fill(obstacle2(:,1), obstacle2(:,2), 'r');
l1handle = fill(link1_geometry(:,1), link1_geometry(:,2), 'b');
l2handle = fill(link2_geometry(:,1), link2_geometry(:,2), 'g');
ob1 = polyshape(obstacle1(:,1),obstacle1(:,2));
ob2 = polyshape(obstacle2(:,1),obstacle2(:,2));
hold off;



for theta1 = th1:5:360+th1
    for theta2 = th2:5:360+th2
         %rotate link about origin
        rotated_l1_geometry = link1_geometry*[cosd(theta1) sind(theta1);...
            -sind(theta1), cosd(theta1)];
        rotated_l2_geometry = link2_geometry*[cosd(theta2+theta1) sind(theta2+theta1);...
            -sind(theta2+theta1), cosd(theta2+theta1)];
        X1=x1+W1*cosd(theta1);
        Y1=y1+W1*sind(theta1);
        set(l1handle, 'xdata', X1+rotated_l1_geometry(:,1),...
            'ydata', Y1+rotated_l1_geometry(:,2));
        l1 = polyshape(X1+rotated_l1_geometry(:,1),Y1+rotated_l1_geometry(:,2));       %for Overlap chaecking later on
        

        x2 = x1+2*W1*cosd(theta1);
        y2 = y1+2*W1*sind(theta1);

        X2=x2+W2*cosd(theta1+theta2);
        Y2=y2+W2*sind(theta1+theta2);

        set(l2handle, 'xdata', X2+rotated_l2_geometry(:,1),...
            'ydata', Y2+rotated_l2_geometry(:,2)); 
        l2 = polyshape(X2+rotated_l2_geometry(:,1), Y2+rotated_l2_geometry(:,2));     %for Overlap chaecking later on
        
        %WorkSpace 
        figure(2)
        title('Position of End Effector')
        xlabel('x axis')
        ylabel('y axis')
        an = animatedline('Marker','.');
        addpoints(an,X2 + 0.5*cosd(theta1+theta2),Y2 + 0.5*sind(theta1+theta2));
        drawnow limitrate
        grid on
        axis([-4 4 -4 4 ])
        
        %Checking obstacle intersection
        pixel = 0;
        if overlaps(l1,ob1) || overlaps(l2,ob1) || overlaps(l1,ob2) || overlaps(l2,ob2)
            pixel = 1;
        end
        pixel;
        
        %Configuration Space 
        figure(3)
        title('Configurational Space')
        xlabel('theta1')
        ylabel('theta2')
        x = theta1+1-th1;
        y = theta2+1-th2;
        hold on
        if pixel == 1
            plot(x,y,'r.')
        else
            plot(x,y,'b.')
        end
        axis([0 360 0 360])
        
        
        [theta1,theta2]
        drawnow  limitrate
     end
end
  
