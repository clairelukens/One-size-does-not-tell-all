function[ z, zUnc ] = ageZ ( age )
    %% Parameters obtained from OLS regression of age vs. elevation
    % Answers question: What elevation do I predict given a measured age?
    n=10; %number of measurements in OLS regression
    b= 0.0222514; %Ma/m slope of the OLS regression line
    sb = 0.002034; %Ma/m standard error of the slope
    rmse = 4.781297; %Ma root mean square error of the regression
    %zBar= 3047.7; %m mean elevation
    ageBar= 44.431819; %Ma mean age
    a= -23.38364; %Ma y intercept
    %sa= 6.379912; %Ma standard error in intercept
    
    nu=n-2;
    t=tinv(0.84,nu);
    K=b^2-t^2*sb^2;
    ssx=783.671^2*(n-1); %Uses sample SSx which may be incorrect (need n?)
    %still not totally sure after checking but using n-1 is more
    %conservative
    %% Calculate elevation and uncertainties factor from ages
    %(inverse prediction)
    z= (age-a)/b; % elevation in m; age in Ma
    zUnc = t*rmse/K.*(((age-ageBar).^2/ssx)+K*(1/n+1/n)).^0.5; 
    %error in m (CI on fit, not prediciton); this is inverse prediction; 
    %formula from Zar (17.33), using n for m

    
    
end
