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
        % singal value 
        beta = 21.35;
        d_ref = 10;
        RSSI_ref_median = - 96;
            
        body = [20 20 0.0];
        
        % time interval for simulation (seconds)
        time_interval = 1;
        
        % size of floating window that follows drone
        axis_size = 20;
        
        % fly speed: 15m/s
        speed = 15;
        
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
        
        % UAV position record when detecting signals
        TOFUAVRecord 
        UAVRecord
        
        distance
        TOFdistance
        
        %Raduis to find signal
        spiralRaduis
        spiralTheta
        spiralThetaChange
        spiralPos
        spiralcount
        
        % estimate position
        estPos
        
        % the angle fly to the reference point
        angle
        
        % record the reference point position
        basePos
        
        % judege whether the position is found 
        complete
    end
    methods
        
        %%%%%%%%%%%%%%%%%%%
        %Initlization     %
        %%%%%%%%%%%%%%%%%%%
        function obj = DroneSet(axis,basePos,signalPos)
            obj.axis = axis;
            
            obj.height = 80;
            
            % initial position
            obj.pos = [0;0;obj.height];
            
            % reference point position
            obj.basePos = [basePos(1);basePos(2);obj.height];
            
            % initial time
            obj.time = 0;
            
            obj.period = 1;
            
            obj.round = 1;
            
            obj.roundDistance = 0;
            
            obj.detect = -1;
            
%             obj.signalPos = [400 700 0];% 先放这
            obj.signalPos = [signalPos(1);signalPos(2);0];% the position of signal source
            
            obj.distance = [];
            obj.TOFdistance = [];
            
            obj.UAVRecord = [];
            obj.TOFUAVRecord = [];
            
            obj.spiralRaduis = 0;
            
            obj.spiralThetaChange = 0;
            
            obj.spiralcount = 0;
            
            obj.angle = atan2(basePos(1),basePos(2));
            
            obj.complete = 0;
            
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
        
        %%%%%%%%%%%%%%%%%%%到达reference point%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_direct(obj) 
            obj.pos(1) = obj.pos(1) + obj.speed * obj.time_interval * sin(obj.angle);
            obj.pos(2) = obj.pos(2) + obj.speed * obj.time_interval * cos(obj.angle);
            obj.pos(3) = obj.height;
            if norm([obj.pos(1)-obj.basePos(1),obj.pos(2)-obj.basePos(2)])< obj.speed * obj.time_interval
                obj.detect = 0;
            end
                         
        end
        
        %%%%%%%%%%%%%%%%%%%Change Position 1画正方形%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation(obj) 
            if (obj.roundDistance + obj.speed * obj.time_interval > 0.8*(2*obj.period-1+fix(obj.round/3)) * obj.S)
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
        
        
        %%%%%%%%%%%%%%%%%%%Change Position 2画螺旋形%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_approach(obj) 
%             obj.radius = norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)]);
%             obj.radius = obj.radius - 1; % radius having been calculated in detection function
%             [THETA,~] = cart2pol(obj.pos(1)-obj.signalPos(1),obj.pos(2)-obj.signalPos(2));
% %             THETA = THETA;
%             % speed * time_interval = arclength
%             theta = obj.speed * obj.time_interval/obj.radius;
%             obj.pos(1) = obj.signalPos(1) + obj.radius*cos(THETA+theta);
%             obj.pos(2) = obj.signalPos(2) + obj.radius*sin(THETA+theta);
            obj.radius = norm([obj.pos(1),obj.pos(2)]-[obj.estPos(1),obj.estPos(2)]);
            if obj.radius >30
                obj.radius = obj.radius - 1; % radius having been calculated in detection function
            end
            if obj.radius <20
                obj.radius = 20; % radius having been calculated in detection function
            end
            [THETA,~] = cart2pol(obj.pos(1)-obj.estPos(1),obj.pos(2)-obj.estPos(2));
%             THETA = THETA;
            % speed * time_interval = arclength
            theta = obj.speed * obj.time_interval/obj.radius;
            obj.pos(1) = obj.estPos(1) + obj.radius*cos(THETA+theta);
            obj.pos(2) = obj.estPos(2) + obj.radius*sin(THETA+theta);
        end
        
        %%%%%%%%%%%%%%%%%%%Change Position 3改向探测信号%%%%%%%%%%%%%%%%%%%%
        function obj = Spiral(obj) 
            obj.spiralRaduis = obj.spiralRaduis + 2 - 0.01 * obj.spiralcount; % radius having been calculated in detection function               
%             THETA = THETA;
            % speed * time_interval = arclength
            obj.spiralThetaChange = obj.speed * obj.time_interval/obj.spiralRaduis + obj.spiralThetaChange;
            obj.pos(1) = obj.spiralPos(1) + obj.spiralRaduis*cos(obj.spiralThetaChange);
            obj.pos(2) = obj.spiralPos(2) + obj.spiralRaduis*sin(obj.spiralThetaChange);
            obj.spiralcount = obj.spiralcount + 1;
        end
        
        %%%%%%%%%%%%%%%%%%%检测是否接收到了信号%%%%%%%%%%%%%%%%%%%%
        function obj = detection(obj)
