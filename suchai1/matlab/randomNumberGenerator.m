function randomVector = randomNumberGenerator( distribution, minValue, maxValue, numberOfValues )

switch distribution
    case 'uniform'
        randomVector = randi([minValue, maxValue], 1, numberOfValues);
    otherwise
        error(strcat(distribution, ' not recognized'));
end
end

