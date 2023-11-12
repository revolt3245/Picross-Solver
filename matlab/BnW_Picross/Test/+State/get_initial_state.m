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
state.time = 0;
end