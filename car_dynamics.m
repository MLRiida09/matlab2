function dxdt = car_dynamics(x, u)
% ديناميكا السيارة ثلاثية الأبعاد
% Inputs:
%   x: الحالة [X; Y; Z; theta]
%   u: مدخلات التحكم [v; omega; vz]
% Output:
%   dxdt: مشتق الحالة

v = u(1);       % السرعة الخطية
omega = u(2);   % السرعة الزاوية
vz = u(3);      % السرعة العمودية
theta = x(4);   % الزاوية الحالية

% معادلات الحركة
dxdt = [v * cos(theta);     % dx/dt
        v * sin(theta);     % dy/dt
        vz;                 % dz/dt
        omega];             % dtheta/dt

end