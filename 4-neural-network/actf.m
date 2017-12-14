function res = actf(tact)
% sigmoid activation function
% tact - total activation

  res = 1 ./ (1 + e.^-tact);
