function y = movingAverage(x, Nwindow)
   kkernel = ones(1, Nwindow) ./ Nwindow;
   y = conv(x, kkernel, 'same');
end