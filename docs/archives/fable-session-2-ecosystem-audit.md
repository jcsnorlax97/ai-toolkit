# Fable 5 Session 2：Personal AI OS 系統級裁決（Audit + Eval 設計 + Doctrine）

status: ready to run
scope: 讀整個 workspace；寫入位置見下方「產出位置」
created: 2026-07-03
note: `ai-ops-ecosystem-spec` 已凍結——本 session 不得寫入該 repo。

## 為什麼值得用 Fable 5

這是弱模型系統性做不到的任務：弱模型天生順從，會樂於繼續幫系統蓋更多層
流程，永遠不會說「這五層裡有兩層在製造摩擦而非價值」。目前生態系的結構
性缺口是：

1. **沒有任何一環在測量系統是否有用。** skillops 的 inventory 有
   `confidence` / `evidence` 欄位，但沒有機制在產生 evidence，
   系統的成長方向由直覺驅動而非證據。
2. **Meta-infrastructure 與實戰產出的比例失衡風險。** workspace 有二十
   幾個 repo，大部分是管理工具的工具，而實戰 testbed
   （carman_church_website）尚未開始。工具鏈不能長得比工作本身快。

殺掉自己心愛的架構需要判斷力和誠實——這是一次性最強智慧的正確用途。

## Session 前準備（不花 Fable 的 token）

- [x] 確認 `ai-toolkit/docs/ROADMAP.md` 是最新的
      （PERSONAL_AI_OS_ROADMAP.md 已標示 superseded，指向它）。
- [x] 列出你「憑感覺」認為最沒有回報的 2-3 個 repo 或流程
      → 填入下方 Prompt 的「前置資訊」區。
- [x] 先設好 permissions，這個 session 需要大量跨 repo 讀取。
- [x] 建議先跑 Session 1（ai-toolkit 升級），讓 audit 看到的是
      修整後的 toolkit，減少誤判。

## 產出位置（因 ecosystem-spec 凍結而調整）

- Audit 報告 → workspace 根目錄新檔 `ecosystem-audit-YYYY-MM.md`
  （根目錄不屬於任何 repo，不違反 Layered Ownership）。
- 各層的具體行動建議 → 各層自己的文件（例如 ai-toolkit 的行動寫進
  `ai-toolkit/docs/ROADMAP.md`）。
- 如果 audit 結論是 ecosystem-spec 該解凍或該由別層接手，
  寫成「給我的建議」，不要直接動那個 repo。

## 開場 Prompt（直接複製貼上）

```
通讀 /Users/jcsnorlax97/Documents/a-ai-codex/ 下的：
- PERSONAL_AI_OS_ROADMAP.md（已 superseded，作歷史背景）
- ai-toolkit/docs/ROADMAP.md（現行優先序）
- ai-ops-ecosystem-spec/（已凍結，只讀不寫）
- skillops/、ai-work-log-bootstrap/、ai-second-brain/ 及各層 CONTEXT.md

你的任務不是幫這個系統長大，而是裁決它。分三階段：

1. 【Audit】對每一層（skills、skillops、work-log、second-brain、
   ecosystem-spec、其餘 repo）回答：它產出的價值是否大於它引入的維護
   成本與認知負擔？給出「保留 / 凍結 / 合併 / 砍掉」建議，附理由。
   特別檢查：
   - meta-infrastructure 與實際產出工作的比例是否健康；
   - 有沒有兩層在做同一件事、或互相等待對方；
   - 「do not do yet」清單裡有沒有其實永遠不該做的項目。
   不要客氣，順從對我沒有價值。先報告，等我確認後才寫檔案。

2. 【Eval 設計】為存活下來的 skills 與 baselines 設計最便宜可行的
   evidence 機制：一個 skill 怎樣算「有效」？如何用現有的 work-log
   capture 回填 skillops inventory 的 confidence/evidence 欄位？
   只設計，不實作——實作之後交給便宜模型。

3. 【Doctrine】寫一頁「何時加流程、何時直接做事」的裁決準則，
   讓未來所有 session 在我想再蓋一層 meta 的時候，能引用它來擋我。

產出位置：
- Audit 報告寫到 workspace 根目錄 ecosystem-audit-YYYY-MM.md。
- 各層的行動建議寫進各層自己的 roadmap/docs（Layered Ownership）。
- 不要寫入 ai-ops-ecosystem-spec（已凍結）；若認為它該解凍，
  寫成建議給我裁決。

約束：
- 這是 read-heavy 的裁決任務，不要動任何 code 或 skill 內容。
- 你不確定的地方明說「不確定」，不要編造。
- 不要刪除任何檔案；「砍掉」是建議，執行由我決定。

前置資訊（開場前由我填入）：
- 我直覺認為回報最低的 repo 或流程：
  - (1) 除了 ai-toolkit、ai-second-brain，以及即將建立的 ai-workbench 之外的所有 repo。
  - (2) personal-diary-capture 和行事曆相關流程感覺應歸屬於 ai-second-brain，考慮合併。
  - (3) 行事曆捕捉幾乎沒用過——主因是手機上難以使用 Claude 或 Codex（摩擦太高）。初步想法：建立 Telegram agent 降低手機端門檻。
  - (4) skillops 不確定是否帶來價值——建立後幾乎沒有回頭查看，evidence 欄位也從未真正填入。
  - (5) 缺乏與私有 Obsidian vault 互動的腳本。概念方向：類似 `A500 Inbox 收件箱/.ai-os-review-dropzone` 的機制，或許能延伸到其他 Obsidian 任務。
  （以上僅為直覺，請獨立驗證，不要直接採信。）
- Session 1（ai-toolkit 升級）：已完成（一次）
- 其他你該知道的近況：ai-ops-ecosystem-spec 於 2026-07-02 凍結
```

## Session 中的操作指引

- 用 **plan mode** 或明確要求「階段 1 先報告、等確認」——
  audit 結論會影響後面兩個階段的範圍。
- 跨 repo 掃描讓它派 **Explore subagent**，主 context 留給裁決推理。
- 如果它的 audit 結論全是「保留」，追問一句：
  「如果你必須砍掉兩層，你砍哪兩層？為什麼？」
  順從的 audit 沒有價值。
- Eval 設計階段守住範圍：只要「最便宜可行」的機制，
  不要讓它設計出又一層需要維護的基礎設施（那正是 audit 要抓的病）。

## 預期交付物與驗收

| 交付物 | 位置 | 驗收方式 |
|---|---|---|
| Audit 報告 | 根目錄 `ecosystem-audit-YYYY-MM.md` | 每層都有明確裁決與理由，至少有非「保留」的結論 |
| Eval 機制設計 | Audit 報告內或獨立章節 | 便宜到可以下週就開始手動執行 |
| Doctrine | 根目錄或 audit 報告附錄（一頁） | 未來 session 可直接引用來擋新流程 |
| 各層行動建議 | 各層自己的 roadmap/docs | 遵守 Layered Ownership |

## 收尾

- 要求交接文件：判斷依據、不放心的地方、給未來弱模型的注意事項。
- Session 結束後用 `capture-assistant-session` 存進 work-log vault。
- 裁決結果（砍/併/凍結）由你手動執行——AI 不做批量刪除。
