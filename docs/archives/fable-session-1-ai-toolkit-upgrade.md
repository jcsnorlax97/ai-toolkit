# Fable 5 Session 1：ai-toolkit 深度升級

status: ready to run
scope: 只動 `ai-toolkit/`
created: 2026-07-03

## 為什麼值得用 Fable 5

`ai-toolkit` 的 skills 與 baselines 會被套用到未來所有專案、所有 AI
session。讓最強的模型來升級「塑造所有未來 session 的資產」，等於把一次的
智慧攤提到未來每一次對話。弱模型可以執行 skill，但找出 skill 之間的設計
矛盾、以及「哪些措辭會誤導較弱模型」需要頂級判斷力。

## Session 前準備（不花 Fable 的 token）

在開始 session 之前，自己或用便宜模型先完成：

- [x] 確認 `ai-toolkit` 的 git 狀態乾淨（有未提交的變更先處理掉）。
- [x] 跑一次 `./scripts/skills-setup/verify.sh`，確認目前是綠的，
      這樣 session 結束時的驗證結果才有對照基準。
- [x] 先設好 permissions（或跑 `/fewer-permission-prompts`），
      避免中途卡在權限確認、打斷連續推理。
- [x] 想好你自己最不滿意的 2-3 個 skill（如果有）
      → 填入下方 Prompt 的「前置資訊」區。

## 開場 Prompt（直接複製貼上）

```
你是我唯一一次使用最高階模型的機會，所以請把精力放在「持久資產」而非
一次性產出。

背景：這個 repo（ai-toolkit）存放可重用的 AI agent 資產：skills、
baselines、workflow 定義。它們會被套用到我未來所有專案、所有 AI session。

任務分三階段：

1. 【診斷】通讀 CONTEXT.md、skills/、baselines/、docs/ROADMAP.md 與相關
   docs，找出：
   - 哪些 skill 有設計缺陷、互相矛盾、或會誤導較弱的模型；
   - 哪些 baseline 的措辭在邊界情況下會產生錯誤行為；
   - 哪些 skill 的觸發條件（description）太模糊或互相重疊，
     導致模型選錯 skill。
   先報告發現，不要動手改。

2. 【設計】針對最高影響的 3-5 個問題提出修正方案，說明取捨，等我確認。

3. 【落地】實作確認後的修正，並且：
   - 把不可逆的決策寫成 ADR（用 docs/adr/0000-template.md）；
   - 跑 ./scripts/skills-setup/verify.sh 驗證；
   - 保留 mattpocock/skills 匯入內容的 attribution
     （NOTICE.md、docs/upstream-sources.md）；
   - 最後寫一份交接文件到 docs/：你的判斷依據、你不放心的地方、
     以及給未來較弱模型的注意事項。

約束：
- 遵守 repo 的 Layered Ownership baseline：SkillOps 生命週期資料
  （status、confidence、evidence）屬於 ../skillops，不要寫進本 repo。
- Surgical changes：只動任務需要的檔案。
- 你不確定的地方明說「不確定」，不要編造。

前置資訊（開場前由我填入）：
- 實際使用情況（事實，可採信）：
  - 常用且有價值：client-flow-diagrams、improve-codebase-architecture
    （在工作上頻繁使用，但不確定它們是否有時過度繁重/overkill）
  - 從未用過：setup-matt-pocock-skills（當初隨其他 skills 一起
    從外部 repo 拉進來的）
  - 其餘 skills 大多很少或從未使用
- 我的懷疑（直覺，請獨立驗證）：
  - grill-spec 與 grill-with-docs 功能重疊
  - staff-level-review 不確定是否真的有幫助
  - 整體印象：很多 skill 感覺是半成品（half-done）
- verify.sh 目前狀態：綠
```

## Session 中的操作指引

- 用 **plan mode** 開場：階段 1 和 2 都在 plan mode 內完成，
  確認方向後才退出動手。設計錯誤的成本遠高於實作錯誤。
- 需要大範圍掃檔案時讓它派 **Explore subagent**，
  把主 context 留給高價值推理。
- 階段 1 的發現如果超過 5 個，要求它排優先序，只處理最高影響的。
  一個 session 做好 3 件事勝過做壞 10 件事。

## 預期交付物與驗收

| 交付物 | 位置 | 驗收方式 |
|---|---|---|
| 診斷報告 | 對話內（階段 1） | 每個發現都指出具體檔案與具體風險 |
| 修正後的 skills/baselines | `skills/`、`baselines/` | `verify.sh` 綠燈 |
| ADR（如有不可逆決策） | `docs/adr/` | 用了模板、講清楚取捨 |
| 交接文件 | `docs/` | 包含「不放心的地方」清單 |

## 收尾

- 最後留一段 context 讓它寫交接文件——對話會結束，檔案不會。
- Session 結束後用 `capture-assistant-session` 把過程存進 work-log vault。
