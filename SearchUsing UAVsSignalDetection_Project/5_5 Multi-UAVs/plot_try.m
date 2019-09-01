syms x y z
% fimplicit((-98 - 35 * log10(sqrt(x^2+z^2)/10))/(1 - 0.5*exp(1 * log(1/2) - sqrt(x^2)))==-100,[-17 17]);
fimplicit((-98 - 35 * log10(sqrt(x^2+y^2)/10))*(exp(2*(-0.3 - sqrt(x^2)))+1)==-120,[-17 17]);
% fplot(exp(2*(2 - sqrt(x^2)))+1,[-1,10]);
% % (-96 - 21.35 * log10(sqrt(100^2+z^2)/10))/(1 - 2*exp(1 * log(1/2) - 100)
% % fplot(1 - 2*exp(coff * log(1/2) - x));
% fplot(exp(-(coff * log(1/2) - x))+1);
% fplot(exp(2*(1 - x))+1,[-1,10]);


alpha = pi/4;
f = @(x,y,z) (-98 - 35 * log10(sqrt((x*cos(alpha)+z*sin(alpha)).^2+y.^2+(-x*sin(alpha)+z*cos(alpha)).^2)/10)).*(exp(2*(-0.3 - sqrt((x*cos(alpha)+z*sin(alpha)).^2+y.^2)))+1)+100;
% f = @(x,y,z) (-98 - 35 * log10(sqrt((x*cos(alpha)-y*sin(alpha)).^2+(x*sin(alpha)+y*cos(alpha)).^2+z.^2)/10)).*(exp(2*(-0.3 - sqrt((x*cos(alpha)-y*sin(alpha)).^2+(x*sin(alpha)+y*cos(alpha)).^2)))+1)+100;
% f = @(x,y,z) (-98 - 35 * log10(sqrt(x.^2+y.^2+z.^2)/10)).*(exp(2*(-0.3 - sqrt(x.^2+y.^2)))+1)+100;
% f = @(x,y,z) (-98 - 35 * log10(sqrt(x.^2+y.^2+z.^2)/10))./(1 - 0.5*exp(1 * log(1/2) - sqrt(x.^2+z.^2)))+100;      % 函数表达式
[x,y,z] = meshgrid(-20:.2:20,-20:.2:20,-20:.2:20);       % 画图范围
v = f(x,y,z);
h = patch(isosurface(x,y,z,v,0)); 
isonormals(x,y,z,v,h)              
set(h,'FaceColor','r','EdgeColor','none');
xlabel('x');ylabel('y');zlabel('z'); 
alpha(1)   
grid on; view([1,1,1]); axis equal; camlight; lighting gouraud

% alpha = pi/2;
% R = [cos(alpha) -sin(alpha) 0
%      sin(alpha)  cos(alpha) 0
%         0           0       1];
% for i = 1:201
%     for j = 1:201
%         for k = 1:201
%             value = [x(i,j,k),y(i,j,k),z(i,j,k)] * R;
%             x(i,j,k) = value(1);
%             y(i,j,k) = value(2);
%             z(i,j,k) = value(3);            
%         end
%     end
% end

% f = @(x,y,z) x.*y.*z.*log(1+x.^2+y.^2+z.^2)-10;      % 函数表达式
% [x,y,z] = meshgrid(-10:.2:10,-10:.2:10,-10:.2:10);       % 画图范围
% v = f(x,y,z);
% h = patch(isosurface(x,y,z,v,0)); 
% isonormals(x,y,z,v,h)              
% set(h,'FaceColor','r','EdgeColor','none');
% xlabel('x');ylabel('y');zlabel('z'); 
% alpha(1)   
% grid on; view([1,1,1]); axis equal; camlight; lighting gouraud