# Fable 5 Session 3：繼承／蒸餾（最後一次 Fable session）

status: blocked — 等 Session 2 完成後才可開跑
scope: 讀 Session 1-2 的全部產出；寫入位置見下方「產出位置」
created: 2026-07-03
note: 這是最後一次使用 Fable 5。目標不是再做一件任務，而是把
Fable 級判斷力封裝成弱模型可用的持久資產。

## 為什麼值得用 Fable 5

Session 1 升級了資產（ai-toolkit），Session 2 裁決了系統（ecosystem
audit + doctrine）。第三步是繼承：把「這兩次 session 為什麼有效」本身
蒸餾出來。這需要 Fable，因為：

1. **蒸餾自己的工作方式需要自我批判。** 弱模型會把兩份 brief 的表面
   結構抄成模板；Fable 能分辨哪些元素真正改變了行為（反順從指令、
   前置資訊的事實/直覺分離），哪些只是儀式。
2. **Doctrine 的措辭品質決定它未來擋不擋得住事。** Session 1 已證明
   Fable 擅長抓「會誤導弱模型的措辭」（baseline 用語修正）；doctrine
   是未來所有 session 的裁決依據，值得用同等強度壓測一次。
3. **這是唯一一次「強模型教你怎麼用弱模型」的機會。** 之後的日常
   session 都由較弱模型執行，繼承指引的品質直接決定日後每次對話的
   上限。

## Session 前準備（不花 Fable 的 token）

- [x] Session 2 已完成：根目錄 `ecosystem-audit-2026-07.md` 與
      doctrine 已落地。**沒有這兩份原料不要開跑。**
- [x] Session 2 已用 `capture-assistant-session` 存進 work-log vault。
- [x] Session 2 的裁決（砍/併/凍結）你已手動執行或明確擱置，
      並知道各項目前狀態 → 填入下方「前置資訊」。
- [x] 回想 Session 1-2 過程：哪些 brief 裡的指令真的改變了模型行為、
      哪些沒用？→ 填入「前置資訊」（事實與直覺分開標示）。
- [x] 先設好 permissions；本 session 讀多寫少，寫入集中在根目錄。

## 產出位置

- Brief 模板 → 根目錄新檔 `high-stakes-session-brief-template.md`
  （根目錄不屬於任何 repo，不違反 Layered Ownership）。
- Doctrine 修訂 → doctrine 所在的原檔案（Session 2 產出，在根目錄或
  audit 報告附錄）。
- 繼承指引 → 根目錄新檔 `weak-model-extraction-guide.md`（一頁）。
- 若發現 toolkit 專屬的問題（例如某 skill 措辭），行動建議寫進
  `ai-toolkit/docs/ROADMAP.md`，不在本 session 內動 skill 本身。
- 不寫入 ai-ops-ecosystem-spec（已凍結）。

## 開場 Prompt（直接複製貼上）

