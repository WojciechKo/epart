function pdf = pdf_multi(pts, para)
% Computes multidimensional Gaussian probability density value 
% pts - matrix of samples for which pdf should be computed (row == sample)
% para - structure with pdf_indep parameters:
%	para.labels - column vector of training set labels
%	para.mu - mean values of features (one row per class)
%	para.sig - covariance matrices of features (one LAYER per class)

% pdf - probability density matrix
%	number of rows == number of samples (rows) in pts
%	number of columns == number of classes

	pdf = rand(rows(pts), rows(para.mu)); % not very useful implementation :)
	% YOUR CODE GOES HERE
	% for each class you should compute multidimensional pdf
	for i=1:rows(para.labels)

		% nice thing here is mvnpdf function - you need to call it once to compute
		% pdf values for all points in pts
		pdf(:,i) = mvnpdf(pts, para.mu(i,:), para.sig(:,:,i));
	end
end
