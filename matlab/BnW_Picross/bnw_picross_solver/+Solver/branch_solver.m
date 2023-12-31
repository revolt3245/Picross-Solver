function [state, flag] = branch_solver(param, state, graphics)
%% solving
is_in_queue = true(1, param.n_row + param.n_col);

[pq_lines, pq_ind] = sort(state.n_lines, 2);
pq = [pq_lines
    pq_ind
    state.bounds(:, pq_ind)];

while any(is_in_queue)
    %% pop minimum line
    pq_top = pq(:,1);
    pq(:,1) = [];
    ind_top = pq_top(2);
    gl_bound = pq_top(3);
    gh_bound = pq_top(4);
    cl_bound = pq_top(5);
    ch_bound = pq_top(6);

    is_in_queue(ind_top) = false;

    %% fill line
    if ind_top <= param.n_row
        i_line = state.board(ind_top, gl_bound:gh_bound);
        clues = param.row_const{ind_top}(cl_bound:ch_bound);
        o_line = Util.fill_row_memo(i_line, clues);

        if(any(o_line == 0))
            flag = false;
            return;
        end

        changed = o_line ~= i_line;
        changed = [false(1, gl_bound-1) changed false(1, param.n_col-gh_bound)];
        has_to_push = [false(1, param.n_row) changed] & ~is_in_queue;

        if any(has_to_push)
            new_ind = 1:(param.n_row+param.n_col);
            new_ind = new_ind(has_to_push);

            new_n_lines = state.n_lines(has_to_push);

            pq = [pq [new_n_lines; new_ind; state.bounds(:, new_ind)]];

            [~, pq_ind] = sort(pq(1,:));
            pq = pq(1:end,pq_ind);

            is_in_queue(new_ind) = true;
        end

        %% update state
        state.board(ind_top,gl_bound:gh_bound) = o_line;

        %% bound n_lines update
        new_gl_bound = state.bounds(1, ind_top) + find(o_line == uint8(3), 1, 'first')-1;
        new_gh_bound = state.bounds(1, ind_top) + find(o_line == uint8(3), 1, 'last')-1;

        if ~isempty(new_gl_bound) && ~isempty(new_gh_bound)
            state.bounds(1, ind_top) = new_gl_bound;
            state.bounds(2, ind_top) = new_gh_bound;

            if new_gl_bound ~= gl_bound && ~isempty(new_gl_bound)
                o_line_l = o_line(1:(new_gl_bound-gl_bound));

                check_l = (o_line_l(2:end) == 2) & (o_line_l(1:end-1) == 1);
                check_l = [o_line_l(1) == 2 check_l];

                new_cl_bound = cl_bound + sum(check_l);
                state.bounds(3, ind_top) = new_cl_bound;

                state.row_const{ind_top}(1:new_cl_bound-1) = false;
            end

            if new_gh_bound ~= gh_bound
                o_line_h = o_line(end-gh_bound+(new_gh_bound+1):end);

                check_h = (o_line_h(2:end) == 1) & (o_line_h(1:end-1) == 2);
                check_h = [check_h o_line_h(end) == 2];

                new_ch_bound = ch_bound - sum(check_h);

                state.bounds(4, ind_top) = new_ch_bound;

                state.row_const{ind_top}(new_ch_bound+1:end) = false;
            end

            s_lines = state.bounds(2, ind_top) - state.bounds(1, ind_top)+1;
            s_clues = state.bounds(4, ind_top) - state.bounds(3, ind_top)+1;

            new_clues = param.row_const{ind_top}(state.row_const{ind_top});
            state.n_lines(ind_top) = Util.get_possible_lines(s_lines, new_clues);
        else
            state.row_const{ind_top}(:) = false;
        end
    else
        i_line = state.board(gl_bound:gh_bound,ind_top-param.n_row);
        clues = param.col_const{ind_top-param.n_row}(cl_bound:ch_bound);
        o_line = Util.fill_col_memo(i_line, clues);
        
        if(any(o_line == 0))
            flag = false;
            return;
        end

        changed = o_line ~= i_line;
        changed = [false(gl_bound-1,1)
            changed
            false(param.n_row-gh_bound,1)];

        has_to_push = [changed' false(1, param.n_col)] & ~is_in_queue;

        if any(has_to_push)
            new_ind = 1:(param.n_row+param.n_col);
            new_ind = new_ind(has_to_push);

            new_n_lines = state.n_lines(has_to_push);

            pq = [pq [new_n_lines; new_ind; state.bounds(:, new_ind)]];

            [pq_lines, pq_ind] = sort(pq(1,:));
            pq = pq(:,pq_ind);

            is_in_queue(new_ind) = true;
        end

        %% bound n_lines update
        state.board(gl_bound:gh_bound,ind_top-param.n_row) = o_line;

        %% bound n_lines update
        new_gl_bound = gl_bound + find(o_line == uint8(3), 1, 'first')-1;
        new_gh_bound = gl_bound + find(o_line == uint8(3), 1, 'last')-1;

        if ~isempty(new_gl_bound) && ~isempty(new_gh_bound)
            state.bounds(1, ind_top) = new_gl_bound;
            state.bounds(2, ind_top) = new_gh_bound;

            if new_gl_bound ~= gl_bound && ~isempty(new_gl_bound)
                o_line_l = o_line(1:(new_gl_bound-gl_bound));

                check_l = (o_line_l(2:end) == 2) & (o_line_l(1:end-1) == 1);
                check_l = [o_line_l(1) == 2
                    check_l];

                new_cl_bound = cl_bound + sum(check_l);
                state.bounds(3, ind_top) = new_cl_bound;

                state.col_const{ind_top-param.n_row}(1:new_cl_bound-1) = false;
            end

            if new_gh_bound ~= gh_bound
                o_line_h = o_line(end-gh_bound+(new_gh_bound+1):end);

                check_h = (o_line_h(2:end) == 1) & (o_line_h(1:end-1) == 2);
                check_h = [check_h
                    o_line_h(end) == 2];

                new_ch_bound = ch_bound - sum(check_h);

                state.bounds(4, ind_top) = new_ch_bound;
                state.col_const{ind_top-param.n_row}(new_ch_bound+1:end) = false;
            end

            s_lines = state.bounds(2, ind_top) - state.bounds(1, ind_top)+1;
            s_clues = state.bounds(4, ind_top) - state.bounds(3, ind_top)+1;
            new_clues = param.col_const{ind_top-param.n_row}(state.col_const{ind_top-param.n_row});
            state.n_lines(ind_top) = Util.get_possible_lines(s_lines, new_clues);
        else
            state.col_const{ind_top-param.n_row}(:)=false;
        end
    end
    state.time = toc(state.tick);

    Draw.update(graphics, state, param);
    drawnow;

    if param.save_video
        frame = getframe(gcf);
        writeVideo(graphics.video, frame);
    end
end

flag = true;
end