% ========================================
%     السكريبت الرئيسي - main_script.m
% ========================================
% يستدعي الدوال المنفصلة

clear; clc; close all;

% ========== إعدادات المحاكاة ==========
path_pts = [-20  20  20 -20 -20;
            -20 -20  20  20 -20;
              0   5  10   5   0];

x = [-20; -20; 0; 0];  % [X; Y; Z; theta]

% معاملات
dt = 0.05;
v = 10;
T = 100;
scale = 3.0;
tolerance = 3.0;
current_target = 1;

% معاملات التحكم
Kp_theta = 4.0;    Kd_theta = 1.5;  % PD للزاوية
Kp_z = 1.2;        Ki_z = 0.4;      Kd_z = 0.3;  % PID للارتفاع

% متغيرات المتحكمات
prev_theta_err = 0;
int_z = 0;
prev_dz = 0;

% ========== حلقة المحاكاة ==========
figure;

for t = 0:dt:T
    % رسم المشهد
    draw_scene(path_pts, x, current_target, scale, t, size(path_pts, 2));
    
    % الهدف الحالي
    target = path_pts(:, current_target);
    
    % التحقق من الوصول
    if norm(x(1:3) - target) < tolerance
        current_target = current_target + 1;
        if current_target > size(path_pts, 2)
            title('✓ وصلنا للنهاية!');
            break;
        end
        target = path_pts(:, current_target);
    end
    
    % حساب التحكم باستخدام الدوال
    [omega, prev_theta_err] = pd_controller(x, target, Kp_theta, Kd_theta, prev_theta_err, dt);
    [vz, int_z, prev_dz] = pid_controller(x(3), target(3), Kp_z, Ki_z, Kd_z, int_z, prev_dz, dt);
    
    % تحديث الحالة
    x = rk4_update(x, v, omega, vz, dt);
    
    drawnow;
end

disp('✓ انتهت المحاكاة بنجاح!');