function [hidden_layer, output_layer, total_error] = backprop(input, labels, inihidlw, inioutlw, lr)
% derivative of sigmoid activation function
% input - training set (every row represents a sample)
% labels - column vector of labels
% inihidlw - initial hidden layer weight matrix
% inioutlw - initial output layer weight matrix
% lr - learning rate

% hidden_layer - hidden layer weight matrix
% output_layer - output layer weight matrix
% total_error - total squared error of the ANN

  % 1. Set output matrices to initial values
  hidden_layer = inihidlw;
  output_layer = inioutlw;

  % 2. Set total error to 0
  total_error = 0;

  hidden_adjust_sum = 0;
  output_adjust_sum = 0;

  % foreach sample in the training set
  for i=1:rows(input)
    % 3. Set desired output of the ANN
    desired_output = zeros(1, columns(output_layer));
    desired_output(labels(i)) = 1;

    % 4. Propagate input forward through the ANN
    % remember to extend input [input(i, :) 1]
    output_from_hidden = actf([input(i, :) 1] * hidden_layer);
    output_from_output = actf([output_from_hidden 1] * output_layer);

    % 5. Adjust total error (just to know this value)
    sample_err = sum((desired_output - output_from_output) .^2);
    total_error += sample_err;

    % 6. Compute delta error of the output layer
    % how many delta errors should be computed here?
    delta_out = actdf(output_from_output) .* (desired_output - output_from_output);
    output_adjust = [output_from_hidden 1]' * delta_out * lr;

    % 7. Compute delta error of the hidden layer
    % how many delta errors should be computed here?
    % dbstop('backprop', 46)
    delta_hid = actdf(output_from_hidden) .* (output_layer(1:end-1,:) * delta_out')';
    hidden_adjust = [input(i,:) 1]' * delta_hid * lr;

    % 8. Update output layer weights
    output_layer += output_adjust;
    output_adjust_sum += sum(abs(output_adjust(:)));

    % 9. Update hidden layer weights
    hidden_layer += hidden_adjust;
    hidden_adjust_sum += sum(abs(hidden_adjust(:)));
  end
  printf("Adjust of hidden: %f\tAdjust of output: %f\n", hidden_adjust_sum , output_adjust_sum )
