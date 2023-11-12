function out_param = get_parameter(in_param)
arguments
    in_param.file (1,1) {mustBeFile};

    %% setting
    in_param.save_video (1,1) logical = true;
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
out_param.n_color = n(3);

%% color map
for i = 1:out_param.n_color
    color_vec = [];
    while isempty(color_vec)
        fline = fgetl(fid);

        color_vec = sscanf(fline, "%d");
    end

    out_param.color_map(i,:) = color_vec/255;
end

%% constraint
out_param.row_const = {};
out_param.col_const = {};

for i=1:out_param.n_row
    r_const = [];
    while isempty(r_const)
        fline = fgetl(fid);

        r_const = sscanf(fline, "%d");
    end

    out_param.row_const{i, 1} = r_const';
end

for i=1:out_param.n_col
    c_const = [];
    while isempty(c_const)
        fline = fgetl(fid);

        c_const = sscanf(fline, "%d");
    end
    out_param.col_const{i, 1} = c_const';
end

%% color const
for i=1:out_param.n_row
    r_const = [];
    while isempty(r_const)
        fline = fgetl(fid);

        r_const = sscanf(fline, "%d");
    end

    out_param.row_const{i}(2,:) = r_const';
end

for i=1:out_param.n_col
    c_const = [];
    while isempty(c_const)
        fline = fgetl(fid);

        c_const = sscanf(fline, "%d");
    end
    out_param.col_const{i}(2,:) = c_const';
end
fclose(fid);
end