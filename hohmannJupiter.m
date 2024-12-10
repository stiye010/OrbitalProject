%%Hohmann to Jupiter
%Start day 06-Oct-2026
function [rsc,vsc,finalDate] = hohmannJupiter(initialDate)
%% Initialize
mu=1.327e11; %Gravitational parameter for Sun
maxDays=900; % Number of days to follow the spaceraft = t12
% for Earth-Mars transfer
rsc=zeros(maxDays,3); % Position vector array for spacecraft
vsc=zeros(maxDays,3); % Velocity vector array for spacecraft
finalDate=initialDate+days(maxDays); %date when sc stops appearing in simulation
launchDay=15; % # of days to launch from Start Date
tinit=datetime(initialDate); % initial time as datetime variable type
%% Stay on Earth until day of launch
for dayCount=1:launchDay
t=tinit+days(dayCount-1); % index dayCount=1 corresponds to initial time.
[y,m,d]=ymd(t); % year month day format of current time
% Use planet_elements_and_sv_coplanar to find current position and
% velocity
[~, r, v, ~] =planet_elements_and_sv_coplanar ...
(1.327e11, 3, y, m, d, 0, 0, 0);
% Update the position and velocity vectors
rsc(dayCount,:)=[r(1),r(2),0];
vsc(dayCount,:)=[v(1), v(2),0];
end
%% Launch Maneuver
t=tinit+days(launchDay);
[y,m,d]=ymd(t);
[~, R, V, ~] =planet_elements_and_sv_coplanar ...
(1.327e11, 3, y, m, d, 0, 0, 0); %Earth on launch day

Vsc = V + 9*V/norm(V);
% Calculate the orbital elements for spacecraft
[h,a,e,w,E0]=scElements(R,Vsc);
% propagate the new orbit for spacecraft
[rsc,vsc]=propagate(h,a,e,w,E0,launchDay+1,maxDays,rsc,vsc);