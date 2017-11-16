graphics_toolkit("gnuplot")

load train.txt
load test.txt
% our data are in train and test matrices
% the first column contains sample label, next go sample's features

% Our first look at the data?
disp('Size of train data');
disp(size(train));
disp('Size of test data');
disp(size(test));

disp('Train data labels');
disp(unique(train(:,1)));
disp('Test data labels');
disp(unique(test(:,1)));

labels = unique(train(:,1));

% Think about what is the result of next statement.
% Why does it work?
disp('number of examples in train assigned to each label');
disp(sum(train(:,1) == labels'));

% comparing mean and median values
disp('Compare mean and median of features from train');
disp([mean(train); median(train)]);

% You can compare here different parameters computed on train
% and test sets - they should be roughly the same
disp('Compare mean of features in train and test');
disp([mean(train); mean(test)]);
disp('Compare median of features in train and test');
disp([median(train); median(test)]);

% plot histogram - to check histogram plotting first show labels (1..4)
% we can use hist for labels to check what the plot looks like
figure
hist(train(:,1)')

% now plot histogram of the first feature
figure
hist(train(:,2))

% plot 2-dimensional diagram of the first two features
% it's good to repeat plotting after each modification of the training set
figure
plot2features(train, 2, 3);

disp('Sorted train set:');
disp(sort(train, 'descend')(1:3,:));

% to find row in which outlier sits
[out.values, out.indices] = max(train);

disp('Remove max outliner');
disp(out);
% to remove outlier from the training set we can use following instruction
row_to_be_removed_index = out.indices(2);
train(row_to_be_removed_index,:)=[];

% What do you think about your training set now?
% Are there any outliers left?

% Here you probably add some code :)
figure
plot2features(train, 2, 3);

disp('Sorted train set:');
disp(sort(train)(1:3,:));

disp('Remove min outlier:');
[out.values, out.indices] = min(train);

disp(out);
train(out.indices(2),:)=[];

figure
plot2features(train, 2, 3);

disp('Recalculate mean and median for train data');
disp([mean(train); median(train)]);
% After removing outliers it's time to select TWO features to be used in the rest of experiments

% I selected the the third and the fifth feature (not the best choice...)
% Note that label must be saved too!
train = train(:,[1 4 6]);
test = test(:,[1 4 6]);

% It is good time to look at bayescls function ...
%  ... and pdf_indep function which you'll have to impelement in a moment

% Here I start preparation of the INDEPENDENT FEATURE parameter structure
% for probability density function
% The first element are labels

pdfindep_para.labels = labels;

% Next we allocate space for means and standard deviations
% Both matrices are number_of_classes x number_of_features

pdfindep_para.mu = zeros(rows(labels), columns(train)-1);
pdfindep_para.sig = zeros(rows(labels), columns(train)-1);

% Finally we can compute mean and standard deviation values for each class

for i=1:rows(labels)
	% ATTENTION: the next instruction is really not necessary in our case (labels are 1 2 3 4)
	% such indirect indexing will work with arbitrary labels
	clabel = labels(i);

	% YOUR CODE GOES HERE !!!
	single_category_subset = train(train(:,1) == i, 2:end);

	pdfindep_para.mu(i,:) = mean(single_category_subset);
	pdfindep_para.sig(i,:) = std(single_category_subset);
end

disp('Pdf indep para');
disp(pdfindep_para);
% Check your result with colleagues who selected the same features


% The parameter structure for two-dimensional distribution has to store
% covariance matrix for each class - it will be convenient to use 3D matrix

pdfmulti_para.labels = labels;
pdfmulti_para.mu = zeros(rows(labels), columns(train)-1);
% No semicolon here you'll see 3D matrix displayes
pdfmulti_para.sig = zeros(columns(train)-1, columns(train)-1, rows(labels));

% Compare different indexing schemes
pdfmulti_para.sig(:,:,1);
pdfmulti_para.sig(1,:,:);

for i=1:rows(labels)
	clabel = labels(i);

	% YOUR CODE GOES HERE
	% to compute covariance matrix use cov function
	single_category_subset = train(train(:,1) == i, 2:end);

	pdfmulti_para.mu(i,:) = mean(single_category_subset);
	pdfmulti_para.sig(:,:,i) = cov(single_category_subset);
end

disp('Pdf multi para');
disp(pdfmulti_para);

% Parameters structure for Parzen window approximation
% since our classes have different number of samples we can't use 3D matrix here
% Instead we'll use cell array
% each cell can contain different elements (matrices with unequal number of rows in particular)

pdfparzen_para.labels = labels;

% number_of_rows == number_of_classes and ONE column of CELLS
pdfparzen_para.samples = cell(rows(labels),1);

% now I insert class samples into proper cells
for i=1:rows(labels)
	pdfparzen_para.samples{i} = train(train(:,1) == labels(i), 2:end);
%						  ^^^ important: gives access to the cell's CONTENTS
end
% finally default Parzen window width (standard deviation)
pdfparzen_para.parzenw = 0.0001;

% Let's check difference in () and {} indexing for cell arrays
% access to the contents of cell under index 1
size(pdfparzen_para.samples{1});
% access to the cell under index 1
size(pdfparzen_para.samples(1));

disp('Pdf Parzen para');
disp('too long to display');

%%
%% Now you're ready to implement pdf functions
%%

%% TIP for pdf_parzen function
% In pdf_parzen function it's good to use symmetry of normal distribution
% Let's assume that we want to compute pdf values for point 0.75 
% for distributions N(0.0,0.1) N(0.3,0.1) N(0.6,0.1) N(0.8,0.1)
% IMPORTAN: note that standard deviation is the same!

% Standard approach is following
[normpdf(0.75, 0.0, 0.1); normpdf(0.75, 0.3, 0.1); normpdf(0.75, 0.6, 0.1); normpdf(0.75, 0.8, 0.1)];

% if we swap x and mu values we got exactly the same result!
[normpdf(0.0, 0.75, 0.1); normpdf(0.3, 0.75, 0.1); normpdf(0.6, 0.75, 0.1); normpdf(0.8, 0.75, 0.1)];

% so we can use just one call to compute all the values
normpdf([0.0; 0.3; 0.6; 0.8], 0.75, 0.1);

% this will allow us to simplify pdfparzen function



% Let's check pdf functions on tiny test set (BEWARE: results are valid for the third and the fifth feature)
% 4 samples - one from each class
tst = train([1 21 41 61],2:end);

disp('Pdf indep results');
disp(pdf_indep(tst, pdfindep_para));
%  1.5836e+011  0.0000e+000  2.1348e+010  5.7646e+010
%  1.0130e+011  0.0000e+000  6.4557e+010  1.9630e+010
%  7.2888e+010  8.2138e+016  1.2340e-005  4.6572e+010
%  7.7599e+010  0.0000e+000  1.1250e+012  1.7571e+010

disp('Pdf multi results');
disp(pdf_multi(tst, pdfmulti_para));
%  3.6650e+011  0.0000e+000  3.6422e+009  1.8300e+011
%  5.7648e+009  0.0000e+000  2.1316e+010  1.2396e+009
%  7.0642e+007  1.0946e+017  5.0140e-019  2.1473e+007
%  2.5762e+011  0.0000e+000  4.8451e+011  4.1083e+010

disp('Pdf parzen results');
disp(pdf_parzen(tst, pdfparzen_para));
%  1.1978e+007  0.0000e+000  0.0000e+000  2.5243e+008
%  9.3703e+007  0.0000e+000  6.3710e+007  0.0000e+000
%  2.5945e-024  6.7958e+009  0.0000e+000  4.9371e+007
%  1.4951e+008  0.0000e+000  2.1525e+008  0.0000e+000

% With pdf functions ready point 2 is straightforward
errcf = zeros(1, 3);
errcf(1) = mean(bayescls(test(:,2:end), @pdf_indep, pdfindep_para) != test(:,1));
errcf(2) = mean(bayescls(test(:,2:end), @pdf_multi, pdfmulti_para) != test(:,1));
errcf(3) = mean(bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para) != test(:,1));

% values for point 2
disp('Errors for pdf_indep, pdf_multi, pdf_parzen');
disp(errcf);

% In point 3 reduce function which selects from individual classes appropriate 
% number of samples will be useful
% Because we change training set here every time new parameters should be computed 
% Since reduce selects samples randomly experiment should be repeated 5 (or more) times
% in the report show only mean and standard deviation of the error coefficient

parts = [0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8];
rep_cnt = 5; % minimalistic approach

% YOUR CODE GOES HERE 
%
function reduced = reduce(set, labels, parts)
  reduced = [];
  for i=1:rows(labels)
    sub = set(set(:,1) == i, :);
    rand = randperm(rows(sub));
    count = int32(rows(sub) * parts(i));
    reduced = [reduced; sub(rand(1:count),:)];
  end
end

parts_error = zeros(columns(parts), rep_cnt);

for part_i=1:columns(parts)
  for rep=1:rep_cnt
    sub_train = reduce(train, labels, zeros(size(labels')) + parts(part_i));

    for i=1:rows(labels)
      pdfparzen_para.samples{i} = sub_train(sub_train(:,1) == labels(i), 2:end);
    end

    errcls = bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para) != test(:,1);
    parts_error(part_i, rep) = mean(errcls);
  end
end

disp('Classification error for following parts of train set');
disp([parts; mean(parts_error, 2)']);
figure
plot(parts,  mean(parts_error, 2));

% Point 4 uses full data set again

parzen_widths = [0.000001, 0.00005, 0.0001, 0.0005, 0.001, 0.005, 0.01];
parzen_res = zeros(1, columns(parzen_widths));

% YOUR CODE GOES HERE 
%
for i=1:rows(labels)
  pdfparzen_para.samples{i} = train(train(:,1) == labels(i), 2:end);
end

for width_i=1:columns(parzen_widths)
  pdfparzen_para.parzenw = parzen_widths(width_i);
  errcls = bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para) != test(:,1);
  parzen_res(width_i) = mean(errcls);
end

% Plots are sometimes better than numerical results
disp('Classification error for following sizes of parzen window');
disp([parzen_widths; parzen_res]);

figure
semilogx(parzen_widths, parzen_res)

% In point 5 you should reduce TEST SET (no need to touch train set)
% 
apriori = [0.17 0.33 0.33 0.17];
parts = [0.5 1.0 1.0 0.5];

% YOUR CODE GOES HERE 
%

pdfparzen_para.parzenw = 0.0001;

errcls = mean(bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para, apriori) != test(:,1));

disp("Without change of proportions in test set");
disp("Result of classification");
disp(errcls);

sub_test = reduce(test, labels, parts);
errcls = mean(bayescls(sub_test(:,2:end), @pdf_parzen, pdfparzen_para, apriori) != sub_test(:,1));

disp("Change proportion of test class");
disp(apriori);
disp("Result of classification");
disp(errcls);

% In point 6 we should consider data normalization
disp("Standard deviation of features");
disp(std(train(:,2:end)));

% Should we normalize?
% If YES remember to normalize BOTH training and testing sets

% YOUR CODE GOES HERE 
%

function label = cls1nn(ts, x)
  diff = ts(:,2:end) - repmat(x, rows(ts), 1);
  dist = sumsq(diff, 2);
  [~, idx] = min(dist);
  label = ts(idx, 1);
end

function errcf = check_1nn(train, test)
  errors = zeros(rows(test), 1);
  for i=1:rows(test)
    errors(i) = cls1nn(train, test(i, 2:end)) != test(i, 1);
  end
  errcf = mean(errors);
end

function [norm_train, norm_test] = normalize(train, test, fun)
  norm_train = zeros(size(train));
  norm_test = zeros(size(test));
  norm_train(:,1) = train(:,1);
  norm_test(:,1) = test(:,1);
  for i=2:columns(test)
    norm_train(:,i) = fun(train(:,i), train(:,i));
    norm_test(:,i) = fun(train(:,i), test(:,i));
  end
end

function mean_norm = mean_norm(base, vector)
  mean_norm = (vector - mean(base)) / (max(base) - min(base));
end

function std_norm = std_norm(base, vector)
  std_norm = (vector - mean(base)) / std(base);
end

raw_error = check_1nn(train, test);
disp("1nn error before normalization");
disp(raw_error);

[mean_train, mean_test] = normalize(train, test, @mean_norm);
mean_error = check_1nn(mean_train, mean_test);
disp("1nn error after mean normalization");
disp(mean_error);

[std_train, std_test] = normalize(train, test, @std_norm);
std_error = check_1nn(std_train, std_test);
disp("1nn error after standardization");
disp(std_error);
