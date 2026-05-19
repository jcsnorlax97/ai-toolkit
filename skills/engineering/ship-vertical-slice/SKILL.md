---
name: ship-vertical-slice
description: 用短回饋迴圈交付一個最小可驗證功能切片，強制維持 testable interface 與 incremental delivery。Use when implementing a feature or refactor that should be delivered one behavior at a time.
---

# Ship Vertical Slice

每次只交付一個可驗證行為，不做水平式分工。

## Workflow

1. 先確認 public interface 或使用者可觀察到的行為。
2. 列出要驗證的行為，只先挑第一個。
3. 先建立最小 feedback loop。
4. 寫一個會失敗的測試或其他可重現檢查。
5. 寫最少量的程式碼讓它通過。
6. 視需要整理命名與模組邊界，但不要順手擴大 scope。
7. 再決定下一個 slice，而不是一次把所有測試與實作都鋪開。

## Rules

- 測試行為，不測內部實作細節。
- 若目前沒有好測的 seam，先指出設計問題。
- 新模組應追求小介面、高槓桿。
- 每次收尾都要說明：完成了哪個行為、怎麼驗證、剩下哪個 slice。

## Anti-Patterns

- 先把所有 tests 寫完
- 先把所有 plumbing 寫完
- 先抽很多 helper 再說
- 因為「反正 AI 很快」就一次改整片
