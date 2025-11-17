% ========================================
% 1. draw_scene.m
% ========================================
function draw_scene(path_pts, x, target_idx, scale, t, total_targets)
% دالة لرسم المشهد الكامل (المسار، السيارة، الهدف)

clf; hold on; grid on; axis equal;
axis([-30 30 -30 30 -5 15]);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Path Following - PID/PD Control');
view(3);

% رسم المسار
plot3(path_pts(1,:), path_pts(2,:), path_pts(3,:), 'r-', 'LineWidth', 3);
scatter3(path_pts(1,:), path_pts(2,:), path_pts(3,:), 80, 'r', 'filled');

% رسم النقطة المستهدفة
target = path_pts(:, target_idx);
scatter3(target(1), target(2), target(3), 200, 'g', 'filled', 'MarkerEdgeColor', 'k');

% رسم السيارة
draw_simple_car(x, scale);


end