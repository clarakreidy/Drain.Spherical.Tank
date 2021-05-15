pkg load symbolic;
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
[t, y] = ode23(dhdt, time, hWater);

index = find(real(y) >= 0)(end)
plot(t(1:index), y(1:index))
