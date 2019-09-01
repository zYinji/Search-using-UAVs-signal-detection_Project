syms x y z
% fimplicit((-98 - 35 * log10(sqrt(x^2+z^2)/10))/(1 - 0.5*exp(1 * log(1/2) - sqrt(x^2)))==-100,[-17 17]);
fimplicit((-98 - 35 * log10(sqrt(x^2+y^2)/10))*(exp(2*(-0.3 - sqrt(x^2)))+1)==-120,[-17 17]);
% fplot(exp(2*(2 - sqrt(x^2)))+1,[-1,10]);
% % (-96 - 21.35 * log10(sqrt(100^2+z^2)/10))/(1 - 2*exp(1 * log(1/2) - 100)
% % fplot(1 - 2*exp(coff * log(1/2) - x));
% fplot(exp(-(coff * log(1/2) - x))+1);
% fplot(exp(2*(1 - x))+1,[-1,10]);

f = @(x,y,z) (-98 - 35 * log10(sqrt(x.^2+y.^2+z.^2)/10)).*(exp(2*(-0.3 - sqrt(x.^2+y.^2)))+1)+100;
% f = @(x,y,z) (-98 - 35 * log10(sqrt(x.^2+y.^2+z.^2)/10))./(1 - 0.5*exp(1 * log(1/2) - sqrt(x.^2+z.^2)))+100;      % 函数表达式
[x,y,z] = meshgrid(-20:.2:20,-20:.2:20,-20:.2:20);       % 画图范围
v = f(x,y,z);
h = patch(isosurface(x,y,z,v,0)); 
isonormals(x,y,z,v,h)              
set(h,'FaceColor','r','EdgeColor','none');
xlabel('x');ylabel('y');zlabel('z'); 
alpha(1)   
grid on; view([1,1,1]); axis equal; camlight; lighting gouraud

% f = @(x,y,z) x.*y.*z.*log(1+x.^2+y.^2+z.^2)-10;      % 函数表达式
% [x,y,z] = meshgrid(-10:.2:10,-10:.2:10,-10:.2:10);       % 画图范围
% v = f(x,y,z);
% h = patch(isosurface(x,y,z,v,0)); 
% isonormals(x,y,z,v,h)              
% set(h,'FaceColor','r','EdgeColor','none');
% xlabel('x');ylabel('y');zlabel('z'); 
% alpha(1)   
% grid on; view([1,1,1]); axis equal; camlight; lighting gouraud