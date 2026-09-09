# CEC2026-BCSOP

<p align="center">
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">中文</a> |
  <strong>日本語</strong>
</p>

**IEEE WCCI/CEC 2026 精度と速度を考慮した数値最適化コンペティション**の境界制約付き単目的最適化問題（BC-SOPs）部門における、一対比較手法の MATLAB 実装です。

11 アルゴリズムを 29 個の 30 次元問題で比較します。各アルゴリズムにつき 25 試行を用い、各試行から 1000 個の進捗記録点を選択します。

## 使用方法

リポジトリをダウンロードして展開し、MATLAB で `main.m` を開いて **Run（F5）** を押します。既定の許容誤差は `1e-8` です。リポジトリのディレクトリから次のように実行することもできます。

```matlab
main(0)       % 公表済みのコンペティション結果
main(1e-8)    % 絶対許容誤差 1e-8
```

各実行では計算結果を同梱の結果表と照合し、一致を確認した後に対応する CSV ファイルを更新します。問題ごとのスコアと順位は、次のように取得できます。

```matlab
result = main(0);
result.scoreTbl
result.rankTbl
```

MATLAB R2025b Update 4 で動作確認済みです。追加のツールボックスは不要です。

## ファイル

| パス | 内容 |
| --- | --- |
| [`main.m`](main.m) | 実行入口と許容誤差の選択 |
| [`code/`](code/) | 一対比較による採点、データ読み込み、検証 |
| [`data/`](data/) | アルゴリズムの実行結果と出典一覧 |
| [`results/`](results/) | 許容誤差 `0` および `1e-8` の比較結果表 |
| [`report.pdf`](report.pdf) | 集計結果表 |

## 評価方法

自己比較を除き、全試行を一対比較します。精度は最終誤差で評価します。速度は、比較する 2 試行のうち大きい方の最終誤差に初めて到達した記録点で評価します。各指標について、勝者に 1 点、敗者に 0 点を与え、同点の場合は双方に 0.5 点を与えます。

各問題のスコアは精度と速度のスコアの合計です。総合順位は問題ごとの順位の合計に基づき、順位和が小さいほど上位となります。

選択した許容誤差は、誤差のゼロ化、精度の同点判定、速度の閾値、同順位の判定に適用されます。すべて絶対許容誤差です。`1e-8` の場合、`abs(MinEV) < 1e-8` を満たす誤差をゼロとします。`0` の場合、公表済みの比較結果のスコアと順位を再現します。

## データ

読み込み処理は元の比較で使用した 1000 点の選択規則を維持し、[`data/sources.csv`](data/sources.csv) に基づいてソースファイルを検証します。比較問題 19 の L-SRTDE データに含まれる `NaN` 値は `Inf` として扱います。

## 著者

| 著者 | 所属 / 所在地 | 連絡先 |
| --- | --- | --- |
| Sichen Tao | 東北大学、日本 | [taosc73@hotmail.com](mailto:taosc73@hotmail.com); [sichen.tao@tohoku.ac.jp](mailto:sichen.tao@tohoku.ac.jp) |
| Kenneth V. Price | Vacaville、カリフォルニア州、米国 | [pricekenneth459@gmail.com](mailto:pricekenneth459@gmail.com) |
| Ponnuthurai N. Suganthan | カタール大学工学部コンピュータサイエンス・工学科、Doha 2713、カタール | [p.n.suganthan@qu.edu.qa](mailto:p.n.suganthan@qu.edu.qa) |

## 参考資料

- [CEC 2026 コンペティションリポジトリ](https://github.com/P-N-Suganthan/2026-CEC)
- [BC-SOP 比較結果、スライド 19–21](https://github.com/P-N-Suganthan/2026-CEC/blob/f3261207946cff6a64f084fa2450b8351862f192/Comparison%20Slides.pdf)
- [境界制約付き最適化の評価基準](https://github.com/P-N-Suganthan/2026-CEC/blob/main/TR_BoundConst-MOP-SOP.pdf)
