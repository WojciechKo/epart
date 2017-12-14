function lab = anncls(tset, hidlw, outlw)
% simple ANN classifier
% tset - data to be classified (every row represents a sample) 
% hidlw - hidden layer weight matrix
% outlw - output layer weight matrix

% lab - classification result (index of output layer neuron with highest value)
% ATTENTION: we assume that constant value IS NOT INCLUDED in tset rows

	hlact = [tset ones(rows(tset), 1)] * hidlw;
	hlout = actf(hlact);
	
	olact = [hlout ones(rows(hlout), 1)] * outlw;
	olout = actf(olact);
	
	[~, lab] = max(olout, [], 2);
