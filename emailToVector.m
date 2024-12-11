function feature_vector = emailToVector(sentence)
    % Convert the sentence to lowercase
    sentence = lower(sentence);
    
    % Remove punctuation (optional, for clean text)
    sentence = regexprep(sentence, '[^\w\s]', '');
    
    % List of words to check against (same words used during training)
    wordsList = textread('words.txt', '%s');  % Load the list of words from file
    
    % Tokenize the sentence into individual words
    emailWords = strsplit(sentence);
    
    % Initialize the feature vector with zeros
    feature_vector = zeros(1, length(wordsList));  % Adjust the size based on wordsList
    
    % Check each word in the sentence against the words in the words list
    for i = 1:length(wordsList)
        if ismember(wordsList{i}, emailWords)
            feature_vector(i) = 1;  % Word is present in the sentence
        end
    end
end
