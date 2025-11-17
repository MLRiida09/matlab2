% ========================================
% 4. rk4_update.m
% ========================================
function x_new = rk4_update(x, v, omega, vz, dt)
% Runge-Kutta (Rk4)

% مدخلات التحكم
u = [v; omega; vz];

% حساب k1, k2, k3, k4
k1 = car_dynamics(x, u);
k2 = car_dynamics(x + k1*(dt/2), u);
k3 = car_dynamics(x + k2*(dt/2), u);
k4 = car_dynamics(x + k3*dt, u);

% تحديث الحالة
x_new = x + (dt/6) * (k1 + 2*k2 + 2*k3 + k4);

% تطبيع الزاوية (بين -pi و pi)
x_new(4) = atan2(sin(x_new(4)), cos(x_new(4)));
end
