function [TIME,CH1,CH2,MATH] = importfileFromTektronix(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [TIME,CH1,CH2,MATH] = IMPORTFILE(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   [TIME,CH1,CH2,MATH] = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data
%   from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [TIME,CH1,CH2,MATH] = importfile('T0001ALL.CSV',16, 1250015);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/03/21 15:33:12

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 16;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column4: double (%f)
%	column8: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%*s%f%*s%*s%*s%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
TIME = dataArray{:, 1};
CH1 = dataArray{:, 2};
CH2 = dataArray{:, 3};
MATH = dataArray{:, 4};


