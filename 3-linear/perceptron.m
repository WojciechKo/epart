function [errors sepplane] = perceptron(positive_samples, negative_samples, learning_rate = 0.00005)
% Computes separating plane (linear classifier) using
% perceptron method
% positive_samples - 'positive' class (one row contains one sample)
% negative_samples - 'negative' class (one row contains one sample)

% sepplane - row vector of separating plane coefficients

  %                  bias + vector size      - mean
  sepplane = rand(1, 1    + columns(positive_samples)) - 0.5;
  tset = [ones(rows(positive_samples), 1) positive_samples; -ones(rows(negative_samples), 1) negative_samples];

  i = 1;
  do
    %%% YOUR CODE GOES HERE %%%
    %% You should:
    %% 1. Check which samples are misclassified (boolean column vector)
    classify = (sepplane * [ones(rows(tset), 1) tset(:,2:end)]')';
    missed = (tset(:,1) == 1 & classify(:,1) < 0) | (tset(:,1) == -1 & classify(:,1) >= 0);

    %% 2. Compute separating plane correction
    %%		This is sum of misclassfied samples coordinate times learning rate
    delta_sepplane = (classify(missed) - tset(missed, 1))' * [ones(rows(tset(missed)),1) tset(missed,2:end)] * learning_rate;

    %% 3. Modify solution (i.e. sepplane)
    sepplane = sepplane - delta_sepplane;

    %% 4. Optionally you can include additional conditions to the stop criterion
    %%		200 iterations can take a while and probably in most cases is unnecessary
    ++i;
  until i > 200;

  %%% YOUR CODE GOES HERE %%%
  %% You should:
  %% 1. Compute number of errors (or error coefficient) and set errors output variable
  %% 	(and of course modify properly description of the function)
  errors = mean(missed);
end
