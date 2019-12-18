function result = RL_deconv(image, PSF, iterations)
fn = image; % at the first iteration
OTF = psf2otf(PSF,size(image)); 
for i=1:iterations
    ffn = fft2(fn); 
    Hfn = OTF.*ffn; 
    iHfn = ifft2(Hfn); 
    ratio = image./iHfn; 
    iratio = fft2(ratio); 
    res = OTF .* iratio; 
    ires = ifft2(res); 
    fn = ires.*fn; 
end
result = abs(fn); 