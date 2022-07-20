close all
clearvars
clc

%path ='C:\Users\adria\Documents\Uni\LM II anno\Tesi\opti_data.xlsx';
path ='C:/A_Tesi/Python/CTM-s/opti_data.xls';

%% extract data
T = readtable(path);
A = table2array(T);
cell_in = A(:, 1);
cell_out = A(:, 2);
delta = A(:, 3);
integral = A(:, 4);
max_delta = A(:,5);
pi_greco = A(:, 6);

%% Different i, j; delta fixed
delta = 360;
x = [];
y = [];
z = [];
fit_name=["poly11","poly12","poly21","poly22","poly13","poly31","poly23","poly32","poly33", ...
          "poly14","poly41","poly24","poly42","poly34","poly43","poly44",...
          "poly15","poly51","poly25","poly52","poly35","poly53","poly45","poly54","poly55"];
for i=1:length(cell_in)
    if(A(i,3)==delta)
        x=[x A(i,1)];
        y=[y A(i,2)];
        z=[z A(i,4)];
    end
end
x=x'; 
y=y'; 
z=z';

%n=length(z);
% x_grid=linspace(0, length(unique(x))+1, 50); 
% y_grid=linspace(1, length(unique(y))+2, 50);
% 
% [xq, yq]=meshgrid(x_grid,y_grid); %crea una griglia cartesiana 2D o 3D
% xq_vec=xq(:);
% yq_vec=yq(:); %serve per poter visualizzare la nostra stima
% 
% Phi1=[ones(n,1), x, y];
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

[f, gof] = fit([x, y],z,fit_name(1));
f_best=f;
gof_best=gof;
b = round(gof_best.adjrsquare,2);
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i));
    a = round(gof.adjrsquare,2);
    if(a > b)
        f_best=f;
        gof_best=gof;
        b = round(gof_best.adjrsquare,2);
    end
end

figure(1)
%mesh(xq, yq, curva1_matrix)
plot(f_best,[x y],z)
zlim([0 3500]);
xlabel('x - Cell IN')
ylabel('y - Cell OUT')
zlabel("Integral")
title("Integral Delta VS i, j")
legend(type(f_best))
grid on

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





% 
% %% Pi
% 
% %c = readtable('C:\Users\adria\Documents\Uni\LM II anno\Tesi\delta-vs-ij.xlsx', 'Sheet','3h_single');
% x = table2array(path(:, "i"));
% y = table2array(path(:, "delta"));
% z = table2array(path(:, "pi"));
% n = length(z);
% 
% x_grid=linspace(0, 11, 50); % fare dinamico
% y_grid=linspace(0, 400, 50);
% [xq, yq]=meshgrid(x_grid,y_grid); %crea una griglia cartesiana 2D o 3D
% xq_vec=xq(:);
% yq_vec=yq(:); %serve per poter visualizzare la nostra stima
% 
% Phi3=[ones(n,1), x, y, x.^2, y.^2, x.*y, x.^3, y.^3, (x.^2).*y, x.*(y.^2)];
% 
% [theta3, std_theta3]=lscov(Phi3, z); %calcola il vettore dei parametri e la sua std dev
% 
% q3=length(theta3);
% y_hat3=Phi3*theta3; %stima
% epsilon3=z-y_hat3; %residui
% SSR3=epsilon3'*epsilon3; 
% 
% Phi3_grid=[ones(length(xq_vec), 1), xq_vec, yq_vec, xq_vec.^2, yq_vec.^2, xq_vec.*yq_vec, xq_vec.^3, yq_vec.^3, (xq_vec.^2).*yq_vec, xq_vec.*(yq_vec.^2)];
% curva3=Phi3_grid*theta3;
% curva3_matrix=reshape(curva3, size(xq));
% 
% figure(3)
% mesh(xq, yq, curva3_matrix)
% hold on
% plot3(x,y,z, '*')
% xlabel('Cell IN')
% ylabel('delta (timesteps)')
% zlabel("Pi")
% title("Pi VS i, delta")
% grid on
% legend('polinomio di grado 3', 'dati')
% 
% 
% FPE3=((n+q3)/(n-q3))*SSR3;
% AIC3=2*q3/n +log(SSR3);
% MDL3=log(n)*q3/n + log(SSR3);
% 
% 
% 
% 
% 
% 















