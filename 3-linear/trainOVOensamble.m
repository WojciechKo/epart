function [errors, ovosp] = trainOVOensamble(training_values, train_labels)
% Trains a set of linear classifiers (one versus one class)
% on the training set using trainSelect function
% training_values - training set samples
% train_labels - labels of the samples in the training set

% ovosp - one versus one class linear classifiers matrix
%         the first column contains positive class label
%         the second column contains negative class label
%         columns (3:end) contain separating plane coefficients

  labels = unique(train_labels);

  % nchoosek produces all possible unique pairs of labels
  % that's exactly what we need for ovo classifier
  pairs = nchoosek(labels, 2);

  %                          labels + bias + vector size
  ovosp = zeros(rows(pairs), 2      + 1    + columns(training_values));
  errors = zeros(rows(pairs), 1);

  for i=1:rows(pairs)
	% store labels in the first two columns
    ovosp(i, 1:2) = pairs(i, :);

	% select samples of two digits from the training set
    posSamples = training_values(train_labels == pairs(i,1), :);
    negSamples = training_values(train_labels == pairs(i,2), :);

	% train 5 classifiers and select the best one
    [err sp] = trainSelect(posSamples, negSamples ,5);

	% what to do with error?
    errors(i,:) = err;

    % store the separating plane coefficients (this is our classifier)
	% in ovo matrix
    ovosp(i, 3:end) = sp;
  end
end
