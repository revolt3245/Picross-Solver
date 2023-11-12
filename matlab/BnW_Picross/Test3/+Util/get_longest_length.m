function [lmat, l_max] = get_longest_length(cell_array)
%% 
paddedMatrix = cellfun(@(x) [x, NaN(1, max(cellfun(@length, cell_array)) - length(x))], cell_array, 'UniformOutput', false);
NumericMatrix = cell2mat(paddedMatrix);

lmat = sum(~isnan(NumericMatrix), 2);
l_max = max(lmat);
end