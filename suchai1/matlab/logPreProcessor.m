function [fileDir, varargout] = logPreProcessor(rawLogFilePath, saveFolder, varargin)
switch varargin{1}
    case 'input'
        reglInput = 'rand() = ';
        regrInput = ' ';
        regEOF = 'pay_print_seed ... finished';
        
        values = [];
        fid = fopen(rawLogFilePath);
        disp(['preprocessing file ',rawLogFilePath, 'as input']);
        tline = fgets(fid);
        while ischar(tline)
            if  ~isempty(  strfind( tline, regEOF ) )
                break
            elseif  ~isempty(  strfind( tline, reglInput ) )
                indexl = strfind( tline, reglInput );
                indexl = indexl + length( reglInput );
                tmp = tline ( indexl : end );
                indexr = strfind( tmp, regrInput );
                nextValue = str2double( tmp( 1 : indexr - 1 ) );
                values = [values; nextValue];
            end
            tline = fgets(fid);
        end
        fclose(fid);
        fileDir{1} = printBufferToFile(values, saveFolder, 'input');
        
    case 'output'
        fid = fopen(rawLogFilePath);
        disp(['preprocessing file ',rawLogFilePath, 'as output']);
        N = varargin{2};
        fileDir = {};
        
        hasExec = true;
        index = N;
        [buffer, hasExec] = processOneOutput(fid);
        disp(strcat('file ',num2str(index), ' processed to a buffer'));
        fileDir{index} = printBufferToFile(buffer, saveFolder ,'output', index);
        disp(strcat('buffer ',num2str(index), ' printed to file ', fileDir{index}));
        
        fclose(fid);
        
    case 'telemetry-output'
        fid = fopen(rawLogFilePath);
        disp(['preprocessing file ',rawLogFilePath, 'as output']);
        fileDir = {};
        
        index = 1;
        adcPeriod = varargin{2};
        [buffer, tmParams] = processOneTelemetry(fid, adcPeriod);
        disp(strcat('file ',rawLogFilePath, ' processed to a buffer'));
        fileDir{index} = printBufferToFile(buffer, saveFolder ,'output', index);
        disp(strcat('buffer ',num2str(index), ' printed to file ', fileDir{index}));
        
        fclose(fid);
        varargout{1} = tmParams;
        
    case 'telemetry-input'
        reglInput = 'rand() = ';
        regrInput = ' ';
        regEOF = 'pay_print_seed ... finished';
        tmParams = varargin{2};
        lostPointsIndex = tmParams.pairedLostPoints;
        
        values = [];
        fid = fopen(rawLogFilePath);
        disp(['preprocessing file ',rawLogFilePath, 'as input']);
        tline = fgets(fid);
        while ischar(tline)
            if  ~isempty(  strfind( tline, regEOF ) )
                break
            elseif  ~isempty(  strfind( tline, reglInput ) )
                indexl = strfind( tline, reglInput );
                indexl = indexl + length( reglInput );
                tmp = tline ( indexl : end );
                indexr = strfind( tmp, regrInput );
                nextValue = str2double( tmp( 1 : indexr - 1 ) );
                values = [values; nextValue];
            end
            tline = fgets(fid);
        end
        fclose(fid);

        values(lostPointsIndex) = [];
        fileDir{1} = printBufferToFile(values, saveFolder, 'input');
        
    otherwise
        error(['The argument' ' "' varargin{1} '" ' 'is not recognized']);
end
end