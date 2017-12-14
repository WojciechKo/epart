function res = actdf(sfvalue)
% derivative of sigmoid activation function
% sfvalue - value of sigmoid activation function (!!!)

  res = actf(sfvalue) .* (1 - actf(sfvalue));
