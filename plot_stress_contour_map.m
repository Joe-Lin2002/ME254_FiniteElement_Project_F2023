function plot_stress_contour_map(data, nodal_stress)
    % Calculate von Mises stress at each node
    sigma_x = nodal_stress(:, 1);
    sigma_y = nodal_stress(:, 2);
    tau_xy = nodal_stress(:, 3);
    von_Mises_stress = sqrt(sigma_x.^2 - sigma_x.*sigma_y + sigma_y.^2 + 3.*tau_xy.^2);
    
    % Create a grid of points covering the entire domain
    coordinates_all = [data.coord(:,1), data.coord(:,2)];
    [xq, yq] = meshgrid(linspace(min(coordinates_all(:,1)), max(coordinates_all(:,1)), 500), ...
                         linspace(min(coordinates_all(:,2)), max(coordinates_all(:,2)), 500));
    
    % Interpolate von Mises stress onto the grid
    von_Mises_stress_grid = griddata(coordinates_all(:,1), coordinates_all(:,2), von_Mises_stress, xq, yq, 'linear');

    % Plot contour of von Mises stress
    figure;
    contourf(xq, yq, von_Mises_stress_grid);
    colorbar;
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title('Contour Map of von Mises Stress');
    hold on;
    plot(coordinates_all(:,1), coordinates_all(:,2), 'k.'); % Plotting the nodal points
    hold off;
end
