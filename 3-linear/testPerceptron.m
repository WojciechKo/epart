function [errors sepplane] = testPerceptron(positive_samples, negative_samples)
  pos = [1 1; 1 2; 2 1; 2 2];
  neg = [3 3; 3 4; 4 4; 4 3];

  [err, sep] = perceptron(pos, neg, 0.01);

  err
  [lincls(sep, pos); lincls(sep, neg)]

  figure
  hold
  plot(pos(:,1), pos(:,2), 'o');
  plot(neg(:,1), neg(:,2), 'x');

  sep_fun = @(x) ((sep(1) + sep(3)*x) / -sep(2));
  % sep_fun = @(x) -(sep(1)*x + sep(2)) / sep(3);

  line_x = [0, 5];
  line(line_x, sep_fun(line_x));
end
