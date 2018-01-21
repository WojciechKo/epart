% load data and remap labels
[tvec tlab tstv tstl] = readSets();
tlab += 1;
tstl += 1;

% remove columns with zero std
toRemove = std(tvec) != 0;
tvec = tvec(:, toRemove);
tstv = tstv(:, toRemove);

% Data is ready - first prepare ANN classifier
% we'll need:
%	activation function (actf)
%	two matrices containing weights of our ANN
%		let's close this code in separate function (crann)
%	classifier function itself

x = -5:0.1:5;
%plot(x, actf(x));

[hidl outl] = crann(2, 3, 2);

% xor data set
tset = [-1 1; 1 1; 1 -1; -1 -1];
tslb = [1; 2; 1; 2];

tset = repmat(tset, 50, 1);
tslb = repmat(tslb, 50, 1);

res = anncls(tset, hidl, outl);
cmx = confMx(tslb, res)
result = compErrors(cmx)

% classifier is ready; now time for training
% we'll need:
%	derivative of the activation function
%	backprop function which performs iterative backpropagation training

%plot(x, actdf(x));

hhidl = hidl;
ooutl = outl;

for i=1:20
  [hhidl ooutl ter] = backprop(tset, tslb, hhidl, ooutl, 0.5);
end
hidl(1:3, :)
hhidl(1:3, :)
res = anncls(tset, hhidl, ooutl);
cmx = confMx(tslb, res)
result = compErrors(cmx)
