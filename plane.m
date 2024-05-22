filename = 'E:\代码接单\飞机数据绘图\BADA性能数据表.xlsx';
M=cell(91,1);
% 读取Excel文件中的所有工作表
for i=1:91
    m=readcell(filename,'sheet',i);
    M{i}=m;
end
% 提取航空器类型并将其存储在一个单元数组中
aircraft_type=cell(91,1);
for i=1:91
    n=readcell(filename,'sheet',i);
    aircraft_type{i}=n{3,1};
end
% 清除不需要的字符并保存到aircraft_type
for i=1:length(aircraft_type)
    aircraft_type{i} = strrep(aircraft_type{i}, 'AC/Type:', '');
    aircraft_type{i} = strrep(aircraft_type{i}, '_', '');
end
% 加载之前存储的航迹数据
load('E:\代码接单\飞机数据绘图\TrajSimilarityMatrix.mat', 'arrTrajectorySet12', 'arrTrajectorySet13', 'arrTrajectorySet14', 'arrTrajectorySet15', 'arrTrajectorySet16', 'arrTrajectorySet17', 'arrTrajectorySet18', 'depTrajectorySet12', 'depTrajectorySet13', 'depTrajectorySet14', 'depTrajectorySet15', 'depTrajectorySet16', 'depTrajectorySet17', 'depTrajectorySet18');
% 保存航迹数据为MATLAB文件
save('E:\代码接单\飞机数据绘图\data_inport.mat', 'arrTrajectorySet12', 'arrTrajectorySet13', 'arrTrajectorySet14', 'arrTrajectorySet15', 'arrTrajectorySet16', 'arrTrajectorySet17', 'arrTrajectorySet18', 'depTrajectorySet12', 'depTrajectorySet13', 'depTrajectorySet14', 'depTrajectorySet15', 'depTrajectorySet16', 'depTrajectorySet17', 'depTrajectorySet18');
%------------------代码速度优化----------------------------------


%--------------------------------------------------------------------------------

total_length = length(arrTrajectorySet12) + length(arrTrajectorySet13) + length(arrTrajectorySet14) + length(arrTrajectorySet15) + length(arrTrajectorySet16) + length(arrTrajectorySet17) + length(arrTrajectorySet18) + length(depTrajectorySet12) + length(depTrajectorySet13) + length(depTrajectorySet14) + length(depTrajectorySet15) + length(depTrajectorySet16) + length(depTrajectorySet17) + length(depTrajectorySet18);

aircraft_type_in_airport = cell(1, total_length);

index = 1;

sets = {arrTrajectorySet12, arrTrajectorySet13, arrTrajectorySet14, arrTrajectorySet15, arrTrajectorySet16, arrTrajectorySet17, arrTrajectorySet18, depTrajectorySet12, depTrajectorySet13, depTrajectorySet14, depTrajectorySet15, depTrajectorySet16, depTrajectorySet17, depTrajectorySet18};

for k = 1:length(sets)
    current_set = sets{k};
    for i = 1:size(current_set, 1)
        aircraft_type_in_airport{index} = current_set{i, 4};
        index = index + 1;
    end
end

aircraft_type_in_airport = cell2mat(aircraft_type_in_airport);




% Remove duplicates from new cell
aircraft_type_in_airport = unique(aircraft_type_in_airport);

%aircraft_type_in_airport表示该机场所用航班类型，经统计得出该机场在7.12至7.18日之间一共只有七种机型，因此只需要利用之前所给的表中的对应七种机型做神经网络即可


% 定义要提取的工作表
sheets = [4, 5, 6, 8, 23, 27, 34];

% 初始化数据表
aircraft_data = cell(length(sheets), 1);

% 逐个读取工作表(sheet)
for i = 1:length(sheets)
    sheet_data = readtable('E:\代码接单\飞机数据绘图\BADA性能数据表.xlsx', 'Sheet', sheets(i));
    aircraft_data{i} = sheet_data;
end

% 将数据保存为MATLAB文件
save('E:\代码接单\飞机数据绘图\aircraft_data.mat', 'aircraft_data');



% 合并所有arrTrajectorySet为一个元胞数组
arrive_track = vertcat(arrTrajectorySet12, arrTrajectorySet13, arrTrajectorySet14, arrTrajectorySet15, arrTrajectorySet16, arrTrajectorySet17, arrTrajectorySet18);

% 合并所有depTrajectorySet为一个元胞数组
departure_track = vertcat(depTrajectorySet12, depTrajectorySet13, depTrajectorySet14, depTrajectorySet15, depTrajectorySet16, depTrajectorySet17, depTrajectorySet18);



