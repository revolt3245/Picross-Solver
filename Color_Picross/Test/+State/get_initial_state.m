function state = get_initial_state(param)
%% parameter
n_col = param.n_col;
n_row = param.n_row;

col_const = param.col_const;
row_const = param.row_const;

%% state
state.board = ones(n_row, n_col, 'uint32') * (bitshift(uint32(1), param.n_color + 1) - 1);

state.col_const = {};
state.row_const = {};

for i=1:n_row
    state.row_const{i, 1} = true(1, size(row_const{i}, 2));
end

for i=1:n_col
    state.col_const{i, 1} = true(1, size(col_const{i}, 2));
end

%% elapse
state.time = 0;
end