```
這是我最後一次使用 Fable 5。你的任務不是做新工作，而是把前兩次
Fable session 的判斷力蒸餾成弱模型可用的持久資產。

原料（全部通讀）：
- /Users/jcsnorlax97/Documents/a-ai-codex/fable-session-1-ai-toolkit-upgrade.md
- /Users/jcsnorlax97/Documents/a-ai-codex/fable-session-2-ecosystem-audit.md
- ai-toolkit/docs/handoffs/2026-07-03-skill-audit.md（Session 1 交接）
- ecosystem-audit-2026-07.md 與其 doctrine（Session 2 產出）
- work-log vault 中兩次 session 的 capture（如可讀）

任務分三階段：

1. 【蒸餾】分析兩份 brief 與實際 session 產出的對照，回答：
   - 哪些結構元素真正改變了模型行為（例：三階段任務切分、
     前置資訊的事實/直覺分離、反順從指令、plan-mode 紀律、
     交接文件要求）？證據是什麼？
   - 哪些元素只是儀式、可以刪掉？
   然後產出一份可重用的 high-stakes session brief 模板，寫到根目錄
   high-stakes-session-brief-template.md。模板要讓「未來我 + 弱模型」
   能在沒有 Fable 的情況下籌備高風險 session。
   先報告分析，等我確認後才寫模板。

2. 【壓測 doctrine】用至少 5 個未來情境 red-team Session 2 的
   doctrine（例：我想建新 repo 管理某流程、我想幫某工具寫包裝腳本、
   我想引入外部方法論）。找出：
   - 哪些措辭在邊界情況會誤導弱模型（參考你在 Session 1 修
     baseline 措辭的標準）；
   - 哪些情境 doctrine 給不出裁決。
   修訂寫回 doctrine 原檔案，逐條說明改了什麼、為什麼。

3. 【繼承指引】寫一頁 weak-model-extraction-guide.md 到根目錄：
   「如何從弱模型逼出接近強模型的判斷」。收錄經過驗證的 prompt
   模式與各自的使用時機，例如：強制排序裁決、「如果必須砍兩個
   你砍哪兩個」、要求明說不確定、要求交接文件、事實與直覺分離。
   只收你有信心推薦的模式，不要湊數。

約束：
- Layered Ownership：模板與指引放根目錄；toolkit 專屬行動建議寫
  ai-toolkit/docs/ROADMAP.md；不寫入 ai-ops-ecosystem-spec（凍結）；
  lifecycle 資料歸 ../skillops。
- 不蓋新層：交付物是三個檔案與一次 doctrine 修訂，不是新 repo、
  新流程、新工具。如果你發現自己在設計需要維護的東西，停下來，
  引用 doctrine 說明為什麼不做。
- 不動任何 code 或 skill 內容；不刪除任何檔案。
- 你不確定的地方明說「不確定」，不要編造。

前置資訊（開場前由我填入）：
- Session 2 裁決的執行狀態（截至 2026-07-03，全部已確認）：
  - 已執行完成：skillops 凍結＋inventory 分拆（Haiku 執行、Fable 驗收；
    ai-toolkit 4 條、ai-second-brain 5 條）；doctrine 打包為 baseline pack
    並套用到根 CLAUDE.md/AGENTS.md（根 DOCTRINE.md 只是指標）；eval 機制
    ticket 2–6 全部上線（PostToolUse hook、capture `skills_used` 欄位、
    月度 rollup 指南、diary contracts 併入 ai-second-brain、baseline
    日落審查 review_by: 2026-10-01）。
  - 已凍結：ai-ops-ecosystem-spec（維持）、personal-diary-capture、
    second-brain calendar adapter。已砍：second-brain-formulate、
    Parking Lot expiry。ai-workbench Phase 5 自建 orchestration 定為 never。
  - 明確擱置（我已表態 not important、等我發起，不要催辦）：
    obsidian_log_formatter 歸檔、ai-automation-recipes recipe 去向、
    diary entries 搬遷。
  - 尚未到期的：ai-workbench 三次真實使用檢查（2026-07-31）、
    下次 rollup（~2026-08-03）。
- Session 1-2 中真的有用的指令（事實，可採信；因果歸因見各條備註）：
  - 前置資訊的事實/直覺分離確實改變了行為：Session 1 的 usage facts 直接
    決定了哪些 skill 修、哪些淘汰（見交接文件 Judgment basis）；Session 2
    的直覺 (4) skillops 被獨立驗證後「修正」了我的診斷（問題是「只寫不讀」
    而非「沒人填」），直覺 (5) 被證明部分過時（dropzone 已存在，模型沒有
    順著我重建）。分離標示讓模型敢反駁直覺——有兩個實例。
  - 「先報告、等我確認後才動手」兩次都被遵守，裁決逐項經我確認才落地；
    「只設計不實作」（Session 2 eval 階段）產出 6 張 ticket，事後由便宜
    模型全部執行成功——強弱模型分工的切點是有效的。
  - 「不要客氣，順從對我沒有價值」：結果面達標（audit 給出凍結 skillops、
    砍兩項、Phase 5 = never、13:1 比例判定不健康，非全保留），但無對照組，
    這句話本身的因果貢獻不確定——請蒸餾時獨立評估，不要因為結果好就自動
    歸功於它。
  - 交接文件要求產出了含「Not fully verified」清單的 handoff，且該清單
    事後真的被引用（memory、本 brief 都指向它）——寫了有被讀。
  - 預先指定產出位置（Layered Ownership 約束）兩次都被遵守，無跨層寫入。
- 感覺沒用或不確定的元素（直覺，請獨立驗證；此區由助手從產出物缺口
  代填，我未逐條背書）：
  - 「你是我唯一一次使用最高階模型的機會」的開場 framing 是否真的改變
    行為，兩次 capture 都無證據。
  - 「如果必須砍掉兩層你砍哪兩層」追問是否實際用上不確定——Session 2
    的 audit 本來就給了非保留結論，追問可能根本沒觸發。
  - plan mode 紀律與「先報告等確認」哪個在承重無法區分，可能只需其一。
  - Explore subagent 指引是否被使用、是否省下主 context，capture 未記錄。
  - brief 裡的「預期交付物與驗收」表格是模型讀了照做，還是只是我自己的
    checklist？不確定。
```

## Session 中的操作指引

- 用 **plan mode** 開場：階段 1 的分析先報告、確認後才寫模板。
  模板寫錯方向，後面兩階段會跟著歪。
- 跨檔案通讀讓它派 **Explore subagent**，主 context 留給蒸餾推理。
- 階段 1 如果它把 brief 的所有元素都說成「有效」，追問：
  「如果模板只能保留三個元素，你留哪三個？為什麼？」
- 階段 3 守住「一頁」：繼承指引超過一頁就是在蓋新層。
- 這是最後一次 Fable session，**不要**讓它把 token 花在執行瑣事
  （改 code、跑腳本）；發現的執行項全部寫成給弱模型的行動建議。

## 預期交付物與驗收

| 交付物 | 位置 | 驗收方式 |
|---|---|---|
| Brief 模板 | 根目錄 `high-stakes-session-brief-template.md` | 每個模板區塊都附「為什麼存在」的一行理由；有元素被刪掉（全保留＝沒蒸餾） |
| Doctrine 修訂 | doctrine 原檔案 | 逐條列出修改與理由；至少通過 5 個 red-team 情境 |
| 繼承指引 | 根目錄 `weak-model-extraction-guide.md` | 一頁以內；每個模式附使用時機；只收有信心的 |
| Toolkit 行動建議（如有） | `ai-toolkit/docs/ROADMAP.md` | 遵守 Layered Ownership |

## 收尾

- 最後留一段 context 問它：「關於怎麼用好弱模型，有什麼你想說
  但我沒問的？」——這是最後一次機會。
- Session 結束後用 `capture-assistant-session` 存進 work-log vault。
- 三次 session 跑完後，若 brief 模式證明有效，走 `methodology-intake`
  決定是否升格為正式模板/skill——以三次 session 的實際成效為
  evidence，不要憑感覺升格。
