function validate_data_block(block, algorithm, comparisonIndex, sourcePath, allowKnownNaN)
%VALIDATE_DATA_BLOCK Enforce the CEC 2026 BC-SOP data contract.

if ~isnumeric(block) || ~isequal(size(block), [1000 25])
    dataContractError(algorithm, comparisonIndex, sourcePath, ...
        'shape must be exactly 1000x25');
end

if allowKnownNaN
    if ~all(isnan(block(:)))
        dataContractError(algorithm, comparisonIndex, sourcePath, ...
            'the registered NaN exception must contain exactly 25000 NaNs');
    end
    return;
end

if any(~isfinite(block(:)))
    dataContractError(algorithm, comparisonIndex, sourcePath, ...
        'nonfinite values are not declared for this block');
end
if any(block(:) < 0)
    dataContractError(algorithm, comparisonIndex, sourcePath, ...
        'values must be nonnegative');
end
if any(diff(block, 1, 1) > 0, 'all')
    dataContractError(algorithm, comparisonIndex, sourcePath, ...
        'each trial curve must be monotonically nonincreasing');
end
end

function dataContractError(algorithm, comparisonIndex, sourcePath, contractType)
error('run_cec2026_bc_sops:DataContract', ...
    'Data contract failure: algorithm=%s comparison_index=%d source=%s contract=%s.', ...
    algorithm, comparisonIndex, sourcePath, contractType);
end
