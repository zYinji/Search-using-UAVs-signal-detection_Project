% ----------------------------------------------------------------------------------------------------------
%  File: DroneSet.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
classdef DroneSet < handle
    properties (Constant)
        body = [6 6 0.0];
        
        % time interval for simulation (seconds)
        time_interval = 1;
        
        % size of floating window that follows drone
        axis_size = 20;
        
        % fly speed: 18m/s
        speed = 18;
        
        % colours of each component of drone model
        colours = [[.8 .3 .1];[.2 .2 .5];[.8 .9 .3];[.9 .6 .8];[.9 .2 .4]];
        
        R = eye(3);
        
        drone_follow = false;
        
        S = 220;
    end
    properties
        % axis to draw on
        axis
        
        % current time
        time
        
        % current position
        pos
       
        % 1S, 2S, .........
        period
        
        round
        
        % per round distance
        roundDistance
        
        height
        
        % having received signal or not(0,1)
        detect
        
        % signal position
        signalPos
        
        % signal 2D radius
        radius

    end
    methods
        
        %%%%%%%%%%%%%%%%%%%
        %Initlization     %
        %%%%%%%%%%%%%%%%%%%
        function obj = DroneSet(axis,basePos)
            obj.axis = axis;
            
            obj.height = 100;
            
            % initial position
            obj.pos = [basePos(1);basePos(2);obj.height];
            
            % initial time
            obj.time = 0;
            
            obj.period = 1;
            
            obj.round = 1;
            
            obj.roundDistance = 0;
            
            obj.detect = 1;
            
            obj.signalPos = [200 200 0];% 先放这
        end
        
        function draw(obj)
            cL = obj.axis_size;
            
            %set to false if you want to see world view
            if(obj.drone_follow)
                axis([obj.pos(1)-cL obj.pos(1)+cL obj.pos(2)-cL obj.pos(2)+cL obj.pos(3)-cL obj.pos(3)+cL]);
            end
            
            %create middle sphere
            [X Y Z] = sphere(8);
            %[X Y Z] = (obj.body(1)/5.).*[X Y Z];
            X = (obj.body(1)/5.).*X + obj.pos(1);
            Y = (obj.body(1)/5.).*Y + obj.pos(2);
            Z = (obj.body(1)/5.).*Z + obj.pos(3);
            s = surf(X,Y,Z);
                        
            set(s,'edgecolor','none','facecolor',obj.colours(1,:));
            
            %create side spheres
            %front, right, back, left
            hOff = obj.body(3)/2;
            Lx = obj.body(1)/2;
            Ly = obj.body(2)/2;
            rotorsPosBody = [...
                0    Ly    0    -Ly;
                Lx    0    -Lx   0;
                hOff hOff hOff hOff];
            rotorsPosInertial = zeros(3,4);
            for i = 1:4
                rotorPosBody = rotorsPosBody(:,i);
                rotorsPosInertial(:,i) = bodyToInertial(obj,rotorPosBody);
                [X Y Z] = sphere(8);
                X = (obj.body(1)/8.).*X + obj.pos(1) + rotorsPosInertial(1,i);
                Y = (obj.body(1)/8.).*Y + obj.pos(2) + rotorsPosInertial(2,i);
                Z = (obj.body(1)/8.).*Z + obj.pos(3) + rotorsPosInertial(3,i);
                s = surf(X,Y,Z);
                set(s,'edgecolor','none','facecolor',obj.colours(i+1,:));
            end
            titlename = ['UAV Search:',' Time:',num2str(obj.time,'%.2f'),'s, Position:',...
                 '(',num2str(obj.pos(1)),',',num2str(obj.pos(2)),',',num2str(obj.pos(3)),')'];
            title(titlename);
        end
        
        function vectorInertial = bodyToInertial(obj, vectorBody)
            vectorInertial = obj.R*vectorBody;
        end
        
        %%%%%%%%%%%%%%%%%%%画正方形%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation(obj) 
            if (obj.roundDistance + obj.speed * obj.time_interval > (2*obj.period-1+fix(obj.round/3)) * obj.S)
                obj.roundDistance = 0; % initialise round distance to zero
                if obj.round == 4
                    obj.round = 1;
                    obj.period = obj.period + 1;
                else
                    obj.round = obj.round + 1;
                end
            end
            obj.roundDistance = obj.roundDistance + obj.speed * obj.time_interval;
            if (obj.round == 1)
                obj.pos(1) = obj.pos(1) - obj.speed * obj.time_interval;
                obj.pos(2) = obj.pos(2);
                obj.pos(3) = obj.height;
            end
            
            if (obj.round == 2)
                obj.pos(1) = obj.pos(1);
                obj.pos(2) = obj.pos(2) + obj.speed * obj.time_interval;
                obj.pos(3) = obj.height;
            end
            
            if (obj.round == 3)
                obj.pos(1) = obj.pos(1) + obj.speed * obj.time_interval;
                obj.pos(2) = obj.pos(2);
                obj.pos(3) = obj.height;
            end
            
            if (obj.round == 4)
                obj.pos(1) = obj.pos(1);
                obj.pos(2) = obj.pos(2) - obj.speed * obj.time_interval;
                obj.pos(3) = obj.height;
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%画正方形%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_approach(obj) 
            obj.radius = norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)]);
            obj.radius = obj.radius - 1;
            [THETA,~] = cart2pol(obj.signalPos(1)-obj.pos(1),obj.signalPos(2)-obj.pos(2));
%             THETA = THETA;
            % speed * time_interval = arclength
            theta = obj.speed * obj.time_interval/(2*pi*obj.radius)*2*pi; 
            obj.pos(1) = obj.signalPos(1) + obj.radius*cos(THETA+theta);
            obj.pos(2) = obj.signalPos(2) + obj.radius*sin(THETA+theta);
        end
        
        %%%%%%%%%%%%%%%%%%%检测是否接受到了信号%%%%%%%%%%%%%%%%%%%%
        function obj = detection(obj)
            
        end
        
        
        %%%%%%%%%%%%%%%%%%Final Execution Function%%%%%%%%%%%%%%%%%%%
        function update(obj)
            %update simulation time
            obj.time = obj.time + obj.time_interval;
            if obj.detect == 1
                % fly closer to the signal
                obj = change_pos_and_orientation_approach(obj);
            else
                % change position and orientation of drone
                obj = change_pos_and_orientation(obj);
            end
            
            % draw drone on figure
            draw(obj);
        end
    end
end
        