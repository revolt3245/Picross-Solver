function state = get_initial_state(param)
%% parameter
n_col = param.n_col;
n_row = param.n_row;

col_const = param.col_const;
row_const = param.row_const;

%% state
state.board = ones(n_row, n_col, 'uint8') * uint8(3);

state.col_const = {};
state.row_const = {};

for i=1:n_row
    state.row_const{i, 1} = true(size(row_const{i}));
end

for i=1:n_col
    state.col_const{i, 1} = true(size(col_const{i}));
end

%% elapse
state.tick = [];
state.time = 0;

%% bound
state.bounds = [ones(1, param.n_row+param.n_col)
    param.n_col*ones(1,param.n_row) param.n_row*ones(1,param.n_col)
    ones(1, param.n_row+param.n_col)
    zeros(1, param.n_row + param.n_col)];

state.n_lines = zeros(1, param.n_row + param.n_col);

for i = 1:(param.n_col + param.n_row)
    if i <= param.n_row
        state.n_lines(i) = Util.get_possible_lines_memo(param.n_col, param.row_const{i});
        state.bounds(4, i) = size(param.row_const{i}, 2);
    else
        state.n_lines(i) = Util.get_possible_lines_memo(param.n_row, param.col_const{i-param.n_row});
        state.bounds(4, i) = size(param.col_const{i-param.n_row}, 2);
    end
end
end