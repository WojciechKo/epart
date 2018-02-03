function objv = fobj(cer, beta = 10)
% computes character recognition objective function f = correct - beta * errors
% cer - matrix containing in each row correct, error and rejection coefficients
% beta - weighting of errors with respect to rejections

	objv = cer(:,1) - beta * cer(:,2);
