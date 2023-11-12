function n_lines = get_possible_lines_memo(s_line, clues)
%% parameter
s_clues = size(clues, 2);
upper_bound = s_line - sum(clues) + size(clues, 2) + 2;

n_lines = s_clues * upper_bound;
end