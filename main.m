function result = main(tolerance)
%MAIN Compute and verify CEC 2026 BC-SOP comparison results.
%   MAIN(TOLERANCE) accepts 0 or 1e-8; the default is 1e-8.

%% Evaluation tolerance
defaultTolerance = 1e-8;

if nargin == 0, tolerance = defaultTolerance; end
if ~isnumeric(tolerance) || ~isreal(tolerance) || ~isscalar(tolerance) || ...
        ~isfinite(tolerance) || ~ismember(tolerance, [0, 1e-8])
    error('main:InvalidTolerance', 'Tolerance must be 0 or 1e-8.');
end
if tolerance == 0
    profile = 'strict';
    filename = 'tolerance0.csv';
else
    profile = 'uniform_1e8';
    filename = 'tolerance1e-8.csv';
end

root = fileparts(mfilename('fullpath'));
oldPath = path;
restorePath = onCleanup(@() path(oldPath));
addpath(fullfile(root, 'code'), '-begin');
csvFile = fullfile(root, 'results', filename);
expected = readtable(csvFile, 'TextType', 'string', 'Delimiter', ',');
result = run_cec2026_bc_sops(profile);
columns = {'Rank','Algorithm','TotalAccuracy','TotalSpeed','TotalScore','RankSum'};
assert(isequal(result.ranking(:,columns), expected(:,columns)), ...
    'main:ResultMismatch', 'Computed values differ from the supplied result table.');

% Replace only the selected CSV, after verification succeeds.
temporaryFile = [tempname(fullfile(root, 'results')) '.csv'];
cleanupFile = onCleanup(@() removeTemporaryFile(temporaryFile));
writetable(result.ranking, temporaryFile);
[ok, message] = movefile(temporaryFile, csvFile, 'f');
assert(ok, 'main:WriteFailed', '%s', message);
disp(result.ranking);
fprintf('PASS: Tolerance=%g. All scores and ranks match.\n%s\n', tolerance, csvFile);
end

function removeTemporaryFile(filename)
if isfile(filename), delete(filename); end
end