% 获取arrive_track的行数，即航班数量
num_flights_arrive = size(arrive_track, 1);

% 创建一个新的3D立体图
figure;
hold on;

% 遍历arrive_track中的每个航班轨迹数据
for i = 1:num_flights_arrive
    % 提取当前航班的轨迹数据
    flight_data_arrive = arrive_track{i, 1};
    
    % 提取x、y和z坐标
    x = flight_data_arrive(:, 7);
    y = flight_data_arrive(:, 8);
    z = flight_data_arrive(:, 3) * 0.3048; % 将英尺转换为米
    
    % 在3D空间中绘制当前航班的轨迹
    plot3(x, y, z);
end

% 设置坐标轴标签
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

%设置图像名称
title('进场航迹图');

% 设置视角
view(3);

% 启用旋转3D模式，以便您可以自由旋转和查看3D立体图
rotate3d on;

% 保持图像
hold off;

%-----------绘制离场航迹图----------------------------
% 获取departure_track的行数，即航班数量
num_flights_departure = size(departure_track, 1);

% 创建一个新的3D立体图
figure;
hold on;

% 遍历arrive_track中的每个航班轨迹数据
for i = 1:num_flights_departure
    % 提取当前航班的轨迹数据
    flight_data_departure = departure_track{i, 1};
    
    % 提取x、y和z坐标
    x = flight_data_departure(:, 7);
    y = flight_data_departure(:, 8);
    z = flight_data_departure(:, 3) * 0.3048; % 将英尺转换为米
    
    % 在3D空间中绘制当前航班的轨迹
    plot3(x, y, z);
end

% 设置坐标轴标签
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

%设置图像名称
title('离场航迹图');

% 设置视角
view(3);

% 启用旋转3D模式，以便您可以自由旋转和查看3D立体图
rotate3d on;

% 保持图像
hold off;
%------------------------做一个判断飞行状态的函数，方便后期调用--------------------
%参见函数--------0代表上升，1代表下降，2代表巡航------------------------------------
%-----------------对航空器点迹进行状态判断（上升，巡航，下降）-------------------------
% 处理arrive_track
for i = 1:length(arrive_track)
    % 提取高度数据
    height_data_cell = arrive_track{i}(:, 3);
    if iscell(height_data_cell)
        height_data = cellfun(@str2double, height_data_cell);
    else
        height_data = height_data_cell;
    end

    % 调用determine_flight_state函数
    flight_state_result = determine_flight_state(height_data);

    % 将飞行状态结果存储到arrive_track的第11列
   arrive_track{i,1}=[arrive_track{i,1},cell2mat(flight_state_result)];
end

% 处理departure_track
for i = 1:length(departure_track)
    % 提取高度数据
    height_data_cell = departure_track{i}(:, 3);
    if iscell(height_data_cell)
        height_data = cellfun(@str2double, height_data_cell);
    else
        height_data = height_data_cell;
    end

    % 调用determine_flight_state函数
    flight_state_result = determine_flight_state(height_data);

    % 将飞行状态结果存储到departure_track的第11列
    departure_track{i,1}=[departure_track{i,1},cell2mat(flight_state_result)];
end

%合并arrive_track和departure_track为一个元胞数组
all_track = vertcat(arrive_track,departure_track);

%-------------------将不同机型和其对应数据表连接起来------------------
% 创建一个包含所有机型的字符串单元数组
aircraft_models = ["A319-131", "A320-211", "A321-232", "A330-301", "737700", "747400", "777300"];
% 遍历all_track中的每一行
for i = 1:size(all_track, 1)
    % 获取当前行的机型数据
    current_aircraft_type = all_track{i, 4};
    
    % 在aircraft_models中查找current_aircraft_type的位置（即索引值）
    aircraft_index = find(aircraft_models == current_aircraft_type);
    
    % 如果找到了对应的机型，将索引值保存到all_track的第14列
    if ~isempty(aircraft_index)
        all_track{i, 14} = aircraft_index;
    end
