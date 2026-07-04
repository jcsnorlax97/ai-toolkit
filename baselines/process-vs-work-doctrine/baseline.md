# Process-vs-Work Doctrine Baseline

Status: active
Version: 0.1.0

何時加流程、何時直接做事的裁決準則。任何 session 裡想建新 repo、新 skill、
新 spec、新治理層時，先過這一頁；過不了就直接做事。未來 session 可以
（而且應該）引用本準則擋下違規提案。

## 背景一句話

2026-05 至 07 的教訓（見 `docs/ecosystem-audit-2026-07.md`）：meta 層與實際
產出的 commit 比例曾達 13:1，三套記錄系統只寫不讀，一個 repo 殼服務一份
YAML。流程的預設答案是「不要」。

## 七條裁決規則

1. **痛先於流程。**
   同一種失敗發生兩次、且兩次都有日期可指之前，不准建流程、repo、skill
   或 spec。一次的痛用手修，兩次的痛才值得制度化。

2. **加一層必先殺一層。**
   新 repo 或新 meta 層必須指名它取代誰；workspace 的 meta repo 淨數
   不得上升。說不出取代誰，就是在堆積。

3. **三次使用前只准最簡形式。**
   任何資產在第三次真實使用前，不得擁有自己的 repo、spec 目錄、
   install script 或 CONTEXT.md。一個檔案就夠的東西給它一個檔案。

4. **只寫不讀即是死。**
   一份紀錄若 60 天內沒有被任何決策引用，預設凍結。
   「記下來以備將來」不是引用；引用是指有一個決策因它而不同。

5. **凍結就是凍結。**
   解凍的唯一合法理由是「有一個今天要做的真實任務被它擋住」。
   「它可以更完整」「順便更新一下」不是理由。

6. **一個 session 能做完的事，不准先搭鷹架。**
   能直接做完就直接做完。scaffold、模板、自動化都要等第二次
   同樣的事出現才有資格存在（見規則 1）。

7. **Meta 配額。**
   連續 meta session 不得超過 1 個。每個 meta session 開始前必須
   寫明它服務的下一個實際產出任務是什麼；寫不出來就去做實際任務。

## 快速判斷表

| 你想做的事 | 問題 | 過關條件 |
|---|---|---|
| 建新 repo | 它取代誰？ | 指名被殺的那一層（規則 2） |
| 建新 skill | 這個痛出現過幾次？ | ≥2 次，有日期（規則 1） |
| 寫新 spec/contract | 誰會在 60 天內讀它做決策？ | 說得出具體場景（規則 4） |
| 加自動化 | 手動做過幾次？ | ≥3 次（規則 3、6） |
| 解凍某層 | 今天哪個任務被擋住？ | 說得出任務名（規則 5） |
| 開 meta session | 上一個 session 是 meta 嗎？ | 不是；且能指出服務的產出任務（規則 7） |

## Origin

Authored 2026-07-03 as the third output of the ecosystem audit
(`docs/ecosystem-audit-2026-07.md`). The workspace root `a-ai-codex/` has no
remote, so the doctrine is packaged here as a portable baseline: machines
pull this repo and run `./scripts/baseline apply process-vs-work-doctrine`
against the workspace root to install the managed block into its
instruction files.

## 本準則自身的約束

- 本檔一頁為限，不長大、不加子文件、不變成第三個治理層。
- 修訂條件同規則 1：某條規則造成兩次有日期可指的錯誤裁決才改。

## Managed Block

The pack applies one managed block per instruction file through the standard
baseline CLI. The block is self-contained; this file adds rationale,
provenance, and the quick-reference table.
