% ========================================
% 3. pid_controller.m
% ========================================
function [vz, int, prev_dz] = pid_controller(z, z_target, Kp, Ki, Kd, int, prev_dz, dt)
% متحكم PID للتحكم في الارتفاع (Z)

% حساب الخطأ
dz = z_target - z;

% التكامل
int = int + dz * dt;

% المشتق
d_dz = (dz - prev_dz) / dt;

% قانون التحكم PID
vz = Kp * dz + Ki * int + Kd * d_dz;

% Saturation (تحديد القيمة القصوى)
vz = max(min(vz, 5), -5);

% تحديث الخطأ السابق
prev_dz = dz;
end