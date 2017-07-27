function [sstateIndexArray, comparationSignalCollection, missedPoints] = findSState(mode, signal, varargin)

refLevel = mean(signal);
sstateIndexArray = [];
comparationSignalCollection = [];
missedPoints = 0;
tolerance = 5e-3;
span = 2e-3;
switch mode
    case 'simple'
        [sstateIndexArray, comparationSignalCollection] = findSStateSimple(signal, refLevel, tolerance, span);
        missedPoints = sstateIndexArray;
    case 'buffered'
        if nargin < 3
            error('not enough arguments');
        end
        buffLen = varargin{1};
        rounds = ceil(length(signal)/buffLen);
        for i = 1 : rounds
            slicedSignal = signal(1+(i-1)*buffLen: i*buffLen);
            [tempIndex, tempSignal] = findSStateSimple(slicedSignal, refLevel, tolerance, span); 
            missedPoints = missedPoints + tempIndex-1;
            sstateIndexArray = [sstateIndexArray; tempIndex];
            comparationSignalCollection = [comparationSignalCollection; tempSignal];
        end
    otherwise
        error('invalid first argument, it must be "cummean" or "local"');
end
end

