% Ultrasonic Haptic Feedback Test Platform
% Created by : Mattis Trost
% Date : 12/05/2023

function [total_pressure,x2,y2,x,y,time_delay] = ultrasonic_phased_array(fpd,fpa,N,pch,a,direc,apod)
% This function takes user set parameters : focal point distance (fpd),
% focal point angle (fpa), number of elements in the array (N), array pitch
% (pch) and element width (a) to simulate the total pressure at the
% desired focal point in a 2D (x2,y2) and 3D grid (x,y,total_pressure) and
% the associated transducer delays.
% The user is also able to add a directivity and apodization function.

% Matching the element width to array pitch for realistic purposes
if pch < 10
    a = pch;
end
f = 40; % Wave frequency (kHz)
c = 343; % Speed of sound in air (m/s)
dc = (N-1)/2; % Distance between the furthest element and the center of the array
m = 1:1:N;
de = ((m-1)-dc)*pch; % Distance between the nth element and the center of the array

amp = 1; % Wave amplitude
w = 2*pi*f; % Angular frequency (rad/s)
k = 2*pi*f/c; % Wave number (m-1)

% Creating the time delays for every element of the phased array using the
% phase matching method
time_delay = phase_matching(fpd,fpa,pch,dc,de,N,c);
delay = exp(1i.*2.*pi.*f.*time_delay);

%
% Pressure simulation for a single transducer
%

x1 = -0.3:0.001:0.3;
y1 = 0:0.001:0.3;
[X1,Y1] = meshgrid(x1,y1); % Creating a grid to plot the sound wave
t = linspace(0,5,100);
amp1 = 1;

% Computing the pressure of a single sound source
for j = 1:length(t)
    r1=sqrt(X1.^2+Y1.^2);
    pressure = (amp1./r1).*exp(1i.*(1000.*k.*r1-w.*t(j)));
end

% 2-D Plot for a realistic ultrasonic wave
figure(2)
pcolor(X1,Y1,real(pressure)); title("Ultrasonic wave"); shading flat;
legend1 = colorbar;
legend1.Label.String = 'Pressure';
caxis([-5 5]);

%
% Pressure simulation for a 1-D phased array
%

% Creating a grid for the 2D and 3D pressure plots
x2= linspace(-300,300, 300);
y2= linspace(1, 300, 200);
[x,y]=meshgrid(x2,y2);

% Apodization function using the Hanning window
if apod == "Yes"
    hanning = (sin((pi.*m)/(N))).^2;
else
    hanning = ones(1,N);
end

% Computing the total pressure from every element of the phased array
total_pressure = 0;
for n=1:N
    [pressure_array] = pressure_2D(amp,k,de(n),x,y,a,direc);
    total_pressure = total_pressure + hanning(n).*delay(n).*pressure_array;
end