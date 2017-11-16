load iris2.txt
load iris3.txt

% 1nn classifier

% Input:
% ts - training set, each row contains one sample
%      first row contains class label
% x  - sample to be classified (doesn't contain label)

% Output:
% label - label of the x's nearest neighbour in the ts
function label = cls1nn(ts, x)
  diff = ts(:,2:end) - repmat(x, rows(ts), 1);
  dist = sumsq(diff, 2);
  [~, idx] = min(dist);
  label = ts(idx, 1);
end

% Performs leave-on-out test of cls1nn classifier on ts

% Input:
% ts - training set, each row contains one sample
%      first row contains class label

% Output:
% errorcf - error coefficient of classification
function errorcf = jackknife(ts)
  clsres = zeros(rows(ts), 1);

  for i = 1:rows(ts)
    training_set = ts(1:end != i, :);
    test_example = ts(i, 2:end); % Only data, withou class information
    clsres(i) = cls1nn(training_set, test_example);
  end

  errorcf = mean(clsres != ts(:, 1));
end

% Assign classes
iris2(:,1) = 2;
iris3(:,1) = 3;

test_set = [iris2; iris3];
errorcf = jackknife(test_set)
