function [err sp] = trainSelect(positive_samples, negative_samples, reps)
% Performs learning of the linear classifier (reps) times
% and selects the best classifier
% positive_samples - samples of class which should be on the positive side of separating plane
% negative_samples - samples of class which should be on the negative side of separating plane
% reps - number of repetitions of training

% err - percent of samples that were missclassified
% sp - coefficients of the best separating plane

  %                    bias + vector size
  manysp = zeros(reps, 1    + columns(positive_samples));
  errors = zeros(reps, 1);

  for i=1:reps
    [errors(i) manysp(i,:)] = perceptron(positive_samples, negative_samples);
  end
  [err theBestIdx] = min(errors);
  sp = manysp(theBestIdx, :);
end
