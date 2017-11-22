function [errCnt sp] = trainSelect(posc, negc, reps)
% Performs learning of the linear classifier (reps) times
% and selects the best classifier
% posc - samples of class which should be on the positive side of separating plane
% negc - samples of class which should be on the negative side of separating plane
% reps - number of repetitions of training

% errCnt - number of errors of the linear classifier sp  on the training set
% sp - coefficients of the best separating plane

  %                    bias + vector size
  manysp = zeros(reps, 1    + columns(posc));
  errors = zeros(reps, 1);

  for i=1:reps
    [errors(i) manysp(i,:)] = perceptron(posc, negc);
  end
  [errCnt theBestIdx] = min(errors);
  sp = manysp(theBestIdx, :);
end
