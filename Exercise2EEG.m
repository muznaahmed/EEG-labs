close all
clear all

fs=500;
t=0:1/fs:5;
f1=5; %Hz
Amp1=0.75 ;
s1=Amp1*sin(2*pi*t*f1);

f2=7; %hz
Amp2=1;
width=0.5;
s2=sawtooth(2*pi*t*f2, width);

Amp3=0.5;
f3=3; %Hz
duty=40;

s3=Amp3*square(2*pi*t*f3, duty);

s1=s1-mean(s1);
s2=s2-mean(s2);
s3=s3-mean(s3);

%Mixingmatrix

A=[0.5 0.5 0.7;0.7 0.2 0.4; 0.2 0.7 -0.5];
S=[s1;s2;s3];
X=A*S;

figure()
subplot(311)
plot(t,s1)
subplot(312)
plot(t,s2)
subplot(313)
plot(t,s3)

figure()
subplot(311)
plot(t,X(1,:))
title('Mixed Variables')
subplot(312)
plot(t,X(2,:))
subplot(313)
plot(t,X(3,:))
xlabel('Time[S]')


%%PCA of X
[V,D]=eig(cov(X')); %Deigenvalues %Veigenvectors 
fprintf('to obtain PCA of X, we have to  find the covariance of eigen vector');
W=V'; %use this to make the coloumn  eigen vector a row vector
PC=W*X;


figure()
subplot(311)
plot(t,PC(1,:))
title('PCA')
subplot(312)
plot(t,PC(2,:))
subplot(313)
plot(t,PC(3,:))
xlabel('Time[S]')


fprintf('PCA is not able to reconstruct the orignal component .\n') %we checked before writing this on the plot there was no reconstruction .\n is used to put the statement below
save('X.mat', 'X') %saving the variables in .mat file


%%Using demixing matrix (4g)
demix=load('demixingmatrix.txt');
%%5)
ICS=demix*X;
figure()
subplot(311)
plot(t,ICS(1,:))
ylabel('ICS1')
subplot(312)
plot(t,ICS(2,:))
ylabel('ICS2')
subplot(313)
plot(t,ICS(3,:))
xlabel('Time[S]')
ylabel('ICS3')

%%Generating five variables xi(t) from centered signals S
A=[0.5 0.5 0.7;0.7 0.2 0.4; 0.2 0.7 -0.5; -0.6 0.3 0.2 ; 0.1 -0.5 0.4];
X=A*S;
fprintf('number r of observed variables X is greater than number n of independent sources i.e r>n');


%PCA OF X
[V,D]=eig(cov(X')); %Deigenvalues %Veigenvectors 
fprintf('to obtain PCA of X, we have to  find the covariance of eigen vector');
W=V'; %use this to make the coloumn  eigen vector a row vector
PC=W*X;

%5 Observed Variables  plot
for i=1:5
     subplot(5,1,i)
     plot(t,X(i,:))
     xlabel('Time[sec]')
end

%Plot of PCA
for i=1:5
     subplot(5,1,i)
     plot(t,PC(i,:))
     xlabel('Time[sec]')
end 
%the covariance matrix is by default in order from min to max check cov(X')
%V is the eigen vector and its first coloumn is the minimum and the last coloumn is max 
%to select 3 PCA
PC2=PC(3:end, :);