clear; clc; close;

%% initialize
fig = figure(Name="picross");
ax = gca;

param = Parameter.get_parameter(file="samples/30/sample2.txt", ...
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

    graphics.video = VideoWriter(video_folder + filename + t_string + ".mp4", "MPEG-4");
    graphics.video.FrameRate = FPS;
    graphics.video.Quality = 100;

    graphics.video.open;

    frame = getframe(gcf);
    writeVideo(graphics.video, frame);
end
%% solving

state.tick = tic;
[state, flag] = Solver.branch_solver(param, state, graphics);

if flag && ~Util.check_all_complete(param, state)
    [state, flag] = Solver.backtrack_solver(param, state, graphics);
end

if ~flag
    disp("Cannot be solvable");
end

if param.save_video
    graphics.video.close;
end