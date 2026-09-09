CEC2026-BCSOP

MATLAB implementation of the pairwise comparison procedure for the
IEEE WCCI/CEC 2026 Competition on Numerical Optimization Considering
Accuracy and Speed, Bound-Constrained Single-Objective Optimization
Problems (BC-SOPs) track.

The program compares 11 algorithms on 29 problems in 30 dimensions,
using 25 trials per algorithm and 1000 selected progress points per trial.

Authors
-------
Sichen Tao - Tohoku University, Japan
Contact: taosc73@hotmail.com; sichen.tao@tohoku.ac.jp
Kenneth V. Price - Vacaville, CA, USA
Contact: pricekenneth459@gmail.com
Ponnuthurai N. Suganthan - Department of Computer Science and Engineering,
College of Engineering, Qatar University, Doha 2713, Qatar
Contact: p.n.suganthan@qu.edu.qa

Usage
-----
Extract the package, open main.m in MATLAB, and click Run (F5).
The default tolerance is 1e-8. Set defaultTolerance to 0 to reproduce
the published competition results. From the package directory:

    main(0)
    main(1e-8)

Each call verifies the computed table and updates the corresponding CSV.
Per-problem scores are available through result = main(0), in
result.scoreTbl and result.rankTbl.
Tested with MATLAB R2025b Update 4. No additional toolbox is required.

Files
-----
main.m       Entry point and tolerance selection
code/        Pairwise scoring, data loading and validation
data/        Algorithm results and source manifest
results/     Comparison tables for tolerances 0 and 1e-8
report.pdf   Summary tables, typeset separately with LaTeX

Scoring
-------
All trials are compared pairwise, excluding self-comparisons. Accuracy
uses the final error. Speed uses the first recorded point reaching the
worse final error of each pair. Each criterion awards 1 point to the
winner and 0 to the loser, or 0.5 to each trial in a tie.
Problem scores sum accuracy and speed. Overall ranking uses the sum
of problem ranks, with smaller sums ranked first.

The selected tolerance applies to error zeroing, accuracy ties, speed
thresholds and rank ties. Comparisons use absolute tolerances only.
With tolerance 1e-8, errors satisfying abs(MinEV)<1e-8 are set to zero.
With tolerance 0, scores and ranks reproduce the published comparison.

Data
----
The loader preserves the comparison's 1000-point selection. Source files
are validated against data/sources.csv. The L-SRTDE data for comparison
problem 19 contain NaNs, which are treated as Inf.

Reference
---------
CEC 2026 competition results, BC-SOPs, slides 19-21:
https://github.com/P-N-Suganthan/2026-CEC/blob/f3261207946cff6a64f084fa2450b8351862f192/Comparison%20Slides.pdf
