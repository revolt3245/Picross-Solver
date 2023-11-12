function [o_line, memo] = fill_line_memo(i_line, clues, memo)
s_clues = size(clues, 2);

s_line = size(i_line, 2);
t_line = ones(1, s_line, 'uint8') * uint8(3);

upper_bound = s_line - sum(clues) - s_clues + 2;

if isempty(memo)
    memo = zeros(upper_bound+1, s_line, 'uint8');
end

if s_clues == 1
    for i=1:upper_bound
        if i == 1
            t_line = ones(1, clues(1), 'uint8') * uint8(2);
        else
            t_line = [t_line uint8(1)];
        end

        pre_memo = memo(upper_bound-i+2, upper_bound-i+1:end);
        pre_memo(1) = i ~= 1;

        if any(bitand(i_line(upper_bound-i+1:end), t_line) == 0)
            memo(upper_bound-i+1, upper_bound-i+1:end) = pre_memo;
        elseif any(bitand(i_line(upper_bound-i+1:end), pre_memo) == 0)
            memo(upper_bound-i+1, upper_bound-i+1:end) = t_line;
        else
            memo(upper_bound-i+1, upper_bound-i+1:end) = bitor(t_line, pre_memo);
        end
    end

    o_line = memo(1,:);
elseif s_clues == 0
    o_line = ones(1, s_line, 'uint8');
else
    [~, memo(:, clues(1)+2:end)] = Util.fill_line_memo(i_line(clues(1)+2:end), clues(2:end), memo(:, clues(1)+2:end));
    for i=1:upper_bound
        if i == 1
            t_line = ones(1, clues(1), 'uint8') * uint8(2);
            t_line = [t_line uint8(1) memo(upper_bound-i+1, upper_bound-i+clues(1)+2:end)];
        else
            t_line(clues(1)+2:end) = [];
            t_line = [t_line memo(upper_bound-i+1, upper_bound-i+clues(1)+2:end)];
        end

        pre_memo = memo(upper_bound-i+2, upper_bound-i+1:end);
        pre_memo(1) = i ~= 1;

        if any(bitand(i_line(upper_bound-i+1:end), t_line) == 0)
            memo(upper_bound-i+1, upper_bound-i+1:end) = pre_memo;
        elseif any(bitand(i_line(upper_bound-i+1:end), pre_memo) == 0)
            memo(upper_bound-i+1, upper_bound-i+1:end) = t_line;
        else
            memo(upper_bound-i+1, upper_bound-i+1:end) = bitor(t_line, pre_memo);
        end
    end
    o_line = memo(1,:);
end
end