function [ centroides, abertura] = validacao( dados, qtd_classes, qtd_atributos)
  
    
    %% SETUP INICIAL
    grade = zeros(5);
    d = @(x, y) sqrt(sum((x-y).^2));
    gauss = @(x, c, ro) exp(d(x, c)^2/(-2*ro^2));
    
    %% TREINANDO A REDE
    for i=1:size(grade, 1)
        for j=1:size(grade, 2)
            
            acuracia = zeros(5, 1);
            
            %Embaralhando os dados
            dados = dados(randperm(size(dados, 1)), :)
            
            % Separando os folds
            fold1 = dados((size(dados, 1)/5)*0+1:size(dados, 1)-(size(dados, 1)-1*(size(dados, 1)/5)),:);
            fold2 = dados((size(dados, 1)/5)*1+1:size(dados, 1)-(size(dados, 1)-2*(size(dados, 1)/5)),:);
            fold3 = dados((size(dados, 1)/5)*2+1:size(dados, 1)-(size(dados, 1)-3*(size(dados, 1)/5)),:);
            fold4 = dados((size(dados, 1)/5)*3+1:size(dados, 1)-(size(dados, 1)-4*(size(dados, 1)/5)),:);
            fold5 = dados((size(dados, 1)/5)*4+1:size(dados, 1)-(size(dados, 1)-5*(size(dados, 1)/5)),:);
            
            for k=1:5 
                if (k==1)
                    foldTeste = fold1;
                    foldTrain = vertcat(fold2, fold3, fold4, fold5);
                elseif(k==2)
                    foldTeste = fold2;
                    foldTrain = vertcat(fold1, fold3, fold4, fold5);
                elseif(k==3)
                    foldTeste = fold3;
                    foldTrain = vertcat(fold2, fold1, fold4, fold5);
                elseif(k==4)
                    foldTeste = fold4;
                    foldTrain = vertcat(fold2, fold3, fold1, fold5);
                else
                    foldTeste = fold5;
                    foldTrain = vertcat(fold2, fold3, fold4, fold1);
                end
                
                qtd_centroides = 3*i;
                abertura = j;
                X = foldTeste(:, 1:size(foldTeste, 2) - qtd_classes);
                D = foldTeste(:, qtd_atributos + 1:end);
                i_centroides = randperm(qtd_centroides);
                centroides = X(i_centroides, :);
                W = RBF(foldTrain, qtd_classes, qtd_atributos, centroides, abertura);
                acertos = 0;
                Y = zeros();
                for m=1:size(X, 1)
                    x_i = X(i,:);
                    for n=1:qtd_centroides
                        Y(m, n) = gauss(x_i, centroides(n,:), abertura);
                    end
                    h = [-1 Y(m,:)];
                    y = ativacao(h*W);
                    if(isequal(y, D(m,:)))
                        acertos = acertos + 1;
                    end
                end
                acuracia(k) = acertos/size(foldTeste, 1);
            end
            grade(i, j) = mean(acuracia);
        end
    end
    [centroides, abertura] = getMaxIndex(grade);
    centroides = 3*centroides;
end
