% Filter out the data that belong to the background

for i = 0 : 99
    infilename = sprintf('data/%010d.pcd', i);
    data = readPcd(infilename);
    v = [];
    for j = 1 : length(data)
        if (data(j, 3) > 3)
            v = [v, j];
        end
    end
    data(v, :) = [];
    data(:, 4) = [];
    outfilename = sprintf('data/%010d_filtered.txt', i);
    dlmwrite(outfilename, data, ',');
end