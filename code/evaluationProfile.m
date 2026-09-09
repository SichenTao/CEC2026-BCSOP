function profile = evaluationProfile(name)
%EVALUATIONPROFILE Return a named CEC 2026 evaluation configuration.
%   PROFILE = EVALUATIONPROFILE('strict') uses exact comparisons.
%   PROFILE = EVALUATIONPROFILE('uniform_1e8') uses absolute 1e-8 thresholds.
%   All tolerances are absolute.

if isstring(name) && isscalar(name)
    profileName = char(name);
elseif ischar(name) && isrow(name)
    profileName = name;
else
    error('evaluationProfile:InvalidName', ...
        'Profile name must be a character vector or scalar string.');
end

switch profileName
    case 'strict'
        cutoffTol = 0;
        accuracyTieTol = 0;
        speedReachTol = 0;
        rankTieTol = 0;
    case 'uniform_1e8'
        cutoffTol = 1e-8;
        accuracyTieTol = 1e-8;
        speedReachTol = 1e-8;
        rankTieTol = 1e-8;
    otherwise
        error('evaluationProfile:UnknownProfile', ...
            'Unknown evaluation profile: %s.', profileName);
end

profile = struct('id', string(profileName), ...
    'cutoffTol', cutoffTol, ...
    'accuracyTieTol', accuracyTieTol, ...
    'speedReachTol', speedReachTol, ...
    'rankTieTol', rankTieTol);

% Validate finite, nonnegative scalar tolerances.
validateTolerance(profile.cutoffTol, 'cutoffTol');
validateTolerance(profile.accuracyTieTol, 'accuracyTieTol');
validateTolerance(profile.speedReachTol, 'speedReachTol');
validateTolerance(profile.rankTieTol, 'rankTieTol');
end

function validateTolerance(value, fieldName)
if ~isnumeric(value) || ~isreal(value) || ~isscalar(value) || ...
        ~isfinite(value) || value < 0
    error('evaluationProfile:InvalidTolerance', ...
        '%s must be a finite, nonnegative scalar.', fieldName);
end
end
