function angle = vector_angle_2d(v1, v2, unit)
    % 计算两个二维向量的夹角
    % 输入：
    %   v1, v2 - 二维向量
    %   unit - 'rad'（弧度，默认）或 'deg'（角度）
    % 输出：
    %   angle - 夹角（0 到 pi）
    
    if nargin < 3
        unit = 'rad';
    end
    
    % 计算点积
    dot_product = dot(v1, v2);
    
    % 计算模长
    norm_v1 = norm(v1);
    norm_v2 = norm(v2);
    
    % 避免除以零
    if norm_v1 == 0 || norm_v2 == 0
%         error('向量不能为零向量');
        angle = 0;
        return;        % 提前返回
    end
    
    % 计算夹角的余弦值
    cos_theta = dot_product / (norm_v1 * norm_v2);
    
    % 处理数值误差（确保cos_theta在[-1,1]范围内）
    cos_theta = max(min(cos_theta, 1), -1);
    
    % 计算夹角
    angle_rad = acos(cos_theta);
    
    % 根据需要转换单位
    switch lower(unit)
        case 'rad'
            angle = angle_rad;
        case 'deg'
            angle = rad2deg(angle_rad);
        otherwise
            error('单位必须是 ''rad'' 或 ''deg''');
    end
end