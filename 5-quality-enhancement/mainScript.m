vnames = {
'valid_1.txt', 
'valid_2.txt',
'valid_3.txt', 
'valid_4.txt', 
'valid_5.txt', 
'valid_6.txt', 
'valid_7.txt'};

tnames = {
'test_1.txt', 
'test_2.txt', 
'test_3.txt', 
'test_4.txt', 
'test_5.txt', 
'test_6.txt', 
'test_7.txt'};

vtab = loadCNNOutputs(vnames);
load validlab.txt
validlab = validlab + 1;

ttab = loadCNNOutputs(tnames);
load testlab.txt
testlab = testlab + 1;

iqltytest = [];
iqltyvald = [];
for i=1:columns(vtab)
	iqltyvald = [iqltyvald sum(vtab(:,i)!=validlab)/rows(validlab)];
	iqltytest = [iqltytest sum(ttab(:,i)!=testlab)/rows(testlab)];
end
[1-iqltyvald; 1-iqltytest]

vcmUni = voteUni(vtab, validlab);
vcmMaj = voteMaj(vtab, validlab);
vcmPlr = votePlr(vtab, validlab);

tcmUni = voteUni(ttab, testlab);
tcmMaj = voteMaj(ttab, testlab);
tcmPlr = votePlr(ttab, testlab);

resVald = [compErrors(vcmUni); compErrors(vcmMaj); compErrors(vcmPlr);]
resTest = [compErrors(tcmUni); compErrors(tcmMaj); compErrors(tcmPlr);]

[resVald fobj(resVald)]
[resTest fobj(resTest)]

% ans =

   % 0.98300   0.98300   0.98560   0.98490   0.98600   0.98500   0.98340
   % 0.98580   0.98580   0.98540   0.98630   0.98690   0.98710   0.98490

% resVald =

  % 9.7290e-001  6.8000e-003  2.0300e-002
  % 9.8610e-001  1.3600e-002  3.0000e-004
  % 9.8610e-001  1.3600e-002  3.0000e-004

% resTest =

  % 9.7590e-001  5.5000e-003  1.8600e-002
  % 9.8660e-001  1.2200e-002  1.2000e-003
  % 9.8680e-001  1.2500e-002  7.0000e-004

% ans =

  % 9.7290e-001  6.8000e-003  2.0300e-002  9.0490e-001
  % 9.8610e-001  1.3600e-002  3.0000e-004  8.5010e-001
  % 9.8610e-001  1.3600e-002  3.0000e-004  8.5010e-001

% ans =

  % 9.7590e-001  5.5000e-003  1.8600e-002  9.2090e-001
  % 9.8660e-001  1.2200e-002  1.2000e-003  8.6460e-001
  % 9.8680e-001  1.2500e-002  7.0000e-004  8.6180e-001
