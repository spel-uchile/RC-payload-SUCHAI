rootFolder = './logs/suchai/';
files = dir(rootFolder);
files = files(arrayfun(@(x) ~strcmp(x.name(1),'.'), files));
dirFlags = [files.isdir];
subfolder = files(dirFlags);
foldernames = {subfolder.name};
latTM = zeros(size(subfolder));
longTM = zeros(size(subfolder));

for i = 1 : numel(subfolder)
    path = strcat(rootFolder,foldernames{i},'/' );
    filesInside = dir(path);
    filesInside = filesInside(arrayfun(@(x) ~strcmp(x.name(1),'.'), filesInside));
    dirFlags = [filesInside.isdir];
    filenames = {filesInside.name};
    filenames(dirFlags) = [];
    indexLocFile = strfind(filenames, '-location');
    indexLocFile = find(not(cellfun('isempty', indexLocFile)));
    
    locfile = filenames{indexLocFile(1)};
    fid = fopen([path, locfile]);
    tline = fgets(fid);
    latTM(i) = sscanf(tline,'LAT %f');
    tline = fgets(fid);
    longTM(i) = sscanf(tline,'LONG %f');
    fclose(fid);
end

worldmap('World');
load coast;
plotm(lat, long);
hold on;
plotm(latTM, longTM, 'ro');