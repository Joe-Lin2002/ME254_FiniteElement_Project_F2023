function plot_stress_contour_map(data, nodal_stress)
    % Extract stress components
    sigma_x = nodal_stress(:, 1);
    sigma_y = nodal_stress(:, 2);
    tau_xy = nodal_stress(:, 3);
    von_Mises_stress = sqrt(sigma_x.^2 - sigma_x.*sigma_y + sigma_y.^2 + 3.*tau_xy.^2);

    % Create a grid of points covering the entire domain
    coordinates_all = [data.coord(:,1), data.coord(:,2)];
    [xq, yq] = meshgrid(linspace(min(coordinates_all(:,1)), max(coordinates_all(:,1)), 500), ...
                         linspace(min(coordinates_all(:,2)), max(coordinates_all(:,2)), 500));

    % Interpolate stresses onto the grid
    sigma_x_grid = griddata(coordinates_all(:,1), coordinates_all(:,2), sigma_x, xq, yq, 'linear');
    sigma_y_grid = griddata(coordinates_all(:,1), coordinates_all(:,2), sigma_y, xq, yq, 'linear');
    von_Mises_stress_grid = griddata(coordinates_all(:,1), coordinates_all(:,2), von_Mises_stress, xq, yq, 'linear');

    % Create figure and subplots
    figure;

    % Subplot for von Mises stress
    subplot(3, 1, 1);
    contourf(xq, yq, von_Mises_stress_grid);
    colorbar;
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title('von Mises Stress');
    axis square; % Set square aspect ratio

    % Subplot for sigma_x
    subplot(3, 1, 2);
    contourf(xq, yq, sigma_x_grid);
    colorbar;
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title('Stress in X Direction');
    axis square; % Set square aspect ratio

    % Subplot for sigma_y
    subplot(3, 1, 3);
    contourf(xq, yq, sigma_y_grid);
    colorbar;
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title('Stress in Y Direction');
    axis square; % Set square aspect ratio

    % Plot nodal points on each subplot
    for i = 1:3
        subplot(3, 1, i);
        hold on;
        plot(coordinates_all(:,1), coordinates_all(:,2), 'k.'); % Plotting the nodal points
        hold off;
    end
end
