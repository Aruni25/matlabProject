function result = classify_spam(feature_vector, likelihood_class_0, likelihood_class_1, log_prior_class_0, log_prior_class_1)
    log_likelihood_0 = 0;
    log_likelihood_1 = 0;
    
    % Calculate log likelihood for class 0 (Not Spam)
    for i = 1:length(feature_vector)
        if feature_vector(i) == 1
            log_likelihood_0 = log_likelihood_0 + log10(likelihood_class_0(i));
        else
            log_likelihood_0 = log_likelihood_0 + log10(1 - likelihood_class_0(i));
        end
    end

    % Calculate log likelihood for class 1 (Spam)
    for i = 1:length(feature_vector)
        if feature_vector(i) == 1
            log_likelihood_1 = log_likelihood_1 + log10(likelihood_class_1(i));
        else
            log_likelihood_1 = log_likelihood_1 + log10(1 - likelihood_class_1(i));
        end
    end
    
    % Add the log priors
  log_likelihood_0 = sum(feature_vector .* log(likelihood_class_0) + (1 - feature_vector) .* log(1 - likelihood_class_0));
    log_likelihood_1 = sum(feature_vector .* log(likelihood_class_1) + (1 - feature_vector) .* log(1 - likelihood_class_1));
    
    % Calculate the log posterior probabilities
    log_posterior_0 = log_likelihood_0 + log_prior_class_0;
    log_posterior_1 = log_likelihood_1 + log_prior_class_1;
    
    % Classify based on the higher log posterior probability
    if log_posterior_1 > log_posterior_0
        result = 1;  % Spam
    else
        result = 0;  % Not spam
    end
end
