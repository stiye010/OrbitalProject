%% Europa-Clipper
% Launch, Flyby Mars, Flyby Earth
function [rsc,vsc,finalDate] = EuropaClipper(initialDate)
%function [rsc,vsc,finalDate] = spacecraft(initialDate)
% Simulates a Hohmann transfer to Mars,flybay of Mars, flyby of Earth
% Set initial date in app to 18-Oct-2026
%According to the theorertical calculations, launchDay will be 12.
%% Initialize
mu=1.327e11; %Gravitational parameter for Sun
maxDays=4000; % Number of days to follow the spaceraft = t12
% for Earth-Mars transfer
fbday1 = 157;
fbday2 = 1097;
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

Vsc = V + 6*V/norm(V);
% Calculate the orbital elements for spacecraft
[h,a,e,w,E0]=scElements(R,Vsc);
% propagate the new orbit for spacecraft
[rsc,vsc]=propagate(h,a,e,w,E0,launchDay+1,fbday1,rsc,vsc);

% Load flyby data from app
load MarsFBforEC1.mat
% Calculate the velocity after the flyby
[Vsc1,DeltaMin]=flyby(Vp1,Vsc1,5.8e+03,42828,3396,1);
DeltaMin %Can output Deltamin to keep the aiming radius above this value
%Calculate the orbital elements for the spacecraft after the flyby
[h,a,e,w,E0]=scElements(R1,Vsc1);
%propagate orbit to end
[rsc,vsc]=propagate(h,a,e,w,E0,fbday1+1,fbday2,rsc,vsc);

load EarthFBforEC1.mat
% Calculate the velocity after the flyby
[Vsc2,DeltaMin]=flyby(Vp2,Vsc2,13500,398600,6378,0);
DeltaMin %Can output Deltamin to keep the aiming radius above this value
%Calculate the orbital elements for the spacecraft after the flyby
[h,a,e,w,E0]=scElements(R2,Vsc2);
%propagate orbit to end
[rsc,vsc]=propagate(h,a,e,w,E0,fbday2+1,maxDays,rsc,vsc);


