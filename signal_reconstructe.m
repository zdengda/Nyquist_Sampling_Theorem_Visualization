% % Copyright(c) 2020
% %
% % Please DO NOT delete the annotation when you forward.
% % 转发请不要删除此注释。
% %
% % Auther: @bilibili z瞳孔
% % Date: 2021/1/19
% % 
% % This file is the source code of my original video in Bilibili.
% % https://www.bilibili.com/video/BV1Qp4y1x72P
% % Opening the source code, and hopefully it will be helpful.
% % 
% % Thank you.
% %
% % --------------------------------------------------------------

clc;clear
% generate the real signal
f = [1 5 10 13 18 20 25 50];% real signal frequency
A = [1 2 1 0.5 1.2 0.3 0.2 0.6];% corresponding amplitude
x = @(t) 0;
for i = f
    x = @(t) x(t) + A(f==i).*sin(2*pi*i*t);
end
%-----------------------------------------
% the interpolation function
h = @(t,freq) sin(pi*freq*t)./(pi*freq*t).*(t~=0)+1.*(t == 0);
fs0 = 1; % initial sampling frequency
T = 1/fs0;
% generate the reconstructed signal
t = 0:0.0005:1;
N = 500; % sum scale
xs = zeros(1,length(t));
k = -N:N;
for i = 1:length(t)
    xs(i) = x(k*T)*(h(t(i)-k*T,fs0))';
end
%----------------------------------------
% drawing (1st)
hold on
fig = gcf;
fig.WindowState = 'maximized';
ob1 = plot(t,x(t));
ob1.Color = [0.47,0.76,0.97];
ob1.LineWidth = 1.5;
%
ob2 = plot(t,xs);
ob2.LineWidth = 1.4;
ob2.Color = 'r';
%
ob3 = scatter(min(t):T:max(t)...
    ,x(min(t):T:max(t)),'ob');
ob3.SizeData = 50;
ob3.LineWidth = 1.3;
ob3.MarkerEdgeColor = 'r';
%
ob4 = legend('real signal','reconstructed signal','sampled points');
ob4.FontSize = 17;
ob4.Interpreter = 'latex';
grid on
%
ax = gca;
ax.FontSize = 18;
xlabel('Time /s','FontSize',30,'Interpreter','latex');
ylabel('Amplitude','FontSize',30,'Interpreter','latex');
ax.TickLabelInterpreter = 'latex';
title('Nyquist Sampling Theorem Visualization'...
    ,'FontSize',30,'Interpreter','latex')
tt = text(0.02,-5,{['$f_{max} = ',num2str(max(f)),'\ Hz$']...
    ,['$f_{s} = ',num2str(fs0),'\ Hz$']}...
    ,'Interpreter','latex'...
    ,'FontSize',25);
t2 = text(0.98,-5,'@bilibili z瞳孔'...
    ,'FontSize',25....
    ,'HorizontalAlignment','right'...
    ,'Color',[0.73,0.65,0.65]...
    ,'FontName','华文新魏');
axis([0 1 -6 6]) % fixed the axes
%-------------------------------------
% create GIF
for fs = fs0:0.1:110 % sampling frequency scale
    T = 1/fs;
    xs = zeros(1,length(t));
    for i = 1:length(t)
        xs(i) = x(k*T)*(h(t(i)-k*T,fs))';
    end
    
    % change the corresponding properties
    ob2.YData = xs;
    ob3.XData = min(t):T:max(t);
    ob3.YData = x(min(t):T:max(t));
    tt.String = {['$f_{max} = ',num2str(max(f),'%.1f'),'Hz$']...
        ,['$f_{s} = ','\ ',num2str(fs,'%.1f'),'Hz$']};
    drawnow; % draw again
    
    %%% GIF creating code
    %
    %
    % str1 = 'test_signal_reconstruct2.gif';
    % ff=getframe(gcf);
    % imind=frame2im(ff);
    % [imind,cm] = rgb2ind(imind,256);
    % if fs == fs0
    %     imwrite(imind,cm,str1,'GIF', 'Loopcount',inf);
    % else
    %     imwrite(imind,cm,str1,'GIF','WriteMode','append');
    % end
    
end
