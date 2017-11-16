function ovosp = trainOVOensamble(tset, tlab)
% Trains a set of linear classifiers (one versus one class)
% on the training set using trainSelect function
% tset - training set samples
% tlab - labels of the samples in the training set
% ovosp - one versus one class linear classifiers matrix
%   the first column contains positive class label
%   the second column contains negative class label
%   columns (3:end) contain separating plane coefficients

  labels = unique(tlab);
  
  % nchoosek produces all possible unique pairs of labels
  % that's exactly what we need for ovo classifier
  pairs = nchoosek(labels, 2);
  ovosp = zeros(rows(pairs), 2 + 1 + columns(tset));
  
  for i=1:rows(pairs)
	% store labels in the first two columns
    ovosp(i, 1:2) = pairs(i, :);
	
	% select samples of two digits from the training set
    posSamples = tset(tlab == pairs(i,1), :);
    negSamples = tset(tlab == pairs(i,2), :);
	
	% train 5 classifiers and select the best one
    [errors sp] = trainSelect(posSamples, negSamples ,5);
	
	% what to do with errors?

    % store the separating plane coefficients (this is our classifier)
	% in ovo matrix
    ovosp(i, 3:end) = sp; 
  end
