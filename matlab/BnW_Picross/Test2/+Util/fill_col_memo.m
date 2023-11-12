function o_line = fill_col_memo(i_line, clues)
[o_line, ~] = Util.fill_line_memo(i_line', clues, []);
o_line = o_line';
end