function is_complete = check_all_complete(param, state)
%% parameter
n_row = param.n_row;
n_col = param.n_col;

%% state
row_const = state.row_const;
col_const = state.col_const;

is_complete = true;
for i=1:n_row
    if any(row_const{i})
        is_complete = false;
    end
end

for i=1:n_col
    if any(col_const{i})
        is_complete = false;
    end
end
end