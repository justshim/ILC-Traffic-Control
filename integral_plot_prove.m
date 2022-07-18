close all
clearvars
clc

%% Different i, j; same delta (11 min)

%a = readtable('C:\Users\adria\Documents\Uni\LM II anno\Tesi\delta-vs-ij.xlsx');
path = readtable('C:/A_Tesi/Python/CTM-s/opti_data.xls');

% x = table2array(path(:, "i"));
% y = table2array(path(:, "j"));
% z = table2array(path(:, "integral"));
% 
% x_grid=linspace(0, 11, 50); % fare dinamico
% y_grid=linspace(0, 11, 50);
% 
% [xq, yq]=meshgrid(x_grid,y_grid); %crea una griglia cartesiana 2D o 3D
% xq_vec=xq(:);
% yq_vec=yq(:); %serve per poter visualizzare la nostra stima
% 
% Phi1=[ones(length(z),1), x, y];
% 
% [theta1, std_theta1]=lscov(Phi1, z); %calcola il vettore dei parametri e la sua std dev
% 
% q1=length(theta1);
% y_hat1=Phi1*theta1; %stima
% epsilon1=z-y_hat1; %residui
% SSR1=epsilon1'*epsilon1; 
% 
% Phi1_grid=[ones(length(xq_vec), 1), xq_vec, yq_vec];
% curva1=Phi1_grid*theta1;
% curva1_matrix=reshape(curva1, size(xq));
% 
% figure(1)
% mesh(xq, yq, curva1_matrix)
% hold on
% plot3(x,y,z, '*')
% xlabel('Cell IN')
% ylabel('Cell OUT')
% zlabel("Integral Delta")
% title("Integral Delta VS i, j")
% grid on
% legend('polinomio di grado 1', 'dati')

%% Different i, delta (5-60 min); j = i+2

%b = readtable('C:\Users\adria\Documents\Uni\LM II anno\Tesi\delta-vs-ij.xlsx', 'Sheet','24_real_smooth');
% 
% x = table2array(path(:, "i"));
% y = table2array(path(:, "delta"));
% z = table2array(path(:, "integral"));
% n=length(z);
% x_grid=linspace(0, 11, 50);% fare dinamico
% y_grid=linspace(0, 400, 50);
% % 
% [xq, yq]=meshgrid(x_grid,y_grid); %crea una griglia cartesiana 2D o 3D
% xq_vec=xq(:);
% yq_vec=yq(:); %serve per poter visualizzare la nostra stima
% % 
% Phi2=[ones(n,1), sin((2*pi*x)/11), cos((2*pi*x)/11), sin((2*pi*y)/400), cos((2*pi*y)/400)...
%     sin((4*pi*x)/11), cos((4*pi*x)/11), sin((4*pi*y)/400), cos((4*pi*y)/400) ...
%     sin((6*pi*x)/11), cos((6*pi*x)/11), sin((6*pi*y)/400), cos((6*pi*y)/400)];
% 
% Phi2=[ones(n,1), sin((2*pi*x)/11), cos((2*pi*x)/11), sin((2*pi*y)/400), cos((2*pi*y)/400)...
%     sin((4*pi*x)/11), cos((4*pi*x)/11), sin((4*pi*y)/400), cos((4*pi*y)/400)];
% 
% Phi2=[ones(n,1), sin((2*pi*x)/11), cos((2*pi*x)/11), sin((2*pi*y)/400), cos((2*pi*y)/400)...
%     sin((2*pi*x)/11).*sin((2*pi*y)/400), sin((2*pi*x)/11).*cos((2*pi*y)/400), cos((2*pi*x)/11).*sin((2*pi*y)/400),cos((2*pi*x)/11).*cos((2*pi*y)/400)];
% 
% Phi2=[ones(n,1), sin((2*pi*x)/11), cos((2*pi*x)/11)...
%     sin((4*pi*x)/11), cos((4*pi*x)/11)];
% 
% Phi2=[ones(n,1), x, y, x.^2, y.^2, x.*y, x.^3, y.^3, (x.^2).*y, x.*(y.^2)...
%     x.^4, y.^4, (x.^3).*y, x.*(y.^3), (x.^2).*(y.^2)...
%     x.^5, y.^5, (x.^4).*y, x.*(y.^4), (x.^3).*(y.^2), (x.^2).*(y.^3)];
% 
% Phi2=[ones(n,1), x, y, x.^2, y.^2, x.*y, x.^3, y.^3, (x.^2).*y, x.*(y.^2)...
%     x.^4, y.^4, (x.^3).*y, x.*(y.^3), (x.^2).*(y.^2)];
% 
% Phi2=[ones(n,1), x, y, x.^2, y.^2, x.*y, x.^3, y.^3, (x.^2).*y, x.*(y.^2)];
% 
% 
% Phi2=[ones((length(z)),1), x, y, x.^2, y.^2, x.*y];
% 
% [theta2, std_theta2]=lscov(Phi2, z); %calcola il vettore dei parametri e la sua std dev
% 
% q2=length(theta2);
% y_hat2=Phi2*theta2; %stima
% epsilon2=z-y_hat2; %residui
% SSR2=epsilon2'*epsilon2; 
% 
% Phi2_grid=[ones(length(xq_vec), 1), sin((2*pi*xq_vec)/11), cos((2*pi*xq_vec)/11), sin((2*pi*yq_vec)/400), cos((2*pi*yq_vec)/400)...
%     sin((4*pi*xq_vec)/11), cos((4*pi*xq_vec)/11), sin((4*pi*yq_vec)/400), cos((4*pi*yq_vec)/400) ...
%     sin((6*pi*xq_vec)/11), cos((6*pi*xq_vec)/11), sin((6*pi*yq_vec)/400), cos((6*pi*yq_vec)/400)];
% 
% Phi2_grid=[ones(length(xq_vec), 1), sin((2*pi*xq_vec)/11), cos((2*pi*xq_vec)/11), sin((2*pi*yq_vec)/400), cos((2*pi*yq_vec)/400)...
%     sin((4*pi*xq_vec)/11), cos((4*pi*xq_vec)/11), sin((4*pi*yq_vec)/400), cos((4*pi*yq_vec)/400)];
% 
% 
% Phi2_grid=[ones(length(xq_vec), 1), sin((2*pi*xq_vec)/11), cos((2*pi*xq_vec)/11), sin((2*pi*yq_vec)/400), cos((2*pi*yq_vec)/400)...
%     sin((2*pi*xq_vec)/11).*sin((2*pi*yq_vec)/400), sin((2*pi*xq_vec)/11).*cos((2*pi*yq_vec)/400), cos((2*pi*xq_vec)/11).*sin((2*pi*yq_vec)/400),cos((2*pi*xq_vec)/11).*cos((2*pi*yq_vec)/400)];
% 
% Phi2_grid=[ones(length(xq_vec), 1), sin((2*pi*xq_vec)/11), cos((2*pi*xq_vec)/11)...
%     sin((4*pi*xq_vec)/11), cos((4*pi*xq_vec)/11)];
% 
% Phi2_grid=[ones(length(xq_vec), 1), xq_vec, yq_vec, xq_vec.^2, yq_vec.^2, xq_vec.*yq_vec, xq_vec.^3, yq_vec.^3,(xq_vec.^2).*yq_vec, xq_vec.*(yq_vec.^2)...
%     xq_vec.^4, yq_vec.^4, (xq_vec.^3).*yq_vec, xq_vec.*(yq_vec.^3), (xq_vec.^2).*(yq_vec.^2)...
%     xq_vec.^5, yq_vec.^5, (xq_vec.^4).*yq_vec, xq_vec.*(yq_vec.^4), (xq_vec.^3).*(yq_vec.^2), (xq_vec.^2).*(yq_vec.^3)];
% 
% Phi2_grid=[ones(length(xq_vec), 1), xq_vec, yq_vec, xq_vec.^2, yq_vec.^2, xq_vec.*yq_vec, xq_vec.^3, yq_vec.^3,  (xq_vec.^2).*yq_vec, xq_vec.*(yq_vec.^2)...
%     xq_vec.^4, yq_vec.^4, (xq_vec.^3).*yq_vec, xq_vec.*(yq_vec.^3), (xq_vec.^2).*(yq_vec.^2)];
% 
% Phi2_grid=[ones(length(xq_vec), 1), xq_vec, yq_vec, xq_vec.^2, yq_vec.^2, xq_vec.*yq_vec, xq_vec.^3, yq_vec.^3, (xq_vec.^2).*yq_vec, xq_vec.*(yq_vec.^2)];
% 
% 
% Phi2_grid=[ones(length(xq_vec), 1), xq_vec, yq_vec, xq_vec.^2, yq_vec.^2, xq_vec.*yq_vec];
% 
% curva2=Phi2_grid*theta2;
% curva2_matrix=reshape(curva2, size(xq));
% 
% figure(2)
% mesh(xq, yq, curva2_matrix)
% hold on
% plot3(x,y,z, '*')
% xlabel('Cell IN')
% ylabel('delta (timesteps)')
% zlabel("Integral Delta")
% title("Integral Delta VS i, delta")
% grid on
% legend('polinomio di grado 2', 'dati')






