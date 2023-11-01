function n_lines = get_possible_lines(s_line, clues)
%% parameter
s_clues = size(clues, 2);

n_lines = nchoosek(s_line-sum(clues)+1, s_clues);
end