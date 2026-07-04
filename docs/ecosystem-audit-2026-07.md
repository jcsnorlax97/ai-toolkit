# Ecosystem Audit 2026-07

date: 2026-07-03
scope: a-ai-codex workspace 全部 ecosystem 層（Session 2 裁決任務）
status: verdicts confirmed by operator on 2026-07-03
canonical: 本檔（synced point-in-time 報告，內容凍結不再修改；workspace 根
另有一份本機工作副本 `../../ecosystem-audit-2026-07.md`）
doctrine: `../baselines/process-vs-work-doctrine/baseline.md`
（本次 audit 的第三項產出，已打包為 portable baseline）

註：本檔是跨層 audit 的歷史快照，不是治理文件。各層的 actionable 決策
已分別寫入各層自己的 roadmap（Layered Ownership）；本檔不隨後續變化更新。

裁決原則：一層的存在必須由「被讀取、被使用、改變過決策」證明，而不是由它自身的完整度證明。

## 證據基礎

獨立驗證（非採信直覺）：

- **Commit 數比例**：meta 層合計約 295 commits（ai-ops-ecosystem-spec 97、
  ai-second-brain 76、ai-toolkit 74、skillops 21、ai-work-log-bootstrap 14、
  ai-workbench 7、ai-automation-recipes 4、personal-diary-capture 2）；
  產出型 repo 約 22 commits（carman_church_website 14、dance-journal-cover-spec 8）。
  約 **13:1**。commit 大小不等，但方向明確。
- **Work-log capture**：vault 內 45 份，集中於 2026-05-19 至 05-30（32 份），
  6 月 7 份、7 月 6 份。內容多數記錄 AI OS 自身建設（meta 記錄 meta）。
- **行事曆**：google-calendar-adapter、OAuth setup script、專用 venv 俱在；
  skillops evidence 只記到一次真實 calendar apply（2026-06-09），之後無使用痕跡。
- **personal-diary-capture**：2 commits、4 份 spec/contract、1 篇真實 entry（2026-05-29）。
- **skillops inventory**：evidence 欄位填得很滿（plan-mixed-capture 一項 11 條），
  但只有 2026-07-03 的 skill audit 一次讀取引用——write-only journal。

## 裁決表

| 層 | 裁決 | 一句話理由 |
|---|---|---|
| ai-toolkit | 保留 | 唯一每天被消費的層；Session 1 剛整修過 |
| ai-second-brain | 保留（收斂範圍） | capture 管線是活的；凍結 calendar adapter 路線 |
| personal-diary-capture | 合併 → ai-second-brain | 1 篇 entry 撐不起一個 repo + 4 份 contract |
| skillops | 裁撤 repo，inventory 分拆回各 canonical repo | 一份 YAML 配了整個 repo 殼；跨層治理違反 Layered Ownership |
| ai-work-log-bootstrap | 維持凍結（已併入 ai-second-brain） | 2026-07-03 已處理完 |
| ai-ops-ecosystem-spec | 維持凍結，**不解凍** | 97 commits 全是治理成本；凍結決定正確 |
| ai-workbench | 保留，附硬性關卡 | Phase 1 CLI 已建但 0 次真實使用；限期驗證 |
| obsidian_log_formatter | 砍掉（建議歸檔，執行由 operator） | 已凍結 repo 的 legacy mirror，雙重遺骸 |
| ai-automation-recipes | 砍掉（recipe 移回 ai_ig_account，執行由 operator） | 1 個 recipe、5/29 後無實質活動 |
| ai_obsidian_2026_migration | 凍結（實質已凍結，標明 read-only） | 歷史遷移參考，零維護成本 |
| PERSONAL_AI_OS_ROADMAP.md | 保留（已標 superseded） | 已正確處理 |
| 其餘 side-project repo | 不在裁決範圍 | 它們是「實際產出」那一側 |

## 各層理由

### skillops（已裁決：分拆 inventory，凍結 repo）

- 價值證據：inventory 在 2026-07-03 skill audit 中被實際引用（retire
  ship-vertical-slice / diagnose-regression 的依據）。記 lifecycle evidence
  的**習慣**有一次真實回報。
- 成本證據：獨立 repo、獨立 CONTEXT/AGENTS/CLAUDE、skill-lifecycle skill
  （含六份支援檔）、兩個 scripts、1215 行 markdown——全部服務一份 424 行 YAML。
