function [normalized_dataset] = normalizar(dataset)
    n = size(dataset, 1);
    menor = repmat(min(dataset), n, 1);
    maior = repmat(max(dataset), n, 1);
    normalized_dataset = (dataset - menor) ./ (maior-menor);