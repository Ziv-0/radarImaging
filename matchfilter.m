function result = matchfilter(sig,srf,dim)
%ƥ���˲�dim = 0 Ϊ���򣬷�֮Ϊ����
% 
if (dim == 1)
    sig = sig.';
end
[nr,nc] = size(sig);
fftnum = nc;
fftsrf = fft(srf,fftnum);
cfftsrf = ones(nr,1)*conj(fftsrf);
sigfft = fft(sig,fftnum,2);
sig = ifft(sigfft.*cfftsrf,fftnum,2);
if (dim ==1)
    sig = sig.';
end
result = sig;
end

