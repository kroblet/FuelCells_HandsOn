
% Nom du modèle Simulink
modelName = 'ideal_power_source';

% Charge le modèle sans le lancer
load_system(modelName);

% Crée un vecteur de 20 valeurs linéairement espacées entre 0.05 et 75
pressureDropValues = linspace(0.05, 75, 20);

% Boucle sur toutes les valeurs de NPressureDrop
for i = 1:length(pressureDropValues)
    % Crée un objet de simulation Simulink
    simInput(i) = Simulink.SimulationInput(modelName);
    
    % Modifie la variable NPressureDrop dans le workspace de la simulation
    simInput(i) = setVariable(simInput(i), 'NPressureDrop', pressureDropValues(i));

    % Définit la fonction de post-traitement
    simInput(i) = setPostSimFcn(simInput(i), @(x) postProcessFcn(x)); 
end

% Exécute la simulation
simOut = sim(simInput);

% Fonction de post-traitement pour calculer la valeur moyenne de PCompressor
function newOut = postProcessFcn(simOut)
    % Extrait les données du signal PCompressor
    PCompressorData = simOut.yout.get('PCompressor').Values.Data;
    
    % Calcule la valeur moyenne du signal PCompressor
    newOut.meanValue = mean(PCompressorData);
end