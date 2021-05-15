clear all; close all; clc;

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
%Water level should be containable in the tank
if hWater>2*rTank
    error("Water volume is greater than tank volume...");
end 

%Hole surface should be smaller than the widest surface of the sphere
if rHole >= rTank
    error("Hole radius is bigger than tank radius...");
end

%equation representing dh/dt
dhdt = @(t,h) -1*(rHole^2*sqrt(2*g*h))/(2*h*rTank-h^2);
y1 = ode23(dhdt, time, hWater);
y2=Euler(dhdt,t0,tFinal,hWater,step);

plot(y1.x, y1.y,' ro-- ',time,y2,' k ','linewidth',1);
title("ODE23 vs Euler Method");
xlabel('Time t in seconds');
ylabel('H(t) in m');
legend('ODE23, Euler');
ylim([0 inf]);

counter=1;
fprintf("\nUsing Euler's Method:\n");
while counter<=dim+1 && y2(counter)>0
    fprintf("at %f ",time(counter));
    fprintf("seconds we have %f ",y2(counter));
    fprintf("m of water remaining in the tank\n");
    counter=counter+1;
end

n=length(time);
integrateH=@(h) (h^2-2*rTank*h)/(sqrt(h));
integral=GaussianQ2(integrateH,hWater,0.001);
timeToEmpty=integral/(rHole^2*sqrt(2*g));
fprintf("Time needed to empty the tank is: %f seconds\n",timeToEmpty);