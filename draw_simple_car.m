% ========================================
% 6. draw_simple_car.m
% ========================================
function draw_simple_car(x, scale)
% دالة لرسم سيارة 3D بسيطة (صندوق مع عجلات وسهم)

theta = x(4);

% مصفوفة الدوران حول المحور Z
R = [cos(theta) -sin(theta) 0;
     sin(theta)  cos(theta) 0;
     0          0         1];

% أبعاد السيارة
L = 2.0 * scale;  % الطول
W = 1.0 * scale;  % العرض
H = 0.6 * scale;  % الارتفاع

% النقاط الأساسية للصندوق (القاعدة)
box = [-L/2  L/2  L/2 -L/2 -L/2;
       -W/2 -W/2  W/2  W/2 -W/2;
        0    0    0    0    0];

% السقف
box_top = box + [0; 0; H];

% تطبيق الدوران والإزاحة
box = R * box + x(1:3);
box_top = R * box_top + x(1:3);

% لون السيارة
color = [0.2 0.4 0.8];  % أزرق

% رسم القاعدة والسقف
fill3(box(1,:), box(2,:), box(3,:), color, 'FaceAlpha', 0.9, 'EdgeColor', 'k', 'LineWidth', 2);
fill3(box_top(1,:), box_top(2,:), box_top(3,:), color, 'FaceAlpha', 0.9, 'EdgeColor', 'k', 'LineWidth', 2);

% رسم الجوانب الأربعة
for i = 1:4
    j = mod(i, 4) + 1;
    side = [box(:,i) box(:,j) box_top(:,j) box_top(:,i)];
    fill3(side(1,:), side(2,:), side(3,:), color, 'FaceAlpha', 0.9, 'EdgeColor', 'k', 'LineWidth', 2);
end

% رسم العجلات (4 دوائر)
r = 0.4 * scale;  % نصف قطر العجلة
wheel_positions = [L/3 -W/2-0.2; 
                   L/3  W/2+0.2; 
                  -L/3 -W/2-0.2; 
                  -L/3  W/2+0.2];

t = linspace(0, 2*pi, 16);

for i = 1:4
    % إنشاء دائرة العجلة
    wheel = [wheel_positions(i,1) + 0*t;
             wheel_positions(i,2) + 0*t;
             r * cos(t)];
    
    % تطبيق الدوران والإزاحة
    wheel = R * wheel + x(1:3);
    
    % رسم العجلة
    fill3(wheel(1,:), wheel(2,:), wheel(3,:), [0.1 0.1 0.1], ...
        'EdgeColor', 'k', 'LineWidth', 1.5);
end

% رسم السهم الأصفر (للاتجاه)
arrow_start = x(1:3) + R * [0; 0; H/2];
arrow_end = arrow_start + R * [L/2 + 0.5; 0; 0];

plot3([arrow_start(1) arrow_end(1)], ...
      [arrow_start(2) arrow_end(2)], ...
      [arrow_start(3) arrow_end(3)], 'y-', 'LineWidth', 4);

scatter3(arrow_end(1), arrow_end(2), arrow_end(3), 120, 'y', 'filled');
end