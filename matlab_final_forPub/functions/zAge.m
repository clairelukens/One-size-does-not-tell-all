function[ age, ageUnc, ageUnc2 ] = zAge ( z )
    %% Parameters obtained from OLS regression of age vs. elevation
    % Answers question: What age do I predict given a measured elevation?
    n=10; %number of measurements in OLS regression
    b= 0.0222514; %Ma/m slope of the OLS regression line
    sb = 0.002034; %Ma/a standard error of the slope
    rmse = 4.781297; %Ma root mean square error of the regression
    zBar= 3047.7; %m mean elevation
    %ageBar= 44.431819; %Ma mean age
    a= -23.38364; %Ma y intercept
    %sa= 6.379912; %Ma standard error in intercept


    %% Calculate elevation and uncertainties factor from ages
    age=a+b*z; % age in Ma; elevation in m
    ageUnc=((rmse)^2/n+(sb*(z-zBar)).^2).^0.5; %error in m (CI on plot);
    % this is s-y-hat in equation 20 in toolkit 10
    ageUnc2=(rmse^2+(rmse)^2/n+(sb*(z-zBar)).^2).^0.5; %error in m...
    % (CI on prediction); this is s-y-hat-sub-i in eqn. 21 of toolkit 10
    % for each point in the supplied list of measured ages

    
end
