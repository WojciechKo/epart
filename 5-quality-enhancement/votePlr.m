function [confmx] = votePlr(clslabels, tstl)
% simple plurality classifier - class with greates number of votes wins (if unique)
% clslabels - matrix containing elementary classifiers results
%	each row contains NN labels for one test element
% tstl - test set labels (ground truth)
% confmx - confusion matrix of the classifier
	s = size(clslabels, 2);
	dig = repmat([0:9]',1,s);
	ds = size(dig,1);
	treshold = floor(s/2) + 1;
	reject = max(tstl) + 1; 
	[lab f] = mode(clslabels');
	for i=1:size(clslabels,1)
		if (f(i) < treshold)
			res = clslabels(i,:);
			res(res == lab(i)) = [];
			[l2 f2] = mode(res);
			if f2 == f(i)
				lab(i) = reject;
			end
		end
	end
	
	confmx = zeros(reject - 1, reject);
	for i=1:size(tstl,1)
		confmx(tstl(i), lab(i)) = confmx(tstl(i), lab(i)) + 1;
	end
