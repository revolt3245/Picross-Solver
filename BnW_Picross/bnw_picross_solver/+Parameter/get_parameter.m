function out_param = get_parameter(in_param)
arguments
    in_param.file (1,1) {mustBeFile};

    %% setting
    in_param.save_video (1,1) logical = true;
    in_param.save_figure (1,1) logical = true;
end
%% parameter
out_param = in_param;

%% file read
fid = fopen(in_param.file);

%% row, col
fline = fgetl(fid);

n = sscanf(fline, "%d");
out_param.n_row = n(1);
out_param.n_col = n(2);

%% constraint
out_param.row_const = {};
out_param.col_const = {};

for i=1:out_param.n_row
    r_const = [];
    while isempty(r_const)
        fline = fgetl(fid);

        r_const = sscanf(fline, "%d");
    end

    if r_const == 0
        out_param.row_const{i, 1} = [];
    else
        out_param.row_const{i, 1} = r_const';
    end
end

for i=1:out_param.n_col
    c_const = [];
    while isempty(c_const)
        fline = fgetl(fid);

        c_const = sscanf(fline, "%d");
    end

    if c_const == 0
        out_param.col_const{i, 1} = [];
    else
        out_param.col_const{i, 1} = c_const';
    end
end
fclose(fid);
end