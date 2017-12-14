format short g
% EPART - linear classification

[train_vectors train_labels test_vectors test_labels] = readSets();
% we have image data and labels in separate matrices this time
% let's look at our data
[size(train_vectors) size(train_labels)];
[size(test_vectors) size(test_labels)];

unique(train_labels);
unique(test_labels);
labels = unique(train_labels)';

% how many samples of individual digits are there?
[labels; sum(train_labels == labels)];
[labels; sum(test_labels == labels)];

% are these real digits?
% we need to transpose and invert image
imshow(1 - reshape(train_vectors(1,:), 28, 28)');

% let's return to work
% the first problem are the labels - zero is not a valid index
% we map digit to more convenient labels by simple shift
train_labels += 1;
test_labels += 1;

% '0' has label 1 now; '1' -> 2 and so on
labels = unique(train_labels)';
[labels; sum(train_labels == labels)];

% now it's time to reduce dimensionality of our data
% today 57 primary components seems to be right choice :)
[mean transformation_matrix] = prepTransform(train_vectors, 50);

train_vectors = pcaTransform(train_vectors, mean, transformation_matrix);
test_vectors = pcaTransform(test_vectors, mean, transformation_matrix);

% after transformation we're ready to prepare
% linear classifiers' ensemble


%%%% YOUR CODE GOES HERE %%%%

# Task 1
testPerceptron

% (some work is hidden deep in trainOVOensemble dependencies)
[errors, ovo] = trainOVOensamble(train_vectors, train_labels);

# Task 2
[ovo(:,1:2) errors]

% let's classify something (lincls to modify)
votes = voting(train_vectors, ovo);

% what's the result of voting
votes(1:8, :);

% produce classification decisions
[mv mid] = max(votes, [], 2);
train_classification = mid;

% add reject desision when there's disagreement
train_classification(mv ~= 9) = 11;

train_cfmx = confMx(train_labels, train_classification)
train_errcf = compErrors(train_cfmx)

% Task 3
canonical_votes = voting(test_vectors, ovo);

% produce classification decisions
[mv mid] = max(canonical_votes, [], 2);
canonical_classification = mid;

% add reject desision when there's disagreement
canonical_classification(mv ~= 9) = 11;

canonical_cfmx = confMx(test_labels, canonical_classification)
canonical_errcf = compErrors(canonical_cfmx)

[sorted_confident, sorted_number] = sort(canonical_votes, 2);

classification = zeros(rows(sorted_confident), 1);
for i=10:-1:8
  doubtless = sorted_confident(:,i) != sorted_confident(:,i-1);
  not_set = classification == 0;

  classification(not_set & doubtless) = sorted_number(not_set & doubtless, i);
  classification(not_set & !doubtless) = 11;

  errcf = compErrors(confMx(test_labels, classification))
end

cfmx = confMx(test_labels, classification)

% after that you can start experiments with
% a better classification approach