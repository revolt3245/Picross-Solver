function o_line = fill_line(i_line, clues)
s_clues = size(clues, 2);

s_line = size(i_line, 2);
o_line = zeros(1, s_line, 'uint8');
t_line = ones(1, s_line, 'uint8') * uint8(3);

upper_bound = s_line - sum(clues) - s_clues + 2;

if s_clues == 1
    for i=1:upper_bound
        if i == 1
            t_line(1:clues(1)) = uint8(2);
            if s_line > clues(1)
                t_line(clues(1)+1:end) = uint8(1);
            end
        else
            t_line(i-1) = uint8(1);
            t_line(i+clues(1)-1) = uint8(2);
        end

        if any(bitand(i_line, t_line) == 0)
            continue
        end

        o_line = bitor(o_line, t_line);
    end
else
    for i=1:upper_bound
        if i == 1
            t_line(1:clues(1)) = uint8(2);
        else
            t_line(i-1) = uint8(1);
            t_line(i+clues(1)-1) = uint8(2);
        end

        t_line(i+clues(1)) = uint8(1);

        if any(bitand(i_line, t_line) == 0)
            continue
        end

        b_line = Util.fill_line(i_line(i+clues(1)+1:end), clues(2:end));

        if any(b_line == 0)
            continue
        end
        
        o_line(1:i+clues(1)) = bitor(o_line(1:i+clues(1)), t_line(1:i+clues(1)));
        o_line(i+clues(1)+1:end) = bitor(o_line(i+clues(1)+1:end), b_line);
    end
end
end