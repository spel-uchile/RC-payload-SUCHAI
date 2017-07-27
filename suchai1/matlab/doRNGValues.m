seed = 0;
rng(seed,'twister');
generator = rng;

samples = 64000;
coeff = 4;
inb4 = 500;
buffersize = 400;
points = samples/coeff;
pointsBuffer = buffersize/coeff;
rounds = points/pointsBuffer;
N = (inb4 + pointsBuffer)*rounds;
minValue = 0;
maxValue = 2^15;

v = randomNumberGenerator('uniform', minValue, maxValue, N);
v = 2.*v;