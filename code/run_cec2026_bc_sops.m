function result = run_cec2026_bc_sops(profileName)
%RUN_CEC2026_BC_SOPS Evaluate the 11 original submissions with a named profile.

if nargin < 1 || isempty(profileName)
    error('run_cec2026_bc_sops:MissingProfile', ...
        'An explicit profile name is required.');
end
profile = evaluationProfile(profileName);
datasetName = 'original';
rootDir = fileparts(mfilename('fullpath'));
if isempty(rootDir), rootDir = pwd; end
packageRoot = fileparts(rootDir);
pro = 29; trial = 25; num = 1000;
algNames = {'RDE26','DE-2LS','RDEx','L-SRTDE','rcmaes','R-CMA-ES', ...
    'mLSHADE_LR','BlockEA','jSOa','IEACOP','ADSDE'};
dataDir = fullfile(packageRoot, 'data');
manifestPath = fullfile(dataDir, 'sources.csv');
manifest = readtable(manifestPath, 'TextType', 'string', 'Delimiter', ',', ...
    'ReadVariableNames', true, 'NumHeaderLines', 0);
validateManifest(manifest, algNames, packageRoot);

cache = cell(numel(algNames), pro);
for a = 1:numel(algNames)
    for f = 1:pro
        sourcePath = fullfile(dataDir, expectedLocalFile(algNames{a}, f));
        block = loadDataBlock(algNames{a}, dataDir, f);
        allowKnownNaN = strcmp(algNames{a}, 'L-SRTDE') && f == 19;
        validate_data_block(block, algNames{a}, f, sourcePath, allowKnownNaN);
        cache{a,f} = block;
    end
end
algs = struct('name', {}, 'getT', {});
for a = 1:numel(algNames)
    algs(a).name = algNames{a};
    algs(a).getT = makeCachedLoader(cache, a);
end

[SR, score, scoreTbl, rankTbl, srTotAll, Data, speedPart, accuracyPart] = ...
    uscore_BCSOPs(pro, trial, num, algs, profile);
uScore = sum(score, 1)'; rankSum = sum(SR, 1)';
totalAccuracy = sum(accuracyPart, 1)'; totalSpeed = sum(speedPart, 1)';
[~, order] = sort(rankSum, 'ascend');
ranking = table((1:numel(algNames))', string(algNames(order))', ...
    totalAccuracy(order), totalSpeed(order), uScore(order), rankSum(order), ...
    'VariableNames', {'Rank','Algorithm','TotalAccuracy','TotalSpeed', ...
    'TotalScore','RankSum'});

result = struct('ranking', ranking, 'scoreTbl', scoreTbl, 'rankTbl', rankTbl, ...
    'Data', Data, 'profile', profile, 'SR', SR, 'score', score, ...
    'datasetName', datasetName);
end

function validateManifest(manifest, algNames, rootDir)
required = {'algorithm','comparison_index','local_relative_path','sha256', ...
    'official_archive_path','official_container_path','match_status'};
if height(manifest) ~= 319 || ~all(ismember(required, manifest.Properties.VariableNames))
    error('run_cec2026_bc_sops:ManifestContract', ...
        'Manifest must contain exactly 319 rows and all required columns.');
