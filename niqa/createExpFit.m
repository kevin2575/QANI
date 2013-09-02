function [fitresult, gof] = createExpFit(score, dmos145)
%CREATEFIT(SCORE,DMOS145)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : score
%      Y Output: dmos145
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 01-Sep-2013 21:37:50


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( score, dmos145 );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf -Inf];
opts.StartPoint = [898.955084505107 -5.08994910549762 0.000946753922222047 11.0639879348596];
opts.Upper = [Inf Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );