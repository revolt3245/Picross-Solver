function [state, flag] = backtrack_solver(param, state, graphics)
%% find minimum line
line_num = 0;
min_upper_bound = inf;
for i = 1:(param.n_row + param.n_col)
    if i <= param.n_row
        line_width = state.bounds(2, i) - state.bounds(1, i) + 1;
        clue_width = sum(param.row_const{i}(state.bounds(3,i):state.bounds(4,i)));
        clue_size = state.bounds(4,i) - state.bounds(3,i) + 1;

        upper_bound = line_width - clue_width - clue_size + 2;
        if(any(state.row_const{i}) && (min_upper_bound > upper_bound))
            min_upper_bound = upper_bound;
            line_num = i;
        end
    else
        line_width = state.bounds(2, i) - state.bounds(1, i) + 1;
        clue_width = sum(param.col_const{i-param.n_row}(state.bounds(3,i):state.bounds(4,i)));
        clue_size = state.bounds(4,i) - state.bounds(3,i) + 1;

        upper_bound = line_width - clue_width - clue_size + 2;
        
        if (any(state.col_const{i-param.n_row}) && (min_upper_bound > upper_bound))
            min_upper_bound = upper_bound;
            line_num = i;
        end
    end
end

%% solver
gl_bound = state.bounds(1, line_num);
gh_bound = state.bounds(2, line_num);
cl_bound = state.bounds(3, line_num);
ch_bound = state.bounds(4, line_num);
state_temp = state;
if cl_bound == ch_bound
    if line_num <= param.n_row
        line_width = gh_bound - gl_bound + 1;
        first_clue = param.row_const{line_num}(cl_bound);
        upper_bound = line_width - first_clue + 1;

        for i=1:upper_bound
            if i == 1
                t_line = ones(1, line_width, 'uint8');
                t_line(1:first_clue) = uint8(2);
            else
                t_line(i-1) = 1;
                t_line(i+first_clue-1) = 2;
            end

            if any(bitand(state_temp.board(line_num, gl_bound:gh_bound), t_line) == 0)
                flag = false;
                break;
            end
            state_temp.board(line_num, gl_bound:gh_bound) = t_line;
            [state_temp, flag] = Solver.branch_solver(param, state_temp, graphics);

            if flag && ~Util.check_all_complete(param, state_temp)
                [state_temp, flag] = Solver.backtrack_solver(param, state_temp, graphics);
            end

            if ~flag
                state_temp = state;
            else
                state = state_temp;
                return
            end
        end
    else
        line_width = gh_bound - gl_bound + 1;
        first_clue = param.col_const{line_num-param.n_row}(cl_bound);
        upper_bound = line_width - first_clue + 1;

        for i=1:upper_bound
            if i == 1
                t_line = ones(line_width, 1, 'uint8');
                t_line(1:first_clue) = uint8(2);
            else
                t_line(i-1) = 1;
                t_line(i+first_clue-1) = 2;
            end

            if any(bitand(state_temp.board(gl_bound:gh_bound, line_num-param.n_row), t_line) == 0)
                flag = false;
                break;
            end
            state_temp.board(gl_bound:gh_bound, line_num-param.n_row) = t_line;
            [state_temp, flag] = Solver.branch_solver(param, state_temp, graphics);

            if flag && ~Util.check_all_complete(param, state_temp)
                [state_temp, flag] = Solver.backtrack_solver(param, state_temp, graphics);
            end

            if ~flag
                state_temp = state;
            else
                state = state_temp;
                return
            end
        end
    end
else
    if line_num <= param.n_row
        line_width = gh_bound - gl_bound + 1;
        first_clue = param.row_const{line_num}(cl_bound);
        upper_bound = line_width - sum(param.row_const{line_num}(cl_bound:ch_bound)) - size(param.row_const{line_num}(cl_bound:ch_bound)) + 2;

        for i=1:upper_bound
            if i == 1
                t_line = ones(1, first_clue+1, 'uint8');
                t_line(1:first_clue) = uint8(2);
            else
                t_line(i-1) = 1;
                t_line(i+first_clue-1) = 2;
                t_line(i+first_clue) = 1;
            end

            if any(bitand(state_temp.board(line_num, gl_bound:gl_bound+first_clue+i-1), t_line) == 0)
                flag = false;
                break;
            end

            state_temp.board(line_num, gl_bound:gl_bound+first_clue+i-1) = t_line;
            [state_temp, flag] = Solver.branch_solver(param, state_temp, graphics);

            if flag && ~Util.check_all_complete(param, state_temp)
                [state_temp, flag] = Solver.backtrack_solver(param, state_temp, graphics);
            end

            if ~flag
                state_temp = state;
            else
                state = state_temp;
                return
            end
        end
    else
        line_width = gh_bound - gl_bound + 1;
        first_clue = param.col_const{line_num-param.n_row}(cl_bound);
        upper_bound = line_width - sum(param.col_const{line_num - param.n_row}(cl_bound:ch_bound)) - size(param.col_const{line_num-param.n_row}(cl_bound:ch_bound), 2) + 2;

        for i=1:upper_bound
            if i == 1
                t_line = ones(first_clue+1, 1, 'uint8');
                t_line(1:first_clue) = uint8(2);
            else
                t_line(i-1) = 1;
                t_line(i+first_clue-1) = 2;
                t_line(i+first_clue) = 1;
            end

            if any(bitand(state_temp.board(gl_bound:gl_bound+first_clue+i-1, line_num-param.n_row), t_line) == 0)
                flag = false;
                break;
            end

            state_temp.board(gl_bound:gl_bound+first_clue+i-1, line_num-param.n_row) = t_line;
            [state_temp, flag] = Solver.branch_solver(param, state_temp, graphics);

            if flag && ~Util.check_all_complete(param, state_temp)
                [state_temp, flag] = Solver.backtrack_solver(param, state_temp, graphics);
            end

            if ~flag
                state_temp = state;
            else
                state = state_temp;
                return
            end
        end
    end
end
end