end
for a = 1:numel(algNames)
    algorithmRows = find(manifest.algorithm == string(algNames{a}));
    if numel(algorithmRows) ~= 29
        error('run_cec2026_bc_sops:ManifestContract', ...
            'Manifest must contain 29 rows for algorithm=%s.', algNames{a});
    end
    for comparisonIndex = 1:29
        row = algorithmRows(manifest.comparison_index(algorithmRows) == comparisonIndex);
        if numel(row) ~= 1
            error('run_cec2026_bc_sops:ManifestContract', ...
                'Manifest must contain one row for algorithm=%s comparison_index=%d.', ...
                algNames{a}, comparisonIndex);
        end
        expectedRelativePath = strrep(fullfile('data', expectedLocalFile(algNames{a}, comparisonIndex)), '\', '/');
        if ~strcmp(char(manifest.local_relative_path(row)), expectedRelativePath)
            error('run_cec2026_bc_sops:ManifestContract', ...
                'Manifest path mismatch: algorithm=%s comparison_index=%d.', ...
                algNames{a}, comparisonIndex);
        end
    end
end
for i = 1:height(manifest)
    algorithm = char(manifest.algorithm(i));
    comparisonIndex = manifest.comparison_index(i);
    localRelativePath = char(manifest.local_relative_path(i));
    sourcePath = fullfile(rootDir, localRelativePath);
    if ~ismember(algorithm, algNames)
        error('run_cec2026_bc_sops:ManifestContract', ...
            'Manifest algorithm is not in code order: %s.', algorithm);
    end
    if ~isfile(sourcePath)
        error('run_cec2026_bc_sops:ManifestContract', ...
            'Manifest source missing: algorithm=%s comparison_index=%d source=%s.', ...
            algorithm, comparisonIndex, sourcePath);
    end
    if ~strcmpi(char(manifest.match_status(i)), 'exact_sha256_match')
        error('run_cec2026_bc_sops:ManifestContract', ...
            'Manifest status is not exact: algorithm=%s comparison_index=%d source=%s.', ...
            algorithm, comparisonIndex, sourcePath);
    end
    actual = sha256File(sourcePath);
    if ~strcmpi(actual, char(manifest.sha256(i)))
        error('run_cec2026_bc_sops:ManifestHash', ...
            'Manifest hash mismatch: algorithm=%s comparison_index=%d source=%s.', ...
            algorithm, comparisonIndex, sourcePath);
    end
end
end

function fileName = expectedLocalFile(algorithm, comparisonIndex)
stored = comparisonIndex;
if ismember(algorithm, {'mLSHADE_LR','jSOa','ADSDE'}) && comparisonIndex >= 2
    stored = comparisonIndex + 1;
end
switch algorithm
    case 'RDE26', fileName = fullfile('RDE26', sprintf('RDE26_CEC26_SOP_F%d.txt', stored));
    case 'DE-2LS', fileName = fullfile('DE-2LS', sprintf('DE-2LS_D30_F%d.txt', stored));
    case 'RDEx', fileName = fullfile('RDEx', sprintf('RDEx_D30_F%d.txt', stored));
    case 'L-SRTDE', fileName = fullfile('L-SRTDE', sprintf('L-SRTDE_F%d_D30.txt', stored));
    case 'rcmaes', fileName = fullfile('rcmaes', sprintf('cec_pap488_F%d_Min_EV.txt', stored));
    case 'R-CMA-ES', fileName = fullfile('R-CMA-ES', sprintf('R-CMA-ES_F%d_Min_EV.mat', stored));
    case 'mLSHADE_LR', fileName = fullfile('mLSHADE_LR', sprintf('mLSAHDE_LR_F#%d_D#30.mat', stored));
    case 'BlockEA', fileName = fullfile('BlockEA', sprintf('BlockEA_F%d_Min_EV.mat', stored));
    case 'jSOa', fileName = fullfile('jSOa', sprintf('jSOa_D30_S%d.txt', stored));
    case 'IEACOP', fileName = fullfile('IEACOP', sprintf('#1570992402_F%d_Min_EV.mat', stored));
    case 'ADSDE', fileName = fullfile('ADSDE', sprintf('ADSDE_CEC26_SOP_F%d.txt', stored));
    otherwise, error('run_cec2026_bc_sops:UnknownAlgorithm', 'Unknown algorithm %s.', algorithm);
end
end

function block = loadDataBlock(algorithm, dataDir, comparisonIndex)
filePath = fullfile(dataDir, expectedLocalFile(algorithm, comparisonIndex));
switch algorithm
    case {'RDE26','DE-2LS','RDEx','rcmaes','jSOa','ADSDE'}
        block = readmatrix(filePath, 'FileType', 'text');
        if ismember(algorithm, {'rcmaes','ADSDE'})
            if size(block, 2) ~= 25 || ~ismember(size(block,1), [1000 1001])
                error('run_cec2026_bc_sops:DataContract', ...
                    'Data contract failure: algorithm=%s comparison_index=%d source=%s contract=unexpected raw shape.', ...
                    algorithm, comparisonIndex, filePath);
            end
            if size(block,1) == 1001, block = block(1:1000,:); end
        end
    case 'L-SRTDE'
        block = readmatrix(filePath, 'FileType', 'text')';
        if size(block, 2) ~= 25 || ~ismember(size(block,1), [1000 1001])
            error('run_cec2026_bc_sops:DataContract', ...
                'Data contract failure: algorithm=%s comparison_index=%d source=%s contract=unexpected transposed L-SRTDE raw shape.', ...
                algorithm, comparisonIndex, filePath);
        end
        block = block(1:1000,:);
    case 'mLSHADE_LR'
        block = load(filePath, '-ascii');
    case {'R-CMA-ES','BlockEA','IEACOP'}
        S = load(filePath);
        if strcmp(algorithm, 'BlockEA')
            block = S.combinedMatrix;
            if size(block, 2) ~= 25 || ~ismember(size(block,1), [1000 1001])
                error('run_cec2026_bc_sops:DataContract', ...
                    'Data contract failure: algorithm=%s comparison_index=%d source=%s contract=unexpected BlockEA raw shape.', ...
                    algorithm, comparisonIndex, filePath);
            end
            if size(block,1) == 1001, block = block(2:1001,:); end
        elseif strcmp(algorithm, 'IEACOP')
            block = S.Min_EV;
        else
            fields = fieldnames(S); block = S.(fields{1});
        end
    otherwise
        error('run_cec2026_bc_sops:UnknownAlgorithm', 'Unknown algorithm %s.', algorithm);
end
if ismember(algorithm, {'R-CMA-ES','IEACOP'})
    if size(block, 2) ~= 25 || ~ismember(size(block,1), [1000 1001])
        error('run_cec2026_bc_sops:DataContract', ...
            'Data contract failure: algorithm=%s comparison_index=%d source=%s contract=unexpected MAT raw shape.', ...
            algorithm, comparisonIndex, filePath);
    end
    if size(block,1) == 1001, block = block(1:1000,:); end
end
if ~isequal(size(block), [1000 25])
    error('run_cec2026_bc_sops:DataContract', ...
        'Data contract failure: algorithm=%s comparison_index=%d source=%s contract=raw normalized shape must be exactly 1000x25.', ...
        algorithm, comparisonIndex, filePath);
end
end

function fh = makeCachedLoader(cache, algorithmIndex)
fh = @(comparisonIndex) cache{algorithmIndex, comparisonIndex};
end

function hash = sha256File(filePath)
md = java.security.MessageDigest.getInstance('SHA-256');
fid = fopen(filePath, 'r');
if fid < 0, error('run_cec2026_bc_sops:IO', 'Cannot open %s.', filePath); end
cleanup = onCleanup(@() fclose(fid));
bytes = fread(fid, Inf, '*uint8');
digest = md.digest(bytes);
hash = lower(reshape(dec2hex(typecast(digest, 'uint8'))', 1, []));
end
