function [confmx] = voteUni(clslabels, tstl)
% simple unanimity classifier
% clslabels - matrix containing elementary classifiers results
%	each row contains NN labels for one test element
% tstl - test set labels (ground truth)
% confmx - confusion matrix of the classifier
	treshold = size(clslabels, 2);
	reject = max(tstl) + 1; 
	[lab f] = mode(clslabels');
	lab(f < treshold) = reject;
	
	confmx = zeros(reject - 1, reject);
	for i=1:size(tstl,1)
		confmx(tstl(i), lab(i)) = confmx(tstl(i), lab(i)) + 1;
	end
