# CEC2026-BCSOP

<p align="center">
  <strong>English</strong> |
  <a href="README.zh-CN.md">中文</a> |
  <a href="README.ja.md">日本語</a>
</p>

MATLAB implementation of the pairwise comparison procedure for the **IEEE WCCI/CEC 2026 Competition on Numerical Optimization Considering Accuracy and Speed**, Bound-Constrained Single-Objective Optimization Problems (BC-SOPs) track.

The comparison covers 11 algorithms, 29 problems in 30 dimensions, 25 trials per algorithm, and 1000 selected progress points per trial.

## Usage

Download and extract the repository, open `main.m` in MATLAB, and click **Run (F5)**. The default tolerance is `1e-8`. From the repository directory:

```matlab
main(0)       % Published competition results
main(1e-8)    % Absolute tolerance of 1e-8
```

Each call verifies the computed table against the supplied results and updates the corresponding CSV after verification. Per-problem scores and ranks are available through:

```matlab
result = main(0);
result.scoreTbl
result.rankTbl
```

Tested with MATLAB R2025b Update 4. No additional toolbox is required.

## Files

| Path | Description |
| --- | --- |
| [`main.m`](main.m) | Entry point and tolerance selection |
| [`code/`](code/) | Pairwise scoring, data loading, and validation |
| [`data/`](data/) | Algorithm results and source manifest |
| [`results/`](results/) | Comparison tables for tolerances `0` and `1e-8` |
| [`report.pdf`](report.pdf) | Summary tables |

## Scoring

All trials are compared pairwise, excluding self-comparisons. Accuracy uses the final error. Speed uses the first recorded point reaching the worse final error of each pair. Each criterion awards 1 point to the winner and 0 to the loser, or 0.5 to each trial in a tie.

Problem scores sum accuracy and speed. Overall ranking uses the sum of problem ranks, with smaller sums ranked first.

The selected tolerance applies to error zeroing, accuracy ties, speed thresholds, and rank ties. All tolerances are absolute. At `1e-8`, errors satisfying `abs(MinEV) < 1e-8` are set to zero. At `0`, scores and ranks reproduce the published comparison.

## Data

The loader preserves the comparison's 1000-point selection. Source files are validated against [`data/sources.csv`](data/sources.csv). The L-SRTDE data for comparison problem 19 contain `NaN` values, which are treated as `Inf`.

## Authors

| Author | Affiliation / Location | Contact |
| --- | --- | --- |
| Sichen Tao | Tohoku University, Japan | [taosc73@hotmail.com](mailto:taosc73@hotmail.com); [sichen.tao@tohoku.ac.jp](mailto:sichen.tao@tohoku.ac.jp) |
| Kenneth V. Price | Vacaville, CA, USA | [pricekenneth459@gmail.com](mailto:pricekenneth459@gmail.com) |
| Ponnuthurai N. Suganthan | Department of Computer Science and Engineering, College of Engineering, Qatar University, Doha 2713, Qatar | [p.n.suganthan@qu.edu.qa](mailto:p.n.suganthan@qu.edu.qa) |

## References

- [CEC 2026 competition repository](https://github.com/P-N-Suganthan/2026-CEC)
- [BC-SOP comparison results, slides 19–21](https://github.com/P-N-Suganthan/2026-CEC/blob/f3261207946cff6a64f084fa2450b8351862f192/Comparison%20Slides.pdf)
- [Bound-constrained optimization evaluation criteria](https://github.com/P-N-Suganthan/2026-CEC/blob/main/TR_BoundConst-MOP-SOP.pdf)
