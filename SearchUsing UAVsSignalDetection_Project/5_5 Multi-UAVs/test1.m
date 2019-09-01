%Create a dipole antenna of length, 0.15 m, and width, 0.015 m.
d = dipole('Length',0.03,'Width',0.005, 'Tilt',0,'TiltAxis',[1 0 0]);

%Create a reflector using the dipole antenna as an exciter and the dielectric, teflon as the substrate.
%使用偶极子天线作为激励器和介质，创建反射器
t = dielectric('Teflon')

rf = reflector('Exciter',d,'Spacing',7.5e-3,'Substrate',t);

% Set the groundplane length of the reflector to inf. View the structure.
rf.GroundPlaneLength = inf;
show(rf)

pattern(rf,868e6)