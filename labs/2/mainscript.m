load train.txt
load test.txt
% our data are in train and test matrices
% the first column contains sample label, next go sample's features

% Our first look at the data?
size(train)
size(test)
labels = unique(train(:,1))
unique(test(:,1))

% Think about what is the result of next statement.
% Why does it work?
sum(train(:,1) == labels')


% comparing mean and median values
[mean(train); median(train)]

% You can compare here different parameters computed on train 
% and test sets - they should be roughly the same

% plot histogram - to check histogram plotting first show labels (1..4)
% we can use hist for labels to check what the plot looks like
hist(train(:,1))

% now plot histogram of the first feature
hist(train(:,2))

% plot 2-dimensional diagram of the first two features
% it's good to repeat plotting after each modification of the training set
plot2features(train, 2, 3);

% to find row in which outlier sits
[mv mi] = max(train)

% to remove outlier from the training set we can use following instruction
train(row_to_be_removed_index,:)=[];

% What do you think about your training set now?
% Are there any outliers left?

% Here you probably add some code :)


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

	
end

% Check your result with colleagues who selected the same features


% The parameter structure for two-dimensional distribution has to store
% covariance matrix for each class - it will be convenient to use 3D matrix

pdfmulti_para.labels = labels;
pdfmulti_para.mu = zeros(rows(labels), columns(train)-1);
% No semicolon here you'll see 3D matrix displayes
pdfmulti_para.sig = zeros(columns(train)-1, columns(train)-1, rows(labels))

% Compare different indexing schemes
pdfmulti_para.sig(:,:,1)
pdfmulti_para.sig(1,:,:)

for i=1:rows(labels)
	clabel = labels(i);
	
	% YOUR CODE GOES HERE
	% to compute covariance matrix use cov function

end


% Parameters structure for Parzen window approximation
% since our classes have different number of samples we can't use 3D matrix here
% Instead we'll use cell array
% each cell can contain different elements (matrices with unequal number of rows in particular)

pdfparzen_para.labels = labels;

% number_of_rows == number_of_classes and ONE column of CELLS
pdfparzen_para.samples = cell(rows(labels),1)

% now I insert class samples into proper cells
for i=1:rows(labels)
	pdfparzen_para.samples{i} = train(train(:,1) == labels(i), 2:end);
%						  ^^^ important: gives access to the cell's CONTENTS
end
% finally default Parzen window width (standard deviation)
pdfparzen_para.parzenw = 0.0001;

% Let's check difference in () and {} indexing for cell arrays
% access to the contents of cell under index 1
size(pdfparzen_para.samples{1})
% access to the cell under index 1
size(pdfparzen_para.samples(1))

%%
%% Now you're ready to implement pdf functions
%%

%% TIP for pdf_parzen function
% In pdf_parzen function it's good to use symmetry of normal distribution
% Let's assume that we want to compute pdf values for point 0.75 
% for distributions N(0.0,0.1) N(0.3,0.1) N(0.6,0.1) N(0.8,0.1)
% IMPORTAN: note that standard deviation is the same!

% Standard approach is following
[normpdf(0.75, 0.0, 0.1); normpdf(0.75, 0.3, 0.1); normpdf(0.75, 0.6, 0.1); normpdf(0.75, 0.8, 0.1)] 

% if we swap x and mu values we got exactly the same result!
[normpdf(0.0, 0.75, 0.1); normpdf(0.3, 0.75, 0.1); normpdf(0.6, 0.75, 0.1); normpdf(0.8, 0.75, 0.1)] 

% so we can use just one call to compute all the values
normpdf([0.0; 0.3; 0.6; 0.8], 0.75, 0.1)

% this will allow us to simplify pdfparzen function



% Let's check pdf functions on tiny test set (BEWARE: results are valid for the third and the fifth feature)
% 4 samples - one from each class
tst = train([1 21 41 61],2:end)

pdf_indep(tst, pdfindep_para)
%  1.5836e+011  0.0000e+000  2.1348e+010  5.7646e+010
%  1.0130e+011  0.0000e+000  6.4557e+010  1.9630e+010
%  7.2888e+010  8.2138e+016  1.2340e-005  4.6572e+010
%  7.7599e+010  0.0000e+000  1.1250e+012  1.7571e+010

pdf_multi(tst, pdfmulti_para)
%  3.6650e+011  0.0000e+000  3.6422e+009  1.8300e+011
%  5.7648e+009  0.0000e+000  2.1316e+010  1.2396e+009
%  7.0642e+007  1.0946e+017  5.0140e-019  2.1473e+007
%  2.5762e+011  0.0000e+000  4.8451e+011  4.1083e+010

pdf_parzen(tst, pdfparzen_para)
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
errcf

% In point 3 reduce function which selects from individual classes appropriate 
% number of samples will be useful
% Because we change training set here every time new parameters should be computed 
% Since reduce selects samples randomly experiment should be repeated 5 (or more) times
% in the report show only mean and standard deviation of the error coefficient

parts = [0.1 0.25 0.5];
rep_cnt = 5; % minimalistic approach

% YOUR CODE GOES HERE 
%


% Point 4 uses full data set again

parzen_widths = [0.0001, 0.0005, 0.001, 0.005, 0.01];
parzen_res = zeros(1, columns(parzen_widths));

% YOUR CODE GOES HERE 
%

% Plots are sometimes better than numerical results
semilogx(parzen_widths, parzen_res)

% In point 5 you should reduce TEST SET (no need to touch train set)
% 
apriori = [0.17 0.33 0.33 0.17];
parts = [0.5 1.0 1.0 0.5];

% YOUR CODE GOES HERE 
%

% In point 6 we should consider data normalization
std(train(:,2:end))

% Should we normalize?
% If YES remember to normalize BOTH training and testing sets

% YOUR CODE GOES HERE 
%

