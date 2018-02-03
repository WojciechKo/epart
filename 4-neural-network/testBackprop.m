function testBackprop()
  % xor data set
  xor_set = [-1 1; 1 1; 1 -1; -1 -1];
  xor_labels = [1; 2; 1; 2];
  
  [hidl, outl] = crann(columns(xor_set), 3, rows(unique(xor_labels)));

  epochs = 2000;
  errors = zeros(1, epochs);
  error_plot = plot(errors);
  lr = 1;

  for i=1:epochs
    [hidl, outl, total_error, hidden_adjustment, output_adjustment] = backprop(xor_set, xor_labels, hidl, outl, lr);
    printf("Epoch #%d\t%s\n", i, strftime("%T", localtime(time())));    
    printf("Backprop error: %f\tLerning rate: %.10f\tAdjust of hidden: %.6f\tAdjust of output: %.6f\n", total_error, lr, hidden_adjustment, output_adjustment);

    errors(i) = total_error;
    set(error_plot, 'YData', errors);
    
    res = anncls(xor_set, hidl, outl);
    cmx = confMx(xor_labels, res);
    printf("Correct: %.3f%%, Error: %.3f%%, Reject: %.3f%%\n", compErrors(cmx) .* 100);
    cmx
  end
  plot(errors);
end