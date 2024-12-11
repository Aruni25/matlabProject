function spamEmailClassifierGUI()
    % Create the main UI figure with a default background color
    fig = uifigure('Name', 'Spam Email Classifier', 'Position', [100, 100, 600, 400], 'Color', [0.53, 0.81, 0.92]);
    
    % Input label and text area for the email
    uilabel(fig, 'Text', 'Enter Email:', 'Position', [20, 350, 80, 20], 'BackgroundColor', [0.53, 0.81, 0.92]);
    emailInput = uitextarea(fig, 'Position', [120, 350, 460, 40], 'BackgroundColor', [0.9, 1, 1]);
    
    % Classify button with blue background (changing to white)
    classifyButton = uibutton(fig, 'Text', 'Classify Email', 'Position', [20, 280, 120, 30], ...
    'ButtonPushedFcn', @(btn, event) classifyEmailButtonPushed(emailInput), 'BackgroundColor', [1, 1, 1]);

    % Classification result label (white background)
    resultLabel = uilabel(fig, 'Text', 'Classification Result:', 'Position', [20, 230, 130, 20], 'BackgroundColor', [1, 1, 1]);
    resultDisplay = uilabel(fig, 'Text', '', 'Position', [150, 230, 400, 20], 'FontWeight', 'bold', 'BackgroundColor', [1, 1, 1]);

    % Accuracy Display label (white background)
    accuracyLabel = uilabel(fig, 'Text', 'Model Accuracy:', 'Position', [20, 180, 130, 20], 'BackgroundColor', [1, 1, 1]);
    accuracyDisplay = uilabel(fig, 'Text', '', 'Position', [150, 180, 400, 20], 'FontWeight', 'bold', 'BackgroundColor', [1, 1, 1]);

    % Variables for model training
    global likelihood_class_0 likelihood_class_1 log_prior_class_0 log_prior_class_1;
    [likelihood_class_0, likelihood_class_1, log_prior_class_0, log_prior_class_1] = trainModel();
    
    % Function to classify the entered email
    function classifyEmailButtonPushed(emailInput)
        str = emailInput.Value;  % Get input email content
        feature_vector = getvector(str);  % Convert email to feature vector
        
        % Classify the email
        result = classify_spam(feature_vector, likelihood_class_0, likelihood_class_1, log_prior_class_0, log_prior_class_1);
        
        % Change the background color of the text boxes to white
        emailInput.BackgroundColor = [1, 1, 1];  % White
        resultDisplay.BackgroundColor = [1, 1, 1];  % White
        accuracyDisplay.BackgroundColor = [1, 1, 1];  % White
        classifyButton.BackgroundColor = [1, 1, 1];  % White (optional)
        
        % Display the classification result and set the text color
        if result == 1
            resultDisplay.Text = 'SPAM';
            resultDisplay.FontColor = [1, 0, 0];  % Red
            fig.Color = [1, 0, 0];  % Red background for SPAM
        else
            resultDisplay.Text = 'NOT SPAM';
            resultDisplay.FontColor = [0, 1, 0];  % Green
            fig.Color = [0, 1, 0];  % Green background for NOT SPAM
        end
    end

    % Function to train the model and calculate likelihoods
    function [likelihood_class_0, likelihood_class_1, log_prior_class_0, log_prior_class_1] = trainModel()
        % Load the dataset and split it into class 0 and class 1
        M = csvread('spambase.csv');
        X_train_class_1 = [];
        X_train_class_0 = [];
        
        for i = 1:length(M)
            if M(i, 58) == 1
                X_train_class_1 = [X_train_class_1; M(i, 1:48)];
            else
                X_train_class_0 = [X_train_class_0; M(i, 1:48)];
            end
        end
        
        % Calculate likelihoods
        likelihood_class_1 = mean(X_train_class_1) / 100.0;
        likelihood_class_0 = mean(X_train_class_0) / 100.0;
        
        % Calculate class priors
        num_class_0 = length(X_train_class_0);
        num_class_1 = length(X_train_class_1);
        prior_probability_class_0 = num_class_0 / (num_class_0 + num_class_1);
        prior_probability_class_1 = num_class_1 / (num_class_0 + num_class_1);
        
        log_prior_class_0 = log10(prior_probability_class_0);
        log_prior_class_1 = log10(prior_probability_class_1);
        
        % Display accuracy
        correct = 0;
        for i = 1:length(M)
            if classify_spam(M(i, 1:48), likelihood_class_0, likelihood_class_1, log_prior_class_0, log_prior_class_1) == M(i, 58)
                correct = correct + 1;
            end
        end
        accuracy = correct * 100 / length(M);
        accuracyDisplay.Text = sprintf('%.2f%%', accuracy);
    end
end
