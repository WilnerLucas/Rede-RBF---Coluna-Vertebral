clc;

%% WILNER LUCAS F. DE FRANÇA - 405023
%% CLASSIFICAÇÃO COM REDE RBF

% Inicializando a base de dados
dados  = load ('Coluna_vertebral.dat');
dados = normalizar(dados);

qtd_atributos = 6;
qtd_classes = 3;
realizacoes = 10;

% Definindo funcao de ativacao
 d = @(x, y) sqrt(sum((x-y).^2));
 gauss = @(x, c, ro) exp(d(x, c)^2/(-2*ro^2));


taxa_de_acerto = zeros(realizacoes, 1);

for k=1:realizacoes

    % Embaralha os dados
    dados = dados(randperm (size(dados, 1)), :);

    % Definindo conjunto de treino
    x_treino = dados(1:size(dados, 1)-96, :);

    % Definindo conjunto de testes
    x_teste = dados (size(dados, 1)-95:end, :);
    X = x_teste(:, 1:size(x_teste, 2) - qtd_classes);
    D = x_teste(:, qtd_atributos + 1:end);
   
    % Treinando a rede
    abertura = 5;
    qtd_centroides = 20; %[qtd_centroides, abertura] = validacao(dados, qtd_classes, qtd_atributos);
    
    %Definindo posicao indices dos centroides
    i_centroides = randperm(qtd_centroides);
    centroides = X(i_centroides, :); % Definido conjunto de centroides
    W = RBF (x_treino, qtd_classes, qtd_atributos, centroides, abertura);
    
    acertos = 0;
    Y = zeros();
    for i=1:size(X, 1);
        x_i = X(i,:);
        for j=1:qtd_centroides
            Y(i, j) = gauss(x_i, centroides(j,:), abertura);
        end
        h = [-1 Y(i,:)];
        y = ativacao(h*W);

        if (isequal(y, D(i,:)))
            acertos = acertos+1;
        end
    end
    fprintf ('EXECUÇÃO %d\n', k);
    taxa_de_acerto(k) = acertos/size(x_teste, 1);
end

Acuracia = mean(taxa_de_acerto)

figure(1)
plot(taxa_de_acerto, '--');
hold on
for i=1:10
   scatter(i, taxa_de_acerto(i), 'o', 'black');
   hold on;
end
title('Taxa de Acertos para "Coluna"');
xlabel('Execuções');
ylabel('Taxa de acerto');
hold off;