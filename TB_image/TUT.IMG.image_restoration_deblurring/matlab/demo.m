%%% Test several deconvolution algorithms for different images and psf

%% with noise and blur
close all
clear all

% generate or load images
n_images = 6;
f = cell(n_images,1);
g = cell(n_images,1);
psf=cell(n_images,1);

f{1} = checkerboard(8);
f{2} = checkerboard(8);
g{3} = fitsread('fits_data/saturn.fits');
g{4} = fitsread('fits_data/j413.fit');
g{5} = fitsread('fits_data/j889.fit');
g{6} = fitsread('fits_data/hubble/ic3g01qlq_flt.fits', 'image', 1);

psf{1} = fspecial('gaussian', size(f{1}), 2);
psf{2} = fspecial('motion', 7, 45);
psf{3} = fitsread('fits_data/saturn_psf.fits');
psf{4} = fitsread('fits_data/psf_413.fit');
psf{5} = fitsread('fits_data/psf_889.fit');
p = fitsread('fits_data/hubble/PSFSTD_WFC3UV_F275W.fits');
psf{6} = p(:,:,1);

% noise
sigma=.01; 
N = randn(size(f{1})) * sigma;
for i=1:2
    g{i} = imfilter(f{i}, psf{i}, 'circular')+ N;
    %g = conv2(f, psf, 'same') + N;
    g{i} = max(0,g{i});
    g{i} = min(1,g{i});
end

% filter a bit the saturn image
for i=3:n_images
    g{i} = max(0,g{i});
end

% apply deconvolutions
for i=n_images:n_images
    all_deconvolutions(g{i}, psf{i}, N);
end