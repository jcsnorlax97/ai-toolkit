---
name: diagnose-regression
description: 以 reproduce, minimise, instrument, fix, regression-test 的順序處理 bug 或效能退化。Use when something is broken, flaky, failing, or slower than expected.
---

# Diagnose Regression

這是一個診斷流程，不是猜測流程。

## Workflow

1. Reproduce: 先取得穩定重現步驟或失敗訊號。
2. Minimise: 把案例縮到最小，排除無關因素。
3. Hypothesise: 只列少數可驗證假設。
4. Instrument: 加入 log、assertion、profiling 或更小的實驗來區分假設。
5. Fix: 只改能直接對應根因的地方。
6. Regression-test: 補上能防止復發的檢查。

## Rules

- 沒有重現就不要宣稱已理解問題。
- 不要一次套用多個修正，否則無法知道哪個有用。
- 如果問題來自模組耦合或沒有測試 seam，明確指出這是設計問題，不只是 bug。
- 結案時要交代根因、證據、修正點、回歸保護。
