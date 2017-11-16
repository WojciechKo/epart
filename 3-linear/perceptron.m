function [errors sepplane] = perceptron(pclass, nclass)
% Computes separating plane (linear classifier) using
% perceptron method
% pclass - 'positive' class (one row contains one sample)
% nclass - 'negative' class (one row contains one sample)
% sepplane - row vector of separating plane coefficients

  sepplane = rand(1, columns(pclass) + 1) - 0.5;
  tset = [ ones(rows(pclass), 1) pclass; -ones(rows(nclass), 1) -nclass];

  i = 1;
  do
    %%% YOUR CODE GOES HERE %%%
    %% You should:
    %% 1. Check which samples are misclassified (boolean column vector)
    %% 2. Compute separating plane correction 
    %%		This is sum of misclassfied samples coordinate times learning rate 
    %% 3. Modify solution (i.e. sepplane)

    %% 4. Optionally you can include additional conditions to the stop criterion
    %%		200 iterations can take a while and probably in most cases is unnecessary
    ++i;
  until i > 200;

  %%% YOUR CODE GOES HERE %%%
  %% You should:
  %% 1. Compute number of errors (or error coefficient) and set errors output variable
  %% 	(and of course modify properly description of the function)

  errors = 0.05;
end
