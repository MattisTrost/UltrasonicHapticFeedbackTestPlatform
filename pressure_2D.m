function [pressure] = pressure_2D(amp,k,e,x,y,a,direc)
% This function computes the pressure for every point in an (x,y) grid
% using the wave amplitude, wave number, element width and optional
% directivity function

% Computing the distance between the nth element of the array and every
% grid point of the (x,y) grid
rb =  sqrt((x-e).^2 + y.^2);
% Computing the pressure with and without the directivity function
if direc == "Yes"
    angle = atan((x-e)./y);
    directivity = (sin(k.*a.*sin(angle)./2))./(k.*a.*sin(angle)./2);
    pressure = directivity.*amp.*exp(1i.*k.*rb)./sqrt(rb);
else
    pressure = amp.*exp(1i.*k.*rb)./sqrt(rb);
end
