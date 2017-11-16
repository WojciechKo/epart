function side = lincls(sepplane, samples)
% Linear classifier
% sepplane - row vector of the separating plane
%            first column represents free factor (additional dimension)
% samples - a matrix of the samples to be classified
%            each row represent one sample (only features are included)
% side - column vector of  classification result
%     1 - means that sample is on the positive side of sepplane (incl. the plane itself)
%     0 - sample is on the negative side of sepplane

	% not the best implementation
	side = (rand(rows(samples), 1) - 0.5) >= 0;

	%%% YOUR CODE GOES HERE %%%
	%% Remember that sepplane has one more coefficient that
	%% number of columns in samples matrix
	%% You should add to samples column of 1 (ones)
	%% as the first column (see sepplane description above)

end
