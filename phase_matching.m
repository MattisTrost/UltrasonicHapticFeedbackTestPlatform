function time_delay = phase_matching(fpd,fpa,pch,dc,de,N,c)
% This function implements the phase matching method to compute the time
% delay for every transducer of an array of pitch pch, with number of
% elements N for a focal point distance fpd and angle fpa

m = 1:1:N;

% Calculating the focal point coordinates
fxm = fpd*sind(fpa);
fy = fpd*cosd(fpa);
% Accounting for positive and negative angles
if fpa > 0
    fx1 = fxm;
else
    fx1 = fpd*sind(abs(fpa));
end
r1 = sqrt(fy^2+(fx1+dc*pch)^2);
% Accounting for elements on the same side and opposite side of the focal
% point
if de(m) <= 0
    rm = sqrt(fy^2+(fxm+abs(de(m))).^2);
else
    if de(m) <= fxm
        rm = sqrt(fy^2+(fxm-de(m)).^2);
    else
        rm = sqrt(fy^2+(de(m)-fxm).^2);
    end
end
% Computing the delay from the furthest element and nth element from the 
% focal point
time_delay = (1/c).*(r1-rm);