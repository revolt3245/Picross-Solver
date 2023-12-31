function shapes = initialize(fig, ax, grid_size, param)
%% initialize
n_col = param.n_col;
n_row = param.n_row;

col_const = param.col_const;
row_const = param.row_const;

n_color = param.n_color;
color_map = param.color_map;

%% col_const, row_const
[col_lmat, col_maxlength] = Util.get_longest_length(col_const);
[row_lmat, row_maxlength] = Util.get_longest_length(row_const);

total_row = n_row + col_maxlength;
total_col = n_col + row_maxlength;

%% fig, ax setting
fig.Units = 'centimeters';

fig.InnerPosition(1) = 0;
fig.InnerPosition(2) = 0;
fig.InnerPosition(3) = total_col * grid_size + 1;
fig.InnerPosition(4) = total_row * grid_size + 1;

hold(ax, 'on'); axis(ax, 'equal');

ax.Visible = false;
ax.YDir = "reverse";

ax.InnerPosition(1) = 1/(2*(total_col*grid_size + 1));
ax.InnerPosition(2) = 1/(2*(total_row*grid_size + 1));
ax.InnerPosition(3) = total_col * grid_size/(total_col * grid_size + 1);
ax.InnerPosition(4) = total_row * grid_size/(total_row * grid_size + 1);

ax.FontUnits = "centimeters";
ax.FontSize = grid_size;

%% board
draw_board = ones(n_row, n_col, 3);
draw_alpha = ones(n_row, n_col);

shapes.board = image(ax, draw_board, AlphaData=draw_alpha);

%% const
draw_row_const = zeros(n_row, row_maxlength,3);
draw_row_const_alpha = zeros(n_row, row_maxlength);

for i=1:n_row
    r_count = row_lmat(i);

    row_const_r = zeros(1, r_count);
    row_const_g = zeros(1, r_count);
    row_const_b = zeros(1, r_count);

    row_const_line = zeros(1, r_count, 3);

    for j=1:n_color
        row_const_r(1, row_const{i}(2,:) == j) = color_map(j, 1);
        row_const_g(1, row_const{i}(2,:) == j) = color_map(j, 2);
        row_const_b(1, row_const{i}(2,:) == j) = color_map(j, 3);
    end
    row_const_line(:,:,1) = row_const_r;
    row_const_line(:,:,2) = row_const_g;
    row_const_line(:,:,3) = row_const_b;

    draw_row_const(i, row_maxlength-r_count+1:row_maxlength,:) = row_const_line;
    draw_row_const_alpha(i, row_maxlength-r_count+1:row_maxlength) = 1;
end

shapes.row_const = image(ax, draw_row_const, AlphaData=draw_row_const_alpha, XData = [-row_maxlength+1 0]);

draw_col_const = zeros(col_maxlength, n_col,3);
draw_col_const_alpha = zeros(col_maxlength, n_col);

for i=1:n_col
    c_count = col_lmat(i);

    col_const_r = zeros(1, c_count);
    col_const_g = zeros(1, c_count);
    col_const_b = zeros(1, c_count);

    col_const_line = zeros(1, c_count, 3);

    for j=1:n_color
        col_const_r(1, col_const{i}(2,:) == j) = color_map(j, 1);
        col_const_g(1, col_const{i}(2,:) == j) = color_map(j, 2);
        col_const_b(1, col_const{i}(2,:) == j) = color_map(j, 3);
    end
    col_const_line(:,:,1) = col_const_r;
    col_const_line(:,:,2) = col_const_g;
    col_const_line(:,:,3) = col_const_b;

    draw_col_const(col_maxlength-c_count+1:col_maxlength, i,:) = col_const_line;
    draw_col_const_alpha(col_maxlength-c_count+1:col_maxlength, i,:) = 1;
end

shapes.col_const = image(ax, draw_col_const, AlphaData=draw_col_const_alpha, YData = [-col_maxlength+1 0]);

%% grid
horizontal_x = repmat([-row_maxlength n_col nan], 1, n_row+1);
vertial_y = repmat([-col_maxlength n_row nan], 1, n_col+1);

horizontal_y = repmat(0:n_row, 2,1);
horizontal_y = [horizontal_y; NaN(1, n_row+1)];
horizontal_y = reshape(horizontal_y, 1, []);

vertial_x = repmat(0:n_col, 2, 1);
vertial_x = [vertial_x; NaN(1, n_col+1)];
vertial_x = reshape(vertial_x, 1, []);

horizontal = [horizontal_x; horizontal_y];
vertical = [vertial_x; vertial_y];

grid_lines = [horizontal vertical] + 0.5;

shapes.grid = plot(ax, grid_lines(1,:), grid_lines(2,:), LineWidth = 1.0, Color = [0.5 0.5 0.5]);

%% thick grid
horizontal_x = repmat([-row_maxlength n_col nan], 1, n_row/5+1);
vertial_y = repmat([-col_maxlength n_row nan], 1, n_col/5+1);

horizontal_y = n_row - 5*repmat(0:n_row/5, 2,1);
horizontal_y = [horizontal_y; NaN(1, n_row/5+1)];
horizontal_y = reshape(horizontal_y, 1, []);

vertial_x = 5 * repmat(0:n_col/5, 2, 1);
vertial_x = [vertial_x; NaN(1, n_col/5+1)];
vertial_x = reshape(vertial_x, 1, []);

horizontal = [horizontal_x; horizontal_y];
vertical = [vertial_x; vertial_y];

grid_lines = [horizontal vertical] + 0.5;

shapes.thick_grid = plot(ax, grid_lines(1,:), grid_lines(2,:), LineWidth = 2.0, Color = [0.5 0.5 0.5]);

%% x sign
xsign = nan(2, n_col*n_row*6);

shapes.xsign = plot(ax, xsign(1,:), xsign(2,:), LineWidth = 1.0, Color = [0.5 0.5 0.5]);

%% constraints
for i=1:n_row
    r_count = row_lmat(i);
    for j=1:r_count
        const_num = row_const{i}(1, j);
        const_col = row_const{i}(2, j);

        if mean(color_map(const_col, :)) > 0.5
            Color = [0 0 0];
        else
            Color = [1 1 1];
        end

        text(ax, -r_count + j, i, num2str(const_num), ...
            Color=Color, ...
            FontWeight='bold', ...
            HorizontalAlignment='center', ...
            FontUnits='centimeters', ...
            FontSize=grid_size/2);
    end
end

for i=1:n_col
    c_count = col_lmat(i);
    for j=1:c_count
        const_num = col_const{i}(1, j);
        const_col = col_const{i}(2, j);

        if mean(color_map(const_col, :)) > 0.5
            Color = [0 0 0];
        else
            Color = [1 1 1];
        end

        text(ax, i, -c_count + j, num2str(const_num), ...
            Color=Color, ...
            FontWeight='bold', ...
            HorizontalAlignment='center', ...
            FontUnits='centimeters', ...
            FontSize=grid_size/2);
    end
end

%% clock
shapes.clock = text(ax, -row_maxlength/2, -col_maxlength/2, "000.00", FontWeight='bold', ...
    FontUnits='centimeters', ...
    FontSize=grid_size, ...
    HorizontalAlignment='center');
end