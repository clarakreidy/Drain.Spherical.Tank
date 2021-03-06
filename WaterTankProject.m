clc

fprintf("This program shows us the behavior of the water in a spherical water tank in the event of a leakage\n");

%specify all the inputs
rTank=input("Give the radius of the tank in meters\n");
hWater=input("Give the initial water level in the tank in meters\n");
tFinal=input("For how many seconds will the the tank be leaking water?\n");
rHole=input("Give the radius of the hole at the bottom of the tank in meters\n");

g=9.81;
t0=0;
step=1;

time=0:step:tFinal;
dim=(tFinal-t0)/step;

flag1=true;
flag2=true;
flag3=true;

%Water level should be containable in the tank
if hWater>2*rTank
    error("Water volume is greater than tank volume...");
end 

%Hole surface should be smaller than the widest surface of the sphere
if rHole >= rTank
    error("Hole radius is bigger than tank radius...");
end

initialVolume=(pi*hWater^2*(3*rTank-hWater))/3;
fprintf("We initially have %f m^3 of water\n",initialVolume);

%equation representing dh/dt
f=@(t,h) -1*(rHole^2*sqrt(2*g*h))/(2*h*rTank-h^2);

test=Euler(f,t0,tFinal,hWater,step);
plot(test);

for i=1:dim+1
    solution1=Euler(f,t0,tFinal,hWater,step);
    if solution1(i)<0
        break
    end
end

for i=1:dim+1
    solution2=RKM(f,t0,tFinal,hWater,step);
    if solution2(i)<0
        break
    end
end

for i=1:dim+1
    [solution3t,solution3h]=euler_backward(f,t0,hWater,tFinal,dim);
    if solution3h(i)<0
        break
    end
end

solution4=ode23(f, time, hWater);

counter=1;
plot(solution4.x,solution4.y,time,solution1,' ro-- ',time,solution2,' g*-. ', time, solution3h,' k ', 'linewidth', 2);
%plot(solution4.x,solution4.y);
title("Euler vs RKM vs Euler Backwards");
xlabel('Time t in seconds');
ylabel('H(t)');
legend('Euler, RKM, Euler Backward');

fprintf("\nUsing Euler's Method:\n");
while counter<=dim+1 && solution1(counter)>0
    fprintf("at %f ",time(counter));
    fprintf("seconds we have %f ",solution1(counter));
    fprintf("m of water remaining in the tank\n");
    counter=counter+1;
end
counter=1;

fprintf("\nUsing RKM's method:\n");
while counter<=dim+1 && solution2(counter)>0
    fprintf("at %f ",time(counter));
    fprintf("seconds we have %f ",solution2(counter));
    fprintf("m of water remaining in the tank\n");
    counter=counter+1;
end

counter=1;
fprintf("\nUsing Euler Backward's method:\n");
while counter<=dim+1 && solution3h(counter)>0
    fprintf("at %f ",solution3t(counter));
    fprintf("seconds we have %f ",solution3h(counter));
    fprintf("m of water remaining in the tank\n");
    counter=counter+1;
end

n=length(time);
integrateH=@(h) (h^2-2*rTank*h)/(sqrt(h));
integral=GaussianQ2(integrateH,hWater,0.001);
timeToEmpty=integral/(rHole^2*sqrt(2*g));
fprintf("Time needed to empty the tank is: %f seconds\n",timeToEmpty);