%             normXY = 10;
            normXY = norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)]);
            % distance between signal and UAV
            d = norm([obj.pos(1),obj.pos(2),obj.pos(3)]-[obj.signalPos(1),obj.signalPos(2),obj.signalPos(3)]);
            coff = 1; % cofficient to control converge
            RSSI = (-96 - 21.35 * log10(d/10))/(1 - 2*exp(coff * log(1/2) - normXY));
            RSSI = RSSI + 2 * normrnd(0,1); % add Gausian noise
            if RSSI < - 125 % threshold
%                 obj.detect = 0;
                return
            elseif size(obj.distance,1) > 20 % 9 position or more(add one more below)
                obj.distance = [obj.d_ref * 10 .^((obj.RSSI_ref_median - RSSI)/obj.beta);obj.distance];
                obj.UAVRecord = [obj.pos(1)+rand*(1.3+1.3)-1.3 obj.pos(2)+rand*(1.3+1.3)-1.3 obj.pos(3);obj.UAVRecord];%%%%%%%%%%%%%%%%%%%%%%%%%
                if size(obj.distance,1) < 160
                    obj.estPos = maxLikelihood(obj.UAVRecord(:,1),obj.UAVRecord(:,2),obj.distance);
                elseif size(obj.distance,1) > 300
                    obj.estPos = maxLikelihood(obj.UAVRecord(1:200,1),obj.UAVRecord(1:200,2),obj.distance(1:200));
                else
                    obj.estPos = maxLikelihood(obj.UAVRecord(1:100,1),obj.UAVRecord(1:100,2),obj.distance(1:100));
                end
            elseif size(obj.distance,1) < 20
                obj.distance = [obj.d_ref * 10 .^((obj.RSSI_ref_median - RSSI)/obj.beta);obj.distance];
                obj.UAVRecord = [obj.pos(1)+rand*(1.3+1.3)-1.3 obj.pos(2)+rand*(1.3+1.3)-1.3 obj.pos(3);obj.UAVRecord];
                obj.detect = 1;
            else %size(obj.distance,1) = 7
                obj.distance = [obj.d_ref * 10 .^((obj.RSSI_ref_median - RSSI)/obj.beta);obj.distance];
                obj.UAVRecord = [obj.pos(1)+rand*(1.3+1.3)-1.3 obj.pos(2)+rand*(1.3+1.3)-1.3 obj.pos(3);obj.UAVRecord];
                obj.detect = 2;
                obj.estPos = maxLikelihood(obj.UAVRecord(:,1),obj.UAVRecord(:,2),obj.distance);%%施工中
%                 position = maxLikelihood(obj.UAVRecord(1:10,1),obj.UAVRecord(1:10,2),obj.distance(1:10))
% position = IntersectionComputingXYZ(obj.UAVRecord(1:3:7,:),obj.distance(1:3:7));
            end
            
            if norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)])<20
               obj.TOFdistance = [sqrt(norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)])^2+(obj.height - obj.signalPos(3))^2) + rand(1);obj.TOFdistance];
               obj.TOFUAVRecord = [obj.pos(1)+rand*(1.3+1.3)-1.3 obj.pos(2)+rand*(1.3+1.3)-1.3 obj.pos(3);obj.TOFUAVRecord];
               if size(obj.TOFdistance,1) == 7
                   obj.estPos = maxLikelihood(obj.TOFUAVRecord(:,1),obj.TOFUAVRecord(:,2),obj.TOFdistance);
                   obj.complete = 1;
                    
                   estHeight = mean(obj.TOFUAVRecord(:,3)-sqrt(obj.TOFdistance.^2-(obj.TOFUAVRecord(:,1) ...
                               -obj.estPos(1)).^2-(obj.TOFUAVRecord(:,2)-obj.estPos(2)).^2));
                   positionError = norm([obj.estPos(1)-obj.signalPos(1),obj.estPos(2)-obj.signalPos(2),estHeight-obj.signalPos(3)]);
              
                   fprintf('Time usage: %d s \n ',obj.time-1);
                   fprintf('Position error: RSSI = %.3f m \n ',positionError);
               end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%Final Execution Function%%%%%%%%%%%%%%%%%%%
        function judge = update(obj)
            %update simulation time
            obj.time = obj.time + obj.time_interval;
            obj = detection(obj);
            if obj.detect == -1 %直线飞行
                % fly to the reference point
                obj = change_pos_and_orientation_direct(obj);
                
            elseif obj.detect == 0 %画正方形
                % change position and orientation of drone
                obj = change_pos_and_orientation(obj);
                
            elseif obj.detect == 2 %螺旋定位：第四步
                %%%%[x,y,z] = IntersectionComputingXYZ(obj.UAVRecord(),obj.distance)
                % fly closer to the signal
                obj = change_pos_and_orientation_approach(obj);
            else  %螺旋探测：第三步
                if obj.spiralcount == 0
                    obj.spiralTheta = 1.5 * pi - obj.round * 0.5 * pi - pi;
                    obj.spiralThetaChange = -obj.spiralTheta;
                    obj.spiralPos = obj.pos;
                    obj.spiralRaduis = 30;
                    obj.spiralPos(1) = obj.spiralPos(1) - obj.spiralRaduis*cos(obj.spiralThetaChange);
                    obj.spiralPos(2) = obj.spiralPos(2) - obj.spiralRaduis*sin(obj.spiralThetaChange);
                end
                obj = Spiral(obj);
            end
            
            % draw drone on figure
            draw(obj);
            judge = obj.complete;

        end
    end
end
        