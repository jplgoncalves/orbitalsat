% --- SIMULADOR DE SATÉLITE VIRTUAL ---
clear; clc; close all;

% 1. Configurações Físicas
G = 6.674e-11; 
M = 5.972e24; 
mu = G*M;
R_terra = 6371000; % Raio da Terra em metros

% 2. Definições da Órbita
altitude = 600000; % 600km de altitude (LEO)
r0 = R_terra + altitude;
inclinacao = deg2rad(51.6); % Inclinação da ISS (51.6 graus)

% 3. Criar a Terra com Cores Reais
figure('Color', 'k'); % Fundo preto como o espaço
[x, y, z] = sphere(50);
load('topo.mat', 'topo', 'topomap1'); 

s = surface(x*R_terra, y*R_terra, z*R_terra);
s.FaceColor = 'texturemap';
s.CData = topo;                
s.EdgeColor = 'none';          
colormap(topomap1);            

% Iluminação para parecer um planeta 3D
camlight right;    
lighting gouraud;  
axis equal; hold on; grid off;
set(gca, 'Color', 'k', 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none');
title('Satélite em Órbita Realista', 'Color', 'w');

% 4. Calcular a Trajetória
theta = linspace(0, 2*pi, 200);
sat_x = r0 * cos(theta);
sat_y = r0 * sin(theta) * cos(inclinacao);
sat_z = r0 * sin(theta) * sin(inclinacao);

% Desenhar a linha da órbita (rastro)
plot3(sat_x, sat_y, sat_z, 'w:', 'LineWidth', 0.5); 

% 5. Criar o Sensor (Mancha Amarela no Chão)
abertura = deg2rad(20);
raio_cobertura = altitude * tan(abertura);
t_circ = linspace(0, 2*pi, 50);
cx = raio_cobertura * cos(t_circ);
cy = raio_cobertura * sin(t_circ);
sensor_plot = fill3(cx, cy, R_terra*ones(size(cx)), 'y', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% 6. Criar o Satélite (Ponto Verde)
sat_ponto = plot3(sat_x(1), sat_y(1), sat_z(1), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8);

% 7. Loop de Animação
for k = 1:length(theta)
    % Atualiza posição do satélite
    set(sat_ponto, 'XData', sat_x(k), 'YData', sat_y(k), 'ZData', sat_z(k));
    
    % Calcula projeção do sensor na superfície curva
    pos_sat = [sat_x(k), sat_y(k), sat_z(k)];
    pos_chao = (pos_sat / norm(pos_sat)) * R_terra;
    
    % Move a mancha amarela (simplificado para visualização)
    set(sensor_plot, 'XData', pos_chao(1) + cx, 'YData', pos_chao(2) + cy, 'ZData', pos_chao(3));
    
    drawnow;
    pause(0.03); % Velocidade da animação
end