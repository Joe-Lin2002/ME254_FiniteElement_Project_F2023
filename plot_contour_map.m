function plot_contour_map(data, displacement)
    % Extract horizontal and vertical displacements
    hori_disp = displacement(1:2:end);
    vert_disp = displacement(2:2:end);

    % Create a grid of points covering the entire domain
    coordinates_all = [data.coord(:,1), data.coord(:,2)];
    [xq, yq] = meshgrid(linspace(min(coordinates_all(:,1)), max(coordinates_all(:,1)), 500), ...
                         linspace(min(coordinates_all(:,2)), max(coordinates_all(:,2)), 500));
    
    % Interpolate displacements onto the grid
    hori_disp_grid = griddata(coordinates_all(:,1), coordinates_all(:,2), hori_disp, xq, yq, 'linear');
    vert_disp_grid = griddata(coordinates_all(:,1), coordinates_all(:,2), vert_disp, xq, yq, 'linear');

    % Plot contour
    figure;
    contourf(xq, yq, sqrt(hori_disp_grid.^2 + vert_disp_grid.^2)); % Plotting magnitude of displacement
    colorbar;
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title('Contour Map of Displacements');
    hold on;
    plot(coordinates_all(:,1), coordinates_all(:,2), 'kx'); % Plotting the nodal points
    hold off;
end
