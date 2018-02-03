format short g
more off
diary on
hold on

%testBackprop

function [first, second] = split(total, ratio = 0.9)
  pivot = int32(rows(total) * ratio);
  first = total(1:pivot,:);
  second = total(pivot+1:end,:);
end

function [random_set, random_labels] = random(origin_set, origin_labels)
  idx = randperm(size(origin_labels,1));
  random_set = origin_set(idx,:);
  random_labels = origin_labels(idx,:);
end

function train_on_mnist()
  % Load data and remap labels
  [real_train_set real_train_labels real_test_set real_test_labels] = readSets();
  real_train_labels += 1;
  real_test_labels += 1;

  % Remove columns with zero std
  toRemove = std(real_train_set) != 0;
  real_train_set = real_train_set(:, toRemove);
  real_test_set = real_test_set(:, toRemove);

  %real_train_set = real_train_set(1:rows(real_train_set) / 15, :);
  %real_train_labels = real_train_labels(1:rows(real_train_labels) / 15, :);

  % Split train data to train set and verification set
  new_train_set = [];
  new_train_labels =[];
  verification_set = [];
  verification_labels = [];

  for i=1:10
    [train_set, test_set] = split(real_train_set(real_train_labels == i,:));
    [train_labels, test_labels] = split(real_train_labels(real_train_labels == i));
    
    new_train_set = [new_train_set; train_set];
    new_train_labels = [new_train_labels; train_labels];  
    verification_set = [verification_set; test_set];
    verification_labels = [verification_labels; test_labels]; 
  end

  [train_set, train_labels] = random(new_train_set, new_train_labels);
  [verification_set, verification_labels] = random(verification_set, verification_labels);

  % Check if histogram for train and verification set is the same
  figure(1);
  subplot(3,1,1);
  hist(real_train_labels);
  title('Whole train set');
  subplot(3,1,2);
  hist(train_labels);
  title('Train subset');
  subplot(3,1,3);
  hist(verification_labels);
  title('Test subset');
  
  % Initialize neural network
  features_size = columns(train_set);
  labels_size = rows(unique(train_labels));  
  [hidl, outl] = crann(features_size, 60, labels_size);

  steps = [10^-3 10^-3 10^-4];
  epochs = 1500;
  backprop_errors = zeros(1, epochs);
  train_corrects = zeros(1, epochs);
  train_errors = zeros(1, epochs);
  verification_corrects = zeros(1, epochs);
  verification_errors = zeros(1, epochs);

  % Show results of classification of verification set
  f = figure(2);
  correct_plot = plot(verification_corrects,'-r');
  figure(3);
  error_plot = plot(verification_errors,'-r');
  figure(4);
  backprop_error_plot = plot(backprop_errors, '-b');

  
  % Training results
  final_hidl = hidl;
  final_outl = outl;
  
  for i=1:epochs
    lr = steps(fix(i / (epochs+1) * columns(steps) + 1));
    
    % Perform backpropagation
    [hidl, outl, total_error, hidden_adjustment, output_adjustment] = backprop(train_set, train_labels, hidl, outl, lr);
    printf("Epoch #%d\t%s\n", i, strftime("%T", localtime(time())));    
    printf("Backprop error: %f\tLerning rate: %.10f\tAdjust of hidden: %.6f\tAdjust of output: %.6f\n", total_error, lr, hidden_adjustment, output_adjustment);
    backprop_errors(i) = total_error;

    % Classify train set
    res = anncls(train_set, hidl, outl);
    cmx = confMx(train_labels, res);
    errs = compErrors(cmx) * 100;
    train_corrects(i) = errs(1);
    train_errors(i) = errs(2);

    % Stre weights if the best solution
    if (train_corrects(i) >= max(train_corrects))
      printf('NEW_BEST\n');
      final_hidl = hidl;
      final_outl = outl;
    end

    printf("Train set\n");
    printf("Correct: %.3f%%, Error: %.3f%%\n", train_corrects(i), train_errors(i));
    cmx
    
    % Update plots
    set(correct_plot, 'YData', verification_corrects);
    set(error_plot, 'YData', verification_errors);
    set(backprop_error_plot, 'YData', backprop_errors);

    % Classify verification set
    res = anncls(verification_set, hidl, outl);
    cmx = confMx(verification_labels, res);
    errs = compErrors(cmx) * 100;
    verification_corrects(i) = errs(1);
    verification_errors(i) = errs(2);

    printf("Verification set\n");
    printf("Correct: %.3f%%, Error: %.3f%%\n", verification_corrects(i), verification_errors(i));
    cmx


    fflush(stdout);
  end
  
  % Plot corrections and errors for train and verification sets
  figure(5);
  plot(train_corrects,'-b', verification_corrects,'-r');
  figure(6);
  plot(train_errors,'-b', verification_errors,'-r');


  % Test set classification
  res = anncls(real_test_set, final_hidl, final_outl);
  cmx = confMx(real_test_labels, res);
  errs = compErrors(cmx) * 100;
  test_correct = errs(1);
  test_error = errs(2);

  printf("Test set\n");
  printf("Correct: %.3f%%, Error: %.3f%%\n", test_correct, test_error);
  cmx
end
train_on_mnist

diary off;