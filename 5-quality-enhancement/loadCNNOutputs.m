function vtab = loadCNNOutputs(fnames)
% Loads neural network outputs from specified files
% Input files contain in each row output of the neural net for one row (sample) of a set
% decmax function is used to reduce each row to index of maximum value the rows contains
% vtab - output matrix containing one column for each file specified
 
	vtab = [];
	for i=1:size(fnames,1)
		valc = load(fnames{i});
		vtab = [vtab decmax(valc)];
	end
