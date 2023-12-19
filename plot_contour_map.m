function plot_contour_map_with_mesh(data, displacement)
    % This function plots a contour map with the original mesh as background
    % data - the struct containing mesh data (coordinates and connectivity)
    % displacement - the displacement vector for each node
    
    % Extract x and y displacements
    x_displacement = displacement(1:2:end); % Odd indices are x-displacements
    y_displacement = displacement(2:2:end); % Even indices are y-displacements
    % Calculate the magnitude of displacement
    displacement_magnitude = sqrt(x_displacement.^2 + y_displacement.^2);
    
    % Initialize the figure
    figure;
    hold on;
    
    % Plot the original mesh as background
    for i = 1:size(data.elemconn, 1)
        nodes = data.elemconn(i, :);
        x = data.coord(nodes, 1);
        y = data.coord(nodes, 2);
        patch('Vertices', [x, y], 'Faces', [1, 2, 3, 4], ...
              'EdgeColor', [0.6 0.6 0.6], 'FaceColor', 'none');
    end
    
    % Get the number of elements
    numElements = size(data.elemconn, 1);
    
    % Initialize a matrix to hold all the z-values for the contour plot
    Z = zeros(numElements, 1);
    
    % Loop over each element to get the average z-value
    for i = 1:numElements
        % Get the node indices for the current element
        nodes = data.elemconn(i,:);
        
        % Get the average displacement magnitude for the current element
        Z(i) = mean(displacement_magnitude(nodes));
    end
    
    % Create a patch object for each element with the average z-value
    for i = 1:numElements
        % Get the node indices for the current element
        nodes = data.elemconn(i,:);
        % Get the x and y coordinates for the current element
        x = data.coord(nodes, 1);
        y = data.coord(nodes, 2);
        % Create a patch for the current element with interpolated face color
        patch('Vertices', [x, y], 'Faces', [1, 2, 3, 4], ...
              'FaceVertexCData', displacement_magnitude(nodes), ...
              'FaceColor', 'interp', 'EdgeColor', 'none');
    end
    
    % Adjust the color scale and add a colorbar
    colormap('default'); 
    caxis([min(Z), max(Z)]); % Set the limits of the color scale
    colorbar; % Show the color scale
    
    % Add labels and title
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title('Displacement Magnitude Contour Plot with Mesh Background');
    
    % Finish the plot
    hold off;
end
