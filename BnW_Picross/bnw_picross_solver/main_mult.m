clear; clc; close;

%% initialize
fig = figure(Name="picross");
ax = gca;
t = datetime;
t_string = sprintf("%d%02d%02d_%02d%02d%02d/", t.Year, t.Month, t.Day, t.Hour, t.Minute, int32(t.Second));

for i=1:12
    disp("Puzzle "+i);
    cla(ax);
    param = Parameter.get_parameter(file="samples/nonogram_galaxy/5/" + i + ".txt", ...
        save_video=true);
    state = State.get_initial_state(param);
    graphics = Draw.initialize(fig, ax, 0.5, param);

    if param.save_video
        FPS = 60;

        video_folder = "Video/";
        if ~isfolder(video_folder + t_string)
            mkdir(video_folder + t_string);
        end

        filename_video = "Picross";

        graphics.video = VideoWriter(video_folder + t_string + filename_video + i + ".mp4", "MPEG-4");
        graphics.video.FrameRate = FPS;
        graphics.video.Quality = 100;

        graphics.video.open;
    end

    %% solving
    state.tick = tic;
    [state, flag] = Solver.branch_solver(param, state, graphics);

    if flag && ~Util.check_all_complete(param, state)
        [state, flag] = Solver.backtrack_solver(param, state, graphics);
    end

    if ~flag
        disp("This puzzle is not solvable puzzle");
    end

    if param.save_video
        graphics.video.close;
    end

    if param.save_figure
        figure_folder = "Photo/";
        if ~isfolder(figure_folder + t_string)
            mkdir(figure_folder + t_string);
        end

        filename_figure = "Picross";
        saveas(gcf, figure_folder + t_string + filename_figure + i + ".png");
    end
end