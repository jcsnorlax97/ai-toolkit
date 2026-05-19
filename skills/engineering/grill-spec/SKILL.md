---
name: grill-spec
description: 釐清需求、術語、邊界與驗收條件，逐題盤問直到工作可被安全拆解。Use when the user wants to plan a feature, stress-test assumptions, clarify domain language, or reduce ambiguity before coding.
---

# Grill Spec

一次只問一個問題，直到以下內容足夠清楚：

- 目標使用者或操作者是誰
- 成功行為是什麼
- 哪些情境在 scope 內，哪些不在
- 驗收要怎麼看出來
- 是否牽涉既有術語、資料模型、外部系統或 irreversible decision

## Rules

- 如果答案可從 codebase 或文件推得，先自行探索，不要先問人。
- 每個問題都附上建議答案或候選方向。
- 發現語言模糊時，提出一個更精確的 canonical term。
- 若新術語被確認，更新 `CONTEXT.md`。
- 若出現重大 trade-off，評估是否值得新增 ADR。

## Exit Criteria

在開始實作前，至少要能明確說出：

1. 要改變的外部行為
2. 驗收方式
3. 第一個最小 vertical slice 是什麼
