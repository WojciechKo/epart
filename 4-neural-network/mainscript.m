% load data and remap labels
format short g
more off

[train_set train_labels test_set test_labels] = readSets();
train_labels += 1;
test_labels += 1;

% remove columns with zero std
toRemove = std(train_set) != 0;
train_set = train_set(:, toRemove);
test_set = test_set(:, toRemove);

train_set = train_set(1:rows(train_set) / 10, :);
train_labels = train_labels(1:rows(train_labels) / 10, :);

test_set = test_set(1:rows(test_set) / 10, :);
test_labels = test_labels(1:rows(test_labels) / 10, :);


% Data is ready - first prepare ANN classifier
% we'll need:
%	activation function (actf)
%	two matrices containing weights of our ANN
%		let's close this code in separate function (crann)
%	classifier function itself

%x = -5:0.1:5;
%plot(x, actf(x));

function test_backprop()
  % xor data set
  xor_set = [-1 1; 1 1; 1 -1; -1 -1];
  xor_labels = [1; 2; 1; 2];

  %xor_set = [-2 1; -2 -1; -1 2; 1 2; -1 1; 1 1; 1 -1; -1 -1];
  %xor_labels = [4; 4; 3; 3; 2; 2; 1; 1];

  [hidl, outl] = crann(columns(xor_set), 5, rows(unique(xor_labels)));

  res = anncls(xor_set, hidl, outl);
  cmx = confMx(xor_labels, res)
  printf("Correct: %.3f%%, Error: %.3f%%, Reject: %.3f%%\n", compErrors(cmx) .* 100);

  hhidl = hidl;
  ooutl = outl;

  steps = 0.1 ./ (10.^0:3);
  epochs = 10000;
  errors = zeros(1, epochs);
  error_plot = plot(errors);
  for i=1:epochs
    lr = steps(fix(i / (epochs+1) * columns(steps) + 1));

    printf("Epoch #%d\tLerning rate: %.3f\t%s\n", i, lr, strftime ("%T", localtime (time ())))

    [hhidl, ooutl, ter] = backprop(xor_set, xor_labels, hhidl, ooutl, lr);

    errors(i) = ter;
    set(error_plot, 'YData', errors);
    res = anncls(xor_set, hhidl, ooutl);
    cmx = confMx(xor_labels, res);
    printf("Backprop error: %f\n", ter)
    printf("Correct: %.3f%%, Error: %.3f%%, Reject: %.3f%%\n", compErrors(cmx) .* 100);
    cmx
  end
  plot(errors);
end
%test_backprop

%function test_ann()

  features_size = columns(train_set);
  labels_size = rows(unique(train_labels));
  [hidl, outl] = crann(features_size, 40, labels_size);

  disp("train_set - Before training")
  res = anncls(train_set, hidl, outl);
  cmx = confMx(train_labels, res);
  printf("Correct: %.3f%%, Error: %.3f%%, Reject: %.3f%%\n", compErrors(cmx) .* 100);
  cmx

  hhidl = hidl;
  ooutl = outl;
  steps = (1*10^-8) ./ (10.^(0:3));

  epochs = 100;
  errors = zeros(1, epochs);
  error_plot = plot(errors);
  lr = 10^-2;
  for i=1:epochs
    %lr = steps(fix(i / (epochs+1) * columns(steps) + 1));

    printf("Epoch #%d\tLerning rate: %.10f\t%s\n", i, lr, strftime ("%T", localtime (time ())))
    [hhidl, ooutl, ter] = backprop(train_set, train_labels, hhidl, ooutl, lr);
    errors(i) = ter;
    set(error_plot, 'YData', errors);

    res = anncls(train_set, hhidl, ooutl);
    cmx = confMx(train_labels, res);
    printf("Backprop error: %f\n", ter)
    printf("Correct: %.3f%%, Error: %.3f%%, Reject: %.3f%%\n", compErrors(cmx) .* 100);
    cmx
    fflush(stdout);
  end

  disp("test_set - After training")
  res = anncls(test_set, hidl, outl);
  cmx = confMx(test_labels, res)
  printf("Correct: %.3f%%, Error: %.3f%%, Reject: %.3f%%\n", compErrors(cmx) .* 100);
%end
