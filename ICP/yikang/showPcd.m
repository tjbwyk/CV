for i = 0 : 99
    filename = sprintf('../data/%010d_filtered.txt', i);
    data = load(filename);
    plot3(data(:, 1), data(:, 2), data(:, 3), '.');
    grid on;
    view(0, 0);
    pause(0.1);
end