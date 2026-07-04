# Process-vs-Work Doctrine Baseline

Status: active
Version: 0.2.0

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
   本條管 meta 層（管理、記錄或協調其他工作的資產）。新 meta repo 或新
   meta 層必須指名它取代誰；workspace 的 meta repo 淨數不得上升。
   說不出取代誰，就是在堆積。產出型 repo（直接交付成果給人用的專案）
   不在此列，不需要殺誰才能存在。

3. **三次使用前只准最簡形式。**
   任何資產在第三次真實使用前，不得擁有自己的 repo、spec 目錄、
   install script 或 CONTEXT.md。一個檔案就夠的東西給它一個檔案。

4. **只寫不讀即是死。**
   需要持續寫入的紀錄系統（inventory、log、queue）若 60 天內沒有被
   任何決策引用，預設凍結。「記下來以備將來」不是引用；引用是指有一個
   決策因它而不同。點狀決策紀錄（ADR、audit 快照、handoff）寫完即完成，
   閒置是正常狀態，不因此凍結或刪除。

5. **凍結就是凍結。**
   解凍的唯一合法理由是「有一個今天要做的真實任務被它擋住」。
   「它可以更完整」「順便更新一下」不是理由。修正凍結層裡會誤導讀者的
   錯誤（失效指標、過時連結、缺漏的凍結公告）不算解凍，但僅限修正該
   錯誤本身，不得順勢擴充內容。

6. **一個 session 能做完的事，不准先搭鷹架。**
   能直接做完就直接做完。scaffold、模板、自動化（含工具包裝腳本）都要
   等第二次同樣的事出現才有資格存在（見規則 1），而且在第三次真實使用
   前只能是最簡形式——單一檔案，沒有自己的 repo、spec 或 install
   chain（見規則 3）。

7. **Meta 配額。**
   meta session = 工作對象是 AI 工作系統自身（skills、baselines、紀錄、
   流程）的 session。連續 meta session 不得超過 1 個。每個 meta session
   開始前必須寫明它服務的下一個實際產出任務是什麼；寫不出來就去做實際
   任務。執行已裁決的 ticket 與既定例行維護（rollup、verify、re-apply）
   不佔配額——它們不新增層，但也不重置計數。

## 快速判斷表

| 你想做的事 | 問題 | 過關條件 |
|---|---|---|
| 建新 meta repo | 它取代誰？ | 指名被殺的那一層（規則 2）。產出型 repo 不適用本表 |
| 建新 skill | 這個痛出現過幾次？ | ≥2 次，有日期（規則 1） |
| 寫新 spec/contract | 誰會在 60 天內讀它做決策？ | 說得出具體場景（規則 4） |
| 加自動化／包裝腳本 | 同樣的事出現過幾次？ | 第 2 次可寫單一檔案；第 3 次真實使用前不得有 repo/spec/install（規則 6、3） |
| 引入外部方法論 | 評估還是晉升？ | 評估（methodology-intake）隨時可做；晉升成 skill/baseline 需兩次有日期的痛（規則 1） |
| 解凍某層 | 今天哪個任務被擋住？ | 說得出任務名（規則 5）。只修凍結層的誤導性錯誤不算解凍 |
| 開 meta session | 上一個 session 是 meta 嗎？ | 不是；且能指出服務的產出任務（規則 7） |

## Origin

Authored 2026-07-03 as the third output of the ecosystem audit
(`docs/ecosystem-audit-2026-07.md`). 0.2.0 (2026-07-03): operator-ordered
red-team pass clarified rule scope (meta vs product repos, ongoing vs
point-in-time records, frozen-layer error fixes, automation thresholds,
meta-session definition, methodology intake); rule substance unchanged.
The workspace root `a-ai-codex/` has no
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
