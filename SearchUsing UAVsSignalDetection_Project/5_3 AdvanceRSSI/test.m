% % Copyright (c) 2009, Arslan Shahid
% % All rights reserved.
% % 
% % Redistribution and use in source and binary forms, with or without 
% % modification, are permitted provided that the following conditions are 
% % met:
% % 
% %     * Redistributions of source code must retain the above copyright 
% %       notice, this list of conditions and the following disclaimer.
% %     * Redistributions in binary form must reproduce the above copyright 
% %       notice, this list of conditions and the following disclaimer in 
% %       the documentation and/or other materials provided with the distribution
% %       
% % THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% % AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% % IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% % ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% % LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% % CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% % SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% % INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% % CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% % ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% % POSSIBILITY OF SUCH DAMAGE.
% %************************************************************************** 
%  
% % Name:                RadPattern3D
% % Author:              Arslan Shahid
% % Date:                March 15, 2010
% % Description:         3-D Radiation Pattern of Dipole Antenna
% % Reference            Constantine A.Balanis, Antenna Theory Analysis And
% % Design , 3rd Edition, page 173, eq. 4-64
% %**************************************************************************
% %Usage:
% %This program plots 3-D radiation Pattern of a Dipole Antenna
% %All the parameters are entered in the M-File
% clear all
% %Defining variables in spherical coordinates
% theta=[0:0.12:2*pi];%theta vector
% phi=[0:0.12:2*pi];%phi vector
% l_lamda1=1/100;% length of antenna in terms of wavelengths
% I0=1;% max current in antenna structure
% n=120*pi;%eta
%  
% % evaluating radiation intensity(U)
% U1=( n*( I0^2 )*( ( cos(l_lamda1*cos(theta-(pi/2))/2) - cos(l_lamda1/2) )./ sin(theta-(pi/2)) ).^2 )/(8*(pi)^2);
% %converting to dB scale
% U1_1=10*log10(U1);
% %normalizing in order to make U vector positive
% min1=min(U1_1);
% U=U1_1-min1;
%  
% % expanding theta to span entire space
% U(1,1)=0;
% for n=1:length(phi)
%     theta(n,:)=theta(1,:);
% end
% % expanding phi to span entire space
% phi=phi';
% for m=1:length(phi)
%     phi(:,m)=phi(:,1);
% end
%  
% % expanding U to span entire space
% for k=1:length(U)
%     U(k,:)=U(1,:);
% end
%  
% % converting to spherical coordinates 
% [x,y,z]=sph2cart(phi,theta,U);
% %plotting routine
% surf(x,y,z)
% colormap(copper)
% title('Radition Pattern for Dipole Antenna (length=1.5lamda)')
% xlabel('x-axis--->')
% ylabel('y-axis--->')
% zlabel('z-axis--->')

% function render()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a=2;b=1;c=1;%
x=linspace(-a,a,401);
y=linspace(-b,b,401);
[xx,yy]=meshgrid(x,y);
m=1-(xx/a).^2-(yy/b).^2;
%m=(m>0).*m;
m(find(m<0))=0;
zz=c*sqrt(m);
figure
mesh(xx,yy,zz,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
alpha(0.5)
% mesh(xx,yy,zz);
hold on;
zz=(-1)*c*sqrt(m);
mesh(xx,yy,zz,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
alpha(0.5)
axis equal;
% end