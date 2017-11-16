function votes = voting(tset, clsmx)
% tset - matrix containing test data; one row represents one sample
% clsmx - voting committee matrix
%	clsmx(:,1) contains positive class label
%	clsmx(:,2) contains negative class label
%	clsmx(:,3) is "augmented dimension" coefficient (bias of sep. hyperplane)
%	clsmx(:,4:end) are regular separating hyperplane coefficients
% votes - output matrix of votes cast by all one-versus-one classifiers

	% get column vector of all labels present in the first two columns 
	% of voting committee 
	labels = unique(clsmx(:,1:2)(:));
	% prepare voting result
	votes = zeros(size(tset,1), size(labels,1));
	
	% for all individual classifiers
	for i=1:size(clsmx,1)
		% get response of one ovo classifier for all samples
		res = lincls(clsmx(i, 3:end), tset);

		% find index of positive label of this classifier
		pid = find(labels == clsmx(i,1));

		% for all samples classified as positive (i.e. res == 1)  
		%   increase number of votes for positive class by one
		votes(res == 1, pid) += 1;

		% find index of positive label of this classifier
		nid = find(labels == clsmx(i,2));

		% for all samples classified as negative (i.e. res == 0)
		%   increase number of votes for negative class by one
		votes(res == 0, nid) += 1;
	end
	