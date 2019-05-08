clear all;
%close all;
%% ������
c = 2.9979e+8; 
%% �״����
global mradar
                %PRF       %fc,      kr,       tr,     fr
mradar = radar(1256.98,5.300e+9,0.72135e+12,41.75e-6,32.317e+6);
B = mradar.kr*mradar.tr
T = 1/mradar.PRF
%% �������
r0  = 0.0065956*c/2; 
vm = 7062;
kd = 2*vm^2*mradar.fc/c/r0
%% �ز����ݣ���ȥ��Ƶ��
CDdata = load('CDdata1.mat');
sr=CDdata.data;
[N,M] = size(sr);
%% ƥ���˲�
t = 0:1/mradar.fr:mradar.tr;
sref = exp(-1j*pi*mradar.kr*t.^2);
result = matchfilter(sr,sref,0);
figure,imagesc(abs(result));
%graymap = gray; colormap(graymap(end:-1:1,:));
%% ��λ��ƥ���˲�
n=1:1:N;
tm=(-N/2+n)./mradar.PRF;
%%��ʱ�������б�ӽ�δ֪������������Ƶ��δ֪���޷�ʱ�����
% sref2=exp(1j*pi*kd*tm.^2);
% azimuth= matchfilter(result,sref2,1);
%%��Ƶ�������ʹƵ������������Ƶ�ʷ�Χ���Ӷ�����ʵ���ź�����
fa=-mradar.PRF/2+mradar.PRF*(n-1)/N;
ref2=exp(-1j*pi*fa.^2./kd);
azimuth=ifft(fft(result).*(ref2.'*ones(1,M)));       
%% ������
image=mat2gray(abs(azimuth));
image=image*8*1;
imwrite(image,'SAR_RD.jpg','JPG');
figure,imagesc(abs(azimuth));
%graymap = gray;colormap(graymap(end:-1:1,:));