end
%-------------------算出实时燃油消耗率--------------------------------------
% 遍历all_track中的每一行
for i = 1:size(all_track, 1)
    % 获取第十四列的数值，找到对应的aircraft_data中的table
    aircraft_index = all_track{i, 14};
    fuel_data = aircraft_data{aircraft_index, 1};

    % 获取当前航班的点迹数据（double数组）
    track_data = all_track{i, 1};

    % 遍历track_data中的每一行
    for j = 1:size(track_data, 1)
        % 获取飞行高度（英尺）和飞行状态
        altitude_ft = track_data(j, 3);
        flight_status = track_data(j, 11);

        % 将高度单位从英尺转换为百英尺
        altitude_hft = altitude_ft / 100;

        % 根据飞行状态选择合适的列索引
        if flight_status == 0  % 上升
            column_index = 10;
        elseif flight_status == 1  % 下降
            column_index = 13;
        elseif flight_status == 2  % 巡航
            column_index = 4;
        else
            error('Invalid flight status');
        end

        % 在fuel_data中查找与当前高度最接近的两个高度值
        [~, idx] = min(abs(fuel_data.FL - altitude_hft));
        lower_idx = max(1, idx - 1);
        upper_idx = min(size(fuel_data, 1), idx);

        % 对燃油消耗率进行插值
        lower_altitude = fuel_data.FL(lower_idx);
        upper_altitude = fuel_data.FL(upper_idx);
        lower_rate = fuel_data{lower_idx, column_index};
        upper_rate = fuel_data{upper_idx, column_index};

        % 计算插值后的燃油消耗率
        interpolated_rate = lower_rate + (upper_rate - lower_rate) * (altitude_hft - lower_altitude) / (upper_altitude - lower_altitude);

        % 将计算结果填入track_data的第十二列
        track_data(j, 12) = interpolated_rate;
    end

    % 更新all_track中的点迹数据
    all_track{i, 1} = track_data;
end
%---------------------计算每个航迹点的燃油消耗----------------------------------
% 获取 all_track 的行数
[numRows, ~] = size(all_track);

% 遍历 all_track 的每一行
for i = 1:numRows
    % 取出当前行的 double 数组
    current_double = all_track{i, 1};
    
    % 计算燃油消耗（第十二列除以6）
    fuel_consumption = current_double(:, 12) / 6;
    
    % 将计算结果存储到第十三列
    current_double(:, 13) = fuel_consumption;

     % 第一步：将燃油消耗乘以折标煤系数1.4714
    standard_coal_consumption = fuel_consumption * 1.4714;

    % 第二步：将标准煤消耗乘以3.15，得到碳排放量
    carbon_emission = standard_coal_consumption * 3.15;

    % 将碳排放量存储到第十四列
    current_double(:, 14) = carbon_emission;
    
    % 将修改后的 double 数组放回 all_track
    all_track{i, 1} = current_double;
end
%---------------------------建立new_all_track----------------------------------------------------
% 获取 all_track 的行数和列数
[numRows, numCols] = size(all_track);

% 创建一个新的元胞数组，大小与 all_track 相同
new_all_track = cell(numRows, numCols);

% 遍历 all_track 的每一个元素
for i = 1:numRows
    for j = 1:numCols
        % 当前列是第一列时，将 double 转换为 cell
        if j == 1
            current_double = all_track{i, j};
            [doubleRows, doubleCols] = size(current_double);
            current_cell = cell(doubleRows, doubleCols);
            for row = 1:doubleRows
                for col = 1:doubleCols
                    current_cell{row, col} = current_double(row, col);
                end
            end
            new_all_track{i, j} = current_cell;
        else
            % 其他情况下，直接复制元素
            new_all_track{i, j} = all_track{i, j};
        end
    end
end
%---------------------插入第十五列，将时间与燃油消耗量对应-----------------------

for i = 1:size(new_all_track, 1)
    temp = new_all_track{i, 1};
    if size(temp, 2) < 15
        temp(:, end+1:15) = {[]};  % 如果元胞数组列数小于15，用空元胞扩展到15列
    end
    temp2 = new_all_track{i, 9};
    if ~iscell(temp2)  % 如果第9列元素不是元胞数组，将其转换为元胞数组
        temp2 = {temp2};
    end
    temp(:, 15) = temp2;  % 将第九列的元胞数组插入第十五列
    new_all_track{i, 1} = temp;
end

%-------------------处理时间数据-------------------------------------
num_records = size(new_all_track, 1);

for i = 1:num_records
    num_rows = size(new_all_track{i, 1}, 1);
    
    % 提取所有时间数据
    raw_time_data = new_all_track{i, 1}(:, 15);
    
    % 找到非空的时间数据索引
    non_empty_idx = ~cellfun(@isempty, raw_time_data);
    
    % 将非空时间数据转换为 datetime
    parsed_time_data = datetime(raw_time_data(non_empty_idx), 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss');
    
    % 将转换后的时间数据放回原位置
    new_all_track{i, 1}(non_empty_idx, 16) = num2cell(parsed_time_data);
    
    % 处理空时间数据
    new_all_track{i, 1}(~non_empty_idx, 16) = {[]};
end

save('new_all_track.mat', 'new_all_track');