%% Pi

%c = readtable('C:\Users\adria\Documents\Uni\LM II anno\Tesi\delta-vs-ij.xlsx', 'Sheet','3h_single');
x = table2array(path(:, "i"));
y = table2array(path(:, "delta"));
z = table2array(path(:, "pi"));
n = length(z);

x_grid=linspace(0, 11, 50); % fare dinamico
y_grid=linspace(0, 400, 50);
[xq, yq]=meshgrid(x_grid,y_grid); %crea una griglia cartesiana 2D o 3D
xq_vec=xq(:);
yq_vec=yq(:); %serve per poter visualizzare la nostra stima

Phi3=[ones(n,1), x, y, x.^2, y.^2, x.*y, x.^3, y.^3, (x.^2).*y, x.*(y.^2)];

[theta3, std_theta3]=lscov(Phi3, z); %calcola il vettore dei parametri e la sua std dev

q3=length(theta3);
y_hat3=Phi3*theta3; %stima
epsilon3=z-y_hat3; %residui
SSR3=epsilon3'*epsilon3; 

Phi3_grid=[ones(length(xq_vec), 1), xq_vec, yq_vec, xq_vec.^2, yq_vec.^2, xq_vec.*yq_vec, xq_vec.^3, yq_vec.^3, (xq_vec.^2).*yq_vec, xq_vec.*(yq_vec.^2)];
curva3=Phi3_grid*theta3;
curva3_matrix=reshape(curva3, size(xq));

figure(3)
mesh(xq, yq, curva3_matrix)
hold on
plot3(x,y,z, '*')
xlabel('Cell IN')
ylabel('delta (timesteps)')
zlabel("Pi")
title("Pi VS i, delta")
grid on
legend('polinomio di grado 3', 'dati')


FPE3=((n+q3)/(n-q3))*SSR3;
AIC3=2*q3/n +log(SSR3);
MDL3=log(n)*q3/n + log(SSR3);





