- 結構問題：inventory 同時治理 ai-toolkit 與 ai-second-brain 的 skills，
  一個外部 repo 治理兩層資產，違反 Layered Ownership。
- 去向：ai-toolkit 的 skills 記在 `ai-toolkit/docs/skills-inventory.yaml`；
  ai-second-brain 的記在 `ai-second-brain/docs/skills-inventory.yaml`。
  skill-lifecycle skill 隨 repo 凍結退場，其精華濃縮為各 inventory 檔頭的
  簡短 update 規則。分拆執行見下方 ticket。

### ai-second-brain

- capture-assistant-session → deliver-to-inbox → A500 dropzone 這條線是活的，保留。
- 行事曆路線凍結：一次真實使用後閒置近一個月，不刪、不再投資。
  「Telegram agent 降低手機摩擦」降為 candidate issue——修一個沒被證明需要的
  功能之前先建新 agent 是倒因為果。痛點若再真實出現（有日期可指）再解凍。
- 併入 personal-diary-capture：4 份 contract 濃縮成一頁 doc + 一個 template。

### ai-workbench

- Phase 1 exit question 正確但無期限：2026-07 內用於 3 個真實任務，否則凍結。
- 重疊警告：workbench dev-task packet 與 ai-toolkit `setup-agent-team` skill
  都在產 multi-agent execution packet。Phase 2 前必須裁定唯一 owner，
  否則就是下一對 ship-vertical-slice/tdd。

## 特別檢查三項

**1. Meta 比例**：13:1（commits），capture 內容也以 meta 為主。不健康。
已由 `DOCTRINE.md` 的配額規則接手。

**2. 兩層做同一件事 / 互相等待**

- 三套「發生了什麼」的記錄系統並存：work-log captures、skillops evidence、
  B2026 review queue。同一 session 的價值最多被記三次、被讀零次。
  Eval 設計以 work-log capture 為唯一 source，其餘只做彙總目的地。
- workbench packets vs `setup-agent-team`（見上）。
- 互相等待鏈：skills 等 evidence → evidence 等使用 → 使用等摩擦下降。
  真正 blocker 是使用摩擦（尤其手機端），不是缺流程。再加流程解不了這條鏈。

**3. 「Do not do yet」裡其實是 never 的項目**

- ai-workbench Phase 5 自建 thread binding / heartbeat polling：**never**——
  Claude Code subagents/background tasks 與 Codex threads 原生提供；
  單人 operator 自建 orchestration runtime 是純負債。Phase 4 UI 接近 never。
- second-brain 雙向 calendar sync：**never**（單人單向手動已足夠）。
- 自動合併多機 raw logs：**never**。
- `second-brain-formulate` skill：5 月至今一直是 future，兩個月手動使用
  沒有催生它 = 需求不存在，自 roadmap 移除。
- Parking Lot 的 expires_on / defer_count / max_defer_count 與每月
  resurfacing review：為單人隊列設計的官僚流程，從未執行過；
  降級為「Parking Lot 就是一份 note，想到就看」。

## 對開場五條直覺的驗證

1. 「除 toolkit / second-brain / workbench 外回報最低」——**大致成立**；
   但 carman_church_website 是活的產出（不屬 meta），skillops 的 inventory
   內容有一次實際回報（殼沒有）。
2. diary / 行事曆歸屬 second-brain——**成立**。
3. 行事曆幾乎沒用——**成立**（evidence 僅一次 apply）。
4. skillops evidence 從未填入——**不成立**：填得很滿，問題是 write-only。
   裁決依據因此不同：不是「沒人寫」而是「沒人讀」。
5. 缺 Obsidian vault 互動腳本——**部分不成立**：`deliver-to-inbox.py` +
   `promote-outbox-note.py`（2026-07-03, ai-second-brain ADR 0024）已是
   A500 dropzone 機制。缺的是延伸到其他 Obsidian 任務，那是新需求，
   走 candidate issue，不要重建已有的。

## Phase 2 — Eval 設計（只設計；實作交給便宜模型）

**「有效」的定義**：一個 skill 有效 = (a) 在真實任務中被觸發，
且 (b) 觸發時改變了做法或結果（沒有被繞過/對抗）。兩個訊號分開收集：

