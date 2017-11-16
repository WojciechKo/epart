function res = plot2features(tset, f1, f2)
% Plots tset samples on a 2-dimensional diagram
%	using features f1 and f2
% tset - training set; the first column contains class label
% f1 - index of the first feature (mapped to horizontal axis)
% f2 - index of the second feature (mapped to vertical axis)
% 
% res - matrix containing values of f1 and f2 features

	% plotting parameters for different classes
	%   restriction to 8 classes seems reasonable
	pattern(1,:) = "ks";
	pattern(2,:) = "rd";
	pattern(3,:) = "mv";
	pattern(4,:) = "b^";
	pattern(5,:) = "gs";
	pattern(6,:) = "md";
	pattern(7,:) = "mv";
	pattern(8,:) = "g^";
	
	res = tset(:, [f1, f2]);
	
	% extraction of all unique labels used in tset
	labels = unique(tset(:,1));
	
	% create diagram and switch to content preserving mode
	figure;
	hold on;
	for i=1:size(labels,1)
		idx = tset(:,1) == labels(i);
		plot(res(idx,1), res(idx,2), pattern(i,:));
	end
	hold off;
end
