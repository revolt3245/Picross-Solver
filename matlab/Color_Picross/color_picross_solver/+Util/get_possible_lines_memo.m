function n_lines = get_possible_lines_memo(s_line, clues)
%% parameter
s_clues = size(clues, 2);

if s_clues == 1
    upper_bound = s_line - clues(1, 1) + 1;
else
    is_next_same_color = clues(2,2:end) == clues(2,1:end-1);

    upper_bound = s_line - sum(is_next_same_color) - sum(clues(1,:)) + 1;
end

n_lines = s_clues * upper_bound;
end