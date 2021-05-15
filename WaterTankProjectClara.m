%pkg load symbolic;
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

time=t0:step:tFinal;

%Water level should be containable in the tank
if hWater>2*rTank
    error("Water volume is greater than tank volume...");
end

%Hole radius should be smaller than tank radius
if rHole >= rTank
    error("Hole radius is bigger than tank radius...");
end

%equation representing dh/dt
dhdt = @(t,h) -1*(rHole^2*sqrt(2*g*h))/(2*h*rTank-h^2);

[t, y1] = ode23(dhdt, time, hWater);
y2= Euler(dhdt,t0,tFinal,hWater,step);

index1 = find(real(y1) >= 0)(end);
index2 = find(real(y2) >= 0)(end);

plot(t(1:index1), y1(1:index1), ' ro-- ', time(1:index2), y2(1:index2),' k ','linewidth', 1)

%plot(t, y1,' ro-- ', time, y2,' k ','linewidth',1);
title("ODE23 vs Euler Method");
xlabel('Time t in seconds');
ylabel('H(t) in m');
legend('ODE23, Euler');


n=length(time);
integrateH=@(h) (h^2-2*rTank*h)/(sqrt(h));
integral=GaussianQ2(integrateH,hWater,0.001);
timeToEmpty=integral/(rHole^2*sqrt(2*g));
fprintf("Time needed to empty the tank is: %f seconds\n",timeToEmpty);

