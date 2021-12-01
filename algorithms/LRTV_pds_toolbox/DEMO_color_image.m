clear all

addpath Function_LRTV
addpath plotting_function

%% load data (you can change the file addres in this sentence.)
addres = 'Dataset/lena_missing_90.png';
X0 = imread(addres);
II = size(X0);

%% set missing indexes
Q = (X0 ~= 255);
T = zeros(II);
T(Q) = double(X0(Q));


%% adjustable hyperparameters
al    = 0.9;     % weight for Total variation term
tvw   = [1 1 0]; % weights for n-th mode differential terms for calculating total variation
be    = 1-al;    % weight for total low-rank term
lrw   = [0.2 0.2 0.6]; % weights for n-th mode low-rank terms
delta = 10;    % noise threshold
dom   = [0 255]; % range of value

% optimization parameters
maxiter = 10000;
tol = 1e-7;
verb= 10;
gam = 0.01;
Gam = [gam 1/(8*gam)];


[X histo] = LRTV_pds(prox_dom(T,dom)/255,Q,al,tvw,be,lrw,delta,dom/255,Gam,maxiter,tol,verb);
Xlrtv = X*255;


original = double(imread('Dataset/Original/lena.bmp'));
psnr_value = PSNR(original,Xlrtv);
ssim_value = calc_SSIM(original,Xlrtv);

figure(1);clf;
subplot(1,3,1)
imagesc(uint8(original));caxis([0 255]);
title('original')

subplot(1,3,2)
imagesc(uint8(T));caxis([0 255]);
title('missing')

subplot(1,3,3)
imagesc(uint8(Xlrtv));caxis([0 255]);
title(['Estimated (PSNR=' num2str(psnr_value) ', SSIM=' num2str(ssim_value) ')'])



