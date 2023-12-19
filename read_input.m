function data = read_input(directory)

files = dir([directory, '*.txt']);

for i=1:length(files)
    data.(files(i).name(1:end-4)) = load([directory,files(i).name]); %Reading file
end

end