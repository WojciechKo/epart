function rds = reduce(ds, parts)
% Reduces number of samples of individual classes in ds set
% ds - data set to be reduced; the first column contains class labels
% parts - row vector of reduction coefficients for individual classes 

	labels = unique(ds(:,1));
	if rows(labels) ~= columns(parts)
		error("Number of classes does not match coefficient count.");
	end

	if max(parts) > 1 || min(parts) < 0
		error("Invalid reduction coefficients.");
	end

	rds = []; 
	
	% YOUR CODE GOES HERE
	% using randperm to shuffle samples is mandatory!

	% for each class 
		% ....
end