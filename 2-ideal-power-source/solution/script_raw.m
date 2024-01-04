
% Nom du modèle Simulink
modelName = 'ideal_power_source';

% Charge le modèle sans le lancer
load_system(modelName);

% Crée un vecteur de 20 valeurs linéairement espacées entre 0.05 et 75
pressureDropValues = linspace(0.05, 75, 20);

% Initialisation du tableau pour stocker les valeurs moyennes
meanPCompressor = zeros(1, length(pressureDropValues));

% Fonction de post-traitement pour calculer la valeur moyenne de PCompressor
function meanValue = postProcessFcn(simOut)
    % Extrait les données du signal PCompressor
    PCompressorData = simOut.yout.get('PCompressor').Values.Data;
    
    % Calcule la valeur moyenne du signal PCompressor
    meanValue = mean(PCompressorData);
end

% Boucle sur toutes les valeurs de NPressureDrop
for i = 1:length(pressureDropValues)
    % Crée un objet de simulation Simulink
    simInput = Simulink.SimulationInput(modelName);
    
    % Modifie la variable NPressureDrop dans le workspace de la simulation
    simInput = simInput.setVariable('NPressureDrop', pressureDropValues(i));
    
    % Définit la fonction de post-traitement
    simInput = simInput.setPostSimFcn(@postProcessFcn);
    
    % Exécute la simulation
    simOut = sim(simInput);
    
    % Stocke la valeur moyenne retournée par la fonction de post-traitement
    meanPCompressor(i) = simOut.SimulationMetadata.UserData;
end

% Affiche les résultats
disp('Valeurs moyennes de PCompressor pour différentes chutes de pression:');
disp(meanPCompressor);

% Sauvegarde les résultats dans un fichier .mat
save('meanPCompressorResults.mat', 'meanPCompressor');

% Ferme le modèle sans sauvegarder
close_system(modelName, 0);