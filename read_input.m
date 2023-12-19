function data = read_input(directory)

files = dir([directory, '*.txt']);

for i=1:length(files)
    data{i} = readmatrix([directory,files(i).name]); %Reading file
end

end