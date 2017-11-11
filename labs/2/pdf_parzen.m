function pdf = pdf_parzen(pts, para)
% Approximates pdf value with Parzen window
% pts - matrix of samples for which pdf should be computed (row == sample)
% para - structure with pdf_indep parameters:
%	para.labels - column vector of training set labels
%	para.samples - cell array containing class labels
%	para.parzenw - Parzen window width

% pdf - probability density matrix
%	number of rows == number of samples (rows) in pts
%	number of columns == number of classes


	pdf = zeros(rows(pts), rows(para.samples));
	
	for cl = 1:rows(para.labels) % for each class
	
		% Parzen window width adjusted to the number of samples in class
		h_n = para.parzenw / sqrt(rows(para.samples{cl})); 
		
		% matrix to store one dimensional pdfs in individual features
		onedim_pdf = zeros(size(para.samples{cl}));

		% YOUR CODE GOES HERE
		% for each sample in pts (nested loops - it will take time...)
			% for each feature 
				% compute one dimensional pdf function "shares" of training points at x
				% and store it in proper onedim_pdf column
				% (remember that training samples are in para.samples{cl})
			
			% one dimensional shares of training points are independent
			% we can aggregate them multiplying 1d pdf values of the same training points
			% finally we can aggregate multidimensional shares by taking their mean

	end
end
