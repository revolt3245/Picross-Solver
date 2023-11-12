clear; clc; close;

%% initialize
fig = figure(Name="picross");
ax = gca;

param = Parameter.get_parameter(file="sample5.txt", ...
    save_video=true);
state = State.get_initial_state(param);
graphics = Draw.initialize(fig, ax, 0.5, param);

%% video setting

if param.save_video
    FPS = 60;

    video_folder = "Video/";
    if ~isfolder(video_folder)
        mkdir(video_folder);
    end

    filename = "Picross";

    t = datetime;
    t_string = sprintf("_%d%02d%02d_%02d%02d%02d", t.Year, t.Month, t.Day, t.Hour, t.Minute, int32(t.Second));

    video = VideoWriter(video_folder + filename + t_string + ".mp4", "MPEG-4");
    video.FrameRate = FPS;
    video.Quality = 100;

    video.open;

    frame = getframe(gcf);
    writeVideo(video, frame);
end
%% solving
n_lines = zeros(1, param.n_row + param.n_col);
bounds = [ones(1, param.n_row+param.n_col)
    param.n_col*ones(1,param.n_row) param.n_row*ones(1,param.n_col)
    ones(1, param.n_row+param.n_col)
    zeros(1, param.n_row + param.n_col)];

for i = 1:(param.n_col + param.n_row)
    if i <= param.n_row
        n_lines(i) = Util.get_possible_lines(param.n_col, param.row_const{i});
        bounds(4, i) = size(param.row_const{i}, 2);
    else
        n_lines(i) = Util.get_possible_lines(param.n_row, param.col_const{i-param.n_row});
        bounds(4, i) = size(param.col_const{i-param.n_row}, 2);
    end
end

is_in_queue = true(1, param.n_row + param.n_col);

[pq_lines, pq_ind] = sort(n_lines, 2);
pq = [pq_lines
    pq_ind
    bounds(:, pq_ind)];

tic;
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
        o_line = Util.fill_row(i_line, clues);

        changed = o_line ~= i_line;
        changed = [false(1, gl_bound-1) changed false(1, param.n_col-gh_bound)];
        has_to_push = [false(1, param.n_row) changed] & ~is_in_queue;

        if any(has_to_push)
            new_ind = 1:(param.n_row+param.n_col);
            new_ind = new_ind(has_to_push);

            new_n_lines = n_lines(has_to_push);

            pq = [pq [new_n_lines; new_ind; bounds(:, new_ind)]];

            [~, pq_ind] = sort(pq(1,:));
            pq = pq(1:end,pq_ind);

            is_in_queue(new_ind) = true;
        end

        %% update state
        state.board(ind_top,gl_bound:gh_bound) = o_line;

        %% bound n_lines update
        new_gl_bound = bounds(1, ind_top) + find(o_line == uint8(3), 1, 'first')-1;
        new_gh_bound = bounds(1, ind_top) + find(o_line == uint8(3), 1, 'last')-1;

        if ~isempty(new_gl_bound) && ~isempty(new_gh_bound)
            bounds(1, ind_top) = new_gl_bound;
            bounds(2, ind_top) = new_gh_bound;

            if new_gl_bound ~= gl_bound && ~isempty(new_gl_bound)
                o_line_l = o_line(1:(new_gl_bound-gl_bound));

                check_l = (o_line_l(2:end) == 2) & (o_line_l(1:end-1) == 1);
                check_l = [o_line_l(1) == 2 check_l];

                new_cl_bound = cl_bound + sum(check_l);
                bounds(3, ind_top) = new_cl_bound;

                state.row_const{ind_top}(1:new_cl_bound-1) = false;
            end

            if new_gh_bound ~= gh_bound
                o_line_h = o_line(end-gh_bound+(new_gh_bound+1):end);

                check_h = (o_line_h(2:end) == 1) & (o_line_h(1:end-1) == 2);
                check_h = [check_h o_line_h(end) == 2];

                new_ch_bound = ch_bound - sum(check_h);

                bounds(4, ind_top) = new_ch_bound;

                state.row_const{ind_top}(new_ch_bound+1:end) = false;
            end

            s_lines = bounds(2, ind_top) - bounds(1, ind_top)+1;
            s_clues = bounds(4, ind_top) - bounds(3, ind_top)+1;
            n_lines(ind_top) = Util.get_possible_lines(s_lines, s_clues);
        else
            state.row_const{ind_top}(:) = false;
        end
    else
        i_line = state.board(gl_bound:gh_bound,ind_top-param.n_row);
        clues = param.col_const{ind_top-param.n_row}(cl_bound:ch_bound);
        o_line = Util.fill_col(i_line, clues);

        changed = o_line ~= i_line;
        changed = [false(gl_bound-1,1)
            changed
            false(param.n_row-gh_bound,1)];

        has_to_push = [changed' false(1, param.n_col)] & ~is_in_queue;

        if any(has_to_push)
            new_ind = 1:(param.n_row+param.n_col);
            new_ind = new_ind(has_to_push);

            new_n_lines = n_lines(has_to_push);

            pq = [pq [new_n_lines; new_ind; bounds(:, new_ind)]];

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
            bounds(1, ind_top) = new_gl_bound;
            bounds(2, ind_top) = new_gh_bound;

            if new_gl_bound ~= gl_bound && ~isempty(new_gl_bound)
                o_line_l = o_line(1:(new_gl_bound-gl_bound));

                check_l = (o_line_l(2:end) == 2) & (o_line_l(1:end-1) == 1);
                check_l = [o_line_l(1) == 2
                    check_l];

                new_cl_bound = cl_bound + sum(check_l);
                bounds(3, ind_top) = new_cl_bound;

                state.col_const{ind_top-param.n_row}(1:new_cl_bound-1) = false;
            end

            if new_gh_bound ~= gh_bound
                o_line_h = o_line(end-gh_bound+(new_gh_bound+1):end);

                check_h = (o_line_h(2:end) == 1) & (o_line_h(1:end-1) == 2);
                check_h = [check_h
                    o_line_h(end) == 2];

                new_ch_bound = ch_bound - sum(check_h);

                bounds(4, ind_top) = new_ch_bound;
                state.col_const{ind_top-param.n_row}(new_ch_bound+1:end) = false;
            end

            s_lines = bounds(2, ind_top) - bounds(1, ind_top)+1;
            s_clues = bounds(4, ind_top) - bounds(3, ind_top)+1;
            n_lines(ind_top) = Util.get_possible_lines(s_lines, s_clues);
        else
            state.col_const{ind_top-param.n_row}(:)=false;
        end
    end
    state.time = toc;

    Draw.update(graphics, state, param);
    drawnow;

    if param.save_video
        frame = getframe(gcf);
        writeVideo(video, frame);
    end
end

if param.save_video
    video.close;
end