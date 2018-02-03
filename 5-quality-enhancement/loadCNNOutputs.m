function vtab = loadCNNOutputs(fnames)
% Loads neural network outputs from specified files
% Input files contain in each row output of the neural net for one row (sample) of a set
% decmax function is used to reduce each row to index of maximum value the rows contains
% vtab - output matrix containing one column for each file specified

  function labels = custom(annout)
    [activation, index] = sort(annout, 2, 'descend');
    index((activation(:,1) / 3) < activation(:,2),1) = 11;
    labels = index(:,1);
  endfunction

	vtab = [];
	for i=1:size(fnames,1)
		valc = load(fnames{i});
		vtab = [vtab custom(valc)];
	end
end
