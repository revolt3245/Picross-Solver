function update(graphics, state, param)
%% board
board = ones(param.n_row, param.n_col);
board(state.board == 2) = 0;
board(state.board == 1) = 0.9;

board = reshape(board, param.n_row, param.n_col, 1);
board = repmat(board, 1, 1, 3);

graphics.board.CData = board;

%% xsign
[X, Y] = meshgrid(0:(param.n_col-1), 0:(param.n_row-1));
grid_x = reshape(X(state.board == 1), 1, []);
grid_y = reshape(Y(state.board == 1), 1, []);

grid_idx = grid_y * param.n_col + grid_x;
grid_idx = reshape(6*grid_idx + (0:5)', 1, []) + 1;

x_sign = nan(2, 6*param.n_col*param.n_row);

xsign_base_x = [-0.5 0.5 nan 0.5 -0.5 nan]';
xsign_base_y = [0.5 -0.5 nan 0.5 -0.5 nan]';

xsign_base_x = reshape(xsign_base_x + grid_x + 1, 1, []);
xsign_base_y = reshape(xsign_base_y + grid_y + 1, 1, []);

x_sign(1, grid_idx) = xsign_base_x;
x_sign(2, grid_idx) = xsign_base_y;

graphics.xsign.XData = x_sign(1,:);
graphics.xsign.YData = x_sign(2,:);

%% clues
[~, col_maxlength] = Util.get_longest_length(param.col_const);
[~, row_maxlength] = Util.get_longest_length(param.row_const);
for i = 1:param.n_row
    Color = zeros(row_maxlength, 3);

    s_row = size(param.row_const{i}, 2);
    state_clue_aug = [true(1, row_maxlength-s_row) state.row_const{i}];
    Color(state_clue_aug, :) = 0;
    Color(~state_clue_aug, :) = 0.5;

    graphics.row_const.CData(i,:,:) = Color;
end

for i=1:param.n_col
    Color = zeros(col_maxlength, 3);

    s_col = size(param.col_const{i}, 2);
    state_clue_aug = [true(1, col_maxlength-s_col) state.col_const{i}];
    Color(state_clue_aug, :) = 0;
    Color(~state_clue_aug, :) = 0.5;

    graphics.col_const.CData(:,i,:) = Color;
end
%% times
graphics.clock.String = sprintf("%03.2f", state.time);
end