---
name: grill-spec
description: 在還沒有具體計畫時盤問需求、術語、邊界與驗收條件，出口是第一個最小 vertical slice。Use when requirements are unclear and no concrete plan exists yet — the user has a goal or feature idea but scope, acceptance checks, or domain terms are still fuzzy. Do NOT use when a concrete plan already exists and needs challenging against documented decisions — use grill-with-docs for that.
---

# Grill Spec

適用前提:還沒有具體計畫。如果已經有一份計畫需要對照 `CONTEXT.md` 與 ADR 挑戰,改用 `/grill-with-docs`。

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
