# CEC2026-BCSOP

<p align="center">
  <a href="README.md">English</a> |
  <strong>中文</strong> |
  <a href="README.ja.md">日本語</a>
</p>

**IEEE WCCI/CEC 2026 兼顾精度与速度的数值优化竞赛**中，边界约束单目标优化问题（BC-SOPs）赛道的成对比较方法 MATLAB 实现。

比较涵盖 11 种算法、29 个 30 维问题，每种算法运行 25 次，每次运行选取 1000 个进展记录点。

## 使用方法

下载并解压仓库，在 MATLAB 中打开 `main.m`，点击 **Run（F5）**。默认容差为 `1e-8`。也可在仓库目录中运行：

```matlab
main(0)       % 已公布的竞赛结果
main(1e-8)    % 绝对容差 1e-8
```

每次运行均将计算表与随附结果核对，通过后更新对应 CSV 文件。各问题的得分与排名可通过以下方式获取：

```matlab
result = main(0);
result.scoreTbl
result.rankTbl
```

已在 MATLAB R2025b Update 4 中测试，无需额外工具箱。

## 文件

| 路径 | 内容 |
| --- | --- |
| [`main.m`](main.m) | 运行入口与容差选择 |
| [`code/`](code/) | 成对评分、数据加载与校验 |
| [`data/`](data/) | 算法结果与来源清单 |
| [`results/`](results/) | 容差为 `0` 和 `1e-8` 的比较结果表 |
| [`report.pdf`](report.pdf) | 汇总结果表 |

## 评分方法

对所有运行进行成对比较，排除自身比较。精度依据最终误差；速度依据首次达到该对运行中较差最终误差的记录点。每项指标的胜者得 1 分，负者得 0 分，平局时各得 0.5 分。

每个问题的得分为精度与速度得分之和。总体排名依据各问题的排名之和，排名和越小，名次越靠前。

所选容差用于误差归零、精度平局、速度阈值和排名平局判定，均为绝对容差。容差为 `1e-8` 时，将满足 `abs(MinEV) < 1e-8` 的误差归零；容差为 `0` 时，得分与排名复现已公布的比较结果。

## 数据

数据加载保留原比较使用的 1000 点选择规则，并依据 [`data/sources.csv`](data/sources.csv) 校验源文件。L-SRTDE 在比较问题 19 中包含的 `NaN` 值按 `Inf` 处理。

## 作者

| 作者 | 所属 / 地点 | 联系方式 |
| --- | --- | --- |
| Sichen Tao | 日本东北大学 | [taosc73@hotmail.com](mailto:taosc73@hotmail.com); [sichen.tao@tohoku.ac.jp](mailto:sichen.tao@tohoku.ac.jp) |
| Kenneth V. Price | 美国加利福尼亚州 Vacaville | [pricekenneth459@gmail.com](mailto:pricekenneth459@gmail.com) |
| Ponnuthurai N. Suganthan | 卡塔尔大学工程学院计算机科学与工程系，Doha 2713，卡塔尔 | [p.n.suganthan@qu.edu.qa](mailto:p.n.suganthan@qu.edu.qa) |

## 参考资料

- [CEC 2026 竞赛仓库](https://github.com/P-N-Suganthan/2026-CEC)
- [BC-SOP 比较结果，第 19–21 页](https://github.com/P-N-Suganthan/2026-CEC/blob/f3261207946cff6a64f084fa2450b8351862f192/Comparison%20Slides.pdf)
- [边界约束优化评估准则](https://github.com/P-N-Suganthan/2026-CEC/blob/main/TR_BoundConst-MOP-SOP.pdf)
