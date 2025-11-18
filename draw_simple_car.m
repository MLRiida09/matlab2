% ========================================
% draw_simple_car.m - نسخة محسنة مع عجلات متحركة
% ========================================
function draw_simple_car(x, scale, omega)
% دالة لرسم موتيف بسيط مع عجلات تدور عند المنعطفات
% المدخلات:
%   x: الحالة [X; Y; Z; theta]
%   scale: حجم الموتيف
%   omega: السرعة الزاوية (لحساب زاوية العجلات)

theta = x(4);

% مصفوفة الدوران حول المحور Z
R = [cos(theta) -sin(theta) 0;
     sin(theta)  cos(theta) 0;
     0          0         1];

% أبعاد الموتيف
L = 2.5 * scale;  % الطول
W = 1.2 * scale;  % العرض
H = 0.8 * scale;  % الارتفاع

% ========== جسم الموتيف (صندوق بسيط) ==========
% القاعدة
box = [-L/2  L/2  L/2 -L/2 -L/2;
       -W/2 -W/2  W/2  W/2 -W/2;
        0    0    0    0    0];

% السقف
box_top = box + [0; 0; H];

% تطبيق الدوران والإزاحة
box = R * box + x(1:3);
box_top = R * box_top + x(1:3);

% لون الموتيف (أحمر فاتح)
body_color = [0.9 0.2 0.2];

% رسم القاعدة والسقف
fill3(box(1,:), box(2,:), box(3,:), body_color, 'FaceAlpha', 0.85, 'EdgeColor', 'k', 'LineWidth', 2);
fill3(box_top(1,:), box_top(2,:), box_top(3,:), body_color, 'FaceAlpha', 0.85, 'EdgeColor', 'k', 'LineWidth', 2);

% رسم الجوانب
for i = 1:4
    j = mod(i, 4) + 1;
    side = [box(:,i) box(:,j) box_top(:,j) box_top(:,i)];
    fill3(side(1,:), side(2,:), side(3,:), body_color, 'FaceAlpha', 0.85, 'EdgeColor', 'k', 'LineWidth', 2);
end

% ========== العجلات المتحركة ==========
% حساب زاوية دوران العجلات الأمامية بناءً على omega
% كلما زادت السرعة الزاوية، زادت زاوية العجلات
max_wheel_angle = pi/6;  % 30 درجة كحد أقصى
wheel_steer_angle = max(min(omega * 0.5, max_wheel_angle), -max_wheel_angle);

% أبعاد العجلة
wheel_radius = 0.4 * scale;
wheel_width = 0.25 * scale;

% مواضع العجلات (أمامية وخلفية)
wheel_positions = [
    L/2.5,  -W/2-0.15, 1;   % أمامية يسار
    L/2.5,   W/2+0.15, 1;   % أمامية يمين
   -L/2.5,  -W/2-0.15, 0;   % خلفية يسار
   -L/2.5,   W/2+0.15, 0;   % خلفية يمين
];

% رسم العجلات
for i = 1:4
    % تحديد ما إذا كانت العجلة أمامية أم خلفية
    is_front = wheel_positions(i, 3);
    
    % زاوية دوران العجلة
    if is_front
        local_steer = wheel_steer_angle;
    else
        local_steer = 0;  % العجلات الخلفية لا تدور
    end
    
    % رسم العجلة
    draw_wheel(x, R, wheel_positions(i, 1:2), wheel_radius, wheel_width, ...
               local_steer, is_front);
end

% ========== السهم الأمامي (الاتجاه) ==========
arrow_start = x(1:3) + R * [0; 0; H/2];
arrow_end = arrow_start + R * [L/2 + 0.8; 0; 0];

plot3([arrow_start(1) arrow_end(1)], ...
      [arrow_start(2) arrow_end(2)], ...
      [arrow_start(3) arrow_end(3)], 'y-', 'LineWidth', 5);

scatter3(arrow_end(1), arrow_end(2), arrow_end(3), 150, 'y', 'filled', ...
         'MarkerEdgeColor', 'k', 'LineWidth', 2);

end

% ========================================
% دالة مساعدة لرسم عجلة واحدة
% ========================================
function draw_wheel(x, R, local_pos, radius, width, steer_angle, is_front)
% رسم عجلة واحدة مع إمكانية الدوران

% مصفوفة دوران العجلة حول المحور Z (للدوران عند المنعطفات)
R_steer = [cos(steer_angle) -sin(steer_angle) 0;
           sin(steer_angle)  cos(steer_angle) 0;
           0                 0                1];

% إنشاء العجلة كأسطوانة بسيطة
n_points = 12;
theta_wheel = linspace(0, 2*pi, n_points);

% الوجه الأول (الخارجي)
wheel_face1 = [local_pos(1) + zeros(1, n_points);
               local_pos(2) + width/2 * ones(1, n_points);
               radius * cos(theta_wheel)];

% الوجه الثاني (الداخلي)
wheel_face2 = [local_pos(1) + zeros(1, n_points);
               local_pos(2) - width/2 * ones(1, n_points);
               radius * cos(theta_wheel)];

% تطبيق دوران العجلة أولاً (للعجلات الأمامية)
wheel_face1 = R_steer * wheel_face1;
wheel_face2 = R_steer * wheel_face2;

% ثم تطبيق دوران الموتيف والإزاحة
wheel_face1 = R * wheel_face1 + x(1:3);
wheel_face2 = R * wheel_face2 + x(1:3);

% لون العجلة
wheel_color = [0.15 0.15 0.15];

% رسم الوجهين
fill3(wheel_face1(1,:), wheel_face1(2,:), wheel_face1(3,:), wheel_color, ...
      'EdgeColor', 'k', 'LineWidth', 1.5);
fill3(wheel_face2(1,:), wheel_face2(2,:), wheel_face2(3,:), wheel_color, ...
      'EdgeColor', 'k', 'LineWidth', 1.5);

% رسم الجوانب (ربط الوجهين)
for i = 1:n_points-1
    side = [wheel_face1(:,i) wheel_face1(:,i+1) wheel_face2(:,i+1) wheel_face2(:,i)];
    fill3(side(1,:), side(2,:), side(3,:), wheel_color, ...
          'EdgeColor', 'k', 'LineWidth', 1);
end

% إضافة خط أحمر على العجلة الأمامية لتوضيح الدوران
if is_front
    center1 = R * R_steer * [local_pos(1); local_pos(2) + width/2; 0] + x(1:3);
    mark_end = center1 + R * R_steer * [radius*0.7; 0; 0];
    
    plot3([center1(1) mark_end(1)], ...
          [center1(2) mark_end(2)], ...
          [center1(3) mark_end(3)], 'r-', 'LineWidth', 3);
end

end