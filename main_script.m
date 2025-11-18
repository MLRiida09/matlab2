% ========================================
%      main_script.m - نسخة محدثة
% ========================================

clear; clc; close all;

% تعريف المسار (مربع مع ارتفاعات مختلفة)
path_pts = [-20  20  20 -20 -20;
            -20 -20  20  20 -20;
              0   5  10   5   0];

% الحالة الأولية [X; Y; Z; theta]
x = [-20; -20; 0; 0];

% معاملات المحاكاة
dt = 0.05;           % خطوة الزمن
v = 10;              % السرعة الخطية
T = 100;             % زمن المحاكاة
scale = 3.0;         % حجم الموتيف
tolerance = 3.0;     % مسافة القبول للهدف
current_target = 1;  % الهدف الحالي

% معاملات التحكم
Kp_theta = 4.0;    Kd_theta = 1.5;  % PD للزاوية
Kp_z = 1.2;        Ki_z = 0.4;      Kd_z = 0.3;  % PID للارتفاع

% متغيرات المتحكمات
prev_theta_err = 0;
int_z = 0;
prev_dz = 0;

% لتسجيل المسار المقطوع
trajectory = [];

% ========== حلقة المحاكاة ==========
figure('Position', [100, 100, 1000, 800]);

% متغير لتخزين omega
omega = 0;

for t = 0:dt:T
    % الهدف الحالي
    target = path_pts(:, current_target);
    
    % حساب التحكم
    [omega, prev_theta_err] = pd_controller(x, target, Kp_theta, Kd_theta, prev_theta_err, dt);
    [vz, int_z, prev_dz] = pid_controller(x(3), target(3), Kp_z, Ki_z, Kd_z, int_z, prev_dz, dt);
    
    % رسم المشهد (تمرير omega لرسم العجلات)
    draw_scene(path_pts, x, current_target, scale, t, size(path_pts, 2), omega);
    
    % رسم المسار المقطوع
    trajectory = [trajectory, x(1:3)];
    if size(trajectory, 2) > 1
        plot3(trajectory(1,:), trajectory(2,:), trajectory(3,:), 'b-', 'LineWidth', 2);
    end
    
    % التحقق من الوصول للهدف
    distance_to_target = norm(x(1:3) - target);
    if distance_to_target < tolerance
        current_target = current_target + 1;
        if current_target > size(path_pts, 2)
            title(sprintf('✓ End of Path! - Time: %.2fs', t));
            break;
        end
        target = path_pts(:, current_target);
    end
    
    % تحديث الحالة باستخدام Runge-Kutta
    x = rk4_update(x, v, omega, vz, dt);
    
    drawnow;
    pause(0.01);  % لتسهيل المشاهدة
end

disp('=== المحاكاة انتهت ===');
fprintf('الزمن الكلي: %.2f ثانية\n', t);
fprintf('عدد النقاط المقطوعة: %d\n', size(trajectory, 2));