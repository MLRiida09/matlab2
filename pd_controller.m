% ========================================
% 2. pd_controller.m
% ========================================
function [omega, prev_err] = pd_controller(x, target, Kp, Kd, prev_err, dt)
% متحكم PD للتحكم في الزاوية (الدوران)

% حساب الزاوية المطلوبة
dx = target(1) - x(1);
dy = target(2) - x(2);
theta_desired = atan2(dy, dx);

% حساب الخطأ الزاوي (مع تطبيع)
theta_error = atan2(sin(theta_desired - x(4)), cos(theta_desired - x(4)));

% حساب المشتق
d_error = (theta_error - prev_err) / dt;

% قانون التحكم PD
omega = Kp * theta_error + Kd * d_error;

% Saturation (تحديد القيمة القصوى)
omega = max(min(omega, 2), -2);

% تحديث الخطأ السابق
prev_err = theta_error;
end