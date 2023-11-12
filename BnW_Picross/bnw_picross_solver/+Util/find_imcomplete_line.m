function line_nums = find_imcomplete_line(param, state)
%% parameter
n_row = param.n_row;
n_col = param.n_col;

%% state
row_const = state.row_const;
col_const = state.col_const;

line_nums = [];
for i=1:n_row
    if(any(row_const{i}))
        line_nums = [line_nums 
            i];
    end
end

for i=1:n_col
    if(any(col_const{i}))
        line_nums = [line_nums
            i+n_row];
    end
end
end