**訊號 A：客觀使用次數（零人力成本）**

- Claude Code PostToolUse hook 攔 `Skill` 工具呼叫，往 local log
  （如 `~/.claude/skill-usage.log`）append 一行：`date, skill, cwd`。
- Codex 端若無 hook 等價物，退回訊號 B 的自報。

**訊號 B：主觀品質（capture 順手帶）**

- capture-assistant-session 的 capture template frontmatter 加一欄：
  `skills_used: [{name, verdict: helped|neutral|fought, note}]`（可省略）。
- 這是唯一的 capture 側改動；不新增任何流程步驟。

**回填規則（月度或 on-demand，便宜模型執行）**

1. 讀 hook log + 掃當月 inbox captures 的 `skills_used`。
2. 每個 skill 產生一條 `type: usage-rollup` evidence
   （次數、verdict 分佈、代表性 note）。
3. 機械式 confidence 調整：≥3 次 helped → `validated`；
   60 天 0 次觸發 → 標 `stale`（凍結候選）；
   ≥2 次 fought → 標 `review`（deprecate 候選）。
4. 寫入各 canonical repo 的 `docs/skills-inventory.yaml`。

**Baselines 的 evidence**：always-on 規則無法逐次計數，不假裝可以。
改用日落審查：每個 baseline pack 記一個 `review_by` 日期（建議 90 天），
到期時問一題——「過去 90 天內，哪一條真的改變過一次 session 的行為？
舉得出例子的留，舉不出的刪。」

**明確不做**：不建 dashboard、不建 eval framework repo、
除上述機械式 confidence 調整外不做任何自動化。

## 給便宜模型的實作 ticket

每張 ticket 獨立可做，完成一張驗證一張：

1. **inventory 分拆**：把 `skillops/inventory/skills.yaml` 條目按
   `canonical_repo` 分拆到 `ai-toolkit/docs/skills-inventory.yaml` 與
   `ai-second-brain/docs/skills-inventory.yaml`（retired 條目跟著原
   canonical repo 走）；檔頭加簡短 update 規則（何時加 evidence、
   confidence 詞彙、stale/review 規則）。同步修改兩個 repo 的
   CLAUDE.md / AGENTS.md 中指向 `../skillops/inventory/skills.yaml` 的段落。
   驗證：兩份 YAML 條目總數等於原檔、`./scripts/skills-setup/verify.sh` 通過。
2. **skill-usage hook（訊號 A）**：在使用者層 Claude Code 設定加
   PostToolUse hook，把 Skill 呼叫 append 到 `~/.claude/skill-usage.log`。
   驗證：跑一次任意 skill 後 log 多一行。
3. **capture template 加欄（訊號 B）**：ai-second-brain 的
   capture-assistant-session template frontmatter 加選填 `skills_used`。
   驗證：下一次 capture 能帶欄位且舊 capture 不受影響。
4. **usage-rollup prompt/script**：寫一份月度 rollup 的操作說明或腳本
   （讀 log + captures → 更新兩份 inventory）。驗證：對 7 月資料試跑一次。
5. **diary 併入**：personal-diary-capture 的 contract 濃縮為
   ai-second-brain 一頁 doc + template；原 repo README 加凍結指標。
   entries 去向由 operator 決定（不自動搬）。
6. **baseline `review_by`**：ai-toolkit 兩個 baseline pack 各加
   `review_by: 2026-10-01`，並在 baselines 說明檔記日落審查規則。

## 產出物索引

- 本報告 canonical（synced）：`ai-toolkit/docs/ecosystem-audit-2026-07.md`；
  workspace 根另有本機工作副本
- Doctrine：`ai-toolkit/baselines/process-vs-work-doctrine/`（portable
  baseline pack；全文在 `baseline.md`）。短版 managed block 已套用到
  workspace 根 `CLAUDE.md` 與 `AGENTS.md`；其他機器 pull ai-toolkit 後
  以 `baseline.ps1 apply process-vs-work-doctrine` 安裝
- 各層行動：`ai-toolkit/docs/ROADMAP.md`、`ai-second-brain/docs/roadmap.md`、
  `ai-workbench/docs/roadmap.md`、`skillops/README.md`（凍結公告）
- `ai-ops-ecosystem-spec`：未寫入（維持凍結，無解凍建議）
