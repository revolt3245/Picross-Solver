function [lmat, l_max] = get_longest_length(cell_array)
%% 
paddedMatrix = cellfun(@(x) [x(1,:), NaN(1, max(cellfun(@length, cell_array)) - size(x, 2))], cell_array, 'UniformOutput', false);
NumericMatrix = cell2mat(paddedMatrix);

lmat = sum(~isnan(NumericMatrix), 2);
l_max = max(lmat);
end