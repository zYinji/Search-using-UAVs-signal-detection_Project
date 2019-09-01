% ----------------------------------------------------------------------------------------------------------
%  File: DroneSet.m (Multi-UAVs)
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
        RSSI_ref_median = - 98;
            
        ellipsoid = [20 20 0.0];
        
        % time interval for simulation (seconds)
        time_interval = 1;
        
        % fly speed: 15m/s
        speed = 15;
        
        % colours of each UAV component
        colours = [[.8 .3 .1];[.2 .2 .5];[.8 .9 .3];[.9 .6 .8];[.9 .2 .4]];
        
        R = eye(3);
        
        drone_follow = false;
        
        S = 200;
    end
    properties
        % axis to draw on
        axis
        
        % current time
        time
        
        % current position
        pos
        posplus
       
        % 1S, 2S, .........
        period
        periodPlus
        
        round
        roundPlus
        
        % per round distance
        roundDistance
        roundDistancePlus
        
        height
        
        % having received signal or not(0,1)
        detect
        detectplus
        
        % signal position
        signalPos
        
        % signal 2D radius
        radius
        TOFradius
        
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
        angleplus
        
        % record the reference point position
        basePos
        basePosPlus
        
        % record the reference point position
        basePosRecord
        basePosPlusRecord
        
        % judege whether the position is found 
        complete
        
        rectangle
        rectanglePlus
        
    end
    methods
        
        %%%%%%%%%%%%%%%%%%%
        %Initlization     %
        %%%%%%%%%%%%%%%%%%%
        function obj = DroneSet(axis,basePos,basePosPlus,signalPos)
            obj.axis = axis;
            
            obj.height = 80;
            
            % initial position
            obj.pos = [0;0;obj.height];
            obj.posplus = [0;0;obj.height];
            
            % reference point position
            obj.basePosRecord = basePos;
            obj.basePosPlusRecord = basePosPlus;
            obj.basePos = [obj.basePosRecord(1,1);obj.basePosRecord(1,2);obj.height];
            obj.basePosPlus = [obj.basePosPlusRecord(1,1);obj.basePosPlusRecord(1,2);obj.height];
            
            % initial time
            obj.time = 0;
            
            obj.period = 1;
            obj.periodPlus = 1;
            
            obj.round = 1;
            obj.roundPlus = 1;
            
            obj.roundDistance = 0;
            obj.roundDistancePlus = 0;
            
            obj.detect = -1;
            obj.detectplus = -1;
            
            % the position of signal source
            obj.signalPos = [signalPos(1);signalPos(2);0];
            
            obj.distance = [];
            obj.TOFdistance = [];            
            obj.UAVRecord = [];
            obj.TOFUAVRecord = [];
            
            obj.spiralRaduis = 0;         
            obj.spiralThetaChange = 0;           
            obj.spiralcount = 0;
            
            obj.angle = atan2(obj.basePos(1)-obj.pos(1),obj.basePos(2)-obj.pos(2));
            obj.angleplus = atan2(obj.basePosPlus(1)-obj.posplus(1),obj.basePosPlus(2)-obj.posplus(1));
                       
            obj.complete = 0;
            
            obj.rectangle = 0;
            obj.rectanglePlus = 0;
            
        end
        
        function draw(obj)

            %create middle sphere
            [X Y Z] = sphere(8);
            [A B C] = sphere(8);
            %[X Y Z] = (obj.ellipsoid(1)/5.).*[X Y Z];
            X = (obj.ellipsoid(1)/5.).*X + obj.pos(1);
            Y = (obj.ellipsoid(1)/5.).*Y + obj.pos(2);
            Z = (obj.ellipsoid(1)/5.).*Z + obj.pos(3);
            s = surf(X,Y,Z);
            
            A = (obj.ellipsoid(1)/5.).*A + obj.posplus(1);
            B = (obj.ellipsoid(1)/5.).*B + obj.posplus(2);
            C = (obj.ellipsoid(1)/5.).*C + obj.posplus(3);
            splus = surf(A,B,C);
                        
            set(s,'edgecolor','none','facecolor',obj.colours(1,:));
            set(splus,'edgecolor','none','facecolor',obj.colours(1,:));
            
            %create side spheres
            %front, right, back, left
            hOff = obj.ellipsoid(3)/2;
            Lx = obj.ellipsoid(1)/2;
            Ly = obj.ellipsoid(2)/2;
            UAVs = [...
                0    Ly    0    -Ly;
                Lx    0    -Lx   0;
                hOff hOff hOff hOff];
            Inertial = zeros(3,4);
            for i = 1:4
                UAV = UAVs(:,i);
                Inertial(:,i) = bodyToInertial(obj,UAV);
                [X Y Z] = sphere(8);
                X = (obj.ellipsoid(1)/8.).*X + obj.pos(1) + Inertial(1,i);
                Y = (obj.ellipsoid(1)/8.).*Y + obj.pos(2) + Inertial(2,i);
                Z = (obj.ellipsoid(1)/8.).*Z + obj.pos(3) + Inertial(3,i);
                s = surf(X,Y,Z);
                set(s,'edgecolor','none','facecolor',obj.colours(i+1,:));
            end
            for i = 1:4
                UAV = UAVs(:,i);
                Inertial(:,i) = bodyToInertial(obj,UAV);
                [A B C] = sphere(8);
                A = (obj.ellipsoid(1)/8.).*A + obj.posplus(1) + Inertial(1,i);
                B = (obj.ellipsoid(1)/8.).*B + obj.posplus(2) + Inertial(2,i);
                C = (obj.ellipsoid(1)/8.).*C + obj.posplus(3) + Inertial(3,i);
                splus = surf(A,B,C);
                set(splus,'edgecolor','none','facecolor',obj.colours(i+1,:));
            end
         
            % show the search time and the current UAV position 
            titlename = ['UAV Search:',' Time:',num2str(obj.time,'%.2f'),'s, Position:',...
                 '(',num2str(obj.pos(1)),',',num2str(obj.pos(2)),',',num2str(obj.pos(3)),')'];
            title(titlename);
        end
        
        function vectorInertial = bodyToInertial(obj, vectorBody)
            vectorInertial = obj.R*vectorBody;
        end
        
        %%%%%%%%%%%%%%%%%%% detect = -1: Arrive reference point-1%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_direct(obj) 
            obj.pos(1) = obj.pos(1) + obj.speed * obj.time_interval * sin(obj.angle);
            obj.pos(2) = obj.pos(2) + obj.speed * obj.time_interval * cos(obj.angle);
            obj.pos(3) = obj.height;
            if norm([obj.pos(1)-obj.basePos(1),obj.pos(2)-obj.basePos(2)])< obj.speed * obj.time_interval
                obj.rectangle = 1;
            end                      
        end
        
        %%%%%%%%%%%%%%%%%%% detect = -1: Arrive reference point-2%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_direct_plus(obj) 
            obj.posplus(1) = obj.posplus(1) + obj.speed * obj.time_interval * sin(obj.angleplus);
            obj.posplus(2) = obj.posplus(2) + obj.speed * obj.time_interval * cos(obj.angleplus);
            obj.posplus(3) = obj.height;
            if norm([obj.posplus(1)-obj.basePosPlus(1),obj.posplus(2)-obj.basePosPlus(2)])< obj.speed * obj.time_interval
                obj.rectanglePlus = 1;
            end                  
        end
        
        %%%%%%%%%%%%%%%%%%% detect = 0: Extended Rectangle Searching-1%%%%%%%%%%%%%%%%%%%%
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
                obj.pos(1) = obj.pos(1) + obj.speed * obj.time_interval;
                obj.pos(2) = obj.pos(2);
                obj.pos(3) = obj.height;
            end
            
            if (obj.round == 2)
                obj.pos(1) = obj.pos(1);
                obj.pos(2) = obj.pos(2) + obj.speed * obj.time_interval;
                obj.pos(3) = obj.height;
            end
            
            if (obj.round == 3)
                obj.pos(1) = obj.pos(1) - obj.speed * obj.time_interval;
                obj.pos(2) = obj.pos(2);
                obj.pos(3) = obj.height;
                if obj.pos(2) >= obj.basePos(2) + 375 - obj.S && obj.pos(1) <= obj.basePos(1) - 375 + obj.S
                    obj.rectangle =0;
                    if size(obj.basePosRecord) ~= 1
                        obj.basePosRecord = [obj.basePosRecord(2:end,:)];
                        obj.basePos = [obj.basePosRecord(1,1);obj.basePosRecord(1,2);obj.height];
                        obj.angle = atan2(obj.basePos(1)-obj.pos(1),obj.basePos(2)-obj.pos(2));
                        obj.period = 1;
                        obj.round = 1;
                        obj.roundDistance = 0;
                    else 
                        obj.detect = 10000;
                    end
                end
            end
            
            if (obj.round == 4)
                obj.pos(1) = obj.pos(1);
                obj.pos(2) = obj.pos(2) - obj.speed * obj.time_interval;
                obj.pos(3) = obj.height;   
            end
        end
        
        %%%%%%%%%%%%%%%%%%% detect = 0: Extended Rectangle Searching-2%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_plus(obj) 
            if (obj.roundDistancePlus + obj.speed * obj.time_interval > 0.8*(2*obj.periodPlus-1+fix(obj.roundPlus/3)) * obj.S)
                obj.roundDistancePlus = 0; % initialise round distance to zero
                if obj.roundPlus == 4
                    obj.roundPlus = 1;
                    obj.periodPlus = obj.periodPlus + 1;
                else
                    obj.roundPlus = obj.roundPlus + 1;
                end
            end
            obj.roundDistancePlus = obj.roundDistancePlus + obj.speed * obj.time_interval;
            if (obj.roundPlus == 1)
                obj.posplus(1) = obj.posplus(1) - obj.speed * obj.time_interval;
                obj.posplus(2) = obj.posplus(2);
                obj.posplus(3) = obj.height;
            end
            
            if (obj.roundPlus == 2)
                obj.posplus(1) = obj.posplus(1);
                obj.posplus(2) = obj.posplus(2) + obj.speed * obj.time_interval;
                obj.posplus(3) = obj.height;
            end
            
            if (obj.roundPlus == 3)
                obj.posplus(1) = obj.posplus(1) + obj.speed * obj.time_interval;
                obj.posplus(2) = obj.posplus(2);
                obj.posplus(3) = obj.height;
                if obj.posplus(2) >= obj.basePosPlus(2) + 375 - obj.S && obj.posplus(1) >= obj.basePosPlus(1) + 375 - obj.S
                    obj.rectanglePlus =0;
                    if size(obj.basePosPlusRecord) ~= 1
                        obj.basePosPlusRecord = [obj.basePosPlusRecord(2:end,:)];
                        obj.basePosPlus = [obj.basePosPlusRecord(1,1);obj.basePosPlusRecord(1,2);obj.height];
                        obj.angleplus = atan2(obj.basePosPlus(1)-obj.posplus(1),obj.basePosPlus(2)-obj.posplus(2));
                        obj.periodPlus = 1;
                        obj.roundPlus = 1;
                        obj.roundDistancePlus = 0;
                    else 
                        obj.detectplus = 10000;
                    end
                end
            end
            
            if (obj.roundPlus == 4)
                obj.posplus(1) = obj.posplus(1);
                obj.posplus(2) = obj.posplus(2) - obj.speed * obj.time_interval;
                obj.posplus(3) = obj.height;   
            end
        end
        
        %%%%%%%%%%%%%%%%%%% detect = 1: Archimedean Spiral Search-1%%%%%%%%%%%%%%%%%%%%
        function obj = Spiral(obj) 
            % radius having been calculated in detection function
            obj.spiralRaduis = obj.spiralRaduis + 2 - 0.01 * obj.spiralcount;                
            % speed * time_interval = arclength
            obj.spiralThetaChange = obj.speed * obj.time_interval/obj.spiralRaduis + obj.spiralThetaChange;
            obj.pos(1) = obj.spiralPos(1) + obj.spiralRaduis*cos(obj.spiralThetaChange);
            obj.pos(2) = obj.spiralPos(2) + obj.spiralRaduis*sin(obj.spiralThetaChange);
            obj.spiralcount = obj.spiralcount + 1;
        end
        
        %%%%%%%%%%%%%%%%%%% detect = 1: Archimedean Spiral Search-2%%%%%%%%%%%%%%%%%%%%
        function obj = Spiral_plus(obj) 
            % radius having been calculated in detection function
            obj.spiralRaduis = obj.spiralRaduis + 2 - 0.01 * obj.spiralcount;                
            % speed * time_interval = arclength
            obj.spiralThetaChange = obj.speed * obj.time_interval/obj.spiralRaduis + obj.spiralThetaChange;
            obj.posplus(1) = obj.spiralPos(1) + obj.spiralRaduis*cos(obj.spiralThetaChange);
            obj.posplus(2) = obj.spiralPos(2) + obj.spiralRaduis*sin(obj.spiralThetaChange);
            obj.spiralcount = obj.spiralcount + 1;
        end
        
        %%%%%%%%%%%%%%%%%%% detect = 2: Decrease Raduis Spiral Search-1%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_approach(obj) 
            obj.radius = norm([obj.pos(1),obj.pos(2)]-[obj.estPos(1),obj.estPos(2)]);
            if obj.radius >30
                obj.radius = obj.radius - 1; % radius having been calculated in detection function
            end
            if obj.radius <20
                obj.radius = 20; % radius having been calculated in detection function
            end
            [THETA,~] = cart2pol(obj.pos(1)-obj.estPos(1),obj.pos(2)-obj.estPos(2));
            % speed * time_interval = arclength
            theta = obj.speed * obj.time_interval/obj.radius;
            obj.pos(1) = obj.estPos(1) + obj.radius*cos(THETA+theta);
            obj.pos(2) = obj.estPos(2) + obj.radius*sin(THETA+theta);
        end
        
        %%%%%%%%%%%%%%%%%%% detect = 2: Decrease Raduis Spiral Search-2%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_approach_plus(obj) 
            obj.radius = norm([obj.posplus(1),obj.posplus(2)]-[obj.estPos(1),obj.estPos(2)]);
            if obj.radius >30
                obj.radius = obj.radius - 1; % radius having been calculated in detection function
            end
            if obj.radius <20
                obj.radius = 20; % radius having been calculated in detection function
            end
            [THETA,~] = cart2pol(obj.posplus(1)-obj.estPos(1),obj.posplus(2)-obj.estPos(2));
            % speed * time_interval = arclength
            theta = obj.speed * obj.time_interval/obj.radius;
            obj.posplus(1) = obj.estPos(1) + obj.radius*cos(THETA+theta);
            obj.posplus(2) = obj.estPos(2) + obj.radius*sin(THETA+theta);
        end
                
        %%%%%%%%%%%%%%%%%%% detect = 2: TOF Sprial-1%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_TOF(obj) 
            if obj.TOFradius < 25
                obj.TOFradius = obj.TOFradius + 1; % radius having been calculated in detection function
            end          
            obj.spiralThetaChange = obj.speed * obj.time_interval/obj.TOFradius + obj.spiralThetaChange;
            obj.pos(1) = obj.TOFUAVRecord(end,1) + obj.TOFradius*cos(obj.spiralThetaChange);
            obj.pos(2) = obj.TOFUAVRecord(end,2) + obj.TOFradius*sin(obj.spiralThetaChange);
        end
        
        %%%%%%%%%%%%%%%%%%% detect = 2: TOF Sprial-2%%%%%%%%%%%%%%%%%%%%
        function obj = change_pos_and_orientation_TOF_plus(obj) 
            if obj.TOFradius < 25
                obj.TOFradius = obj.TOFradius + 1; % radius having been calculated in detection function
            end           
            obj.spiralThetaChange = obj.speed * obj.time_interval/obj.TOFradius + obj.spiralThetaChange;
            obj.posplus(1) = obj.TOFUAVRecord(end,1) + obj.TOFradius*cos(obj.spiralThetaChange);
            obj.posplus(2) = obj.TOFUAVRecord(end,2) + obj.TOFradius*sin(obj.spiralThetaChange);
        end
        
      
        
        %%%%%%%%%%%%%%%%%%%Detect if the signal is received-1%%%%%%%%%%%%%%%%%%%%
        function obj = detection(obj)
            normXY = norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)]);
            % distance between signal and UAV
            d = norm([obj.pos(1),obj.pos(2),obj.pos(3)]-[obj.signalPos(1),obj.signalPos(2),obj.signalPos(3)]);
            coff = 1; % cofficient to control converge
            RSSI = (-98 - 21.35 * log10(d/10))/(1 - 2*exp(coff * log(1/2) - normXY));
            RSSI = RSSI + 1 * normrnd(0,1); % add Gausian noise
            if RSSI < - 125 % threshold
                return
            elseif size(obj.distance,1) > 20 % 21 position or more(add one more below)
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
                obj.detectplus = 1000;
            else %size(obj.distance,1) = 7
                obj.distance = [obj.d_ref * 10 .^((obj.RSSI_ref_median - RSSI)/obj.beta);obj.distance];
                obj.UAVRecord = [obj.pos(1)+rand*(1.3+1.3)-1.3 obj.pos(2)+rand*(1.3+1.3)-1.3 obj.pos(3);obj.UAVRecord];
                obj.detect = 2;
                obj.estPos = maxLikelihood(obj.UAVRecord(:,1),obj.UAVRecord(:,2),obj.distance);
            end
            
            if norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)])<20 && obj.detect ~= 3
               obj.detect = 3; % change to circle to find
               obj.TOFdistance = [sqrt(norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)])^2+(obj.height - obj.signalPos(3))^2) + rand(1);obj.TOFdistance];
               obj.TOFUAVRecord = [obj.pos(1)+rand*(1.3+1.3)-1.3 obj.pos(2)+rand*(1.3+1.3)-1.3 obj.pos(3);obj.TOFUAVRecord];
               obj.TOFradius = 10;        
            elseif norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)])<20 && obj.detect == 3
               obj.TOFdistance = [sqrt(norm([obj.pos(1),obj.pos(2)]-[obj.signalPos(1),obj.signalPos(2)])^2+(obj.height - obj.signalPos(3))^2) + rand(1);obj.TOFdistance];
               obj.TOFUAVRecord = [obj.pos(1)+rand*(1.3+1.3)-1.3 obj.pos(2)+rand*(1.3+1.3)-1.3 obj.pos(3);obj.TOFUAVRecord];
               if size(obj.TOFdistance,1) == 20
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
        
        %%%%%%%%%%%%%%%%%%%Detect if the signal is received-2%%%%%%%%%%%%%%%%%%%%
        function obj = detectionPlus(obj)
            normXY = norm([obj.posplus(1),obj.posplus(2)]-[obj.signalPos(1),obj.signalPos(2)]);
            % distance between signal and UAV
            d = norm([obj.posplus(1),obj.posplus(2),obj.posplus(3)]-[obj.signalPos(1),obj.signalPos(2),obj.signalPos(3)]);
            coff = 1; % cofficient to control converge
            RSSI = (-96 - 21.35 * log10(d/10))/(1 - 2*exp(coff * log(1/2) - normXY));
            RSSI = RSSI + 1 * normrnd(0,1); % add Gausian noise
            if RSSI < - 125 % threshold
                return
            elseif size(obj.distance,1) > 20 % 21 position or more(add one more below)
                obj.distance = [obj.d_ref * 10 .^((obj.RSSI_ref_median - RSSI)/obj.beta);obj.distance];
                obj.UAVRecord = [obj.posplus(1)+rand*(1.3+1.3)-1.3 obj.posplus(2)+rand*(1.3+1.3)-1.3 obj.posplus(3);obj.UAVRecord];%%%%%%%%%%%%%%%%%%%%%%%%%
                if size(obj.distance,1) < 160
                    obj.estPos = maxLikelihood(obj.UAVRecord(:,1),obj.UAVRecord(:,2),obj.distance);
                elseif size(obj.distance,1) > 300
                    obj.estPos = maxLikelihood(obj.UAVRecord(1:200,1),obj.UAVRecord(1:200,2),obj.distance(1:200));
                else
                    obj.estPos = maxLikelihood(obj.UAVRecord(1:100,1),obj.UAVRecord(1:100,2),obj.distance(1:100));
                end
            elseif size(obj.distance,1) < 20
                obj.distance = [obj.d_ref * 10 .^((obj.RSSI_ref_median - RSSI)/obj.beta);obj.distance];
                obj.UAVRecord = [obj.posplus(1)+rand*(1.3+1.3)-1.3 obj.posplus(2)+rand*(1.3+1.3)-1.3 obj.posplus(3);obj.UAVRecord];
                obj.detect = 1000; 
                obj.detectplus = 1;
            else %size(obj.distance,1) = 20
                obj.distance = [obj.d_ref * 10 .^((obj.RSSI_ref_median - RSSI)/obj.beta);obj.distance];
                obj.UAVRecord = [obj.posplus(1)+rand*(1.3+1.3)-1.3 obj.posplus(2)+rand*(1.3+1.3)-1.3 obj.posplus(3);obj.UAVRecord];
                obj.detectplus = 2;
                obj.estPos = maxLikelihood(obj.UAVRecord(:,1),obj.UAVRecord(:,2),obj.distance);
            end
            
            if norm([obj.posplus(1),obj.posplus(2)]-[obj.signalPos(1),obj.signalPos(2)])<20 && obj.detectplus ~= 3
               obj.detectplus = 3; % change to circle to find
               obj.TOFdistance = [sqrt(norm([obj.posplus(1),obj.posplus(2)]-[obj.signalPos(1),obj.signalPos(2)])^2+(obj.height - obj.signalPos(3))^2) + rand(1);obj.TOFdistance];
               obj.TOFUAVRecord = [obj.posplus(1)+rand*(1.3+1.3)-1.3 obj.posplus(2)+rand*(1.3+1.3)-1.3 obj.posplus(3);obj.TOFUAVRecord];
               obj.TOFradius = 10;        
            elseif norm([obj.posplus(1),obj.posplus(2)]-[obj.signalPos(1),obj.signalPos(2)])<20 && obj.detectplus == 3
               obj.TOFdistance = [sqrt(norm([obj.posplus(1),obj.posplus(2)]-[obj.signalPos(1),obj.signalPos(2)])^2+(obj.height - obj.signalPos(3))^2) + rand(1);obj.TOFdistance];
               obj.TOFUAVRecord = [obj.posplus(1)+rand*(1.3+1.3)-1.3 obj.posplus(2)+rand*(1.3+1.3)-1.3 obj.posplus(3);obj.TOFUAVRecord];
               if size(obj.TOFdistance,1) == 20
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
            obj = detectionPlus(obj);
            if obj.detect == -1 % direct flight
                if obj.rectangle == 0
                    % fly to the reference point
                    obj = change_pos_and_orientation_direct(obj);
                else
                    % change position and orientation of drone
                    obj = change_pos_and_orientation(obj);
                end
            elseif obj.detect == 2 % sprial approach
                % fly closer to the signal
                obj = change_pos_and_orientation_approach(obj);
            elseif obj.detect == 3 % TOF localization
                obj = change_pos_and_orientation_TOF(obj);
            elseif obj.detect == 1  % sprial detection
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
            
            if obj.detectplus == -1 % direct flight
                if obj.rectanglePlus == 0
                    % fly to the reference point
                    obj = change_pos_and_orientation_direct_plus(obj);
                else
                    % change position and orientation of drone
                    obj = change_pos_and_orientation_plus(obj);
                end
                          
            elseif obj.detectplus == 2 % sprial approach
                obj = change_pos_and_orientation_approach_plus(obj);
            elseif obj.detectplus == 3 % TOF localization
                obj = change_pos_and_orientation_TOF_plus(obj);
            elseif obj.detectplus == 1 % sprial detection
                if obj.spiralcount == 0
                    obj.spiralTheta = 1.5 * pi - obj.roundPlus * 0.5 * pi - pi;
                    obj.spiralThetaChange = -obj.spiralTheta;
                    obj.spiralPos = obj.posplus;
                    obj.spiralRaduis = 30;
                    obj.spiralPos(1) = obj.spiralPos(1) - obj.spiralRaduis*cos(obj.spiralThetaChange);
                    obj.spiralPos(2) = obj.spiralPos(2) - obj.spiralRaduis*sin(obj.spiralThetaChange);
                end
                obj = Spiral_plus(obj);
            end
            
            % draw drone on figure
            draw(obj);
            judge = obj.complete;

        end
    end
end
        